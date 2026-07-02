# Change Request — SPEC-016

## Status
[x] Approved

## Assigned Model Tier
[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

## Objective
Create `reports/repository-engineering-program.md` — a single, repository-visible, structural view of the Repository Engineering program's purpose, packages, dependencies, progress measurement, and completion criteria, referencing each package's Change Request for live status rather than restating it.

## Business Reason
This program's purpose, package list, dependency order, progress measurement, and SQL Readiness Criteria currently exist only in conversation. This document gives them a permanent, repository-native home, matching `33_sql_migration_plan.md`'s proven table-with-dependencies format — reused, not reinvented. Amended after the post-SPEC-012/013/014 retrospective to include an explanatory "What Repository Engineering Is" section and a "How Progress Is Measured" section — both identified as missing capabilities before this Change Request's own Approval, and folded in here rather than deferred.

## Risks
None. New, static, narrative document; no live state is duplicated into it.

## Supersedes / Depends On
Supersedes: None. Depends on: None.

## Scope — Files Allowed to Modify
- reports/repository-engineering-program.md (new file)

## Out of Scope — Files Forbidden to Modify
Scope above is exhaustive. Every existing file, including every `changes/SPEC-0NN-*.md` file (referenced by path, never restated).

## Minimum Reading List
- changes/SPEC-012-authority-self-description.md
- changes/SPEC-013-state-truthfulness.md
- changes/SPEC-014-dead-reference-tooling-cleanup.md

## Implementation Steps

### Step 1 — Create the Program Plan document
Verify: check whether `reports/repository-engineering-program.md` exists. If it exists: Already Applied, skip. If not: create it with, in order:

1. `## What Repository Engineering Is` — one paragraph: Repository Engineering is the implementation program that follows this repository's completed architectural review (Governance stabilization, Repository Recovery, Repository Normalization, the Compatibility Adapter Contract, the Engineering Playbook, the Execution Contract). It executes the smallest set of Change Requests needed to bring the repository into alignment with its own frozen architecture before SQL implementation begins. It exists because the defect that started this entire effort — completed work whose repository state was never synchronized — was found not just in one place but across governance, onboarding, and roadmap documents; Repository Engineering is the corrective execution of that finding, one package at a time.
2. `## Program Table` — a table with columns `# | Package | Objective | Change Request | Depends on (#) | Status`, listing all nine current program items (Authority & Self-Description / SPEC-012; State Truthfulness / SPEC-013; Entry Point & Reading List / SPEC-018; Dead Reference & Tooling Cleanup / SPEC-014; Compatibility Adapters / not yet drafted; Repository Index & Health / not yet drafted; Historical Audit-Trail Note / not yet drafted; CR_LIFECYCLE.md Engineering Observations / SPEC-015; this Program Plan / SPEC-016). Every Status cell reads only "see `changes/SPEC-0NN-*.md`" or "not yet drafted" — never a restated status word.
3. `## How Progress Is Measured` — progress is measured as packages Complete divided by packages planned, a simple, objective, repository-checkable fraction, not a time estimate. Packages vary in effort, so the fraction signals completion, not a schedule. The authoritative test for whether Repository Engineering itself is finished is the SQL Readiness Criteria below, not the percentage.
4. `## SQL Readiness Criteria` — Packages 1–5 (Authority, State, Entry Point, Dead Reference, Compatibility Adapters) `Complete`; `manifest.md`'s Current Development Status accurate; the roadmap's Phase 2 entry accurate; no unqualified-authority collision remains; at least one Compatibility Adapter exists and redirects correctly.

## Acceptance Criteria
- [ ] The document exists and contains all four sections, in order.
- [ ] The Program Table lists all nine current program items, each Status cell pointing to a Change Request or stating "not yet drafted" — never a restated status word.
- [ ] The SQL Readiness Criteria are stated in full.
- [ ] No file outside Scope was created or modified.

## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request, before
IMPLEMENT is considered complete, per synchronization as defined in AGENTS.md's Agent Handoff
Protocol — this file is always implicitly in scope for this section.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]

## Verification Notes

[Appended by the reviewing agent (Tier 1) after independently re-checking the Execution Log
against the live repository state. Append-only — never edit or delete a prior entry.]

## Review Gate
- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied.
- [ ] No file outside the Scope list was modified or created.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] The repository is in a clean, releasable state.
