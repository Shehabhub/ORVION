-- Migration: create_subscription_tables
-- Plan reference: 33_sql_migration_plan.md migration 14
-- Creates subscription_plans, feature_entitlements, subscriptions, subscription_payment_proofs,
-- usage_counters per 31 section 8 and 30. subscription_plans/feature_entitlements are global
-- platform catalog rows (no tenant_id). subscription_payment_proofs.document_id -> documents
-- (migration 7). Status/plan/feature/metric codes plain text (SPEC-030). period_start/period_end are
-- date (no _at suffix); used_value/limit_value numeric per 31. updated_at triggers on subscriptions
-- and usage_counters only.

create table subscription_plans (
    id uuid primary key default gen_random_uuid(),
    plan_code text not null,
    name text not null,
    description text,
    is_active boolean not null default true,
    created_at timestamptz not null default now()
);

create table feature_entitlements (
    id uuid primary key default gen_random_uuid(),
    subscription_plan_id uuid not null references subscription_plans (id) on delete restrict on update no action,
    feature_code text not null,
    is_enabled boolean not null default false,
    limit_value numeric,
    created_at timestamptz not null default now()
);

create table subscriptions (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    subscription_plan_id uuid not null references subscription_plans (id) on delete restrict on update no action,
    subscription_status_code text not null,
    starts_at timestamptz not null default now(),
    ends_at timestamptz,
    grace_ends_at timestamptz,
    read_only_started_at timestamptz,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table subscription_payment_proofs (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    subscription_id uuid not null references subscriptions (id) on delete restrict on update no action,
    document_id uuid not null references documents (id) on delete restrict on update no action,
    uploaded_by uuid references users (id) on delete restrict on update no action,
    reviewed_by uuid references users (id) on delete restrict on update no action,
    uploaded_at timestamptz not null default now(),
    reviewed_at timestamptz,
    status_code text not null,
    review_notes text
);

create table usage_counters (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    usage_metric_code text not null,
    period_start date not null,
    period_end date not null,
    used_value numeric not null default 0,
    limit_value numeric,
    updated_at timestamptz not null default now()
);

-- Indexes (30 Index Standard: FKs, tenant filtering, status).
create index feature_entitlements_plan_id_idx on feature_entitlements (subscription_plan_id);
create index subscriptions_tenant_status_idx on subscriptions (tenant_id, subscription_status_code);
create index subscriptions_plan_id_idx on subscriptions (subscription_plan_id);
create index subscription_payment_proofs_subscription_id_idx on subscription_payment_proofs (subscription_id);
create index subscription_payment_proofs_document_id_idx on subscription_payment_proofs (document_id);
create index subscription_payment_proofs_tenant_id_idx on subscription_payment_proofs (tenant_id);
create index usage_counters_tenant_metric_idx on usage_counters (tenant_id, usage_metric_code);

-- updated_at triggers (subscriptions, usage_counters have updated_at).
create trigger subscriptions_set_updated_at before update on subscriptions for each row execute function moddatetime(updated_at);
create trigger usage_counters_set_updated_at before update on usage_counters for each row execute function moddatetime(updated_at);
