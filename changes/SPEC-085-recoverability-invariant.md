# Change Request — SPEC-085

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Objective

Codify a git-native recoverability invariant so the repository stays recoverable at *every* stop — not only at `Complete` or phase-end — closing the mid-capability interruption gap.

---

## Business Reason

SPEC-084 made a fresh session bootstrap from the repository, but synchronization discipline was defined only at `Complete`/phase-end. A session that stops mid-capability (context limit, crash, IDE/machine restart, agent/conversation switch) left the manifest pointing at an in-progress CR whose Execution Log was written only at IMPLEMENT-end — recoverable from git, but by reconstruction, not cold boot. Design Challenge + research (durable-execution / checkpoint-before-suspend; atomic commits leaving a working state after each commit) confirmed the principle is established practice. Strongest practical solution for a git repo (not an agent runtime) is the git-native expression using artifacts we already have — git history + `manifest.md` + the CR living artifact — with no new mechanism or document.

---

## Risks

None material. Two additive paragraphs to existing governance docs; no schema, no behavior change, no new file beyond this CR. Rejected the over-engineered alternatives (session-state file, resume-log, heartbeat, continuous audit) as Earn-It failures that duplicate git and add friction.

---

## Supersedes / Depends On

Depends on SPEC-084 (operating model canonicalized into `AGENTS.md` / `CR_LIFECYCLE.md`). Supersedes nothing.

---

## Scope — Files Allowed to Modify

- AGENTS.md
- CR_LIFECYCLE.md
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-085-recoverability-invariant.md

---

## Out of Scope — Files Forbidden to Modify

- Any `supabase/migrations/**`, any completed `changes/SPEC-0*.md` other than this one, README.md, PROTOCOL.md, changes/TEMPLATE.md, `_ORVION_CANONICAL/32_execution_roadmap.md`.

---

## Minimum Reading List

- AGENTS.md
- CR_LIFECYCLE.md

---

## Implementation Steps

1. Add a "Recoverable at every stop" guardrail bullet to `AGENTS.md` §5: durable state = git + manifest + active CR living artifact (never conversation); every commit leaves a recoverable state; before any non-trivial pause, commit atomically and make the manifest Active CR + the CR Execution Log reflect the true current step; commit often (git cannot recover uncommitted work).
2. Add a paragraph to `CR_LIFECYCLE.md` §6 permitting incremental append of the Execution Log at meaningful checkpoints during a long IMPLEMENT, referencing the `AGENTS.md` §5 invariant; final synchronization unchanged.

---

## Acceptance Criteria

- [x] `AGENTS.md` §5 states the recoverability invariant covering *every* stop, git-native, with "commit often".
- [x] `CR_LIFECYCLE.md` §6 permits incremental Execution Log checkpoints and cross-references the invariant.
- [x] No new mechanism/file introduced beyond this CR; no schema change.
- [x] Cold-boot chain remains consistent (README → AGENTS → manifest → active CR).

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), owner-directed (Observations 1–3)

Outcome: Complete

Step results:
- Step 1: Applied — recoverability-invariant bullet added to `AGENTS.md` §5.
- Step 2: Applied — incremental-checkpoint paragraph added to `CR_LIFECYCLE.md` §6.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Re-read both edited sections against the live repo. `AGENTS.md` §5 now generalizes the former "releasable state (completed task)" rule to a recoverability invariant covering any interruption, expressed via existing artifacts. `CR_LIFECYCLE.md` §6 permits incremental Execution Log checkpoints and points to the invariant; final-synchronization semantics unchanged. No new file/mechanism. Boot chain unchanged and consistent.

Recommendation to human: Set Status to Complete (autonomous per `CR_LIFECYCLE.md` §5 — no new architectural decision; git-native codification of an owner-validated principle).

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified or created.
- [x] No completed CR (append-only history) was altered.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On handled (depends on SPEC-084; supersedes nothing).
- [x] The repository is in a clean, releasable state.

---

## Notes

Observations 1–3 proven correct and adopted git-natively. Over-engineered variants (dedicated checkpoint/session-state file, resume-log, heartbeat, continuous sync-audit on every micro-pause) evaluated and rejected under Earn-It as duplicating git and adding friction the owner explicitly wants removed.
