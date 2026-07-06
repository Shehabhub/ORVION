# Change Request — SPEC-059

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

Add the first tenant-facing identity/access RPCs: `app.create_tenant_user(...)` and `app.assign_user_role(...)`, both guarded by `app.has_permission('MANAGE_USERS')` and scoped to `app.current_tenant_id()`. These give an owner/CEO the ability to add users to their tenant and grant them roles.

---

## Business Reason

Provisioning (SPEC-058) creates a tenant + its owner, but the owner then needs to build their team — add users and assign roles. This is the "User accounts" and "Role/permission assignment" output of Phase 3. It is the first real consumer of `has_permission()`, grounding that primitive in an enforced flow.

---

## Risks

Low. Two `SECURITY INVOKER` functions (RLS remains a backstop — the caller must already hold INSERT + tenant-scoped RLS) that additionally enforce `MANAGE_USERS` via `has_permission()`. No schema/table change. Role assignment is limited to seeded roles; the target user must belong to the caller's tenant.

---

## Supersedes / Depends On

Depends On: `SPEC-058` (`provision_tenant`, `has_permission`), `SPEC-057` (role_permissions / ADR-0015), `SPEC-055` (authenticated DML + RLS). Precedes branch/department assignment RPCs and invitation/activation flow.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607043800_user_management_rpcs.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; reports/** ; supabase/config.toml ; any existing migration ; table structure ; RBAC seed data ; branch/department assignment ; invitation/activation ; event emission

---

## Minimum Reading List

- supabase/migrations/202607043700_provision_tenant_and_has_permission.sql (has_permission, current_tenant_id patterns)
- supabase/migrations/202607041700_create_identity_and_access_tables.sql (users, user_role_assignments)
- _ORVION_CANONICAL/28_permissions_matrix.md (MANAGE_USERS authority)

---

## Implementation Steps

1. Create `supabase/migrations/202607043800_user_management_rpcs.sql`:
   (a) `app.create_tenant_user(p_full_name, p_email, p_phone default null, p_auth_user_id default null)` — plpgsql SECURITY INVOKER, `set search_path=''`; resolves `app.current_tenant_id()`, requires `app.has_permission('MANAGE_USERS')`, inserts a `users` row in that tenant, returns the new user id. Grant execute to `authenticated`.
   (b) `app.assign_user_role(p_user_id, p_role_code, p_scope_type default 'tenant', p_branch_id default null, p_department_id default null)` — plpgsql SECURITY INVOKER, `set search_path=''`; requires `MANAGE_USERS`, verifies the target user is in the caller's tenant, resolves the role by code, inserts an active `user_role_assignments` row with `assigned_by` = the caller's user id, returns the assignment id. Grant execute to `authenticated`.

---

## Acceptance Criteria

- [x] The migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] As a provisioned owner, `create_tenant_user` creates a user in the owner's tenant and `assign_user_role` grants that user a role; the new user then resolves `has_permission()` for that role's permissions.
- [x] Both RPCs raise a permission error (SQLSTATE 42501) when the caller lacks `MANAGE_USERS` (e.g. an employee).
- [x] `assign_user_role` rejects a target user_id outside the caller's tenant and an unknown role code.
- [x] Both RPCs are executable by `authenticated`, not `anon`.

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — created both functions; `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (owner from SPEC-058 flow, JWT simulated):
- As owner: `create_tenant_user('Sara Agent','sara@meridian.test')` → new user in owner's tenant; `assign_user_role(sara, 'employee')` → active tenant-scoped assignment (assigned_by = owner's user id).
- As Sara (her JWT): `has_permission('CREATE_LEAD')`=true (employee grant), `has_permission('MANAGE_USERS')`=false.
- As Sara: `create_tenant_user(...)` raised `permission denied: MANAGE_USERS` (SQLSTATE 42501).
- As owner: `assign_user_role(<random uuid>, 'employee')` raised "target user is not in your tenant"; `assign_user_role(sara,'not_a_role')` raised "unknown or inactive role".

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Both RPCs enforce `MANAGE_USERS` via `has_permission()` and stay within `app.current_tenant_id()`; SECURITY INVOKER keeps RLS as a second line of defence. Role assignment validates tenant membership of the target and role existence, and records `assigned_by`. The employee-denial and bad-input paths raise as specified. E2E chain (provision → create user → assign role → new user resolves permissions) reproduced. No file outside Scope modified; no schema change.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Both RPCs are `SECURITY INVOKER` (unlike `provision_tenant`, which must be DEFINER to write before any RLS context exists): the caller already holds INSERT + tenant-scoped RLS on `users`/`user_role_assignments` (SPEC-055), so RLS remains an enforced backstop and the RPC adds the `MANAGE_USERS` authorization gate that RLS does not express. Per ADR-0015 only the binary `MANAGE_USERS` grant is enforced here; scoped management (branch_manager "Branch only", department_manager "Department only") is deferred until its scope enforcement is built, at which point those roles earn the corresponding capability — for now only owner/CEO (the strict-"Yes" holders) can manage users. `assign_user_role` accepts scope/branch/department parameters but does not yet validate scope-vs-branch coherence (e.g. branch scope requires a branch_id) — that validation lands with the branch/department assignment slice. Role-assignment security_event emission remains deferred (28 Event Requirements) with the eventing capability.
