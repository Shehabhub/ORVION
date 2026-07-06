-- Migration: advance_booking
-- Phase 5 (Booking Core). Booking-level lifecycle transitions -- OPTION A pre-finance slice: only the
-- booking-domain-owned, finance-free transitions are implemented now:
--   draft -> pending_approval   (booking_submitted_for_approval)
--   draft -> cancelled          (booking_cancelled)
--   pending_approval -> cancelled (booking_cancelled)
-- The finance-entangled transitions (pending_approval->confirmed [approval], confirmed->in_progress
-- [execution], in_progress->issued [issuance], issued->void/refunded/reissue, and the completions that
-- follow) are DEFERRED to land with the finance-approval gate (13), where their capability permissions
-- and behavioral preconditions are defined together.
--
-- ORCHESTRATION BOUNDARY (owner principle): advance_booking owns booking lifecycle decisions and
-- PUBLISHES canonical booking_* events. Future domains (Finance, Documents, Notifications, Reporting,
-- Automation) REACT to those events when their phase arrives -- they are NOT to be added as cross-domain
-- logic inside this function. Booking Core is deliberately service-agnostic: it never encodes
-- service-specific behavior (flight/visa/hotel/etc.), so future service modules plug in via booking_items
-- + events without changing the header lifecycle.
--
-- Authorization: CREATE_BOOKING (the booking owner drives the early lifecycle) via app.authorize. The
-- capability-driven permission model (Submit/Approve/Issue/Cancel/Refund/Reissue Booking) is the
-- recorded recommendation to be introduced as a cohesive set at the finance-gate ADR. SECURITY INVOKER;
-- RLS backstop. No table/schema change.
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

    -- Canonical allowed transitions (26 Booking State Machine) -- pre-finance slice only.
    select t.ev into v_event
    from (values
        ('draft',            'pending_approval', 'booking_submitted_for_approval'),
        ('draft',            'cancelled',        'booking_cancelled'),
        ('pending_approval', 'cancelled',        'booking_cancelled')
    ) as t(frm, to_s, ev)
    where t.frm = v_bk.booking_status_code and t.to_s = p_to_status;

    if v_event is null then
        -- Distinguish "not yet implemented (finance)" from "never allowed" for a clearer contract.
        if p_to_status in ('confirmed', 'in_progress', 'issued', 'void', 'refunded', 'reissue', 'completed') then
            raise exception 'transition % -> % is finance-gated and arrives with the finance-approval gate',
                v_bk.booking_status_code, p_to_status;
        end if;
        raise exception 'transition not allowed: % -> %', v_bk.booking_status_code, p_to_status;
    end if;

    perform app.authorize('CREATE_BOOKING');

    v_is_cancel := (p_to_status = 'cancelled');

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    update public.bookings
    set booking_status_code = p_to_status,
        cancelled_at = case when v_is_cancel then now() else cancelled_at end,
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
