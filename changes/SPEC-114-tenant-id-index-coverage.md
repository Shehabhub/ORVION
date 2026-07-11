# Change Request — SPEC-114

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

[ ] Tier 2 — Local execution agent (Qwen3.8B)

---

## Objective

Add the canon-required leading `tenant_id` index to the 18 tenant tables built without one, and add a pgTAP invariant that keeps every tenant table covered.

---

## Business Reason

`30_database_conventions.md` (Index Standard) names `tenant_id` as the first expected index, because every RLS policy filters `tenant_id = app.current_tenant_id()` — an unindexed tenant_id forces a sequential scan on every tenant-scoped query, degrading as tenants grow. Live inspection found 18 of 54 NOT-NULL-`tenant_id` tables lacking a leading tenant_id index — matching ARB finding A2. This closes a canon-vs-built gap; it implements an already-approved convention, introduces no new decision, and is additive (indexes only).

---

## Risks

Minimal. Additive indexes only — no table/column/type/relationship/data change, no existing migration altered. Only the bare `tenant_id` index that canon names unambiguously is added; composite refinements (tenant_id+status/customer_id/booking_id) are deferred to the capabilities that exercise those access paths (no speculative over-indexing).

---

## Supersedes / Depends On

Depends on SPEC-113 (pgTAP harness) for the new invariant test. Delivers the index portion of ARB finding A2.

---

## Scope — Files Allowed to Modify

- changes/SPEC-114-tenant-id-index-coverage.md
- supabase/migrations/202607048300_add_missing_tenant_id_indexes.sql
- supabase/tests/04_tenant_id_index_coverage_test.sql

---

## Out of Scope — Files Forbidden to Modify

- Any existing file under `supabase/migrations/**` (immutable; this adds one new migration).
- Any `_ORVION_CANONICAL/**` (the convention already prescribes the index; no canon change).
- `scripts/verify_database.sql`, `AGENTS.md`, `README.md`, `GOVERNANCE.md`.
- Any other `changes/SPEC-*.md`.

---

## Minimum Reading List

- _ORVION_CANONICAL/30_database_conventions.md (Index Standard)
- supabase/migrations/202607043300_create_rls_policies.sql (tenant_id filter model)
- reports/master/MASTER_GAP_REGISTER.md (A2)

---

## Implementation Steps

1. **Add migration `202607048300_add_missing_tenant_id_indexes.sql`.** Verification check: path exists. Else `create index if not exists <table>_tenant_id_idx on public.<table> (tenant_id);` for the 18 tables identified by the live catalog query (leading-column-tenant_id absent). Naming matches the existing `<table>_tenant_id_idx` convention.
2. **Add pgTAP test `04_tenant_id_index_coverage_test.sql`.** Verification check: path exists. Else assert 0 NOT-NULL-tenant_id tables lack a leading-tenant_id index. Hard assertion (passes once step 1 applies).

---

## Acceptance Criteria

- [x] 18 `<table>_tenant_id_idx` indexes created; `04_tenant_id_index_coverage_test.sql` reports 0 missing.
- [x] `supabase db reset` applies cleanly; `supabase test db` → **Result: PASS** (Files=4, Tests=6).
- [x] `scripts/verify_database.sql` → `ALL CHECKS PASSED (71 tables)` (unchanged).
- [x] Only the one new migration + one new test file added; no existing migration or canon modified.

---

## Execution Log

### 2026-07-11 — Claude (Opus 4.8), Tier 1

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607048300` adds 18 tenant_id indexes (live query confirmed exactly 18 tables lacked one, matching A2).
- Step 2: Applied — `04_tenant_id_index_coverage_test.sql` asserts full coverage; passes after step 1.

Verification (local, Supabase CLI 2.109.0, PG17): `db reset` clean → `supabase test db` **Result: PASS** (Files=4, Tests=6; test 04 green, DC-1 still todo) → `verify_database.sql` `ALL CHECKS PASSED (71 tables)`.

Commits: (pending — awaiting owner go / branch off main, per session commit policy)

---

## Verification Notes

[Autonomous completion per `CR_LIFECYCLE.md` §5 — verified by the executing agent; implements an existing canon convention (Index Standard), no new architectural decision. Composite-index refinements explicitly deferred.]

---

## Review Gate

- [x] Every change matches the Implementation Steps exactly.
- [x] No file outside the Scope list was modified or created.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On updated (depends on SPEC-113; delivers A2 index portion).
- [x] The repository is in a clean, releasable state (uncommitted; verified green).

---

## Notes

Delivers the index portion of ARB finding **A2**. The composite refinements canon lists (tenant_id+status, +customer_id, +booking_id) remain deferred to the capabilities that exercise those paths — recorded so a future session does not treat A2 as fully closed for composites. The bare-tenant_id coverage is now a permanent pgTAP fitness function.
