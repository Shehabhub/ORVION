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

Last Completed Task: SPEC-058 — recorded ADR-0016 (owner-approved Option A: platform-mediated tenant provisioning) and added the first two identity/access RPCs: app.provision_tenant(...) (service_role-only SECURITY DEFINER; creates tenant + owner users membership + owner tenant-scoped role assignment; status param default 'trial'; no subscription row — that lifecycle is a separate future slice) and app.has_permission(key) (the binary authorization primitive per ADR-0015, resolving the caller within app.current_tenant_id() through active user_role_assignments → role_permissions). Also granted service_role USAGE on the app schema. Proven E2E: provisioned owner resolves MANAGE_USERS/CREATE_LEAD/APPROVE_FINANCE=true, MANAGE_SUBSCRIPTION/VIEW_ADVANCED_DASHBOARDS=false, stranger=false; authenticated cannot provision. Smoke-test passes. (Prior: SPEC-057 seeded role_permissions + ADR-0015; SPEC-056 seeded roles(9)+permissions(64).)

Next Planned Task: Continue Phase 3 (Identity & Access) capability-by-capability. The bootstrap (provision_tenant) and the authorization primitive (has_permission) now exist. Candidate next slices, each its own CR: user management RPCs (create/invite user, assign role, assign branch/department) guarded by has_permission('MANAGE_USERS') + RLS scope — at which point conditional/scoped grants earn their role_permissions rows per ADR-0015; invitation/activation flow linking auth.users to a users membership; branch/department management; TOTP-required enforcement for high-risk roles (owner/ceo/finance_manager/system_administrator per 28); device-trust baseline. Deferred (recorded): security_event emission on role assignment (28 Event Requirements) — wire with the eventing capability; subscription lifecycle (subscriptions row, subscription_plans/feature_entitlements seeding) — separate slice; reference-data layer (currencies etc.) — provisioning passes null currency until then; app.set_active_tenant()/multi-membership persistence (ADR-0011).

Active Change Request: None

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
