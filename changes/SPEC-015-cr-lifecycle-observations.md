# Change Request — SPEC-015

## Status
[x] In Progress

## Assigned Model Tier
[x] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

## Objective
Add the Engineering Observation triage rule, and its methodology-specific sequencing clause, to `CR_LIFECYCLE.md` as a new §11.

## Business Reason
This rule has governed every package since it was established during the Execution Contract review, but has never been written into any canonical document — it exists only in conversation. `CR_LIFECYCLE.md` already claims to be "the single authoritative reference for the lifecycle of a Change Request," and Observation handling is a lifecycle concern its existing ten sections don't yet cover.

## Risks
None. Additive only; no existing section is altered.

## Supersedes / Depends On
Supersedes: None. Depends on: None.

## Scope — Files Allowed to Modify
- CR_LIFECYCLE.md

## Out of Scope — Files Forbidden to Modify
Scope above is exhaustive. Explicitly includes AGENTS.md, PROTOCOL.md, changes/TEMPLATE.md, and every other file.

## Minimum Reading List
- CR_LIFECYCLE.md

## Implementation Steps

### Step 1 — Add §11 Engineering Observations
Verify: search for the exact heading `## 11. Engineering Observations`. If found: Already Applied, skip. If not found: append, after §10's closing code fence:

```
## 11. Engineering Observations

A discovery made during IMPLEMENT or REVIEW that was not anticipated by the Change Request's own Implementation Steps is recorded as an Engineering Observation — what was discovered, why it matters, and which of two outcomes applies. It stays inside the current Change Request only if it touches a file already in that Change Request's Scope, uses a mechanism the Change Request already relies on, and requires no judgment beyond what the Change Request was already drafted to make — and only if flagged before that Change Request is Approved, never added silently afterward. Otherwise it becomes its own future Change Request. An Engineering Observation is never silently implemented and never silently discarded.

An Observation concerning the engineering methodology itself — as distinct from repository content — never interrupts the Change Request that surfaced it. The current Change Request always completes its own lifecycle normally first; only afterward is a methodology refinement considered, and only through its own Change Request. The methodology does not change inside an implementation package.
```

### Step 2 — Reflect the expanded scope in §1 Purpose
Verify: search for the exact string `and the responsibility for each transition, and how mid-execution discoveries are handled`. If found: Already Applied, skip. If not found: in §1, replace `its states, allowed transitions, and the responsibility for each transition.` with `its states, allowed transitions, and the responsibility for each transition, and how mid-execution discoveries are handled.`

## Acceptance Criteria
- [x] §11 exists, contains both the triage rule and the methodology-sequencing clause, worded exactly as specified.
- [x] §1's Purpose sentence reflects the expanded scope.
- [x] No existing section (1–10) is otherwise altered.
- [x] No file outside Scope was modified.

## Execution Log

### 2026-07-02 20:20 — Claude (Sonnet 5)

Outcome: Complete

Step results:
- Step 1: Applied — §11 Engineering Observations added, worded exactly as specified.
- Step 2: Applied — §1's Purpose sentence extended to mention mid-execution discovery handling.

Commits: pending — recorded at commit time in the same commit as this entry.

Verification performed before this entry: `git status --porcelain` confirmed exactly the one Scope file changed.

## Verification Notes

### 2026-07-02 20:21 — Claude (Sonnet 5)

Verdict: Confirmed Complete

Findings: `git diff c06ccf9 HEAD` on CR_LIFECYCLE.md matches both Implementation Steps exactly. No file outside Scope touched.

Recommendation to human: Set Status to Complete

## Review Gate
- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied.
- [x] No file outside the Scope list was modified or created.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

## Notes
This formalizes a rule that has already governed SPEC-012 through SPEC-014's drafting in practice — transcription of proven behavior, matching the same justification used for adopting the Command Vocabulary in SPEC-012.
