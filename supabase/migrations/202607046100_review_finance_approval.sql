-- Migration: review_finance_approval
-- Phase 5 (Booking Core) — Finance Approval Gate, execution-approval slice (ADR-0020), step 2 of 3.
-- app.review_finance_approval(request, decision, reason?) resolves a pending finance_execution_approval
-- along the 26 Finance Approval State Machine: pending -> approved | rejected | cancelled. On approve it
-- locks cost (booking_items.cost_locked_at) and opens the execution gate (consumed by step 3's
-- confirmed->in_progress precondition). Emits the mandated finance_approval_approved | _rejected |
-- _cancelled event (27). SECURITY INVOKER; RLS backstop. No table/schema change.
--
-- Authorization is per decision (ADR-0020, capability-driven, minting no new permission): the finance
-- reviewer approves/rejects under APPROVE_FINANCE (owner/ceo/finance_manager; MFA composes); the
-- requester withdraws a not-yet-reviewed request (cancel) under CREATE_BOOKING_ITEM. Only a pending
-- request can be resolved; resubmission (rejected -> pending) is a fresh app.request_finance_approval.
create or replace function app.review_finance_approval(
    p_approval_request_id uuid,
    p_decision text,
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
    v_ar record;
    v_event text;
    v_severity text;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    if p_decision not in ('approved', 'rejected', 'cancelled') then
        raise exception 'decision must be approved, rejected, or cancelled (got %)', p_decision;
    end if;

    select ar.id,
           ar.approval_type_code,
           ar.approval_status_code,
           ar.booking_item_id,
           bi.base_status_code,
           bi.is_archived        as item_archived,
           b.booking_status_code,
           b.is_archived         as booking_archived
      into v_ar
    from public.approval_requests ar
    join public.booking_items bi on bi.id = ar.booking_item_id
    join public.bookings b on b.id = bi.booking_id
    where ar.id = p_approval_request_id and ar.tenant_id = v_tenant;
    if not found then
        raise exception 'finance approval request is not in your tenant';
    end if;

    if v_ar.approval_type_code <> 'finance_execution_approval' then
        raise exception 'this RPC only reviews finance_execution_approval requests';
    end if;
    if v_ar.approval_status_code <> 'pending' then
        raise exception 'only a pending finance approval can be reviewed (is %)', v_ar.approval_status_code;
    end if;

    -- Cannot OPEN the execution gate for a terminal/archived item or booking; rejecting or withdrawing
    -- a stale request is always allowed.
    if p_decision = 'approved'
       and (v_ar.item_archived
            or v_ar.base_status_code in ('cancelled', 'no_show')
            or v_ar.booking_archived
            or v_ar.booking_status_code in ('completed', 'cancelled')) then
        raise exception 'cannot approve finance for a terminal/archived booking item or booking';
    end if;

    -- Per-decision authority (ADR-0020): finance reviews approve/reject; requester withdraws (cancel).
    if p_decision in ('approved', 'rejected') then
        perform app.authorize('APPROVE_FINANCE');
    else
        perform app.authorize('CREATE_BOOKING_ITEM');
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    v_event := case p_decision
        when 'approved'  then 'finance_approval_approved'
        when 'rejected'  then 'finance_approval_rejected'
        when 'cancelled' then 'finance_approval_cancelled'
    end;
    v_severity := case p_decision when 'approved' then 'critical' else 'warning' end;

    update public.approval_requests
    set approval_status_code = p_decision,
        reviewed_by = v_actor,
        reviewed_at = now(),
        rejection_reason = case when p_decision = 'rejected' then p_reason else rejection_reason end
    where id = p_approval_request_id;

    update public.booking_items
    set finance_approval_status_code = p_decision,
        cost_locked_at = case when p_decision = 'approved' then now() else cost_locked_at end,
        updated_at = now()
    where id = v_ar.booking_item_id;

    perform app.record_event(
        v_tenant, v_event, 'booking_item', v_ar.booking_item_id, v_actor,
        'pending', p_decision, p_reason,
        jsonb_build_object('approval_request_id', v_ar.id,
                           'approval_type_code', 'finance_execution_approval'),
        v_severity
    );

    return p_decision;
end;
$$;
grant execute on function app.review_finance_approval(uuid, text, text) to authenticated;
