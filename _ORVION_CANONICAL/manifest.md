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

Current Phase: Phase 7 — Documents (application layer), on the Supabase-native backend (ADR-0014). Phase 6 Finance Core COMPLETE (frozen in `32`).

Current Module: Phase 7 Documents — upload/linkage, versioning/archival, and expiry surfacing COMPLETE (`upload_document`, `add_document_version`, `archive_document`, `expiring_documents`). Remaining: financial-document visibility. (Next work is stated once, below, in the single `Next capability` field.)

Active Change Request: None

Last Completed: SPEC-111 — `app.expiring_documents(p_within_days)`: derived read-only list of non-archived documents expiring on/before now + N days (incl. already-expired), with `days_until_expiry`; the query behind expiry alerts (`16`; scheduled notification is a Phase-10/ADR-0018 concern).

Next capability: **financial-document visibility** — a read-only `app.financial_documents(...)` (or a `VIEW_FINANCIAL_DOCUMENTS`-guarded read) distinguishing financial documents (invoice/receipt-linked) from travel documents (`16`/`28`: financial documents require stricter visibility). This is the last Phase-7 output → then `Freeze Phase 7` + Phase-7 completion review. Reference: `08`/`16` + `28` (`VIEW_FINANCIAL_DOCUMENTS`/`VIEW_TRAVEL_DOCUMENTS`).

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
