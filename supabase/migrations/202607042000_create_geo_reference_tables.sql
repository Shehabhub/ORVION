-- Migration: create_geo_reference_tables
-- Plan reference: 33_sql_migration_plan.md migration 3b (SPEC-037, reference data layer)
-- Creates countries, languages, nationalities as natural-key reference tables per
-- 31_schema_draft.md section 2a, following the currencies pattern. Global reference data
-- (no tenant_id); seeded later. Every code column in later migrations references these.

create table countries (
    code text primary key,
    name text not null,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table languages (
    code text primary key,
    name text not null,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table nationalities (
    code text primary key,
    name text not null,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create trigger countries_set_updated_at
    before update on countries
    for each row execute function moddatetime(updated_at);

create trigger languages_set_updated_at
    before update on languages
    for each row execute function moddatetime(updated_at);

create trigger nationalities_set_updated_at
    before update on nationalities
    for each row execute function moddatetime(updated_at);
