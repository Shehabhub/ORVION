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

Last Completed: Phase-8 attribution-click capture — migration `202607049400`: `app.capture_attribution_click` (SECURITY DEFINER, integration-role-only; explicit tenant since landing-page capture is pre-auth) writes `attribution_clicks` (gclid/gbraid/wbraid + consent + UTM, canon 21) and sets the lead's first-touch anchor (`leads.attribution_click_id`) only when null. Consent stored-not-enforced (claim RPC is the sole gate). Emits `attribution_click_captured`. Verified: reset clean, smoke `ALL CHECKS PASSED (72)`, behavioral green (capture+anchor, first-touch not overwritten on 2nd click, bad source rejected, grants exact). **This completes the ORVION-side Phase-8 pipeline: capture → map → claim → ack** (migrations 049200/049300/049400). Only the n8n workflow remains (owner-exclusive: Google OAuth + `orvion_integration` password).

Next capability: **Integration Catalog seed + n8n workflow spec** (backlog Adopt-Later, trigger = Phase 8 landed — now due). Author the canonical integration-contract doc for the Google Data Manager delivery: the ORVION RPC pipeline, exact n8n node sequence, Data Manager API payload mapping, SHA-256 hashing spec, and the owner-exclusive setup (Google OAuth `datamanager` scope, `orvion_integration` login+password). That reduces Phase 8's owner dependency to credentials only. **Then the highest-value autonomous roadmap unit** — candidate: Quotations workflow (inert schema + canon state machine exist; no owner-exclusive dependency; delegated engineering authority covers the quotation→booking design). Phase 9 Tier B stays evidence-gated; subscription lifecycle blocked on owner C4/C5 business policy.

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
