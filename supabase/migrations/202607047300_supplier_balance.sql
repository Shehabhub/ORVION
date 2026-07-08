-- Migration: supplier_balance
-- Phase 6 (Finance Core). app.supplier_balance is the derived, read-only, per-currency definition of what
-- ORVION owes an external supplier (07/14 Finance Lite "Supplier payables") -- the payables mirror of
-- app.customer_balance (ADR-0021). There is no supplier-bill/invoice table: a payable is derived live from
-- booking-item cost owed to the supplier, offset by supplier payments, so it can never drift.
--
-- Definition (per currency): outstanding_payable = cost - paid, where
--   cost = sum of booking_items.cost_amount for items assigned to this supplier whose cost is LOCKED
--          (cost_locked_at is not null -- cost is provisional until finance approval locks it, per 14;
--          this parallels customer_balance counting only live/non-draft invoices), excluding cancelled/
--          no_show and archived items (not a payable);
--   paid = sum of payments.amount with payment_direction_code = 'supplier_payment' to this supplier.
-- Positive = ORVION owes the supplier; negative = overpaid/credit. Grouped BY currency_code, never
-- collapsed across currencies (multi-currency is real; collapsing needs exchange rates). p_booking_id
-- optionally narrows both sources to one booking.
--
-- Read-only: no writes, no events. STABLE, SECURITY INVOKER; RLS on booking_items/payments is the only
-- access gate, following the read-RPC precedent (app.customer_balance / app.lead_booking_readiness -- no
-- app.authorize on a pure read). No table/schema change.
create or replace function app.supplier_balance(
    p_supplier_id uuid,
    p_booking_id uuid default null
)
returns table (
    currency_code text,
    cost_amount numeric,
    paid_amount numeric,
    outstanding_payable numeric
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

    perform 1 from public.suppliers
    where id = p_supplier_id and tenant_id = v_tenant;
    if not found then
        raise exception 'supplier is not in your tenant';
    end if;

    return query
    with contrib as (
        select bi.currency_code, bi.cost_amount as cost, 0::numeric as paid
        from public.booking_items bi
        where bi.tenant_id = v_tenant
          and bi.supplier_id = p_supplier_id
          and bi.cost_locked_at is not null
          and bi.is_archived = false
          and bi.base_status_code not in ('cancelled', 'no_show')
          and bi.cost_amount is not null
          and (p_booking_id is null or bi.booking_id = p_booking_id)
        union all
        select p.currency_code, 0::numeric, p.amount
        from public.payments p
        where p.tenant_id = v_tenant
          and p.supplier_id = p_supplier_id
          and p.payment_direction_code = 'supplier_payment'
          and (p_booking_id is null or p.booking_id = p_booking_id)
    )
    select
        c.currency_code,
        sum(c.cost) as cost_amount,
        sum(c.paid) as paid_amount,
        sum(c.cost) - sum(c.paid) as outstanding_payable
    from contrib c
    group by c.currency_code
    order by c.currency_code;
end;
$$;
grant execute on function app.supplier_balance(uuid, uuid) to authenticated;
