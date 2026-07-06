-- Migration: create_booking
-- Phase 5 (Booking Core) -- first capability. Creates a booking in the initial 'draft' status
-- (26_state_machines Booking State Machine) and emits booking_created. Guarded by CREATE_BOOKING via
-- app.authorize (MFA composes). SECURITY INVOKER; RLS is the backstop. No table/schema change.
--
-- Phase boundary (SPEC-072): when a booking originates from a lead, this RPC CONSUMES the canonical
-- Phase 4->5 handoff contract app.lead_booking_readiness(lead) -- it does NOT re-derive CRM booking
-- eligibility. It requires is_ready and takes the normalized customer/branch/department/title from the
-- contract payload. A booking may also be created directly for an existing customer (no lead), per the
-- schema (bookings.lead_id is nullable, customer_id NOT NULL) and 12's Lead-To-Booking rule.
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
    p_booking_reference text default null
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
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('CREATE_BOOKING');

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
        v_customer   := p_customer_id;
        v_branch     := p_branch_id;
        v_department := p_department_id;
        v_title      := p_title;
        if v_customer is null then
            raise exception 'a customer is required to create a booking';
        end if;
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
        lead_id, customer_id, booking_status_code, title, booking_reference,
        travel_start_date, travel_end_date, destination_country_code, destination_city, created_by
    )
    values (
        v_tenant, v_branch, v_department, v_actor, v_department, v_branch,
        p_lead_id, v_customer, 'draft', v_title, v_ref,
        p_travel_start_date, p_travel_end_date, p_destination_country_code, p_destination_city, v_actor
    )
    returning id into v_booking;

    perform app.record_event(
        v_tenant, 'booking_created', 'booking', v_booking, v_actor, null, 'draft', null,
        jsonb_build_object('lead_id', p_lead_id, 'customer_id', v_customer, 'booking_reference', v_ref)
    );

    return v_booking;
end;
$$;
grant execute on function app.create_booking(
    uuid, uuid, text, uuid, uuid, date, date, text, text, text
) to authenticated;
