# Change Request — SPEC-044

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word anywhere in a Change Request.

---

## Assigned Model Tier

[ ] Tier 1 — Strong reasoning model
[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Create migration 14, `create_subscription_tables`, defining `subscription_plans`, `feature_entitlements`, `subscriptions`, `subscription_payment_proofs`, and `usage_counters` per `31_schema_draft.md` section 8 and `30_database_conventions.md`.

---

## Business Reason

`33` migration 14 adds the subscription/billing layer. `subscription_payment_proofs.document_id` depends on migration 7 (documents). `subscription_plans`/`feature_entitlements` are global platform catalog rows (no `tenant_id`). Structure only.

---

## Risks

Low (5 tables). Prerequisites live (tenants, users, documents). Status/plan/feature/metric codes plain text (SPEC-030). `updated_at` triggers on `subscriptions`/`usage_counters`. Business-key uniqueness deferred to backlog (see Notes). Physical choices in Notes.

---

## Supersedes / Depends On

Depends On: `SPEC-029` (tenants), `SPEC-032` (users), `SPEC-036` (documents), `SPEC-028` (moddatetime) — Complete.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607042700_create_subscription_tables.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; any later migration ; seed data

---

## Minimum Reading List

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/33_sql_migration_plan.md

---

## Implementation Steps

1. Create `supabase/migrations/202607042700_create_subscription_tables.sql` defining the five tables per `31` section 8: `subscription_plans` and `feature_entitlements` (global, no `tenant_id`), `subscriptions`, `subscription_payment_proofs` (FK to `documents`), `usage_counters`; all FKs `restrict`/`no action`; status/plan/feature/metric codes plain text; `period_start`/`period_end` `date`; `used_value`/`limit_value` `numeric`; `updated_at` triggers on `subscriptions`/`usage_counters`; FK/tenant/status indexes.

---

## Acceptance Criteria

- [x] `supabase/migrations/202607042700_create_subscription_tables.sql` exists.
- [x] `npx supabase db reset` applies every migration on a clean database with no error.
- [x] All five tables exist; all foreign keys `restrict`/`no action`; no FK on any code column.
- [x] `subscription_plans` and `feature_entitlements` have no `tenant_id` column (global catalog).
- [x] `updated_at` triggers exist on `subscriptions` and `usage_counters` (2) and nowhere else in this migration.

---

## Execution Log

### 2026-07-05 — Claude (Tier 2 execution)

Outcome: Complete

Step results:
- Step 1: Applied — created the migration; `npx supabase db reset` applied all 16 migrations cleanly.

Database Audit: 5 tables present; no FK deviates from restrict/no-action; no FK on any `_code` column; `subscription_plans`/`feature_entitlements` have no `tenant_id`; `updated_at` triggers on `subscriptions`/`usage_counters` only. Behavioral: a `subscription_payment_proofs` row with an unknown `document_id` rejected (restrict); cross-transaction update advanced `subscriptions.updated_at` (moddatetime).

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-05 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Re-checked all five tables against `31` section 8 — column sets, the deliberate absence of `tenant_id` on the two global catalog tables, nullability, `date` period columns, and `numeric` value columns match. Referential Action Standard upheld; codes plain text (SPEC-030). `updated_at` triggers correct. Clean `db reset` and behavioral tests reproduced. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Physical decisions: `subscription_plans` and `feature_entitlements` carry no `tenant_id` (global platform catalog, per `31`); `period_start`/`period_end` are `date` (the `_at`-less naming signals a date range); `used_value`/`limit_value` are unqualified `numeric` to match `31`'s explicit `usage_counters` spec (these are counts, not money, so not `numeric(14,2)`); `usage_counters.used_value` defaults to 0. Following the migration-10 booking-reference precedent, natural business-key uniqueness — `subscription_plans.plan_code`, `feature_entitlements(subscription_plan_id, feature_code)`, and `usage_counters(tenant_id, usage_metric_code, period_start, period_end)` — is not stated in `31` and was not invented here; logged as a Recommended backlog item for a later canonical decision.
