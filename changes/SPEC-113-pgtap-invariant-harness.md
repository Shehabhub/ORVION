# Change Request — SPEC-113

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
    Permitted modes: IMPLEMENT only

---

## Objective

Stand up a pgTAP invariant test harness (`supabase test db`) that asserts the repository's foundation invariants as executable regression tests, wired into CI.

---

## Business Reason

The codebase has grown to ~90 migrations (71 tables, Phases 2–7 built) with only a single smoke-test (`scripts/verify_database.sql`) as its safety net. The Architecture Review Board sequenced a pgTAP harness (finding **DC-16**) as the first foundation-hardening step and the precondition for the built-table retrofits (DC-1 money precision, R1–R8) — retrofits that alter already-built columns and are unsafe without a regression net. pgTAP is catalog-driven, so it detects invariant violations (missing RLS, wrong money scale, missing append-only triggers) generically as tables are added, rather than by hand-maintained checklists. This CR delivers the net itself — additive test infrastructure only; it changes no application schema, canon, or ADR.

---

## Risks

- **Low.** Additive only: new `supabase/tests/**` files + one CI step + a config note. No migration is altered, no application table/RPC/policy is touched, no canon or ADR changes.
- The money-currency invariant (DC-1) will FAIL against the current `numeric(14,2)`. To keep CI green and the tree releasable, that single assertion ships inside a pgTAP `todo()` block documenting DC-1 with a pointer to `MASTER_GAP_REGISTER` — it records the known defect as an executable expectation without breaking the build. It is un-wrapped to a hard assertion by the (owner-gated) DC-1 fix CR, not here.
- pgTAP must be available to the test database. It is created per-test-run via `create extension if not exists pgtap` inside the test setup, not added to the production migration chain (keeps the Frozen Baseline untouched).

---

## Supersedes / Depends On

None. (Foundation-hardening peer items DC-1/R1–R8 are owner-gated and out of scope here; this CR is their precondition.)

---

## Scope — Files Allowed to Modify

- changes/SPEC-113-pgtap-invariant-harness.md
- supabase/tests/01_rls_coverage_test.sql
- supabase/tests/02_append_only_audit_test.sql
- supabase/tests/03_money_currency_precision_test.sql
- .github/workflows/migration-ci.yml

(A separate `00_setup.sql` was dropped during implementation: pg_prove treats every file as a TAP test and a DDL-only file has no plan, so the `create extension if not exists pgtap` guard lives at the top of each test file instead — idempotent and self-contained.)

---

## Out of Scope — Files Forbidden to Modify

- Any file under `supabase/migrations/**` (all applied migrations are immutable, including the Frozen Baseline).
- `scripts/verify_database.sql` (the existing smoke-test stays as-is; pgTAP complements, does not replace it).
- Any `_ORVION_CANONICAL/**` (incl. `manifest.md` and `32_execution_roadmap.md` — this CR adds no capability to the roadmap and changes no state until it reaches Complete).
- Any `reports/**`, `AGENTS.md`, `README.md`, `GOVERNANCE.md`, `CR_LIFECYCLE.md`.
- Any other `changes/SPEC-*.md`.

---

## Minimum Reading List

- supabase/migrations/202607041200_enable_extensions.sql (extension-creation pattern)
- supabase/migrations/202607043300_create_rls_policies.sql (RLS coverage model — the tenant_id NOT NULL loop, `tenant_isolation`)
- supabase/migrations/202607045300_seed_currencies.sql (`currencies.decimal_places` — the money-precision reference)
- scripts/verify_database.sql (invariants already asserted by the smoke-test, to avoid duplication)
- reports/master/MASTER_GAP_REGISTER.md (DC-1 / DC-16 authoritative detail)

---

## Implementation Steps

1. **Extension bootstrap.** Each test file begins with `create extension if not exists pgtap with schema extensions;` (idempotent). No separate setup file — see Scope note.

2. **Create `supabase/tests/01_rls_coverage_test.sql`.** Verification check: path exists. Else author a catalog-driven test: for every table in the application schema(s) that has a `tenant_id` column declared `NOT NULL`, assert (a) `relrowsecurity = true` in `pg_class`, and (b) at least one policy exists in `pg_policies`. Drive the assertions from `pg_catalog`/`information_schema` (no hard-coded table names). Wrap with `select plan(...)`/`select * from finish();` sized from the catalog count.

3. **Create `supabase/tests/02_append_only_audit_test.sql`.** Verification check: path exists. Else assert that the append-only backbone tables (events / security_events, resolved from the catalog by the presence of the `app.forbid_mutation()` trigger function) each carry a `BEFORE UPDATE OR DELETE` trigger bound to `app.forbid_mutation`. Catalog-driven via `pg_trigger`/`pg_proc`.

4. **Create `supabase/tests/03_money_currency_precision_test.sql`.** Verification check: path exists. Else assert, inside a `todo('DC-1: money columns are numeric(14,2); 3-dp currencies (KWD/BHD/OMR/JOD) need scale >= currency precision — fix is owner-gated, see MASTER_GAP_REGISTER DC-1', N)` block, that every money-typed `numeric` column has scale >= the maximum `currencies.decimal_places`. The `todo()` wrapper records the known failure without failing the suite.

5. **Wire CI.** Verification check: search `.github/workflows/migration-ci.yml` for the string `supabase test db`. If found, Already Applied. Else add a step after "Apply all migrations on a clean database" that runs `supabase test db`, and extend the `on.push`/`on.pull_request` path filters to include `supabase/tests/**`.

---

## Acceptance Criteria

- [x] The pgtap extension is created by the test files (per-file guard) and is not part of `supabase/migrations/**`.
- [x] `01_rls_coverage_test.sql` fails if any NOT-NULL-`tenant_id` table lacks RLS or a policy — **verified by negative check**: disabling RLS on `booking_items` made the suite `Result: FAIL`; re-enabling restored `PASS`.
- [x] `02_append_only_audit_test.sql` asserts the `forbid_mutation` trigger on each append-only backbone table (events, security_events).
- [x] `03_money_currency_precision_test.sql` encodes the DC-1 scale invariant inside a `todo` block — suite reports `Failed (TODO) have:22 want:0`, i.e. known-todo, not a failure.
- [x] `supabase test db` passes locally — **Result: PASS** (Files=3, Tests=5), money test reported as todo.
- [x] `.github/workflows/migration-ci.yml` runs `supabase test db` and triggers on `supabase/tests/**`.
- [x] No file under `supabase/migrations/**`, `_ORVION_CANONICAL/**` was modified; `scripts/verify_database.sql` unchanged and still reports `ALL CHECKS PASSED (71 tables)`.

---

## Execution Log

### 2026-07-11 — Claude (Opus 4.8), Tier 1

Outcome: Complete

Step results:
- Step 1 (extension bootstrap): Applied — per-file `create extension if not exists pgtap`; separate 00_setup.sql dropped (pg_prove needs a plan per file).
- Step 2 (RLS coverage): Applied — catalog-driven; live schema has 54 NOT-NULL-tenant_id tables, all RLS-enabled + policied (0 violations).
- Step 3 (append-only): Applied — events + security_events carry `app.forbid_mutation` (confirmed via pg_trigger/pg_proc).
- Step 4 (money precision): Applied — 22 `numeric(14,2)` money columns vs max `currencies.decimal_places`=3; assertion wrapped in `todo` (DC-1).
- Step 5 (CI): Applied — `supabase test db` step added after db reset; `supabase/tests/**` added to push/PR path filters.

Verification run (local, Supabase CLI 2.109.0, PG17):
- `supabase db reset` → all migrations apply cleanly.
- `supabase test db` → **Result: PASS** (Files=3, Tests=5); `03_money…` reports `Failed (TODO) have:22 want:0`.
- Negative check → RLS disabled on `booking_items` ⇒ `Result: FAIL`; re-enabled ⇒ `PASS` (regression net proven).
- `scripts/verify_database.sql` → `ALL CHECKS PASSED (71 tables)` (smoke-test unaffected).

Commits: (pending — awaiting owner go / branch off main, per session commit policy)

---

## Verification Notes

[Autonomous completion per `CR_LIFECYCLE.md` §5 / `AGENTS.md` §2 — verified by the executing agent; no new architectural decision introduced (delivers ARB-validated finding DC-16; pgTAP is within delegated tooling authority). Independent human/second-agent re-check optional.]

---

## Review Gate

- [x] Every change matches the Implementation Steps exactly (Step 1 consolidated as recorded in the Execution Log and Scope note).
- [x] No file outside the Scope list was modified or created.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On is "None"; nothing to reconcile.
- [x] The repository is in a clean, releasable state (uncommitted; verified green).

---

## Notes

Delivers ARB finding **DC-16** (`MASTER_EXECUTION_PLAN` Batch 0, step 1). This is the additive precondition for the owner-gated retrofits (DC-1 money precision `numeric(19,4)`, R1–R8) — it does not perform them. Kept as its own capability so the regression net exists and is green before any built-table column is altered.
