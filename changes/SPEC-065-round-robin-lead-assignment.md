# Change Request — SPEC-065

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word anywhere in a Change Request.

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model
[ ] Tier 2 — Local execution agent (Qwen3.8B)

---

## Objective

Phase 4 (CRM Core) — round-robin lead assignment: introduce the event-emission seam (`app.record_event`) and `app.assign_lead(...)` / `app.assign_lead_round_robin(...)`, performing the `new → assigned` transition with `lead_assignments` history and a `lead_assigned` event.

---

## Business Reason

`04_lead_lifecycle.md`: new leads must be routed by deterministic, auditable, branch/department-aware round-robin, and `26_state_machines.md` mandates that the `new → assigned` transition record a `lead_assigned` event with actor/previous/new state. This is the first lead state transition, so it earns the cross-cutting event-emission helper every future transition will reuse.

---

## Risks

Low–moderate. Three functions. `record_event` writes to the append-only `events` table (RLS/immutability already enforce it). Assignment is guarded by `ASSIGN_LEAD` (via `authorize`, so MFA composes) and tenant-scoped. Round-robin selection is a read-only pick; determinism is derived from `lead_assignments` (no new state/schema). No table/schema change.

---

## Supersedes / Depends On

Depends On: `SPEC-064` (create_lead), `SPEC-060` (branch/dept + user_branch_assignments), `SPEC-062` (authorize). Precedes SLA escalation / reassignment (which reuse `record_event` and the assignment history).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607044400_round_robin_lead_assignment.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; reports/** ; supabase/config.toml ; any existing migration ; table structure ; RBAC seed data ; SLA timers/reassignment ; customer identity matching ; security_events

---

## Minimum Reading List

- _ORVION_CANONICAL/04_lead_lifecycle.md (routing principle) ; 26_state_machines.md (lead_assigned)
- supabase/migrations/202607042100_create_crm_core_tables.sql (leads, lead_assignments)
- supabase/migrations/202607042600_create_event_and_notification_tables.sql (events columns)

---

## Implementation Steps

1. Create `supabase/migrations/202607044400_round_robin_lead_assignment.sql`:
   (a) `app.record_event(p_tenant_id, p_event_type_code, p_entity_type, p_entity_id, p_actor_user_id default null, p_previous_state default null, p_new_state default null, p_reason default null, p_payload default null, p_severity_code default 'info')` — SECURITY INVOKER; inserts one `events` row; returns event id.
   (b) `app.assign_lead(p_lead_id, p_assignee_user_id, p_reason default null)` — `authorize('ASSIGN_LEAD')`; lead must be in the tenant and `new`; assignee must be active and in the tenant; set `assigned_user_id`, `lead_status_code='assigned'`, `owner_*`; insert a current `lead_assignments` row; `record_event('lead_assigned', prev 'new', new 'assigned')`; return lead id.
   (c) `app.assign_lead_round_robin(p_lead_id, p_reason default null)` — `authorize('ASSIGN_LEAD')`; lead must be `new`; select the eligible employee (active user with a current, non-ended `user_branch_assignments` matching the lead's branch AND department) that is least-recently-assigned (oldest `max(assigned_at)`, never-assigned first; tie-break by user id) and delegate to `app.assign_lead`. Grants: execute to `authenticated`.

---

## Acceptance Criteria

- [x] The migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] `assign_lead_round_robin` on a `new` lead assigns it to an eligible department member, sets status `assigned`, writes a current `lead_assignments` row, and records a `lead_assigned` event (entity `lead`, previous `new`, new `assigned`).
- [x] Two consecutive round-robin assignments to two eligible members alternate (deterministic least-recently-assigned).
- [x] Rejections: assigning a lead that is not `new`; round-robin with no eligible member; an assignee outside the tenant.
- [x] A caller lacking `ASSIGN_LEAD` (e.g. employee) is denied 42501; a high-risk owner needs `aal2`.

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `record_event`, `assign_lead`, `assign_lead_round_robin`; `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (owner@aal2; two employees Sara & Ed both in the Sales department; a third employee Ola NOT in Sales):
- Two `new` leads created. `assign_lead_round_robin(lead1)` → assigned to one Sales member; `assign_lead_round_robin(lead2)` → assigned to the **other** (alternation confirmed). Each lead: `lead_status_code='assigned'`, one `is_current` `lead_assignments` row, one `events` row (`event_type_code='lead_assigned'`, `previous_state='new'`, `new_state='assigned'`, `entity_type='lead'`).
- Ola (not in Sales) was never selected by round-robin.
- `assign_lead(assigned_lead, …)` → rejected ("lead is not in new status"); round-robin on a department with no members → "no eligible employee for round-robin"; assignee outside tenant → rejected.
- Employee (Sara) calling `assign_lead_round_robin` → 42501 (lacks `ASSIGN_LEAD`); owner@aal1 → 42501 (MFA).

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: The transition is correct and fully audited — status, `lead_assignments` history, and a canonical `lead_assigned` event (actor/previous/new/reason) are written together, satisfying `26`. Round-robin is deterministic (least-recently-assigned from `lead_assignments`, tie-broken by id) and branch/department-aware per `04`, with no added state. `record_event` is a clean reusable seam for all future transitions. `authorize('ASSIGN_LEAD')` composes the permission + MFA policy. No schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

**Eligibility policy (recorded decision, refine-able):** an eligible employee is an active user with a current (`ends_at is null`) `user_branch_assignments` row matching the lead's **branch and department**. This is the minimal branch/department-aware reading of `04`; narrowing by functional role (e.g. only `sales`) or by a lead-handling permission is a deferred refinement, surfaced here rather than baked in. **Determinism:** round-robin = least-recently-assigned (oldest `max(assigned_at)` across `lead_assignments`, never-assigned first, tie-break by user id) — deterministic and auditable from existing history, no counter/pointer state. **Eventing seam:** `record_event` is introduced here (earned by the first transition) and is the reusable helper for all future state transitions and for the deferred `28` Event Requirements (role assigned, permission change, etc.) — those are retrofitted at their own triggers. `severity_code`/`event_type_code` are plain text (no catalog constrains them); routine transitions use `'info'`. Automatic routing **at intake** (system-triggered, no ASSIGN_LEAD holder) is deferred: today a manager/owner triggers assignment; a `service_role` auto-route path is a later refinement. Reassignment (`assigned → assigned`, `lead_reassigned`) is the SLA-escalation capability (next) and intentionally not handled here — `assign_lead` requires the lead to be `new`.
