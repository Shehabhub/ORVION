# Change Request — SPEC-012

## Status
[x] Approved

## Assigned Model Tier
[x] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

Note, matching the precedent set by SPEC-009/010/011: this Change Request edits governance/authority documents and merges content across documents, requiring judgment about wording, placement, and disposition — not mechanical text insertion.

## Objective
Resolve the unqualified-authority collision between `codex.md` and `AGENTS.md`, retire `SYSTEM_PROMPT.md` and `codex.md`'s duplicated process content in favor of `AGENTS.md`/`PROTOCOL.md`, preserve `codex.md`'s non-duplicated business context by merging it into `PROJECT_CONTEXT.md`, transcribe the already-proven Command Vocabulary into `AGENTS.md`'s Agent Handoff Protocol — including extending the `Complete` command's own definition so that repository state synchronization happens as part of completing a Change Request, not as a separately remembered step — and record the Execution Contract's standing rules (the architecture/methodology reconsideration threshold, the simplification success criterion, and the generalized tie-updates-to-actions principle) in the same section.

## Business Reason
This task closes the root cause identified across the Repository Recovery and Normalization review: two eras of this repository's governance were never reconciled. `codex.md` and `SYSTEM_PROMPT.md` were built before `AGENTS.md`/`PROTOCOL.md`/`CR_LIFECYCLE.md` existed and were never retired or reconciled against them — producing the exact failure modes that started this entire effort: a new participant cannot tell which document is authoritative, `SYSTEM_PROMPT.md`'s workflow independently restates `AGENTS.md`'s Workflow in different words, and the Command Vocabulary that has governed every `Approve`/`Execute`/`Review`/`Complete` action in this project's history since `SPEC-007` still carried `Status: Proposal` in a report — the rules this repository has actually followed were not the rules its own canonical documents stated. Extending `Complete`'s definition to include state synchronization applies the Zero-Memory Workflow principle at its most direct point: the original failure this whole project exists to prevent was completed work whose repository state was never updated because nobody remembered to update it. The Execution Contract's standing rules are recorded here, in the same document and the same pass, rather than left as conversational record, for the identical reason — the discipline this review established should not depend on this conversation being remembered either.

## Risks
Content loss risk on `codex.md`'s business-philosophy sections if merged carelessly — mitigated by Step 4 preserving them verbatim into `PROJECT_CONTEXT.md`. No table, schema, or business-domain decision is altered. `SYSTEM_PROMPT.md` and the retained portions of `codex.md` are deprecated, not deleted, per `AGENTS.md`'s own "Never delete files unless explicitly requested" rule and the existing `changes/CHANGE_REQUEST.md` deprecation-stub precedent.

## Supersedes / Depends On
Supersedes: None.
Depends on: `SPEC-005`, `SPEC-010`, `SPEC-011` must already be applied — confirmed.

## Scope — Files Allowed to Modify
- AGENTS.md
- codex.md (`_ORVION_CANONICAL/codex.md`)
- SYSTEM_PROMPT.md (`_ORVION_CANONICAL/SYSTEM_PROMPT.md`)
- global-rules.md
- PROJECT_CONTEXT.md

## Out of Scope — Files Forbidden to Modify
Scope above is exhaustive. Explicitly includes: `PROTOCOL.md`, `changes/TEMPLATE.md`, `CR_LIFECYCLE.md` (the Engineering Observation triage rule, and its sequencing refinement, belong to CR_LIFECYCLE.md's own responsibility and are deliberately deferred to their own future Change Request, not folded in here), `README.md`, `manifest.md`, `32_execution_roadmap.md` (a separate package corrects their current staleness; this package only writes the rule that keeps them synchronized going forward), `CODING_STANDARDS.md`, `scripts/**`, every `_ORVION_CANONICAL/00`–`33` file, `reports/**`, and every prior `changes/SPEC-00X` file.

## Minimum Reading List
- AGENTS.md
- PROTOCOL.md
- codex.md
- SYSTEM_PROMPT.md
- global-rules.md
- PROJECT_CONTEXT.md
- reports/repository-communication-protocol-v0.2-command-vocabulary.md

## Implementation Steps

### Step 1 — Transcribe the Command Vocabulary into AGENTS.md, with Complete's definition extended
Verify: search `AGENTS.md` for the exact string `Approve SPEC-NNN`. If found: Already Applied, skip. If not found: add six new bullets to `## Agent Handoff Protocol`, after the existing "Only a human may change..." bullet and before "Full protocol:", transcribing `Approve`/`Execute`/`Review`/`Complete`/`Start Phase`/`Freeze Phase` from `reports/repository-communication-protocol-v0.2-command-vocabulary.md` §2 — including that `Complete` requires a pre-existing, committed Verification Notes entry, not the command alone. The `Complete` bullet's stated action must additionally include: "clear `manifest.md`'s `Active Change Request`; update `manifest.md`'s `Current Task` and `Last Completed Task` fields to reflect this Change Request; if this Change Request is the last one scoped to an active phase in `32_execution_roadmap.md`, note that `Freeze Phase N` may now apply as part of this Change Request's own Execution Log entry — do not auto-invoke `Freeze Phase N`, which remains a separate human-gated command."

### Step 2 — Deprecate SYSTEM_PROMPT.md
Verify: search `SYSTEM_PROMPT.md` for the exact string `Superseded`. If found: Already Applied, skip. If not found: replace the file's entire content with a deprecation notice matching `changes/CHANGE_REQUEST.md`'s structure (Status: Deprecated / Why / What to use instead), stating its process content is fully covered by `AGENTS.md` and its document-loading-map content is superseded by the repository-level Reading List (a later package).

### Step 3 — Deprecate codex.md's process content, preserve its business content
Verify: search `codex.md` for the exact string `Superseded`. If found: Already Applied, skip. If not found: after Step 4 has moved the business-philosophy sections into `PROJECT_CONTEXT.md`, replace `codex.md`'s remaining content with a deprecation notice in the same format as Step 2, pointing to `AGENTS.md`/`PROTOCOL.md` for process and `PROJECT_CONTEXT.md` for business context.

### Step 4 — Merge codex.md's business content into PROJECT_CONTEXT.md
Verify: search `PROJECT_CONTEXT.md` for the exact string `Travel Agency Mindset`. If found: Already Applied, skip. If not found: append a new `## 12. Business Context (from codex.md)` section containing, verbatim, `codex.md`'s "About ORVION" service list, "Business First" questions, "Travel Agency Mindset" role list, "Event Philosophy" examples, "API Philosophy", and "UI Philosophy" sections.

### Step 5 — Add global-rules.md's deferral to AGENTS.md
Verify: search `global-rules.md` for the exact string `AGENTS.md is the operational authority`. If found: Already Applied, skip. If not found: add one line near the top: "AGENTS.md is the operational authority for agent execution. This document supplements it and does not override it."

### Step 6 — Fix AGENTS.md's own Project Context reading list
Verify: search `AGENTS.md`'s `## Project Context` section for the exact string `manifest.md`. If found: Already Applied, skip. If not found: add `_ORVION_CANONICAL/manifest.md` and `CR_LIFECYCLE.md` to the existing "Project documentation" list.

### Step 7 — Record the Execution Contract's standing rules in AGENTS.md
Verify: search `AGENTS.md` for the exact string `concrete repository evidence that they cannot satisfy`. If found: Already Applied, skip. If not found: add three new bullets to `## Agent Handoff Protocol`, after the six command bullets added in Step 1 and before "Full protocol:":
- "Architecture and engineering methodology are reconsidered only when implementation produces concrete repository evidence that they cannot satisfy their own stated objective — never on preference or discussion alone."
- "Whenever an update is always expected after another action, that update is defined as part of the action itself, not left as a separately remembered responsibility."
- "A package's success is measured not only by its own completion, but by whether it leaves the next package easier to execute. When multiple valid implementation choices exist, prefer the one that reduces maintenance, duplicated knowledge, duplicated authority, and required context."

## Acceptance Criteria
- [ ] `AGENTS.md`'s Agent Handoff Protocol states all six commands and their preconditions.
- [ ] The `Complete` bullet specifically states its extended action: manifest.md state fields updated, phase-freeze eligibility flagged (not auto-invoked), as part of the same defined action.
- [ ] `AGENTS.md` states the architecture/methodology reconsideration threshold, the tie-updates-to-actions principle, and the simplification success criterion, each as a standing rule.
- [ ] `SYSTEM_PROMPT.md` contains only a deprecation notice, no process or document-map content remains.
- [ ] `codex.md` contains only a deprecation notice; no business-philosophy content is lost, only relocated.
- [ ] `PROJECT_CONTEXT.md` contains `codex.md`'s business-philosophy content verbatim, in a new numbered section.
- [ ] `global-rules.md` explicitly defers to `AGENTS.md`.
- [ ] `AGENTS.md`'s Project Context list includes `manifest.md` and `CR_LIFECYCLE.md`.
- [ ] No file outside Scope was modified. `manifest.md`, `32_execution_roadmap.md`, and `CR_LIFECYCLE.md` are unchanged by this package.
- [ ] No table, schema, or business-domain decision was altered anywhere.

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
- [ ] No section was added, removed, or restructured outside the approved steps.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] Any step that could not be resolved deterministically was reported, not guessed.
- [ ] Confirmed SPEC-005/010/011 were already applied before this task began.
- [ ] The repository is in a clean, releasable state.

## Notes
This is the first package of Repository Engineering, following an extended architectural review (Governance stabilization → Repository Recovery → Repository Normalization → Compatibility Adapter Contract → the Engineering Playbook → the Execution Contract). Key decisions this package operationalizes, recorded here so they don't exist only in conversation: `codex.md` and `SYSTEM_PROMPT.md` are deprecated rather than kept as parallel authority because two eras of this repository's governance were never reconciled, and an unqualified-authority document coexisting with `AGENTS.md` is a duplicated-authority risk, not a stylistic one. `codex.md`'s business-philosophy content is preserved, not discarded, because it is genuinely unique context found nowhere else in the repository. The Command Vocabulary is transcribed rather than left as a standing "Proposal" because ten successful executions across `SPEC-007`–`011` already constitute sufficient evidence — ratifying it here is transcription of proven practice, not new judgment. `Complete`'s extended definition (manifest state, phase-freeze flag) exists because the original problem motivating this entire project was completed work whose repository state was never synchronized. The Execution Contract's standing rules are recorded in `AGENTS.md` specifically, not as a new document, because a standalone document restating content `AGENTS.md`/`CR_LIFECYCLE.md` already own would repeat the exact defect this package exists to remove from `codex.md` and `SYSTEM_PROMPT.md`. The Engineering Observation triage rule, and its methodology-specific sequencing refinement, are deliberately excluded from this package's Scope — they belong to `CR_LIFECYCLE.md`'s own responsibility and are deferred to their own future Change Request. `32_execution_roadmap.md` and `manifest.md`'s own current staleness are explicitly not corrected here — that is a separate package (State Truthfulness), depending on this one only for the rule this package writes.
