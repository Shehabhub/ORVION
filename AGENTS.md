# Purpose
AGENTS.md is the operational authority for agent execution in this repository. When AGENTS.md and PROTOCOL.md conflict, AGENTS.md takes precedence.
Define the operating rules for AI agents in this repository. Keep this file focused on agent behavior only.

# Operating Modes
Supported modes:
- ANALYZE
- PLAN
- IMPLEMENT
- REVIEW
- REFACTOR

Rules:
- Default mode is ANALYZE.
- Never assume IMPLEMENT.
- Never switch modes automatically.

# Protected Resources
The following resources are protected.
Never modify them unless they are explicitly listed in the current task.
- AGENTS.md
- README.md
- docs/**
- _ORVION_CANONICAL/**

# Execution Rules
- Modify only files explicitly listed in the task.
- Never create files unless explicitly requested.
- Never rename files unless explicitly requested.
- Never delete files unless explicitly requested.
- Never reorganize the repository unless explicitly requested.
- Read only the documents required for the current task.
- Stop immediately after completing the requested work.
- Never continue automatically to the next task.
- If the request is ambiguous, stop and ask.

## Planning First

Before modifying any file:

- Understand the requested task completely.
- Inspect only the files required for the task.
- Identify risks, blockers, and affected files.
- If the user requested analysis or review, do not modify any file.
- Do not implement changes until explicitly instructed.
- Prefer reporting findings before proposing implementation.

## Change Philosophy
- Every task must solve one business problem only.
- Prefer multiple small changes over one large change.
- Every completed task must leave the repository in a releasable state.
- Avoid partial implementations.
- Avoid placeholder implementations.
- Avoid TODO comments unless explicitly requested.
- If a requested change cannot be completed safely, stop and explain the blocker instead of implementing a partial solution.

## Rules for Maintaining This File

When editing AGENTS.md itself, follow these constraints:
- English only.
- Markdown only.
- Keep the document concise.
- Do not add project-specific business rules to the general sections above this heading.
- Do not create new files.

---

# ORVION Agent Workflow

## Project Context

Read only the required project context.

Project documentation:

* README.md
* PROJECT_CONTEXT.md
* _ORVION_CANONICAL/manifest.md
* CR_LIFECYCLE.md

Project rules:

* global-rules.md


## Workflow

For every task:

1. Read the task description provided by the user.
2. Read only the required project context.
3. Modify only the files required by the task.
4. Verify consistency.
5. Verify the completed changes.
6. Stop after completing the requested task.

Never continue automatically to the next task.

## Git

The repository history is the source of truth.

Never rewrite git history.

Always leave the repository in a clean state.

## Multi-Agent Rules

* AGENTS.md is the single source of truth for agent behavior.
* Do not duplicate these instructions in agent-specific files.
* Read only the files required for the current task.
* If instructions conflict, stop and ask before proceeding.

## Agent Handoff Protocol

* A Change Request is a living repository artifact, not merely an instruction document — it is the authoritative state record of the work it describes. Its declared Scope governs engineering artifacts only; a Change Request's own workflow-state sections are always implicitly in scope for whichever agent is synchronizing them, and doing so is never a Scope violation.
* Synchronization means updating only a Change Request's own workflow-state sections — `Status` (only transitions permitted by the workflow), `Acceptance Criteria`, `Review Gate` (when applicable), `Execution Log`, and `Verification Notes`. Synchronization never authorizes modifying `Objective`, `Business Reason`, `Risks`, `Scope`, `Out of Scope`, `Minimum Reading List`, or `Implementation Steps` — those remain fixed once Approved and are corrected only by a new Change Request. Every other reference to synchronizing a Change Request in this repository means exactly this definition; it is not restated elsewhere.
* IMPLEMENT is not considered complete until the Change Request has been synchronized with the execution state — its Status advanced and its Execution Log appended — as the final part of the same task, not a separate action. Review and Complete remain independent phases and are not merged into IMPLEMENT.
* Handoff between agents happens through `changes/*.md` Change Request files and the `Active Change Request` field in `_ORVION_CANONICAL/manifest.md` — not through chat.
* A Change Request's `## Execution Log` and `## Verification Notes` sections are append-only. Never edit or delete a prior entry.
* Only a human may change a Change Request's Status to `Complete` or `Cancelled`. Codex may change `Approved` to `In Progress` as the first action of its own execution run.
* `Approve SPEC-NNN`: requires Status `Draft`; flips Status to `Approved`, sets `manifest.md`'s `Active Change Request` to this Change Request's path, commits. If Status is already `Approved` or further along, report that instead of re-applying.
* `Execute SPEC-NNN`: requires Status `Approved`; flips Status to `In Progress`, performs the Change Request's Implementation Steps exactly as written, appends an `## Execution Log` entry, commits. If Status is still `Draft`, refuse — never treat `Execute` as an implicit `Approve`.
* `Review SPEC-NNN`: requires Status `In Progress` with at least one `## Execution Log` entry; independently re-verifies every Acceptance Criterion and Review Gate item against the live repository state, not the Execution Log's self-report, appends a `## Verification Notes` entry, commits. If no Execution Log entry exists, report that there is nothing to review.
* `Complete SPEC-NNN`: requires a `## Verification Notes` entry with `Verdict: Confirmed Complete`; flips Status to `Complete`; clears `manifest.md`'s `Active Change Request`; updates `manifest.md`'s `Current Task` and `Last Completed Task` fields to reflect this Change Request; if this Change Request is the last one scoped to an active phase in `32_execution_roadmap.md`, notes that `Freeze Phase N` may now apply as part of this Change Request's own Execution Log entry — this never auto-invokes `Freeze Phase N`, which remains a separate human-gated command; commits. If no Verification Notes entry exists yet, perform `Review` first, surface the result, and stop. If the existing Verification Notes entry says `Discrepancy Found`, refuse and point to it.
* `Start Phase N`: requires the prior phase's status in `32_execution_roadmap.md` to be `Complete`; updates the roadmap's phase table and `manifest.md`'s Current Phase/Module/Task. If the prior phase is not `Complete`, flag this explicitly and wait rather than proceeding silently.
* `Freeze Phase N`: requires every Change Request scoped to that phase to be `Complete` or `Cancelled`; updates that phase's status to `Complete` in the roadmap. If any scoped Change Request is still `Draft`/`Approved`/`In Progress`, list them and refuse until addressed or explicitly overridden.
* Architecture and engineering methodology are reconsidered only when implementation produces concrete repository evidence that they cannot satisfy their own stated objective — never on preference or discussion alone.
* Whenever an update is always expected after another action, that update is defined as part of the action itself, not left as a separately remembered responsibility.
* A Change Request's success is measured not only by its own completion, but by whether it leaves the next Change Request easier to execute. When multiple valid implementation choices exist, prefer the one that reduces maintenance, duplicated knowledge, duplicated authority, and required context.
* Full protocol: `CR_LIFECYCLE.md` (the authoritative Change Request state-machine reference); design rationale: `reports/repository-communication-protocol.md`.
