-- Migration: advance_booking_issue
-- Phase 6 (Finance Core). Booking-level lifecycle -- ADR-0020 capability set, slice 3 (Issue):
--   in_progress -> issued      (booking_issued)     "One or more issuable items issued"
--   issued      -> completed   (booking_completed)  all required services completed
-- Issue is finance-consequential, so it mints ISSUE_BOOKING (owner/ceo/branch_manager/finance_manager --
-- the finance-consequential precedent, mirroring ALLOW_ISSUE_WITH_NEGATIVE_BALANCE grants). issued ->
-- completed is booking-operator workflow (no distinct capability) and reuses CREATE_BOOKING, as the other
-- completions do (SPEC-094). reissue -> issued (re-issuance) lands with the Refund/Reissue slice, where
-- the reissue state becomes reachable.
--
-- NEGATIVE-BALANCE RISK FLAG (ADR-0020, deferred until app.customer_balance() existed -- now unblocked):
-- on issuance, the customer's per-currency balance for THIS booking is computed via app.customer_balance
-- (tenant-scoped by RLS -- every ISSUE_BOOKING role reads the tenant's finance rows under the generic
-- tenant_isolation policy, so the snapshot is authoritative). "Issuing before full collection" = any
-- currency with outstanding_balance > 0 (the customer still owes; ADR-0021 sign convention). When that
-- holds, issuance additionally requires ALLOW_ISSUE_WITH_NEGATIVE_BALANCE (28: "issuing before full
-- collection requires explicit permission") and emits the canonical booking_item_risk_flag_created event
-- (severity 'risk') capturing the permission used, the balance snapshot, and the reason (27's Requires).
-- The risk flag is a first-class EVENT, no table (event philosophy). The canonical event code predates the
-- ADR-0020 decision to make issuance booking-level; it is emitted on entity_type='booking' (the entity
-- transitioning to issued and the scope of the customer balance), honouring the event's semantic contract.
-- Booking Core stays service-agnostic: the header transition does not enforce item-level issuance (items
-- issue via sub-status, a separate concern) and publishes canonical events for future domains to react to.
--
-- create-or-replace of app.advance_booking (applied migrations are immutable): changes vs 202607046500 are
-- (a) the two new transition rows, (b) the issuance risk-flag block, and (c) removing 'issued' from the
-- deferred-contract in-list. All other transitions and side effects are unchanged.

insert into permissions (key, name, is_system, is_active)
values ('ISSUE_BOOKING', 'Issue Booking', true, true)
on conflict (key) do nothing;

insert into role_permissions (role_id, permission_id)
select r.id, p.id
from public.permissions p
cross join public.roles r
where p.key = 'ISSUE_BOOKING'
  and r.code in ('owner', 'ceo', 'branch_manager', 'finance_manager')
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
    v_owes boolean;
    v_balance_snapshot jsonb;
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
        ('in_progress',      'completed',        'booking_completed',              'CREATE_BOOKING'),
        ('in_progress',      'issued',           'booking_issued',                 'ISSUE_BOOKING'),
        ('issued',           'completed',        'booking_completed',              'CREATE_BOOKING')
    ) as t(frm, to_s, ev, perm)
    where t.frm = v_bk.booking_status_code and t.to_s = p_to_status;

    if v_event is null then
        -- Distinguish "not yet implemented (later lifecycle slice)" from "never allowed".
        if p_to_status in ('void', 'refunded', 'reissue') then
            raise exception 'transition % -> % arrives with a later booking-lifecycle slice',
                v_bk.booking_status_code, p_to_status;
        end if;
        raise exception 'transition not allowed: % -> %', v_bk.booking_status_code, p_to_status;
    end if;

    perform app.authorize(v_perm);

    -- Negative-balance issuance risk flag (ADR-0020): on issuance, snapshot the customer's per-currency
    -- balance for this booking; if any currency shows the customer still owes (outstanding > 0), issuing
    -- before full collection requires ALLOW_ISSUE_WITH_NEGATIVE_BALANCE.
    if p_to_status = 'issued' then
        select
            coalesce(bool_or(cb.outstanding_balance > 0), false),
            coalesce(jsonb_agg(jsonb_build_object(
                'currency_code', cb.currency_code,
                'outstanding_balance', cb.outstanding_balance) order by cb.currency_code), '[]'::jsonb)
          into v_owes, v_balance_snapshot
        from app.customer_balance(v_bk.customer_id, p_booking_id) cb;

        if v_owes then
            perform app.authorize('ALLOW_ISSUE_WITH_NEGATIVE_BALANCE');
        end if;
    end if;

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

    -- Publish the canonical booking event (orchestration boundary).
    perform app.record_event(
        v_tenant, v_event, 'booking', p_booking_id, v_actor,
        v_bk.booking_status_code, p_to_status, p_reason,
        jsonb_build_object('customer_id', v_bk.customer_id, 'lead_id', v_bk.lead_id,
                           'booking_reference', v_bk.booking_reference),
        case when v_is_cancel then 'warning' else 'info' end
    );

    -- First-class risk flag when issuance happened before full collection (27: severity 'risk';
    -- requires permission used, customer balance snapshot, reason).
    if p_to_status = 'issued' and v_owes then
        perform app.record_event(
            v_tenant, 'booking_item_risk_flag_created', 'booking', p_booking_id, v_actor,
            null, 'issued', p_reason,
            jsonb_build_object('permission_used', 'ALLOW_ISSUE_WITH_NEGATIVE_BALANCE',
                               'customer_id', v_bk.customer_id,
                               'customer_balance_snapshot', v_balance_snapshot),
            'risk'
        );
    end if;

    return p_to_status;
end;
$$;
grant execute on function app.advance_booking(uuid, text, text) to authenticated;
