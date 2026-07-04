-- Migration: enable_extensions
-- Plan reference: 33_sql_migration_plan.md migration 1
-- Enables pgcrypto so gen_random_uuid() is available before any table is created
-- (30_database_conventions.md, Primary Key Standard).

create extension if not exists pgcrypto;
