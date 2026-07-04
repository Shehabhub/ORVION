-- Migration: create_system_catalog_tables
-- Plan reference: 33_sql_migration_plan.md migration 2
-- Creates the system catalog tables (catalog_types, catalog_values) per
-- 31_schema_draft.md section 1 and 30_database_conventions.md (Primary Key,
-- Catalog, Unique Constraint, Boolean Naming, and Timestamp Standards).
--
-- Deferred foreign keys (targets do not exist yet; added by a later migration):
--   catalog_values.tenant_id   -> tenants(id)  (tenants created in migration 4)
--   catalog_values.created_by  -> users(id)    (users created in migration 5)
-- These are created here as plain nullable uuid columns, without constraints.
--
-- catalog_values.catalog_type_code is intentionally a plain code column with no FK to
-- catalog_types: no canonical document requires enforcing it as a database foreign key,
-- consistent with how 31_schema_draft.md marks currency_code as a FK but leaves
-- catalog_type_code (and event_type_code) as plain code columns. See Finding F1.

create table catalog_types (
    id uuid primary key default gen_random_uuid(),
    code text not null unique,
    name text not null,
    ownership_type text,
    description text,
    is_active boolean not null default true
);

create table catalog_values (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid,
    catalog_type_code text not null,
    code text not null,
    label text not null,
    description text,
    sort_order integer not null default 0,
    is_active boolean not null default true,
    is_system boolean not null default false,
    created_by uuid,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint catalog_values_type_code_key unique (catalog_type_code, code)
);

create index catalog_values_tenant_id_idx on catalog_values (tenant_id);
