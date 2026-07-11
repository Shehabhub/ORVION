-- pgTAP invariant: every app.* function pins search_path (CODING_STANDARDS; AGENTS §5).
-- A function with a mutable search_path can resolve unqualified names against attacker-controlled
-- schemas. Catalog-driven guard so no future app function ships without a pinned search_path.
create extension if not exists pgtap with schema extensions;

begin;
select plan(1);

select is(
  (select count(*)::int
     from pg_proc p
     join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'app'
      and p.prokind = 'f'
      and not exists (
        select 1 from unnest(coalesce(p.proconfig, '{}')) cfg
         where cfg like 'search_path=%')),
  0,
  'Every app.* function pins search_path');

select * from finish();
rollback;
