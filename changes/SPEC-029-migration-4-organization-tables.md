# Change Request — SPEC-029

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

Create migration 4, `create_organization_tables`, defining `tenants`, `branches`, `departments`, `branch_business_hours`, and `holidays` per `31_schema_draft.md` section 2 and `30_database_conventions.md`.

---

## Business Reason

`33_sql_migration_plan.md` migration 4 is the next dependency-ready unit and the first with real foreign keys. `tenants` is the tenant-isolation root that nearly every later table references; `branches`/`departments` establish the operational hierarchy; `branch_business_hours`/`holidays` support SLA and operational planning. This migration applies `30`'s new Referential Action Standard (SPEC-027) to its foreign keys and adds a per-table `updated_at` trigger using the mechanism enabled by SPEC-028. Structure only — no seed data.

---

## Risks

Low–moderate. Five new tables with foreign keys, indexes, and triggers; no data. All prerequisites are in place (verified): `pgcrypto` (mig 1), `currencies` (mig 3, for `tenants.default_currency_code`), and `moddatetime` (SPEC-028, for triggers). No dependency on `users` (mig 5) — these tables have no actor columns. Status/type-code columns are plain `text` with no `catalog_values` foreign key (see Findings F1); this is the only notable deviation from a naive reading of `30`'s Status Standard and is deliberate and precedented. Physical choices not fixed by the canonical documents are recorded in Notes.

---

## Supersedes / Depends On

Depends On: `changes/SPEC-022-enable-extensions-migration.md`, `changes/SPEC-025-migration-3-reference-tables.md`, and `changes/SPEC-028-updated-at-triggers-retrofit.md` (all Complete) — respectively `pgcrypto`, `currencies`, and the `moddatetime` mechanism.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607041600_create_organization_tables.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** (all canonical documents are read-only for this task)
- supabase/config.toml
- Any existing migration file (migrations 1–3 and the SPEC-028 retrofit are complete)
- Any later migration (migration 5+ is not authored here)
- Seed data (structure only in this Change Request)

---

## Minimum Reading List

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/33_sql_migration_plan.md

---

## Implementation Steps

1. Verification check: determine whether any file matching `supabase/migrations/*_create_organization_tables.sql` already exists. If one exists, record this step as Already Applied and make no change. If none exists, create the file `supabase/migrations/202607041600_create_organization_tables.sql` with exactly the following content and nothing else:

```sql
-- Migration: create_organization_tables
-- Plan reference: 33_sql_migration_plan.md migration 4
-- Creates the organization tables (tenants, branches, departments,
-- branch_business_hours, holidays) per 31_schema_draft.md section 2 and
-- 30_database_conventions.md. tenants is the tenant-isolation root.
--
-- Referential actions follow 30's Referential Action Standard: on delete restrict
-- on update no action. updated_at is maintained by moddatetime triggers (30 Timestamp
-- Standard; extension enabled by the SPEC-028 retrofit).
--
-- Status/type-code columns (tenants.status, branches.branch_type,
-- departments.department_type_code) are plain text with no catalog_values foreign key,
-- per 30_database_conventions.md's resolved Status Standard (SPEC-030): status/type
-- codes are plain text validated by the seeded catalog plus application/state-machine
-- logic; families are registered in 25_catalog_registry.md; database enforcement is
-- optional per-column and not used here.

create table tenants (
    id uuid primary key default gen_random_uuid(),
    name text not null,
    slug text not null unique,
    legal_name text,
    primary_phone text,
    primary_email text,
    default_currency_code text references currencies (code) on delete restrict on update no action,
    status text not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table branches (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    name text not null,
    slug text not null,
    branch_type text,
    primary_phone text,
    address text,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint branches_tenant_slug_key unique (tenant_id, slug)
);

create table departments (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    branch_id uuid not null references branches (id) on delete restrict on update no action,
    department_type_code text not null,
    name text not null,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table branch_business_hours (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    branch_id uuid not null references branches (id) on delete restrict on update no action,
    day_of_week smallint not null,
    opens_at time,
    closes_at time,
    is_closed boolean not null default false,
    notes text,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table holidays (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    branch_id uuid references branches (id) on delete restrict on update no action,
    name text not null,
    holiday_date date not null,
    is_recurring boolean not null default false,
    description text,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

-- Indexes (30 Index Standard: foreign keys, tenant filtering).
-- branches(tenant_id) is already covered by the unique (tenant_id, slug) index.
create index departments_tenant_id_idx on departments (tenant_id);
create index departments_branch_id_idx on departments (branch_id);
create index branch_business_hours_branch_id_idx on branch_business_hours (branch_id);
create index holidays_tenant_id_holiday_date_idx on holidays (tenant_id, holiday_date);
create index holidays_branch_id_idx on holidays (branch_id);

-- updated_at maintenance triggers (30 Timestamp Standard).
create trigger tenants_set_updated_at
    before update on tenants
    for each row execute function moddatetime(updated_at);

create trigger branches_set_updated_at
    before update on branches
    for each row execute function moddatetime(updated_at);

create trigger departments_set_updated_at
    before update on departments
    for each row execute function moddatetime(updated_at);

create trigger branch_business_hours_set_updated_at
    before update on branch_business_hours
    for each row execute function moddatetime(updated_at);

create trigger holidays_set_updated_at
    before update on holidays
    for each row execute function moddatetime(updated_at);
```

---

## Acceptance Criteria

- [ ] A single file `supabase/migrations/202607041600_create_organization_tables.sql` exists with exactly the content specified in Step 1.
- [ ] `npx supabase db reset` applies every migration (1, 2, 3, the SPEC-028 retrofit, and this one) on a clean local database with no error.
- [ ] After reset, all five tables exist: `tenants`, `branches`, `departments`, `branch_business_hours`, `holidays`.
- [ ] Foreign keys exist with `ON DELETE RESTRICT` / `ON UPDATE NO ACTION`: `branches.tenant_id`, `departments.tenant_id`, `departments.branch_id`, `branch_business_hours.tenant_id`, `branch_business_hours.branch_id`, `holidays.tenant_id`, `holidays.branch_id`, and `tenants.default_currency_code` → `currencies(code)`.
- [ ] Unique constraints exist: `tenants.slug`, and `branches(tenant_id, slug)`.
- [ ] No foreign key exists on any status/type-code column (`tenants.status`, `branches.branch_type`, `departments.department_type_code`) — they are plain `text` (Finding F1).
- [ ] A `before update` `..._set_updated_at` trigger exists on each of the five tables.
- [ ] The six indexes listed in Step 1 exist.
- [ ] Functional check (rolled-back): updating a `tenants` row advances `updated_at` (trigger fires); no test data persists.

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

Physical realization decisions not fixed by the canonical documents (recorded, not assumed silently):
- Nullability: `tenants` — `name`/`slug`/`status` NOT NULL, `legal_name`/`primary_phone`/`primary_email`/`default_currency_code` nullable. `branches` — `tenant_id`/`name`/`slug` NOT NULL, `branch_type`/`primary_phone`/`address` nullable. `departments` — `tenant_id`/`branch_id`/`department_type_code`/`name` NOT NULL. `branch_business_hours` — `tenant_id`/`branch_id`/`day_of_week` NOT NULL, `opens_at`/`closes_at`/`notes` nullable. `holidays` — `tenant_id`/`name`/`holiday_date` NOT NULL, `branch_id`/`description` nullable.
- `tenants.status`: `text NOT NULL`, **no default** — a default would invent a catalog value; the caller/seed supplies it.
- Booleans: `is_active` default true; `is_closed`/`is_recurring` default false (`30` Boolean Naming Standard).
- Types: `day_of_week smallint` (encoding undefined — Finding F3); `opens_at`/`closes_at` `time`; `holiday_date` `date`.
- `default_currency_code` is the only within-migration FK to an existing external table (`currencies`, mig 3).

Trigger naming follows `<table>_set_updated_at` per `30`'s Timestamp Standard example.

---

## Findings

- **F1 — RESOLVED by SPEC-030 (Complete).** The composite status/type-code FK question (a single column cannot reference `catalog_values`' composite `(catalog_type_code, code)` key) has been resolved canonically in `30`'s Status Standard: status/type codes are plain `text`, validated by the seeded catalog plus application/state-machine logic, with database enforcement optional per-column. `tenants.status`, `branches.branch_type`, and `departments.department_type_code` are plain `text` with no FK here, which **already complies** with the resolved standard. **Classification: Informational** (no open question remains).
- **F2 — `branch_business_hours` has no `unique(branch_id, day_of_week)`.** Business logic implies one hours row per branch per weekday, but `31` does not state it, so it is not added here. **Classification: Recommended.** May be approved for inclusion in this migration or a follow-up.
- **F3 — `day_of_week` encoding and CHECK undefined.** `31` gives no encoding (0–6 vs 1–7) or validity CHECK; created as plain `smallint not null`. **Classification: Recommended.** Define the encoding and add `check (day_of_week between 0 and 6)` (or 1–7) if approved.
- **F4 — No `opens_at < closes_at` CHECK.** Not stated in `31`; omitted. **Classification: Nice to Have.**
- **F5 — Unindexed foreign-key columns.** `branch_business_hours.tenant_id` and `tenants.default_currency_code` are left unindexed; acceptable because their parents are archived-not-deleted (restrict-checks are rare) and access is via branch. **Classification: Informational.**
