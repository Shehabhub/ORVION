-- Migration: convert_lead
-- Phase 4 (CRM Core). Lead -> Customer conversion (12_lead_statuses_and_rules Lead-To-Customer rule;
-- 26_state_machines won -> converted). Links a won lead to a customer (an existing one, or the customer
-- already linked at intake) and performs the terminal won -> converted transition, preserving the lead
-- as history and emitting lead_converted. Single responsibility: the customer must already exist
-- (created via app.create_customer or linked at intake) -- this RPC does the link + transition only.
-- SECURITY INVOKER; RLS is the backstop. No table/schema change.
--
-- Authorization mirrors lead progression (advance_lead / record_lead_interaction): the caller must be
-- the lead's assigned handler OR hold ASSIGN_LEAD, plus app.mfa_satisfied(). Creating the customer is
-- separately gated by CREATE_CUSTOMER in app.create_customer.
create or replace function app.convert_lead(
    p_lead_id uuid,
    p_customer_id uuid default null,
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
    v_assigned uuid;
    v_status text;
    v_lead_customer uuid;
    v_customer uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    select assigned_user_id, lead_status_code, customer_id
      into v_assigned, v_status, v_lead_customer
    from public.leads
    where id = p_lead_id and tenant_id = v_tenant;
    if not found then
        raise exception 'lead is not in your tenant';
    end if;

    -- 26: only a won lead may convert.
    if v_status <> 'won' then
        raise exception 'transition not allowed: % -> converted (lead must be won)', v_status;
    end if;

    -- Target customer: explicit argument wins, else the one linked at intake. One is required.
    v_customer := coalesce(p_customer_id, v_lead_customer);
    if v_customer is null then
        raise exception 'no customer to convert to; link or create a customer first';
    end if;
    if not exists (
        select 1 from public.customers where id = v_customer and tenant_id = v_tenant
    ) then
        raise exception 'customer is not in your tenant';
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    if not (v_actor is not null and v_actor = v_assigned) and not app.has_permission('ASSIGN_LEAD') then
        raise exception 'permission denied: not the assigned handler and lacks ASSIGN_LEAD'
            using errcode = '42501';
    end if;
    if not app.mfa_satisfied() then
        raise exception 'multi-factor authentication required for this role' using errcode = '42501';
    end if;

    -- Terminal transition. The lead is preserved (never deleted) and linked to the customer;
    -- converted is recorded with the official closure reason converted_customer (12).
    update public.leads
    set lead_status_code = 'converted',
        customer_id = v_customer,
        closure_reason_code = 'converted_customer',
        closed_at = now(),
        updated_at = now()
    where id = p_lead_id;

    perform app.record_event(
        v_tenant, 'lead_converted', 'lead', p_lead_id, v_actor, 'won', 'converted', p_reason,
        jsonb_build_object('customer_id', v_customer)
    );

    return v_customer;
end;
$$;
grant execute on function app.convert_lead(uuid, uuid, text) to authenticated;
