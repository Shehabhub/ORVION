# Change Request — SPEC-021

## Status
[x] In Progress

## Assigned Model Tier
[x] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

Note, matching the SPEC-009/010/011/012 precedent: consolidating a governance/state document's ownership requires wording and placement judgment, not mechanical text insertion.

## Objective
Reconcile manifest.md so every section it contains reflects a responsibility manifest.md actually owns — Current Development Status only — deferring every other responsibility to the document that already owns it, closing the one remaining instance of duplicated authority this program's Exit Review found.

## Business Reason
The Exit Review's full read of manifest.md — the one canonical document never read start to finish during any prior package, only touched via targeted `grep` checks — found twelve of fifteen content sections restating responsibilities already owned elsewhere: project identity (`PROJECT_CONTEXT.md`), engineering principles and workflow (`AGENTS.md`/`PROTOCOL.md`), document routing (`README.md`), and phase/module progress (`32_execution_roadmap.md`) — the last of these not merely duplicated but directly contradictory (manifest.md's Module Status table states Identity `Complete`, CRM `In Progress`; `32_execution_roadmap.md`, verified directly, states both `Pending`). This is not a new architectural problem — it is one remaining instance of the exact problem `SPEC-012` resolved for `codex.md`/`SYSTEM_PROMPT.md`, found late only because this one document was never read in full until now.

## Risks
None to repository content or architecture — this task reconciles ownership, it does not change what any other document says. One small content-preservation risk, mitigated directly: manifest.md's Target Users list includes "Finance," not present in `PROJECT_CONTEXT.md`'s otherwise-equivalent role list — preserved by Step 1 rather than discarded.

## Supersedes / Depends On
Supersedes: None.
Depends on: SPEC-012 through SPEC-020 must already be Complete — confirmed (all nine prior packages closed).

## Scope — Files Allowed to Modify
- _ORVION_CANONICAL/manifest.md
- PROJECT_CONTEXT.md

## Out of Scope — Files Forbidden to Modify
Scope above is exhaustive. Explicitly includes AGENTS.md, PROTOCOL.md, README.md, CR_LIFECYCLE.md, changes/TEMPLATE.md, 32_execution_roadmap.md, every _ORVION_CANONICAL/00-33 file, reports/**, every changes/SPEC-0NN file, and every Compatibility Adapter. This Change Request introduces no new document, no new architecture, no new governance, no new mechanism — it reconciles ownership within the two files listed above only.

## Minimum Reading List
- _ORVION_CANONICAL/manifest.md
- PROJECT_CONTEXT.md
- AGENTS.md
- README.md
- _ORVION_CANONICAL/32_execution_roadmap.md

## Implementation Steps

Each step is independently verified and independently safe to skip if already applied. None of them touch `# Current Development Status` — that section's content at execution time, whatever it is, is left exactly as it was found. Every verify check below is an exact full-line match, not a substring search, to avoid ambiguity between similarly-prefixed headings (`# Project` / `# Project Goal` / `# Project Success`).

### Step 1 — Preserve the one non-duplicated fact
Verify: search PROJECT_CONTEXT.md §12's Travel Agency Mindset list for the exact line `- Finance`. If found: Already Applied, skip. If not found: add `- Finance` to that list, alongside the existing Sales Employee/Customer Service/Ticketing Staff/Operations/Manager/Owner entries.

### Step 2 — Correct the header Purpose line
Verify: search manifest.md for the exact line `Purpose: Repository State`. If found: skip. If not found: replace the exact line `Purpose: AI Entry Point` with `Purpose: Repository State`.

### Step 3 — Rewrite the Purpose section
Verify: search manifest.md for the exact string `this document does not restate their responsibilities`. If found: skip. If not found: replace the `# Purpose` section's body (the text between the `# Purpose` heading and its trailing `---`) with:
```
This document tells any agent or human where the project currently stands.

It exists to answer one question: what phase, task, and Change Request is active right now.

For where to begin, what to read, and who governs conduct, see `README.md` and `AGENTS.md` — this document does not restate their responsibilities.

This file should always reflect the current state of the project.
```

### Step 4 — Remove `# Project`
Verify: search manifest.md for the exact line `# Project` immediately followed within the section by `Name: ORVION`. If not found: skip. If found: remove the entire section, from the exact line `# Project` up to (not including) its next line consisting solely of `---`.

### Step 5 — Remove `# Project Goal`
Verify: search for the exact line `# Project Goal`. If not found: skip. If found: remove the section through its next line consisting solely of `---`.

### Step 6 — Remove `# Development Roadmap`
Verify: search for the exact line `# Development Roadmap`. If not found: skip. If found: remove the section through its next line consisting solely of `---`.

### Step 7 — Remove `# Module Status`
Verify: search for the exact line `# Module Status`. If not found: skip. If found: remove the section through its next line consisting solely of `---`.

### Step 8 — Remove `# Reference Documents`
Verify: search for the exact line `# Reference Documents`. If not found: skip. If found: remove the section through its next line consisting solely of `---`.

### Step 9 — Remove `# Which Documents Should Be Loaded?`
Verify: search for that exact line. If not found: skip. If found: remove the section through its next line consisting solely of `---`.

### Step 10 — Remove `# Current Principles`
Verify: search for the exact line `# Current Principles`. If not found: skip. If found: remove the section through its next line consisting solely of `---`.

### Step 11 — Remove `# Things That Must Never Change Automatically`
Verify: search for that exact line. If not found: skip. If found: remove the section through its next line consisting solely of `---`.

### Step 12 — Remove `# Working Context`
Verify: search for the exact line `# Working Context`. If not found: skip. If found: remove the section through its next line consisting solely of `---`.

### Step 13 — Remove `# Documentation Rule`
Verify: search for the exact line `# Documentation Rule`. If not found: skip. If found: remove the section through its next line consisting solely of `---`.

### Step 14 — Remove `# Token Optimization`
Verify: search for the exact line `# Token Optimization`. If not found: skip. If found: remove the section through its next line consisting solely of `---`.

### Step 15 — Remove `# Project Success`
Verify: search for the exact line `# Project Success`. If not found: skip. If found: remove the section through its next line consisting solely of `---`.

### Step 16 — Remove `# Final Reminder`
Verify: search for the exact line `# Final Reminder`. If not found: skip. If found: remove the section through the end of the file.

### Step 17 — Add `# Governance and Ownership`
Verify: search manifest.md for the exact line `# Governance and Ownership`. If found: skip. If not found: append, unconditionally at the true end of the file (regardless of what else has or hasn't already been removed by prior steps):
```

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
```

## Acceptance Criteria
- [x] PROJECT_CONTEXT.md §12 includes Finance.
- [x] manifest.md's header Purpose reads `Repository State`.
- [x] manifest.md's Purpose section is State-only, no Entry-flavored or Codex-specific language remains.
- [x] None of `# Project`, `# Project Goal`, `# Development Roadmap`, `# Module Status`, `# Reference Documents`, `# Which Documents Should Be Loaded?`, `# Current Principles`, `# Things That Must Never Change Automatically`, `# Working Context`, `# Documentation Rule`, `# Token Optimization`, `# Project Success`, `# Final Reminder` remain.
- [x] `# Governance and Ownership` exists with the four deferral bullets, positioned at the true end of the file.
- [x] `# Current Development Status`'s content was not touched by any step in this Change Request — whatever it reads at execution time is left exactly as found, not frozen to drafting-time content.
- [x] No file outside Scope was modified.
- [x] No table, schema, or business-domain decision was altered.

## Execution Log

### 2026-07-02 21:15 — Claude (Sonnet 5)

Outcome: Complete

Step results:
- Step 1: Applied — Finance added to PROJECT_CONTEXT.md §12's Travel Agency Mindset list.
- Step 2: Applied — header Purpose corrected to Repository State.
- Step 3: Applied — Purpose section rewritten to State-only content.
- Step 4: Applied — # Project removed.
- Step 5: Applied — # Project Goal removed.
- Step 6: Applied — # Development Roadmap removed.
- Step 7: Applied — # Module Status removed (the contradictory table).
- Step 8: Applied — # Reference Documents removed.
- Step 9: Applied — # Which Documents Should Be Loaded? removed.
- Step 10: Applied — # Current Principles removed.
- Step 11: Applied — # Things That Must Never Change Automatically removed.
- Step 12: Applied — # Working Context removed.
- Step 13: Applied — # Documentation Rule removed.
- Step 14: Applied — # Token Optimization removed.
- Step 15: Applied — # Project Success removed.
- Step 16: Applied — # Final Reminder removed.
- Step 17: Applied — # Governance and Ownership added at end of file with the four deferral bullets.

Commits: pending — recorded at commit time in the same commit as this entry.

Verification performed before this entry: `git status --porcelain` confirmed exactly the two Scope files changed. Direct read of manifest.md confirms it now contains exactly three sections (Purpose, Current Development Status, Governance and Ownership) and Current Development Status's content is unchanged from immediately before this Change Request's execution.

## Verification Notes

### 2026-07-02 21:17 — Claude (Sonnet 5)

Verdict: Confirmed Complete

Findings: `git diff 7bb4597 HEAD` on both Scope files matches every Implementation Step exactly — all twelve sections removed, header and Purpose section correctly rewritten, `# Governance and Ownership` added with the four deferral bullets, `Finance` added to PROJECT_CONTEXT.md §12. `Current Development Status` is unchanged, confirmed by its absence from the diff except as surrounding context. No file outside Scope touched. `git status --porcelain` — clean.

Recommendation to human: Set Status to Complete

## Review Gate
- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied.
- [x] No file outside the Scope list was modified or created.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

## Repository Engineering Completion Verification

Checked against the state this Change Request produces, to be independently re-confirmed during Review against live repository evidence, not assumed from this list:

| Objective | Status |
|---|---|
| Single Source of Truth | Achieved |
| Single Ownership | Achieved |
| Zero-Memory Workflow | Achieved |
| Deterministic Execution | Achieved |
| Independent Review | Achieved |
| Repository Discoverability | Achieved |
| Repository Navigation | Achieved |
| Multi-Agent Compatibility | Achieved |
| Repository Self-Guidance | Achieved |
| Minimal Required Reading | Achieved |
| No duplicated authority | Achieved |
| No duplicated workflow | Achieved |
| No duplicated navigation | Achieved |
| No duplicated engineering responsibility | Achieved |
| SQL Readiness | Achieved |

All fifteen — none Not Achieved. Per instruction, execution continues rather than stopping.

## Notes
This is the closing Change Request of Repository Engineering. It introduces nothing new — no document, no architecture, no governance, no mechanism — it completes the transfer of ownership this program has been performing since `SPEC-012`, for the one document a full read had never covered until the Exit Review. `Finance` (Step 1) is the only content genuinely preserved-by-relocation rather than deferred-by-reference; everything else removed from manifest.md already has a correct, verified owner elsewhere in the repository.

Restructured after a safety review: the original draft's single "replace the entire file" step was rejected in favor of seventeen individually-verifiable, independently-skippable steps, matching this program's own established discipline rather than a one-time exception to it. The Current Development Status Acceptance Criterion was corrected from "byte-for-byte unchanged" to "not touched by this Change Request's own steps" — the former would have frozen living state at drafting time, contradicting Zero-Memory Workflow. Step 17's insertion point was further hardened to append unconditionally at end-of-file rather than assuming position relative to another section, and every verify check was confirmed to be an exact full-line match to avoid ambiguity between similarly-prefixed headings.

Final legacy-pattern sweep, performed before this Change Request's approval: `00_project_charter.md` (never previously read in full this session) confirmed clean; a repository-wide grep across all of `_ORVION_CANONICAL/` for entry-point and authority-flavored language found only `manifest.md` (addressed by this Change Request) and `codex.md`'s own descriptive deprecation text (confirmed benign). No other legacy-accumulation document exists.
