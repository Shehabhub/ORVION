-- Migration: advance_lead
-- Phase 4 (CRM Core). Lead pipeline progression + closure. A single table-driven RPC that validates
-- the requested transition against the canonical Lead State Machine (26_state_machines), authorizes it,
-- applies it, and emits the mandated per-transition event via app.record_event.
-- Covers: contacted->qualified->quotation_sent->negotiation->won (plus qualified->won, quotation_sent->won)
-- and closures ->lost/->spam/->duplicate (with a controlled lead_closure_reason).
-- Out of scope (deferred): won->converted (needs the customer link) and terminal-state reopening.
-- SECURITY INVOKER; RLS + append-only triggers are the backstop. No table/schema change.
--
-- Authorization mirrors established canon:
--   progression -> caller is the assigned handler OR holds ASSIGN_LEAD, plus app.mfa_satisfied()
--                  (same guard as record_lead_interaction, SPEC-066).
--   closure     -> app.authorize('CLOSE_LEAD') (28_permissions_matrix: "CLOSE_LEAD ... Assigned only").
create or replace function app.advance_lead(
    p_lead_id uuid,
    p_to_status text,
    p_reason text default null,
    p_closure_reason_code text default null
)
returns text
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_assigned uuid;
    v_status text;
    v_event text;
    v_is_closure boolean;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    select assigned_user_id, lead_status_code
      into v_assigned, v_status
    from public.leads
    where id = p_lead_id and tenant_id = v_tenant;
    if not found then
        raise exception 'lead is not in your tenant';
    end if;

    -- Canonical allowed transitions (26_state_machines Lead State Machine), excluding
    -- new->assigned / assigned->contacted / assigned->assigned (owned by other RPCs),
    -- won->converted (deferred: customer link) and terminal reopening (deferred).
    select t.ev, t.is_closure
      into v_event, v_is_closure
    from (values
        ('new',           'spam',          'lead_marked_spam',         true),
        ('new',           'duplicate',     'lead_marked_duplicate',    true),
        ('assigned',      'lost',          'lead_lost',                true),
        ('assigned',      'duplicate',     'lead_marked_duplicate',    true),
        ('contacted',     'qualified',     'lead_qualified',           false),
        ('contacted',     'lost',          'lead_lost',                true),
        ('contacted',     'spam',          'lead_marked_spam',         true),
        ('qualified',     'quotation_sent','lead_quotation_sent',      false),
        ('qualified',     'won',           'lead_won',                 false),
        ('qualified',     'lost',          'lead_lost',                true),
        ('quotation_sent','negotiation',   'lead_negotiation_started', false),
        ('quotation_sent','won',           'lead_won',                 false),
        ('quotation_sent','lost',          'lead_lost',                true),
        ('negotiation',   'won',           'lead_won',                 false),
        ('negotiation',   'lost',          'lead_lost',                true)
    ) as t(frm, to_s, ev, is_closure)
    where t.frm = v_status and t.to_s = p_to_status;

    if v_event is null then
        raise exception 'transition not allowed: % -> %', v_status, p_to_status;
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    if v_is_closure then
        perform app.authorize('CLOSE_LEAD');
        if p_closure_reason_code is null then
            raise exception 'closure requires a closure_reason_code';
        end if;
        if not exists (
            select 1 from public.catalog_values
            where catalog_type_code = 'lead_closure_reason' and code = p_closure_reason_code
        ) then
            raise exception 'unknown lead_closure_reason: %', p_closure_reason_code;
        end if;
    else
        if not (v_actor is not null and v_actor = v_assigned)
           and not app.has_permission('ASSIGN_LEAD') then
            raise exception 'permission denied: not the assigned handler and lacks ASSIGN_LEAD'
                using errcode = '42501';
        end if;
        if not app.mfa_satisfied() then
            raise exception 'multi-factor authentication required for this role' using errcode = '42501';
        end if;
    end if;

    update public.leads
    set lead_status_code = p_to_status,
        closure_reason_code = case when v_is_closure then p_closure_reason_code else closure_reason_code end,
        closed_at = case when v_is_closure then now() else closed_at end,
        updated_at = now()
    where id = p_lead_id;

    perform app.record_event(
        v_tenant, v_event, 'lead', p_lead_id, v_actor, v_status, p_to_status, p_reason,
        case when v_is_closure
             then jsonb_build_object('closure_reason_code', p_closure_reason_code)
             else null end,
        case when v_is_closure then 'warning' else 'info' end
    );

    return p_to_status;
end;
$$;
grant execute on function app.advance_lead(uuid, text, text, text) to authenticated;
