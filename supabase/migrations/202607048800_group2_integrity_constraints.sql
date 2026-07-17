-- Migration: group2_integrity_constraints
-- Additive integrity hardening (2026-07-17). Two verified-open invariants that canon 31 left
-- unstated and prior CRs consciously deferred (SPEC-073: booking_reference uniqueness pending a
-- format decision — the guard is separable from the format; SPEC-042: finance non-negativity had
-- "no canonical basis" — now canonically stated). Cheapest to add now (empty tables); painful dedup
-- later. No behavioral change: nothing legitimate emits duplicate business keys or negative money
-- magnitudes (direction is modeled by separate entities, e.g. payments vs refunds — never a negative
-- amount). Parity with the existing booking_items / journal_entry_lines guards. Canon 31 synced.

-- 1. Business-key uniqueness (natural, human-facing keys).
--    booking_reference / quotation_number are per-tenant (both NOT NULL); plan_code is platform-global
--    (subscription_plans has no tenant_id); one entitlement per (plan, feature); one usage row per
--    (tenant, metric, period).
alter table public.bookings
    add constraint bookings_tenant_reference_key unique (tenant_id, booking_reference);
alter table public.quotations
    add constraint quotations_tenant_number_key unique (tenant_id, quotation_number);
alter table public.subscription_plans
    add constraint subscription_plans_code_key unique (plan_code);
alter table public.feature_entitlements
    add constraint feature_entitlements_plan_feature_key unique (subscription_plan_id, feature_code);
alter table public.usage_counters
    add constraint usage_counters_tenant_metric_period_key
        unique (tenant_id, usage_metric_code, period_start, period_end);

-- 2. Finance value non-negativity (parity with booking_items / journal_entry_lines).
--    Money magnitudes are >= 0; sign/direction lives in separate entities, never in a negative amount.
--    (receipts has no amount column — it references a payment — so it is intentionally excluded.)
alter table public.invoices
    add constraint invoices_total_amount_nonneg_check check (total_amount >= 0);
alter table public.payments
    add constraint payments_amount_nonneg_check check (amount >= 0);
alter table public.refunds
    add constraint refunds_amount_nonneg_check check (amount >= 0);
alter table public.payment_allocations
    add constraint payment_allocations_amount_nonneg_check
        check (allocated_amount >= 0
               and (allocated_amount_invoice_currency is null or allocated_amount_invoice_currency >= 0));
