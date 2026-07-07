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

Current Module: Finance Core — `app.customer_balance(...)` derived read-only primitive COMPLETE (ADR-0021). Next: outstanding-balance surfacing and the negative-balance issuance risk flag (ADR-0020, now unblocked).

Active Change Request: None

Last Completed: SPEC-090 — Folded the minimal-context, precedent-first discipline into `AGENTS.md` §3 Design Review (the one genuine delta from the Standard Capability Workflow proposal; the rest was already in §3/§1, and the Capability Completion Check was already the §5 cold-stop self-test — no duplication added). Prior: SPEC-089 — `app.customer_balance(p_customer_id[, p_booking_id])`: derived, read-only, per-currency outstanding balance (`invoiced − paid + refunded`; live invoices, `customer_payment`s, completed `customer_refund`s; positive = owes). SECURITY INVOKER, RLS backstop, no new permission (read-RPC precedent). Verified: clean `db reset` + smoke-test (71 tables) + behavioral (multi-currency, all exclusions, booking filter, tenant guard). Recorded as ADR-0021; unblocks the ADR-0020 negative-balance risk flag. First Phase 6 capability. (Operational-model arc SPEC-084→088 remains closed; prior domain work SPEC-083 closed the Booking-Core finance gate.)

Next capability: Phase 6 Finance Core — read-only, derived `app.customer_balance(customer_id[, booking_id])` (computed from invoices/payments/refunds, not stored); the keystone for outstanding-balance reporting and the deferred negative-balance risk flag. Then finance-gated booking-level transitions (Approve/Issue/Cancel/Refund/Reissue) with their capability permissions (see memory `booking-transition-authority-model`).

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
