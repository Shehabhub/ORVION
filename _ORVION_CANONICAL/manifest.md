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

Current Module: Finance Core — beginning with a read-only, derived `app.customer_balance(...)` primitive. (The operational layer now canonicalizes the active operating model into the repository; a fresh session bootstraps from `AGENTS.md` without conversational recovery — SPEC-084.)

Active Change Request: None

Last Completed: SPEC-087 — Strategic direction into the repo: the long-term vision (operational platform + single source of truth for verified business outcomes; external platforms are consumers) now lives in `PROJECT_CONTEXT.md` §11, and the strategic deferred items (attribution capture at lead intake; Customer Communications future domain [shape undecided]; full Meta-ecosystem research; revenue-intelligence delivery posture) in `reports/future-backlog.md`. Closes the last memory-only gap — external `.claude` memory is now a pure cache. Concludes the operating-model + continuity arc (SPEC-084 → 085 → 086 → 087). (Prior domain work: SPEC-083 closed the Booking-Core finance-gate capability.)

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
