-- pgTAP invariant: tenant_id index coverage (canon 30 Index Standard; ARB finding A2).
-- Every RLS policy filters by tenant_id, so every NOT-NULL-tenant_id table must have an index
-- whose leading column is tenant_id. Catalog-driven; guards against the A2 gap ever recurring.
create extension if not exists pgtap with schema extensions;

begin;
select plan(1);

select is(
  (select count(*)::int
     from pg_class c
     join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relkind = 'r'
      and exists (
        select 1 from information_schema.columns col
         where col.table_schema = 'public'
           and col.table_name = c.relname
           and col.column_name = 'tenant_id'
           and col.is_nullable = 'NO')
      and not exists (
        select 1
          from pg_index i
          join pg_attribute a on a.attrelid = i.indrelid and a.attnum = i.indkey[0]
         where i.indrelid = c.oid
           and a.attname = 'tenant_id')),
  0,
  'Every NOT NULL tenant_id table has an index with tenant_id as the leading column');

select * from finish();
rollback;
