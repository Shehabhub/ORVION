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

Last Completed Task: SPEC-045 — migration 15 (document_links table): created document_links per 31 section 6, the single latest-dependent table; source document_id plus eight nullable target FKs (passenger/booking/booking_item/invoice/quotation/receipt/supplier/subscription_payment_proof), all restrict/no-action, with document_links_single_target_check enforcing exactly one target per row; verified on a clean local database (0/2 targets rejected, 1 accepted). This completed the approved migrations 10-15 continuous phase (62 tables live before this; document_links makes it the phase's final table)

Next Planned Task: Migration 16 — authentication support tables (31 section 9) per 33_sql_migration_plan.md. THIS IS AN OWNER ARCHITECTURAL GATE: per ADR-0011, trusted_devices/otp_challenges/totp_enrollments are human-identity (auth.users) concerns currently keyed to (tenant_id, user_id=membership); a decision is required to re-home them to the human identity or keep them per-membership before drafting. Do not proceed past this gate without owner input. The migrations 10-15 continuous-execution authorization has been fully consumed.

Active Change Request: SPEC-046 — Authentication & Identity Principles (canonical)

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
