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

Current Module: Finance Core — booking-level Issue transition (`in_progress → issued`, `issued → completed`) COMPLETE, minting `ISSUE_BOOKING` and landing the negative-balance issuance risk flag (ADR-0020 capability set, slice 3). (Next work is stated once, below, in the single `Next capability` field.)

Active Change Request: None

Last Completed: SPEC-096 — booking Issue transition: `app.advance_booking` now allows `in_progress → issued` (`booking_issued`) under the new finance-consequential permission `ISSUE_BOOKING` (owner/ceo/branch_manager/finance_manager) and `issued → completed` under `CREATE_BOOKING`. Issuing before full collection (any currency with `app.customer_balance` outstanding > 0) additionally requires `ALLOW_ISSUE_WITH_NEGATIVE_BALANCE` and emits the canonical `booking_item_risk_flag_created` event (severity `risk`) capturing the per-currency balance snapshot — closing the long-deferred ADR-0020 risk flag. Canon 25/28 updated. Prior: SPEC-095 (`AGENTS.md` checkpoint-vs-pause clarification); SPEC-094 (booking Progress transitions); SPEC-093 (booking Approve, `APPROVE_BOOKING`).

Next capability: complete the ADR-0020 booking capability set (capability-by-capability, minted per-consumer): (a) **Cancel/Void** — `confirmed/in_progress → cancelled`, `issued → void`, `void → completed`, minting `CANCEL_BOOKING`; (b) **Refund/Reissue** — `issued → refunded/reissue`, `reissue → issued`, `refunded → completed`, minting `REFUND_BOOKING`/`REISSUE_BOOKING` — after which the booking lifecycle (26) is fully implemented.

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
