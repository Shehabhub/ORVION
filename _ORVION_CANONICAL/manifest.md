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

Current Task: Write SQL migrations per 33_sql_migration_plan.md's sequence. Complete so far: migrations 1 (enable_extensions), 2 (system catalog tables), 3 (reference tables: currencies), the updated_at trigger retrofit (SPEC-028), and migration 4 (organization tables: tenants, branches, departments, branch_business_hours, holidays — SPEC-029); plus the canonical amendments SPEC-027 (Referential Action + updated_at) and SPEC-030 (Status FK Pattern: status/type codes are plain text, DB enforcement optional per-column). The next unit is migration 5 (identity and access: users, roles, permissions, role_permissions, user_branch_assignments, user_role_assignments), which introduces the users <-> auth.users link via auth_user_id (30 Identity Key Standard) and begins actor columns referencing users. After migration 5, the SPEC-024 Finding F2 deferred catalog_values foreign keys (tenant_id -> tenants, created_by -> users) become addable. Reference Data Layer (countries/languages/nationalities per 25_catalog_registry.md) must be decided before migrations 8-10 (see reports/future-backlog.md). The npm dependency-manifest decision is deferred to its own Change Request. Package 7 (Historical Audit-Trail Note) remains open, blocked on human input, and does not block SQL implementation.

Last Completed Task: SPEC-029 — migration 4 (organization tables): created tenants, branches, departments, branch_business_hours, holidays with 8 restrict/no-action foreign keys, unique constraints, indexes, and per-table updated_at triggers; verified on a clean local database (Database Audit + behavioral restrict/trigger tests)

Next Planned Task: Migration 5 — identity and access tables (users, roles, permissions, role_permissions, user_branch_assignments, user_role_assignments) per 33_sql_migration_plan.md; run its Migration Design Review Gate before drafting

Active Change Request: changes/SPEC-031-identity-auth-nullability.md

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
