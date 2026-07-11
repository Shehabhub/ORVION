# ORVION

## Purpose

ORVION is the project identity and working repository for the travel CRM and operations system. This README serves as the primary entry point for humans and AI agents.

## Repository Structure

* `AGENTS.md` - AI agent operating rules for this repository (execution conduct authority).
* `GOVERNANCE.md` - Knowledge & decision operating system: where every fact lives (SSOT map), the decision/report lifecycles, and where agents may write.
* `llms.txt` - Curated boot map for AI agents.
* `WORKSTATION.md` - Entry point for rebuilding the engineering environment on a fresh machine (points to `.workstation/`). Separate from ORVION development, which starts here.
* `PROTOCOL.md` - Retired → pointer to `AGENTS.md`/`GOVERNANCE.md`.
* `PROJECT_CONTEXT.md` - Project context for AI agents.
* `CODING_STANDARDS.md` - Repository coding standards.
* `global-rules.md` - Retired → pointer to `AGENTS.md §6`.
* `_ORVION_CANONICAL/` - Canonical project documents and source of truth.
* `scripts/` - Development and maintenance scripts.
* `changes/` - Active change requests.
* `supabase/` - Local Supabase configuration and database resources.

## Boot Sequence

A fresh session bootstraps itself from the repository — no prior conversation or `/resume` required. Read only what the current state calls for; large documents stay unread until the state needs them.

1. **`AGENTS.md`** — the operating model and execution brain: how work is done here, what governs conduct, the standing authorities, how decisions are made, and where to look next. Read this first.
2. **`_ORVION_CANONICAL/manifest.md`** — the live state: current phase, module, and `Active Change Request`.
3. **If `Active Change Request` is not `None`** — read that `changes/SPEC-*.md`; its own Minimum Reading List takes over from here.
4. **If it is `None`** — read `_ORVION_CANONICAL/32_execution_roadmap.md` for the current phase and its next capability.
5. **Task-specific canon only** — `_ORVION_CANONICAL/00`–`23` (business/domain rules), `24`–`33` (schema/database), and the cross-cutting principle docs `34_authentication_and_identity_principles.md` and `35_tenant_isolation_and_data_access_principles.md`. Read only what the current task needs.
6. **Rationale, on demand** — `reports/` for the "why" behind a decision; `reports/architecture-decision-records.md` for active ADRs; `reports/future-backlog.md` for deferred work and its triggers.

## Development Principles

* Preserve the existing project direction.
* Keep changes small and local.
* Respect documented decisions.
* Validate assumptions before changing code.
* Stop and ask when requirements are unclear.

## Repository Rules

* Do not modify canonical documents unless explicitly requested.
* Keep changes minimal.
* Follow `AGENTS.md`.
* Follow project coding standards.

## Project Status

Current Phase:

See `_ORVION_CANONICAL/manifest.md`'s Current Development Status — not restated here, to avoid the two falling out of sync.

Source of Truth:

`_ORVION_CANONICAL/`

Repository Policy:

Canonical-first
