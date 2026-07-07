# Change Request — SPEC-091

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Objective

Fix the manifest "next capability" synchronization at its root so it can never point to a completed capability, and broaden `AGENTS.md` §3 to use research as a graduated, on-demand Design Review tool.

---

## Business Reason

Owner observation: after SPEC-089 completed, the manifest's `Next capability` field still named `app.customer_balance(...)` — a completed capability. Verified real (not a transcript artifact). Root cause: the manifest stated "next" in two places (a "Next:" clause inside Current Module and the standalone `Next capability` field), and `Complete` updated one but not the other — two sources of one fact drift. Fix the logic, not just the value: collapse to a single `Next capability` field and make updating it an explicit atomic part of the `Complete` command. Separately, owner proposal (validated against 2026 spec-driven / context-engineering practice): research should be a lightweight, graduated Design Review tool used whenever current evidence materially improves a decision — already present for major capabilities via Learn-Before-Designing; broadened here to on-demand for any decision, with no new stage or process.

---

## Risks

None material. Documentation/governance edits; no schema, no behavior change. The `Complete` rule change is additive discipline. Single-source consolidation removes a drift source.

---

## Supersedes / Depends On

Depends on SPEC-084 (operating model), SPEC-086 (§5 self-test). Supersedes nothing.

---

## Scope — Files Allowed to Modify

- AGENTS.md
- CR_LIFECYCLE.md
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-091-manifest-sync-and-research-tool.md

---

## Out of Scope — Files Forbidden to Modify

- Any `supabase/migrations/**`, any completed `changes/SPEC-0*.md` other than this one, README.md, PROTOCOL.md, changes/TEMPLATE.md, PROJECT_CONTEXT.md, `_ORVION_CANONICAL/32_execution_roadmap.md`, reports/**.

---

## Minimum Reading List

- AGENTS.md
- CR_LIFECYCLE.md
- _ORVION_CANONICAL/manifest.md

---

## Implementation Steps

1. `CR_LIFECYCLE.md` §9 `Complete` command: replace "updates manifest's Current Task/Last Completed fields, naming the next dependency-ready package(s)" with an explicit rule that Complete updates Current Module + Last Completed + `Next capability` together, repointing `Next capability` to the next dependency-ready package so it can never name a completed capability; note that `Next capability` is a single field and "next" is not restated elsewhere.
2. `_ORVION_CANONICAL/manifest.md`: remove the redundant "Next:" clause from Current Module (single-source), and correct `Next capability` to the real next work (finance-gated booking-level transitions + the now-unblocked negative-balance issuance risk flag).
3. `AGENTS.md` §3 stage 2: broaden Learn-Before-Designing into graduated, on-demand research (quick check for routine decisions touching fast-moving external surfaces; full study for major capabilities), verifying against official sources; not every task.

---

## Acceptance Criteria

- [x] `manifest.md` states "next" in exactly one place (the `Next capability` field); Current Module no longer contains a "Next:" clause.
- [x] `manifest.md` `Next capability` names real upcoming work, not a completed capability.
- [x] `CR_LIFECYCLE.md` §9 makes updating `Next capability` an explicit part of `Complete`.
- [x] `AGENTS.md` §3 stage 2 frames research as a graduated, on-demand Design Review tool without adding a stage or process.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), owner-directed (observation + proposal)

Outcome: Complete

Step results:
- Step 1: Applied — `CR_LIFECYCLE.md` §9 `Complete` now atomically updates Current Module + Last Completed + Next capability.
- Step 2: Applied — manifest Current Module "Next:" clause removed; `Next capability` corrected to the booking-level finance transitions + issuance risk flag.
- Step 3: Applied — `AGENTS.md` §3 stage 2 broadened to graduated on-demand research.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: manifest now has a single `Next capability` field naming real upcoming work (no completed-capability pointer; no duplicate "next" in Current Module). `CR_LIFECYCLE.md` §9 makes the `Next capability` update a mandatory, atomic part of `Complete` — structural prevention of the observed drift. `AGENTS.md` §3 stage 2 frames research as a graduated on-demand tool without a new stage. No schema/behavior change.

Recommendation to human: Set Status to Complete (autonomous per `CR_LIFECYCLE.md` §5 — no new architectural decision).

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

Manifest-sync fix is a root-cause (structural) correction, not just a value edit. Returning immediately to the roadmap: the next capability is the finance-gated booking-level transitions.
