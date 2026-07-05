# Change Request — SPEC-052

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

Create migration 19, `create_rls_policies`, enabling Row Level Security on every public base table and applying policies per `35_tenant_isolation_and_data_access_principles.md`.

---

## Business Reason

`33` migration 19 is the tenant-isolation enforcement layer. It implements the principles consolidated in `35`: database-enforced default-deny isolation by `tenant_id`, resolved through a single `SECURITY DEFINER` primitive, with category-specific policies for global, auth-support, catalog, and append-only audit tables.

---

## Risks

Moderate (touches all 71 tables) but mechanical and derived from `35`. Structure/policy only — no data change. The Supabase `service_role` bypasses RLS (backend/platform access); `anon` receives no policy (default deny). Physical choices and one finding in Notes.

---

## Supersedes / Depends On

Depends On: `SPEC-050` (`35` principles), `SPEC-032` (users/RBAC), `SPEC-051` (catalog_values FKs) — Complete. Implements `31 §13` item 3 and `30` Identity Key/Tenant Scope Standards.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607043300_create_rls_policies.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; any later migration ; seed data ; table structure (no DDL beyond the `app` schema/function/trigger and policies)

---

## Minimum Reading List

- _ORVION_CANONICAL/35_tenant_isolation_and_data_access_principles.md
- _ORVION_CANONICAL/30_database_conventions.md (Tenant Scope + Identity Key Standards)
- _ORVION_CANONICAL/34_authentication_and_identity_principles.md (auth-support ownership)

---

## Implementation Steps

1. Create `supabase/migrations/202607043300_create_rls_policies.sql`: (a) `app` schema + `app.current_tenant_id()` SECURITY DEFINER resolution primitive (active-tenant-aware, degrading to the single active membership) + `app.forbid_mutation()` trigger function; (b) enable RLS and a `tenant_isolation` policy on every `tenant_id`-NOT-NULL table; (c) read-all-authenticated on the 10 global tables; (d) own-tenant policy on `tenants`; (e) `auth_user_id` ownership on the 3 auth-support tables; (f) `catalog_values` dual-read + tenant-write; (g) append-only insert+read policies and an immutability trigger on `events`/`security_events`.

---

## Acceptance Criteria

- [x] `supabase/migrations/202607043300_create_rls_policies.sql` exists.
- [x] `npx supabase db reset` applies every migration on a clean database with no error.
- [x] RLS is enabled on all 71 public base tables; no RLS-enabled table lacks a policy.
- [x] The resolution primitive `app.current_tenant_id()` exists (SECURITY DEFINER, non-API schema) and resolves `auth.uid()` to the correct tenant.
- [x] Behavioral: a tenant user sees only their tenant's rows and their own tenant; a stranger sees none; system catalog rows are readable; `events`/`security_events` reject UPDATE/DELETE.

---

## Execution Log

### 2026-07-06 — Claude (Tier 2 execution)

Outcome: Complete

Step results:
- Step 1: Applied — created the RLS migration; `npx supabase db reset` applied all 21 migrations cleanly.

Database Audit: 71/71 tables RLS-enabled, none disabled; 76 policies (54 tenant_isolation + 10 read-all + 1 tenant_self + 3 owner_only + 4 catalog + 2 audit_read + 2 audit_insert); resolution function present; 2 immutability triggers; no RLS-enabled table without a policy. Behavioral (simulated authenticated session): resolver returned the caller's tenant; the caller saw exactly their tenant's 1 customer and only their own tenant; a stranger (unknown auth.uid) saw 0; 395 system catalog rows readable; UPDATE/DELETE on `events` raised. Immutability trigger confirmed independently.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Policies match `35`'s four application-rule cases across all categories. The single-resolution-primitive rule holds — every tenant policy references `app.current_tenant_id()`, so the mechanism can evolve in one place. Row-scoping proven correct behaviorally (isolation + default-deny + dual-read catalog + append-only). `service_role` bypass and `anon` default-deny preserved. Finding logged (authenticated DML grants, backend phase) — not a defect of this migration. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Physical decisions: resolution + trigger functions live in a non-API `app` schema (`SECURITY DEFINER`, `search_path=''`); `app.current_tenant_id()` reads an optional `app.active_tenant_id` session setting and degrades to the single active membership (MVP), so multi-membership plumbing later touches only this function; policies target the `authenticated` role (`service_role` bypasses RLS by design; `anon` gets nothing). Append-only immutability is enforced both by omitting UPDATE/DELETE policies and by a `before update or delete` trigger (blocks all roles, defence in depth).

**Finding (logged to future-backlog, not a defect):** RLS is the row-scoping layer and sits on top of table privileges. Verified that `authenticated` currently holds only `TRUNCATE/REFERENCES/TRIGGER` (Supabase default), not `SELECT/INSERT/UPDATE/DELETE`, so end-user clients cannot yet reach any table — a safe, fully-locked state. Granting DML to `authenticated` (with RLS enforcing rows) and deciding `anon` read scope is an access-layer decision that pairs with the API/backend phase; there is no client consumer now, so it is deliberately deferred. Subscription-state gating remains distinct (service layer for MVP) per `35`.
