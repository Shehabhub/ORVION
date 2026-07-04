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
