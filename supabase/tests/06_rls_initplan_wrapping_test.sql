-- pgTAP invariant: RLS policies wrap app.current_tenant_id() in a scalar subquery (ARB A1).
-- Wrapping hoists the resolver to an InitPlan (evaluated once per query, not per row). This guard
-- keeps the performance pattern in place as new policies are added; semantics are unchanged.
create extension if not exists pgtap with schema extensions;

begin;
select plan(1);

select is(
  (select count(*)::int
     from pg_policies
    where schemaname = 'public'
      and (coalesce(qual, '') || coalesce(with_check, '')) ilike '%current_tenant_id%'
      and (coalesce(qual, '') || coalesce(with_check, '')) not ilike '%select app.current_tenant_id()%'),
  0,
  'Every RLS policy referencing app.current_tenant_id() wraps it in a scalar subquery (InitPlan)');

select * from finish();
rollback;
