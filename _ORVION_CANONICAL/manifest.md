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

Current Phase: Phase 5 — Booking Core (application layer), on the Supabase-native backend (ADR-0014).

Current Module: Booking Core — Finance Approval Gate (ADR-0020).

Active Change Request: None

Last Completed: SPEC-081 — Finance Approval Gate execution-approval slice 1 (ADR-0020). `app.request_finance_approval(item, reason?)` opens a `pending` `finance_execution_approval`, marks the item (`finance_approval_required`, `finance_approval_status_code='pending'`), emits `finance_approval_requested`. `CREATE_BOOKING_ITEM`-guarded; mints no new permission (capability permissions recorded in ADR-0020, minted per-consumer). Verified: clean `db reset` + smoke-test (71 tables) + behavioral (create/duplicate-pending/terminal-item/terminal-booking/trainee-denial).

Next: SPEC-082 `app.review_finance_approval` (approve/reject/cancel under `APPROVE_FINANCE`; locks cost on approve), then the `confirmed → in_progress` gate precondition in `advance_booking_item`. Negative-balance risk flag deferred to Finance Core (`app.customer_balance()`), per ADR-0020.

Prior phases (summary; full history in git log + `changes/` + `reports/`): Phase 2 (Database Foundation, migrations 1–20) COMPLETE; Phase 3 (Identity & Access) COMPLETE; Phase 4 (CRM Core) COMPLETE at SPEC-072; Phase 5 (Booking Core) in progress — SPEC-073…080 (booking / item / passenger creation + linkage, item + booking transitions, internal supplier linkage) done, SPEC-081 (finance-gate slice 1) done.

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.
- Per-capability history and rationale — the git log, `changes/*.md`, and `reports/`.

End of Document.
