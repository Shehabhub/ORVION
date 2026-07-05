# Change Request — SPEC-051

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

Add the two deferred `catalog_values` foreign keys (`tenant_id → tenants`, `created_by → users`) recorded as SPEC-024 Finding F2, now that both targets exist.

---

## Business Reason

`catalog_values.tenant_id`/`created_by` were created as plain nullable uuid columns in migration 2 because `tenants` (migration 4) and `users` (migration 5) did not yet exist. Both are now live. The FKs must exist before Migration 19 so the `tenant_id` column RLS depends on has referential integrity (`35`, Future Compatibility).

---

## Risks

Very low (two FK additions on nullable columns). Existing seeded rows have `tenant_id`/`created_by` null (system rows), so no constraint violation on apply. Referential Action Standard: `on delete restrict on update no action`.

---

## Supersedes / Depends On

Depends On: `SPEC-023` (catalog_values), `SPEC-029` (tenants), `SPEC-032` (users), `SPEC-049` (seeded system rows) — Complete. Closes SPEC-024 Finding F2.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607043200_add_catalog_values_deferred_fks.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; any later migration ; seed data

---

## Minimum Reading List

- supabase/migrations/202607041300_create_system_catalog_tables.sql (deferred-FK note)
- _ORVION_CANONICAL/30_database_conventions.md (Referential Action Standard)

---

## Implementation Steps

1. Create `supabase/migrations/202607043200_add_catalog_values_deferred_fks.sql` adding `catalog_values_tenant_id_fkey` (`tenant_id → tenants(id)`) and `catalog_values_created_by_fkey` (`created_by → users(id)`), both `on delete restrict on update no action`.

---

## Acceptance Criteria

- [x] `supabase/migrations/202607043200_add_catalog_values_deferred_fks.sql` exists.
- [x] `npx supabase db reset` applies every migration on a clean database with no error (seed rows do not violate the new FKs).
- [x] Both FKs exist on `catalog_values` with `restrict`/`no action`.
- [x] Inserting a `catalog_values` row with an unknown `tenant_id` is rejected.

---

## Execution Log

### 2026-07-06 — Claude (Tier 2 execution)

Outcome: Complete

Step results:
- Step 1: Applied — created the ALTER migration; `npx supabase db reset` applied all 20 migrations cleanly, seed rows intact.

Database Audit: both FKs present on `catalog_values`, `confdeltype='r'`/`confupdtype='a'`, targeting `tenants`/`users`. Behavioral: a `catalog_values` insert with an unknown `tenant_id` rejected (foreign key).

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: The two FKs implement SPEC-024 Finding F2 exactly; nullable columns, so the 395 seeded system rows (tenant_id/created_by null) remain valid — confirmed by a clean reset. Referential Action Standard upheld. FK enforced behaviorally. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Closes SPEC-024 Finding F2 and the corresponding Future-Backlog line. This is the last deferred DDL before Migration 19. The `catalog_values` tenant-uniqueness constraint (tenant-scoped) remains a separate, deferred backlog item (trigger: tenant-extension feature) and is unaffected here.
