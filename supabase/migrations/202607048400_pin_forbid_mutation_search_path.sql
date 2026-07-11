-- Migration: pin_forbid_mutation_search_path
-- Plan reference: CODING_STANDARDS.md (every function pins search_path); AGENTS.md §5 RPC conventions.
--
-- app.forbid_mutation() — the append-only audit guard (defined in 202607043300) — was the one
-- app function created without a pinned search_path. Body is unchanged (identical exception);
-- this only adds `set search_path = ''` to bring it into line with the other 54 app functions
-- and remove the mutable-search_path hardening gap. Additive create-or-replace; the existing
-- triggers on events / security_events are unaffected.

create or replace function app.forbid_mutation()
  returns trigger
  language plpgsql
  set search_path = ''
as $$
begin
  raise exception 'append-only table: % is not permitted on %', tg_op, tg_table_name;
end
$$;
