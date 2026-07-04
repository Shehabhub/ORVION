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

Current Task: Write SQL migrations per 33_sql_migration_plan.md's sequence. Complete so far: migrations 1 (enable_extensions), 2 (system catalog tables), 3 (reference tables: currencies), the updated_at trigger retrofit (SPEC-028), and migration 4 (organization tables: tenants, branches, departments, branch_business_hours, holidays — SPEC-029); plus the canonical amendments SPEC-027 (Referential Action + updated_at) and SPEC-030 (Status FK Pattern: status/type codes are plain text, DB enforcement optional per-column). The Identity model is settled: a users row is a human's membership in one tenant, auth.users is the shared human identity, and auth_user_id is nullable and unique per tenant (SPEC-031 nullability + SPEC-033 membership model; ADR-0004/0011). The next unit is migration 5 (identity and access: users, roles, permissions, role_permissions, user_branch_assignments, user_role_assignments). SPEC-032 is drafted and being revised to the membership model: users.auth_user_id unique per (tenant_id, auth_user_id), ON DELETE SET NULL; tenant_id NOT NULL (platform-tenant convention); users unique (tenant_id, email); roles.code / permissions.key uniques; role_permissions(role_id, permission_id) unique; one current primary branch per user via partial unique index. Migration CI (a supabase db reset GitHub Action + pre-push check) lands immediately after migration 5, before migration 6. After migration 5, the SPEC-024 Finding F2 deferred catalog_values foreign keys (tenant_id -> tenants, created_by -> users) become addable. The invitation/activation lifecycle model (invitation records, invited_at/activated_at, invited_by, user status) is deferred to reports/future-backlog.md and does not block migration 5. Reference Data Layer (countries/languages/nationalities per 25_catalog_registry.md) must be decided before migrations 8-10 (see reports/future-backlog.md). The npm dependency-manifest decision is deferred to its own Change Request. Package 7 (Historical Audit-Trail Note) remains open, blocked on human input, and does not block SQL implementation.

Last Completed Task: SPEC-033 — adopted the identity membership model canonically (users = a human's membership in one tenant; auth.users = the shared human identity; auth_user_id unique per tenant) across 30_database_conventions.md, 31_schema_draft.md, and ADR-0004/0011

Next Planned Task: SPEC-032 — Migration 5 identity and access tables (revise its users DDL to per-tenant auth_user_id per SPEC-033, then Approve/Execute/Review/Complete)

Active Change Request: changes/SPEC-032-migration-5-identity-and-access-tables.md

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
