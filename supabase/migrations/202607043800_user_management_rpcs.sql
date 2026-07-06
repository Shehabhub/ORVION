-- Migration: user_management_rpcs
-- Phase 3 (Identity & Access). First tenant-facing identity RPCs, guarded by has_permission and
-- scoped to app.current_tenant_id(). SECURITY INVOKER: the caller already holds INSERT + tenant
-- RLS on these tables (SPEC-055), so RLS stays an enforced backstop and these functions add the
-- MANAGE_USERS authorization gate that RLS does not express (ADR-0015). No schema change.

-- Add a user to the caller's tenant. Requires MANAGE_USERS. Returns the new user id.
create or replace function app.create_tenant_user(
    p_full_name text,
    p_email text,
    p_phone text default null,
    p_auth_user_id uuid default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_user uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    if not app.has_permission('MANAGE_USERS') then
        raise exception 'permission denied: MANAGE_USERS' using errcode = '42501';
    end if;

    insert into public.users (tenant_id, auth_user_id, full_name, email, phone, is_active)
    values (v_tenant, p_auth_user_id, p_full_name, p_email, p_phone, true)
    returning id into v_user;

    return v_user;
end;
$$;
grant execute on function app.create_tenant_user(text, text, text, uuid) to authenticated;

-- Assign a role to a user in the caller's tenant. Requires MANAGE_USERS. Returns the assignment id.
create or replace function app.assign_user_role(
    p_user_id uuid,
    p_role_code text,
    p_scope_type text default 'tenant',
    p_branch_id uuid default null,
    p_department_id uuid default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_role uuid;
    v_actor uuid;
    v_assignment uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    if not app.has_permission('MANAGE_USERS') then
        raise exception 'permission denied: MANAGE_USERS' using errcode = '42501';
    end if;

    select id into v_role from public.roles where code = p_role_code and is_active;
    if v_role is null then
        raise exception 'unknown or inactive role: %', p_role_code;
    end if;

    if not exists (
        select 1 from public.users where id = p_user_id and tenant_id = v_tenant
    ) then
        raise exception 'target user is not in your tenant';
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    insert into public.user_role_assignments (
        tenant_id, user_id, role_id, scope_type, branch_id, department_id, is_active, assigned_by
    )
    values (
        v_tenant, p_user_id, v_role, p_scope_type, p_branch_id, p_department_id, true, v_actor
    )
    returning id into v_assignment;

    return v_assignment;
end;
$$;
grant execute on function app.assign_user_role(uuid, text, text, uuid, uuid) to authenticated;
