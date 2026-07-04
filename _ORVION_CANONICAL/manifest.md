# ORVION Project Manifest

Version: 2.0
Status: Canonical
Purpose: Repository State
Loaded After: AGENTS.md

---

# Purpose

This document tells any agent or human where the project currently stands.

It exists to answer one question: what phase, task, and Change Request is active right now.

For where to begin, what to read, and who governs conduct, see `README.md` and `AGENTS.md` — this document does not restate their responsibilities.

This file should always reflect the current state of the project.

---

# Current Development Status

Update this section continuously.

Current Phase: Database Foundation

Current Sprint: SQL migration authoring

Current Module: Database Foundation

Current Task: Write SQL migrations per 33_sql_migration_plan.md's sequence. Migrations 1 (enable_extensions) and 2 (system catalog tables) are complete; the next dependency-ready unit is migration 3 (reference tables: currencies). Three known items are recorded for later, none blocking migration 3: a 30_database_conventions.md amendment (default referential actions and updated_at maintenance mechanism) is required before migration 4; a small Change Request should add catalog_values' deferred foreign keys (tenant_id -> tenants, created_by -> users) after migration 5 (SPEC-024 Finding F2); and the npm dependency-manifest decision (package.json/package-lock.json) is deferred to its own Change Request. Package 7 (Historical Audit-Trail Note) remains open, blocked on human input, and does not block SQL implementation.

Last Completed Task: SPEC-026 — side task: added a branch-agnostic publish-on-Complete clause to AGENTS.md's Complete command (git push to the current branch's upstream after completing a Change Request)

Next Planned Task: Migration 3 — reference tables (currencies) per 33_sql_migration_plan.md (resume at Approve SPEC-025)

Active Change Request: changes/SPEC-025-migration-3-reference-tables.md

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
