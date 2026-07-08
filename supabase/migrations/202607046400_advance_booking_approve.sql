-- Migration: advance_booking_approve
-- Phase 6 (Finance Core). Booking-level lifecycle -- ADR-0020 capability set, slice 1 of the deferred
-- booking transitions: pending_approval -> confirmed [Approve]. This is the booking-level MANAGEMENT
-- approval ("Required approval granted", 26 Booking State Machine) -- distinct from the item-level
-- finance execution approval (ADR-0020, app.review_finance_approval), which gates confirmed -> in_progress
-- on the booking ITEM. Booking confirm carries no finance precondition and stays service-agnostic
-- (booking-orchestration-boundary): it publishes booking_confirmed and future domains react.
--
-- Permission (capability-driven, minted by this consuming CR per ADR-0015/0020): APPROVE_BOOKING, granted
-- to owner/ceo/branch_manager/department_manager -- the manager-approval precedent already established in
-- 28 for ASSIGN_LEAD/REASSIGN_LEAD/ESCALATE_CONVERSATION (approval/assignment authority is a management
-- act; senior_employee creates a booking but does not self-approve it). Submit and the early cancels keep
-- their existing CREATE_BOOKING authority; authority is now resolved per transition.
--
-- create-or-replace of app.advance_booking (applied migrations are immutable): the ONLY changes vs
-- 202607045800 are (a) the pending_approval -> confirmed row + its booking_confirmed event, (b) per-
-- transition authority (v_perm) replacing the single CREATE_BOOKING authorize, and (c) removing
-- 'confirmed' from the "finance-gated / not yet implemented" contract message (it is implemented here).
-- All other transitions, the orchestration-boundary event publication, and side effects are unchanged.

-- Mint the capability permission and its manager-approval grants (idempotent).
insert into permissions (key, name, is_system, is_active)
values ('APPROVE_BOOKING', 'Approve Booking', true, true)
on conflict (key) do nothing;

insert into role_permissions (role_id, permission_id)
select r.id, p.id
from public.permissions p
cross join public.roles r
where p.key = 'APPROVE_BOOKING'
  and r.code in ('owner', 'ceo', 'branch_manager', 'department_manager')
on conflict (role_id, permission_id) do nothing;

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
        ('pending_approval', 'confirmed',        'booking_confirmed',              'APPROVE_BOOKING')
    ) as t(frm, to_s, ev, perm)
    where t.frm = v_bk.booking_status_code and t.to_s = p_to_status;

    if v_event is null then
        -- Distinguish "not yet implemented (later finance/lifecycle slice)" from "never allowed".
        if p_to_status in ('in_progress', 'issued', 'void', 'refunded', 'reissue', 'completed') then
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
