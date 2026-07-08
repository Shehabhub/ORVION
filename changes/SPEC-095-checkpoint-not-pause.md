# Change Request — SPEC-095

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model

[ ] Tier 2 — Local execution agent (Qwen3.8B)

---

## Objective

Clarify AGENTS.md so the checkpoint/pause distinction is explicit: a completed, verified, synchronized capability continues directly to the next dependency-ready capability, and a Design Challenge resolves to an engineering decision rather than a question to the owner.

---

## Business Reason

Owner observation, evaluated and adopted after a Design Challenge (all points survived an attempt to disprove). §1 already forbids routine confirmations, yet execution drifted into a routine post-Complete pause ("Say the word") twice — evidence (not anticipation) that a one-line explicit reinforcement now earns its place. Separates *checkpoint* (repo sync + short status; always happens) from *pause* (stops for the owner; only on a genuine escalation condition), and reinforces that the Design Challenge produces reject/improve/confirm decisions. Governance-self-revising per AGENTS.md §3; lightest durable implementation.

---

## Risks

Negligible. Documentation-only clarification of the existing operating model; adds no new authority and removes none. Consistent with SPEC-090/SPEC-092 precedent for §1/§3 clarifications. No code, no schema.

---

## Supersedes / Depends On

Extends the §1 clarification of SPEC-092 (escalation vs implementation) and the sequencing-authority principle adopted in SPEC-093/094. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- AGENTS.md
- changes/SPEC-095-checkpoint-not-pause.md

---

## Out of Scope — Files Forbidden to Modify

- Any `supabase/migrations/**`; any `_ORVION_CANONICAL/**` (incl. the manifest — no state change: this is a methodology clarification, not a capability); CR_LIFECYCLE.md, README.md, PROTOCOL.md; any completed `changes/SPEC-0*.md`.

---

## Minimum Reading List

- AGENTS.md (§1 How execution flows; §3 stage 4 Design Challenge)

---

## Implementation Steps

1. In AGENTS.md §1, immediately before "**Stop only when one of these genuinely occurs:**", verify the phrase "A checkpoint is not a pause" is absent; add a paragraph defining checkpoint (always; never stops) vs pause (only on a stop condition) and stating that a Complete+verified+synced+committed capability continues directly to the next dependency-ready capability with no routine confirmation.
2. In AGENTS.md §3 stage 4 (Design Challenge), verify the phrase "reject, improve, or confirm" is absent; extend the "Output = short findings list" sentence so the output resolves to reject/improve/confirm and implement, with a question to the owner warranted only on a genuine architectural conflict.

---

## Acceptance Criteria

- [x] AGENTS.md §1 contains the "A checkpoint is not a pause" paragraph with the checkpoint vs pause definitions and the auto-continue rule.
- [x] AGENTS.md §3 stage 4 states the Design Challenge resolves to reject/improve/confirm and that a question to the owner is warranted only on a genuine architectural conflict.
- [x] No file outside AGENTS.md and this CR modified; no code/schema/manifest change.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8)

Outcome: Complete

Step results:
- Step 1: Applied — §1 "A checkpoint is not a pause" paragraph added before the stop-conditions list.
- Step 2: Applied — §3 stage 4 output clause extended to reject/improve/confirm + implement.

Verification: AGENTS.md re-read; both clauses present, lean, and consistent with the surrounding operating model. Documentation-only; no build/test surface.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Re-read AGENTS.md §1 and §3 stage 4. Both edits present, minimal, and non-contradictory with existing text (they sharpen, not replace, the standing "do not stop for routine confirmations" rule). Scope respected (only AGENTS.md + this CR). No new architectural decision — this records an owner-adopted methodology clarification.

Recommendation to human: Set Status to Complete (autonomous per `CR_LIFECYCLE.md` §5).

---

## Review Gate

- [x] Every change matches the Implementation Steps exactly.
- [x] No file outside the Scope list was modified or created.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On handled (nothing to supersede).
- [x] The repository is in a clean, releasable state.

---

## Notes

Methodology clarification (per CR_LIFECYCLE §11, handled as its own change, not folded into a capability CR). Booking-lifecycle capability flow (ADR-0020) resumes immediately after this at the Issue slice, now under the sharpened auto-continue rule.
