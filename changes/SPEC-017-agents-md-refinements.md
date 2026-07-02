# Change Request — SPEC-017

## Status
[x] Approved

## Assigned Model Tier
[x] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

## Objective
Add two small refinements to AGENTS.md's Agent Handoff Protocol, both identified during the post-SPEC-012/013/014 execution retrospective: transcribe the commit-attribution message format, and sharpen Complete's Current Task update to require naming the next dependency-ready package(s), not merely describing what just finished.

## Business Reason
Both gaps were found by direct observation during three live executions, not by design review. The commit-message format has been followed correctly only because this session had access to the original report; a participant reading only AGENTS.md would not know it exists. Complete's Current Task update is accurate today only because it was written with full context; nothing structurally requires a future execution to state what's next, only what just happened.

## Risks
None. Both additions are transcription/clarification of already-established, already-proven practice — no new rule, no new judgment.

## Supersedes / Depends On
Supersedes: None. Depends on: SPEC-012 must already be Complete — confirmed.

## Scope — Files Allowed to Modify
- AGENTS.md

## Out of Scope — Files Forbidden to Modify
Scope above is exhaustive. Every other file, explicitly including CR_LIFECYCLE.md, PROTOCOL.md, changes/TEMPLATE.md.

## Minimum Reading List
- AGENTS.md
- reports/repository-communication-protocol.md

## Implementation Steps

### Step 1 — Transcribe the commit-attribution format
Verify: search AGENTS.md for the exact string `human-directed and which command triggered it`. If found: Already Applied, skip. If not found: add one bullet to the Agent Handoff Protocol, after the six command bullets: "Every commit produced in response to a human command states, in its message, that it was human-directed and which command triggered it — e.g. `SPEC-NNN: Approve (human command)` — distinct from an agent's own step-execution or analytical commits."

### Step 2 — Sharpen Complete's Current Task clause
Verify: search AGENTS.md for the exact string `naming the next dependency-ready package`. If found: Already Applied, skip. If not found: in the existing `Complete SPEC-NNN` bullet, extend "updates `manifest.md`'s `Current Task` and `Last Completed Task` fields to reflect this Change Request" to "...reflect this Change Request, naming the next dependency-ready package(s) if any are known."

## Acceptance Criteria
- [ ] The commit-attribution bullet is present, worded as specified.
- [ ] The Complete bullet's Current Task clause requires naming next dependency-ready work.
- [ ] No other line in AGENTS.md is changed.

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
