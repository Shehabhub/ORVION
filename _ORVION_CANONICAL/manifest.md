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

Current Phase: **Phase 8 (Offline Conversion) — IN PROGRESS** (started 2026-07-17; Phase 9 Tier A COMPLETE the same day). Execution order 7→9→8→10 (`32`). Phases 2–7 + 9 COMPLETE. Supabase-native backend (ADR-0014); transport = Data Manager API + ECL via n8n outbox (ADR-0023).

Current Module: Phase-8 offline-conversion engine — **ORVION-side core IMPLEMENTED** (migration `049200`: `orvion_integration` role, `app.record_offline_conversion`, n8n outbox pair `claim_conversion_deliveries`/`record_conversion_delivery_result` with in-DB consent gate + retry ceiling 5). Open isolated owner items (non-blocking, defaults applied): presentation currency (per-currency); "sales activity" measure (bookings-created); Google OAuth `datamanager` credentials needed only when the n8n workflow goes live.

Active Change Request: None (no SPEC drafted yet — Design Review precedes the first Phase-9 SPEC).

Context & remaining owner decisions (detail in the linked reports — not restated): sequencing is now DECIDED (RC-4/Reports before Phase 8, 2026-07-16). Background: the 2026-07-14 review approved P1–P7 (`reports/history/session-discovery-checkpoint-2026-07-14.md`, canonical realization awaits sign-off); the 2026-07-15 Repository Recovery (`reports/history/repository-recovery-completion-2026-07-15.md`, COMPLETE) reconciled the repo (governance v1.6, permanent consistency guard). **Still-open owner decisions:** C4/C5 (activation-code, subscription grace — at the subscription-lifecycle trigger); A3 (money-storage ADR) + live-DB V-series re-verification — at the next comprehensive DB audit. (S-EVENT/N1 **RESOLVED** 2026-07-17: migration `049100` seeds the `event_type`/`event_severity_code` catalogs from canon 27 and `app.record_event` now rejects unregistered codes.)

Last Completed: Quotations workflow — migration `202607049500`: `create_quotation` (QT- number fallback mirroring bookings) / `add_quotation_item` (draft-only, catalog-validated, header-total recompute) / `advance_quotation` (full canon-26 state machine incl. rejected/expired→draft revise loop; per-transition permissions CREATE/SEND/ACCEPT_QUOTATION, pre-seeded) + `create_booking` extended with `p_quotation_id` (accepted-only, customer-match enforced; original body preserved verbatim — the readiness-contract consumption untouched). No auto lead-transition on send (advance_lead stays the lead authority; event published for future reactors). Verified: reset clean, smoke `ALL CHECKS PASSED (72)`, **10-assertion behavioral suite green through the real auth chain** (JWT claims + owner role + aal2). Prior: Integration Catalog (GOVERNANCE v1.9), Phase-8 ORVION-side pipeline (049200–049400).

Next capability: **The autonomous frontier is reached.** Every remaining roadmap item is either **owner-gated** — Phase-8 n8n workflow (needs Google OAuth `datamanager` + `orvion_integration` password, `MASTER_INTEGRATION_CATALOG.md §3`); subscription lifecycle (C4/C5 business policy); HR (owner scheduling); Phase-10 comms *implementation* (Meta accounts/verification) — or **evidence-gated** (Phase 9 Tier B on measured cost; composite indexes A2 on volume). **One autonomous option remains open:** the Phase-10 Meta-ecosystem Learn-Before-Designing research + communications-domain Design Challenge (research and design are autonomous; only implementation needs owner accounts) — start it if the owner wants Phase 10 designed ahead of credentials, otherwise the repo idles clean awaiting the catalog-§3 inputs.

Prior phases (summary; full history in git log + `changes/` + `reports/`): Phase 2 (Database Foundation, migrations 1–20) COMPLETE; Phase 3 (Identity & Access) COMPLETE; Phase 4 (CRM Core) COMPLETE at SPEC-072; Phase 5 (Booking Core) COMPLETE — SPEC-073…080 (booking / item / passenger creation + linkage, item + booking transitions, internal supplier linkage) plus SPEC-081–083 (finance-gate execution-approval control) done; negative-balance risk flag deferred to Finance Core per ADR-0020.

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` (with `GOVERNANCE.md` for knowledge governance and `CR_LIFECYCLE.md` for CR mechanics). `PROTOCOL.md` is retired to a pointer and owns nothing.
- Document discovery and reading order — `AGENTS.md §4` (the single, mandatory boot sequence); `README.md` is the one-hop router into it.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.
- Per-capability history and rationale — the git log, `changes/*.md`, and `reports/`.

End of Document.
