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

Current Module: Finance Core — booking Refund/Reissue transitions COMPLETE, minting `REFUND_BOOKING`/`REISSUE_BOOKING`. The ADR-0020 capability-driven booking lifecycle (Submit/Approve/Issue/Cancel/Refund/Reissue) and the full 26 Booking State Machine are now implemented. (Next work is stated once, below, in the single `Next capability` field.)

Active Change Request: None

Last Completed: SPEC-098 — final booking transitions: `app.advance_booking` now allows `issued → refunded` (`REFUND_BOOKING`), `issued → reissue` (`REISSUE_BOOKING`), `reissue → issued` (reuses `ISSUE_BOOKING`, inheriting the negative-balance risk-flag gate), and `refunded → completed` (`CREATE_BOOKING`); no booking transition remains deferred. Canon 25/28 updated; the capability set is complete. Prior: SPEC-097 (Cancel/Void, `CANCEL_BOOKING`); SPEC-096 (Issue + risk flag, `ISSUE_BOOKING`); SPEC-095 (`AGENTS.md` checkpoint-vs-pause); SPEC-094 (Progress); SPEC-093 (Approve, `APPROVE_BOOKING`).

Next capability: with the booking lifecycle complete, a brief Phase-6 booking-lifecycle coherence check is warranted, then the remaining Finance Core roadmap outputs (`32` Phase 6): customer receivables surfacing, supplier payables, payments, receipts, invoices, refunds workflows, basic journal entries, and profit per booking item. Select the next dependency-ready package from that set (invoicing/payment recording is the natural keystone, since `app.customer_balance` and the issuance risk flag already consume those tables).

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
