# Change Request — SPEC-037

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word (for example
"Ready", "Implemented", or "Rejected") anywhere in a Change Request.

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

[ ] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

Note: this Change Request amends the frozen schema (`31`) and the migration plan (`33`) as well as adding a migration; it requires judgment about the canonical additions, so Tier 1.

---

## Objective

Add the reference data layer approved as Option A: define `countries`, `languages`, and `nationalities` as natural-key reference tables in `31_schema_draft.md` section 2a, record their migration in `33_sql_migration_plan.md`, and create the structure migration — so migrations 8–10 can reference them by foreign key.

---

## Business Reason

Migrations 8–10 introduce `preferred_language_code`, `nationality_code`, `passport_issuing_country_code`, and `destination_country_code`. The owner approved Option A (dedicated reference tables) over plain text, for consistency with the existing `currencies` reference table (SPEC-025), alignment with `25_catalog_registry.md`'s guidance (which recommends reference tables and forbids storing this data in `catalog_values`), and the travel domain's reliance on standardized country/nationality/language data for reporting, deduplication, and integrations. Deciding and building this before migration 8 avoids retrofitting foreign keys onto populated customer/passenger/booking data. Structure only — the reference rows (ISO datasets) are seeded later, exactly as `currencies` is.

---

## Risks

Low. Three new global reference tables (no `tenant_id`, like `currencies`), a documentation amendment to `31`/`33`, and one migration. No existing table or migration is changed. The foreign keys that will reference these tables are added in migrations 8–10, not here; the tables are created empty and seeded later, so nothing depends on their contents yet.

---

## Supersedes / Depends On

Depends On: `SPEC-025` (currencies reference-table precedent) and `SPEC-028` (moddatetime, for the `updated_at` triggers) — both Complete.

---

## Scope — Files Allowed to Modify

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/33_sql_migration_plan.md
- supabase/migrations/202607042000_create_geo_reference_tables.sql

---

## Out of Scope — Files Forbidden to Modify

- All other `_ORVION_CANONICAL/**` documents ; supabase/config.toml ; any existing migration
- Seed data for the reference tables (deferred, like `currencies`)
- `cities` / `airports` reference tables (deferred until a column requires them)
- The migration-8 foreign keys (added in migration 8's own Change Request)

---

## Minimum Reading List

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/33_sql_migration_plan.md
- _ORVION_CANONICAL/30_database_conventions.md

---

## Implementation Steps

1. In `31_schema_draft.md`, add three reference-table definitions to section 2a by replacing the section-3 heading line `# 3. CRM Tables` with the three table definitions followed by that heading. Replace:

`# 3. CRM Tables`

with:

`## countries

Purpose:

Canonical country reference used by every country code column (for example `destination_country_code`, `passport_issuing_country_code`).

Core fields:

- code
- name
- is_active
- created_at
- updated_at

Unique:

- code

## languages

Purpose:

Canonical language reference used by every language code column (for example `preferred_language_code`).

Core fields:

- code
- name
- is_active
- created_at
- updated_at

Unique:

- code

## nationalities

Purpose:

Canonical nationality reference used by every nationality code column (for example `nationality_code`).

Core fields:

- code
- name
- is_active
- created_at
- updated_at

Unique:

- code

---

# 3. CRM Tables`

2. In `33_sql_migration_plan.md`, record the inserted reference-data migration. Replace the line:

`| 3 | `NN_create_reference_tables.sql` | `currencies` | 1 | No dependencies. |`

with:

`| 3 | `NN_create_reference_tables.sql` | `currencies` | 1 | No dependencies. |
| 3b | `NN_create_geo_reference_tables.sql` | `countries`, `languages`, `nationalities` | 1 | Reference data layer (SPEC-037), inserted before migration 8 (CRM core); natural-key tables like `currencies`, seeded later. |`

3. Verification check: if any file matches `supabase/migrations/*_create_geo_reference_tables.sql`, record Already Applied. Otherwise create `supabase/migrations/202607042000_create_geo_reference_tables.sql` with exactly:

```sql
-- Migration: create_geo_reference_tables
-- Plan reference: 33_sql_migration_plan.md migration 3b (SPEC-037, reference data layer)
-- Creates countries, languages, nationalities as natural-key reference tables per
-- 31_schema_draft.md section 2a, following the currencies pattern. Global reference data
-- (no tenant_id); seeded later. Every code column in later migrations references these.

create table countries (
    code text primary key,
    name text not null,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table languages (
    code text primary key,
    name text not null,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table nationalities (
    code text primary key,
    name text not null,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create trigger countries_set_updated_at
    before update on countries
    for each row execute function moddatetime(updated_at);

create trigger languages_set_updated_at
    before update on languages
    for each row execute function moddatetime(updated_at);

create trigger nationalities_set_updated_at
    before update on nationalities
    for each row execute function moddatetime(updated_at);
```

---

## Acceptance Criteria

- [ ] `31_schema_draft.md` section 2a defines `countries`, `languages`, and `nationalities` (natural-key `code`, `name`, `is_active`, timestamps) before `# 3. CRM Tables`.
- [ ] `33_sql_migration_plan.md` records the `create_geo_reference_tables` migration (row 3b).
- [ ] `supabase/migrations/202607042000_create_geo_reference_tables.sql` exists with exactly the Step 3 content.
- [ ] `npx supabase db reset` applies every migration on a clean database with no error.
- [ ] `countries`, `languages`, `nationalities` exist, each with `code` as PRIMARY KEY (type `text`) and an `updated_at` trigger.
- [ ] No foreign key references these tables yet (they are added in migration 8+).

---

## Execution Log

### 2026-07-05 01:29 — Claude Code (Opus 4.8), IMPLEMENT

Outcome: Complete

Step results:
- Step 1: Applied — `31_schema_draft.md` section 2a now defines `countries`, `languages`, `nationalities` (natural-key, minimal columns) before `# 3. CRM Tables`.
- Step 2: Applied — `33_sql_migration_plan.md` records the `create_geo_reference_tables` migration (row 3b).
- Step 3: Applied — created `supabase/migrations/202607042000_create_geo_reference_tables.sql` with the three tables + `updated_at` triggers.

Verification (clean `db reset`, Postgres 17): the three tables exist, each `PRIMARY KEY (code)` on `text`; three `updated_at` triggers; zero foreign keys reference them yet (added in migrations 8+); `31` has the three definitions and `33` has row 3b.

Commits: this Implement commit (amends `31` + `33`, adds the migration). No other document or migration changed.

---

## Verification Notes

### 2026-07-05 01:32 — Claude Code (Opus 4.8), REVIEW

Verdict: Confirmed Complete

Findings: Re-verified independently against a fresh `db reset` and the live documents.
- `countries`, `languages`, `nationalities` exist, each with a `PRIMARY KEY (code)` and an `updated_at` trigger (3 tables / 3 PKs / 3 triggers).
- Zero foreign keys reference these tables yet (added in migrations 8+).
- `31_schema_draft.md` section 2a contains all three definitions; `33_sql_migration_plan.md` records the `create_geo_reference_tables` migration (row 3b).
- Scope: `git show --stat 79527ea` — only `31`, `33`, the migration file, and this Change Request changed.

Recommendation to human: Set Status to Complete.

---

## Review Gate

- [ ] Every change matches the Implementation Steps.
- [ ] No file outside Scope was modified.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] The repository is in a clean, releasable state.

---

## Notes

The three tables mirror the `currencies` reference-table design (natural-key `code`, minimal columns). Enrichment columns (country phone code, default currency, region; language/nationality metadata) and the `cities`/`airports` reference tables are deferred to the Future Backlog. Seed data (ISO 3166 countries, ISO 639 languages, nationality list) is a later seed migration, alongside the `currencies` seed. Migration 8 adds `customers.preferred_language_code -> languages(code)`; migrations 9–10 add the country/nationality foreign keys.
