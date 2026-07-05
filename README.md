# ORVION

## Purpose

ORVION is the project identity and working repository for the travel CRM and operations system. This README serves as the primary entry point for humans and AI agents.

## Repository Structure

* `AGENTS.md` - AI agent operating rules for this repository.
* `PROTOCOL.md` - Repository collaboration protocol.
* `PROJECT_CONTEXT.md` - Project context for AI agents.
* `CODING_STANDARDS.md` - Repository coding standards.
* `global-rules.md` - Global AI collaboration rules.
* `_ORVION_CANONICAL/` - Canonical project documents and source of truth.
* `scripts/` - Development and maintenance scripts.
* `changes/` - Active change requests.
* `supabase/` - Local Supabase configuration and database resources.

## First Reading Order

1. `AGENTS.md` — operational authority; states what governs conduct.
2. `_ORVION_CANONICAL/manifest.md` — current phase, current task. If Active Change Request is not `None`, read that Change Request next; its own Minimum Reading List takes over from here.
3. If Active Change Request is `None`, check `_ORVION_CANONICAL/32_execution_roadmap.md` for the current phase and next planned work.
4. Canonical documents relevant to the current task only: `_ORVION_CANONICAL/00`-`23` for business/domain rules, `_ORVION_CANONICAL/24`-`33` for schema/database structure, and the principle documents governing cross-cutting decisions: `_ORVION_CANONICAL/34_authentication_and_identity_principles.md` (authentication/identity/security) and `_ORVION_CANONICAL/35_tenant_isolation_and_data_access_principles.md` (tenant isolation, RLS, membership resolution).
5. `reports/` — narrative rationale and the Repository Engineering program plan; read only when the "why" behind a decision is needed.
6. Generated artifacts (project tree, tracked files, Repository Index once available) — read only when locating something by name rather than by task.

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
