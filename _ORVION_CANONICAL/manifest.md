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

Last Completed: SPEC-117 — wrapped `app.current_tenant_id()` in a scalar subquery across all 63 RLS policies (migration `202607048500`, ARB finding A1) so it evaluates once per query (InitPlan) not per row, plus a pgTAP invariant guarding the pattern. Semantics unchanged. Prior: SPEC-116 fixed smoke-test CI gating; SPEC-115 pinned function search_path; SPEC-114 added 18 tenant_id indexes (A2); SPEC-113 stood up the pgTAP harness (DC-16); SPEC-112 closed Phase 7.

Next capability: `Start Phase 8` (Offline Conversion — Google Ads offline-conversion feedback: click capture `gclid`/`gbraid`/`wbraid` + consent, lead attribution, CRM outcome mapping, internal conversion event, delivery + retry). Phase-8 Design Review: read `21_offline_conversion_engine.md` + `18_integration_priority.md` + the marketing/offline-conversion tables (migration `202607043000`); verify attribution capture at lead intake (deferred check noted in the roadmap) as an early step. Research-warranted area (Google Ads offline conversions API + consent) per Learn-Before-Designing.

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
