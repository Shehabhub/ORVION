-- Migration: organization_management_rpcs
-- Phase 3 (Identity & Access) -- "Branch/department assignment" output. Tenant-facing org-structure
-- RPCs guarded by has_permission and scoped to app.current_tenant_id(). SECURITY INVOKER so RLS
-- (SPEC-055) stays an enforced backstop; the functions add the MANAGE_* authorization gate RLS does
-- not express (ADR-0015). No schema change. branch_business_hours/holidays are out of scope
-- (operational scheduling, not identity/access).

-- Create a branch in the caller's tenant. Requires MANAGE_BRANCHES.
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
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    if not app.has_permission('MANAGE_BRANCHES') then
        raise exception 'permission denied: MANAGE_BRANCHES' using errcode = '42501';
    end if;

    insert into public.branches (tenant_id, name, slug, branch_type, primary_phone, address, is_active)
    values (v_tenant, p_name, p_slug, p_branch_type, p_primary_phone, p_address, true)
    returning id into v_branch;

    return v_branch;
end;
$$;
grant execute on function app.create_branch(text, text, text, text, text) to authenticated;

-- Create a department under a branch in the caller's tenant. Requires MANAGE_DEPARTMENTS.
-- department_type_code is validated against the seeded department_type catalog (25: employees must
-- not create operational types freely).
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
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    if not app.has_permission('MANAGE_DEPARTMENTS') then
        raise exception 'permission denied: MANAGE_DEPARTMENTS' using errcode = '42501';
    end if;

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

    return v_department;
end;
$$;
grant execute on function app.create_department(uuid, text, text) to authenticated;

-- Place a user in a branch (optionally a department) in the caller's tenant. Requires MANAGE_USERS.
create or replace function app.assign_user_branch(
    p_user_id uuid,
    p_branch_id uuid,
    p_department_id uuid default null,
    p_is_primary boolean default false,
    p_transfer_type_code text default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_assignment uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    if not app.has_permission('MANAGE_USERS') then
        raise exception 'permission denied: MANAGE_USERS' using errcode = '42501';
    end if;

    if not exists (select 1 from public.users where id = p_user_id and tenant_id = v_tenant) then
        raise exception 'target user is not in your tenant';
    end if;
    if not exists (select 1 from public.branches where id = p_branch_id and tenant_id = v_tenant) then
        raise exception 'branch is not in your tenant';
    end if;
    if p_department_id is not null and not exists (
        select 1 from public.departments
        where id = p_department_id and branch_id = p_branch_id and tenant_id = v_tenant
    ) then
        raise exception 'department does not belong to branch';
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    insert into public.user_branch_assignments (
        tenant_id, user_id, branch_id, department_id, transfer_type_code, is_primary, created_by
    )
    values (
        v_tenant, p_user_id, p_branch_id, p_department_id, p_transfer_type_code, p_is_primary, v_actor
    )
    returning id into v_assignment;

    return v_assignment;
end;
$$;
grant execute on function app.assign_user_branch(uuid, uuid, uuid, boolean, text) to authenticated;
