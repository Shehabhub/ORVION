# Change Request — SPEC-058

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

Record ADR-0016 (platform-mediated tenant provisioning) and add the first two identity/access RPCs: `app.provision_tenant(...)` (service_role-only; creates a tenant + its owner user + owner role assignment) and `app.has_permission(permission_key)` (the binary authorization primitive per ADR-0015).

---

## Business Reason

Phase 3 needs an app-driven way to create the first tenant and owner — RLS requires a `users` membership that could not otherwise exist (bootstrap gap). The owner approved platform-mediated provisioning (Option A), consistent with ORVION's bank-transfer / platform-approval billing model. `has_permission()` is the authorization primitive every subsequent management RPC will use; it is introduced here and grounded by verifying it end-to-end against the freshly provisioned owner.

---

## Risks

Low–moderate. Two SECURITY DEFINER functions. `provision_tenant` is revoked from public/authenticated and granted only to `service_role`, so tenants cannot self-provision. `has_permission` resolves strictly within `app.current_tenant_id()` and returns only a boolean. No schema/table change. Provisioning creates no subscription row (that lifecycle is a separate slice), so a provisioned tenant has `status='trial'` and no plan until a later subscription capability.

---

## Supersedes / Depends On

Depends On: `SPEC-052` (`app.current_tenant_id()`, RLS), `SPEC-055` (authenticated grants), `SPEC-056`/`SPEC-057` (roles/permissions/role_permissions + ADR-0015). Establishes ADR-0016. Precedes user/branch/department management RPCs.

---

## Scope — Files Allowed to Modify

- reports/architecture-decision-records.md (append ADR-0016)
- supabase/migrations/202607043700_provision_tenant_and_has_permission.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; table structure ; roles/permissions/role_permissions data ; subscription_plans / feature_entitlements seeding ; event emission wiring

---

## Minimum Reading List

- reports/architecture-decision-records.md (ADR-0015, ADR-0016)
- supabase/migrations/202607043300_create_rls_policies.sql (app.current_tenant_id pattern)
- supabase/migrations/202607041700_create_identity_and_access_tables.sql (users, user_role_assignments)

---

## Implementation Steps

1. Append ADR-0016 (platform-mediated provisioning; service_role-only RPC; status param default 'trial'; subscription lifecycle deferred; escalation trigger).
2. Create `supabase/migrations/202607043700_provision_tenant_and_has_permission.sql`:
   (a) `app.provision_tenant(p_tenant_name, p_tenant_slug, p_owner_email, p_owner_full_name, p_owner_auth_user_id default null, p_default_currency_code default null, p_tenant_status default 'trial')` — plpgsql SECURITY DEFINER, `set search_path=''`; inserts tenant, owner `users` row, owner `user_role_assignments` (scope_type='tenant'); returns (tenant_id, owner_user_id). Revoke from public; grant execute to `service_role` only.
   (b) `app.has_permission(p_permission_key text)` — sql STABLE SECURITY DEFINER, `set search_path=''`; returns boolean = the caller (auth.uid, active, within `app.current_tenant_id()`) holds an active role assignment whose role grants the permission. Grant execute to `authenticated`.

---

## Acceptance Criteria

- [x] ADR-0016 recorded (decision, rationale, rejected alternatives, consequences, escalation trigger).
- [x] The migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] `provision_tenant` is executable by `service_role` and NOT by `authenticated`/`anon`/public.
- [x] Provisioning a tenant creates exactly one tenant (status='trial'), one owner `users` row, one active owner `user_role_assignments` (scope_type='tenant').
- [x] As the provisioned owner, `has_permission('MANAGE_USERS')` and `has_permission('CREATE_LEAD')` return true; `has_permission('MANAGE_SUBSCRIPTION')` and `has_permission('VIEW_ADVANCED_DASHBOARDS')` return false (not owner-granted per ADR-0015); a stranger / no-membership caller gets false.

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — ADR-0016 appended.
- Step 2: Applied — created both functions; `npx supabase db reset` applied all migrations cleanly; `scripts/verify_database.sql` still reports ALL CHECKS PASSED.

Behavioral test (via a real auth.users identity + provisioning): called `app.provision_tenant('Meridian Travel','meridian',...,null currency,'trial')` as service_role → created 1 tenant (status='trial'), 1 owner users row (auth_user_id linked), 1 active owner user_role_assignments (scope_type='tenant'). Executing `provision_tenant` as `authenticated` raised `insufficient_privilege` (grant model correct — service_role-only). Simulating the owner's JWT (`request.jwt.claims`→auth.uid), `app.has_permission` returned: MANAGE_USERS=true, CREATE_LEAD=true, APPROVE_FINANCE=true (owner IS granted it per matrix 28), MANAGE_SUBSCRIPTION=false (owner cell = Limited → no strict-Yes row), VIEW_ADVANCED_DASHBOARDS=false (plan-gated, no role cell); a stranger auth.uid returned false for MANAGE_USERS. Smoke-test: ALL CHECKS PASSED.

Fix applied during execution: `service_role` lacked USAGE on the `app` schema (migration 19 granted it only to `authenticated`); added `grant usage on schema app to service_role` to this migration so the service_role can reach `provision_tenant`. Also confirmed `default_currency_code` must be passed null until the reference-data layer seeds `currencies` (a real FK; currencies is not yet seeded) — the column is nullable, so provisioning without a currency is valid.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: `provision_tenant` is `service_role`-only (revoked from public), resolves the owner role by code, and writes tenant+user+role-assignment atomically in one plpgsql body. `has_permission` is a binary check scoped through `app.current_tenant_id()` and active `user_role_assignments` → `role_permissions`, consistent with ADR-0015 (no scope/conditional logic embedded — that stays in calling RPCs). E2E proof reproduced against a provisioned owner and a non-member. No table/schema change; subscription lifecycle correctly untouched. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

`provision_tenant` emits no `security_event` yet, though `28`'s Event Requirements list "Role assigned" as event-generating — deferred (recorded in memory) until the eventing capability is built, rather than half-wiring it here. No `subscriptions` row / `subscription_plans` seed is created: the subscription/billing lifecycle is a separate future slice; a provisioned tenant sits at `status='trial'` with no plan until then. `has_permission` returns a pure boolean role→permission decision; scope narrowing (branch/department/assigned) and plan-gating are applied by the calling RPC per ADR-0015. `assigned_by` on the owner's role assignment is left null (platform-provisioned; no tenant-user assigner).
