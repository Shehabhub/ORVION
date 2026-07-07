# Change Request — SPEC-090

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Objective

Make the minimal-context, precedent-first discipline explicit in the `AGENTS.md` §3 Design Review stage — the one genuine delta from the Standard Capability Workflow proposal.

---

## Business Reason

Design Challenge on two owner proposals, researched against 2026 practice (spec-driven / skill-engineering standardization; Definition-of-Done handoff criteria). **Proposal 2 (capability completion check)** is already implemented verbatim as the `AGENTS.md` §5 recoverability self-test (SPEC-086) — no change; re-adding would duplicate it. **Proposal 1 (standard capability workflow)** is already encoded by `AGENTS.md` §3 stages + §1; a parallel numbered list would fragment the single source. The only new, valuable element is steps 2–4 (read only relevant canon, read only required schema, look for existing precedents) — the discipline that made SPEC-089 correct-and-cheap (reusing the `lead_booking_readiness` read-RPC precedent avoided inventing a needless permission). Folded into §3 as one clause; no new list, stage, or document.

---

## Risks

None material. One-clause addition to an existing workflow stage. No schema, no behavior change.

---

## Supersedes / Depends On

Depends on SPEC-084 (AGENTS.md operating model) and SPEC-086 (§5 self-test, which already satisfies Proposal 2). Supersedes nothing.

---

## Scope — Files Allowed to Modify

- AGENTS.md
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-090-design-review-minimal-context.md

---

## Out of Scope — Files Forbidden to Modify

- Any `supabase/migrations/**`, any completed `changes/SPEC-0*.md` other than this one, CR_LIFECYCLE.md, README.md, PROTOCOL.md, changes/TEMPLATE.md, PROJECT_CONTEXT.md, `_ORVION_CANONICAL/32_execution_roadmap.md`, reports/**.

---

## Minimum Reading List

- AGENTS.md

---

## Implementation Steps

1. Expand `AGENTS.md` §3 stage 3 (Design Review) to require gathering minimum context first — read only the relevant canonical docs and required schema/migrations, and look for an existing precedent to reuse — before confirming canonical fit.

---

## Acceptance Criteria

- [x] `AGENTS.md` §3 stage 3 states the minimal-context, precedent-first discipline.
- [x] No parallel workflow list, new stage, or new document introduced (Proposal 1 folded into the existing stage).
- [x] Proposal 2 confirmed already covered by `AGENTS.md` §5; no duplicate added.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), owner-directed (Proposals 1–2 Design Challenge)

Outcome: Complete

Step results:
- Step 1: Applied — `AGENTS.md` §3 stage 3 expanded with minimal-context + precedent-first reading.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: `AGENTS.md` §3 stage 3 now names the discipline (read only relevant canon + required schema; reuse precedent). Confirmed Proposal 2 is already present at `AGENTS.md` §5 (the cold-stop self-test) — no duplicate added. No new list/stage/document; single-source preserved.

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

Proposal 1 adopted as a one-clause refinement (not a parallel workflow); Proposal 2 proven already-implemented and left unchanged. Returning to Phase 6 Finance Core.
