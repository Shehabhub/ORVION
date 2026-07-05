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

Last Completed Task: SPEC-048 — migration 17 (marketing and offline conversion tables): created marketing_campaigns, campaign_daily_metrics, attribution_clicks, offline_conversions, offline_conversion_deliveries per 31 section 10; money columns numeric(14,2), count metrics numeric, currency_code real FKs, plain-text platform/status/source/event codes, updated_at triggers on marketing_campaigns/campaign_daily_metrics; verified on a clean local database (attribution_click_id FK restrict + marketing_campaigns moddatetime). All 71 business/support tables of the frozen schema are now live

Next Planned Task: Migration 18 — seed system catalogs (populate catalog_values from 25_catalog_registry.md, plus reference-data seeds for currencies/countries/languages/nationalities). Data-only, no DDL; run its content-verification checkpoint. After 18, the next unit is migration 19 (RLS) which is an OWNER ARCHITECTURAL GATE (active-tenant context design; stop for owner input). Also due around now: a Database Naming Audit (66+ tables, past the ~half-of-71 trigger) surfaced as findings/CRs, not silent edits.

Active Change Request: None

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
