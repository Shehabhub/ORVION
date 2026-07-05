-- Migration: create_rls_policies
-- Plan reference: 33_sql_migration_plan.md migration 19
-- Derived from 35_tenant_isolation_and_data_access_principles.md. Enables RLS on every public base
-- table and applies policies by category. The single resolution primitive is app.current_tenant_id()
-- (SECURITY DEFINER, in the non-API `app` schema, active-tenant-aware degrading to the single active
-- membership); every tenant policy references it, so the resolution mechanism can evolve in one place.
-- The Supabase service_role bypasses RLS (backend/platform access, Principle 6); anon gets nothing.
-- Categories (Principles 1,3-7): tenant-owned -> isolate by tenant_id; global -> read-all;
-- tenants -> own tenant; auth-support -> row-ownership by auth.uid() (34); catalog_values -> dual read
-- (system rows or own tenant); events/security_events -> append-only (insert + tenant read, no
-- update/delete, backed by an immutability trigger).

create schema if not exists app;
grant usage on schema app to authenticated;

-- Resolution primitive: caller's authorized tenant. SECURITY DEFINER so it reads public.users as the
-- table owner (bypassing users RLS -> no recursion). Reads an optional session active-tenant; if set
-- and the caller is a member there, uses it; else falls back to the single active membership (MVP).
create or replace function app.current_tenant_id()
returns uuid
language sql
stable
security definer
set search_path = ''
as $$
  select u.tenant_id
  from public.users u
  where u.auth_user_id = (select auth.uid())
    and u.is_active
    and (
      nullif(current_setting('app.active_tenant_id', true), '') is null
      or u.tenant_id = nullif(current_setting('app.active_tenant_id', true), '')::uuid
    )
  limit 1
$$;
grant execute on function app.current_tenant_id() to authenticated;

-- Immutability guard for append-only audit tables (defence in depth beyond the absent update/delete
-- policies; blocks the operation for every role including service_role).
create or replace function app.forbid_mutation()
returns trigger
language plpgsql
as $$
begin
  raise exception 'append-only table: % is not permitted on %', tg_op, tg_table_name;
end
$$;

-- 1. Tenant-owned tables (tenant_id NOT NULL): isolate by the resolution primitive.
do $$
declare r record;
begin
  for r in
    select c.relname
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relkind = 'r'
      and (select col.is_nullable
           from information_schema.columns col
           where col.table_schema = 'public' and col.table_name = c.relname
             and col.column_name = 'tenant_id') = 'NO'
  loop
    execute format('alter table public.%I enable row level security', r.relname);
    execute format(
      'create policy tenant_isolation on public.%I for all to authenticated '
      'using (tenant_id = app.current_tenant_id()) '
      'with check (tenant_id = app.current_tenant_id())', r.relname);
  end loop;
end
$$;

-- 2. Global system/reference tables (no tenant_id): read-all for authenticated; writes are platform
--    (service_role) only.
do $$
declare r text;
begin
  foreach r in array array[
    'catalog_types','countries','currencies','feature_entitlements','languages',
    'nationalities','permissions','role_permissions','roles','subscription_plans'
  ]
  loop
    execute format('alter table public.%I enable row level security', r);
    execute format('create policy read_all_authenticated on public.%I for select to authenticated using (true)', r);
  end loop;
end
$$;

-- 3. tenants: a member sees only their own tenant.
alter table public.tenants enable row level security;
create policy tenant_self on public.tenants for all to authenticated
  using (id = app.current_tenant_id())
  with check (id = app.current_tenant_id());

-- 4. Authentication support tables: row-ownership by the human identity (34).
do $$
declare r text;
begin
  foreach r in array array['trusted_devices','otp_challenges','totp_enrollments']
  loop
    execute format('alter table public.%I enable row level security', r);
    execute format(
      'create policy owner_only on public.%I for all to authenticated '
      'using (auth_user_id = (select auth.uid())) '
      'with check (auth_user_id = (select auth.uid()))', r);
  end loop;
end
$$;

-- 5. catalog_values: readable when system row (tenant_id null) or own tenant; tenant rows writable
--    within the tenant; system rows are platform (service_role) only.
alter table public.catalog_values enable row level security;
create policy catalog_read on public.catalog_values for select to authenticated
  using (tenant_id is null or tenant_id = app.current_tenant_id());
create policy catalog_tenant_insert on public.catalog_values for insert to authenticated
  with check (tenant_id = app.current_tenant_id());
create policy catalog_tenant_update on public.catalog_values for update to authenticated
  using (tenant_id = app.current_tenant_id())
  with check (tenant_id = app.current_tenant_id());
create policy catalog_tenant_delete on public.catalog_values for delete to authenticated
  using (tenant_id = app.current_tenant_id());

-- 6. Append-only audit tables: insert + tenant-scoped read; no update/delete policy; immutability
--    trigger for defence in depth. tenant_id null = platform-level rows (service_role only).
do $$
declare r text;
begin
  foreach r in array array['events','security_events']
  loop
    execute format('alter table public.%I enable row level security', r);
    execute format('create policy audit_read on public.%I for select to authenticated using (tenant_id = app.current_tenant_id())', r);
    execute format('create policy audit_insert on public.%I for insert to authenticated with check (tenant_id = app.current_tenant_id())', r);
    execute format('create trigger %I before update or delete on public.%I for each row execute function app.forbid_mutation()', r || '_append_only', r);
  end loop;
end
$$;
