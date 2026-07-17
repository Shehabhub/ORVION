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

Current Phase: **Phase 9 (Reports & Dashboards / RC-4) — IN PROGRESS.** Owner-sequenced ahead of Phase 8 Offline Conversion (2026-07-16 decision; execution order 7→9→8→10 in `32`). Phases 2–7 COMPLETE. Supabase-native backend (ADR-0014).

Current Module: RC-4 read-model foundation — **first slice IMPLEMENTED** (migration `048900`: `reporting` schema + 7 Tier A `security_invoker` views for the six outputs, per-currency per ADR-0022). Verified: `db reset` clean, smoke `ALL CHECKS PASSED`, all 7 views resolve, each confirmed `security_invoker` (RLS inherited). Isolated owner business-policy decisions (non-blocking, defaults applied): **presentation currency** (per-currency default) and the exact **"sales activity" measure** (reporting philosophy — defaulted to bookings-created).

Active Change Request: None (no SPEC drafted yet — Design Review precedes the first Phase-9 SPEC).

Context & remaining owner decisions (detail in the linked reports — not restated): sequencing is now DECIDED (RC-4/Reports before Phase 8, 2026-07-16). Background: the 2026-07-14 review approved P1–P7 (`reports/history/session-discovery-checkpoint-2026-07-14.md`, canonical realization awaits sign-off); the 2026-07-15 Repository Recovery (`reports/history/repository-recovery-completion-2026-07-15.md`, COMPLETE) reconciled the repo (governance v1.6, permanent consistency guard). **Still-open owner decisions (do not block Phase 9 start):** S-EVENT/N1 event-type integrity; C4/C5 (activation-code, subscription grace); A3 (money-storage ADR); live-DB V-series re-verification.

Last Completed: Phase 9 read-model first slice — migration `202607048900`: `reporting` schema + 7 Tier A `security_invoker` views (`booking_item_profit`, `customer_outstanding`, `supplier_outstanding`, `lead_performance`, `booking_pipeline`, `sales_activity`, `subscription_state`) over the four read primitives + transactional tables; RLS inherited via `security_invoker`; per-currency (ADR-0022). Verified: `db reset` clean, smoke `ALL CHECKS PASSED`, all 7 views resolve, guard CLEAN.

Next capability: **Phase 9 Tier B (ADR-0022) — only where measured cost warrants.** Add tenant-scoped aggregate tables + `pg_cron` `SECURITY DEFINER` refresh + `reporting.refresh_runs`/`refresh_schedule` for any report whose Tier A view proves too slow at volume; expose the `reporting` schema via PostgREST when the first frontend/API consumer arrives (Earn-It — no consumer yet, so deferred). With Tier A serving all six outputs, Phase 9 is functionally complete pending Tier-B-on-evidence; next phase per execution order (7→9→8→10) is **Phase 8 (Offline Conversion)**, consuming this read-model as the verified-outcome surface.

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
