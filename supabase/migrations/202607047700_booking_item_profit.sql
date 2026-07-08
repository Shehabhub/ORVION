-- Migration: booking_item_profit
-- Phase 6 (Finance Core). app.booking_item_profit is the derived, read-only definition of profit per
-- booking item (07/14 Finance Lite "Profit per booking item"): profit = selling_amount - cost_amount, per
-- item, in the item's currency. Derived live from booking_items (never stored), so it cannot drift.
-- Cancelled/no_show/archived items are excluded (no profit). Null selling/cost are treated as 0; profit is
-- PROJECTED until cost is locked (cost_locked_at) and REALISED once locked -- cost_locked_at is returned so
-- the consumer can distinguish. Optional p_booking_id / p_booking_item_id narrow the result.
--
-- Read-only: no writes, no events. STABLE, SECURITY INVOKER; RLS on booking_items is the only access gate,
-- following the read-RPC precedent (app.customer_balance / app.supplier_balance -- no app.authorize on a
-- pure read; finer cost/margin visibility, if ever needed, is an RLS decision on booking_items). No
-- table/schema change.
create or replace function app.booking_item_profit(
    p_booking_id uuid default null,
    p_booking_item_id uuid default null
)
returns table (
    booking_item_id uuid,
    booking_id uuid,
    currency_code text,
    selling_amount numeric,
    cost_amount numeric,
    profit numeric,
    cost_locked boolean
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

    return query
    select
        bi.id,
        bi.booking_id,
        bi.currency_code,
        coalesce(bi.selling_amount, 0) as selling_amount,
        coalesce(bi.cost_amount, 0) as cost_amount,
        coalesce(bi.selling_amount, 0) - coalesce(bi.cost_amount, 0) as profit,
        (bi.cost_locked_at is not null) as cost_locked
    from public.booking_items bi
    where bi.tenant_id = v_tenant
      and bi.is_archived = false
      and bi.base_status_code not in ('cancelled', 'no_show')
      and (p_booking_id is null or bi.booking_id = p_booking_id)
      and (p_booking_item_id is null or bi.id = p_booking_item_id)
    order by bi.booking_id, bi.id;
end;
$$;
grant execute on function app.booking_item_profit(uuid, uuid) to authenticated;
