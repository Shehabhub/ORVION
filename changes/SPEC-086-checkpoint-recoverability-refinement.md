# Change Request — SPEC-086

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Objective

Sharpen the `AGENTS.md` §5 recoverability invariant to define durability around meaningful engineering checkpoints (commit as mechanism) and to state the memory-is-cache-never-sole-source rule — closing the one remaining continuity gap.

---

## Business Reason

Design Challenge on owner observations 1–7, validated against current practice (durable execution defines checkpoints at side-effect/step boundaries — a commit is the mechanism, not the definition; Definition-of-Done is the checkpoint discipline; over-documentation is the named anti-pattern). Observations proved correct but mostly already satisfied by SPEC-084/085. The genuine deltas: (1) recoverability is stronger when defined around *meaningful checkpoints* than around a "commit often" timer; (2) the memory-as-cache rule — no operational fact may live solely in external `.claude` memory — was the one linchpin of "repo = complete operational memory" not yet written. Both fit inside the existing §5 bullet; no new document, stage, or layer (rejected as over-documentation per Earn-It and observations 6–7). Cold-agent audit of `AGENTS.md` (observation 2) found no additional gap.

---

## Risks

None material. One re-worded guardrail bullet in `AGENTS.md`; no schema, no behavior change, net-flat size. Alternatives rejected under Earn-It: a separate "continuity check" stage/bullet (duplicates the invariant), any new checkpoint/state file (duplicates git).

---

## Supersedes / Depends On

Depends on SPEC-084 and SPEC-085. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- AGENTS.md
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-086-checkpoint-recoverability-refinement.md

---

## Out of Scope — Files Forbidden to Modify

- Any `supabase/migrations/**`, any completed `changes/SPEC-0*.md` other than this one, CR_LIFECYCLE.md, README.md, PROTOCOL.md, changes/TEMPLATE.md, `_ORVION_CANONICAL/32_execution_roadmap.md`.

---

## Minimum Reading List

- AGENTS.md

---

## Implementation Steps

1. Rewrite the `AGENTS.md` §5 "Recoverable at every stop" bullet to: define recoverability around meaningful engineering checkpoints (commit as the durability mechanism; git + manifest + CR living artifact as the only durable state); fold in the "if execution stopped right now, could a fresh session continue from the repo alone?" self-test as the checkpoint trigger; add the rule that external `.claude` memory is a cache only and no operational fact may live solely there.

---

## Acceptance Criteria

- [x] `AGENTS.md` §5 defines recoverability around meaningful checkpoints, with commit as the mechanism and git as the only source of truth.
- [x] The self-test ("stopped permanently right now, continue from the repository alone?") is present as the checkpoint trigger, without introducing a new workflow stage.
- [x] The memory-is-cache-never-sole-source rule is stated.
- [x] No new document, stage, or mechanism introduced beyond this CR.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), owner-directed (Observations 1–7)

Outcome: Complete

Step results:
- Step 1: Applied — `AGENTS.md` §5 recoverability bullet rewritten (checkpoint-defined durability + self-test trigger + memory-as-cache rule).

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Re-read `AGENTS.md` §5 against the live repo. The bullet now defines durability around meaningful checkpoints (verified migration / completed CR step / synchronized doc / phase transition) with the commit as mechanism; includes the cold-stop self-test as trigger; states memory-is-cache-never-sole-source and the uncommitted-work limitation. No new stage/document/layer. Cold-boot chain unchanged and consistent. Observation-2 cold-agent audit passed with no further gap.

Recommendation to human: Set Status to Complete (autonomous per `CR_LIFECYCLE.md` §5 — no new architectural decision; git-native refinement of an owner-validated principle).

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified or created.
- [x] No completed CR (append-only history) was altered.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On handled (depends on SPEC-084/085; supersedes nothing).
- [x] The repository is in a clean, releasable state.

---

## Notes

Observations 1, 3, 4 adopted inside the existing §5 bullet. Observation 2 (cold-agent audit) performed — no gap. Observations 5–7 (industry validation, simplicity, Earn-It) satisfied by making the smallest possible change and rejecting every additive alternative. This concludes the operating-model continuity work (SPEC-084 → 085 → 086); the repository is now the authoritative operational memory.
