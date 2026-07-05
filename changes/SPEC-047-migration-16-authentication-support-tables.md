# Change Request — SPEC-047

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

Create migration 16, `create_authentication_support_tables`, defining `trusted_devices`, `otp_challenges`, and `totp_enrollments` derived from `34_authentication_and_identity_principles.md` and `31_schema_draft.md` section 9 (as amended by SPEC-046).

---

## Business Reason

`33` migration 16 adds the authentication support tables. Per the Authentication & Identity Principles (1/6/7) and ADR-0012, these prove *who the human is* and belong to the Human Identity: keyed by `auth_user_id` → `auth.users(id)`, no `tenant_id`, no membership `user_id`. Structure only.

---

## Risks

Low (3 tables). Depends only on the Supabase-provided `auth.users`. Status codes plain text (SPEC-030). `on delete cascade` to the human identity is the documented opt-in (ADR-0012). No `updated_at`, so no triggers. Physical choices in Notes.

---

## Supersedes / Depends On

Depends On: `SPEC-022` (migration 1 enables extensions; `auth.users` is Supabase-provided), `SPEC-046` (principles + `31` §9 amendment). No CR superseded.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607042900_create_authentication_support_tables.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; any later migration ; seed data

---

## Minimum Reading List

- _ORVION_CANONICAL/34_authentication_and_identity_principles.md
- _ORVION_CANONICAL/31_schema_draft.md section 9
- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/33_sql_migration_plan.md

---

## Implementation Steps

1. Create `supabase/migrations/202607042900_create_authentication_support_tables.sql` defining the three tables per `31` section 9 (amended): each keyed by `auth_user_id` → `auth.users(id)` `on delete cascade on update no action`, no `tenant_id`/membership `user_id`; status codes plain text; `auth_user_id` indexes. No `updated_at`, so no triggers.

---

## Acceptance Criteria

- [x] `supabase/migrations/202607042900_create_authentication_support_tables.sql` exists.
- [x] `npx supabase db reset` applies every migration on a clean database with no error.
- [x] All three tables exist; each has an `auth_user_id` FK to `auth.users(id)` with `on delete cascade`; none has a `tenant_id` or membership `user_id` column.
- [x] No FK on any status code column; no `updated_at` triggers created.

---

## Execution Log

### 2026-07-05 — Claude (Tier 2 execution)

Outcome: Complete

Step results:
- Step 1: Applied — created the migration; `npx supabase db reset` applied all 18 migrations cleanly.

Database Audit: 3 tables present; each `auth_user_id` FK targets `auth.users` with `confdeltype='c'` (cascade); no `tenant_id`/`user_id` column on any of them; no FK on any `_code` column; zero triggers. Behavioral: an insert with an unknown `auth_user_id` was rejected (foreign key to `auth.users`).

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-05 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Re-checked the three tables against `31` section 9 (amended) and `34`'s schema consequence — `auth_user_id` → `auth.users(id)` on all three, `on delete cascade` (the documented opt-in), no `tenant_id`, no membership `user_id`. Status codes plain text (SPEC-030). No `updated_at`, hence no triggers. Clean `db reset` reproduced; FK to `auth.users` enforced behaviorally. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Physical decisions: `auth_user_id` references `auth.users(id)` (the Human Identity) `on delete cascade on update no action` — cascade is the deliberate opt-in from ADR-0012 / `31` §9, since these records are pure children of the human; `failed_attempts` is `integer not null default 0`; `is_active` defaults true; status codes are plain text. No `tenant_id` and no membership `user_id` on any of the three tables (Principles 1/6/7). RLS for these tables (migration 19) will be row-ownership by `auth.uid()`, not tenant-scoped. Natural uniqueness of `(auth_user_id, device_identifier)` on `trusted_devices` is not stated in `31` and was not invented; it remains a candidate for the same business-key backlog decision as other tables.
