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

Update this section continuously; keep it to current state only.

Current Phase: Phase 6 — Finance Core (application layer), on the Supabase-native backend (ADR-0014).

Current Module: Finance Core — invoicing: `app.create_invoice(...)` COMPLETE (first finance-transaction write; creates a `draft` invoice with a per-tenant year-prefixed unique number `INV-YYYY-NNNN`). The ADR-0020 booking lifecycle is complete; Finance Core write capabilities have begun. (Next work is stated once, below, in the single `Next capability` field.)

Active Change Request: None

Last Completed: SPEC-100 — `app.create_invoice`: creates a customer invoice in `draft` with a per-tenant, year-prefixed, DB-unique sequential number (`INV-YYYY-NNNN`; unique index `invoices_tenant_number_key`; race-safe via a per-(tenant,year) advisory lock; non-gapless by design per researched legal/industry practice), guarded by `CREATE_INVOICE`, emitting `invoice_created`. First finance-transaction write capability. Prior: SPEC-099 (CI reliability — pinned Supabase CLI); SPEC-098 (booking Refund/Reissue, completing the ADR-0020 lifecycle); SPEC-097 (Cancel/Void); SPEC-096 (Issue + risk flag).

Next capability: continue Finance Core invoicing/receivables (`32` Phase 6). Natural next slice: **issue-invoice** (`draft → issued`), which turns a draft into a live receivable that `app.customer_balance` counts — this also connects invoicing to the booking issuance risk flag. Then payment recording (drives `partially_paid`/`paid` via `payment_allocations`), receipts, refund workflows, basic journal entries, and profit per booking item. No canonical invoice state machine exists in `26` yet; if the issue/paid/void lifecycle grows beyond the obvious, propose adding one (Design-Review call at that point).

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
