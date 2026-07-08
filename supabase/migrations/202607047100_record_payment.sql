-- Migration: record_payment
-- Phase 6 (Finance Core). app.record_payment records a customer payment against a single issued invoice
-- and allocates it, driving the invoice status to partially_paid / paid and drawing down the receivable in
-- app.customer_balance (07/14 Finance Lite "Payments"). This is the slice that closes the invoicing loop:
-- create (SPEC-100) -> issue (SPEC-101) -> pay (here).
--
-- Design (Design Challenge outcomes): customer and currency are DERIVED FROM THE INVOICE (no mismatch
-- surface; cross-currency allocation via exchange_rate is a future slice). Only an issued/partially_paid/
-- overdue invoice can be paid (not draft -> must be issued first; not voided/archived/paid). Over-allocation
-- is REJECTED (allocated <= remaining), so status derivation stays exact and overpayment/on-account credit
-- is a clean future slice. Allocation is serialised per invoice with a transaction advisory lock, so
-- concurrent payments cannot double-allocate past the total. Status is derived from the live allocation sum
-- (sum >= total -> paid, else partially_paid) rather than stored incrementally, so it cannot drift.
--
-- Auth: RECORD_PAYMENT (owner/ceo/finance_manager, seeded). SECURITY INVOKER; RLS backstop. Emits
-- payment_recorded, plus the invoice status-transition event (invoice_paid / invoice_partially_paid).
-- Additive: one RPC; no table/schema change.
create or replace function app.record_payment(
    p_invoice_id uuid,
    p_amount numeric,
    p_payment_method_code text,
    p_paid_at timestamptz default now(),
    p_reference_number text default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_inv record;
    v_already numeric;
    v_remaining numeric;
    v_new_total numeric;
    v_new_status text;
    v_payment_id uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    if p_amount is null or p_amount <= 0 then
        raise exception 'payment amount must be greater than zero';
    end if;
    if not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'payment_method' and code = p_payment_method_code
    ) then
        raise exception 'unknown payment_method: %', p_payment_method_code;
    end if;

    select id, customer_id, currency_code, total_amount, status_code, voided_at, is_archived
      into v_inv
    from public.invoices
    where id = p_invoice_id and tenant_id = v_tenant;
    if not found then
        raise exception 'invoice is not in your tenant';
    end if;
    if v_inv.is_archived or v_inv.voided_at is not null then
        raise exception 'invoice is archived or voided';
    end if;
    if v_inv.status_code not in ('issued', 'partially_paid', 'overdue') then
        raise exception 'only an issued/partially_paid/overdue invoice can be paid (is %)', v_inv.status_code;
    end if;

    perform app.authorize('RECORD_PAYMENT');

    -- Serialise allocation for this invoice so concurrent payments cannot over-allocate.
    perform pg_advisory_xact_lock(hashtextextended(p_invoice_id::text, 0));

    select coalesce(sum(pa.allocated_amount), 0) into v_already
    from public.payment_allocations pa
    where pa.invoice_id = p_invoice_id and pa.tenant_id = v_tenant;

    v_remaining := v_inv.total_amount - v_already;
    if p_amount > v_remaining then
        raise exception 'payment % exceeds invoice outstanding % (total %, already allocated %)',
            p_amount, v_remaining, v_inv.total_amount, v_already;
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    insert into public.payments (
        tenant_id, payment_direction_code, customer_id, currency_code,
        payment_method_code, reference_number, amount, paid_at, received_by, created_by
    ) values (
        v_tenant, 'customer_payment', v_inv.customer_id, v_inv.currency_code,
        p_payment_method_code, p_reference_number, p_amount, p_paid_at, v_actor, v_actor
    ) returning id into v_payment_id;

    insert into public.payment_allocations (
        tenant_id, payment_id, invoice_id, allocated_amount, currency_code, created_by
    ) values (
        v_tenant, v_payment_id, p_invoice_id, p_amount, v_inv.currency_code, v_actor
    );

    v_new_total := v_already + p_amount;
    v_new_status := case when v_new_total >= v_inv.total_amount then 'paid' else 'partially_paid' end;

    update public.invoices
    set status_code = v_new_status,
        updated_at = now()
    where id = p_invoice_id;

    perform app.record_event(
        v_tenant, 'payment_recorded', 'payment', v_payment_id, v_actor,
        null, 'customer_payment', p_reference_number,
        jsonb_build_object('invoice_id', p_invoice_id, 'amount', p_amount,
                           'currency_code', v_inv.currency_code, 'invoice_new_status', v_new_status),
        'info'
    );

    -- Invoice status transition event (issued/overdue/partially_paid -> partially_paid|paid).
    perform app.record_event(
        v_tenant,
        case when v_new_status = 'paid' then 'invoice_paid' else 'invoice_partially_paid' end,
        'invoice', p_invoice_id, v_actor,
        v_inv.status_code, v_new_status, null,
        jsonb_build_object('payment_id', v_payment_id, 'allocated_total', v_new_total,
                           'total_amount', v_inv.total_amount),
        'info'
    );

    return v_payment_id;
end;
$$;
grant execute on function app.record_payment(uuid, numeric, text, timestamptz, text) to authenticated;
