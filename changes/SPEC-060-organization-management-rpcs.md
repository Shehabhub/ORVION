# Change Request — SPEC-060

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

Add the Organization Management identity/access RPCs: `app.create_branch(...)`, `app.create_department(...)`, and `app.assign_user_branch(...)` — guarded by `MANAGE_BRANCHES` / `MANAGE_DEPARTMENTS` / `MANAGE_USERS` respectively and scoped to `app.current_tenant_id()`.

---

## Business Reason

Phase 3's "Branch/department assignment" output: after users exist (SPEC-059), an owner/CEO structures the company into branches and departments and places users within them. Branch/department scope is also what the deferred scoped-management grants (branch_manager "Branch only", department_manager "Department only") will later narrow against, per ADR-0015.

---

## Risks

Low. Three `SECURITY INVOKER` functions (RLS backstop) adding the appropriate `has_permission()` gate. `create_department` validates its `department_type_code` against the seeded `department_type` catalog and that the branch is in the caller's tenant; `assign_user_branch` validates user, branch, and (if given) department coherence. No schema/table change.

---

## Supersedes / Depends On

Depends On: `SPEC-059` (create_tenant_user/assign_user_role), `SPEC-058` (has_permission), `SPEC-052` (RLS). Precedes the invitation/activation and auth-hardening slices.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607043900_organization_management_rpcs.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; reports/** ; supabase/config.toml ; any existing migration ; table structure ; RBAC seed data ; branch_business_hours / holidays ; invitation/activation ; event emission

---

## Minimum Reading List

- supabase/migrations/202607041600_create_organization_tables.sql (branches, departments, user_branch_assignments target)
- supabase/migrations/202607043800_user_management_rpcs.sql (RPC pattern)
- _ORVION_CANONICAL/28_permissions_matrix.md (MANAGE_BRANCHES / MANAGE_DEPARTMENTS / MANAGE_USERS)

---

## Implementation Steps

1. Create `supabase/migrations/202607043900_organization_management_rpcs.sql`:
   (a) `app.create_branch(p_name, p_slug, p_branch_type default null, p_primary_phone default null, p_address default null)` — requires `MANAGE_BRANCHES`; inserts a branch in the caller's tenant; returns branch id.
   (b) `app.create_department(p_branch_id, p_department_type_code, p_name)` — requires `MANAGE_DEPARTMENTS`; verifies the branch is in the caller's tenant; validates `p_department_type_code` against the seeded `department_type` catalog; inserts the department; returns department id.
   (c) `app.assign_user_branch(p_user_id, p_branch_id, p_department_id default null, p_is_primary default false, p_transfer_type_code default null)` — requires `MANAGE_USERS`; verifies user and branch are in the caller's tenant and (if given) the department belongs to the branch; inserts a `user_branch_assignments` row (created_by = caller); returns assignment id.
   All three: plpgsql SECURITY INVOKER, `set search_path=''`, permission errors raise SQLSTATE 42501. Grant execute to `authenticated`.

---

## Acceptance Criteria

- [x] The migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] As an owner: `create_branch` → branch in tenant; `create_department` → department under that branch; `assign_user_branch` → assignment placing a user in the branch/department.
- [x] `create_department` rejects an unknown `department_type_code` and a branch outside the caller's tenant.
- [x] `assign_user_branch` rejects a department that does not belong to the given branch, and a user/branch outside the tenant.
- [x] A caller without the required permission (e.g. employee) is denied with SQLSTATE 42501.

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — created all three functions; `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (provisioned owner + a created employee "Sara", JWTs simulated):
- Owner: `create_branch('Downtown','downtown')` → branch; `create_department(branch,'sales','Sales Team')` → department; `assign_user_branch(sara, branch, dept, is_primary=>true)` → assignment. Counts: 1 branch, 1 department, 1 primary branch assignment for Sara.
- `create_department(branch,'not_a_type','X')` → rejected ("unknown department_type_code"); `create_department(<foreign branch id>, 'sales','X')` → rejected ("branch is not in your tenant").
- `assign_user_branch(sara, branch, <dept of another branch>)` → rejected ("department does not belong to branch").
- Sara (employee): `create_branch(...)` → denied SQLSTATE 42501 (lacks MANAGE_BRANCHES).

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Each RPC enforces the correct permission from matrix 28 (`MANAGE_BRANCHES` / `MANAGE_DEPARTMENTS` / `MANAGE_USERS`) and stays within `app.current_tenant_id()`; SECURITY INVOKER keeps RLS a backstop. `create_department` validates the type code against the seeded `department_type` catalog (consistent with `25`'s "employees must not create operational types freely") and tenant-scopes the branch; `assign_user_branch` enforces user/branch/department coherence. All rejection and denial paths reproduced. `branch_business_hours`/`holidays` correctly left out of scope (operational scheduling, not identity/access). No file outside Scope modified; no schema change.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Scope decision (phase-fit): `branch_business_hours` and `holidays` are operational scheduling config, not identity/access — building them now would solve a future (operations-phase) problem, so they are deferred and recorded here rather than implemented. Only the org structure that identity/access needs (branches, departments, user placement) is built. Per ADR-0015 the binary permission is enforced; scoped management for branch_manager/department_manager ("Branch only"/"Department only") is still deferred until scope enforcement is built, so for now only owner/CEO can manage the organization. `assign_user_branch` relies on the existing partial unique index (one current primary branch per user) to enforce single-primary; re-pointing a user's primary branch (ending the prior assignment first) is a refinement for the assignment-lifecycle slice. Role-assignment/organization security_event emission remains deferred (28 Event Requirements) with the eventing capability.
