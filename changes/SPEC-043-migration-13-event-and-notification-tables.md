# Change Request — SPEC-043

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

Create migration 13, `create_event_and_notification_tables`, defining `events`, `security_events`, `notifications`, and `notification_deliveries` per `31_schema_draft.md` section 7 and `30_database_conventions.md`.

---

## Business Reason

`33` migration 13 adds the event log and notification tables. It depends only on migration 4 (tenants/users). `events`/`security_events` use polymorphic entity fields, not real FKs beyond `tenant_id`/`actor`. Structure only.

---

## Risks

Low (4 tables, no CHECKs, no triggers). Prerequisites live. `tenant_id` nullable on `events`/`security_events` (platform-level rows). Type/severity/channel/status codes plain text (SPEC-030). Physical choices in Notes.

---

## Supersedes / Depends On

Depends On: `SPEC-029` (tenants), `SPEC-032` (users) — Complete.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607042600_create_event_and_notification_tables.sql

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

1. Create `supabase/migrations/202607042600_create_event_and_notification_tables.sql` defining the four tables per `31` section 7: `events`, `security_events` (nullable `tenant_id`/`user_id`, polymorphic entity fields, `payload jsonb`, `ip_address inet`), `notifications`, `notification_deliveries`; all real FKs `restrict`/`no action`; type/severity/channel/status codes plain text; the two `events` composite indexes from `31` plus FK/tenant indexes. No `updated_at` columns, so no triggers.

---

## Acceptance Criteria

- [x] `supabase/migrations/202607042600_create_event_and_notification_tables.sql` exists.
- [x] `npx supabase db reset` applies every migration on a clean database with no error.
- [x] All four tables exist; all real foreign keys `restrict`/`no action`; no FK on any code column; polymorphic `entity_id`/`related_entity_id` carry no FK.
- [x] No `updated_at` triggers were created in this migration (no table carries `updated_at`).
- [x] `events.tenant_id` and `security_events.tenant_id`/`user_id` are nullable; `notifications.tenant_id`/`target_user_id` are NOT NULL.

---

## Execution Log

### 2026-07-05 — Claude (Tier 2 execution)

Outcome: Complete

Step results:
- Step 1: Applied — created the migration; `npx supabase db reset` applied all 15 migrations cleanly.

Database Audit: 4 tables present; no real FK deviates from restrict/no-action; no FK on any `_code` column; no polymorphic-id FK; zero triggers on the four tables; nullability matches `31`. Behavioral: an event row with null `tenant_id` inserted successfully (platform event); a notification with an unknown `target_user_id` rejected (restrict).

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-05 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Re-checked all four tables against `31` section 7 — column sets, nullability (nullable `tenant_id` on `events`/`security_events`, nullable `user_id` on `security_events`), polymorphic entity fields with no FK, and `payload jsonb` match. Referential Action Standard upheld; codes plain text (SPEC-030). The two `31`-specified `events` composite indexes exist. No `updated_at`, hence no triggers. Clean `db reset` and behavioral tests reproduced. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Physical decisions: `events.tenant_id`, `security_events.tenant_id`, and `security_events.user_id` are nullable per `31` (platform-level rows); polymorphic `events.entity_id`/`entity_type`, `notifications.related_entity_id`/`related_entity_type` are plain columns (no FK); `payload` is `jsonb` on `events`/`security_events`; `security_events.ip_address` uses the native `inet` type (better integrity than text; trivially castable for downstream use). No table in this migration carries `updated_at`, so no moddatetime triggers were created. DB-enforced event immutability (blocking UPDATE/DELETE on `events`/`security_events`) is a Recommended backlog item deferred to the RLS migration (19), consistent with deferring all other row-level enforcement to 19.
