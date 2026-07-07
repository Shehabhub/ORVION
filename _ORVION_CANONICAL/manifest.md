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

Last Completed: SPEC-082 — Finance Approval Gate execution-approval slice 2 (ADR-0020). `app.review_finance_approval(request, decision, reason?)` resolves a pending `finance_execution_approval` along the `26` Finance Approval State Machine: approve/reject under `APPROVE_FINANCE` (MFA composes), cancel by the requester under `CREATE_BOOKING_ITEM`; approve locks cost (`cost_locked_at`) and sets the item approved. Emits `finance_approval_approved|_rejected|_cancelled`. Verified: clean `db reset` + smoke-test (71 tables) + behavioral (approve+lock, reject, cancel, non-pending rejected, non-finance denial 42501).

Next: SPEC-083 — the `confirmed → in_progress` gate precondition in `advance_booking_item` (block execution unless an approved `finance_execution_approval` exists for an item that requires it). Negative-balance risk flag deferred to Finance Core (`app.customer_balance()`), per ADR-0020.

Prior phases (summary; full history in git log + `changes/` + `reports/`): Phase 2 (Database Foundation, migrations 1–20) COMPLETE; Phase 3 (Identity & Access) COMPLETE; Phase 4 (CRM Core) COMPLETE at SPEC-072; Phase 5 (Booking Core) in progress — SPEC-073…080 (booking / item / passenger creation + linkage, item + booking transitions, internal supplier linkage) done, SPEC-081–082 (finance-gate slices 1–2: request + review) done.

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.
- Per-capability history and rationale — the git log, `changes/*.md`, and `reports/`.

End of Document.
