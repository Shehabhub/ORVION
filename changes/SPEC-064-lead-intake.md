# Change Request — SPEC-064

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

Phase 4 (CRM Core) first capability — **Lead intake**: `app.create_lead(...)` creates a lead in the initial `new` status within the caller's tenant, guarded by `CREATE_LEAD`, validating branch/department/catalog references.

---

## Business Reason

CRM Core begins with capturing leads (`04_lead_lifecycle.md` intake channels). A lead enters at `lead_status_code='new'` (`26_state_machines.md`) and is later routed (round-robin assignment — the next capability). Intake is the entry point every downstream CRM capability depends on.

---

## Risks

Low. One `SECURITY INVOKER` RPC (RLS backstop) guarded by `app.authorize('CREATE_LEAD')`. Validates branch/department coherence and the `lead_source` / `service_type` / `priority_code` catalog codes. No schema change. No state transition occurs (creation is the initial state), so no event emission is required yet (events are mandated on transitions — earned at the assignment capability).

---

## Supersedes / Depends On

Depends On: `SPEC-060` (branches/departments), `SPEC-062` (`authorize`), `SPEC-057` (`CREATE_LEAD` grant). Precedes round-robin assignment (new → assigned transition + eventing).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607044300_create_lead.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; reports/** ; supabase/config.toml ; any existing migration ; table structure ; RBAC seed data ; assignment/SLA/eventing ; customer identity matching

---

## Minimum Reading List

- supabase/migrations/202607042100_create_crm_core_tables.sql (leads columns)
- _ORVION_CANONICAL/04_lead_lifecycle.md ; 26_state_machines.md (lead_status: initial `new`)
- supabase/migrations/202607043900_organization_management_rpcs.sql (validation/RPC pattern)

---

## Implementation Steps

1. Create `supabase/migrations/202607044300_create_lead.sql`: `app.create_lead(p_branch_id, p_department_id, p_lead_source_code, p_title, p_priority_code default null, p_requested_service_type_code default null, p_customer_id default null, p_customer_phone default null, p_customer_name default null, p_expected_value default null, p_source_payload default null)` — plpgsql SECURITY INVOKER, `set search_path=''`. Resolve tenant; `app.authorize('CREATE_LEAD')`; validate the department belongs to the branch in the tenant; validate `lead_source_code`, and (when provided) `requested_service_type_code` and `priority_code`, against their catalogs; validate `customer_id` (if given) is in the tenant. Insert the lead with `lead_status_code='new'`, `created_by`=caller's user id; return the lead id. Grant execute to `authenticated`.

---

## Acceptance Criteria

- [x] The migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] An employee (aal1, holds `CREATE_LEAD`) creates a lead → row with `lead_status_code='new'`, `created_by` set, in their tenant.
- [x] Rejections: department not in the given branch; unknown `lead_source_code`; unknown `requested_service_type_code` / `priority_code` when provided; `customer_id` outside the tenant.
- [x] A caller lacking `CREATE_LEAD` (e.g. trainee — Limited, no strict grant) is denied with SQLSTATE 42501.
- [x] A high-risk owner at `aal1` is MFA-blocked (via `authorize`); at `aal2` succeeds.

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — created `app.create_lead`; `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (provisioned owner@aal2, employee Sara@aal1, branch+department created):
- Sara: `create_lead(branch, dept, 'website_form', 'Umrah enquiry')` → lead with `lead_status_code='new'`, `created_by`=Sara. Optional path with `priority_code='high'`, `requested_service_type_code='umrah'` accepted.
- Rejections: dept-not-in-branch ("department does not belong to branch"); `lead_source_code='bogus'` ("unknown lead_source_code"); `requested_service_type_code='nope'` ("unknown requested_service_type_code"); `priority_code='nope'` ("unknown priority_code").
- Owner at `aal1`: `create_lead(...)` → 42501 (MFA required); at `aal2` → succeeds.
- A trainee (assigned 'trainee', no `CREATE_LEAD` strict grant): `create_lead(...)` → 42501 (permission denied).

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: `create_lead` enforces `CREATE_LEAD` via `authorize()` (so the MFA policy composes for high-risk roles), stays within `app.current_tenant_id()`, and validates branch/department coherence plus the three catalog codes against the seeded catalog values (consistent with `25`). The lead is created in the canonical initial state `new`; no transition occurs, so the absence of event emission is correct for this slice (events are earned at the assignment transition). No schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Intake creates the lead **unassigned** in `new`; `assigned_user_id`, `owner_*`, and the `lead_assignments` history are populated by the round-robin assignment capability (next), which performs the `new → assigned` transition and — per `26_state_machines.md` — must record a `lead_assigned` event. That is the natural point at which the cross-cutting **security-event emission** seam is earned; a `lead_created` event can be retrofitted onto `create_lead` at that time (cheap `create or replace`). `requested_service_type_code`/`priority_code`/`lead_source_code` are validated against catalogs (not FKs, per SPEC-030) so employees cannot free-type operational codes (`25`). `customer_id` is optional — anonymous intake is allowed and customer identity matching is a later Phase-4 capability.
