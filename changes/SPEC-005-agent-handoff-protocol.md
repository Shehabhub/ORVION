# Change Request — SPEC-005

## Status

[x] Approved

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

Note: this Change Request modifies governance files (`AGENTS.md`, `_ORVION_CANONICAL/manifest.md`) and a Change Request template (`changes/TEMPLATE.md`), not application/business content. It is assigned Tier 1 rather than Tier 2 because it requires judgment about wording and placement inside authority documents, not mechanical, unambiguous text insertion of a kind already fully specified elsewhere — matching the precedent that governance-file edits in this repository's own history were made deliberately rather than as bulk template application.

---

## Objective

Add a repository-native handoff mechanism between Claude Code and Codex — an append-only Execution Log and Verification Notes section in the Change Request template, and an Active Change Request pointer in the project manifest — so that Change Request execution and verification are reported through committed files instead of chat.

---

## Business Reason

`reports/workflow-architecture-report.md` and `reports/repository-communication-protocol.md` document the full design rationale: this repository's existing `changes/TEMPLATE.md` Status vocabulary and Assigned Model Tier field already encode a working Claude/Codex handoff state machine, but it has no structured place for the executing agent (Codex) to report what happened, or for the reviewing agent (Claude) to report its independent verification, without relying on a human relaying chat output between two separate agent sessions. This task adds the minimum structural change needed to close that gap — a new template section pair and one new manifest field — without introducing a new folder, a new Status value, or any live signaling mechanism, all of which were evaluated and rejected (see Workflow Architecture Report §3).

---

## Risks

Low. All three edits are additive: two new sections inserted into `changes/TEMPLATE.md` (no existing section is altered, removed, or reordered), and one new field inserted into `_ORVION_CANONICAL/manifest.md`'s existing "Current Development Status" block (no existing field is altered). `AGENTS.md` receives one new subsection appended after its existing final section, not a rewrite of any existing rule. No `.gitignore` change is needed since no new transient artifact is introduced. The main risk is the same as prior Change Requests in this repository: divergence between the assumed and actual current file state, mitigated by verification-gated steps below.

---

## Supersedes / Depends On

Supersedes: None.

Depends on: None. This task is independent of `SPEC-004-phase2-catalog-lifecycle.md` (which remains Draft and unaffected) — it changes workflow tooling, not ORVION business/schema content.

---

## Scope — Files Allowed to Modify

- changes/TEMPLATE.md
- _ORVION_CANONICAL/manifest.md
- AGENTS.md

---

## Out of Scope — Files Forbidden to Modify

Scope above is exhaustive. Every other file in the repository is out of scope, with no exceptions, including but not limited to:

- PROTOCOL.md — deliberately not edited by this task. `PROTOCOL.md` already states "Git is the execution history" and does not contradict this protocol; folding the full normative content of `reports/repository-communication-protocol.md` into `PROTOCOL.md`'s "Layers" section is recommended as a *future* Change Request once this minimal version has been used in practice, not bundled into this one (see Notes).
- CODING_STANDARDS.md, README.md, global-rules.md, PROJECT_CONTEXT.md
- changes/CHANGE_REQUEST.md (deprecated — do not edit)
- changes/SPEC-002-phase1-database-foundation.md, changes/SPEC-003-phase1-consistency-fix.md, changes/SPEC-004-phase2-catalog-lifecycle.md (existing Change Requests — the new template sections apply only to Change Requests authored after this task; existing ones are not retrofitted, per Workflow Architecture Report §7)
- reports/workflow-architecture-report.md, reports/repository-communication-protocol.md (design-rationale deliverables — do not edit)
- Any file under `_ORVION_CANONICAL/` other than `manifest.md`
- supabase/**, scripts/**, .aider.conf.yml

---

## Minimum Reading List

- changes/TEMPLATE.md
- _ORVION_CANONICAL/manifest.md
- AGENTS.md
- reports/workflow-architecture-report.md
- reports/repository-communication-protocol.md

---

## Implementation Steps

### Step 1 — Add `## Execution Log` and `## Verification Notes` sections to `changes/TEMPLATE.md`

Verify: search for the exact heading `## Execution Log` in `changes/TEMPLATE.md`.
- If found: Already Applied, skip.
- If not found: locate the exact block:

```
## Acceptance Criteria

[Binary. Every item must be verifiable by reading the repository after the task completes.
No subjective criteria. Prefer one criterion per Implementation Step over a small number of
broad criteria — this makes partial completion and partial failure both individually visible.]

- [ ]

---

## Review Gate
```

Replace it with:

```
## Acceptance Criteria

[Binary. Every item must be verifiable by reading the repository after the task completes.
No subjective criteria. Prefer one criterion per Implementation Step over a small number of
broad criteria — this makes partial completion and partial failure both individually visible.]

- [ ]

---

## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]

### <YYYY-MM-DD HH:MM> — <agent identifier>

Outcome: Complete | Blocked | Failed

Step results:
- Step 1: Already Applied | Applied | Failed — <one-line reason>

Commits: <commit hash(es) for this run>

Blocker: <only present if Outcome is Blocked or Failed. One factual paragraph describing
exactly which verification check produced an unanticipated result and where. Do not propose
or apply a guessed resolution.>

---

## Verification Notes

[Appended by the reviewing agent (Tier 1) after independently re-checking the Execution Log
against the live repository state. Append-only — never edit or delete a prior entry.]

### <YYYY-MM-DD HH:MM> — <agent identifier>

Verdict: Confirmed Complete | Discrepancy Found | Needs Corrective Change Request

Findings: <what was independently re-checked, and what was found>

Recommendation to human: Set Status to Complete | Set Status to Cancelled | Approve corrective
Change Request `changes/SPEC-00N-*.md`

---

## Review Gate
```

### Step 2 — Add `Active Change Request` field to `_ORVION_CANONICAL/manifest.md`

Verify: search for the exact string `Active Change Request:` in `_ORVION_CANONICAL/manifest.md`.
- If found: Already Applied, skip.
- If not found: locate the exact block:

```
Next Planned Task: Create SQL migration plan

---

# Development Roadmap
```

Replace it with:

```
Next Planned Task: Create SQL migration plan

Active Change Request: None

---

# Development Roadmap
```

Note: the value of this field is maintained by the workflow itself thereafter (set to a CR's file path by whichever agent moves that CR's Status to `Approved`, cleared back to `None` when that CR reaches `Complete` or `Cancelled`) — this step only adds the field.

### Step 3 — Add `## Agent Handoff Protocol` subsection to `AGENTS.md`

Verify: search for the exact heading `## Agent Handoff Protocol` in `AGENTS.md`.
- If found: Already Applied, skip.
- If not found: locate the exact block, which is the final content of the file:

```
## Multi-Agent Rules

* AGENTS.md is the single source of truth for agent behavior.
* Do not duplicate these instructions in agent-specific files.
* Read only the files required for the current task.
* If instructions conflict, stop and ask before proceeding.
```

Append immediately after the final line (`* If instructions conflict, stop and ask before proceeding.`), with no other change to this section:

```

## Agent Handoff Protocol

* Handoff between agents happens through `changes/*.md` Change Request files and the `Active Change Request` field in `_ORVION_CANONICAL/manifest.md` — not through chat.
* A Change Request's `## Execution Log` and `## Verification Notes` sections are append-only. Never edit or delete a prior entry.
* Only a human may change a Change Request's Status to `Complete` or `Cancelled`. Codex may change `Approved` to `In Progress` as the first action of its own execution run.
* Full protocol: `reports/repository-communication-protocol.md`.
```

---

## Acceptance Criteria

- [ ] Step 1: `changes/TEMPLATE.md` contains `## Execution Log` and `## Verification Notes` headings, positioned between `## Acceptance Criteria` and `## Review Gate`, with `## Review Gate` and everything after it in the file completely unchanged.
- [ ] Step 2: `_ORVION_CANONICAL/manifest.md` contains the exact line `Active Change Request: None` immediately after `Next Planned Task: Create SQL migration plan`, with no other line in the file altered.
- [ ] Step 3: `AGENTS.md` contains a `## Agent Handoff Protocol` subsection as its final section, with every prior line in the file unchanged.
- [ ] No file outside Scope (`changes/TEMPLATE.md`, `_ORVION_CANONICAL/manifest.md`, `AGENTS.md`) was modified or created.
- [ ] `PROTOCOL.md` was not touched.

---

## Review Gate

- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [ ] No file outside the Scope list was modified or created.
- [ ] No section was added, removed, or restructured outside the approved steps.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] Any step that could not be resolved deterministically was reported, not guessed.
- [ ] Supersedes / Depends On: not applicable (no prior Change Request to update).
- [ ] The repository is in a clean, releasable state.

---

## Notes

This task is deliberately scoped to the minimum structural change: a template addition and a manifest pointer, both proven-pattern additive edits. It does **not** fold `reports/repository-communication-protocol.md`'s full normative content into `PROTOCOL.md`, even though that document's own "Layers" section already anticipates future formalization ("Layers marked [Planned] are defined in principle but not yet implemented"). That larger consolidation is recommended as a separate, future Change Request once this minimal mechanism has been used on at least one real Change Request in practice — folding untested process design directly into the repository's highest-authority collaboration document (`PROTOCOL.md`) before it has been exercised once would be premature. This task was authored, and remains, in ANALYZE/PLAN mode: no file listed in Scope has been modified by producing this Change Request. It requires human approval (Draft → Approved) before any agent may act on it.
