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

Last Completed Task: SPEC-062 — Authentication hardening (ADR-0017, Supabase-native auth): auth artifacts (MFA/OTP/sessions/aal) belong to Supabase Auth; ORVION owns the policy. Added app.requires_mfa() (caller's active membership holds a high-risk role: owner/ceo/finance_manager/system_administrator per 28), app.mfa_satisfied() ((not required) OR JWT aal='aal2'), and app.authorize(permission_key) (has_permission AND mfa_satisfied); re-defined the 5 management RPCs to guard via authorize(). Proven E2E: owner@aal2 manages, owner@aal1/no-aal blocked (42501 MFA), employee not high-risk (not MFA-blocked). has_permission unchanged. Smoke-test passes. (Prior: SPEC-061 invitation/activation; SPEC-060 org management; SPEC-059 user mgmt.)

Next Planned Task: Continue Phase 3 (Identity & Access). Provisioning, has_permission, user create/role-assign, and org management (branch/department/user-branch) now exist. Remaining identity capability group before the owner-suggested one-time end-to-end User Lifecycle Review (see memory user-lifecycle-review-milestone): Invitation & Activation (DONE, SPEC-061), Authentication hardening — MFA-requirement enforcement (DONE, SPEC-062); device-trust baseline (ORVION-owned trusted_devices per ADR-0017) remains as a small next slice, and Membership Resolution (app.my_memberships + app.activate_membership exist; confirm/extend for active-tenant). After device-trust, perform the single User Lifecycle Review, then continue. After that group completes, perform the single User Lifecycle Review (Provision→Invite→Activate→Assign Role→Assign Branch/Department→Login→Membership Resolution→Permission Resolution→RLS), then continue. Deferred (recorded): security_event emission (28 Event Requirements) with the eventing capability; scoped management for branch_manager/department_manager (ADR-0015); subscription lifecycle + reference-data (currencies) layers; branch_business_hours/holidays (operations phase); assignment-lifecycle (re-point primary branch); app.set_active_tenant()/multi-membership persistence (ADR-0011).

Active Change Request: None

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
