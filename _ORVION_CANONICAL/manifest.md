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

Last Completed Task: SPEC-063 — Device-trust baseline (ADR-0017; trusted_devices is an ORVION-owned Human-Identity artifact keyed to auth.users, no tenant): app.record_trusted_device(identifier) (idempotent per auth_user_id+identifier), app.my_trusted_devices(), app.revoke_trusted_device(id). SECURITY INVOKER, owner-only RLS backstop, scoped to auth.uid(), works pre-tenant. Proven E2E: idempotent register, revoke→'revoked', cross-user isolation (B sees 0 of A's, "device not found" on cross-revoke). Smoke-test passes. THIS COMPLETES the Phase-3 identity capability group. (Prior: SPEC-062 MFA enforcement+ADR-0017; SPEC-061 invitation/activation; SPEC-060 org mgmt; SPEC-059 user mgmt.)

Next Planned Task: Continue Phase 3 (Identity & Access). Provisioning, has_permission, user create/role-assign, and org management (branch/department/user-branch) now exist. The Phase-3 identity capability group is COMPLETE: Tenant Provisioning (SPEC-058), User Management (SPEC-059), Organization Management (SPEC-060), Invitation & Activation (SPEC-061), Authentication hardening (SPEC-062 MFA + SPEC-063 device-trust), Membership Resolution (my_memberships + activate_membership). The owner-suggested one-time end-to-end User Lifecycle Review is DONE — reports/phase-03-user-lifecycle-review.md: all 10 seams (Provision→Invite→Activate→Role→Branch/Dept→Login→Membership Resolution→Permission Resolution→RLS→cross-tenant isolation) PASS against a fresh db reset, no defects, verdict coherent end-to-end. NEXT: continue per roadmap. Deferred (recorded): active-tenant selection for multi-membership (ADR-0011); security-event emission (28 Event Requirements) via the eventing capability; scoped management for branch_manager/department_manager (ADR-0015); subscription lifecycle + reference-data (currencies) layers; branch_business_hours/holidays (operations phase). After that group completes, perform the single User Lifecycle Review (Provision→Invite→Activate→Assign Role→Assign Branch/Department→Login→Membership Resolution→Permission Resolution→RLS), then continue. Deferred (recorded): security_event emission (28 Event Requirements) with the eventing capability; scoped management for branch_manager/department_manager (ADR-0015); subscription lifecycle + reference-data (currencies) layers; branch_business_hours/holidays (operations phase); assignment-lifecycle (re-point primary branch); app.set_active_tenant()/multi-membership persistence (ADR-0011).

Active Change Request: None

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
