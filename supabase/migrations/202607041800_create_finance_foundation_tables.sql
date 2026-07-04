-- Migration: create_finance_foundation_tables
-- Plan reference: 33_sql_migration_plan.md migration 6
-- Creates exchange_rates, chart_of_accounts, financial_accounts per 31_schema_draft.md
-- section 5 and 30_database_conventions.md. currency_code columns are real foreign keys to
-- currencies.code (Money Standard). account_type / financial_account_type_code are plain
-- text (SPEC-030). Money precision: numeric(18,8) rates, numeric(14,2) balances.
-- exchange_rates has no updated_at (rates are immutable snapshots) -> no trigger.

create table exchange_rates (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    from_currency_code text not null references currencies (code) on delete restrict on update no action,
    to_currency_code text not null references currencies (code) on delete restrict on update no action,
    rate numeric(18, 8) not null,
    effective_at timestamptz not null,
    set_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now()
);

create table chart_of_accounts (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    code text not null,
    name text not null,
    parent_account_id uuid references chart_of_accounts (id) on delete restrict on update no action,
    account_type text not null,
    is_system_default boolean not null default false,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table financial_accounts (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    financial_account_type_code text not null,
    name text not null,
    currency_code text not null references currencies (code) on delete restrict on update no action,
    opening_balance numeric(14, 2) not null default 0,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

-- Indexes (30 Index Standard: foreign keys, tenant filtering).
create index exchange_rates_tenant_id_idx on exchange_rates (tenant_id);
create index chart_of_accounts_tenant_id_idx on chart_of_accounts (tenant_id);
create index chart_of_accounts_parent_account_id_idx on chart_of_accounts (parent_account_id);
create index financial_accounts_tenant_id_idx on financial_accounts (tenant_id);

-- updated_at triggers (exchange_rates excluded -- immutable rate snapshots, no updated_at).
create trigger chart_of_accounts_set_updated_at
    before update on chart_of_accounts
    for each row execute function moddatetime(updated_at);

create trigger financial_accounts_set_updated_at
    before update on financial_accounts
    for each row execute function moddatetime(updated_at);
