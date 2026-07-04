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

Current Task: Write SQL migrations per 33_sql_migration_plan.md's sequence. Migration 1 (enable_extensions) is complete; the next dependency-ready unit is migration 2 (system catalog tables: catalog_types, catalog_values). Two known items are recorded for later, neither blocking migration 2: a 30_database_conventions.md amendment (default referential actions and updated_at maintenance mechanism) is required before migration 4, and the npm dependency-manifest decision (package.json/package-lock.json) is deferred to its own Change Request. Package 7 (Historical Audit-Trail Note) remains open, blocked on human input, and does not block SQL implementation.

Last Completed Task: SPEC-023 — repository hygiene: ignored and untracked transient Supabase CLI artifacts (node_modules/, supabase/.temp/, supabase/.branches/)

Next Planned Task: Migration 2 — system catalog tables (catalog_types, catalog_values) per 33_sql_migration_plan.md

Active Change Request: None

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
