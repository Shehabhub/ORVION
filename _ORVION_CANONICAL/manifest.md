# ORVION Project Manifest

Version: 2.0
Status: Canonical
Purpose: Repository State
Loaded After: AGENTS.md

---

# Purpose

This document tells any agent or human where the project currently stands.

It exists to answer one question: what phase, task, and Change Request is active right now.

For where to begin, what to read, and who governs conduct, see `README.md` and `AGENTS.md` — this document does not restate their responsibilities.

This file should always reflect the current state of the project.

---

# Current Development Status

Update this section continuously.

Current Phase: Phase 3 — Identity And Access (application layer)

Current Sprint: Supabase-native backend (ADR-0014)

Current Module: Identity And Access

Current Task: Phase 2 (Database Foundation) is COMPLETE — migrations 1-20 (SPEC-022 through SPEC-053): 71 tables, 65 catalog types / 395 catalog values, 76 RLS policies, append-only audit, and an executable verification smoke-test (scripts/verify_database.sql). The Database Naming Audit ran (schema found consistent; only status-column naming deferred to backend-phase start — logged in future-backlog). The backend architecture is decided (ADR-0014, SPEC-054): Supabase-native-first — PostgREST + RLS + PostgreSQL RPC backbone, Edge Functions + pg_cron/pg_net + n8n for out-of-DB compute, SSR web + shared Supabase surface for all clients, no standalone backend service unless a capability earns it. Now executing Phase 3 (Identity And Access) capability-by-capability under the CR lifecycle on that architecture. The deferred Architecture Knowledge Layer evaluation remains owner-scheduled for the stable post-database state (do not run yet). Deferred backlog items remain in reports/future-backlog.md (business-key uniqueness; finance non-negative CHECKs; status-column naming; authenticated DML grants — now being addressed as the Phase 3 first slice; subscription-state gating).

Last Completed Task: SPEC-057 — recorded ADR-0015 (owner-approved Option A: the permission matrix realizes onto the binary role_permissions table unchanged; scope/conditional/plan enforced at point-of-use via RLS+RPC+subscription logic; current operational model with an evidence-based escalation trigger) and seeded role_permissions with the strict-"Yes" grants transcribed from 28_permissions_matrix.md — 239 grants across 59 permissions (5 plan/platform-gated permissions correctly have no role row; system_administrator and trainee have zero strict-Yes rows). Idempotent; smoke-test passes. (Prior: SPEC-056 seeded roles(9)+permissions(64); SPEC-055 granted authenticated DML + app.my_memberships() RPC.)

Next Planned Task: Continue Phase 3 (Identity & Access) capability-by-capability on the Supabase-native architecture — the RBAC vocabulary and grants now exist (roles/permissions/role_permissions seeded; ADR-0015). Candidate next slices: an app.has_permission(permission_key) enforcement function reading role_permissions (built when the first RPC needs it — at which point conditional/scoped grants earn their rows per ADR-0015); tenant/user/role/branch/department management RPCs; invitation/activation flow; TOTP-required enforcement for high-risk roles (owner/ceo/finance_manager/system_administrator per 28); device-trust baseline. Each its own CR. app.set_active_tenant() and multi-membership active-tenant persistence remain deferred (MVP degrades to single membership; ADR-0011).

Active Change Request: None

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
