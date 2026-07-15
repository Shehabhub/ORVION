# Repository Engineering Program

Class: **HISTORICAL-IMMUTABLE** (process record; class header added 2026-07-16 as a metadata normalization — content unchanged).

## What Repository Engineering Is

Repository Engineering is the implementation program that follows this repository's completed architectural review (Governance stabilization, Repository Recovery, Repository Normalization, the Compatibility Adapter Contract, the Engineering Playbook, the Execution Contract). It executes the smallest set of Change Requests needed to bring the repository into alignment with its own frozen architecture before SQL implementation begins. It exists because the defect that started this entire effort — completed work whose repository state was never synchronized — was found not just in one place but across governance, onboarding, and roadmap documents; Repository Engineering is the corrective execution of that finding, one package at a time.

## Program Table

| # | Package | Objective | Change Request | Depends on (#) | Status |
| --- | --- | --- | --- | --- | --- |
| 1 | Authority & Self-Description | Resolve the codex.md/AGENTS.md authority collision; adopt the Command Vocabulary; record the Execution Contract | `changes/SPEC-012-authority-self-description.md` | — | see `changes/SPEC-012-authority-self-description.md` |
| 2 | State Truthfulness | Correct manifest.md and the roadmap's stale state fields | `changes/SPEC-013-state-truthfulness.md` | 1 | see `changes/SPEC-013-state-truthfulness.md` |
| 3 | Entry Point & Reading List | Complete README.md's Reading Order into a working repository-level reading path | `changes/SPEC-018-entry-point-reading-list.md` | 1, 2 | see `changes/SPEC-018-entry-point-reading-list.md` |
| 4 | Dead Reference & Tooling Cleanup | Fix broken paths in start-aider.ps1, AGENTS.md's dead docs/** entry, one unprefixed self-reference | `changes/SPEC-014-dead-reference-tooling-cleanup.md` | — | see `changes/SPEC-014-dead-reference-tooling-cleanup.md` |
| 5 | Compatibility Adapters | Create single-hop redirect files for tools with harness-level filename triggers | `changes/SPEC-019-compatibility-adapters.md` | 3 | see `changes/SPEC-019-compatibility-adapters.md` |
| 6 | Repository Index & Health | Extend repository-all.ps1 to emit a derived index (Health check deferred, distinct future work) | `changes/SPEC-020-repository-index.md` | 1, 2, 3 (soft) | see `changes/SPEC-020-repository-index.md` |
| 7 | Historical Audit-Trail Note | Acknowledge SPEC-002/003's missing report citations | not yet drafted | — (needs human input) | not yet drafted |
| 8 | CR_LIFECYCLE.md Engineering Observations | Formalize the Observation triage rule and its methodology-sequencing clause | `changes/SPEC-015-cr-lifecycle-observations.md` | — | see `changes/SPEC-015-cr-lifecycle-observations.md` |
| 9 | Program Plan Report | This document | `changes/SPEC-016-program-plan-report.md` | — | see `changes/SPEC-016-program-plan-report.md` |
| 10 | AGENTS.md Refinements | Transcribe commit-attribution format; sharpen Complete's Current Task clause | `changes/SPEC-017-agents-md-refinements.md` | 1 | see `changes/SPEC-017-agents-md-refinements.md` |
| 11 | Manifest Ownership Reconciliation | Closing Change Request — reconcile manifest.md to its single, actual responsibility | `changes/SPEC-021-manifest-ownership-reconciliation.md` | 1–10 | see `changes/SPEC-021-manifest-ownership-reconciliation.md` |

## Program Status

Repository Engineering is formally closed. Packages 1–5 (the SQL Readiness gate) and the two additional closing packages (8, 10, 11) are all `Complete`. Packages 6's Health-check portion and Package 7 remain intentionally open, non-blocking, deferred future work — not part of this program's required scope.

## How Progress Is Measured

Progress is measured as packages Complete divided by packages planned — a simple, objective, repository-checkable fraction, not a time estimate. Packages vary in effort, so the fraction signals completion, not a schedule. The authoritative test for whether Repository Engineering itself is finished is the SQL Readiness Criteria below, not the percentage.

## SQL Readiness Criteria

- Packages 1–5 (Authority, State, Entry Point, Dead Reference, Compatibility Adapters) show `Status: Complete` with a committed Verification Notes entry each.
- `manifest.md`'s Current Development Status matches actual Change Request and roadmap history.
- `32_execution_roadmap.md`'s Phase 2 entry accurately reflects that planning is done and SQL authoring is the remaining work.
- No document claims unqualified authority colliding with `AGENTS.md`.
- At least one Compatibility Adapter exists and correctly redirects.
