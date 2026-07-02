# Change Request — SPEC-019

## Status
[x] Approved

## Assigned Model Tier
[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

## Objective
Create four Compatibility Adapters — `CLAUDE.md`, `.github/copilot-instructions.md`, `.cursor/rules/orvion.mdc`, `GEMINI.md` — each a single-hop pointer to `README.md`, per the validated Adapter Contract.

## Business Reason
Confirmed by direct check: none of Claude Code, GitHub Copilot, or Cursor will discover this repository's governance on their own — each requires a filename their own harness is hardwired to look for. `README.md` is now a complete, correct entry point (`SPEC-018`); these four files exist solely to route each tool's automatic discovery to it, carrying no content of their own.

## Risks
None. Each file is a few lines, contains no business knowledge, no workflow, no governance, no repository state — only a redirect, per the Adapter Contract this session already validated.

## Supersedes / Depends On
Supersedes: None. Depends on: SPEC-018 — Complete, confirmed.

## Scope — Files Allowed to Modify
- CLAUDE.md (new file)
- .github/copilot-instructions.md (new file)
- .cursor/rules/orvion.mdc (new file)
- GEMINI.md (new file)

## Out of Scope — Files Forbidden to Modify
Every existing file. No adapter restates any content from README.md, AGENTS.md, or any other document.

## Minimum Reading List
- README.md

## Implementation Steps

### Step 1 — Create CLAUDE.md
Verify: check whether `CLAUDE.md` exists. If it exists: Already Applied, skip. If not: create it with exactly:
```
# ORVION

Start at `README.md`. It defines the canonical reading order for this repository.
```

### Step 2 — Create .github/copilot-instructions.md
Verify: check whether `.github/copilot-instructions.md` exists. If it exists: Already Applied, skip. If not: create it (and the `.github/` directory if needed) with exactly:
```
# ORVION — Copilot Instructions

Start at `README.md`. It defines the canonical reading order for this repository.
```

### Step 3 — Create .cursor/rules/orvion.mdc
Verify: check whether `.cursor/rules/orvion.mdc` exists. If it exists: Already Applied, skip. If not: create it (and the `.cursor/rules/` directory if needed) with exactly:
```
---
description: ORVION entry point
alwaysApply: true
---

Start at `README.md`. It defines the canonical reading order for this repository.
```

### Step 4 — Create GEMINI.md
Verify: check whether `GEMINI.md` exists. If it exists: Already Applied, skip. If not: create it with exactly:
```
# ORVION

Start at `README.md`. It defines the canonical reading order for this repository.
```

## Acceptance Criteria
- [ ] All four files exist, each containing only the specified redirect text — no restated content.
- [ ] `.cursor/rules/orvion.mdc`'s frontmatter is present and correctly formed.
- [ ] No file outside Scope was created or modified.

## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request, before
IMPLEMENT is considered complete, per synchronization as defined in AGENTS.md's Agent Handoff
Protocol — this file is always implicitly in scope for this section.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]

## Verification Notes

[Appended by the reviewing agent (Tier 1) after independently re-checking the Execution Log
against the live repository state. Append-only — never edit or delete a prior entry.]

## Review Gate
- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied.
- [ ] No file outside the Scope list was modified or created.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] The repository is in a clean, releasable state.

## Notes
This is the last package the SQL Readiness Criteria require. Once Complete, Packages 1–5 are all Complete.
