-- Migration: identity_event_emission (closes the last verified audit-orphan before Phase-8 live)
-- Verified against implementation: the identity RPCs emit NO events because they predate
-- app.record_event (created 044400) — a chronology gap, not a design decision. Canon 27
-- registers user_created / role_assigned / branch_created / department_created; canon 28
-- expects the role-change audit trail. This migration re-creates the four RPCs with their
-- 044100 bodies VERBATIM plus only an actor lookup (where absent) and the event emission.
-- Deliberately NOT emitted (no-guessing): assign_user_branch initial assignment (canon 27
-- defines only *transfer* events); role_removed / permission_granted / permission_revoked
-- (no RPC mutates those yet — they land with their first consumer RPC, mint-per-consumer).

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
    v_actor uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('MANAGE_USERS');

    insert into public.users (tenant_id, auth_user_id, full_name, email, phone, is_active)
    values (v_tenant, p_auth_user_id, p_full_name, p_email, p_phone, true)
    returning id into v_user;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;
    perform app.record_event(
        v_tenant, 'user_created', 'user', v_user, v_actor,
        null, 'active', null,
        jsonb_build_object('email', p_email, 'has_auth_link', p_auth_user_id is not null),
        'info'
    );

    return v_user;
end;
$$;

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
    perform app.authorize('MANAGE_USERS');

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

    perform app.record_event(
        v_tenant, 'role_assigned', 'user', p_user_id, v_actor,
        null, p_role_code, null,
        jsonb_build_object('role_code', p_role_code, 'scope_type', p_scope_type,
                           'branch_id', p_branch_id, 'department_id', p_department_id,
                           'assignment_id', v_assignment),
        'security'
    );

    return v_assignment;
end;
$$;

create or replace function app.create_branch(
    p_name text,
    p_slug text,
    p_branch_type text default null,
    p_primary_phone text default null,
    p_address text default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_branch uuid;
    v_actor uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('MANAGE_BRANCHES');

    insert into public.branches (tenant_id, name, slug, branch_type, primary_phone, address, is_active)
    values (v_tenant, p_name, p_slug, p_branch_type, p_primary_phone, p_address, true)
    returning id into v_branch;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;
    perform app.record_event(
        v_tenant, 'branch_created', 'branch', v_branch, v_actor,
        null, 'active', null,
        jsonb_build_object('name', p_name, 'slug', p_slug),
        'info'
    );

    return v_branch;
end;
$$;

create or replace function app.create_department(
    p_branch_id uuid,
    p_department_type_code text,
    p_name text
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_department uuid;
    v_actor uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('MANAGE_DEPARTMENTS');

    if not exists (
        select 1 from public.branches where id = p_branch_id and tenant_id = v_tenant
    ) then
        raise exception 'branch is not in your tenant';
    end if;

    if not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'department_type' and code = p_department_type_code
    ) then
        raise exception 'unknown department_type_code: %', p_department_type_code;
    end if;

    insert into public.departments (tenant_id, branch_id, department_type_code, name, is_active)
    values (v_tenant, p_branch_id, p_department_type_code, p_name, true)
    returning id into v_department;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;
    perform app.record_event(
        v_tenant, 'department_created', 'department', v_department, v_actor,
        null, 'active', null,
        jsonb_build_object('branch_id', p_branch_id, 'department_type_code', p_department_type_code,
                           'name', p_name),
        'info'
    );

    return v_department;
end;
$$;
