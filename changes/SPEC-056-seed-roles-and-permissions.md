# Change Request — SPEC-056

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word anywhere in a Change Request.

---

## Assigned Model Tier

[ ] Tier 1 — Strong reasoning model
[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Seed the two flat global RBAC catalogs — `roles` (9 role codes) and `permissions` (64 permission keys) — from `25_catalog_registry.md`. Seed only; no `role_permissions` mapping and no enforcement function (those require an architectural decision, out of scope).

---

## Business Reason

Phase 3 (Identity & Access) needs the canonical role and permission vocabulary present in the database before any role assignment, permission check, or management RPC can reference it. These two lists are flat, unambiguous, and unblocked. The `role_permissions` mapping is deliberately excluded: the permission matrix in `28_permissions_matrix.md` carries scope-aware, conditional, and plan-gated semantics that the binary `role_permissions (role_id, permission_id)` table cannot express, so *how* the matrix realizes is a separate owner-level architectural decision.

---

## Risks

Very low. Two idempotent seed inserts (`on conflict do nothing` on `roles.code` / `permissions.key`), system rows only (`is_system=true`, `is_active=true`), deterministic placeholder labels. No DDL, no structural change.

---

## Supersedes / Depends On

Depends On: `SPEC-032` (roles/permissions tables), `SPEC-049` (catalog seed pattern). Precedes the permission-model realization decision (`role_permissions` + `has_permission`).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607043500_seed_roles_and_permissions.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; table structure ; role_permissions data ; any enforcement function

---

## Minimum Reading List

- _ORVION_CANONICAL/25_catalog_registry.md (role_code, permission_key)
- supabase/migrations/202607043100_seed_system_catalogs.sql (seed pattern)
- supabase/migrations/202607041700_create_identity_and_access_tables.sql (roles/permissions structure)

---

## Implementation Steps

1. Create `supabase/migrations/202607043500_seed_roles_and_permissions.sql`: (a) insert the 9 role codes into `roles` (`code`, `name`=initcap placeholder, `is_system=true`, `is_active=true`), `on conflict (code) do nothing`; (b) insert the 64 permission keys into `permissions` (`key`, `name`=initcap placeholder, `is_system=true`, `is_active=true`), `on conflict (key) do nothing`.

---

## Acceptance Criteria

- [ ] The migration exists; `npx supabase db reset` applies cleanly.
- [ ] `roles` holds exactly the 9 registry role codes; `permissions` holds exactly the 64 registry permission keys; all rows `is_system=true`, `is_active=true`.
- [ ] Re-applying the migration (db reset / CI) neither duplicates nor errors (idempotent).
- [ ] The Phase 2 verification smoke-test still passes.

---

## Execution Log

(pending)

---

## Verification Notes

(pending)

---

## Review Gate

- [ ] Every change matches the Implementation Steps.
- [ ] No file outside Scope was modified.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] The repository is in a clean, releasable state.

---

## Notes

`role_permissions` is intentionally left empty by this CR. The permission matrix (`28`) is scope-aware (tenant/branch/department/assigned/platform), conditional (Optional / Assigned-only / Limited), and plan-gated — semantics the binary mapping table cannot hold. Flattening it unilaterally would either lose those semantics or bake in an unreviewed interpretation, i.e. exactly the kind of durable artifact that must be *earned* by an owner decision. This CR delivers the unblocked, phase-appropriate slice (the two vocabularies); the realization of the matrix onto `role_permissions` + a resolution/enforcement function + RLS scope is presented separately for owner approval.
