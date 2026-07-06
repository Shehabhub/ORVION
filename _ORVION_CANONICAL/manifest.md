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

Current Phase: Phase 4 — CRM Core (application layer)

Current Sprint: Supabase-native backend (ADR-0014)

Current Module: Identity And Access

Current Task: Phase 2 (Database Foundation) is COMPLETE — migrations 1-20 (SPEC-022 through SPEC-053): 71 tables, 65 catalog types / 395 catalog values, 76 RLS policies, append-only audit, and an executable verification smoke-test (scripts/verify_database.sql). The Database Naming Audit ran (schema found consistent; only status-column naming deferred to backend-phase start — logged in future-backlog). The backend architecture is decided (ADR-0014, SPEC-054): Supabase-native-first — PostgREST + RLS + PostgreSQL RPC backbone, Edge Functions + pg_cron/pg_net + n8n for out-of-DB compute, SSR web + shared Supabase surface for all clients, no standalone backend service unless a capability earns it. Now executing Phase 3 (Identity And Access) capability-by-capability under the CR lifecycle on that architecture. The deferred Architecture Knowledge Layer evaluation remains owner-scheduled for the stable post-database state (do not run yet). Deferred backlog items remain in reports/future-backlog.md (business-key uniqueness; finance non-negative CHECKs; status-column naming; authenticated DML grants — now being addressed as the Phase 3 first slice; subscription-state gating).

Last Completed Task: SPEC-064 — Phase 4 (CRM Core) first capability, Lead intake: app.create_lead(...) creates a lead in the initial 'new' status within the caller's tenant, guarded by app.authorize('CREATE_LEAD') (MFA policy composes for high-risk roles), validating branch/department coherence + lead_source/service_type/priority catalog codes + customer-in-tenant. SECURITY INVOKER, RLS backstop. Proven E2E: employee creates 'new' lead (created_by set); owner aal1 MFA-blocked / aal2 ok; bad source/priority/dept rejected; trainee denied CREATE_LEAD. Smoke-test passes. Phase 3 (Identity & Access) is COMPLETE (SPEC-058..063 + lifecycle review). (Prior: SPEC-063 device-trust; SPEC-062 MFA+ADR-0017.)

Next Planned Task: Continue Phase 3 (Identity & Access). Provisioning, has_permission, user create/role-assign, and org management (branch/department/user-branch) now exist. The Phase-3 identity capability group is COMPLETE: Tenant Provisioning (SPEC-058), User Management (SPEC-059), Organization Management (SPEC-060), Invitation & Activation (SPEC-061), Authentication hardening (SPEC-062 MFA + SPEC-063 device-trust), Membership Resolution (my_memberships + activate_membership). The owner-suggested one-time end-to-end User Lifecycle Review is DONE — reports/phase-03-user-lifecycle-review.md: all 10 seams (Provision→Invite→Activate→Role→Branch/Dept→Login→Membership Resolution→Permission Resolution→RLS→cross-tenant isolation) PASS against a fresh db reset, no defects, verdict coherent end-to-end. Phase 4 (CRM Core) is now active; lead intake (SPEC-064) done. NEXT: round-robin lead assignment (new → assigned transition, deterministic/auditable/branch-department-aware per 04) — this is the first lead state transition, so per 26_state_machines it must record a lead_assigned event, making it the natural point to earn the cross-cutting security-event emission seam (and retrofit a lead_created event onto create_lead). Then: SLA escalation (15-min rule, 04), customer identity matching (05), lead closure, lead→customer link, lead→booking prep. Deferred (recorded): active-tenant selection (ADR-0011); scoped management for branch/department managers (ADR-0015); subscription lifecycle + reference-data (currencies) layers; branch_business_hours/holidays (operations phase). After that group completes, perform the single User Lifecycle Review (Provision→Invite→Activate→Assign Role→Assign Branch/Department→Login→Membership Resolution→Permission Resolution→RLS), then continue. Deferred (recorded): security_event emission (28 Event Requirements) with the eventing capability; scoped management for branch_manager/department_manager (ADR-0015); subscription lifecycle + reference-data (currencies) layers; branch_business_hours/holidays (operations phase); assignment-lifecycle (re-point primary branch); app.set_active_tenant()/multi-membership persistence (ADR-0011).

Active Change Request: None

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
