# Change Request — SPEC-025

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
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

Create migration 3, `create_reference_tables`, defining the `currencies` reference table per `31_schema_draft.md` section 2a and `30_database_conventions.md`.

---

## Business Reason

`33_sql_migration_plan.md` migration 3 (`NN_create_reference_tables.sql`) is the next dependency-ready unit after migration 2. `currencies` is the canonical, validated currency list that every `currency_code` column elsewhere in the schema references (`31_schema_draft.md` section 2a; `30_database_conventions.md` Money Standard). Creating it early — it has no dependencies of its own — lets later migrations that carry `currency_code` columns (from migration 6 onward) reference it. This Change Request creates the structure only; currency seed data (EGP, SAR, USD) is not part of it.

---

## Risks

Very low. One new table, no data, no foreign keys (it is a root reference table), and no dependency on any other table. `currencies` uses no `gen_random_uuid()` default — its primary key is the natural currency `code` — so it does not even depend functionally on migration 1's `pgcrypto`, though it is sequenced after it per `33`. Physical choices not fixed by the canonical documents (the `decimal_places` type and default) are recorded in Notes.

---

## Supersedes / Depends On

Depends On: `changes/SPEC-022-enable-extensions-migration.md` and `changes/SPEC-024-migration-2-system-catalog-tables.md` (both Complete) — the prior migrations in the sequence. This migration adds no foreign key to either.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607041400_create_reference_tables.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** (all canonical documents are read-only for this task)
- supabase/config.toml
- supabase/migrations/202607041200_enable_extensions.sql (migration 1, complete)
- supabase/migrations/202607041300_create_system_catalog_tables.sql (migration 2, complete)
- Any other migration file (migrations 4+ are not authored here)
- Currency seed data (structure only in this Change Request)

---

## Minimum Reading List

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/33_sql_migration_plan.md

---

## Implementation Steps

1. Verification check: determine whether any file matching `supabase/migrations/*_create_reference_tables.sql` already exists. If one exists, record this step as Already Applied and make no change. If none exists, create the file `supabase/migrations/202607041400_create_reference_tables.sql` with exactly the following content and nothing else:

```sql
-- Migration: create_reference_tables
-- Plan reference: 33_sql_migration_plan.md migration 3
-- Creates the currencies reference table per 31_schema_draft.md section 2a and
-- 30_database_conventions.md (Money Standard, Boolean Naming, Timestamp Standards).
--
-- currencies is a reference table keyed by its natural code (ISO currency code): per
-- 31_schema_draft.md section 2a it has no surrogate uuid id, and every currency_code
-- column elsewhere in the schema references currencies(code). See Finding F1.

create table currencies (
    code text primary key,
    name text not null,
    symbol text,
    decimal_places smallint not null default 2,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);
```

---

## Acceptance Criteria

- [ ] A single file `supabase/migrations/202607041400_create_reference_tables.sql` exists with exactly the content specified in Step 1.
- [ ] `npx supabase db reset` applies all migrations (1, 2, and 3) on a clean local database with no error.
- [ ] After reset, `public.currencies` exists (`select to_regclass('public.currencies');` returns a non-null value).
- [ ] `currencies` has a PRIMARY KEY on `code`, and `code` is of type `text`.
- [ ] `currencies` has columns `name`, `symbol`, `decimal_places`, `is_active`, `created_at`, `updated_at` with the types/nullability specified in Step 1.
- [ ] `currencies` has no foreign key constraints (verifiable via `pg_constraint`: no row with `contype = 'f'`).

---

## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request, before
IMPLEMENT is considered complete, per synchronization as defined in AGENTS.md's Agent Handoff
Protocol — this file is always implicitly in scope for this section.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]

### 2026-07-04 12:35 — Claude Code (Opus 4.8), IMPLEMENT

Outcome: Complete

Step results:
- Step 1: Applied — no file matched `supabase/migrations/*_create_reference_tables.sql`; created `supabase/migrations/202607041400_create_reference_tables.sql` with exactly the specified content.

Verification against Acceptance Criteria (local Supabase stack, Postgres 17):
- File exists at the scoped path with the specified content — confirmed.
- `npx supabase db reset` applied migrations 1, 2, and 3 on a clean database with no error — confirmed.
- `select to_regclass('public.currencies');` returned `currencies` — confirmed.
- PRIMARY KEY is on `code`, type `text` (`pg_constraint`: `PRIMARY KEY (code)`) — confirmed.
- Columns and nullability: `code text NOT NULL`, `name text NOT NULL`, `symbol text NULL`, `decimal_places smallint NOT NULL`, `is_active boolean NOT NULL`, `created_at`/`updated_at timestamptz NOT NULL` — confirmed via information_schema.
- No foreign key constraints on `currencies` (`pg_constraint contype='f'` count = 0) — confirmed.

Commits: this Implement commit, which adds `supabase/migrations/202607041400_create_reference_tables.sql` and synchronizes this Change Request. No other migration and no canonical document was changed.

---

## Verification Notes

[Appended by the reviewing agent (Tier 1) after independently re-checking the Execution Log
against the live repository state. Append-only — never edit or delete a prior entry.]

### 2026-07-04 12:38 — Claude Code (Opus 4.8), REVIEW

Verdict: Confirmed Complete

Findings: Every Acceptance Criterion and Review Gate item was re-checked independently against live repository and database state, not against the Execution Log.
- File content: `supabase/migrations/202607041400_create_reference_tables.sql` matches Step 1 exactly, including `code text primary key` and no `references` clause (natural-key design, F1).
- Clean apply: an independent `npx supabase db reset` applied migrations 1, 2, and 3 with no error.
- `currencies` exists (`to_regclass` returned `currencies`).
- PRIMARY KEY is `PRIMARY KEY (code)`; `code` is `text`.
- Foreign keys on `currencies`: count = 0.
- Columns/nullability: `code`/`name`/`decimal_places`/`is_active`/`created_at`/`updated_at` NOT NULL, `symbol` nullable — matches the spec.
- Review Gate — scope: `git show --stat a9c094c` confirms the Implement commit touched only the migration file and this Change Request; no canonical document, no other migration. Supersedes/Depends On (`SPEC-022`, `SPEC-024`) both Complete. Working tree releasable.

Recommendation to human: Set Status to Complete.

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
- `code`: `text primary key` — the natural key per `31_schema_draft.md` section 2a (see Finding F1).
- `symbol`: nullable `text` (`31` marks it "nullable").
- `decimal_places`: `smallint not null default 2` — `smallint` is sufficient for a decimal-place count; the default `2` matches `30`'s Money Standard note that `numeric(14, 2)` is the safe default for the documented currencies (EGP, SAR, USD). A currency with a different scale sets this explicitly.
- `name`: `text not null`.
- `is_active`: `boolean not null default true` (`30` Boolean Naming Standard).
- `created_at` / `updated_at`: `timestamptz not null default now()` (`30` Timestamp Standard).
- No `created_by`/`updated_by`: `30`'s Actor Standard is "where useful"; reference data has no meaningful actor, and `31` section 2a omits them.

---

## Findings

Documented separately from implementation, per the drafting convention. None is Blocking; SPEC-025 proceeds as drafted.

- **F1 — `currencies` uses a natural-key primary key (`code`), not the `id uuid` Primary Key Standard.** `30_database_conventions.md`'s Primary Key Standard says "Every main table uses `id uuid primary key default gen_random_uuid()`," but `31_schema_draft.md` section 2a defines `currencies` with no `id` column, `Unique: code`, and the note that every `currency_code` column references `currencies.code`. This CR follows the frozen schema: `code` is the primary key and the foreign-key target. This is a deliberate reference-table design (a small, stable, externally-meaningful ISO code set), not a defect — consistent with `25_catalog_registry.md`'s guidance to use dedicated reference tables for stable public datasets. If desired, `30` could be clarified to state that reference tables key on their natural code; that is a canonical-documentation change, out of scope here. **Classification: Nice to Have.**
