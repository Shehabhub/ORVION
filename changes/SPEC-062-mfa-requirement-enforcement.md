# Change Request — SPEC-062

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

Record ADR-0017 (Supabase-native authentication) and implement the MFA-requirement policy ORVION owns: `app.requires_mfa()`, `app.mfa_satisfied()`, a combined `app.authorize(permission_key)` guard (permission AND MFA), and enforcement of that guard on the existing sensitive management RPCs.

---

## Business Reason

`28` requires high-risk roles (owner/ceo/finance_manager/system_administrator) to clear MFA. Per ADR-0017 the MFA artifact/verification is Supabase Auth's (`aal` claim); ORVION owns the *requirement* and enforces it. Folding the check into a single `authorize()` guard applied to management RPCs makes "high-risk roles must be MFA-verified to perform sensitive actions" real and centralizes the pattern for future RPCs.

---

## Risks

Low–moderate. Adds three functions and `create or replace`s the five existing management RPCs to route their guard through `app.authorize()` (behaviour identical except the added MFA assertion). No table/schema change. A high-risk role now needs a session `aal='aal2'` to perform management actions — intended; non-high-risk roles are unaffected (`requires_mfa()` false → `mfa_satisfied()` true).

---

## Supersedes / Depends On

Depends On: `SPEC-058` (has_permission), `SPEC-059`/`SPEC-060` (the management RPCs re-defined here). Establishes ADR-0017. Builds on ADR-0014 (Supabase-native).

---

## Scope — Files Allowed to Modify

- reports/architecture-decision-records.md (append ADR-0017)
- supabase/migrations/202607044100_mfa_requirement_enforcement.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; table structure ; RBAC seed data ; migration-29 auth-support tables (not repurposed here) ; device-trust RPCs (separate slice) ; event emission

---

## Minimum Reading List

- reports/architecture-decision-records.md (ADR-0014, ADR-0017)
- supabase/migrations/202607043800_user_management_rpcs.sql ; 202607043900_organization_management_rpcs.sql (RPCs re-defined)
- _ORVION_CANONICAL/28_permissions_matrix.md (Authentication Requirements By Role)

---

## Implementation Steps

1. Append ADR-0017 (Supabase-native authentication; artifacts → Supabase Auth, policy → ORVION; evolution framing).
2. Create `supabase/migrations/202607044100_mfa_requirement_enforcement.sql`:
   (a) `app.requires_mfa()` — true if the caller's active membership (within `app.current_tenant_id()`) holds a high-risk role (owner/ceo/finance_manager/system_administrator).
   (b) `app.mfa_satisfied()` — `(not requires_mfa()) OR (JWT aal = 'aal2')`.
   (c) `app.authorize(p_permission_key)` — raises 42501 unless `has_permission(key)`; raises 42501 (MFA) unless `mfa_satisfied()`.
   (d) `create or replace` `create_tenant_user`, `assign_user_role`, `create_branch`, `create_department`, `assign_user_branch` to route their guard through `app.authorize(...)` (bodies otherwise unchanged). Grants preserved.

---

## Acceptance Criteria

- [x] ADR-0017 recorded (evolution framing; artifacts → Supabase Auth, policy → ORVION).
- [x] The migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] A high-risk owner with `aal='aal2'` can perform management RPCs; the same owner with `aal='aal1'` (or no aal) is blocked with SQLSTATE 42501 (MFA required).
- [x] `requires_mfa()` is true for an owner and false for an employee; a non-high-risk user is never MFA-blocked.
- [x] `has_permission()` is unchanged (pure authz); the MFA gate lives only in `authorize()`/the RPCs.

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — ADR-0017 appended.
- Step 2: Applied — added `requires_mfa`, `mfa_satisfied`, `authorize`; re-defined the five management RPCs to guard via `app.authorize()`. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (provisioned owner + employee, JWTs simulated):
- Owner with `aal='aal2'`: `create_branch(...)` succeeded; `requires_mfa()`=true, `mfa_satisfied()`=true.
- Owner with `aal='aal1'` (and with no aal claim): `create_tenant_user(...)`/`create_branch(...)` raised SQLSTATE 42501 "multi-factor authentication required"; `mfa_satisfied()`=false.
- Employee (Sara) — `requires_mfa()`=false, `mfa_satisfied()`=true even at aal1 (not high-risk); still denied management by permission (42501) as before.
- `has_permission()` results unchanged from SPEC-058/059.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: `requires_mfa()` transcribes `28`'s high-risk set; `mfa_satisfied()` reads the Supabase `aal` claim and only gates when required; `authorize()` cleanly composes permission + MFA and is the single guard the five RPCs now share. `has_permission()` stays pure authz (ADR-0015), so RLS and permission resolution are unaffected — the MFA policy is additive and lives at the RPC boundary, consistent with ADR-0017 (ORVION owns the requirement; Supabase owns the artifact/aal). No schema change; migration-29 tables untouched. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

The MFA gate is intentionally at the RPC boundary via `authorize()`, not inside `has_permission()` — authorization (what a role may do) stays separate from authentication policy (has this session cleared MFA), per ADR-0015/0017. `provision_tenant` is unchanged: it is a `service_role` platform operation, not a tenant-user action, so the tenant-role MFA policy does not apply. The high-risk role set is transcribed from `28`; a data-driven form (a `roles` column) is deferred (schema frozen). Device-trust baseline (ORVION-owned `trusted_devices` per ADR-0017) is a separate follow-up slice. Simulated `aal` in tests stands in for the Supabase-issued claim; in production the app must obtain `aal2` via Supabase MFA before high-risk management succeeds.
