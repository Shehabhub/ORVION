# Change Request — SPEC-061

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

Add `app.activate_membership()` — the activation/claim RPC that links an authenticated Supabase identity (`auth.users`) to its pre-created, unlinked `users` membership(s) by matching the caller's Supabase-verified email, completing the invitation flow.

---

## Business Reason

Phase 3 "User accounts" / invitation flow. An owner invites a teammate by (1) pre-creating their membership unlinked (`create_tenant_user` with `auth_user_id` null, already supported) and (2) inviting them through Supabase Auth (which creates the verified `auth.users` identity and sends the email — Supabase owns the invite token, so ORVION builds none). On first sign-in the invitee calls `activate_membership()` to bind their verified identity to the waiting membership(s), after which membership + permission resolution + RLS all work for them.

---

## Risks

Low. One SECURITY DEFINER RPC. It links only memberships whose email equals the caller's Supabase-verified `auth.users` email and that are currently unlinked (`auth_user_id is null`) and active — so a caller can only claim memberships for an email they have proven (via Supabase Auth) to own. Idempotent: re-calling claims nothing new and simply returns the caller's memberships. The per-tenant unique `(tenant_id, auth_user_id)` and `(tenant_id, email)` constraints bound it to at most one membership per tenant.

---

## Supersedes / Depends On

Depends On: `SPEC-059` (create_tenant_user pre-creates the unlinked membership), `SPEC-055`/`SPEC-052` (my_memberships/RLS), ADR-0011 (auth.users = shared human identity). Complements `app.my_memberships()`.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607044000_activate_membership.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; reports/** ; supabase/config.toml ; any existing migration ; table structure ; RBAC seed data ; TOTP/device-trust ; event emission ; no ORVION-side invitation-token table (Supabase Auth owns the invite)

---

## Minimum Reading List

- supabase/migrations/202607043400_grant_authenticated_access_and_memberships.sql (my_memberships pattern)
- supabase/migrations/202607041700_create_identity_and_access_tables.sql (users: auth_user_id nullable, unique (tenant,email)/(tenant,auth_user_id))
- reports/architecture-decision-records.md (ADR-0011)

---

## Implementation Steps

1. Create `supabase/migrations/202607044000_activate_membership.sql`: `app.activate_membership()` — plpgsql SECURITY DEFINER, `set search_path=''`. Read `auth.uid()` (raise if null) and the caller's verified email from `auth.users`. `UPDATE public.users SET auth_user_id = uid WHERE lower(email)=lower(verified_email) AND auth_user_id IS NULL AND is_active`. Then `RETURN QUERY` the caller's memberships (membership_id, tenant_id, tenant_name, is_active) — same shape as `my_memberships()`. Grant execute to `authenticated`.

---

## Acceptance Criteria

- [x] The migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] An owner pre-creates an unlinked membership (create_tenant_user, auth_user_id null); the invitee (a Supabase identity with the matching verified email) calls `activate_membership()` and their membership becomes linked; `my_memberships()` then returns it and, once assigned a role, `has_permission()` resolves.
- [x] A caller whose verified email matches no unlinked membership claims nothing (returns their existing memberships, possibly none).
- [x] Re-calling `activate_membership()` is idempotent (no new links; returns the same memberships).
- [x] A caller cannot claim a membership whose email differs from their verified email.

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — created `app.activate_membership()`; `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test:
- Owner (provisioned) pre-created an unlinked membership for sara@meridian.test (create_tenant_user, auth_user_id null) and assigned 'employee'. A Supabase `auth.users` identity for sara (verified email sara@meridian.test) called `activate_membership()` → 1 membership linked; `my_memberships()` returned Meridian; `has_permission('CREATE_LEAD')`=true afterwards.
- Re-calling `activate_membership()` as sara linked 0 new rows and returned the same single membership (idempotent).
- An identity with email mismatch@nowhere.test called `activate_membership()` → claimed nothing (0 memberships), and sara's membership stayed bound to sara (no hijack).

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: `activate_membership()` binds only unlinked, active memberships whose email equals the caller's Supabase-verified `auth.users` email, so claim authority derives from Supabase Auth's email verification — a caller cannot claim an email they do not own. Idempotent and safe under the per-tenant unique constraints. Returns the caller's memberships in the `my_memberships()` shape. No ORVION-side invite token was introduced (Supabase Auth owns the invite), consistent with the Supabase-native architecture. No file outside Scope modified; no schema change.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

The invitation "token" and email delivery are Supabase Auth's responsibility (`inviteUserByEmail` / OTP / magic link), not ORVION's — building an ORVION invite-token table would duplicate that and is not earned. ORVION's contribution is the membership-claim binding. Email match is case-insensitive on the Supabase-verified address; because the caller's `auth.users` row exists only after Supabase verifies the email, the match is an authorization proof, not a guess. Multi-tenant humans: if the same verified email has unlinked memberships in several tenants, all are claimed (one per tenant, bounded by the unique constraints) — consistent with ADR-0011 (auth.users is the shared human identity). Active-tenant selection across multiple memberships remains the deferred `set_active_tenant()` concern (ADR-0011; MVP degrades to the single membership).
