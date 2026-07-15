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

Current Phase: Between phases — Phase 7 Documents COMPLETE (frozen in `32`); Phase 8 (Offline Conversion) not yet started. Phases 2–7 COMPLETE. Supabase-native backend (ADR-0014).

Current Module: Phase 7 Documents COMPLETE and frozen. Awaiting `Start Phase 8`. (Next work is stated once, below, in the single `Next capability` field.)

Active Change Request: None

Session Checkpoint (2026-07-14, pre-Phase-8): an owner-directed whole-system review + external-integration research session is preserved at `reports/history/session-discovery-checkpoint-2026-07-14.md` (5-specialist verification pass, Google-Ads/Meta/CRM compatibility findings, approved proposals P1–P7, UUIDv7/Self-Healing/Self-Learning/Airports-Airlines conclusions, a consolidated synchronization register, and pending owner decisions). A new session should read that record and continue from the preserved engineering state — decide continuation (further verification vs implementation) from the repository, not restart analysis. No canonical changes have been applied yet; they await owner sign-off per that record.

Governance update (2026-07-15): the owner's Delegation & Model-Selection policy is now persisted authoritatively in `AGENTS.md §2` (expanded "Delegation is Earn-It-gated" bullet); it supersedes the earlier "delegate whenever it increases quality / cost is not a concern" stance recorded in checkpoint §1.4.

Repository Recovery (2026-07-15, COMPLETE): an owner-directed synchronization/consistency/cleanup/drift-prevention phase reconciled the Master suite to implementation truth, persisted policy refinements into `AGENTS.md`/`GOVERNANCE.md` (governance now **v1.6**, Living-Documents-first), annotated superseded canon prose, and installed a permanent CI consistency guard (`scripts/check_repository_consistency.ps1`). Full record: `reports/history/repository-recovery-completion-2026-07-15.md`. No business/architecture change; Phase 8 remains not started. Pending owner decisions and the next-phase sequencing recommendation (Reporting/RC-4 vs Phase 8) are in that report §4–§5.

Last Completed: SPEC-119 — R5 attribution capture: added `gbraid`/`wbraid` + Google consent signals (`consent_ad_user_data`/`consent_ad_personalization`, CHECK granted/denied/unspecified) to `attribution_clicks`, and a first-touch `leads.attribution_click_id` anchor (FK `on delete restrict`, indexed) — migration `202607048700`, canon `21`/`31` updated. Closes the Phase-8 capture-side prerequisite. Prior: SPEC-118 DC-1 money precision (numeric(19,4), RK-01); SPEC-117 RLS InitPlan (A1); SPEC-114 tenant_id indexes (A2).

Next capability: `Start Phase 8` (Offline Conversion — Google Ads offline-conversion feedback: click capture `gclid`/`gbraid`/`wbraid` + consent, lead attribution, CRM outcome mapping, internal conversion event, delivery + retry). Phase-8 Design Review: read `21_offline_conversion_engine.md` + `18_integration_priority.md` + the marketing/offline-conversion tables (migration `202607043000`); verify attribution capture at lead intake (deferred check noted in the roadmap) as an early step. Research-warranted area (Google Ads offline conversions API + consent) per Learn-Before-Designing.

Prior phases (summary; full history in git log + `changes/` + `reports/`): Phase 2 (Database Foundation, migrations 1–20) COMPLETE; Phase 3 (Identity & Access) COMPLETE; Phase 4 (CRM Core) COMPLETE at SPEC-072; Phase 5 (Booking Core) COMPLETE — SPEC-073…080 (booking / item / passenger creation + linkage, item + booking transitions, internal supplier linkage) plus SPEC-081–083 (finance-gate execution-approval control) done; negative-balance risk flag deferred to Finance Core per ADR-0020.

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` (with `GOVERNANCE.md` for knowledge governance and `CR_LIFECYCLE.md` for CR mechanics). `PROTOCOL.md` is retired to a pointer and owns nothing.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.
- Per-capability history and rationale — the git log, `changes/*.md`, and `reports/`.

End of Document.
