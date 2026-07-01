# CHANGE_REQUEST.md — Superseded

Status: Deprecated. Do not use this file's format for new Change Requests.

## Why

This file previously defined a second, independent Change Request format
(sections: Change ID, Title, Objective, Scope, Out of Scope, Business Reason,
Risks, Acceptance Criteria, Status) alongside `TEMPLATE.md`'s format, with a
different Status vocabulary (Draft / Approved / Implemented / Rejected) than
`TEMPLATE.md`'s (Draft / Approved / In Progress / Complete / Cancelled) and
without `TEMPLATE.md`'s Assigned Model Tier, Minimum Reading List, deterministic
numbered Implementation Steps, or Review Gate sections.

Two Change Request formats in the same folder is exactly the kind of ambiguity
that causes the local execution agent to stop and ask for clarification instead
of executing — a task written against this file's format would not satisfy
`TEMPLATE.md`'s determinism requirements, and there was no rule anywhere stating
which of the two formats was authoritative.

## What to use instead

`TEMPLATE.md` is the single authoritative Change Request format for this
repository. It has been extended to include this file's genuinely useful
sections (Business Reason, Risks) so no content is lost — only the duplicate
format is retired.

## Status word mapping, if migrating an old-format request

| This file's old value | `TEMPLATE.md` equivalent |
| --- | --- |
| Draft | Draft |
| Approved | Approved |
| Implemented | Complete |
| Rejected | Cancelled |

## Do not

- Do not create a new Change Request using this file as a starting point.
- Do not hand this file, or a file copied from it, to the local execution agent
  as a task.
