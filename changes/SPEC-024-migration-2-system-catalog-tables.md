# Change Request — SPEC-024

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word (for example
"Ready", "Implemented", or "Rejected") anywhere in a Change Request.

---

## Assigned Model Tier

Mark one:

[ ] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Create migration 2, `create_system_catalog_tables`, defining the `catalog_types` and `catalog_values` tables per `31_schema_draft.md` section 1 and `30_database_conventions.md`.

---

## Business Reason

`33_sql_migration_plan.md` migration 2 (`NN_create_system_catalog_tables.sql`) is the next dependency-ready unit after migration 1. These two tables are foundational: `30_database_conventions.md`'s Status Standard makes `catalog_values(catalog_type_code, code)` the composite reference target for every status/type code column across the schema, so `catalog_values` must exist before the business tables that reference it (the first is `tenants.status` at migration 4). This Change Request creates the structure only; catalog *data* is seeded separately at migration 18 (`33` migration 18), and is out of scope here.

---

## Risks

Low. Two new tables, no data, and no enforced foreign keys at all in this migration. Two conventionally-expected backward foreign keys (`tenant_id` → `tenants`, `created_by` → `users`) cannot be created yet and are deliberately deferred (see Finding F2); this is the documented resolution of the `catalog_values` backward-reference discovery, consistent with `33`'s "No dependencies on business tables" note for migration 2. The `catalog_type_code`/`catalog_types` relationship is left as a logical code reference, not a database FK, per the F1 verification (no canonical document requires enforcing it). Physical nullability/default choices not fixed by the canonical documents are recorded in Notes.

---

## Supersedes / Depends On

Depends On: `changes/SPEC-022-enable-extensions-migration.md` (Complete) — migration 1 provides `pgcrypto` for `gen_random_uuid()`.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607041300_create_system_catalog_tables.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** (all canonical documents are read-only for this task)
- supabase/config.toml
- supabase/migrations/202607041200_enable_extensions.sql (migration 1 is complete and untouched)
- Any other migration file (migrations 3+ are not authored here)
- Catalog seed data (migration 18 per `33`) — structure only in this Change Request

---

## Minimum Reading List

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/33_sql_migration_plan.md

---

## Implementation Steps

1. Verification check: determine whether any file matching `supabase/migrations/*_create_system_catalog_tables.sql` already exists. If one exists, record this step as Already Applied and make no change. If none exists, create the file `supabase/migrations/202607041300_create_system_catalog_tables.sql` with exactly the following content and nothing else:

```sql
-- Migration: create_system_catalog_tables
-- Plan reference: 33_sql_migration_plan.md migration 2
-- Creates the system catalog tables (catalog_types, catalog_values) per
-- 31_schema_draft.md section 1 and 30_database_conventions.md (Primary Key,
-- Catalog, Unique Constraint, Boolean Naming, and Timestamp Standards).
--
-- Deferred foreign keys (targets do not exist yet; added by a later migration):
--   catalog_values.tenant_id   -> tenants(id)  (tenants created in migration 4)
--   catalog_values.created_by  -> users(id)    (users created in migration 5)
-- These are created here as plain nullable uuid columns, without constraints.
--
-- catalog_values.catalog_type_code is intentionally a plain code column with no FK to
-- catalog_types: no canonical document requires enforcing it as a database foreign key,
-- consistent with how 31_schema_draft.md marks currency_code as a FK but leaves
-- catalog_type_code (and event_type_code) as plain code columns. See Finding F1.

create table catalog_types (
    id uuid primary key default gen_random_uuid(),
    code text not null unique,
    name text not null,
    ownership_type text,
    description text,
    is_active boolean not null default true
);

create table catalog_values (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid,
    catalog_type_code text not null,
    code text not null,
    label text not null,
    description text,
    sort_order integer not null default 0,
    is_active boolean not null default true,
    is_system boolean not null default false,
    created_by uuid,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint catalog_values_type_code_key unique (catalog_type_code, code)
);

create index catalog_values_tenant_id_idx on catalog_values (tenant_id);
```

---

## Acceptance Criteria

- [ ] A single file `supabase/migrations/202607041300_create_system_catalog_tables.sql` exists with exactly the content specified in Step 1.
- [ ] `npx supabase db reset` applies all migrations (1 and 2) on a clean local database with no error.
- [ ] After reset, both `public.catalog_types` and `public.catalog_values` exist (`select to_regclass('public.catalog_types'), to_regclass('public.catalog_values');` returns two non-null values).
- [ ] `catalog_types.code` has a UNIQUE constraint.
- [ ] `catalog_values` has a UNIQUE constraint on `(catalog_type_code, code)` (per `30_database_conventions.md` Catalog values uniqueness requirement).
- [ ] `catalog_values` has NO foreign key constraints in this migration (verifiable via `pg_constraint`): `catalog_type_code` is a plain code column (Finding F1), and `tenant_id`/`created_by` are deferred (Finding F2).
- [ ] An index exists on `catalog_values(tenant_id)`.

---

## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request, before
IMPLEMENT is considered complete, per synchronization as defined in AGENTS.md's Agent Handoff
Protocol — this file is always implicitly in scope for this section.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]

### <YYYY-MM-DD HH:MM> — <agent identifier>

Outcome: Complete | Blocked | Failed

Step results:
- Step 1: Already Applied | Applied | Failed — <one-line reason>

Commits: <commit hash(es) for this run>

Blocker: <only present if Outcome is Blocked or Failed. One factual paragraph describing
exactly which verification check produced an unanticipated result and where. Do not propose
or apply a guessed resolution.>

---

## Verification Notes

[Appended by the reviewing agent (Tier 1) after independently re-checking the Execution Log
against the live repository state. Append-only — never edit or delete a prior entry.]

### <YYYY-MM-DD HH:MM> — <agent identifier>

Verdict: Confirmed Complete | Discrepancy Found | Needs Corrective Change Request

Findings: <what was independently re-checked, and what was found>

Recommendation to human: Set Status to Complete | Set Status to Cancelled | Approve corrective
Change Request `changes/SPEC-00N-*.md`

---

## Review Gate

[Human-completed. Do not mark Status as Complete until every item below is checked.]

- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as
      Already Applied per its verification check.
- [ ] No file outside the Scope list was modified or created.
- [ ] No section was added, removed, or restructured outside the approved steps.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] Any step that could not be resolved deterministically was reported, not guessed.
- [ ] If this Change Request's Supersedes / Depends On section names another file, that file's
      Status has been updated accordingly.
- [ ] The repository is in a clean, releasable state.

---

## Notes

Physical realization decisions not fixed by the canonical documents (recorded so they are reviewable, not assumed silently):
- `ownership_type` (catalog_types): nullable `text` — `30`'s Catalog Standard qualifies ownership type as "where applicable," implying optionality; no enumerated value set exists in evidence (see Finding F5).
- `description` (both tables): nullable `text`.
- `sort_order` (catalog_values): `integer not null default 0`.
- `is_active` / `is_system`: `boolean not null`, defaults `true` / `false` respectively (`30` Boolean Naming Standard).
- `created_at` / `updated_at` (catalog_values): `timestamptz not null default now()` (`30` Timestamp Standard). `catalog_types` has no timestamp columns — see Finding F3.
- `tenant_id`, `created_by` (catalog_values): nullable `uuid`, no FK — deferred (Finding F2).
- `catalog_type_code` (catalog_values): `text not null`, no FK — logical code reference only, per the F1 verification (Finding F1).

The composite UNIQUE `(catalog_type_code, code)` is implemented exactly as `30_database_conventions.md` mandates to support the schema-wide composite status-FK pattern. `catalog_types.code` is UNIQUE on independent grounds (`30` Unique Constraint Standard lists "catalog code" as business uniqueness), not to serve as a foreign-key target.

---

## Findings

Documented separately from implementation, per the drafting instruction. None is Blocking; SPEC-024 proceeds as drafted.

- **F1 — RESOLVED: no `catalog_type_code` foreign key.** A repository-wide verification found that no canonical document requires `catalog_values.catalog_type_code → catalog_types.code` to be enforced as a database foreign key, explicitly or implicitly: `29_relationship_map.md` and `24_entity_registry.md` do not mention catalogs; the only enforced catalog relationship the canon requires is business tables → `catalog_values(catalog_type_code, code)` (`30` line 226) plus the composite UNIQUE on `catalog_values` (`30` line 260); and `31_schema_draft.md` marks `currency_code` as a FK explicitly (line 357) while leaving `catalog_type_code` a plain column — the same treatment as `event_type_code`. `30` line 222 states the intent is code-based coupling "without introducing tight per-catalog table definitions." The FK is therefore not introduced. `catalog_type_code` is `text not null` with no FK; `catalog_types` remains a valid registry with a UNIQUE `code` on business-uniqueness grounds. **Classification: Nice to Have** (an optional integrity enhancement a future canonical decision could add, not a current requirement).
- **F2 — Deferred backward foreign keys.** `catalog_values.tenant_id` (→ `tenants`, migration 4) and `catalog_values.created_by` (→ `users`, migration 5) cannot be enforced at migration 2. They are created as plain nullable `uuid` columns here. To restore referential integrity once the targets exist, a small future Change Request should add both constraints via `ALTER TABLE catalog_values ADD CONSTRAINT ...` after migration 5. **Classification: Required Soon.** (Smallest future CR: "add deferred catalog_values foreign keys," scoped to one new migration file.)
- **F3 — `catalog_types` has no `created_at`/`updated_at`.** `30`'s Timestamp Standard says main tables "should" include them, but the frozen `31_schema_draft.md` §1 omits them for `catalog_types`. This CR follows the frozen schema (authoritative table spec) and does not add columns. If timestamps are wanted on `catalog_types`, reconcile `30` and `31` in a separate canonical-documentation Change Request. **Classification: Nice to Have.**
- **F4 — Global vs per-tenant catalog-code uniqueness.** `30` mandates a global UNIQUE on `(catalog_type_code, code)` (required for the composite status-FK), yet `25`/`30` also allow tenant-specific catalog values (`tenant_id` set). Global uniqueness prevents two tenants — or a tenant and the system — from reusing the same `(type, code)`. This is already baked into `30` and flagged by `31` §13 item 2 ("requires careful constraints"); it is implemented as mandated. If per-tenant code reuse ever becomes a requirement, the composite-FK strategy needs governance review — not resolvable inside a migration. **Classification: Independent.**
- **F5 — `ownership_type` has no backing catalog or enumerated values.** Created as free `text`. Analogous to `events.event_type_code` (see `33` "Recommended (Non-Blocking)"), it does not require a catalog to be correct DDL. **Classification: Nice to Have.**
