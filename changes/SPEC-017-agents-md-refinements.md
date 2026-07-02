# Change Request — SPEC-017

## Status
[x] Complete

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
- [x] The commit-attribution bullet is present, worded as specified.
- [x] The Complete bullet's Current Task clause requires naming next dependency-ready work.
- [x] No other line in AGENTS.md is changed.

## Execution Log

### 2026-07-02 20:28 — Claude (Sonnet 5)

Outcome: Complete

Step results:
- Step 1: Applied — commit-attribution bullet added after the Freeze Phase N bullet.
- Step 2: Applied — Complete's Current Task clause extended to require naming next dependency-ready work.

Commits: pending — recorded at commit time in the same commit as this entry.

Verification performed before this entry: `git status --porcelain` confirmed exactly the one Scope file changed.

### 2026-07-02 — Complete (human command)

Phase-freeze check: not scoped to any roadmap phase — Repository Engineering work. Not applicable.

## Verification Notes

### 2026-07-02 20:29 — Claude (Sonnet 5)

Verdict: Confirmed Complete

Findings: `git diff 8b8bee5 HEAD` on AGENTS.md matches both Implementation Steps exactly. No other line changed, no file outside Scope touched.

Recommendation to human: Set Status to Complete

## Review Gate
- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied.
- [x] No file outside the Scope list was modified or created.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.
