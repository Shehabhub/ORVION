# Change Request — SPEC-087

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Objective

Move the long-term vision and strategic deferred items from external `.claude` memory into their natural repository homes, so a cold-start session learns them from the repo alone.

---

## Business Reason

Final cold-start validation (owner confidence test) found the operating model complete except one gap: the expanded product vision (operational platform / Revenue Intelligence posture) and the strategic deferred items (attribution capture at lead intake; Customer Communications as a future domain with undecided shape; full Meta-ecosystem research; outbound revenue-intelligence delivery posture) lived only in external memory. That violates the memory-is-cache-never-sole-source rule (`AGENTS.md` §5) and the owner's requirement that the repository communicate the long-term vision. Research on 2026 failure modes confirms the dominant risk is context/specification drift and silent staleness, not architecture — so surfacing these facts into the repo is the highest-confidence-per-token improvement. Fix is organization, not new documents: vision → `PROJECT_CONTEXT.md` §11; deferred-with-triggers → `reports/future-backlog.md` (the existing home for exactly this).

---

## Risks

None material. Two additive sections in existing files; no schema, no roadmap change, no duplication (each fact placed in one natural home, cross-referenced). No new document or workflow.

---

## Supersedes / Depends On

Depends on SPEC-084/085/086 (operating model + recoverability). Supersedes nothing.

---

## Scope — Files Allowed to Modify

- PROJECT_CONTEXT.md
- reports/future-backlog.md
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-087-strategic-direction-into-repo.md

---

## Out of Scope — Files Forbidden to Modify

- Any `supabase/migrations/**`, any completed `changes/SPEC-0*.md` other than this one, AGENTS.md, CR_LIFECYCLE.md, README.md, PROTOCOL.md, `_ORVION_CANONICAL/32_execution_roadmap.md`.

---

## Minimum Reading List

- PROJECT_CONTEXT.md
- reports/future-backlog.md

---

## Implementation Steps

1. Add `PROJECT_CONTEXT.md` §11 "Long-Term Direction" (operational platform + single source of truth for verified outcomes; external platforms are consumers; does not change the roadmap); renumber the following sections.
2. Add a "Strategic Direction & Future Domains" table to `reports/future-backlog.md` (attribution capture at intake; Customer Communications future domain with undecided shape; full Meta-ecosystem research; revenue-intelligence delivery posture), each with trigger, cross-referencing `PROJECT_CONTEXT.md` §11.

---

## Acceptance Criteria

- [x] `PROJECT_CONTEXT.md` communicates the long-term vision (operational platform + verified-outcomes source of truth; platforms as consumers) without changing the roadmap.
- [x] `reports/future-backlog.md` records the strategic deferred items with triggers, including attribution capture at intake (unrecoverable rationale, Data Manager API target).
- [x] No fact is duplicated across files; each has one natural home with cross-reference.
- [x] Cold-start test passes: every required question answerable from the repository alone.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), owner-directed (final cold-start validation)

Outcome: Complete

Step results:
- Step 1: Applied — `PROJECT_CONTEXT.md` §11 Long-Term Direction added; Business Context renumbered §12→§13.
- Step 2: Applied — `reports/future-backlog.md` "Strategic Direction & Future Domains" section added before "How items enter and leave".

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8), final cold-start simulation

Verdict: Confirmed Complete

Findings: Re-ran the cold-start chain (README → AGENTS.md → manifest.md → roadmap; PROJECT_CONTEXT / future-backlog / ADRs on demand) assuming no memory/conversation. All required questions now answerable from the repository alone: purpose, business problem, architectural + execution philosophy, long-term vision (PROJECT_CONTEXT §11), governance/authorities/workflow/Earn-It/Design Review/Design Challenge/Excellence Check (AGENTS.md), roadmap + current phase (6) + current/next capability (manifest + roadmap), and the strategic deferred items with triggers (future-backlog). No memory-only operational fact remains. No duplication introduced. Roadmap phases 6–10 reviewed — coherent and discoverable; no change earned.

Recommendation to human: Set Status to Complete (autonomous per `CR_LIFECYCLE.md` §5 — no new architectural decision; relocation of owner-validated facts into the repo).

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

Concludes the operating-model + continuity arc (SPEC-084 canonicalization → 085 recoverability invariant → 086 checkpoint refinement → 087 strategic direction into repo). External `.claude` memory is now a pure cache: no operational or strategic fact lives solely there. Next: resume Phase 6 (Finance Core, `app.customer_balance(...)`).
