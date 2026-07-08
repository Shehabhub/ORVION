-- Migration: create_invoice
-- Phase 6 (Finance Core). First WRITE capability for the finance-transaction layer: app.create_invoice
-- creates a customer invoice in 'draft' (07/14 Finance Lite "Invoices"). Draft is deliberately not yet a
-- receivable -- app.customer_balance counts only issued/partially_paid/paid/overdue -- so issuing
-- (draft -> issued) and payment-driven status changes are separate follow-on slices; this slice is the
-- uncontroversial create act (there is no canonical invoice state machine in 26 to realize yet).
--
-- INVOICE NUMBERING (research-backed): tax authorities require invoice numbers to be UNIQUE and
-- sequential/traceable, but NOT strictly gapless (a gap from a voided invoice is acceptable). Best practice
-- for multi-tenant is a per-tenant, year-prefixed sequence. Numbers are 'INV-YYYY-NNNN', unique PER TENANT
-- (each tenant is a separate company); a partial unique index enforces that in the database (compliance:
-- uniqueness), and generation serialises on a per-(tenant,year) transaction advisory lock then takes
-- max(sequence)+1, so concurrent inserts cannot collide. Not gapless by design (correct per the rule). A
-- per-tenant configurable prefix is a future refinement (no config surface yet -- Earn-It).
--
-- Auth: CREATE_INVOICE (owner/ceo/finance_manager, already seeded). SECURITY INVOKER; RLS is the backstop.
-- Emits invoice_created. Additive: one partial unique index + one RPC; no table/column change.

-- DB-enforced per-tenant uniqueness of the generated number (voided invoices keep their number; the index
-- covers all rows, so a re-used number is impossible even across voids).
create unique index if not exists invoices_tenant_number_key
    on public.invoices (tenant_id, invoice_number);

create or replace function app.create_invoice(
    p_customer_id uuid,
    p_currency_code text,
    p_total_amount numeric,
    p_booking_id uuid default null,
    p_booking_item_id uuid default null,
    p_invoice_date date default current_date,
    p_due_date date default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_year text := to_char(coalesce(p_invoice_date, current_date), 'YYYY');
    v_seq integer;
    v_number text;
    v_invoice_id uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    if p_total_amount is null or p_total_amount <= 0 then
        raise exception 'invoice total_amount must be greater than zero';
    end if;

    -- Referenced entities must be in the caller's tenant (RLS with-check covers the insert; these give a
    -- clear error rather than a policy violation, and validate the optional booking links).
    perform 1 from public.customers where id = p_customer_id and tenant_id = v_tenant;
    if not found then
        raise exception 'customer is not in your tenant';
    end if;
    if p_booking_id is not null then
        perform 1 from public.bookings where id = p_booking_id and tenant_id = v_tenant;
        if not found then
            raise exception 'booking is not in your tenant';
        end if;
    end if;
    if p_booking_item_id is not null then
        perform 1 from public.booking_items where id = p_booking_item_id and tenant_id = v_tenant;
        if not found then
            raise exception 'booking item is not in your tenant';
        end if;
    end if;

    perform app.authorize('CREATE_INVOICE');

    -- Serialise number allocation per (tenant, year); gaps are acceptable, collisions are not.
    perform pg_advisory_xact_lock(hashtextextended(v_tenant::text || ':' || v_year, 0));
    select coalesce(max(split_part(i.invoice_number, '-', 3)::integer), 0) + 1
      into v_seq
    from public.invoices i
    where i.tenant_id = v_tenant
      and i.invoice_number like 'INV-' || v_year || '-%';
    v_number := 'INV-' || v_year || '-' || lpad(v_seq::text, 4, '0');

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    insert into public.invoices (
        tenant_id, customer_id, booking_id, booking_item_id,
        invoice_number, invoice_date, due_date, currency_code,
        total_amount, status_code, created_by
    ) values (
        v_tenant, p_customer_id, p_booking_id, p_booking_item_id,
        v_number, coalesce(p_invoice_date, current_date), p_due_date, p_currency_code,
        p_total_amount, 'draft', v_actor
    ) returning id into v_invoice_id;

    perform app.record_event(
        v_tenant, 'invoice_created', 'invoice', v_invoice_id, v_actor,
        null, 'draft', null,
        jsonb_build_object('invoice_number', v_number, 'customer_id', p_customer_id,
                           'booking_id', p_booking_id, 'currency_code', p_currency_code,
                           'total_amount', p_total_amount),
        'info'
    );

    return v_invoice_id;
end;
$$;
grant execute on function app.create_invoice(uuid, text, numeric, uuid, uuid, date, date) to authenticated;
