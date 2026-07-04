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
