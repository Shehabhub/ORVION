# Change Request — SPEC-092

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Objective

Add one clarifying clause to `AGENTS.md` §1: a decision that follows from an already-approved ADR/canon/owner-decision is implementation (execute the strongest option), not an escalation.

---

## Business Reason

Design Challenge on the owner's execution-continuity proposal: the principle ("once a direction is approved, implementation decisions that follow continue autonomously until a genuine escalation") is correct and already encoded in `AGENTS.md` §1 (no routine confirmations) and §2 (implementation-choice autonomy). It survived the attempt to disprove it: the recent pause on the negative-balance risk-flag semantics was carried-over caution, not a governance requirement — block-unless-permitted is derivable from ADR-0020 + the existing `ALLOW_ISSUE_WITH_NEGATIVE_BALANCE` permission. Nothing to add to the model; the fix is behavioral. The one clause earns its place only because the miscalibration recurred (pausing on ADR-covered work) — "when it happens twice, add a line." No new stage or workflow.

---

## Risks

None. One clarifying sentence in an existing section; no schema, no workflow change.

---

## Supersedes / Depends On

Depends on SPEC-084 (operating model). Supersedes nothing.

---

## Scope — Files Allowed to Modify

- AGENTS.md
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-092-autonomous-execution-clarification.md

---

## Out of Scope — Files Forbidden to Modify

- Any `supabase/migrations/**`, any completed `changes/SPEC-0*.md` other than this one, CR_LIFECYCLE.md, README.md, PROTOCOL.md, changes/TEMPLATE.md, PROJECT_CONTEXT.md, `_ORVION_CANONICAL/32_execution_roadmap.md`, reports/**.

---

## Minimum Reading List

- AGENTS.md

---

## Implementation Steps

1. Add to `AGENTS.md` §1 the clause distinguishing a decision that follows from an approved ADR/canon/owner-decision (implementation — choose the strongest supported option and continue) from a genuinely new direction (escalation).

---

## Acceptance Criteria

- [x] `AGENTS.md` §1 states that decisions following from approved ADR/canon/owner-decision are implementation, not escalation.
- [x] No new governance stage or workflow introduced.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), owner-directed (execution-continuity proposal)

Outcome: Complete

Step results:
- Step 1: Applied — clarifying clause added to `AGENTS.md` §1.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: `AGENTS.md` §1 now explicitly frames approved-direction decisions as execution, escalation as reserved for new direction. Consistent with §2 implementation-choice autonomy; no duplication of a stage. Behavioral adoption: proceeding autonomously with the booking-transition capability (block-unless-permitted risk-flag semantics) without further routine approval.

Recommendation to human: Set Status to Complete (autonomous per `CR_LIFECYCLE.md` §5).

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

Execution is the default again. Immediately continuing the roadmap: the finance-gated booking-level transitions, recording ADR-0022 and implementing autonomously slice-by-slice.
