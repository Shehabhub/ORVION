-- Migration: create_identity_and_access_tables
-- Plan reference: 33_sql_migration_plan.md migration 5
-- Creates identity and RBAC tables per 31_schema_draft.md section 2 and
-- 30_database_conventions.md.
--
-- Key decisions (see SPEC-032 Findings):
--  * users.auth_user_id is nullable (SPEC-031) with ON DELETE SET NULL: if the backing
--    auth.users identity is deleted, the ORVION user survives, unlinked (re-invitable) --
--    a deliberate SPEC-027 set-null opt-in, not the restrict default.
--  * users is a tenant membership (SPEC-033): tenant_id is NOT NULL (platform staff belong
--    to a designated platform tenant), and auth_user_id is unique PER TENANT
--    (unique (tenant_id, auth_user_id)) -- one human (auth.users) may hold a membership in
--    several tenants, each a separate users row. Not globally unique.
--  * roles/permissions are global (no tenant_id); assignments are tenant-scoped.
--  * Status/type codes (transfer_type_code, scope_type) are plain text (SPEC-030).
--  * Only users has updated_at (and its moddatetime trigger); roles/permissions have no
--    timestamps and the assignment/mapping tables have created_at only, per 31.

create table roles (
    id uuid primary key default gen_random_uuid(),
    code text not null unique,
    name text not null,
    description text,
    is_system boolean not null default false,
    is_active boolean not null default true
);

create table permissions (
    id uuid primary key default gen_random_uuid(),
    key text not null unique,
    name text not null,
    description text,
    is_system boolean not null default false,
    is_active boolean not null default true
);

create table role_permissions (
    id uuid primary key default gen_random_uuid(),
    role_id uuid not null references roles (id) on delete restrict on update no action,
    permission_id uuid not null references permissions (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    constraint role_permissions_role_permission_key unique (role_id, permission_id)
);

create table users (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    auth_user_id uuid references auth.users (id) on delete set null on update no action,
    full_name text not null,
    phone text,
    email text not null,
    is_active boolean not null default true,
    is_platform_user boolean not null default false,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint users_tenant_email_key unique (tenant_id, email),
    constraint users_tenant_auth_key unique (tenant_id, auth_user_id)
);

create table user_branch_assignments (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    user_id uuid not null references users (id) on delete restrict on update no action,
    branch_id uuid not null references branches (id) on delete restrict on update no action,
    department_id uuid references departments (id) on delete restrict on update no action,
    transfer_type_code text,
    starts_at timestamptz not null default now(),
    ends_at timestamptz,
    is_primary boolean not null default false,
    reason text,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now()
);

create table user_role_assignments (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    user_id uuid not null references users (id) on delete restrict on update no action,
    role_id uuid not null references roles (id) on delete restrict on update no action,
    scope_type text not null,
    branch_id uuid references branches (id) on delete restrict on update no action,
    department_id uuid references departments (id) on delete restrict on update no action,
    starts_at timestamptz not null default now(),
    ends_at timestamptz,
    is_active boolean not null default true,
    assigned_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now()
);

-- One current primary branch per user (03_company_structure.md: "Each employee belongs
-- to one primary branch"): partial unique over current (not-ended) primary assignments.
create unique index user_branch_assignments_one_primary_idx
    on user_branch_assignments (tenant_id, user_id)
    where is_primary and ends_at is null;

-- Indexes (30 Index Standard: foreign keys, tenant filtering). users(tenant_id) is
-- covered by the unique (tenant_id, email) index.
create index user_branch_assignments_user_id_idx on user_branch_assignments (user_id);
create index user_branch_assignments_branch_id_idx on user_branch_assignments (branch_id);
create index user_role_assignments_user_id_idx on user_role_assignments (user_id);
create index user_role_assignments_role_id_idx on user_role_assignments (role_id);

-- updated_at maintenance (only users has updated_at).
create trigger users_set_updated_at
    before update on users
    for each row execute function moddatetime(updated_at);
