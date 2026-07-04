-- Migration: create_crm_core_tables
-- Plan reference: 33_sql_migration_plan.md migration 8
-- CRM core (customers + detail tables, leads + detail tables) per 31 section 3 and 30.
-- customers before leads (leads.customer_id nullable). preferred_language_code is a real FK to
-- languages(code) (SPEC-037). Other type/status/source codes are plain text (SPEC-030).
-- Archive fields on customers/customer_notes/leads. All FKs restrict/no action.

create table customers (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    customer_type_code text not null,
    first_name text,
    family_name text,
    full_name text not null,
    company_name text,
    primary_phone text,
    primary_email text,
    preferred_language_code text references languages (code) on delete restrict on update no action,
    preferred_contact_method_code text,
    marketing_opt_in boolean not null default false,
    first_registered_branch_id uuid references branches (id) on delete restrict on update no action,
    last_interaction_branch_id uuid references branches (id) on delete restrict on update no action,
    last_interaction_user_id uuid references users (id) on delete restrict on update no action,
    last_interaction_at timestamptz,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text
);

create table customer_contact_methods (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    customer_id uuid not null references customers (id) on delete restrict on update no action,
    contact_method_type_code text not null,
    value text not null,
    is_primary boolean not null default false,
    is_verified boolean not null default false,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table customer_identity_signals (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    customer_id uuid not null references customers (id) on delete restrict on update no action,
    signal_type_code text not null,
    signal_value text not null,
    source_entity_type text,
    source_entity_id uuid,
    created_at timestamptz not null default now()
);

create table customer_identity_merges (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    source_customer_id uuid not null references customers (id) on delete restrict on update no action,
    target_customer_id uuid not null references customers (id) on delete restrict on update no action,
    merged_by uuid references users (id) on delete restrict on update no action,
    reason text,
    created_at timestamptz not null default now()
);

create table customer_notes (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    customer_id uuid not null references customers (id) on delete restrict on update no action,
    note_text text not null,
    is_pinned boolean not null default false,
    is_confidential boolean not null default false,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text
);

create table leads (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    branch_id uuid not null references branches (id) on delete restrict on update no action,
    department_id uuid not null references departments (id) on delete restrict on update no action,
    owner_user_id uuid references users (id) on delete restrict on update no action,
    owner_department_id uuid references departments (id) on delete restrict on update no action,
    owner_branch_id uuid references branches (id) on delete restrict on update no action,
    lead_source_code text not null,
    lead_status_code text not null,
    priority_code text,
    closure_reason_code text,
    customer_id uuid references customers (id) on delete restrict on update no action,
    assigned_user_id uuid references users (id) on delete restrict on update no action,
    title text not null,
    requested_service_type_code text,
    expected_value numeric(14, 2),
    next_follow_up_at timestamptz,
    last_contact_at timestamptz,
    customer_phone_snapshot text,
    customer_name_snapshot text,
    source_payload jsonb,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    closed_at timestamptz,
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text
);

create table lead_assignments (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    lead_id uuid not null references leads (id) on delete restrict on update no action,
    assigned_user_id uuid not null references users (id) on delete restrict on update no action,
    assigned_by uuid references users (id) on delete restrict on update no action,
    assigned_at timestamptz not null default now(),
    unassigned_at timestamptz,
    assignment_reason text,
    is_current boolean not null default true
);

create table lead_interactions (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    lead_id uuid not null references leads (id) on delete restrict on update no action,
    user_id uuid references users (id) on delete restrict on update no action,
    interaction_type_code text not null,
    interaction_at timestamptz not null default now(),
    summary text,
    metadata jsonb,
    created_at timestamptz not null default now()
);

-- Indexes (30 Index Standard: FKs, tenant filtering, status, assignment queues, dedup).
create index customers_tenant_phone_idx on customers (tenant_id, primary_phone);
create index customer_contact_methods_customer_id_idx on customer_contact_methods (customer_id);
create index customer_identity_signals_customer_id_idx on customer_identity_signals (customer_id);
create index customer_identity_merges_source_idx on customer_identity_merges (source_customer_id);
create index customer_identity_merges_target_idx on customer_identity_merges (target_customer_id);
create index customer_notes_customer_id_idx on customer_notes (customer_id);
create index leads_tenant_status_idx on leads (tenant_id, lead_status_code);
create index leads_tenant_assigned_user_idx on leads (tenant_id, assigned_user_id);
create index leads_customer_id_idx on leads (customer_id);
create index leads_branch_id_idx on leads (branch_id);
create index lead_assignments_lead_id_idx on lead_assignments (lead_id);
create index lead_interactions_lead_id_idx on lead_interactions (lead_id);

-- updated_at triggers (only tables with an updated_at column).
create trigger customers_set_updated_at before update on customers for each row execute function moddatetime(updated_at);
create trigger customer_contact_methods_set_updated_at before update on customer_contact_methods for each row execute function moddatetime(updated_at);
create trigger customer_notes_set_updated_at before update on customer_notes for each row execute function moddatetime(updated_at);
create trigger leads_set_updated_at before update on leads for each row execute function moddatetime(updated_at);
