# Change Request — SPEC-084

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Objective

Canonicalize the active operating model into the repository so a completely fresh engineering session bootstraps from `AGENTS.md` alone — no prior conversation, memory, or `/resume` — and remove the stale operational artifacts that contradicted it.

---

## Business Reason

The active operating model (execution-first default, standing authorities, significance tiering, Earn-It, Design Review/Challenge, Excellence Check, autonomous completion, phase-transition checkpoints, precedence order) lived only in per-machine `.claude` memory, while the repository's operational files still described the superseded conservative model (default ANALYZE, stop after each task, human-only Complete). A fresh session — or any teammate/agent — reading the repo would operate under the wrong rules and could not even reproduce how SPEC-081/082/083 were completed. This is the governance-canonicalization step deferred in memory `governance-model-and-tiering` until "~2–3 stable phases"; the owner has explicitly fired that trigger and prioritized repository-as-operational-memory. Research confirmed the proven pattern: `AGENTS.md` (Linux Foundation-stewarded, 28+ tools, 60k+ repos) as the execution brain + progressive disclosure — no new document invented.

---

## Risks

Governance-document redesign. Mitigations: completed CRs are append-only history and were not modified; only live cross-references were repointed (`TEMPLATE.md` → `CR_LIFECYCLE.md §8`); the CR state machine and command vocabulary were relocated (not deleted) into their rightful owner `CR_LIFECYCLE.md`; the change is documentation-only (no SQL / no schema), verified by a cold-boot read-through simulating a fresh session.

---

## Supersedes / Depends On

None. (Firing the deferral recorded in memory `governance-model-and-tiering`; supersedes no CR file.)

---

## Scope — Files Allowed to Modify

- AGENTS.md
- CR_LIFECYCLE.md
- README.md
- PROTOCOL.md
- changes/TEMPLATE.md
- _ORVION_CANONICAL/32_execution_roadmap.md
- _ORVION_CANONICAL/manifest.md
- scripts/repository-all.ps1
- project-tree.txt (delete)
- git-tree.txt (delete)
- tracked-files.txt (delete)
- changes/SPEC-084-operational-layer-continuity.md

---

## Out of Scope — Files Forbidden to Modify

- Any `supabase/migrations/**` file (no schema change).
- Any completed `changes/SPEC-0*.md` other than this one (append-only history).
- `_ORVION_CANONICAL/00`–`31`, `33`, `34`, `35`, `codex.md`, `SYSTEM_PROMPT.md`.
- `global-rules.md`, `CODING_STANDARDS.md`, `PROJECT_CONTEXT.md`, `repository-index.md`.

---

## Minimum Reading List

- AGENTS.md
- CR_LIFECYCLE.md
- README.md
- PROTOCOL.md
- changes/TEMPLATE.md
- _ORVION_CANONICAL/manifest.md
- _ORVION_CANONICAL/32_execution_roadmap.md

---

## Implementation Steps

1. Rewrite `AGENTS.md` as the lean, imperative operating model / execution brain: precedence; execution-first + five stop-triggers; capability-as-unit; standing authorities (implementation-choice autonomy, autonomous completion + boundary, boy-scout); Earn-It; significance tiering; workflow stages (incl. Learn-Before-Designing, Design Challenge, Excellence Check, phase-transition checkpoint); boot sequence; guardrails; tool-file rule; maintenance rule. Remove the ANALYZE-default/stop-after-each-task/human-only-Complete text and the relocated CR command mechanics.
2. Rewrite `CR_LIFECYCLE.md` to OWN the CR state machine, command vocabulary, and canonical IMPLEMENT/Synchronization definitions relocated from `AGENTS.md`; update the responsibility table + state machine so `In Progress → Complete` is the executing agent's when verified and no new decision (else human), `Cancelled` human-only.
3. Repoint the two live references in `changes/TEMPLATE.md` from "AGENTS.md's Agent Handoff Protocol" to `CR_LIFECYCLE.md §8`, and reconcile the Review Gate header with autonomous completion.
4. Replace README's "First Reading Order" with a state-driven "Boot Sequence" routing through `AGENTS.md` → manifest → active CR / roadmap → task canon.
5. Reconcile `PROTOCOL.md` Principles: remove "Stop after completing"/"Never continue automatically"; defer execution posture to `AGENTS.md`.
6. Correct `_ORVION_CANONICAL/32_execution_roadmap.md` phase table (Phases 3–5 → Complete, Phase 6 → Active) and "Immediate Next Action" (→ Phase 6 Finance Core, derived `customer_balance()`).
7. Update `_ORVION_CANONICAL/manifest.md` Current Development Status to Phase 6, with this CR active.
8. Remove tree/tracked-file generation from `scripts/repository-all.ps1` and delete `project-tree.txt`, `git-tree.txt`, `tracked-files.txt`.

---

## Acceptance Criteria

- [x] `AGENTS.md` describes the active operating model (execution-first, tiering, Earn-It, Design Challenge, Excellence Check, autonomous completion, boot sequence) and contains no ANALYZE-default / stop-after-each-task / "no agent may Complete" text.
- [x] `CR_LIFECYCLE.md` contains the command vocabulary + IMPLEMENT/Synchronization definitions and permits autonomous `In Progress → Complete` (verified, no new decision); `Cancelled` remains human-only.
- [x] No live document points to a now-removed "AGENTS.md Agent Handoff Protocol" section (`TEMPLATE.md` repointed to `CR_LIFECYCLE.md §8`); completed CRs left unmodified.
- [x] README leads a fresh reader through the boot sequence starting at `AGENTS.md`.
- [x] `PROTOCOL.md` no longer asserts "Never continue automatically".
- [x] Roadmap phase table and Immediate Next Action reflect Phase 6 active; manifest reflects Phase 6.
- [x] `project-tree.txt`, `git-tree.txt`, `tracked-files.txt` are deleted and no longer generated by `scripts/repository-all.ps1`.
- [x] Cold-boot simulation (read only README → AGENTS → manifest → roadmap) yields correct understanding of vision, phase, next capability, governance, authorities, approval model, and next task.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), owner-directed (C1–C5)

Outcome: Complete

Step results:
- Step 1: Applied — `AGENTS.md` rewritten as lean operating model (~120 lines, single H1, imperative).
- Step 2: Applied — `CR_LIFECYCLE.md` now owns state machine + command vocabulary + IMPLEMENT/Synchronization; autonomous-Complete encoded in §5/§9/§10.
- Step 3: Applied — `TEMPLATE.md` two pointers repointed to `CR_LIFECYCLE.md §8`; Review Gate header reconciled.
- Step 4: Applied — README "Boot Sequence" replaces "First Reading Order".
- Step 5: Applied — `PROTOCOL.md` Principles reconciled (defers execution posture to `AGENTS.md`).
- Step 6: Applied — roadmap Phases 3–5 → Complete, Phase 6 → Active; Immediate Next Action → Phase 6 `customer_balance()`.
- Step 7: Applied — manifest Current Development Status → Phase 6, SPEC-084 active.
- Step 8: Applied — tree generation removed from `scripts/repository-all.ps1`; three tree files `git rm`-ed.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8), cold-boot simulation

Verdict: Confirmed Complete

Findings: Simulated a fresh session reading only the boot chain. README → `AGENTS.md` yields the operating model (execution-first, tiering, Earn-It, autonomous completion, stop-triggers) and the boot sequence. `AGENTS.md` → `manifest.md` yields current state: Phase 6 Finance Core, Active CR = SPEC-084, next capability = derived `customer_balance()`. `manifest` → `32_execution_roadmap.md` confirms Phases 2–5 Complete, Phase 6 Active, and the same next slice. CR mechanics resolve correctly from `AGENTS.md` → `CR_LIFECYCLE.md` (no dangling pointer). No live document teaches the superseded model. Grep confirms only completed (append-only) CRs still mention the old "Agent Handoff Protocol", which is correct history. Cold-boot understanding is complete and self-consistent without conversation history.

Recommendation to human: Set Status to Complete (satisfied autonomously per `CR_LIFECYCLE.md §5` — no new architectural decision; the canonicalization was an explicit owner decision).

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside the Scope list was modified or created.
- [x] No completed CR (append-only history) was altered.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On: None — nothing to update.
- [x] The repository is in a clean, releasable state.

---

## Notes

Deferred (recorded for their triggers, not done here): `TEMPLATE.md`'s legacy "Assigned Model Tier" (Tier-1/Tier-2 local-executor) section — trigger: next `TEMPLATE.md` edit; `repository-index.md` is canonical-only and misnamed — trigger: next `scripts/repository-all.ps1` edit or a dedicated cleanup; re-homing the governance `.claude` memories as thin pointers into `AGENTS.md` — trigger: immediately after this CR verifies.
