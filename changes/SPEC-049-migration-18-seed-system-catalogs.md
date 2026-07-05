# Change Request — SPEC-049

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

Create migration 18, `seed_system_catalogs`, populating `catalog_types` and `catalog_values` with the system catalog codes from `25_catalog_registry.md`. Seed data only, no DDL.

---

## Business Reason

`33` migration 18 seeds the controlled-value knowledge layer. Status/type codes across the schema are plain text validated by the seeded catalog + application logic (SPEC-030/ADR-0006); those codes must exist as `catalog_values` rows.

---

## Risks

Low (idempotent seed, no DDL, no schema change). System rows only (`tenant_id null`, `is_system true`). `on conflict do nothing` on the natural keys makes re-application safe. Scope decisions recorded in Notes (validated in the migration-18 design review as non-blocking defaults).

---

## Supersedes / Depends On

Depends On: `SPEC-023` (catalog_types/catalog_values) — Complete. Reference-data, RBAC, and subscription seeds are separate later migrations.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607043100_seed_system_catalogs.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; any later migration ; any table structure (no DDL)

---

## Minimum Reading List

- _ORVION_CANONICAL/25_catalog_registry.md
- _ORVION_CANONICAL/31_schema_draft.md (section 1: catalog_types/catalog_values)
- _ORVION_CANONICAL/30_database_conventions.md (Catalog/Status standards)

---

## Implementation Steps

1. Create `supabase/migrations/202607043100_seed_system_catalogs.sql` that inserts (a) one `catalog_types` row per system/tenant-extendable catalog family from `25` (ownership per `25`, name = deterministic placeholder), and (b) `catalog_values` rows for each family's codes (system rows: `tenant_id null`, `is_system true`; `label` = `initcap(replace(code,'_',' '))`; `sort_order` = registry order via `unnest … with ordinality`). Both inserts use `on conflict … do nothing` on the natural keys. Exclude dedicated-table codes (role/permission/plan/feature), reference data, deprecated `finance_approval_type`, and consumer-less `functional_role_code`/`cabin_class_code`/`fare_type_code`/`expense_category_code`.

---

## Acceptance Criteria

- [x] `supabase/migrations/202607043100_seed_system_catalogs.sql` exists and contains no DDL.
- [x] `npx supabase db reset` applies every migration on a clean database with no error.
- [x] Every seeded `catalog_values.catalog_type_code` has a matching `catalog_types.code` row.
- [x] All seeded rows are system rows (`tenant_id is null`, `is_system = true`); every `code` is unique within its `catalog_type_code`.
- [x] Re-running the seed (via a second `db reset`) produces identical counts (idempotent).

---

## Execution Log

### 2026-07-05 — Claude (Tier 2 execution)

Outcome: Complete

Step results:
- Step 1: Applied — created the seed migration; `npx supabase db reset` applied all 19 migrations cleanly.

Content audit: 65 `catalog_types` rows; `catalog_values` rows seeded across all 65 families; zero orphan `catalog_type_code` values; all rows `tenant_id null` + `is_system true`; the excluded families (role/permission/plan/feature/reference/deprecated/consumer-less) are absent. Idempotency confirmed: a second `db reset` yields identical row counts.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-05 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Codes cross-checked against `25_catalog_registry.md`. No DDL present (seed only). Every `catalog_values.catalog_type_code` resolves to a seeded `catalog_types.code`. Uniqueness holds within each family. System-only rows. Excluded families verified absent (dedicated tables, reference data, deprecated, consumer-less). Idempotent re-application reproduced identical counts. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Design-validation defaults (all confirmed non-blocking, engineering judgment): (1) `catalog_type_code` values are registry-verbatim; (2) scope = `catalog_types` + `catalog_values` only, system rows; (3) exclusions as listed; (4) idempotency via `on conflict do nothing`; (5) `label`/`name` are deterministic `initcap` placeholders pending localization (`25` §26). No Seed Data Standard document was created — per the earn-it rule it will be generalized once 2–3 seed migrations exist. Deferred and unaffected by this migration: `catalog_values` tenant-uniqueness constraint (trigger: tenant-extension feature); F2 FKs `catalog_values.tenant_id`/`created_by` (DDL; trigger: before RLS migration 19). Both remain in the backlog.
