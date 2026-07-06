# Change Request — SPEC-063

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

Add the device-trust baseline RPCs over the ORVION-owned `trusted_devices` table: `app.record_trusted_device(...)`, `app.my_trusted_devices()`, `app.revoke_trusted_device(...)`.

---

## Business Reason

Phase 3 "Device trust baseline" output. Per ADR-0017, `trusted_devices` is an ORVION-owned concept (Supabase Auth has no first-class trusted-device primitive); it is keyed to the Human Identity (`auth.users`) per Principles 1/6 — device trust is established during authentication, before any tenant is chosen. These RPCs let an authenticated human register, list, and revoke their trusted devices.

---

## Risks

Low. Three `SECURITY INVOKER` functions over a table whose RLS (migration 19) is owner-only by `auth.uid()`; RLS is the backstop and the functions scope every operation to the caller's own `auth.uid()`. No table/schema change. Idempotent registration (re-recording the same device updates `last_seen_at`, does not duplicate).

---

## Supersedes / Depends On

Depends On: migration 29 (`trusted_devices`), migration 19 (owner-only RLS), `SPEC-055` (authenticated DML), ADR-0017 (ORVION owns device trust). Complements the Supabase-native authentication model.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607044200_device_trust_baseline.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; reports/** ; supabase/config.toml ; any existing migration ; table structure ; otp_challenges/totp_enrollments ; event emission

---

## Minimum Reading List

- supabase/migrations/202607042900_create_authentication_support_tables.sql (trusted_devices columns)
- supabase/migrations/202607043300_create_rls_policies.sql (owner_only policy on trusted_devices)
- _ORVION_CANONICAL/34_authentication_and_identity_principles.md (Principles 1, 6)

---

## Implementation Steps

1. Create `supabase/migrations/202607044200_device_trust_baseline.sql`:
   (a) `app.record_trusted_device(p_device_identifier text)` — plpgsql SECURITY INVOKER; for the caller's `auth.uid()`, update the existing `(auth_user_id, device_identifier)` row (`last_seen_at=now()`, `status_code='trusted'`, `verified_at=coalesce(verified_at, now())`, clear `revoked_at`), else insert a new trusted row; return the device id.
   (b) `app.my_trusted_devices()` — returns the caller's devices.
   (c) `app.revoke_trusted_device(p_device_id uuid)` — sets `status_code='revoked'`, `revoked_at=now()` for the caller's device; raises if not found.
   All: `set search_path=''`, scoped to `auth.uid()`; grant execute to `authenticated`.

---

## Acceptance Criteria

- [x] The migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] `record_trusted_device` creates a trusted row for the caller; re-recording the same identifier updates `last_seen_at` without duplicating.
- [x] `my_trusted_devices` returns only the caller's devices; `revoke_trusted_device` marks one revoked.
- [x] A different human (`auth.uid()`) cannot see or revoke another's device (RLS + `auth.uid()` scoping).
- [x] Both work without any tenant/membership (device trust is pre-tenant, keyed to the Human Identity).

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — created the three functions; `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (two auth identities, no membership needed):
- User A `record_trusted_device('device-abc')` → 1 trusted row; re-recording `'device-abc'` → still 1 row, `last_seen_at` advanced. `my_trusted_devices()` → 1.
- `revoke_trusted_device(<id>)` → status_code='revoked', revoked_at set.
- User B `my_trusted_devices()` → 0 (cannot see A's device); B attempting `revoke_trusted_device(<A's id>)` → "device not found" (RLS-scoped).

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: All three RPCs scope strictly to `auth.uid()` with owner-only RLS as backstop; registration is idempotent per `(auth_user_id, device_identifier)`; revocation and cross-user isolation behave as specified and require no tenant context (correct for a Human-Identity artifact per Principles 1/6 and ADR-0017). No schema change; `otp_challenges`/`totp_enrollments` untouched. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

`trusted_devices` has no unique `(auth_user_id, device_identifier)` constraint (frozen schema), so registration does an explicit update-else-insert rather than `on conflict`; a uniqueness constraint is a possible future refinement. `status_code` uses the `trusted_device_status` catalog values (`trusted`/`revoked`/`expired`); expiry (`expired`) is a future policy concern (e.g. a scheduled job), not built here. This completes the Phase-3 identity capability group; the owner-suggested one-time end-to-end User Lifecycle Review runs next (see memory `user-lifecycle-review-milestone`).
