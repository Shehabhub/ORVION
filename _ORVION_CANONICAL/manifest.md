# ORVION Project Manifest

Version: 2.1
Status: Canonical
Purpose: Repository State
Loaded After: AGENTS.md

---

# Purpose

This document tells any agent or human where the project currently stands.

It exists to answer one question: what phase, task, and Change Request is active right now.

For where to begin, what to read, and who governs conduct, see `README.md` and `AGENTS.md` — this document does not restate their responsibilities.

This file holds ONLY current state. Detailed per-SPEC history is NOT restated here — it lives in the git log, `changes/*.md`, and `reports/`. Keeping this file lean keeps every session/`resume` cheap (it is re-read on every bootstrap).

---

# Current Development Status

Update this section continuously; keep it to current state only. `Last Completed` names only the single most recent capability — replace it each time, never chain a "Prior:" history (git log + `changes/` + `reports/` hold history). If any field starts becoming a changelog, trim it.

Current Phase: Phase 6 — Finance Core (application layer), on the Supabase-native backend (ADR-0014).

Current Module: Finance Core — invoicing/receivables: create → issue → pay. `app.create_invoice`, `app.issue_invoice`, and `app.record_payment` (allocation + `partially_paid`/`paid` derivation) COMPLETE. (Next work is stated once, below, in the single `Next capability` field.)

Active Change Request: None

Last Completed: SPEC-102 — `app.record_payment`: records a customer payment against an issued invoice, allocates it (`payment_allocations`), derives status `partially_paid`/`paid`, and draws down the receivable in `app.customer_balance`; guarded by `RECORD_PAYMENT`; emits `payment_recorded` + the invoice status-transition event.

Next capability: **receipts** — issue a receipt document per recorded payment (`receipts` table, per-tenant receipt number, mirrors the invoice-number scheme). Then supplier payables (the `supplier_payment` direction mirror of invoice→payment), refund workflows, basic journal entries, and profit per booking item (`32` Phase 6). Deferred future slices (recorded in SPEC-102): multi-invoice allocation, on-account credit/overpayment, cross-currency allocation via `exchange_rate_id`.

Prior phases (summary; full history in git log + `changes/` + `reports/`): Phase 2 (Database Foundation, migrations 1–20) COMPLETE; Phase 3 (Identity & Access) COMPLETE; Phase 4 (CRM Core) COMPLETE at SPEC-072; Phase 5 (Booking Core) COMPLETE — SPEC-073…080 (booking / item / passenger creation + linkage, item + booking transitions, internal supplier linkage) plus SPEC-081–083 (finance-gate execution-approval control) done; negative-balance risk flag deferred to Finance Core per ADR-0020.

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.
- Per-capability history and rationale — the git log, `changes/*.md`, and `reports/`.

End of Document.
