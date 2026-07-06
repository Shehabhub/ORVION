-- Migration: mfa_requirement_enforcement
-- Phase 3 (Identity & Access) -- authentication hardening per ADR-0017 (Supabase-native auth).
-- Supabase Auth owns the MFA artifact + verification and stamps the session assurance level (aal)
-- into the JWT; ORVION owns the POLICY -- which roles require MFA (28: owner/ceo/finance_manager/
-- system_administrator) -- and enforces it. No table/schema change; migration-29 tables untouched.

-- Does the caller's active membership hold a high-risk role that requires MFA? (28 Auth Requirements)
create or replace function app.requires_mfa()
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
            on ura.user_id = u.id and ura.tenant_id = u.tenant_id and ura.is_active
           and (ura.ends_at is null or ura.ends_at > now())
        join public.roles r on r.id = ura.role_id and r.is_active
        where u.auth_user_id = (select auth.uid())
          and u.is_active
          and u.tenant_id = app.current_tenant_id()
          and r.code in ('owner', 'ceo', 'finance_manager', 'system_administrator')
    );
$$;
grant execute on function app.requires_mfa() to authenticated;

-- Is the MFA policy satisfied for this session? True unless MFA is required and the Supabase-issued
-- session assurance level (JWT aal claim) is not aal2.
create or replace function app.mfa_satisfied()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
    select (not app.requires_mfa())
        or coalesce((select auth.jwt() ->> 'aal'), 'aal1') = 'aal2';
$$;
grant execute on function app.mfa_satisfied() to authenticated;

-- Combined guard for sensitive RPCs: authorization (has_permission) AND authentication policy
-- (mfa_satisfied). Keeps has_permission pure (ADR-0015) while composing the MFA gate at the boundary.
create or replace function app.authorize(p_permission_key text)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
    if not app.has_permission(p_permission_key) then
        raise exception 'permission denied: %', p_permission_key using errcode = '42501';
    end if;
    if not app.mfa_satisfied() then
        raise exception 'multi-factor authentication required for this role'
            using errcode = '42501';
    end if;
end;
$$;
grant execute on function app.authorize(text) to authenticated;

-- Re-define the five sensitive management RPCs to route their guard through app.authorize()
-- (bodies otherwise unchanged from SPEC-059/SPEC-060).

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
    perform app.authorize('MANAGE_USERS');

    insert into public.users (tenant_id, auth_user_id, full_name, email, phone, is_active)
    values (v_tenant, p_auth_user_id, p_full_name, p_email, p_phone, true)
    returning id into v_user;

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
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('MANAGE_BRANCHES');

    insert into public.branches (tenant_id, name, slug, branch_type, primary_phone, address, is_active)
    values (v_tenant, p_name, p_slug, p_branch_type, p_primary_phone, p_address, true)
    returning id into v_branch;

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

    return v_department;
end;
$$;

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
    perform app.authorize('MANAGE_USERS');

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
