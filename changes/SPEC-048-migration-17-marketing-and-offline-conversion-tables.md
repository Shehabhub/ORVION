# Change Request — SPEC-048

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word anywhere in a Change Request.

---

## Assigned Model Tier

[ ] Tier 1 — Strong reasoning model
[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Create migration 17, `create_marketing_and_offline_conversion_tables`, defining `marketing_campaigns`, `campaign_daily_metrics`, `attribution_clicks`, `offline_conversions`, and `offline_conversion_deliveries` per `31_schema_draft.md` section 10 and `30_database_conventions.md`.

---

## Business Reason

`33` migration 17 adds the marketing and offline-conversion layer. `offline_conversions` carries nullable FKs to `leads`, `bookings`/`booking_items`, and `payments`, so it follows those migrations. Structure only.

---

## Risks

Low (5 tables). Prerequisites live. Platform/status/source/event codes plain text (SPEC-030). Money columns `numeric(14,2)`, count metrics `numeric`. `updated_at` triggers on `marketing_campaigns`/`campaign_daily_metrics`. Physical choices in Notes.

---

## Supersedes / Depends On

Depends On: `SPEC-029` (tenants), `SPEC-035` (currencies via finance? no — currencies from SPEC-025), `SPEC-038` (leads), `SPEC-040` (bookings/booking_items), `SPEC-042` (payments), `SPEC-028` (moddatetime) — Complete.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607043000_create_marketing_and_offline_conversion_tables.sql

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

1. Create `supabase/migrations/202607043000_create_marketing_and_offline_conversion_tables.sql` defining the five tables per `31` section 10: `marketing_campaigns`, `campaign_daily_metrics`, `attribution_clicks` (before `offline_conversions`), `offline_conversions`, `offline_conversion_deliveries`; all FKs `restrict`/`no action`; `currency_code`→`currencies`; platform/status/source/event codes plain text; money columns `numeric(14,2)`, count metrics `numeric`; `updated_at` triggers on `marketing_campaigns`/`campaign_daily_metrics`; FK/tenant indexes.

---

## Acceptance Criteria

- [x] `supabase/migrations/202607043000_create_marketing_and_offline_conversion_tables.sql` exists.
- [x] `npx supabase db reset` applies every migration on a clean database with no error.
- [x] All five tables exist; all foreign keys `restrict`/`no action`; no FK on any platform/status/source/event code column (only `currency_code` FKs to `currencies`).
- [x] `updated_at` triggers exist on `marketing_campaigns` and `campaign_daily_metrics` (2) and nowhere else in this migration.

---

## Execution Log

### 2026-07-05 — Claude (Tier 2 execution)

Outcome: Complete

Step results:
- Step 1: Applied — created the migration; `npx supabase db reset` applied all 19 migrations cleanly.

Database Audit: 5 tables present; no FK deviates from restrict/no-action; the only `_code` FKs are `currency_code`→`currencies`; `updated_at` triggers on `marketing_campaigns`/`campaign_daily_metrics` only. Behavioral: an `offline_conversions` row referencing an unknown `attribution_click_id` was rejected (restrict); cross-transaction update advanced `marketing_campaigns.updated_at`.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-05 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Re-checked all five tables against `31` section 10 — column sets, nullability, money vs count numeric typing, and the `attribution_clicks`→`offline_conversions` ordering match. Referential Action Standard upheld; platform/status/source/event codes plain text (SPEC-030); only `currency_code` carries an FK. `updated_at` triggers correct. Clean `db reset` and behavioral tests reproduced. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Physical decisions: money columns (`spend_amount`, `revenue_amount`, `conversion_value`) are `numeric(14,2)`; count metrics (`impressions`, `clicks`, `leads_count`, `bookings_count`) are unqualified `numeric` per `31`; `attempt_number` is `integer not null default 1`; `response_payload` is `jsonb`; `metric_date` is `date`, `conversion_at`/`clicked_at` are `timestamptz`; `status_code` on `marketing_campaigns` is nullable per `31`. `attribution_clicks` is created before `offline_conversions` so the `attribution_click_id` FK resolves within the migration.
