-- Migration: request_finance_approval
-- Phase 5 (Booking Core) — Finance Approval Gate, execution-approval slice (ADR-0020), step 1 of 3.
-- app.request_finance_approval(item, reason?) opens a pending finance_execution_approval on a booking
-- item: inserts an approval_requests row (26 Finance Approval State Machine start = 'pending'), marks
-- the item finance_approval_required + finance_approval_status_code='pending', and emits the mandated
-- finance_approval_requested event (27). Guarded by CREATE_BOOKING_ITEM via app.authorize (the booking
-- operator raises approval on an item they already manage; MFA composes) -- ADR-0020 mints no new
-- permission for this slice. SECURITY INVOKER; RLS backstop. No table/schema change.
--
-- Resubmission (26: rejected -> pending) is the same call on an item whose prior approval was rejected;
-- a duplicate is prevented by blocking when a pending finance_execution_approval already exists for the
-- item. finance_approval_status_code is written only with approval_status_code catalog values.
create or replace function app.request_finance_approval(
    p_booking_item_id uuid,
    p_reason text default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_item record;
    v_prev_status text;
    v_request_id uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    -- Load the item joined to its booking, in-tenant.
    select bi.id,
           bi.base_status_code,
           bi.is_archived           as item_archived,
           bi.finance_approval_status_code,
           b.booking_status_code,
           b.is_archived            as booking_archived
      into v_item
    from public.booking_items bi
    join public.bookings b on b.id = bi.booking_id
    where bi.id = p_booking_item_id and bi.tenant_id = v_tenant;
    if not found then
        raise exception 'booking item is not in your tenant';
    end if;

    -- Cannot request approval on a terminal/archived item or booking.
    if v_item.item_archived or v_item.base_status_code in ('cancelled', 'no_show') then
        raise exception 'cannot request finance approval on a cancelled/no_show/archived booking item';
    end if;
    if v_item.booking_archived or v_item.booking_status_code in ('completed', 'cancelled') then
        raise exception 'cannot request finance approval on a completed/cancelled/archived booking';
    end if;

    perform app.authorize('CREATE_BOOKING_ITEM');

    -- One open request at a time (resubmit only after a rejected/cancelled decision).
    if exists (
        select 1 from public.approval_requests
        where booking_item_id = p_booking_item_id
          and approval_type_code = 'finance_execution_approval'
          and approval_status_code = 'pending'
    ) then
        raise exception 'a finance approval request is already pending for this booking item';
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    insert into public.approval_requests (
        tenant_id, approval_type_code, approval_status_code,
        requested_by, related_entity_type, related_entity_id,
        booking_item_id, requested_at, reason
    ) values (
        v_tenant, 'finance_execution_approval', 'pending',
        v_actor, 'booking_item', p_booking_item_id,
        p_booking_item_id, now(), p_reason
    ) returning id into v_request_id;

    v_prev_status := v_item.finance_approval_status_code;

    update public.booking_items
    set finance_approval_required = true,
        finance_approval_status_code = 'pending',
        updated_at = now()
    where id = p_booking_item_id;

    perform app.record_event(
        v_tenant, 'finance_approval_requested', 'booking_item', p_booking_item_id, v_actor,
        v_prev_status, 'pending', p_reason,
        jsonb_build_object('approval_request_id', v_request_id,
                           'approval_type_code', 'finance_execution_approval'),
        'info'
    );

    return v_request_id;
end;
$$;
grant execute on function app.request_finance_approval(uuid, text) to authenticated;
