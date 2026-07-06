-- Migration: advance_booking_item
-- Phase 5 (Booking Core). Booking-item base-lifecycle transitions (26_state_machines Booking Item Base
-- State Machine): draft->pending->confirmed->in_progress->completed, plus cancelled/no_show, each
-- emitting its mandated event. Reuses the same table-driven transition pattern as app.advance_lead and
-- the shared app.record_event seam (a dedicated per-entity transition RPC, not a generic engine -- the
-- status column and per-transition side effects differ per entity, so an engine is not yet earned).
-- Guarded by UPDATE_BOOKING_ITEM_STATUS via app.authorize (MFA composes). SECURITY INVOKER; RLS backstop.
-- No table/schema change.
--
-- FINANCE GATE (13): the confirmed->in_progress transition begins execution and is the designated
-- integration point for the finance-approval gate (execution blocked until finance approval). Finance
-- behavior is intentionally NOT implemented yet; when the gate is built it guards this transition,
-- keeping Finance Core pluggable without premature complexity here.
create or replace function app.advance_booking_item(
    p_booking_item_id uuid,
    p_to_status text,
    p_reason text default null,
    p_sub_status_code text default null,
    p_cancellation_reason_code text default null
)
returns text
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_item record;
    v_event text;
    v_is_cancel boolean;
    v_is_no_show boolean;
    v_sub_catalog text;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    select bi.id, bi.service_type_code, bi.base_status_code, bi.is_archived
      into v_item
    from public.booking_items bi
    where bi.id = p_booking_item_id and bi.tenant_id = v_tenant;
    if not found then
        raise exception 'booking item is not in your tenant';
    end if;
    if v_item.is_archived then
        raise exception 'booking item is archived';
    end if;

    -- Canonical allowed transitions (26 Booking Item Base State Machine) + mandated event per target.
    select t.ev into v_event
    from (values
        ('draft',       'pending',     'booking_item_pending'),
        ('draft',       'completed',   'booking_item_completed'),
        ('draft',       'cancelled',   'booking_item_cancelled'),
        ('pending',     'confirmed',   'booking_item_confirmed'),
        ('pending',     'cancelled',   'booking_item_cancelled'),
        ('confirmed',   'in_progress', 'booking_item_in_progress'),
        ('confirmed',   'completed',   'booking_item_completed'),
        ('confirmed',   'cancelled',   'booking_item_cancelled'),
        ('confirmed',   'no_show',     'booking_item_no_show_recorded'),
        ('in_progress', 'completed',   'booking_item_completed'),
        ('in_progress', 'cancelled',   'booking_item_cancelled'),
        ('in_progress', 'no_show',     'booking_item_no_show_recorded')
    ) as t(frm, to_s, ev)
    where t.frm = v_item.base_status_code and t.to_s = p_to_status;

    if v_event is null then
        raise exception 'transition not allowed: % -> %', v_item.base_status_code, p_to_status;
    end if;

    perform app.authorize('UPDATE_BOOKING_ITEM_STATUS');

    v_is_cancel := (p_to_status = 'cancelled');
    v_is_no_show := (p_to_status = 'no_show');

    if v_is_cancel then
        if p_cancellation_reason_code is null then
            raise exception 'cancellation requires a cancellation_reason_code';
        end if;
        if not exists (
            select 1 from public.catalog_values
            where catalog_type_code = 'booking_cancellation_reason_code'
              and code = p_cancellation_reason_code
        ) then
            raise exception 'unknown booking_cancellation_reason_code: %', p_cancellation_reason_code;
        end if;
    end if;

    -- Optional service-specific sub-status set alongside the transition (13): only ticket/visa/hotel.
    if p_sub_status_code is not null then
        v_sub_catalog := case v_item.service_type_code
            when 'flight_ticket' then 'ticket_sub_status'
            when 'visa'          then 'visa_sub_status'
            when 'hotel'         then 'hotel_sub_status'
            else null
        end;
        if v_sub_catalog is null then
            raise exception 'service_type % does not support a sub_status', v_item.service_type_code;
        end if;
        if not exists (
            select 1 from public.catalog_values
            where catalog_type_code = v_sub_catalog and code = p_sub_status_code
        ) then
            raise exception 'unknown % value: %', v_sub_catalog, p_sub_status_code;
        end if;
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    update public.booking_items
    set base_status_code = p_to_status,
        sub_status_code = coalesce(p_sub_status_code, sub_status_code),
        cancellation_reason_code = case when v_is_cancel then p_cancellation_reason_code
                                        else cancellation_reason_code end,
        cancelled_at = case when v_is_cancel then now() else cancelled_at end,
        cancelled_by = case when v_is_cancel then v_actor else cancelled_by end,
        no_show_at = case when v_is_no_show then now() else no_show_at end,
        no_show_recorded_by = case when v_is_no_show then v_actor else no_show_recorded_by end,
        completed_at = case when p_to_status = 'completed' then now() else completed_at end,
        updated_at = now()
    where id = p_booking_item_id;

    perform app.record_event(
        v_tenant, v_event, 'booking_item', p_booking_item_id, v_actor,
        v_item.base_status_code, p_to_status, p_reason,
        jsonb_build_object('sub_status_code', p_sub_status_code,
                           'cancellation_reason_code', case when v_is_cancel then p_cancellation_reason_code end),
        case when v_is_cancel or v_is_no_show then 'warning' else 'info' end
    );

    return p_to_status;
end;
$$;
grant execute on function app.advance_booking_item(uuid, text, text, text, text) to authenticated;
