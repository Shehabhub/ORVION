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

Current Module: Phase 7 Documents — upload/linkage + versioning/archival COMPLETE (`app.upload_document`, `app.add_document_version`, `app.archive_document`). Remaining: expiry surfacing, financial-document visibility. (Next work is stated once, below, in the single `Next capability` field.)

Active Change Request: None

Last Completed: SPEC-110 — `app.add_document_version` (new current version; document stays `active`, `current_version_id` advances) + `app.archive_document` (active → `archived` with reason); guarded by `CREATE_DOCUMENT_VERSION` / `ARCHIVE_DOCUMENT`. Engineering Observation recorded: canon `26` "new version → superseded" diverges from the frozen `current_version_id` design (document stays active; document-level supersede reserved for a future explicit op).

Next capability: **document expiry surfacing** — a read-only `app.expiring_documents(p_within_days)` over official documents' `expires_at` (`16`: passport/national_id/visa/medical_certificate), the query behind expiry alerts. Then financial-document visibility (`VIEW_FINANCIAL_DOCUMENTS` distinguishing financial vs travel documents) completes Phase 7 (`32`). Reference: `08`/`16` + `documents`/`document_versions`/`document_links`.

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
