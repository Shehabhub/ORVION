-- Migration: lead_sla_escalation
-- Phase 4 (CRM Core). First scheduled workload under the background-processing model (ADR-0018):
-- business logic in a PostgreSQL RPC, scheduled by pg_cron (the fittest scheduler today), in-system
-- notifications in-DB (external delivery deferred to Edge/n8n).
-- SLA (04_lead_lifecycle / 26_state_machines): an assigned lead with no qualifying interaction within
-- 15 min -> lead_sla_warning + notify; after another 15 min -> reassign (lead_reassigned). SLA is
-- derived from lead_assignments.assigned_at (a qualifying interaction transitions the lead to
-- 'contacted', removing it from the 'assigned' scan). No table/schema change.

create extension if not exists pg_cron;

-- System (cross-tenant) SLA processor. SECURITY DEFINER: runs with no caller tenant context (cron),
-- so it acts per each lead's own tenant_id and does not use app.current_tenant_id(). Thresholds are
-- parameters (defaults per canon) to make it deterministically testable and future-configurable.
create or replace function app.process_lead_sla(
    p_warn_after interval default '15 minutes',
    p_reassign_after interval default '30 minutes'
)
returns table (lead_id uuid, action text)
language plpgsql
security definer
set search_path = ''
as $$
declare
    r record;
    v_cur_id uuid;
    v_cur_user uuid;
    v_cur_at timestamptz;
    v_warned boolean;
    v_elapsed interval;
    v_next uuid;
    m record;
begin
    for r in
        select l.id, l.tenant_id, l.branch_id, l.department_id
        from public.leads l
        where l.lead_status_code = 'assigned'
    loop
        select la.id, la.assigned_user_id, la.assigned_at
          into v_cur_id, v_cur_user, v_cur_at
        from public.lead_assignments la
        where la.lead_id = r.id and la.is_current
        order by la.assigned_at desc
        limit 1;
        if v_cur_id is null then
            continue;
        end if;

        v_elapsed := now() - v_cur_at;
        v_warned := exists (
            select 1 from public.events e
            where e.entity_type = 'lead' and e.entity_id = r.id
              and e.event_type_code = 'lead_sla_warning'
              and e.created_at >= v_cur_at
        );

        if v_elapsed >= p_reassign_after and v_warned then
            -- second stage: reassign to a different eligible, least-recently-assigned member
            select u.id into v_next
            from public.users u
            join public.user_branch_assignments uba
                on uba.user_id = u.id
               and uba.tenant_id = r.tenant_id
               and uba.branch_id = r.branch_id
               and uba.department_id = r.department_id
               and uba.ends_at is null
            left join lateral (
                select max(la2.assigned_at) as last_at
                from public.lead_assignments la2
                where la2.assigned_user_id = u.id and la2.tenant_id = r.tenant_id
            ) x on true
            where u.is_active and u.id <> v_cur_user
            order by x.last_at asc nulls first, u.id asc
            limit 1;

            if v_next is not null then
                update public.lead_assignments
                set is_current = false, unassigned_at = now()
                where id = v_cur_id;

                insert into public.lead_assignments (
                    tenant_id, lead_id, assigned_user_id, assigned_by, assignment_reason, is_current
                )
                values (r.tenant_id, r.id, v_next, null, 'SLA auto-reassignment', true);

                update public.leads
                set assigned_user_id = v_next, owner_user_id = v_next
                where id = r.id;

                perform app.record_event(
                    r.tenant_id, 'lead_reassigned', 'lead', r.id, null, 'assigned', 'assigned',
                    'SLA auto-reassignment (no qualifying interaction)',
                    jsonb_build_object('from_user_id', v_cur_user, 'to_user_id', v_next), 'warning'
                );

                insert into public.notifications (
                    tenant_id, target_user_id, notification_type_code, title, body,
                    related_entity_type, related_entity_id
                )
                values (
                    r.tenant_id, v_next, 'lead_reassigned', 'Lead reassigned to you',
                    'An SLA-overdue lead was reassigned to you.', 'lead', r.id
                );

                lead_id := r.id; action := 'reassigned'; return next;
            end if;

        elsif v_elapsed >= p_warn_after and not v_warned then
            -- first stage: warn + notify assignee and branch/department managers
            perform app.record_event(
                r.tenant_id, 'lead_sla_warning', 'lead', r.id, null, null, null,
                'No qualifying interaction within SLA window',
                jsonb_build_object('assigned_user_id', v_cur_user), 'warning'
            );

            insert into public.notifications (
                tenant_id, target_user_id, notification_type_code, title, body,
                related_entity_type, related_entity_id
            )
            values (
                r.tenant_id, v_cur_user, 'lead_sla_warning', 'Lead SLA warning',
                'A lead assigned to you has had no qualifying interaction within the SLA window.',
                'lead', r.id
            );

            for m in
                select distinct ura.user_id
                from public.user_role_assignments ura
                join public.roles rr on rr.id = ura.role_id
                where ura.tenant_id = r.tenant_id and ura.is_active
                  and rr.code in ('branch_manager', 'department_manager')
                  and (ura.branch_id = r.branch_id or ura.department_id = r.department_id)
                  and ura.user_id <> v_cur_user
            loop
                insert into public.notifications (
                    tenant_id, target_user_id, notification_type_code, title, body,
                    related_entity_type, related_entity_id
                )
                values (
                    r.tenant_id, m.user_id, 'lead_sla_warning', 'Team lead SLA warning',
                    'A lead in your team has breached its SLA window.', 'lead', r.id
                );
            end loop;

            lead_id := r.id; action := 'warned'; return next;
        end if;
    end loop;
end;
$$;

revoke all on function app.process_lead_sla(interval, interval) from public;
grant execute on function app.process_lead_sla(interval, interval) to service_role;

-- Schedule the SLA processor every minute (pg_cron = the fittest scheduler today, ADR-0018).
-- Idempotent: unschedule any prior job of this name before (re)scheduling.
do $$
begin
    if exists (select 1 from cron.job where jobname = 'lead-sla-processor') then
        perform cron.unschedule('lead-sla-processor');
    end if;
    perform cron.schedule('lead-sla-processor', '* * * * *', 'select app.process_lead_sla()');
end
$$;
