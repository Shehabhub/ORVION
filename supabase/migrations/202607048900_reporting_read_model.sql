-- Migration: reporting_read_model (Phase 9 / RC-4 first slice)
-- Implements ADR-0022 Tier A: a dedicated `reporting` schema of live `security_invoker` views
-- over the transactional tables + the four built read primitives. security_invoker (PG15+) makes
-- each view run with the caller's permissions, so base-table RLS is enforced automatically —
-- tenant isolation is inherited, no policy on the view (and none is possible). Presentation is
-- PER-CURRENCY (ADR-0022 default; single-currency is a later additive FX slice). Tier B aggregate
-- tables + pg_cron are added later only where a report's measured cost earns it.
-- NOTE (performance, Tier A): customer/supplier outstanding lateral-join a per-entity primitive
-- (one function call per entity). Correct and cheap at current volumes; promote to a Tier B
-- aggregate table if a tenant's entity count makes it measurably slow (ADR-0022 §refresh).

create schema if not exists reporting;
grant usage on schema reporting to authenticated;

-- 1. Profit by booking item — lateral over booking_items so the profit SSOT (app.booking_item_profit,
--    which requires an active tenant) is gated behind RLS-scoped rows: no rows -> not called ->
--    graceful, exactly like the balance views below. Reuses the SSOT (One Authority), never re-derives.
create view reporting.booking_item_profit with (security_invoker = true) as
select bip.booking_item_id, bip.booking_id, bip.currency_code,
       bip.selling_amount, bip.cost_amount, bip.profit, bip.cost_locked
from public.booking_items bi
cross join lateral app.booking_item_profit(null, bi.id) bip;

-- 2. Finance — customer outstanding balances (per customer, per currency).
create view reporting.customer_outstanding with (security_invoker = true) as
select c.tenant_id, c.id as customer_id, c.full_name,
       cb.currency_code, cb.invoiced_amount, cb.paid_amount, cb.refunded_amount, cb.outstanding_balance
from public.customers c
cross join lateral app.customer_balance(c.id) cb
where not c.is_archived;

-- 3. Finance — supplier outstanding payables (per supplier, per currency).
create view reporting.supplier_outstanding with (security_invoker = true) as
select s.tenant_id, s.id as supplier_id, s.name as supplier_name,
       sb.currency_code, sb.cost_amount, sb.paid_amount, sb.outstanding_payable
from public.suppliers s
cross join lateral app.supplier_balance(s.id) sb
where not s.is_archived;

-- 4. Lead performance — counts + expected value by status/source/owner/service.
create view reporting.lead_performance with (security_invoker = true) as
select tenant_id, lead_status_code, lead_source_code, owner_user_id, requested_service_type_code,
       count(*) as lead_count, coalesce(sum(expected_value), 0) as expected_value_total
from public.leads
group by tenant_id, lead_status_code, lead_source_code, owner_user_id, requested_service_type_code;

-- 5. Booking pipeline — booking counts by status/owner/branch.
create view reporting.booking_pipeline with (security_invoker = true) as
select tenant_id, booking_status_code, owner_user_id, branch_id, count(*) as booking_count
from public.bookings
where not is_archived
group by tenant_id, booking_status_code, owner_user_id, branch_id;

-- 6. Sales activity — bookings created by owner/branch/day. (Definition = bookings created: a
--    defensible default; the exact "sales activity" measure is a reporting-philosophy call the
--    owner may refine — see the manifest's open reporting-philosophy note.)
create view reporting.sales_activity with (security_invoker = true) as
select tenant_id, owner_user_id, branch_id, created_at::date as activity_date,
       count(*) as bookings_created
from public.bookings
where not is_archived
group by tenant_id, owner_user_id, branch_id, created_at::date;

-- 7. Subscription state — current tenant subscription with its plan.
create view reporting.subscription_state with (security_invoker = true) as
select s.tenant_id, s.id as subscription_id, s.subscription_plan_id,
       p.plan_code, p.name as plan_name, s.subscription_status_code,
       s.starts_at, s.ends_at, s.grace_ends_at, s.read_only_started_at
from public.subscriptions s
join public.subscription_plans p on p.id = s.subscription_plan_id;

grant select on
    reporting.booking_item_profit,
    reporting.customer_outstanding,
    reporting.supplier_outstanding,
    reporting.lead_performance,
    reporting.booking_pipeline,
    reporting.sales_activity,
    reporting.subscription_state
to authenticated;
