# Change Request — SPEC-055

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word anywhere in a Change Request.

---

## Assigned Model Tier

[ ] Tier 1 — Strong reasoning model
[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Phase 3 (Identity & Access) first slice: grant DML to the `authenticated` role so RLS-scoped clients can use the database, and add the `app.my_memberships()` resolution RPC wiring Supabase Auth to the tenant context.

---

## Business Reason

Under the Supabase-native architecture (ADR-0014), RLS (migration 19) scopes rows but sits on top of table privileges, which `authenticated` did not yet hold — so no client could reach any table. This slice makes the architecture end-to-end functional and provides the login/tenant-selection entry point.

---

## Risks

Low. Grants + one SECURITY DEFINER RPC. RLS still enforces tenant isolation; DELETE is withheld (archive-not-delete); `anon` gets nothing. Grant model derived from existing canon (Notes).

---

## Supersedes / Depends On

Depends On: `SPEC-052` (RLS + `app.current_tenant_id()`), `SPEC-032` (users/RBAC), `SPEC-054` (architecture). Addresses the deferred "authenticated DML grants" backlog item.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607043400_grant_authenticated_access_and_memberships.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; any later migration ; seed data ; table structure

---

## Minimum Reading List

- _ORVION_CANONICAL/35_tenant_isolation_and_data_access_principles.md
- reports/architecture-decision-records.md (ADR-0014)
- supabase/migrations/202607043300_create_rls_policies.sql

---

## Implementation Steps

1. Create `supabase/migrations/202607043400_grant_authenticated_access_and_memberships.sql`: (a) `GRANT SELECT` on the 10 global/reference tables to `authenticated`; (b) `GRANT SELECT, INSERT` on `events`/`security_events`; (c) `GRANT SELECT, INSERT, UPDATE` on every other public table (tenant-owned, `tenants`, `catalog_values`, auth-support) — no DELETE; (d) `app.my_memberships()` SECURITY DEFINER RPC returning the caller's memberships, `grant execute` to `authenticated`.

---

## Acceptance Criteria

- [x] The migration exists; `npx supabase db reset` applies cleanly.
- [x] `authenticated` holds SELECT/INSERT/UPDATE (no DELETE) on tenant tables; SELECT-only on global/reference; SELECT/INSERT on `events`/`security_events`; nothing on `anon`.
- [x] An authenticated user (no manual grant) can read only their own tenant's rows (RLS still enforced) and `app.my_memberships()` returns their memberships.
- [x] The Phase 2 verification smoke-test still passes (foundation invariants unaffected).

---

## Execution Log

### 2026-07-06 — Claude (Tier 2 execution)

Outcome: Complete

Step results:
- Step 1: Applied — created the migration; `npx supabase db reset` applied all migrations cleanly; `scripts/verify_database.sql` still passes (exit 0).

Behavioral (simulated authenticated session, no manual grant): `customers` grants = SELECT/INSERT/UPDATE (no DELETE); `currencies` = SELECT only; `events` = SELECT/INSERT only; the user saw exactly their own tenant's 1 customer (RLS enforced); `app.my_memberships()` returned their single membership (Acme); `app.current_tenant_id()` resolved.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: The grant model matches the derived canon — RLS scopes rows, DELETE withheld per archive-not-delete, global tables read-only, audit tables append-only, `anon` empty. End-to-end proof reproduced: authenticated DML works while tenant isolation holds. `app.my_memberships()` is SECURITY DEFINER and returns only the caller's memberships. Foundation smoke-test unaffected. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Grant model derivation: RLS (migration 19) enforces which rows, so `authenticated` gets broad DML on tenant-owned tables; DELETE is intentionally withheld (archive-not-delete convention; `25` says catalog values are deactivated, not deleted); global/reference tables are platform-managed (SELECT only; writes via `service_role`); `events`/`security_events` are append-only (SELECT/INSERT only, matching their RLS + immutability trigger); `anon` receives nothing (login required). `app.set_active_tenant()` is intentionally NOT built yet — MVP degrades to the single membership (ADR-0011), and a session GUC would not persist across stateless PostgREST requests anyway; it is deferred to the multi-membership UX with its persistence mechanism. This closes the deferred "authenticated DML grants" backlog item. Next Phase 3 slices proceed capability-by-capability (e.g., tenant/user/role management RPCs, TOTP-required enforcement).
