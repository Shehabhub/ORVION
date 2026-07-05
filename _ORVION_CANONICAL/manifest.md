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

Current Task: Write SQL migrations per 33_sql_migration_plan.md's sequence. Migrations 1-15 are complete (SPEC-022 through SPEC-045), verified on clean local resets and by Migration CI. This includes the full booking/CRM/finance/event/subscription/document-link core: migration 10 (booking core — SPEC-040), 11 (CRM extensions — SPEC-041), 12 (finance transactions — SPEC-042), 13 (events & notifications — SPEC-043), 14 (subscriptions — SPEC-044), and 15 (document_links with its single-target CHECK — SPEC-045), completing the approved migrations 10-15 continuous phase. Canonical settlements remain in force: Referential Action Standard (SPEC-027), Status/type codes are plain text while currency/geo codes are real FKs (SPEC-030), the membership Identity model (SPEC-031/033; ADR-0004/0011), and the Reference Data Layer (SPEC-037). The next unit, migration 16 (authentication support tables), is an OWNER ARCHITECTURAL GATE (ADR-0011 auth-support re-homing) and must not proceed without owner input. Deferred backlog items remain tracked in reports/future-backlog.md (business-key uniqueness for bookings/quotations/subscriptions; non-negative CHECKs on finance money columns; DB-enforced event immutability at RLS migration 19; SPEC-024 F2 catalog_values FKs).

Last Completed Task: SPEC-049 — migration 18 (seed system catalogs): idempotent seed of catalog_types (65) + catalog_values (395) from 25_catalog_registry.md, system rows only (tenant_id null, is_system true), on-conflict-do-nothing, deterministic initcap placeholder labels, sort_order via unnest ordinality; excluded dedicated-table codes (role/permission/plan/feature), reference data, deprecated finance_approval_type, and consumer-less functional_role_code/cabin_class/fare_type/expense_category; verified on clean reset + idempotency re-run (identical 65/395 counts). RBAC/subscription/reference-data seeds remain as their own later migrations

Next Planned Task: Migration 19 — RLS policies on every tenant-owned table. THIS IS AN OWNER ARCHITECTURAL GATE: the active-tenant context design (how a human holding multiple memberships carries the active tenant to Membership Resolution) needs owner input; and per the earn-it trigger, a Tenant Isolation & Data Access Principles doc is the recommended precursor (mirrors auth-principles-before-mig-16). Also pending before/with RLS: the deferred F2 FKs (catalog_values.tenant_id/created_by ALTER) and the subscription_status-vs-tenants.status access authority. A Database Naming Audit is due (71 tables) surfaced as findings/CRs, not silent edits.

Active Change Request: None

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
