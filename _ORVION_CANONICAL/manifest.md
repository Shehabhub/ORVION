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

Current Phase: Between phases — Phases 2–7 COMPLETE (Phase 7 Documents frozen in `32`); Phase 8 (Offline Conversion) not started. Supabase-native backend (ADR-0014).

Current Module: none active — awaiting an owner sequencing decision before the next phase begins (see `Next capability`).

Active Change Request: None

Context & pending owner decisions (detail lives in the linked reports — not restated here): the 2026-07-14 whole-system review + external-integration research (`reports/history/session-discovery-checkpoint-2026-07-14.md`) approved proposals P1–P7 whose canonical realization awaits owner sign-off; the 2026-07-15 Repository Recovery (`reports/history/repository-recovery-completion-2026-07-15.md`, COMPLETE) reconciled the repository (governance v1.6, Living-Documents-first, permanent CI consistency guard) with no business/architecture change. **Open owner decisions before implementation resumes:** next-phase sequencing (Reporting/RC-4 vs Offline-Conversion/Phase 8); S-EVENT/N1 event-type integrity; C4/C5 (activation-code idea, subscription grace/read-only); A3 (whether the implemented money-storage standard needs a formal ADR); live-DB V-series re-verification.

Last Completed: SPEC-119 — R5 attribution capture: added `gbraid`/`wbraid` + Google consent signals (`consent_ad_user_data`/`consent_ad_personalization`, CHECK granted/denied/unspecified) to `attribution_clicks`, and a first-touch `leads.attribution_click_id` anchor (FK `on delete restrict`, indexed) — migration `202607048700`, canon `21`/`31` updated. Closes the Phase-8 capture-side prerequisite. Prior: SPEC-118 DC-1 money precision (numeric(19,4), RK-01); SPEC-117 RLS InitPlan (A1); SPEC-114 tenant_id indexes (A2).

Next capability: **BLOCKED ON OWNER DECISION** — do not autonomously `Start Phase 8`. The next engineering move is an owner sequencing decision: Reporting/RC-4 first vs Offline-Conversion/Phase 8 first (recommendation + rationale in `repository-recovery-completion-2026-07-15.md` §5), plus the pending items above. If Phase 8 is chosen, its Design Review reads `21_offline_conversion_engine.md` + `18_integration_priority.md` + the marketing/offline-conversion tables (migration `202607043000`), and Google Ads offline-conversion API + consent is research-warranted (Learn-Before-Designing).

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
