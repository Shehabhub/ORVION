-- Migration: round_robin_lead_assignment
-- Phase 4 (CRM Core). Round-robin lead assignment + the reusable event-emission seam.
-- 04_lead_lifecycle: deterministic, auditable, branch/department-aware routing.
-- 26_state_machines: the new -> assigned transition must record a lead_assigned event
-- (actor, previous_state, new_state). SECURITY INVOKER; RLS + append-only triggers are the backstop.
-- No table/schema change.

-- Reusable event-emission helper (earned by the first lead state transition; reused by all future
-- transitions and the deferred 28 Event Requirements). Writes one append-only events row.
create or replace function app.record_event(
    p_tenant_id uuid,
    p_event_type_code text,
    p_entity_type text,
    p_entity_id uuid,
    p_actor_user_id uuid default null,
    p_previous_state text default null,
    p_new_state text default null,
    p_reason text default null,
    p_payload jsonb default null,
    p_severity_code text default 'info'
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_event uuid;
begin
    insert into public.events (
        tenant_id, event_type_code, severity_code, actor_user_id, entity_type, entity_id,
        previous_state, new_state, reason, payload
    )
    values (
        p_tenant_id, p_event_type_code, p_severity_code, p_actor_user_id, p_entity_type, p_entity_id,
        p_previous_state, p_new_state, p_reason, p_payload
    )
    returning id into v_event;
    return v_event;
end;
$$;
grant execute on function app.record_event(uuid, text, text, uuid, uuid, text, text, text, jsonb, text)
    to authenticated;

-- Assign a NEW lead to a specific active tenant member: performs the new -> assigned transition,
-- records assignment history, and emits a lead_assigned event.
create or replace function app.assign_lead(
    p_lead_id uuid,
    p_assignee_user_id uuid,
    p_reason text default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_branch uuid;
    v_department uuid;
    v_status text;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('ASSIGN_LEAD');

    select branch_id, department_id, lead_status_code
      into v_branch, v_department, v_status
    from public.leads
    where id = p_lead_id and tenant_id = v_tenant;
    if not found then
        raise exception 'lead is not in your tenant';
    end if;
    if v_status <> 'new' then
        raise exception 'lead is not in new status (use reassignment): %', v_status;
    end if;

    if not exists (
        select 1 from public.users
        where id = p_assignee_user_id and tenant_id = v_tenant and is_active
    ) then
        raise exception 'assignee is not an active user in your tenant';
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    update public.leads
    set assigned_user_id = p_assignee_user_id,
        lead_status_code = 'assigned',
        owner_user_id = p_assignee_user_id,
        owner_branch_id = v_branch,
        owner_department_id = v_department
    where id = p_lead_id;

    insert into public.lead_assignments (
        tenant_id, lead_id, assigned_user_id, assigned_by, assignment_reason, is_current
    )
    values (v_tenant, p_lead_id, p_assignee_user_id, v_actor, p_reason, true);

    perform app.record_event(
        v_tenant, 'lead_assigned', 'lead', p_lead_id, v_actor, 'new', 'assigned', p_reason,
        jsonb_build_object('assigned_user_id', p_assignee_user_id)
    );

    return p_lead_id;
end;
$$;
grant execute on function app.assign_lead(uuid, uuid, text) to authenticated;

-- Round-robin: pick the eligible, least-recently-assigned department member and assign the NEW lead.
create or replace function app.assign_lead_round_robin(
    p_lead_id uuid,
    p_reason text default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_branch uuid;
    v_department uuid;
    v_status text;
    v_chosen uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('ASSIGN_LEAD');

    select branch_id, department_id, lead_status_code
      into v_branch, v_department, v_status
    from public.leads
    where id = p_lead_id and tenant_id = v_tenant;
    if not found then
        raise exception 'lead is not in your tenant';
    end if;
    if v_status <> 'new' then
        raise exception 'lead is not in new status (use reassignment): %', v_status;
    end if;

    -- Eligible = active users with a current branch+department assignment to the lead's branch/dept.
    -- Round-robin = least-recently-assigned (oldest max(assigned_at); never-assigned first),
    -- tie-broken deterministically by user id.
    select u.id
      into v_chosen
    from public.users u
    join public.user_branch_assignments uba
        on uba.user_id = u.id
       and uba.tenant_id = v_tenant
       and uba.branch_id = v_branch
       and uba.department_id = v_department
       and uba.ends_at is null
    left join lateral (
        select max(la.assigned_at) as last_at
        from public.lead_assignments la
        where la.assigned_user_id = u.id and la.tenant_id = v_tenant
    ) x on true
    where u.is_active
    order by x.last_at asc nulls first, u.id asc
    limit 1;

    if v_chosen is null then
        raise exception 'no eligible employee for round-robin';
    end if;

    return app.assign_lead(p_lead_id, v_chosen, coalesce(p_reason, 'round-robin assignment'));
end;
$$;
grant execute on function app.assign_lead_round_robin(uuid, text) to authenticated;
