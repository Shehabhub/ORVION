# Change Request — SPEC-117

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model

---

## Objective

Wrap `app.current_tenant_id()` in a scalar subquery in every RLS policy so it evaluates once per query (InitPlan) instead of per row, and add a pgTAP invariant that keeps it wrapped.

---

## Business Reason

Every RLS policy filters on `app.current_tenant_id()`, which does a `users` lookup keyed on `auth.uid()`. Called unwrapped, Postgres evaluates it **per row**; wrapped as `(select app.current_tenant_id())` it is hoisted to an InitPlan and evaluated **once per query** — the Supabase-documented RLS performance pattern. Live inspection found all 63 policies referencing the resolver were unwrapped (ARB finding A1). This is a pure performance protection: `x = f()` and `x = (select f())` are identical as filters, so tenant-isolation semantics are unchanged.

---

## Risks

Low, and mechanical rather than semantic. A scalar subquery returns the same value as the bare call, so isolation is preserved **by construction** — no input distinguishes the two. The only risk is a malformed rewrite, mitigated by: catalog-driven in-place rewrite (each policy's own expression, any shape), `db reset` applying cleanly, post-migration check (0 of 63 policies left unwrapped), pgTAP RLS coverage still green, smoke-test `ALL CHECKS PASSED`.

---

## Supersedes / Depends On

Depends on SPEC-113 (pgTAP harness). Delivers ARB finding A1.

---

## Scope — Files Allowed to Modify

- changes/SPEC-117-rls-initplan-wrapping.md
- supabase/migrations/202607048500_rls_initplan_wrapping.sql
- supabase/tests/06_rls_initplan_wrapping_test.sql

---

## Out of Scope — Files Forbidden to Modify

- Any existing file under `supabase/migrations/**` (immutable; this adds one migration that ALTERs policies in place).
- Any `_ORVION_CANONICAL/**`, `scripts/verify_database.sql`, `AGENTS.md`, `README.md`, `GOVERNANCE.md`.
- Any other `changes/SPEC-*.md`.

---

## Minimum Reading List

- supabase/migrations/202607043300_create_rls_policies.sql (original policy definitions)
- reports/master/MASTER_GAP_REGISTER.md (A1)

---

## Implementation Steps

1. **Add migration `202607048500_rls_initplan_wrapping.sql`.** A catalog-driven DO loop over every `public` policy whose `qual`/`with_check` references `app.current_tenant_id()`; `ALTER POLICY … USING/WITH CHECK` re-specifying the existing expression with `app.current_tenant_id()` replaced by `(select app.current_tenant_id())`. Only clauses that already exist are set.
2. **Add pgTAP test `06_rls_initplan_wrapping_test.sql`.** Assert 0 `public` policies reference the resolver without a `select`-wrap.

---

## Acceptance Criteria

- [x] Post-migration: 63 policies reference the resolver, 0 unwrapped (verified).
- [x] Sample confirms rewrite, e.g. `catalog_read` → `… OR (tenant_id = ( SELECT app.current_tenant_id()))`.
- [x] `supabase db reset` clean; `supabase test db` → **Result: PASS** (Files=6, Tests=8).
- [x] `scripts/verify_database.sql` → `ALL CHECKS PASSED (71 tables)` (RLS + policies still valid).
- [x] Only one new migration + one new test added; no existing migration or canon modified.

---

## Execution Log

### 2026-07-11 — Claude (Opus 4.8), Tier 1

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607048500`; catalog-driven ALTER POLICY loop wrapped the resolver in all 63 policies (tenant_isolation ×54, tenant_self, catalog_* ×4, audit_* ×4).
- Step 2: Applied — `06_rls_initplan_wrapping_test.sql`; green.

Verification (local, PG17): `db reset` clean → post-check 63 referencing / 0 unwrapped → `supabase test db` **PASS** (Files=6, Tests=8) → `verify_database.sql` `ALL CHECKS PASSED (71 tables)`. Semantic equivalence is by construction (scalar subquery == bare call as a filter).

Commits: (pending — awaiting owner go / branch off main)

---

## Verification Notes

[Autonomous completion per `CR_LIFECYCLE.md` §5 — performance pattern, no new decision, isolation semantics provably unchanged.]

---

## Review Gate

- [x] Every change matches the Implementation Steps exactly.
- [x] No file outside the Scope list was modified or created.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On updated (depends on SPEC-113; delivers A1).
- [x] The repository is in a clean, releasable state (uncommitted; verified green).

---

## Notes

Delivers ARB finding **A1**. The InitPlan-wrapping invariant (`06`) is now a permanent fitness function, so future policies inherit the pattern or fail CI.
