# Change Request — SPEC-022

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

Mark one:

[ ] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Create the first ORVION SQL migration, `enable_extensions`, which enables the `pgcrypto` extension required before any table using `gen_random_uuid()` is created.

---

## Business Reason

`33_sql_migration_plan.md` migration 1 is `NN_enable_extensions.sql`, marked "Required before any `gen_random_uuid()` default." `30_database_conventions.md`'s Primary Key Standard mandates `id uuid primary key default gen_random_uuid()` and instructs: "Ensure the database enables the `pgcrypto` extension in migrations before creating tables." This Change Request produces that first migration so every subsequent table migration can rely on the extension being present on a genuinely clean database. It is the first executable step of SQL Engineering with no open blockers (`33`'s `# Blocked Items` reads "None currently").

---

## Risks

Minimal. The migration is a single idempotent statement (`create extension if not exists pgcrypto`). On the local Supabase stack pgcrypto is pre-installed, so the statement is a no-op there; its value is reproducibility on a clean database that is not Supabase-preseeded. No table, constraint, or data is created. The only material risk is filename-convention drift (see Notes), which does not affect execution.

---

## Supersedes / Depends On

None.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607041200_enable_extensions.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** (all canonical documents, including 33_sql_migration_plan.md and 30_database_conventions.md — read-only for this task)
- supabase/config.toml
- scripts/repository-all.ps1
- Any other file under supabase/migrations/ (no other migration is authored by this Change Request)

---

## Minimum Reading List

- _ORVION_CANONICAL/33_sql_migration_plan.md
- _ORVION_CANONICAL/30_database_conventions.md

---

## Implementation Steps

1. Verification check: determine whether any file matching `supabase/migrations/*_enable_extensions.sql` already exists. If one exists, record this step as Already Applied and make no change. If none exists, create the file `supabase/migrations/202607041200_enable_extensions.sql` with exactly the following content and nothing else:

```sql
-- Migration: enable_extensions
-- Plan reference: 33_sql_migration_plan.md migration 1
-- Enables pgcrypto so gen_random_uuid() is available before any table is created
-- (30_database_conventions.md, Primary Key Standard).

create extension if not exists pgcrypto;
```

---

## Acceptance Criteria

- [ ] A single file `supabase/migrations/202607041200_enable_extensions.sql` exists.
- [ ] Its content is exactly the SQL block specified in Step 1 (a header comment and one `create extension if not exists pgcrypto;` statement), with no additional statements.
- [ ] `npx supabase db reset` applies the full migrations directory against a clean local database with no error.
- [ ] After reset, `pgcrypto` is present (verifiable via `select 1 from pg_extension where extname = 'pgcrypto';` returning one row).

---

## Execution Log

### 2026-07-04 10:08 — Claude Code (Opus 4.8), IMPLEMENT

Outcome: Complete

Step results:
- Step 1: Applied — no file matched `supabase/migrations/*_enable_extensions.sql`; created `supabase/migrations/202607041200_enable_extensions.sql` with exactly the specified content (header comment + `create extension if not exists pgcrypto;`).

Verification against Acceptance Criteria (local Supabase stack, Postgres 17):
- File exists at the scoped path — confirmed.
- Content matches Step 1 exactly, single statement — confirmed.
- `npx supabase db reset` applied all migrations on a clean database with no error; log showed `Applying migration 202607041200_enable_extensions.sql...` and `NOTICE (42710): extension "pgcrypto" already exists, skipping` (expected idempotent no-op on the Supabase-preseeded image) — confirmed.
- `select extname from pg_extension where extname = 'pgcrypto';` returned one row (`pgcrypto`) — confirmed.

Commits: this Implement commit, which adds `supabase/migrations/202607041200_enable_extensions.sql` and synchronizes this Change Request.

Note: the local database required Docker Desktop to be started during this run; the stack was brought up and `db reset` completed successfully. No Scope deviation.

---

## Verification Notes

### 2026-07-04 10:12 — Claude Code (Opus 4.8), REVIEW

Verdict: Confirmed Complete

Findings: Every Acceptance Criterion and Review Gate item was re-checked independently against live repository and database state, not against the Execution Log's self-report.
- AC1 (file exists): `supabase/migrations/202607041200_enable_extensions.sql` present at the scoped path — confirmed.
- AC2 (exact content): file contains only the specified header comment and a single `create extension if not exists pgcrypto;` statement — confirmed (one `create extension`, one `;`, no other statements).
- AC3 (applies on clean DB): an independent `npx supabase db reset` re-applied the migration on a fresh database and reported `Finished supabase db reset` with no error.
- AC4 (pgcrypto present): direct query `select extname, extversion from pg_extension where extname='pgcrypto';` returned `pgcrypto | 1.3`.
- Review Gate — scope: `git show --stat 67ce571` confirms the Implement commit touched only the two scoped files (the migration file and this Change Request); no out-of-scope or canonical file was modified. Supersedes/Depends On is None (n/a). Working tree is releasable (only untracked tooling artifacts remain, outside this Change Request's Scope).

The `NOTICE ... "pgcrypto" already exists, skipping` message is the expected idempotent no-op on the Supabase-preseeded image and is not a defect; `create extension if not exists` is correct for reproducibility on a non-preseeded clean database.

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

Filename convention: `30_database_conventions.md`'s Migration Rule specifies `YYYYMMDDHHMM_description.sql` (12-digit prefix; its own example `202606271700_create_core_identity_tables.sql` is 12-digit). This Change Request follows that canonical convention. Note that `npx supabase migration new` generates a 14-digit `YYYYMMDDHHMMSS` prefix by default; the file is therefore authored by hand to honor `30` rather than generated by the CLI. This divergence is recorded as an observation for possible future reconciliation, not resolved here.
