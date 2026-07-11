-- Migration: rls_initplan_wrapping
-- Plan reference: ARB finding A1 (MASTER_EXECUTION_PLAN Batch 1); Supabase RLS performance guidance.
--
-- Every RLS policy filters on app.current_tenant_id(). Called unwrapped, Postgres evaluates the
-- function PER ROW; wrapped as a scalar subquery `(select app.current_tenant_id())` it is hoisted
-- to an InitPlan and evaluated ONCE per query. This is a pure performance change: `x = f()` and
-- `x = (select f())` are identical as filters (a scalar subquery yields the same value), so tenant
-- isolation semantics are preserved exactly — only the evaluation strategy changes.
--
-- Rewrites in place, driven by the catalog, so every policy that references the resolver is covered
-- (tenant_isolation, tenant_self, catalog_*, audit_*) regardless of its individual expression shape.

do $$
declare
  r record;
  stmt text;
begin
  for r in
    select pol.polname,
           c.relname,
           pg_get_expr(pol.polqual, pol.polrelid)      as qual,
           pg_get_expr(pol.polwithcheck, pol.polrelid) as wcheck
      from pg_policy pol
      join pg_class c on c.oid = pol.polrelid
      join pg_namespace n on n.oid = c.relnamespace
     where n.nspname = 'public'
       and ( pg_get_expr(pol.polqual, pol.polrelid)      like '%app.current_tenant_id()%'
          or pg_get_expr(pol.polwithcheck, pol.polrelid) like '%app.current_tenant_id()%' )
  loop
    stmt := format('alter policy %I on public.%I', r.polname, r.relname);
    if r.qual is not null then
      stmt := stmt || format(' using (%s)',
        replace(r.qual, 'app.current_tenant_id()', '(select app.current_tenant_id())'));
    end if;
    if r.wcheck is not null then
      stmt := stmt || format(' with check (%s)',
        replace(r.wcheck, 'app.current_tenant_id()', '(select app.current_tenant_id())'));
    end if;
    execute stmt;
  end loop;
end $$;
