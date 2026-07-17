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

Current Module: RC-4 read-model foundation — **Design COMPLETE** (ADR-0022 accepted: dedicated `reporting` schema; Tier A `security_invoker` views + Tier B RLS-bearing aggregate tables; `pg_cron` `SECURITY DEFINER` refresh; NO API-exposed matviews; external BI via non-BYPASSRLS role). Implementation-ready. Isolated owner business-policy decision: **presentation currency** (default per-currency, non-blocking; single-currency is an additive FX slice).

Active Change Request: None (no SPEC drafted yet — Design Review precedes the first Phase-9 SPEC).

Context & remaining owner decisions (detail in the linked reports — not restated): sequencing is now DECIDED (RC-4/Reports before Phase 8, 2026-07-16). Background: the 2026-07-14 review approved P1–P7 (`reports/history/session-discovery-checkpoint-2026-07-14.md`, canonical realization awaits sign-off); the 2026-07-15 Repository Recovery (`reports/history/repository-recovery-completion-2026-07-15.md`, COMPLETE) reconciled the repo (governance v1.6, permanent consistency guard). **Still-open owner decisions (do not block Phase 9 start):** S-EVENT/N1 event-type integrity; C4/C5 (activation-code, subscription grace); A3 (money-storage ADR); live-DB V-series re-verification.

Last Completed: Group 2 integrity hardening — migration `202607048800`: additive business-key UNIQUE constraints (`bookings`/`quotations` per-tenant, `subscription_plans.plan_code` global, `feature_entitlements`, `usage_counters`) + finance non-negativity CHECKs (`invoices`/`payments`/`refunds`/`payment_allocations`); canon `31` + `future-backlog.md` synced. Verified: `db reset` clean, smoke `ALL CHECKS PASSED (71 tables)`, live duplicate-key rejection. Closed 3 stale/disproven backlog items (Group 1 already-built; `lead_created` deliberate; `account_type` plain-text per ADR-0006).

Next capability: **Phase 9 — implement the read-model first slice per ADR-0022.** Create the `reporting` schema + Tier A `security_invoker` views over the four read primitives (`customer_balance`/`supplier_balance`/`booking_item_profit`/`lead_booking_readiness`) + transactional tables for the six outputs (lead performance, sales activity, booking pipeline, outstanding balances, profit by item, subscription state); add Tier B aggregate tables + `pg_cron` refresh + `reporting.refresh_runs`/`refresh_schedule` only where a report's measured cost earns it. Presentation currency defaults to per-currency (owner may later elect single-currency — additive FX `convert_amount` over `exchange_rates`).

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
