# Purpose
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

## Change Philosophy
- Every task must solve one business problem only.
- Prefer multiple small changes over one large change.
- Every completed task must leave the repository in a releasable state.
- Avoid partial implementations.
- Avoid placeholder implementations.
- Avoid TODO comments unless explicitly requested.
- If a requested change cannot be completed safely, stop and explain the blocker instead of implementing a partial solution.

Constraints:
- English only.
- Markdown only.
- Keep the document concise.
- Do not add project-specific business rules.
- Do not create new files.

---

# ORVION Agent Workflow

## Project Context

Read only the required project context.

Project documentation:

* README.md
* docs/PROJECT_CONTEXT.md

Project rules:

* .ai/rules/global-rules.md


## Workflow

For every task:

1. Read the task description provided by the user.
2. Read only the required project context.
3. Modify only the files required by the task.
4. Verify consistency.
5. Update the project state if required.
6. Stop after completing the requested task.

Never continue automatically to the next task.
.

## Git

The repository history is the source of truth.

Never rewrite git history.

Always leave the repository in a clean state.

## Multi-Agent Rules

* AGENTS.md is the single source of truth for agent behavior.
* Do not duplicate these instructions in agent-specific files.
* Read only the files required for the current task.
* If instructions conflict, stop and ask before proceeding.
