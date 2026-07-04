-- Migration: create_reference_tables
-- Plan reference: 33_sql_migration_plan.md migration 3
-- Creates the currencies reference table per 31_schema_draft.md section 2a and
-- 30_database_conventions.md (Money Standard, Boolean Naming, Timestamp Standards).
--
-- currencies is a reference table keyed by its natural code (ISO currency code): per
-- 31_schema_draft.md section 2a it has no surrogate uuid id, and every currency_code
-- column elsewhere in the schema references currencies(code). See Finding F1.

create table currencies (
    code text primary key,
    name text not null,
    symbol text,
    decimal_places smallint not null default 2,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);
