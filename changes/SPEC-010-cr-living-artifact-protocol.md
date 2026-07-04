# Change Request — SPEC-010

## Status

[x] Complete

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

Note: this Change Request edits governance/authority documents (`AGENTS.md`, `changes/TEMPLATE.md`), not application content. Per the precedent set by `SPEC-005` (the last governance-file Change Request), this requires judgment about wording and placement inside authority documents, not mechanical text insertion — assigned Tier 1 for the same reason.

---

## Objective

Formalize the approved architectural decision — a Change Request is a living repository artifact, always implicitly in scope for its own workflow-state sections, and IMPLEMENT is not complete until that state is synchronized — into `AGENTS.md` and `changes/TEMPLATE.md`, with exactly one canonical definition of "synchronization" and no duplicated wording, eliminating the recurring gap observed in `SPEC-004`, `SPEC-007`, `SPEC-008`, and `SPEC-009`.

---

## Business Reason

Across four separate executions, the executing agent correctly and deterministically applied every Implementation Step to every file named in Scope, and never once updated the Change Request's own `Status` or `Execution Log`. Root-cause analysis (see conversation record) traced this to a structural contradiction: every Change Request authored to date declares a Scope list that excludes its own filename, while `changes/TEMPLATE.md`'s Out of Scope section states Scope is exhaustive "with no exceptions," and `AGENTS.md`'s Execution Rules state "modify only files explicitly listed in the task." A rule-following executor reading those together has grounds to conclude it must not touch the Change Request file itself, even to record that it just finished executing it. Prior to this task, the term "synchronization" was not formally defined anywhere in `AGENTS.md` or `changes/TEMPLATE.md` (confirmed by direct search immediately before this task was written) — this task both resolves the Scope contradiction and establishes a single, precise, non-duplicated definition of what synchronization does and does not authorize, so that reference alone is sufficient everywhere it is needed.

---

## Risks

None. Both edits are additive clarifications to existing sections — no existing rule, bullet, or section is removed or contradicted; the "no exceptions" Scope rule is narrowed to explicitly name what it already implicitly meant to cover (engineering artifacts) rather than reversed. No Change Request that has already reached `Complete` is affected, since this task changes only the template and the general governance rule going forward, not any historical record.

---

## Supersedes / Depends On

Supersedes: None.

Depends on: `SPEC-005-agent-handoff-protocol.md` must already be `Complete`, since this task edits the `## Agent Handoff Protocol` subsection and `## Execution Log` section that `SPEC-005` created.

---

## Scope — Files Allowed to Modify

- AGENTS.md
- changes/TEMPLATE.md

---

## Out of Scope — Files Forbidden to Modify

Scope above is exhaustive. Every other file is out of scope, with no exceptions, including but not limited to:

- Every `_ORVION_CANONICAL/**` file — this task is workflow governance only, not an engineering or canonical business specification change.
- `_ORVION_CANONICAL/33_sql_migration_plan.md` and every other SQL-planning artifact — not touched.
- `PROTOCOL.md`, `README.md`, `CODING_STANDARDS.md`, `global-rules.md`, `PROJECT_CONTEXT.md` — no change to these is required to satisfy this task's objective; `AGENTS.md` is already the stated operational authority for agent execution.
- `reports/repository-communication-protocol.md` and `reports/repository-communication-protocol-v0.2-command-vocabulary.md` — explanatory design-rationale documents, not binding governance; not required to make this decision authoritative.
- `_ORVION_CANONICAL/manifest.md` — its `Active Change Request` pointer mechanism is unaffected by this decision.
- Every existing `changes/SPEC-002` through `SPEC-009` file — historical records; this task changes forward behavior only.

---

## Minimum Reading List

- AGENTS.md
- changes/TEMPLATE.md

---

## Implementation Steps

### Step 1 — Add the living-artifact principle and the canonical "synchronization" definition to `AGENTS.md`

Verify: search for the exact string `Synchronization means` in `AGENTS.md`.
- If found: Already Applied, skip.
- If not found: locate the exact block, the final section of the file:

```
## Agent Handoff Protocol

* Handoff between agents happens through `changes/*.md` Change Request files and the `Active Change Request` field in `_ORVION_CANONICAL/manifest.md` — not through chat.
* A Change Request's `## Execution Log` and `## Verification Notes` sections are append-only. Never edit or delete a prior entry.
* Only a human may change a Change Request's Status to `Complete` or `Cancelled`. Codex may change `Approved` to `In Progress` as the first action of its own execution run.
* Full protocol: `reports/repository-communication-protocol.md`.
```

Replace it with:

```
## Agent Handoff Protocol

* A Change Request is a living repository artifact, not merely an instruction document — it is the authoritative state record of the work it describes. Its declared Scope governs engineering artifacts only; a Change Request's own workflow-state sections are always implicitly in scope for whichever agent is synchronizing them, and doing so is never a Scope violation.
* Synchronization means updating only a Change Request's own workflow-state sections — `Status` (only transitions permitted by the workflow), `Acceptance Criteria`, `Review Gate` (when applicable), `Execution Log`, and `Verification Notes`. Synchronization never authorizes modifying `Objective`, `Business Reason`, `Risks`, `Scope`, `Out of Scope`, `Minimum Reading List`, or `Implementation Steps` — those remain fixed once Approved and are corrected only by a new Change Request. Every other reference to synchronizing a Change Request in this repository means exactly this definition; it is not restated elsewhere.
* IMPLEMENT is not considered complete until the Change Request has been synchronized with the execution state — its Status advanced and its Execution Log appended — as the final part of the same task, not a separate action. Review and Complete remain independent phases and are not merged into IMPLEMENT.
* Handoff between agents happens through `changes/*.md` Change Request files and the `Active Change Request` field in `_ORVION_CANONICAL/manifest.md` — not through chat.
* A Change Request's `## Execution Log` and `## Verification Notes` sections are append-only. Never edit or delete a prior entry.
* Only a human may change a Change Request's Status to `Complete` or `Cancelled`. Codex may change `Approved` to `In Progress` as the first action of its own execution run.
* Full protocol: `reports/repository-communication-protocol.md`.
```

Do not alter any other section of `AGENTS.md`.

### Step 2 — Reference the canonical definition in `changes/TEMPLATE.md`'s Out of Scope section (no re-derivation)

Verify: search for the exact string `implicitly in scope for synchronization` in `changes/TEMPLATE.md`.
- If found: Already Applied, skip.
- If not found: locate the exact block:

```
## Out of Scope — Files Forbidden to Modify

[List every file that must NOT be touched. Include files the agent might reasonably assume are in
scope. Scope above is exhaustive: any file not listed in Scope is out of scope by default, with no
exceptions, whether or not it is separately listed here. This section exists to call out specific
files that pose a realistic risk of being assumed in-scope (adjacent files in the same folder,
related governance files, the changes/ folder itself) — it is not required to enumerate the entire
repository, but every file it does name must be an exact path, never a category or a wildcard.]

-
```

Replace it with:

```
## Out of Scope — Files Forbidden to Modify

[List every file that must NOT be touched. Include files the agent might reasonably assume are in
scope. Scope above is exhaustive for engineering artifacts: any engineering file not listed in
Scope is out of scope by default, with no exceptions, whether or not it is separately listed here.
This section exists to call out specific files that pose a realistic risk of being assumed
in-scope (adjacent files in the same folder, related governance files, the changes/ folder
itself) — it is not required to enumerate the entire repository, but every file it does name must
be an exact path, never a category or a wildcard.

Exception: this Change Request's own file is always implicitly in scope for synchronization, as
defined in `AGENTS.md`'s Agent Handoff Protocol. Updating it in that sense is never a Scope
violation; this exception is defined once, there, and is not restated here.]

-
```

Do not alter any file-list entries that may already exist below this bracketed text in a given Change Request; this step targets `changes/TEMPLATE.md`'s own bracketed instructional text only.

### Step 3 — Reference the canonical definition in `changes/TEMPLATE.md`'s Execution Log section (no re-derivation)

Verify: search for the exact string `before IMPLEMENT is considered complete` in `changes/TEMPLATE.md`.
- If found: Already Applied, skip.
- If not found: locate the exact block:

```
## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]
```

Replace it with:

```
## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request, before
IMPLEMENT is considered complete, per synchronization as defined in AGENTS.md's Agent Handoff
Protocol — this file is always implicitly in scope for this section.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]
```

Do not alter the `## Verification Notes` section or anything after it.

---

## Acceptance Criteria

- [ ] Step 1: `AGENTS.md`'s `## Agent Handoff Protocol` section contains the living-artifact bullet and the "Synchronization means..." definition bullet exactly as specified, positioned before the four pre-existing bullets, which remain word-for-word unchanged; no other section of `AGENTS.md` is altered.
- [ ] Step 2: `changes/TEMPLATE.md`'s Out of Scope bracketed text states Scope is exhaustive "for engineering artifacts" and contains the Exception paragraph exactly as specified, referencing `AGENTS.md`'s definition rather than restating the list of workflow-state section names; the file-list placeholder (`-`) immediately below it is unchanged.
- [ ] Step 3: `changes/TEMPLATE.md`'s Execution Log bracketed text states the "before IMPLEMENT is considered complete" checkpoint exactly as specified, referencing `AGENTS.md`'s definition; the append-only and unused-template sentences are otherwise unchanged; `## Verification Notes` and every section after it are unchanged.
- [ ] The term "synchronization" (or "synchronized") is formally defined in exactly one location (`AGENTS.md`'s Agent Handoff Protocol) and is not re-derived or re-listed anywhere else in either file.
- [ ] No file outside Scope (`AGENTS.md`, `changes/TEMPLATE.md`) was modified or created.
- [ ] No existing bullet, section, or rule in either file was removed, reworded beyond what is specified above, or reordered relative to content not named in these steps.

---

## Review Gate

- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [ ] No file outside the Scope list was modified or created.
- [ ] No section was added, removed, or restructured outside the approved steps.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] Any step that could not be resolved deterministically was reported, not guessed.
- [ ] Supersedes / Depends On: confirmed `SPEC-005` was already `Complete`, and the architectural decision was already approved, before this task began.
- [ ] The repository is in a clean, releasable state.

---

## Execution Log

### 2026-07-02 — Claude

Outcome: Complete

Step results:
- Step 1: Applied — `AGENTS.md`'s `## Agent Handoff Protocol` section now contains the living-artifact bullet and the "Synchronization means..." canonical definition bullet, positioned before the four pre-existing bullets, which are unchanged.
- Step 2: Applied — `changes/TEMPLATE.md`'s Out of Scope bracketed text now states Scope is exhaustive "for engineering artifacts" and contains the Exception paragraph, referencing `AGENTS.md`'s definition rather than restating the section-name list.
- Step 3: Applied — `changes/TEMPLATE.md`'s Execution Log bracketed text now states the "before IMPLEMENT is considered complete" checkpoint, referencing `AGENTS.md`'s definition; `## Verification Notes` and everything after it is unchanged.

Commits: pending — not yet committed as of this entry.

Blocker: None.

---

## Verification Notes

[Appended by the reviewing agent (Tier 1) after independently re-checking the Execution Log
against the live repository state. Append-only — never edit or delete a prior entry.]

### 2026-07-04 22:39 — Claude Code (Opus 4.8), REVIEW

Verdict: Confirmed Complete

This Review was performed retroactively: this Change Request has carried Status `In Progress` since its 2026-07-02 Execution Log entry, with no Verification Notes entry, and a repository state audit surfaced it. Each Acceptance Criterion was re-checked independently against the live repository (not the Execution Log):

- Step 1: `AGENTS.md` contains the living-artifact bullet ("A Change Request is a living repository artifact") and the canonical "Synchronization means updating only a Change Request's own workflow-state sections" definition — both present (grep 1 each).
- Single-source requirement: the string "Synchronization means updating only" appears in `AGENTS.md` only; it is not re-derived in `changes/TEMPLATE.md`, `PROTOCOL.md`, or `CR_LIFECYCLE.md`.
- Step 2: `changes/TEMPLATE.md`'s Out of Scope text states Scope is "exhaustive for engineering artifacts" and contains the "always implicitly in scope for synchronization" Exception paragraph.
- Step 3: `changes/TEMPLATE.md`'s Execution Log text carries the "IMPLEMENT is considered complete, per synchronization" checkpoint referencing `AGENTS.md`.

Note on subsequent evolution: `AGENTS.md`'s Agent Handoff Protocol has since been legitimately extended by later Change Requests (for example SPEC-012's command-vocabulary and commit-attribution rules, SPEC-017's refinements), so the section is now longer than the exact end-state this Change Request's Steps described. SPEC-010's specific contributions — the two bullets and the single-sourced synchronization definition — persist intact, and `SPEC-011`/`CR_LIFECYCLE.md` consolidated this protocol on top of them. The later extension does not invalidate this Change Request; its substance is live and load-bearing.

Recommendation to human: Set Status to Complete. (This Change Request was functionally complete on 2026-07-02 but never formally closed; this entry supplies the missing verification so `Complete SPEC-010` can finalize it.)

---

## Notes

This Change Request itself was created and synchronized in accordance with the rule it formalizes — its own `Status` and `Execution Log` are updated below as its Implementation Steps are applied, demonstrating the fix on the artifact that introduces it. Verification against every Acceptance Criterion and Review Gate item was performed and reported before committing, per explicit instruction; `Status` is left at `In Progress`, not `Complete`, since Review and Complete remain independent phases not merged into this IMPLEMENT action.
