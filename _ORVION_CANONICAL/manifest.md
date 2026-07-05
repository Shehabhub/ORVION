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

Last Completed Task: SPEC-053 — migration 20 (database verification): added scripts/verify_database.sql, an executable 9-assertion smoke-test over the foundation (extensions; 71 public tables; RLS on all; no RLS table without a policy; app.current_tenant_id() resolver; 65 catalog_types + 395 catalog_values; Referential Action Standard with its 3 documented exceptions; updated_at triggers; append-only audit triggers). Passes clean (exit 0); proven to exit non-zero on a broken invariant. THIS CLOSES THE 20-STAGE 33_sql_migration_plan.md — the ORVION database foundation (schema + seed + RLS + verification) is complete.

Next Planned Task: Post-foundation activities (no owner gate unless one arises): (1) Database Naming Audit across the 71 tables (surface cosmetic/naming findings as CRs, not silent edits; known candidates: tenants.status, unprefixed status_code, catalog_type_code registry-verbatim naming); (2) the deferred Architecture Knowledge Layer evaluation (owner-scheduled for the stable post-database state — keep deferred, do not run yet). After that, the next major phase is the backend/API layer (where the deferred authenticated DML grants and subscription-state gating land).

Active Change Request: None

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
