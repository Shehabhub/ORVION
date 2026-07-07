# Change Request — SPEC-088

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Objective

Give a cold-start session the exact build/verify commands and RPC conventions in `AGENTS.md`, so it can begin implementing the next capability immediately without reconstructing them from historical CRs.

---

## Business Reason

Execution-readiness ("dress rehearsal") validation: attempting to start the next capability (`app.customer_balance(...)`) from the repository alone, a fresh session learned *what* to build and *that* it must "db reset + smoke-test + behavioral tests," but the exact commands (`npx supabase db reset`; the smoke-test via `docker exec -i supabase_db_ORVION psql … < scripts/verify_database.sql`; behavioral tests via the same container; the migration filename convention; the RPC pattern) existed only scattered across historical `changes/SPEC-0*.md` and CI. That is reconstructable but only by probing — the exact friction/token cost this effort exists to remove. The cross-tool `AGENTS.md` convention explicitly places build commands and test procedures in `AGENTS.md`. This is the single execution blocker between comprehension and immediate action.

---

## Risks

None material. One compact runbook section added to `AGENTS.md` (execution-critical, read at boot) + section renumbering (5→6, 6→7, 7→8) and one live cross-reference fix in `CR_LIFECYCLE.md` (§5→§6). Commands verified against `scripts/verify_database.sql` and recent CRs, not invented. No schema change.

---

## Supersedes / Depends On

Depends on SPEC-084 (AGENTS.md as operating model). Supersedes nothing.

---

## Scope — Files Allowed to Modify

- AGENTS.md
- CR_LIFECYCLE.md
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-088-build-verify-runbook.md

---

## Out of Scope — Files Forbidden to Modify

- Any `supabase/migrations/**`, any completed `changes/SPEC-0*.md` other than this one, README.md, PROTOCOL.md, changes/TEMPLATE.md, PROJECT_CONTEXT.md, `_ORVION_CANONICAL/32_execution_roadmap.md`, reports/**.

---

## Minimum Reading List

- AGENTS.md
- scripts/verify_database.sql

---

## Implementation Steps

1. Add an `AGENTS.md` §5 "Build and verify" section: stack + DB container name; `npx supabase start` / `db reset`; the smoke-test command (`scripts/verify_database.sql` → `ALL CHECKS PASSED`, 71 tables); behavioral-test invocation; CI pointer; and the RPC conventions (security invoker / empty search_path / `current_tenant_id()` / `authorize()` / `record_event()` / grant to authenticated) with a concrete example migration. Renumber the subsequent sections (Guardrails 5→6, Multi-agent 6→7, Maintaining 7→8).
2. Fix the one live cross-reference to the renumbered section: `CR_LIFECYCLE.md` §6 "AGENTS.md §5" → "§6".

---

## Acceptance Criteria

- [x] `AGENTS.md` §5 states the exact apply, smoke-test, behavioral-test, and CI commands, plus the RPC conventions and an example migration.
- [x] Subsequent sections renumbered consistently (Guardrails §6, Multi-agent §7, Maintaining §8); no dangling internal reference.
- [x] `CR_LIFECYCLE.md`'s live reference points to `AGENTS.md` §6 (recoverability invariant).
- [x] Dress-rehearsal test passes: a cold session can begin the next capability with only task-specific canon reads remaining.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), owner-directed (execution-readiness validation)

Outcome: Complete

Step results:
- Step 1: Applied — `AGENTS.md` §5 "Build and verify" added; §6/§7/§8 renumbered.
- Step 2: Applied — `CR_LIFECYCLE.md` recoverability cross-reference updated to §6. Grep confirms no other live doc references a shifted section number.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8), execution-readiness (dress rehearsal)

Verdict: Confirmed Complete

Findings: Re-ran the dress rehearsal for `app.customer_balance(...)` from the repo alone. From the boot chain a cold session now has: the capability (manifest + roadmap), the exact build/verify commands and RPC pattern (`AGENTS.md` §5), the CR process (`CR_LIFECYCLE.md` + `TEMPLATE.md`), and the migration/verify scripts. The only remaining reads are task-specific canon for finance table columns (`_ORVION_CANONICAL/07`, `14`, `31`; migrations 6/12) — normal per-task reading routed by `AGENTS.md` §4, not a gap. Commands verified against `scripts/verify_database.sql`. Success criterion (begin implementing immediately, no external context) met.

Recommendation to human: Set Status to Complete (autonomous per `CR_LIFECYCLE.md` §5 — no new architectural decision; codifies existing commands).

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified or created.
- [x] No completed CR (append-only history) was altered.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On handled.
- [x] The repository is in a clean, releasable state.

---

## Notes

Concludes the execution-readiness arc. The repository now supports comprehension AND immediate execution from a cold start. Next: resume Phase 6 (Finance Core, `app.customer_balance(...)`).
