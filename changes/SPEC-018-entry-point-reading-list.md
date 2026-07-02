# Change Request — SPEC-018

## Status
[x] Complete

## Assigned Model Tier
[x] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

## Objective
Complete README.md's First Reading Order into a working repository-level Reading List — the Minimum Reading List pattern applied once at the entry point — connecting Authority, State, active-CR routing, roadmap fallback, layer-based canonical routing, reports/, and generated artifacts.

## Business Reason
Dependency-satisfied now that SPEC-012 (Authority) and SPEC-013 (State) are both Complete. Checked directly: README's current Reading Order still names SYSTEM_PROMPT.md (deprecated by SPEC-012) and stops at "relevant canonical documents," omitting active-CR routing, the roadmap fallback, reports/, and generated artifacts entirely.

## Risks
None. Documentation-only change to one file.

## Supersedes / Depends On
Supersedes: None. Depends on: SPEC-012, SPEC-013 — both Complete, confirmed.

## Scope — Files Allowed to Modify
- README.md

## Out of Scope — Files Forbidden to Modify
Every other file, explicitly including AGENTS.md, manifest.md, CR_LIFECYCLE.md.

## Minimum Reading List
- README.md
- AGENTS.md

## Implementation Steps

### Step 1 — Replace the First Reading Order section
Verify: search README.md for the exact string `check manifest.md's Active Change Request`. If found: Already Applied, skip. If not found: replace the existing "First Reading Order" list with:

```
1. `AGENTS.md` — operational authority; states what governs conduct.
2. `_ORVION_CANONICAL/manifest.md` — current phase, current task. If Active Change Request is not `None`, read that Change Request next; its own Minimum Reading List takes over from here.
3. If Active Change Request is `None`, check `_ORVION_CANONICAL/32_execution_roadmap.md` for the current phase and next planned work.
4. Canonical documents relevant to the current task only: `_ORVION_CANONICAL/00`-`23` for business/domain rules, `_ORVION_CANONICAL/24`-`33` for schema/database structure.
5. `reports/` — narrative rationale and the Repository Engineering program plan; read only when the "why" behind a decision is needed.
6. Generated artifacts (project tree, tracked files, Repository Index once available) — read only when locating something by name rather than by task.
```

## Acceptance Criteria
- [x] README.md's Reading Order no longer references SYSTEM_PROMPT.md.
- [x] It states active-CR routing, roadmap fallback, layer-based canonical routing, reports/, and generated artifacts, in that order.
- [x] No other section of README.md is changed except the Engineering-Observation fix to Project Status (recorded above).

## Execution Log

### 2026-07-02 20:32 — Claude (Sonnet 5)

Outcome: Complete

Step results:
- Step 1: Applied — First Reading Order replaced exactly as specified.

Engineering Observation, folded into this package per the Observation triage rule: README.md's `## Project Status` section separately stated `Current Phase: SQL Migration Planning` — the same duplicated-state pattern SPEC-013 already fixed once in manifest.md, now stale in exactly the same way. Same file already in Scope, no new judgment (mirrors SPEC-013's already-made decision). Fixed to reference manifest.md's Current Development Status instead of restating a copy.

Commits: pending — recorded at commit time in the same commit as this entry.

Verification performed before this entry: `git status --porcelain` confirmed exactly the one Scope file changed.

### 2026-07-02 — Complete (human command)

Phase-freeze check: not scoped to any roadmap phase — Repository Engineering work. Not applicable.

## Verification Notes

### 2026-07-02 20:33 — Claude (Sonnet 5)

Verdict: Confirmed Complete

Findings: `git diff 6f61199 HEAD` on README.md matches Step 1 exactly and shows the recorded Engineering Observation fix (Project Status now references manifest.md instead of restating a stale copy). No file outside Scope touched.

Recommendation to human: Set Status to Complete

## Review Gate
- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied.
- [x] No file outside the Scope list was modified or created.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.
