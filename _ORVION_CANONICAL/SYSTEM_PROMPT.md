# SYSTEM_PROMPT.md — Superseded

Status: Deprecated. Do not use this file as a session-start prompt.

## Why

This file previously operated as a Codex-specific session-start prompt,
built before `AGENTS.md`/`PROTOCOL.md`/`CR_LIFECYCLE.md` existed. Its
process content (First Rule, Daily Workflow, Scope Protection,
Communication Style, Problem Classification) duplicated `AGENTS.md`'s
Workflow and Agent Handoff Protocol sections almost exactly, in different
words. Its Document Loading Rules — a task-type-to-document map — referenced
filenames (`schema.md`, `database-conventions.md`, `api-contracts.md`,
`workflow-definitions.md`, `ui-design.md`, `authentication.md`,
`authorization.md`, `security.md`) that never matched the repository's
actual `00`–`33` numbered convention and had gone stale.

## What to use instead

`AGENTS.md` for agent conduct and workflow. `_ORVION_CANONICAL/manifest.md`
for current phase, current task, and the active Change Request. A
repository-level reading list, completing `README.md`'s reading order, is
the superseding replacement for this file's document-loading-map role —
see a later Repository Engineering package for that work.

## Do not

- Do not treat this file as a session-start prompt.
- Do not restore its document-loading map; the filenames it referenced no longer match this repository's structure.
