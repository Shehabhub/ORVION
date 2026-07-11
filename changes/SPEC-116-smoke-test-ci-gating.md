# Change Request — SPEC-116

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

Make `scripts/verify_database.sql` self-arm `ON_ERROR_STOP` so it exits non-zero on any broken invariant, and run it in CI after every `db reset`.

---

## Business Reason

`verify_database.sql` asserts the frozen-baseline battery (71 tables, RLS + policies, tenant resolver, 65/395 catalog seed, FK Referential Action Standard, updated_at triggers, append-only audit) by `raise exception` on the first failure. But a `raise` inside a DO block exits psql with code **0** unless `ON_ERROR_STOP` is set — which neither the documented local command (AGENTS §5) nor CI set. Empirically confirmed: `raise` without the flag → exit 0; with it → exit 3. So the smoke-test was **silently non-gating everywhere** — a regression would print an error yet report success. Additionally, CI ran migrations + pgTAP but never ran the smoke-test at all. This CR fixes the root cause (self-arm in the file) and enforces it in CI.

---

## Risks

Minimal. Adds one psql meta-command (`\set ON_ERROR_STOP on`) to a script — no assertion changed — and one CI step. Verified: passing DB still exits 0; a simulated failure now exits non-zero.

---

## Supersedes / Depends On

None.

---

## Scope — Files Allowed to Modify

- changes/SPEC-116-smoke-test-ci-gating.md
- scripts/verify_database.sql
- .github/workflows/migration-ci.yml

---

## Out of Scope — Files Forbidden to Modify

- Any `supabase/migrations/**`, `supabase/tests/**`, `_ORVION_CANONICAL/**`, `AGENTS.md`, `README.md`, `GOVERNANCE.md`.
- Any other `changes/SPEC-*.md`.

---

## Minimum Reading List

- scripts/verify_database.sql
- .github/workflows/migration-ci.yml

---

## Implementation Steps

1. **Self-arm the smoke-test.** Verification check: search `scripts/verify_database.sql` for `\set ON_ERROR_STOP`. If found, Already Applied. Else add `\set ON_ERROR_STOP on` as the first line.
2. **Run it in CI.** Verification check: search `.github/workflows/migration-ci.yml` for `verify_database.sql`. If found, Already Applied. Else add a step after the pgTAP step running the smoke-test via `docker exec ... psql -v ON_ERROR_STOP=1 ... -f - < scripts/verify_database.sql`, and add `scripts/verify_database.sql` to the push/PR path filters.

---

## Acceptance Criteria

- [x] `verify_database.sql` first line is `\set ON_ERROR_STOP on`.
- [x] Passing DB exits 0 (verified, no `-v` flag); a `\set`+raise exits 3 (verified) — the file self-gates.
- [x] `migration-ci.yml` runs the smoke-test after `db reset` and triggers on `scripts/verify_database.sql`.
- [x] `ALL CHECKS PASSED (71 tables)` still prints on the current schema.

---

## Execution Log

### 2026-07-11 — Claude (Opus 4.8), Tier 1

Outcome: Complete

Step results:
- Step 1: Applied — `\set ON_ERROR_STOP on` prepended to `verify_database.sql`.
- Step 2: Applied — CI smoke-test step added (with `ON_ERROR_STOP=1`) + `scripts/verify_database.sql` path filter.

Verification (local, PG17): real smoke via in-file `\set`, no `-v` → `ALL CHECKS PASSED`, exit 0; in-file `\set`+raise, no `-v` → exit 3. Empirically established beforehand: raise without ON_ERROR_STOP → exit 0 (the latent non-gating bug), with it → exit 3.

Commits: (pending — awaiting owner go / branch off main)

---

## Verification Notes

[Autonomous completion per `CR_LIFECYCLE.md` §5 — fixes a verification-harness integrity weakness; no schema, canon, or decision change.]

---

## Review Gate

- [x] Every change matches the Implementation Steps exactly.
- [x] No file outside the Scope list was modified or created.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On is "None".
- [x] The repository is in a clean, releasable state (uncommitted; verified green).

---

## Notes

Discovered via continuous implementation review. The smoke-test's non-gating behavior meant every prior "ALL CHECKS PASSED" that followed an error would still have exited 0; now the file gates for all callers (local + CI), and CI enforces it.
