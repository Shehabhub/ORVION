# Change Request — SPEC-039

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

Create migration 9, `create_suppliers_and_passengers_tables`, defining `suppliers` and `passengers` per `31_schema_draft.md` section 4 and `30_database_conventions.md`.

---

## Business Reason

`33` migration 9 creates `suppliers` and `passengers`, both needed by Booking (migration 10). `passengers.nationality_code` → `nationalities` and `passport_issuing_country_code` → `countries` use the reference data layer (SPEC-037). Structure only.

---

## Risks

Low. Two tables; prerequisites live (`tenants`, `branches`, `departments`, `users`, `customers`, `nationalities`, `countries`). Type codes plain text (SPEC-030); `credit_limit_amount numeric(14,2)`; `passengers` enforces the `31` passport issue-before-expiry rule via a CHECK. Physical choices in Notes.

---

## Supersedes / Depends On

Depends On: `SPEC-029` (tenants/branches/departments), `SPEC-032` (users), `SPEC-038` (customers), `SPEC-037` (nationalities/countries), `SPEC-028` (moddatetime) — all Complete.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607042200_create_suppliers_and_passengers_tables.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; any later migration ; seed data

---

## Minimum Reading List

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/33_sql_migration_plan.md

---

## Implementation Steps

1. Verification check: if any file matches `supabase/migrations/*_create_suppliers_and_passengers_tables.sql`, record Already Applied. Otherwise create `supabase/migrations/202607042200_create_suppliers_and_passengers_tables.sql` with exactly:

```sql
-- Migration: create_suppliers_and_passengers_tables
-- Plan reference: 33_sql_migration_plan.md migration 9
-- Creates suppliers and passengers per 31 section 4 and 30. passengers.nationality_code ->
-- nationalities and passport_issuing_country_code -> countries (reference data layer, SPEC-037).
-- Type codes plain text (SPEC-030). Money: credit_limit_amount numeric(14,2). passengers
-- enforces passport_issue_date < passport_expiry_date (31 Rule). Archive fields on both.

create table suppliers (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    supplier_type_code text not null,
    name text not null,
    phone text,
    email text,
    payment_term_code text,
    credit_limit_amount numeric(14, 2),
    is_internal boolean not null default false,
    internal_branch_id uuid references branches (id) on delete restrict on update no action,
    internal_department_id uuid references departments (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text
);

create table passengers (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    customer_id uuid references customers (id) on delete restrict on update no action,
    first_name text not null,
    family_name text not null,
    full_name text not null,
    passenger_type_code text not null,
    relationship_to_customer_code text,
    date_of_birth date,
    nationality_code text references nationalities (code) on delete restrict on update no action,
    passport_number text,
    passport_issue_date date,
    passport_expiry_date date,
    visa_number text,
    visa_issue_date date,
    visa_expiry_date date,
    passport_issuing_country_code text references countries (code) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text,
    constraint passengers_passport_dates_check check (
        passport_issue_date is null or passport_expiry_date is null
        or passport_issue_date < passport_expiry_date
    )
);

-- Indexes (30 Index Standard + 31 expiry-search indexes).
create index suppliers_tenant_id_idx on suppliers (tenant_id);
create index passengers_tenant_id_idx on passengers (tenant_id);
create index passengers_customer_id_idx on passengers (customer_id);
create index passengers_passport_expiry_idx on passengers (passport_expiry_date);
create index passengers_visa_expiry_idx on passengers (visa_expiry_date);

-- updated_at triggers.
create trigger suppliers_set_updated_at before update on suppliers for each row execute function moddatetime(updated_at);
create trigger passengers_set_updated_at before update on passengers for each row execute function moddatetime(updated_at);
```

---

## Acceptance Criteria

- [ ] `supabase/migrations/202607042200_create_suppliers_and_passengers_tables.sql` exists with exactly the Step 1 content.
- [ ] `npx supabase db reset` applies every migration on a clean database with no error.
- [ ] `suppliers` and `passengers` exist.
- [ ] `passengers.nationality_code` → `nationalities(code)` and `passengers.passport_issuing_country_code` → `countries(code)`; all foreign keys `restrict`/`no action`; no FK on any type code column.
- [ ] The `passengers_passport_dates_check` CHECK constraint exists.
- [ ] `updated_at` triggers exist on both tables; `passport_expiry_date` and `visa_expiry_date` indexes exist.
- [ ] Behavioral (rolled back): a passenger with `passport_issue_date` after `passport_expiry_date` is rejected.

---

## Execution Log

### 2026-07-05 01:52 — Claude Code (Opus 4.8), IMPLEMENT

Outcome: Complete

Step results:
- Step 1: Applied — created `supabase/migrations/202607042200_create_suppliers_and_passengers_tables.sql`.

Verification (clean `db reset`): both tables exist; `passengers.nationality_code` → `nationalities`, `passport_issuing_country_code` → `countries`; `passengers_passport_dates_check` present and enforced (a passport issue date after expiry was rejected); 0 non-restrict FKs; 2 `updated_at` triggers; passport/visa expiry indexes present.

Commits: this Implement commit.

---

## Verification Notes

### 2026-07-05 01:54 — Claude Code (Opus 4.8), REVIEW

Verdict: Confirmed Complete

Findings: Re-verified against a fresh `db reset` and live schema. Both tables exist; passengers' `nationality_code`→`nationalities` and `passport_issuing_country_code`→`countries` FKs present; `passengers_passport_dates_check` present (behavioral pass: issue-after-expiry rejected); 0 non-restrict FKs; 2 `updated_at` triggers; passport/visa expiry indexes present. Scope: only the migration file and this Change Request changed.

Recommendation to human: Set Status to Complete.

---

## Review Gate

- [ ] Every change matches the Implementation Steps.
- [ ] No file outside Scope was modified.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] The repository is in a clean, releasable state.

---

## Notes

Physical decisions: `passengers` first_name/family_name/full_name NOT NULL (per `31`, unlike `customers`); `credit_limit_amount numeric(14,2)`; date fields `date`; `is_internal` default false. Only the passport issue-before-expiry rule is enforced (a visa-date CHECK is implied but not stated in `31`; surfaced as Recommended, not added).
