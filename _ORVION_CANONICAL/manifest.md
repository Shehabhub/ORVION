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

Current Task: Write SQL migrations per 33_sql_migration_plan.md's sequence. Migrations 1 (enable_extensions), 2 (system catalog tables), 3 (reference tables: currencies) are complete; the 30_database_conventions.md amendment (SPEC-027) and the updated_at trigger retrofit (SPEC-028: moddatetime enabled, triggers on catalog_values and currencies) are complete. The Status FK Pattern is now resolved canonically (SPEC-030: status/type codes are plain text, validated by seed + application/state-machine, DB enforcement optional per-column). The next unit is migration 4 (organization tables: tenants, branches, departments, branch_business_hours, holidays) — the first migration with real foreign keys — applying 30's Referential Action Standard (default on delete restrict / on update no action), a before-update updated_at trigger per table, and plain-text status/type columns per SPEC-030 (SPEC-029 already complies). Reference Data Layer (countries/languages/nationalities per 25_catalog_registry.md) must be decided before migrations 8-10 (see reports/future-backlog.md); it does not affect migration 4. Two further items remain recorded: catalog_values' deferred foreign keys (tenant_id -> tenants, created_by -> users) after migration 5 (SPEC-024 Finding F2); and the npm dependency-manifest decision, deferred to its own Change Request. Package 7 (Historical Audit-Trail Note) remains open, blocked on human input, and does not block SQL implementation.

Last Completed Task: SPEC-030 — resolved the Status FK Pattern canonically in 30_database_conventions.md (status/type codes are plain text; families owned by 25_catalog_registry.md; enforcement domain-dependent; composite FK optional per-column), resolving Migration 4 Design Review Gate Finding F1

Next Planned Task: SPEC-029 — Migration 4 organization tables (draft already complies with SPEC-030; update its F1 note, then Approve)

Active Change Request: changes/SPEC-029-migration-4-organization-tables.md

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
