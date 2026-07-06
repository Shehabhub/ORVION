-- Migration: create_booking_item
-- Phase 5 (Booking Core). Creates a booking item on a booking, in the initial base_status 'draft'
-- (26_state_machines Booking Item Base State Machine), and emits booking_item_created. Each item has an
-- independent lifecycle (13_booking_statuses_and_rules) over one shared base lifecycle
-- (draft->pending->confirmed->in_progress->completed) with service-specific sub-status. Guarded by
-- CREATE_BOOKING_ITEM via app.authorize (MFA composes). SECURITY INVOKER; RLS is the backstop.
-- No table/schema change.
--
-- Finance behavior is NOT implemented here: finance_approval_required is recorded as intent only; the
-- finance-approval execution gate (13) is a later Phase-5 capability, so Finance Core can plug in later
-- without premature complexity.
create or replace function app.create_booking_item(
    p_booking_id uuid,
    p_service_type_code text,
    p_currency_code text,
    p_cost_amount numeric default 0,
    p_selling_amount numeric default 0,
    p_commission_rate numeric default null,
    p_supplier_id uuid default null,
    p_sub_status_code text default null,
    p_finance_approval_required boolean default false
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_bk record;
    v_sub_catalog text;
    v_item uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('CREATE_BOOKING_ITEM');

    select id, branch_id, department_id, booking_status_code, is_archived
      into v_bk
    from public.bookings
    where id = p_booking_id and tenant_id = v_tenant;
    if not found then
        raise exception 'booking is not in your tenant';
    end if;
    if v_bk.is_archived or v_bk.booking_status_code in ('completed', 'cancelled') then
        raise exception 'cannot add items to a % booking',
            case when v_bk.is_archived then 'archived' else v_bk.booking_status_code end;
    end if;

    if not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'service_type' and code = p_service_type_code
    ) then
        raise exception 'unknown service_type_code: %', p_service_type_code;
    end if;

    if not exists (select 1 from public.currencies where code = p_currency_code) then
        raise exception 'unknown currency_code: %', p_currency_code;
    end if;

    if p_supplier_id is not null and not exists (
        select 1 from public.suppliers where id = p_supplier_id and tenant_id = v_tenant
    ) then
        raise exception 'supplier is not in your tenant';
    end if;

    -- Service-specific sub-status: only ticket/visa/hotel define a sub-status catalog (13).
    if p_sub_status_code is not null then
        v_sub_catalog := case p_service_type_code
            when 'flight_ticket' then 'ticket_sub_status'
            when 'visa'          then 'visa_sub_status'
            when 'hotel'         then 'hotel_sub_status'
            else null
        end;
        if v_sub_catalog is null then
            raise exception 'service_type % does not support a sub_status', p_service_type_code;
        end if;
        if not exists (
            select 1 from public.catalog_values
            where catalog_type_code = v_sub_catalog and code = p_sub_status_code
        ) then
            raise exception 'unknown % value: %', v_sub_catalog, p_sub_status_code;
        end if;
    end if;

    if p_cost_amount < 0 or p_selling_amount < 0 then
        raise exception 'cost and selling amounts must be non-negative';
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    insert into public.booking_items (
        tenant_id, booking_id, service_type_code, base_status_code, sub_status_code, supplier_id,
        operational_owner_user_id, owner_user_id, owner_department_id, owner_branch_id,
        sales_owner_user_id, sales_owner_department_id, sales_owner_branch_id,
        currency_code, cost_amount, selling_amount, commission_rate,
        finance_approval_required, created_by
    )
    values (
        v_tenant, p_booking_id, p_service_type_code, 'draft', p_sub_status_code, p_supplier_id,
        v_actor, v_actor, v_bk.department_id, v_bk.branch_id,
        v_actor, v_bk.department_id, v_bk.branch_id,
        p_currency_code, p_cost_amount, p_selling_amount, p_commission_rate,
        p_finance_approval_required, v_actor
    )
    returning id into v_item;

    perform app.record_event(
        v_tenant, 'booking_item_created', 'booking_item', v_item, v_actor, null, 'draft', null,
        jsonb_build_object('booking_id', p_booking_id, 'service_type_code', p_service_type_code,
                           'currency_code', p_currency_code)
    );

    return v_item;
end;
$$;
grant execute on function app.create_booking_item(
    uuid, text, text, numeric, numeric, numeric, uuid, text, boolean
) to authenticated;
