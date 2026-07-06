-- Migration: record_lead_interaction
-- Phase 4 (CRM Core). Logs a lead interaction and, on a qualifying contact, performs the
-- assigned -> contacted transition with a lead_contacted event (26_state_machines). Reuses
-- app.record_event. SECURITY INVOKER; RLS is the backstop. No table/schema change.
-- Guard: the caller must be the lead's assigned handler OR hold ASSIGN_LEAD (manager), and satisfy
-- the MFA policy -- there is no dedicated "record interaction" permission in 28.
create or replace function app.record_lead_interaction(
    p_lead_id uuid,
    p_interaction_type_code text,
    p_summary text default null,
    p_metadata jsonb default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_assigned uuid;
    v_status text;
    v_interaction uuid;
    v_qualifying boolean;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    select assigned_user_id, lead_status_code
      into v_assigned, v_status
    from public.leads
    where id = p_lead_id and tenant_id = v_tenant;
    if not found then
        raise exception 'lead is not in your tenant';
    end if;

    if not (v_actor is not null and v_actor = v_assigned) and not app.has_permission('ASSIGN_LEAD') then
        raise exception 'permission denied: not the assigned handler and lacks ASSIGN_LEAD'
            using errcode = '42501';
    end if;
    if not app.mfa_satisfied() then
        raise exception 'multi-factor authentication required for this role' using errcode = '42501';
    end if;

    if not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'lead_interaction_type' and code = p_interaction_type_code
    ) then
        raise exception 'unknown lead_interaction_type: %', p_interaction_type_code;
    end if;

    insert into public.lead_interactions (
        tenant_id, lead_id, user_id, interaction_type_code, summary, metadata
    )
    values (v_tenant, p_lead_id, v_actor, p_interaction_type_code, p_summary, p_metadata)
    returning id into v_interaction;

    v_qualifying := p_interaction_type_code in
        ('phone_call', 'whatsapp_message', 'chat_opened', 'customer_reply');

    if v_qualifying then
        update public.leads set last_contact_at = now() where id = p_lead_id;

        if v_status = 'assigned' then
            update public.leads set lead_status_code = 'contacted' where id = p_lead_id;
            perform app.record_event(
                v_tenant, 'lead_contacted', 'lead', p_lead_id, v_actor, 'assigned', 'contacted', null,
                jsonb_build_object('interaction_id', v_interaction,
                                   'interaction_type_code', p_interaction_type_code)
            );
        end if;
    end if;

    return v_interaction;
end;
$$;
grant execute on function app.record_lead_interaction(uuid, text, text, jsonb) to authenticated;
