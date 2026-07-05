# Change Request — SPEC-053

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

Create migration 20, the database verification deliverable, as an executable SQL smoke-test (`scripts/verify_database.sql`) asserting the foundation invariants of migrations 1-19.

---

## Business Reason

`33` migration 20 is the plan's final stage — a database verification checklist, format left open. An **executable** smoke-test is chosen over a static checklist: it is CI-able and catches regressions (non-zero exit on any broken invariant), giving durable value over a document that cannot self-check.

---

## Risks

Very low (read-only assertions, no schema change, no migration). The script only queries catalog tables; it never mutates.

---

## Supersedes / Depends On

Depends On: all preceding migrations (1-19, SPEC-022 → SPEC-052) — Complete. Final stage of the 20-step plan.

---

## Scope — Files Allowed to Modify

- scripts/verify_database.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any migration ; seed data ; any table structure

---

## Minimum Reading List

- _ORVION_CANONICAL/33_sql_migration_plan.md (migration 20)
- _ORVION_CANONICAL/30_database_conventions.md (Referential Action Standard)
- _ORVION_CANONICAL/35_tenant_isolation_and_data_access_principles.md

---

## Implementation Steps

1. Create `scripts/verify_database.sql` — a `DO` block of nine assertions over the foundation: required extensions; 71 public base tables; RLS enabled on all; no RLS table without a policy; the `app.current_tenant_id()` resolver; 65 catalog_types + 395 catalog_values; every public FK restrict/no-action except the documented exceptions (`users.auth_user_id` set null; 3 auth-support cascades to `auth.users`); every `updated_at` table has a trigger; append-only triggers on `events`/`security_events`. Raises on the first failure; prints `ALL CHECKS PASSED` otherwise.

---

## Acceptance Criteria

- [x] `scripts/verify_database.sql` exists and mutates nothing.
- [x] Against a freshly reset database, it prints `ALL CHECKS PASSED` and exits 0.
- [x] With `ON_ERROR_STOP=1`, breaking any invariant makes it raise and exit non-zero (regression-catching proven).

---

## Execution Log

### 2026-07-06 — Claude (Tier 2 execution)

Outcome: Complete

Step results:
- Step 1: Applied — created `scripts/verify_database.sql`. On a clean `db reset` it printed `ALL CHECKS PASSED` (exit 0). Negative test: disabling RLS on one table made it raise `CHECK 3 FAILED` and exit 3; a subsequent clean reset restored the pass.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: The script is read-only and asserts the frozen-baseline invariants (71 tables, RLS + policy coverage, resolver, 65/395 catalog seed, Referential Action Standard with its three documented exceptions, updated_at triggers, append-only audit). Positive run passes; negative run (broken RLS) exits non-zero — confirming it is a genuine regression detector, not a static checklist. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Chosen as an executable script (not a documentation checklist) because it is CI-able and self-verifying, per execution-first philosophy. It encodes the three documented referential exceptions surfaced during verification (`users.auth_user_id` ON DELETE SET NULL per ADR-0011; `trusted_devices`/`otp_challenges`/`totp_enrollments` ON DELETE CASCADE per ADR-0012) — everything else is restrict/no-action. Completing this CR closes the 20-stage `33_sql_migration_plan.md`: the ORVION database foundation (schema + seed + RLS + verification) is complete. Remaining post-foundation activities: the deferred Architecture Knowledge Layer evaluation and the Database Naming Audit.
