-- Migration: customer_balance
-- Phase 6 (Finance Core) -- first capability. The single authoritative, read-only definition of a
-- customer's outstanding balance ("Customer receivables" / "Outstanding balance", 07/14 Finance Lite).
-- DERIVED, never stored: computed live from invoices, customer payments, and completed customer
-- refunds, so it can never drift from the underlying finance records. Future consumers (outstanding-
-- balance reporting, and the negative-balance issuance risk flag deferred by ADR-0020) must call this
-- function rather than re-deriving the rule. Recorded as ADR-0021.
--
-- Definition (per currency): outstanding = invoiced - paid + refunded, where
--   invoiced  = sum of live customer invoices (status issued/partially_paid/paid/overdue; not voided,
--               not archived) -- draft and voided invoices are not receivables;
--   paid      = sum of customer_payment payments;
--   refunded  = sum of COMPLETED customer_refund refunds (only a completed refund has actually returned
--               cash, re-opening what the customer owes).
-- Positive balance = the customer owes the company; negative = customer credit / overpayment.
--
-- MULTI-CURRENCY: results are grouped BY currency_code and never collapsed across currencies (that would
-- require exchange rates; the canon tracks balances by currency). A customer with activity in one
-- currency returns one row. p_booking_id optionally narrows all three sources to a single booking.
--
-- Read-only: no writes, no events. SECURITY INVOKER; RLS on invoices/payments/refunds is the backstop
-- and the only access gate, following the read-RPC precedent set by app.lead_booking_readiness (no
-- app.authorize() on a pure read). No table/schema change.
create or replace function app.customer_balance(
    p_customer_id uuid,
    p_booking_id uuid default null
)
returns table (
    currency_code text,
    invoiced_amount numeric,
    paid_amount numeric,
    refunded_amount numeric,
    outstanding_balance numeric
)
language plpgsql
stable
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    perform 1 from public.customers
    where id = p_customer_id and tenant_id = v_tenant;
    if not found then
        raise exception 'customer is not in your tenant';
    end if;

    return query
    with contrib as (
        select i.currency_code, i.total_amount as inv, 0::numeric as pay, 0::numeric as ref
        from public.invoices i
        where i.tenant_id = v_tenant
          and i.customer_id = p_customer_id
          and i.status_code in ('issued', 'partially_paid', 'paid', 'overdue')
          and i.voided_at is null
          and i.is_archived = false
          and (p_booking_id is null or i.booking_id = p_booking_id)
        union all
        select p.currency_code, 0::numeric, p.amount, 0::numeric
        from public.payments p
        where p.tenant_id = v_tenant
          and p.customer_id = p_customer_id
          and p.payment_direction_code = 'customer_payment'
          and (p_booking_id is null or p.booking_id = p_booking_id)
        union all
        select r.currency_code, 0::numeric, 0::numeric, r.amount
        from public.refunds r
        where r.tenant_id = v_tenant
          and r.customer_id = p_customer_id
          and r.payment_direction_code = 'customer_refund'
          and r.refund_status_code = 'completed'
          and (p_booking_id is null or r.booking_id = p_booking_id)
    )
    select
        c.currency_code,
        sum(c.inv) as invoiced_amount,
        sum(c.pay) as paid_amount,
        sum(c.ref) as refunded_amount,
        sum(c.inv) - sum(c.pay) + sum(c.ref) as outstanding_balance
    from contrib c
    group by c.currency_code
    order by c.currency_code;
end;
$$;
grant execute on function app.customer_balance(uuid, uuid) to authenticated;
