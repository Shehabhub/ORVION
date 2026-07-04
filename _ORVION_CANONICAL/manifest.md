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

Current Task: Write SQL migrations per 33_sql_migration_plan.md's sequence. Complete so far: migrations 1 (enable_extensions), 2 (system catalog tables), 3 (reference tables: currencies), the updated_at trigger retrofit (SPEC-028), and migration 4 (organization tables: tenants, branches, departments, branch_business_hours, holidays — SPEC-029); plus the canonical amendments SPEC-027 (Referential Action + updated_at) and SPEC-030 (Status FK Pattern: status/type codes are plain text, DB enforcement optional per-column). The Identity model is settled: a users row is a human's membership in one tenant, auth.users is the shared human identity, and auth_user_id is nullable and unique per tenant (SPEC-031 nullability + SPEC-033 membership model; ADR-0004/0011). Migration 5 (identity and access tables) is complete (SPEC-032, membership model). Migration CI is complete (SPEC-034): a GitHub Actions workflow runs supabase start + supabase db reset on every push/PR touching migrations, verified green in CI (all migrations apply cleanly on a fresh database). Migrations 6 (finance foundation — SPEC-035) and 7 (document core: documents, document_versions with the deferred mutual FK — SPEC-036) are complete. The next unit is migration 8 (CRM core), but it is GATED on the Reference Data Layer decision (whether to add countries/languages/nationalities reference tables with FKs, or keep those codes plain text): customers/passengers/bookings (migrations 8-10) carry preferred_language_code / nationality_code / destination_country_code. This is an architectural decision surfaced for owner approval before migration 8. After migration 5, the SPEC-024 Finding F2 deferred catalog_values foreign keys (tenant_id -> tenants, created_by -> users) become addable. The invitation/activation lifecycle model (invitation records, invited_at/activated_at, invited_by, user status) is deferred to reports/future-backlog.md and does not block migration 5. Reference Data Layer (countries/languages/nationalities per 25_catalog_registry.md) must be decided before migrations 8-10 (see reports/future-backlog.md). The npm dependency-manifest decision is deferred to its own Change Request. Package 7 (Historical Audit-Trail Note) remains open, blocked on human input, and does not block SQL implementation.

Last Completed Task: SPEC-036 — migration 7 (document core): created documents and document_versions, resolving their mutual reference via a deferred ALTER for documents.current_version_id, with the one-current-version partial unique index; verified on a clean local database and by Migration CI

Next Planned Task: Reference Data Layer decision (architectural — surfaced for owner approval): add countries/languages/nationalities reference tables with FKs, or keep those codes plain text — required before migration 8 (CRM core). Then migration 8 (customers, contact methods, identity signals/merges, notes, leads, lead_assignments, lead_interactions).

Active Change Request: None

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
