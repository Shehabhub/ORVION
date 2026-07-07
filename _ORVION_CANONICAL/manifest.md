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

Current Module: Finance Core — `app.customer_balance(...)` derived read-only primitive COMPLETE (ADR-0021). (Next work is stated once, below, in the single `Next capability` field.)

Active Change Request: None

Last Completed: SPEC-091 — Manifest-sync root-cause fix + research-as-Design-Review-tool. `Next capability` is now a single field (removed the redundant "Next:" from Current Module) and the `Complete` command (`CR_LIFECYCLE.md §9`) now updates Current Module + Last Completed + Next capability together, so the manifest can never leave `Next capability` naming a completed capability. `AGENTS.md` §3 stage 2 broadened Learn-Before-Designing into graduated, on-demand research. Prior: SPEC-090 (minimal-context/precedent discipline in §3); SPEC-089 (`app.customer_balance` — derived per-currency outstanding balance, ADR-0021).

Next capability: the finance-gated booking-level transitions (`pending_approval → confirmed` [Approve], issuance [Issue], void/refund/reissue [Cancel/Refund/Reissue]) with their capability permissions (ADR-0020; memory `booking-transition-authority-model`), minted per-consumer — completing the booking lifecycle that `advance_booking` currently raises "arrives with the finance-approval gate" for. The negative-balance issuance risk flag (ADR-0020, now unblocked by `app.customer_balance()`) lands with the Issue transition as a first-class event.

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
