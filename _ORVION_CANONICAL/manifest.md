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

Last Completed Task: SPEC-071 — Phase 4 (CRM Core) lead→customer conversion (12 Lead-To-Customer rule; 26 won→converted). app.convert_lead(p_lead_id, p_customer_id, p_reason) SECURITY INVOKER: requires the lead be 'won', resolves the target customer as coalesce(p_customer_id, leads.customer_id) (one required, in-tenant), guards via assigned-handler-OR-ASSIGN_LEAD + MFA, then links the customer + terminal won→converted transition (closure_reason_code='converted_customer', closed_at), preserving the lead (never deleted), and emits lead_converted (payload {customer_id}). Single responsibility — customer must pre-exist (create_customer or intake link); no CREATE_CUSTOMER gate here. Completes the lead state machine normal flow. Proven E2E: convert won+linked (no arg), unlinked won rejected then explicit-arg link works, non-won rejected, non-handler denial (42501). Smoke-test passes. (Prior: SPEC-070 customer merge + ADR-0019; SPEC-069 create_customer.)

Earlier Completed: SPEC-070 — Phase 4 (CRM Core) sensitive customer merge (ADR-0019). app.merge_customer_identity(source, target, reason) SECURITY DEFINER: authorize('MERGE_CUSTOMER_IDENTITY') + MFA + same-tenant verification, then re-points EVERY reference to customers(id) from source→target via DYNAMIC FK discovery from pg_constraint (participation-by-default; excludes only the customer_identity_merges audit table), writes the merge audit row (source/target/merged_by/reason/time), emits the mandated customer_merged event, and soft-archives the source (never deletes). ADR-0019 rule: every new table referencing customers auto-participates in merge unless explicitly excluded with a documented reason. Proven E2E: lead+contact+signal all re-pointed (0 still on source), audit row keeps source, event emitted, source archived not deleted; guards (source=target, re-merge archived) + denials (no MERGE 42501, owner aal1 no MFA 42501). Smoke-test passes. (Prior: SPEC-069 create_customer + find_customer_duplicates; SPEC-068 advance_lead.)

Earlier Completed: SPEC-069 — Phase 4 (CRM Core) customer creation + duplicate detection (05_customer_identity). app.create_customer(...) SECURITY INVOKER CREATE_CUSTOMER-gated: validates customer_type/contact_method_type catalogs + branch-in-tenant, enforces in-tenant primary-phone uniqueness unless p_allow_duplicate override (05's approved exception), inserts the customer, seeds customer_identity_signals from phone/whatsapp/email. app.find_customer_duplicates(...) read-only candidate search across identity signals + profile phone/email (never name). Sensitive merge (MERGE_CUSTOMER_IDENTITY, must emit event + re-point references) deferred to its own CR. Proven E2E: create + 3 signals; duplicate phone rejected then override succeeds; detection by phone(2)/whatsapp(1)/email(1)/unrelated(0); unknown type + trainee denial (42501). Smoke-test passes. (Prior: SPEC-068 pipeline progression/closure advance_lead; SPEC-067 SLA + ADR-0018.)

Earlier Completed: SPEC-068 — Phase 4 (CRM Core) lead pipeline progression + closure. app.advance_lead(p_lead_id, p_to_status, p_reason, p_closure_reason_code) SECURITY INVOKER: validates the requested transition against the canonical Lead State Machine (26) encoded as a table, authorizes it (progression = assigned handler OR ASSIGN_LEAD + MFA; closure = CLOSE_LEAD via authorize), applies it, and emits the mapped per-transition event via record_event. Covers contacted→qualified→quotation_sent→negotiation→won (+ qualified/quotation_sent→won) and closures →lost/→spam/→duplicate (validated lead_closure_reason, closed_at). won→converted (needs customer link) and terminal reopening deferred. Proven E2E: full forward pipeline (4 correct events), illegal jumps rejected (won→converted, contacted→won), closure sets reason/closed_at + lead_lost event, bad/missing closure reason rejected, progression + closure denied to a non-authorized employee (42501). Smoke-test passes. (Prior: SPEC-067 SLA escalation + ADR-0018; SPEC-066 interaction recording.)

Earlier Completed: SPEC-066 — Phase 4 (CRM Core) lead interaction recording: app.record_lead_interaction(lead, interaction_type, summary, metadata) logs an interaction and, on a qualifying contact (phone_call/whatsapp_message/chat_opened/customer_reply) on an 'assigned' lead, performs assigned→contacted with a lead_contacted event + sets last_contact_at. Reuses record_event. Guard: caller is the assigned handler OR holds ASSIGN_LEAD, plus mfa_satisfied. Proven E2E: phone_call→contacted (1 event), note logs without re-transition, non-assignee denied 42501, catalog-validated. Smoke-test passes. (Prior: SPEC-065 round-robin assignment + event seam.)

Earlier Completed: SPEC-065 — Phase 4 (CRM Core) round-robin lead assignment + the reusable event-emission seam. Added app.record_event(...) (writes append-only events rows — earned by the first lead transition, reused by all future transitions and the deferred 28 Event Requirements), app.assign_lead(lead,assignee) (new→assigned transition + lead_assignments history + lead_assigned event), and app.assign_lead_round_robin(lead) (picks the eligible least-recently-assigned department member; eligibility = active user with a current branch+department assignment to the lead's branch/dept). ASSIGN_LEAD-guarded via authorize (MFA composes). Proven E2E: 2 leads alternate across 2 Sales members, wrong-dept user never picked, 2 lead_assigned events (prev new/new assigned), rejections (not-new, empty dept, employee denied). Smoke-test passes. (Prior: SPEC-064 lead intake; Phase 3 complete SPEC-058..063.)

Next Planned Task: Continue Phase 3 (Identity & Access). Provisioning, has_permission, user create/role-assign, and org management (branch/department/user-branch) now exist. The Phase-3 identity capability group is COMPLETE: Tenant Provisioning (SPEC-058), User Management (SPEC-059), Organization Management (SPEC-060), Invitation & Activation (SPEC-061), Authentication hardening (SPEC-062 MFA + SPEC-063 device-trust), Membership Resolution (my_memberships + activate_membership). The owner-suggested one-time end-to-end User Lifecycle Review is DONE — reports/phase-03-user-lifecycle-review.md: all 10 seams (Provision→Invite→Activate→Role→Branch/Dept→Login→Membership Resolution→Permission Resolution→RLS→cross-tenant isolation) PASS against a fresh db reset, no defects, verdict coherent end-to-end. Phase 4 (CRM Core) active. Done: lead intake (SPEC-064), round-robin assignment + event seam (SPEC-065), interaction recording assigned→contacted (SPEC-066), SLA escalation + background-processing model ADR-0018 (SPEC-067), pipeline progression + closure advance_lead (SPEC-068), customer creation + duplicate detection (SPEC-069), sensitive customer merge ADR-0019 (SPEC-070), lead→customer conversion won→converted (SPEC-071). The lead state machine normal flow (new→assigned→contacted→qualified→quotation_sent→negotiation→won→converted) + closures are now COMPLETE. NEXT candidates: booking creation from a converted lead/customer (13 booking_statuses_and_rules + 06 booking model — booking_created in 'draft', anchored to customer, references lead; CREATE_BOOKING), then booking state machine transitions, terminal-state reopening (lost/spam/duplicate→assigned, lead_reopened). Deferred (recorded): merge value-level conflict resolution (ADR-0019 escalation); manual REASSIGN_LEAD; external notification delivery (Edge/n8n); 28 Event Requirements retrofit at their triggers. Deferred (recorded): manual reassignment RPC (REASSIGN_LEAD); external notification delivery (Edge/n8n); auto-route at intake via service_role; eligibility narrowing by functional role; retrofit lead_created event; 28 Event Requirements retrofit at their triggers; active-tenant selection (ADR-0011); scoped management (ADR-0015); subscription lifecycle + reference-data layers; branch_business_hours/holidays. After that group completes, perform the single User Lifecycle Review (Provision→Invite→Activate→Assign Role→Assign Branch/Department→Login→Membership Resolution→Permission Resolution→RLS), then continue. Deferred (recorded): security_event emission (28 Event Requirements) with the eventing capability; scoped management for branch_manager/department_manager (ADR-0015); subscription lifecycle + reference-data (currencies) layers; branch_business_hours/holidays (operations phase); assignment-lifecycle (re-point primary branch); app.set_active_tenant()/multi-membership persistence (ADR-0011).

Active Change Request: None

---

# Governance and Ownership

This document owns only the state above. Every other responsibility belongs elsewhere, by design, and is not restated here:

- Project identity, vision, and platform boundaries — `PROJECT_CONTEXT.md`.
- Engineering principles, execution rules, and workflow — `AGENTS.md` and `PROTOCOL.md`.
- Document discovery and reading order — `README.md`'s First Reading Order.
- Phase and module progress — `_ORVION_CANONICAL/32_execution_roadmap.md`, the single source of truth for that state.

End of Document.
