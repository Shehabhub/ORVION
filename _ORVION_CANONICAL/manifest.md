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

Last Completed Task: SPEC-068 — Phase 4 (CRM Core) lead pipeline progression + closure. app.advance_lead(p_lead_id, p_to_status, p_reason, p_closure_reason_code) SECURITY INVOKER: validates the requested transition against the canonical Lead State Machine (26) encoded as a table, authorizes it (progression = assigned handler OR ASSIGN_LEAD + MFA; closure = CLOSE_LEAD via authorize), applies it, and emits the mapped per-transition event via record_event. Covers contacted→qualified→quotation_sent→negotiation→won (+ qualified/quotation_sent→won) and closures →lost/→spam/→duplicate (validated lead_closure_reason, closed_at). won→converted (needs customer link) and terminal reopening deferred. Proven E2E: full forward pipeline (4 correct events), illegal jumps rejected (won→converted, contacted→won), closure sets reason/closed_at + lead_lost event, bad/missing closure reason rejected, progression + closure denied to a non-authorized employee (42501). Smoke-test passes. (Prior: SPEC-067 SLA escalation + ADR-0018; SPEC-066 interaction recording.)

Earlier Completed: SPEC-066 — Phase 4 (CRM Core) lead interaction recording: app.record_lead_interaction(lead, interaction_type, summary, metadata) logs an interaction and, on a qualifying contact (phone_call/whatsapp_message/chat_opened/customer_reply) on an 'assigned' lead, performs assigned→contacted with a lead_contacted event + sets last_contact_at. Reuses record_event. Guard: caller is the assigned handler OR holds ASSIGN_LEAD, plus mfa_satisfied. Proven E2E: phone_call→contacted (1 event), note logs without re-transition, non-assignee denied 42501, catalog-validated. Smoke-test passes. (Prior: SPEC-065 round-robin assignment + event seam.)

Earlier Completed: SPEC-065 — Phase 4 (CRM Core) round-robin lead assignment + the reusable event-emission seam. Added app.record_event(...) (writes append-only events rows — earned by the first lead transition, reused by all future transitions and the deferred 28 Event Requirements), app.assign_lead(lead,assignee) (new→assigned transition + lead_assignments history + lead_assigned event), and app.assign_lead_round_robin(lead) (picks the eligible least-recently-assigned department member; eligibility = active user with a current branch+department assignment to the lead's branch/dept). ASSIGN_LEAD-guarded via authorize (MFA composes). Proven E2E: 2 leads alternate across 2 Sales members, wrong-dept user never picked, 2 lead_assigned events (prev new/new assigned), rejections (not-new, empty dept, employee denied). Smoke-test passes. (Prior: SPEC-064 lead intake; Phase 3 complete SPEC-058..063.)

Next Planned Task: Continue Phase 3 (Identity & Access). Provisioning, has_permission, user create/role-assign, and org management (branch/department/user-branch) now exist. The Phase-3 identity capability group is COMPLETE: Tenant Provisioning (SPEC-058), User Management (SPEC-059), Organization Management (SPEC-060), Invitation & Activation (SPEC-061), Authentication hardening (SPEC-062 MFA + SPEC-063 device-trust), Membership Resolution (my_memberships + activate_membership). The owner-suggested one-time end-to-end User Lifecycle Review is DONE — reports/phase-03-user-lifecycle-review.md: all 10 seams (Provision→Invite→Activate→Role→Branch/Dept→Login→Membership Resolution→Permission Resolution→RLS→cross-tenant isolation) PASS against a fresh db reset, no defects, verdict coherent end-to-end. Phase 4 (CRM Core) active. Done: lead intake (SPEC-064), round-robin assignment + event seam (SPEC-065), interaction recording assigned→contacted (SPEC-066), SLA escalation + background-processing model ADR-0018 (SPEC-067), pipeline progression + closure advance_lead (SPEC-068). NEXT candidates: customer identity matching (05 — dedup/merge signals; CREATE_CUSTOMER + MERGE_CUSTOMER_IDENTITY, sensitive merge must emit event), then lead→customer link + won→converted (12 Lead-To-Customer rule), lead→booking prep, terminal-state reopening (lost/spam/duplicate→assigned). Deferred (recorded): manual reassignment RPC (REASSIGN_LEAD); external notification delivery (Edge/n8n); auto-route at intake via service_role; eligibility narrowing by functional role; retrofit lead_created event; 28 Event Requirements retrofit at their triggers; active-tenant selection (ADR-0011); scoped management (ADR-0015); subscription lifecycle + reference-data layers; branch_business_hours/holidays. After that group completes, perform the single User Lifecycle Review (Provision→Invite→Activate→Assign Role→Assign Branch/Department→Login→Membership Resolution→Permission Resolution→RLS), then continue. Deferred (recorded): security_event emission (28 Event Requirements) with the eventing capability; scoped management for branch_manager/department_manager (ADR-0015); subscription lifecycle + reference-data (currencies) layers; branch_business_hours/holidays (operations phase); assignment-lifecycle (re-point primary branch); app.set_active_tenant()/multi-membership persistence (ADR-0011).

Active Change Request: None

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
