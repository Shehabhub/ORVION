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

Current Module: Finance Core — booking-level Cancel/Void transitions (`confirmed/in_progress → cancelled`, `issued → void`, `void → completed`) COMPLETE, minting `CANCEL_BOOKING` (ADR-0020 capability set, slice 4). (Next work is stated once, below, in the single `Next capability` field.)

Active Change Request: None

Last Completed: SPEC-097 — booking Cancel/Void transitions: `app.advance_booking` now allows `confirmed/in_progress → cancelled` and `issued → void` under the new finance-consequential permission `CANCEL_BOOKING` (owner/ceo/branch_manager/finance_manager), and `void → completed` under `CREATE_BOOKING`; every `cancelled` edge now requires a cancellation reason (canon-27 alignment, folded in). Pre-approval cancels stay under `CREATE_BOOKING`. Canon 25/28 updated. Prior: SPEC-096 (booking Issue + negative-balance risk flag, `ISSUE_BOOKING`); SPEC-095 (`AGENTS.md` checkpoint-vs-pause); SPEC-094 (booking Progress); SPEC-093 (booking Approve).

Next capability: final slice of the ADR-0020 booking capability set — **Refund/Reissue**: `issued → refunded`, `issued → reissue`, `reissue → issued`, `refunded → completed`, minting `REFUND_BOOKING` and `REISSUE_BOOKING`. After it, the entire booking lifecycle (26 Booking State Machine) is implemented and the ADR-0020 capability set is complete — at which point a brief Phase-6 booking-lifecycle coherence check + the roadmap's remaining Finance Core outputs (payments/receipts/invoices/refunds workflows, profit per item) come into view.

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
