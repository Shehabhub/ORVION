# Change Request — SPEC-018

## Status
[x] Approved

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
- [ ] README.md's Reading Order no longer references SYSTEM_PROMPT.md.
- [ ] It states active-CR routing, roadmap fallback, layer-based canonical routing, reports/, and generated artifacts, in that order.
- [ ] No other section of README.md is changed.

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
