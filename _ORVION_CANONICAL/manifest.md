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

Last Completed Task: SPEC-066 — Phase 4 (CRM Core) lead interaction recording: app.record_lead_interaction(lead, interaction_type, summary, metadata) logs an interaction and, on a qualifying contact (phone_call/whatsapp_message/chat_opened/customer_reply) on an 'assigned' lead, performs assigned→contacted with a lead_contacted event + sets last_contact_at. Reuses record_event. Guard: caller is the assigned handler OR holds ASSIGN_LEAD, plus mfa_satisfied. Proven E2E: phone_call→contacted (1 event), note logs without re-transition, non-assignee denied 42501, catalog-validated. Smoke-test passes. (Prior: SPEC-065 round-robin assignment + event seam.)

Earlier Completed: SPEC-065 — Phase 4 (CRM Core) round-robin lead assignment + the reusable event-emission seam. Added app.record_event(...) (writes append-only events rows — earned by the first lead transition, reused by all future transitions and the deferred 28 Event Requirements), app.assign_lead(lead,assignee) (new→assigned transition + lead_assignments history + lead_assigned event), and app.assign_lead_round_robin(lead) (picks the eligible least-recently-assigned department member; eligibility = active user with a current branch+department assignment to the lead's branch/dept). ASSIGN_LEAD-guarded via authorize (MFA composes). Proven E2E: 2 leads alternate across 2 Sales members, wrong-dept user never picked, 2 lead_assigned events (prev new/new assigned), rejections (not-new, empty dept, employee denied). Smoke-test passes. (Prior: SPEC-064 lead intake; Phase 3 complete SPEC-058..063.)

Next Planned Task: Continue Phase 3 (Identity & Access). Provisioning, has_permission, user create/role-assign, and org management (branch/department/user-branch) now exist. The Phase-3 identity capability group is COMPLETE: Tenant Provisioning (SPEC-058), User Management (SPEC-059), Organization Management (SPEC-060), Invitation & Activation (SPEC-061), Authentication hardening (SPEC-062 MFA + SPEC-063 device-trust), Membership Resolution (my_memberships + activate_membership). The owner-suggested one-time end-to-end User Lifecycle Review is DONE — reports/phase-03-user-lifecycle-review.md: all 10 seams (Provision→Invite→Activate→Role→Branch/Dept→Login→Membership Resolution→Permission Resolution→RLS→cross-tenant isolation) PASS against a fresh db reset, no defects, verdict coherent end-to-end. Phase 4 (CRM Core) active; lead intake (SPEC-064) + round-robin assignment & event-emission seam (SPEC-065) done. NEXT candidates: lead-contact/interaction recording (assigned→contacted transition via record_event; lead_interactions), SLA escalation (15-min not-responded rule → lead_sla_warning event, then reassignment assigned→assigned → lead_reassigned; needs a scheduler — pg_cron/Edge Function per ADR-0014), customer identity matching (05), lead closure (→won/lost/converted + closure_reason), lead→customer link, lead→booking prep. The record_event helper is the reusable seam for all these transitions. Deferred (recorded): auto-route at intake via service_role; eligibility narrowing by functional role; retrofit lead_created event; 28 Event Requirements retrofit at their triggers; active-tenant selection (ADR-0011); scoped management (ADR-0015); subscription lifecycle + reference-data layers; branch_business_hours/holidays. After that group completes, perform the single User Lifecycle Review (Provision→Invite→Activate→Assign Role→Assign Branch/Department→Login→Membership Resolution→Permission Resolution→RLS), then continue. Deferred (recorded): security_event emission (28 Event Requirements) with the eventing capability; scoped management for branch_manager/department_manager (ADR-0015); subscription lifecycle + reference-data (currencies) layers; branch_business_hours/holidays (operations phase); assignment-lifecycle (re-point primary branch); app.set_active_tenant()/multi-membership persistence (ADR-0011).

Active Change Request: None

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
