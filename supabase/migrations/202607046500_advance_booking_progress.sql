-- Migration: advance_booking_progress
-- Phase 6 (Finance Core). Booking-level lifecycle -- ADR-0020 capability set, slice 2 (Progress):
--   confirmed   -> in_progress   (booking_in_progress)  "Operations started"
--   in_progress -> completed     (booking_completed)    non-ticket booking completed
-- Both are booking-operator workflow with NO distinct capability in the ADR-0020 model
-- (Submit/Approve/Issue/Cancel/Refund/Reissue), so they reuse the existing CREATE_BOOKING authority --
-- exactly as the pre-finance slice does for submit/cancel -- minting NO new permission (Earn-It/ADR-0015).
-- The item-level finance execution gate (ADR-0020) lives on the booking ITEM's confirmed->in_progress
-- edge (app.advance_booking_item), NOT on this booking-header summary transition; booking Progress stays
-- service-agnostic (booking-orchestration-boundary) and publishes canonical events for future domains.
--
-- create-or-replace of app.advance_booking (applied migrations are immutable): the ONLY changes vs
-- 202607046400 are (a) the two new transition rows, (b) setting completed_at on a completed transition,
-- and (c) removing 'in_progress'/'completed' from the deferred-contract in-list. All else unchanged.
create or replace function app.advance_booking(
    p_booking_id uuid,
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
    v_bk record;
    v_event text;
    v_perm text;
    v_is_cancel boolean;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    select id, booking_status_code, customer_id, lead_id, booking_reference, is_archived
      into v_bk
    from public.bookings
    where id = p_booking_id and tenant_id = v_tenant;
    if not found then
        raise exception 'booking is not in your tenant';
    end if;
    if v_bk.is_archived then
        raise exception 'booking is archived';
    end if;

    -- Canonical allowed transitions (26 Booking State Machine) with per-transition authority + event.
    select t.ev, t.perm into v_event, v_perm
    from (values
        ('draft',            'pending_approval', 'booking_submitted_for_approval', 'CREATE_BOOKING'),
        ('draft',            'cancelled',        'booking_cancelled',              'CREATE_BOOKING'),
        ('pending_approval', 'cancelled',        'booking_cancelled',              'CREATE_BOOKING'),
        ('pending_approval', 'confirmed',        'booking_confirmed',              'APPROVE_BOOKING'),
        ('confirmed',        'in_progress',      'booking_in_progress',            'CREATE_BOOKING'),
        ('in_progress',      'completed',        'booking_completed',              'CREATE_BOOKING')
    ) as t(frm, to_s, ev, perm)
    where t.frm = v_bk.booking_status_code and t.to_s = p_to_status;

    if v_event is null then
        -- Distinguish "not yet implemented (later finance/lifecycle slice)" from "never allowed".
        if p_to_status in ('issued', 'void', 'refunded', 'reissue') then
            raise exception 'transition % -> % arrives with a later booking-lifecycle slice',
                v_bk.booking_status_code, p_to_status;
        end if;
        raise exception 'transition not allowed: % -> %', v_bk.booking_status_code, p_to_status;
    end if;

    perform app.authorize(v_perm);

    v_is_cancel := (p_to_status = 'cancelled');

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    update public.bookings
    set booking_status_code = p_to_status,
        cancelled_at = case when v_is_cancel then now() else cancelled_at end,
        completed_at = case when p_to_status = 'completed' then now() else completed_at end,
        updated_at = now()
    where id = p_booking_id;

    -- Publish the canonical booking event (orchestration boundary). Payload carries the business keys
    -- future domains need to react without re-querying.
    perform app.record_event(
        v_tenant, v_event, 'booking', p_booking_id, v_actor,
        v_bk.booking_status_code, p_to_status, p_reason,
        jsonb_build_object('customer_id', v_bk.customer_id, 'lead_id', v_bk.lead_id,
                           'booking_reference', v_bk.booking_reference),
        case when v_is_cancel then 'warning' else 'info' end
    );

    return p_to_status;
end;
$$;
grant execute on function app.advance_booking(uuid, text, text) to authenticated;
