# Change Request — SPEC-013

## Status
[x] In Progress

## Assigned Model Tier
[x] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

Note, matching the SPEC-009 precedent: introducing "Active" as a new status word in 32_execution_roadmap.md's minimal vocabulary requires a small amount of wording judgment, not mechanical substitution.

## Objective
Correct manifest.md's Current Development Status and 32_execution_roadmap.md's Phase 2 status and Immediate Next Action to reflect that SQL migration planning (SPEC-007) and the identity/RLS decision (SPEC-009) are complete, and that SQL migration authoring is the remaining Phase 2 work — and fix manifest.md's now-dangling "Loaded After: codex.md" header reference.

## Business Reason
manifest.md and 32_execution_roadmap.md are the two documents whose staleness first evidenced the exact failure this entire Repository Engineering effort exists to prevent: completed work (SPEC-007, SPEC-009) whose repository state was never updated to reflect it. SPEC-012 already wrote the rule that keeps this correct going forward (Complete's extended definition, updating manifest.md's fields as part of the same command). This package performs the one-time correction of what predates that rule — the two are complementary, not redundant: SPEC-012 is the mechanism, this is the data fix the mechanism didn't retroactively apply to.

## Risks
None. Purely descriptive correction to two documents' status fields. No table, schema, or business-domain decision is touched.

## Supersedes / Depends On
Supersedes: None.
Depends on: SPEC-012 must already be Complete — confirmed. Not because this package's content depends on SPEC-012's specific text, but because the guarantee that this correction stays correct going forward depends on the rule SPEC-012 wrote.

## Scope — Files Allowed to Modify
- _ORVION_CANONICAL/manifest.md
- _ORVION_CANONICAL/32_execution_roadmap.md

## Out of Scope — Files Forbidden to Modify
Scope above is exhaustive. Explicitly includes: AGENTS.md, README.md, CR_LIFECYCLE.md, `33_sql_migration_plan.md` (referenced, not restated), every other `_ORVION_CANONICAL/**` file, `changes/**`, `reports/**`.

## Minimum Reading List
- _ORVION_CANONICAL/manifest.md
- _ORVION_CANONICAL/32_execution_roadmap.md
- _ORVION_CANONICAL/33_sql_migration_plan.md
- changes/SPEC-007-sql-migration-plan.md
- changes/SPEC-009-identity-auth-rls-decision.md

## Implementation Steps

### Step 1 — Bump 32_execution_roadmap.md's version marker
Verify: search for the exact line `Version: 0.2`. If found: Already Applied, skip. If not found (`Version: 0.1`): replace with `Version: 0.2`.

### Step 2 — Correct Phase 2's status
Verify: search `# Phase 2: Database Foundation` for the exact string `Status: Active`. If found: Already Applied, skip. If not found: locate `Status: Pending` immediately under `# Phase 2: Database Foundation` and replace with `Status: Active`. Also remove the now-satisfied line `Do not begin until Phase 1 is reviewed.` since Phase 1's status already reads `Complete`.

### Step 3 — Correct the Immediate Next Action
Verify: search for the exact string `Write SQL migrations in the sequence defined in`. If found: Already Applied, skip. If not found: replace the `# Immediate Next Action` section's content (`Create SQL migration plan.` / `This is the first required document in the database foundation package.`) with `Write SQL migrations in the sequence defined in \`33_sql_migration_plan.md\`. The plan itself is complete; no further planning document is required before authoring begins.`

### Step 4 — Correct manifest.md's Current Development Status
Verify: search for the exact string `Current Phase: Database Foundation`. If found: Already Applied, skip. If not found: replace `Current Phase: Database-Ready Specification` with `Current Phase: Database Foundation`; replace `Current Sprint: SQL migration planning` with `Current Sprint: SQL migration authoring`; replace `Current Module: Database specification preparation` with `Current Module: Database Foundation`.

### Step 5 — Correct manifest.md's Next Planned Task
Verify: search for the exact string `Write SQL migrations per 33_sql_migration_plan.md`. If found: Already Applied, skip. If not found: replace `Next Planned Task: Create SQL migration plan` with `Next Planned Task: Write SQL migrations per 33_sql_migration_plan.md's sequence`.

### Step 6 — Fix manifest.md's dangling codex.md reference (Engineering Observation)
Verify: search for the exact string `Loaded After: codex.md`. If found: replace with `Loaded After: AGENTS.md` (codex.md is deprecated per SPEC-012; AGENTS.md is the correct operational-authority predecessor). If not found: Already Applied, skip.

## Acceptance Criteria
- [ ] `32_execution_roadmap.md` reads `Version: 0.2`.
- [ ] Phase 2's status reads `Active`, and the now-satisfied "Do not begin until Phase 1 is reviewed" line is removed.
- [ ] The Immediate Next Action section references `33_sql_migration_plan.md` rather than restating a plan that already exists.
- [ ] manifest.md's Current Phase/Sprint/Module reflect Phase 2 / Database Foundation / SQL migration authoring.
- [ ] manifest.md's Next Planned Task references `33_sql_migration_plan.md`.
- [ ] manifest.md's header no longer references `codex.md`.
- [ ] No file outside Scope was modified.
- [ ] No table, schema, or business-domain decision was altered.

## Execution Log

### 2026-07-02 19:55 — Claude (Sonnet 5)

Outcome: Complete

Step results:
- Step 1: Applied — 32_execution_roadmap.md version bumped 0.1 -> 0.2.
- Step 2: Applied — Phase 2 status changed Pending -> Active; the now-satisfied "Do not begin until Phase 1 is reviewed" line removed.
- Step 3: Applied — Immediate Next Action now references 33_sql_migration_plan.md instead of restating a plan that already exists.
- Step 4: Applied — manifest.md's Current Phase/Sprint/Module updated to Database Foundation / SQL migration authoring / Database Foundation.
- Step 5: Applied — manifest.md's Next Planned Task now references 33_sql_migration_plan.md.
- Step 6: Applied — manifest.md's header now reads "Loaded After: AGENTS.md".

Commits: pending — recorded at commit time in the same commit as this entry.

Verification performed before this entry: `git status --porcelain` confirmed exactly the two Scope files changed; `git diff --stat` confirmed no unexpected file touched.

## Verification Notes

[Appended by the reviewing agent (Tier 1) after independently re-checking the Execution Log
against the live repository state. Append-only — never edit or delete a prior entry.]

## Review Gate
- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied.
- [ ] No file outside the Scope list was modified or created.
- [ ] No section was added, removed, or restructured outside the approved steps.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] Any step that could not be resolved deterministically was reported, not guessed.
- [ ] Confirmed SPEC-012 was already Complete before this task began.
- [ ] The repository is in a clean, releasable state.

## Notes
Step 6 is an Engineering Observation folded directly into this package, per the triage rule established during the Execution Contract review: it touches the same file already in Scope and requires no judgment beyond what this package already decides. `33_sql_migration_plan.md` itself is not modified by this package — its content is referenced, not restated, consistent with Define Once, Reference Everywhere.
