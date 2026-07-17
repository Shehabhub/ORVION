-- Migration: quotation_workflow (brings the inert Quotations domain to life)
-- Canon: 26 §Quotation State Machine (draft→sent→accepted/rejected/expired/cancelled;
-- rejected/expired→draft revise loop), 28 §CRM (CREATE/SEND/ACCEPT_QUOTATION — already
-- seeded, no mint), 31 §quotations/quotation_items, events 27 (quotation_* all registered).
-- Design decisions (Design Challenge, recorded here):
--  * Per-transition authority: draft-side ops (create/add-item/cancel-draft/revise) =
--    CREATE_QUOTATION; send/withdraw/record-expiry = SEND_QUOTATION; recording the
--    customer's decision (accept/reject) = ACCEPT_QUOTATION (canon-28 CLOSE_LEAD pattern).
--  * NO automatic lead transition on send: lead status is app.advance_lead's authority
--    (booking-orchestration-boundary — domains react to events, no hidden coupling).
--    The quotation_sent event is published for any future reactor.
--  * accepted → booking happens via an explicit app.create_booking(p_quotation_id) call
--    (extended below), never automatically. Terminal 'accepted' is not revisable.
--  * quotation_number mirrors the booking_reference pattern: caller-supplied or
--    'QT-YYYYMMDD-XXXXXXXX' fallback; per-tenant uniqueness enforced by migration 048800.
--  * Sending requires >= 1 item (an empty quotation is not a sendable offer).

-- 1. Create a draft quotation.
create or replace function app.create_quotation(
    p_customer_id uuid,
    p_currency_code text,
    p_lead_id uuid default null,
    p_valid_until timestamptz default null,
    p_quotation_number text default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_id uuid;
    v_number text;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('CREATE_QUOTATION');

    if not exists (select 1 from public.customers where id = p_customer_id and tenant_id = v_tenant) then
        raise exception 'customer is not in your tenant';
    end if;
    if not exists (select 1 from public.currencies where code = p_currency_code) then
        raise exception 'unknown currency_code: %', p_currency_code;
    end if;
    if p_lead_id is not null and not exists (
        select 1 from public.leads where id = p_lead_id and tenant_id = v_tenant
    ) then
        raise exception 'lead is not in your tenant';
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    v_number := coalesce(
        p_quotation_number,
        'QT-' || to_char(now(), 'YYYYMMDD') || '-' || upper(left(replace(gen_random_uuid()::text, '-', ''), 8))
    );

    insert into public.quotations (
        tenant_id, lead_id, customer_id, owner_user_id,
        quotation_status_code, quotation_number, currency_code, valid_until, created_by
    ) values (
        v_tenant, p_lead_id, p_customer_id, v_actor,
        'draft', v_number, p_currency_code, p_valid_until, v_actor
    )
    returning id into v_id;

    perform app.record_event(
        v_tenant, 'quotation_created', 'quotation', v_id, v_actor,
        null, 'draft', null,
        jsonb_build_object('quotation_number', v_number, 'customer_id', p_customer_id, 'lead_id', p_lead_id),
        'info'
    );
    return v_id;
end;
$$;
grant execute on function app.create_quotation(uuid, text, uuid, timestamptz, text) to authenticated;

-- 2. Add an item to a draft quotation (recomputes the header total).
create or replace function app.add_quotation_item(
    p_quotation_id uuid,
    p_service_type_code text,
    p_unit_price numeric,
    p_quantity numeric default 1,
    p_description text default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_q record;
    v_item uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('CREATE_QUOTATION');

    select * into v_q from public.quotations
    where id = p_quotation_id and tenant_id = v_tenant
    for update;
    if not found then
        raise exception 'quotation is not in your tenant';
    end if;
    if v_q.quotation_status_code <> 'draft' then
        raise exception 'items can only be added to a draft quotation (status: %)', v_q.quotation_status_code;
    end if;
    if not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'service_type' and code = p_service_type_code
    ) then
        raise exception 'unknown service_type_code: %', p_service_type_code;
    end if;
    if p_unit_price < 0 or p_quantity <= 0 then
        raise exception 'unit_price must be >= 0 and quantity > 0';
    end if;

    insert into public.quotation_items (
        tenant_id, quotation_id, service_type_code, description,
        quantity, unit_price, total_amount, currency_code
    ) values (
        v_tenant, p_quotation_id, p_service_type_code, p_description,
        p_quantity, p_unit_price, p_quantity * p_unit_price, v_q.currency_code
    )
    returning id into v_item;

    update public.quotations
    set total_amount = (select coalesce(sum(total_amount), 0)
                        from public.quotation_items where quotation_id = p_quotation_id)
    where id = p_quotation_id;

    return v_item;
end;
$$;
grant execute on function app.add_quotation_item(uuid, text, numeric, numeric, text) to authenticated;

-- 3. Advance the quotation through the canon-26 state machine.
create or replace function app.advance_quotation(
    p_quotation_id uuid,
    p_to_status text,
    p_reason text default null
)
returns text
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_q record;
    v_perm text;
    v_event text;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    select * into v_q from public.quotations
    where id = p_quotation_id and tenant_id = v_tenant
    for update;
    if not found then
        raise exception 'quotation is not in your tenant';
    end if;

    -- canon-26 transition table: (from, to) -> permission + event
    select perm, evt into v_perm, v_event
    from (values
        ('draft',    'sent',      'SEND_QUOTATION',   'quotation_sent'),
        ('draft',    'cancelled', 'CREATE_QUOTATION', 'quotation_cancelled'),
        ('sent',     'accepted',  'ACCEPT_QUOTATION', 'quotation_accepted'),
        ('sent',     'rejected',  'ACCEPT_QUOTATION', 'quotation_rejected'),
        ('sent',     'expired',   'SEND_QUOTATION',   'quotation_expired'),
        ('sent',     'cancelled', 'SEND_QUOTATION',   'quotation_cancelled'),
        ('rejected', 'draft',     'CREATE_QUOTATION', 'quotation_revised'),
        ('expired',  'draft',     'CREATE_QUOTATION', 'quotation_revised')
    ) as t(f, s, perm, evt)
    where t.f = v_q.quotation_status_code and t.s = p_to_status;
    if v_perm is null then
        raise exception 'transition not allowed: % -> %', v_q.quotation_status_code, p_to_status;
    end if;

    perform app.authorize(v_perm);

    if p_to_status = 'sent' and not exists (
        select 1 from public.quotation_items where quotation_id = p_quotation_id
    ) then
        raise exception 'a quotation needs at least one item before it can be sent';
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    update public.quotations
    set quotation_status_code = p_to_status,
        sent_at     = case when p_to_status = 'sent'     then now() else sent_at end,
        accepted_at = case when p_to_status = 'accepted' then now() else accepted_at end,
        rejected_at = case when p_to_status = 'rejected' then now() else rejected_at end,
        updated_at  = now()
    where id = p_quotation_id;

    perform app.record_event(
        v_tenant, v_event, 'quotation', p_quotation_id, v_actor,
        v_q.quotation_status_code, p_to_status, p_reason,
        jsonb_build_object('quotation_number', v_q.quotation_number,
                           'customer_id', v_q.customer_id, 'lead_id', v_q.lead_id,
                           'total_amount', v_q.total_amount, 'currency_code', v_q.currency_code),
        'info'
    );
    return p_to_status;
end;
$$;
grant execute on function app.advance_quotation(uuid, text, text) to authenticated;

-- 4. Extend create_booking with the accepted-quotation link (SPEC-073 deferred exactly this).
--    Signature changes, so drop the old overload first (no callers exist in-repo; PostgREST
--    clients resolve by name+args at call time).
drop function app.create_booking(uuid, uuid, text, uuid, uuid, date, date, text, text, text);
create or replace function app.create_booking(
    p_customer_id uuid default null,
    p_lead_id uuid default null,
    p_title text default null,
    p_branch_id uuid default null,
    p_department_id uuid default null,
    p_travel_start_date date default null,
    p_travel_end_date date default null,
    p_destination_country_code text default null,
    p_destination_city text default null,
    p_booking_reference text default null,
    p_quotation_id uuid default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_customer uuid;
    v_branch uuid;
    v_department uuid;
    v_title text;
    v_ref text;
    v_booking uuid;
    v_rc record;
    v_quote record;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('CREATE_BOOKING');

    -- ADDITIVE (quotation workflow): an accepted quotation may anchor the booking.
    if p_quotation_id is not null then
        select * into v_quote from public.quotations
        where id = p_quotation_id and tenant_id = v_tenant;
        if not found then
            raise exception 'quotation is not in your tenant';
        end if;
        if v_quote.quotation_status_code <> 'accepted' then
            raise exception 'only an accepted quotation can produce a booking (status: %)',
                v_quote.quotation_status_code;
        end if;
    end if;

    if p_lead_id is not null then
        -- Consume the handoff contract (single source of booking-eligibility). Do not re-derive.
        select * into v_rc from app.lead_booking_readiness(p_lead_id);
        if not v_rc.is_ready then
            raise exception 'lead is not booking-ready: %', v_rc.reason_code;
        end if;
        v_customer   := v_rc.customer_id;
        v_branch     := coalesce(p_branch_id, v_rc.branch_id);
        v_department := coalesce(p_department_id, v_rc.department_id);
        v_title      := coalesce(p_title, v_rc.title);
    else
        -- ADDITIVE: the quotation can supply the customer on the direct path.
        v_customer   := coalesce(p_customer_id,
                                 case when p_quotation_id is not null then v_quote.customer_id end);
        v_branch     := p_branch_id;
        v_department := p_department_id;
        v_title      := p_title;
        if v_customer is null then
            raise exception 'a customer is required to create a booking';
        end if;
    end if;

    -- ADDITIVE: whichever path resolved the customer, it must match the quotation's customer.
    if p_quotation_id is not null and v_customer <> v_quote.customer_id then
        raise exception 'customer does not match the quotation customer';
    end if;

    if v_branch is null or v_department is null then
        raise exception 'branch and department are required';
    end if;
    if v_title is null then
        raise exception 'a booking title is required';
    end if;

    -- Customer, and department-within-branch-within-tenant, must all be in the caller's tenant.
    if not exists (
        select 1 from public.customers where id = v_customer and tenant_id = v_tenant
    ) then
        raise exception 'customer is not in your tenant';
    end if;
    if not exists (
        select 1 from public.departments d
        where d.id = v_department and d.branch_id = v_branch and d.tenant_id = v_tenant
    ) then
        raise exception 'department does not belong to branch in your tenant';
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    -- Human-readable reference (no uniqueness constraint in the schema; make it practically unique).
    v_ref := coalesce(
        p_booking_reference,
        'BK-' || to_char(now(), 'YYYYMMDD') || '-' || upper(left(replace(gen_random_uuid()::text, '-', ''), 8))
    );

    insert into public.bookings (
        tenant_id, branch_id, department_id, owner_user_id, owner_department_id, owner_branch_id,
        lead_id, quotation_id, customer_id, booking_status_code, title, booking_reference,
        travel_start_date, travel_end_date, destination_country_code, destination_city, created_by
    )
    values (
        v_tenant, v_branch, v_department, v_actor, v_department, v_branch,
        p_lead_id, p_quotation_id, v_customer, 'draft', v_title, v_ref,
        p_travel_start_date, p_travel_end_date, p_destination_country_code, p_destination_city, v_actor
    )
    returning id into v_booking;

    perform app.record_event(
        v_tenant, 'booking_created', 'booking', v_booking, v_actor, null, 'draft', null,
        jsonb_build_object('lead_id', p_lead_id, 'customer_id', v_customer,
                           'booking_reference', v_ref, 'quotation_id', p_quotation_id)
    );

    return v_booking;
end;
$$;
grant execute on function app.create_booking(uuid, uuid, text, uuid, uuid, date, date, text, text, text, uuid) to authenticated;
