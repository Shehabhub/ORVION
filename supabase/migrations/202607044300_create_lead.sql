-- Migration: create_lead
-- Phase 4 (CRM Core) -- Lead intake. Creates a lead in the initial 'new' status (26_state_machines)
-- within the caller's tenant, guarded by CREATE_LEAD via app.authorize (so the MFA policy composes
-- for high-risk roles). SECURITY INVOKER: RLS (SPEC-055) is the backstop. No state transition occurs
-- (initial state), so no event emission is required here -- events are mandated on transitions and are
-- earned at the assignment capability. No table/schema change.
create or replace function app.create_lead(
    p_branch_id uuid,
    p_department_id uuid,
    p_lead_source_code text,
    p_title text,
    p_priority_code text default null,
    p_requested_service_type_code text default null,
    p_customer_id uuid default null,
    p_customer_phone text default null,
    p_customer_name text default null,
    p_expected_value numeric default null,
    p_source_payload jsonb default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_lead uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('CREATE_LEAD');

    -- department must belong to the given branch, in the caller's tenant
    if not exists (
        select 1 from public.departments d
        where d.id = p_department_id and d.branch_id = p_branch_id and d.tenant_id = v_tenant
    ) then
        raise exception 'department does not belong to branch';
    end if;

    if not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'lead_source' and code = p_lead_source_code
    ) then
        raise exception 'unknown lead_source_code: %', p_lead_source_code;
    end if;

    if p_requested_service_type_code is not null and not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'service_type' and code = p_requested_service_type_code
    ) then
        raise exception 'unknown requested_service_type_code: %', p_requested_service_type_code;
    end if;

    if p_priority_code is not null and not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'priority_code' and code = p_priority_code
    ) then
        raise exception 'unknown priority_code: %', p_priority_code;
    end if;

    if p_customer_id is not null and not exists (
        select 1 from public.customers where id = p_customer_id and tenant_id = v_tenant
    ) then
        raise exception 'customer is not in your tenant';
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    insert into public.leads (
        tenant_id, branch_id, department_id, lead_source_code, lead_status_code, priority_code,
        customer_id, assigned_user_id, title, requested_service_type_code, expected_value,
        customer_phone_snapshot, customer_name_snapshot, source_payload, created_by
    )
    values (
        v_tenant, p_branch_id, p_department_id, p_lead_source_code, 'new', p_priority_code,
        p_customer_id, null, p_title, p_requested_service_type_code, p_expected_value,
        p_customer_phone, p_customer_name, p_source_payload, v_actor
    )
    returning id into v_lead;

    return v_lead;
end;
$$;
grant execute on function app.create_lead(uuid, uuid, text, text, text, text, uuid, text, text, numeric, jsonb) to authenticated;
