-- Migration: record_refund
-- Phase 6 (Finance Core). app.record_refund opens a customer refund in 'requested' status (07/14 Finance
-- Lite "Refunds"). A refund starts as a request and only affects the receivable once COMPLETED
-- (app.customer_balance counts completed customer_refund as re-opening what the customer owes); the refund
-- lifecycle (requested -> approved/rejected -> processing -> completed/cancelled) is realised by a separate
-- transition RPC (app.advance_refund), mirroring the invoice create-then-transition pattern. The catalog
-- states (refund_status_code) and reasons (refund_reason_code) are canonical; there is no refund state
-- machine in 26 yet, so the transitions live with app.advance_refund.
--
-- Auth: RECORD_REFUND (owner/ceo/finance_manager, seeded). SECURITY INVOKER; RLS backstop. Emits
-- refund_requested. No table/schema change.
create or replace function app.record_refund(
    p_customer_id uuid,
    p_amount numeric,
    p_currency_code text,
    p_refund_reason_code text,
    p_booking_id uuid default null,
    p_original_payment_id uuid default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_refund_id uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    if p_amount is null or p_amount <= 0 then
        raise exception 'refund amount must be greater than zero';
    end if;
    if not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'refund_reason_code' and code = p_refund_reason_code
    ) then
        raise exception 'unknown refund_reason: %', p_refund_reason_code;
    end if;

    perform 1 from public.customers where id = p_customer_id and tenant_id = v_tenant;
    if not found then
        raise exception 'customer is not in your tenant';
    end if;
    if p_booking_id is not null then
        perform 1 from public.bookings where id = p_booking_id and tenant_id = v_tenant;
        if not found then
            raise exception 'booking is not in your tenant';
        end if;
    end if;
    if p_original_payment_id is not null then
        perform 1 from public.payments where id = p_original_payment_id and tenant_id = v_tenant;
        if not found then
            raise exception 'original payment is not in your tenant';
        end if;
    end if;

    perform app.authorize('RECORD_REFUND');

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    insert into public.refunds (
        tenant_id, payment_direction_code, original_payment_id, customer_id, booking_id,
        refund_reason_code, currency_code, amount, refund_status_code, requested_at, created_by
    ) values (
        v_tenant, 'customer_refund', p_original_payment_id, p_customer_id, p_booking_id,
        p_refund_reason_code, p_currency_code, p_amount, 'requested', now(), v_actor
    ) returning id into v_refund_id;

    perform app.record_event(
        v_tenant, 'refund_requested', 'refund', v_refund_id, v_actor,
        null, 'requested', p_refund_reason_code,
        jsonb_build_object('customer_id', p_customer_id, 'booking_id', p_booking_id,
                           'amount', p_amount, 'currency_code', p_currency_code),
        'info'
    );

    return v_refund_id;
end;
$$;
grant execute on function app.record_refund(uuid, numeric, text, text, uuid, uuid) to authenticated;
