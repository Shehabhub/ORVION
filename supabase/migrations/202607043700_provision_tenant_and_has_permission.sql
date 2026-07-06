-- Migration: provision_tenant_and_has_permission
-- Phase 3 (Identity & Access). Two RPCs on the app schema:
--   * app.provision_tenant(...)  -- platform-mediated tenant + owner bootstrap (ADR-0016).
--   * app.has_permission(key)    -- binary authorization primitive (ADR-0015).
-- No table/schema change. Subscription lifecycle (subscriptions row, plans, entitlements) and
-- security-event emission are intentionally NOT handled here (separate future slices).

-- The app schema (migration 19) granted usage only to authenticated; provision_tenant is a
-- service_role operation, so service_role needs usage on the schema to reach it.
grant usage on schema app to service_role;

-- Platform-mediated provisioning: creates a tenant, its owner users membership, and the owner
-- role assignment. SECURITY DEFINER so it can write before any RLS context exists; callable ONLY
-- by service_role (platform owner / backend), never by tenants themselves. Initial status is a
-- parameter (tenants.status is unconstrained text) defaulting to 'trial'.
create or replace function app.provision_tenant(
    p_tenant_name text,
    p_tenant_slug text,
    p_owner_email text,
    p_owner_full_name text,
    p_owner_auth_user_id uuid default null,
    p_default_currency_code text default null,
    p_tenant_status text default 'trial'
)
returns table (tenant_id uuid, owner_user_id uuid)
language plpgsql
security definer
set search_path = ''
as $$
declare
    v_tenant_id uuid;
    v_user_id uuid;
    v_owner_role_id uuid;
begin
    select id into v_owner_role_id from public.roles where code = 'owner' and is_active;
    if v_owner_role_id is null then
        raise exception 'owner role is not seeded; cannot provision tenant';
    end if;

    insert into public.tenants (name, slug, primary_email, default_currency_code, status)
    values (p_tenant_name, p_tenant_slug, p_owner_email, p_default_currency_code, p_tenant_status)
    returning id into v_tenant_id;

    insert into public.users (tenant_id, auth_user_id, full_name, email, is_active)
    values (v_tenant_id, p_owner_auth_user_id, p_owner_full_name, p_owner_email, true)
    returning id into v_user_id;

    -- Owner authority is tenant-scoped (scope_type='tenant'); assigned_by is null (platform action,
    -- no tenant-user assigner).
    insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type, is_active)
    values (v_tenant_id, v_user_id, v_owner_role_id, 'tenant', true);

    return query select v_tenant_id, v_user_id;
end;
$$;

revoke all on function app.provision_tenant(text, text, text, text, uuid, text, text) from public;
grant execute on function app.provision_tenant(text, text, text, text, uuid, text, text) to service_role;

-- Binary authorization primitive (ADR-0015): true iff the calling human, active and resolved within
-- their current tenant (app.current_tenant_id()), holds an active role assignment whose role is
-- granted the permission. Scope narrowing (branch/department/assigned) and plan-gating are applied
-- by the calling RPC, not here. SECURITY DEFINER to read RBAC tables regardless of the caller's own
-- row visibility; exposed to authenticated via PostgREST.
create or replace function app.has_permission(p_permission_key text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
    select exists (
        select 1
        from public.users u
        join public.user_role_assignments ura
            on ura.user_id = u.id
           and ura.tenant_id = u.tenant_id
           and ura.is_active
           and (ura.ends_at is null or ura.ends_at > now())
        join public.roles r on r.id = ura.role_id and r.is_active
        join public.role_permissions rp on rp.role_id = ura.role_id
        join public.permissions p on p.id = rp.permission_id
            and p.is_active
            and p.key = p_permission_key
        where u.auth_user_id = (select auth.uid())
          and u.is_active
          and u.tenant_id = app.current_tenant_id()
    );
$$;

grant execute on function app.has_permission(text) to authenticated;
