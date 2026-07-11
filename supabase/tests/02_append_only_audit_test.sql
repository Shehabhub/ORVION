-- pgTAP invariant: append-only audit backbone (ARB finding DC-16).
-- The immutable event/audit tables must carry the app.forbid_mutation() trigger so history
-- cannot be updated or deleted. Regression guard for the append-only guarantee.
create extension if not exists pgtap with schema extensions;

begin;
select plan(2);

select is(
  (select count(*)::int
     from (values ('events'), ('security_events')) as req(t)
    where not exists (
      select 1
        from pg_trigger tg
        join pg_class c on c.oid = tg.tgrelid
        join pg_proc p on p.oid = tg.tgfoid
        join pg_namespace n on n.oid = c.relnamespace
       where n.nspname = 'public'
         and c.relname = req.t
         and p.proname = 'forbid_mutation'
         and not tg.tgisinternal)),
  0,
  'Append-only backbone tables (events, security_events) carry a forbid_mutation trigger');

select is(
  (select count(*)::int from pg_proc where proname = 'forbid_mutation'),
  1,
  'The app.forbid_mutation() immutability function exists');

select * from finish();
rollback;
