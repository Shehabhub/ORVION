-- Migration: grant_authenticated_access_and_memberships
-- Phase 3 (Identity & Access) first slice, Supabase-native architecture (ADR-0014).
-- RLS (migration 19) is the row-scoping layer but sits on top of table privileges; the authenticated
-- role holds no DML yet. This migration grants DML to authenticated (RLS enforces which rows) and adds
-- the membership-resolution RPC that wires Supabase Auth to app.current_tenant_id().
-- Grant model (derived from existing canon):
--   * tenant-owned + auth-support + catalog_values + tenants: SELECT, INSERT, UPDATE (no DELETE -
--     archive-not-delete convention; catalog values are deactivated not deleted per 25).
--   * global/reference config tables: SELECT only (platform-managed via service_role).
--   * events/security_events: SELECT, INSERT only (append-only; RLS + immutability trigger enforce).
--   * anon: nothing (login required).

-- Global/reference tables: read-only for authenticated.
do $$
declare r text;
begin
  foreach r in array array[
    'catalog_types','countries','currencies','feature_entitlements','languages',
    'nationalities','permissions','role_permissions','roles','subscription_plans'
  ]
  loop
    execute format('grant select on public.%I to authenticated', r);
  end loop;
end
$$;

-- Append-only audit tables: select + insert only.
grant select, insert on public.events to authenticated;
grant select, insert on public.security_events to authenticated;

-- Everything else (tenant-owned tables, tenants, catalog_values, auth-support tables):
-- SELECT, INSERT, UPDATE. RLS scopes rows; DELETE is intentionally withheld (archive-not-delete).
do $$
declare r record;
begin
  for r in
    select c.relname
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relkind = 'r'
      and c.relname not in (
        'catalog_types','countries','currencies','feature_entitlements','languages',
        'nationalities','permissions','role_permissions','roles','subscription_plans',
        'events','security_events'
      )
  loop
    execute format('grant select, insert, update on public.%I to authenticated', r.relname);
  end loop;
end
$$;

-- Membership resolution RPC: lists the calling human's memberships across tenants (for login and
-- tenant selection). SECURITY DEFINER so it reads across tenants (bypassing per-tenant RLS on users);
-- returns only the caller's own memberships. Exposed via PostgREST to authenticated.
create or replace function app.my_memberships()
returns table (membership_id uuid, tenant_id uuid, tenant_name text, is_active boolean)
language sql
stable
security definer
set search_path = ''
as $$
  select u.id, u.tenant_id, t.name, u.is_active
  from public.users u
  join public.tenants t on t.id = u.tenant_id
  where u.auth_user_id = (select auth.uid())
  order by t.name
$$;
grant execute on function app.my_memberships() to authenticated;
