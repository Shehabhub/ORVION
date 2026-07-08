-- Migration: advance_refund
-- Phase 6 (Finance Core). app.advance_refund drives a refund through its lifecycle. The states are
-- canonical (refund_status_code: requested/approved/rejected/processing/completed/cancelled); there is no
-- refund state machine in 26, so the allowed transitions are realised here (same approach as
-- app.advance_booking): the natural refund flow requested -> approved -> processing -> completed, with
-- rejected/cancelled off-ramps. On COMPLETED the refund sets completed_at and becomes the value
-- app.customer_balance reads (a completed customer_refund re-opens what the customer owes).
--
-- Auth: RECORD_REFUND (owner/ceo/finance_manager) for every transition -- finance owns the refund
-- lifecycle; if approve authority must later diverge from record authority, mint a permission then
-- (Earn-It). SECURITY INVOKER; RLS backstop. Emits refund_approved/rejected/processing/completed/cancelled.
create or replace function app.advance_refund(
    p_refund_id uuid,
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
    v_rf record;
    v_event text;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    select id, refund_status_code, customer_id, amount, currency_code
      into v_rf
    from public.refunds
    where id = p_refund_id and tenant_id = v_tenant;
    if not found then
        raise exception 'refund is not in your tenant';
    end if;

    select t.ev into v_event
    from (values
        ('requested',  'approved',   'refund_approved'),
        ('requested',  'rejected',   'refund_rejected'),
        ('requested',  'cancelled',  'refund_cancelled'),
        ('approved',   'processing', 'refund_processing'),
        ('approved',   'completed',  'refund_completed'),
        ('approved',   'cancelled',  'refund_cancelled'),
        ('processing', 'completed',  'refund_completed'),
        ('processing', 'cancelled',  'refund_cancelled')
    ) as t(frm, to_s, ev)
    where t.frm = v_rf.refund_status_code and t.to_s = p_to_status;

    if v_event is null then
        raise exception 'refund transition not allowed: % -> %', v_rf.refund_status_code, p_to_status;
    end if;

    perform app.authorize('RECORD_REFUND');

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    update public.refunds
    set refund_status_code = p_to_status,
        completed_at = case when p_to_status = 'completed' then now() else completed_at end,
        updated_at = now()
    where id = p_refund_id;

    perform app.record_event(
        v_tenant, v_event, 'refund', p_refund_id, v_actor,
        v_rf.refund_status_code, p_to_status, p_reason,
        jsonb_build_object('customer_id', v_rf.customer_id, 'amount', v_rf.amount,
                           'currency_code', v_rf.currency_code),
        case when p_to_status = 'completed' then 'warning' else 'info' end
    );

    return p_to_status;
end;
$$;
grant execute on function app.advance_refund(uuid, text, text) to authenticated;
