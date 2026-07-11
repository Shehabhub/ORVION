-- pgTAP invariant: tenant-isolation RLS coverage (ARB finding DC-16 / V5 latent trap).
-- Catalog-driven: every application table with a NOT NULL tenant_id must have both
-- row-level security enabled AND at least one policy. No table names are hard-coded, so
-- the invariant holds automatically as new tenant tables are added.
create extension if not exists pgtap with schema extensions;

begin;
select plan(2);

select is(
  (select count(*)::int
     from pg_class c
     join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relkind = 'r'
      and c.relrowsecurity = false
      and exists (
        select 1 from information_schema.columns col
         where col.table_schema = 'public'
           and col.table_name = c.relname
           and col.column_name = 'tenant_id'
           and col.is_nullable = 'NO')),
  0,
  'Every NOT NULL tenant_id table has row-level security enabled');

select is(
  (select count(*)::int
     from information_schema.columns col
    where col.table_schema = 'public'
      and col.column_name = 'tenant_id'
      and col.is_nullable = 'NO'
      and not exists (
        select 1 from pg_policies pp
         where pp.schemaname = 'public'
           and pp.tablename = col.table_name)),
  0,
  'Every NOT NULL tenant_id table has at least one RLS policy');

select * from finish();
rollback;
