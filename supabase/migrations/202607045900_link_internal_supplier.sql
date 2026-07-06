-- Migration: link_internal_supplier
-- Phase 5 (Booking Core). Internal supplier linkage -- an ORGANIZATIONAL FULFILMENT capability: records
-- that one branch/department (the provider) fulfils a booking item on behalf of the item's owning
-- branch/department (the requester). This is the INTERNAL fulfilment path (internal_supplier_links);
-- EXTERNAL supplier fulfilment is booking_items.supplier_id. Guarded by ASSIGN_SUPPLIER via
-- app.authorize. SECURITY INVOKER; RLS backstop. No table/schema change.
--
-- FULFILMENT HISTORY: each linkage APPENDS a new internal_supplier_links row (the table has no
-- uniqueness constraint), so "who fulfilled what and when" is preserved -- the latest row is the current
-- provider; all rows are the history (valuable for audit/reporting/commissions/workload/future SLA). An
-- internal_supplier_linked event is also published (orchestration boundary: future domains react).
-- Booking Core stays service-agnostic -- no flight/hotel/visa/etc. assumptions here.
create or replace function app.link_internal_supplier(
    p_booking_item_id uuid,
    p_provider_branch_id uuid,
    p_provider_department_id uuid,
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
    v_item record;
    v_req_branch uuid;
    v_req_dept uuid;
    v_link uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('ASSIGN_SUPPLIER');

    select bi.id, bi.base_status_code, bi.is_archived,
           bi.owner_branch_id, bi.owner_department_id,
           b.branch_id as booking_branch_id, b.department_id as booking_department_id,
           b.booking_status_code, b.is_archived as booking_archived
      into v_item
    from public.booking_items bi
    join public.bookings b on b.id = bi.booking_id and b.tenant_id = v_tenant
    where bi.id = p_booking_item_id and bi.tenant_id = v_tenant;
    if not found then
        raise exception 'booking item is not in your tenant';
    end if;
    if v_item.is_archived or v_item.base_status_code in ('cancelled', 'no_show') then
        raise exception 'cannot link a supplier to a % booking item', v_item.base_status_code;
    end if;
    if v_item.booking_archived or v_item.booking_status_code in ('completed', 'cancelled') then
        raise exception 'cannot link a supplier to an item on a % booking', v_item.booking_status_code;
    end if;

    -- Requester = the item's owning org unit (fallback to the booking's branch/department).
    v_req_branch := coalesce(v_item.owner_branch_id, v_item.booking_branch_id);
    v_req_dept   := coalesce(v_item.owner_department_id, v_item.booking_department_id);

    -- Provider org unit must be a department-within-branch in the caller's tenant.
    if not exists (
        select 1 from public.departments d
        where d.id = p_provider_department_id
          and d.branch_id = p_provider_branch_id
          and d.tenant_id = v_tenant
    ) then
        raise exception 'provider department does not belong to provider branch in your tenant';
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    -- Append a new fulfilment record (history preserved; latest row = current provider).
    insert into public.internal_supplier_links (
        tenant_id, booking_item_id, provider_branch_id, provider_department_id,
        requester_branch_id, requester_department_id
    )
    values (
        v_tenant, p_booking_item_id, p_provider_branch_id, p_provider_department_id,
        v_req_branch, v_req_dept
    )
    returning id into v_link;

    perform app.record_event(
        v_tenant, 'internal_supplier_linked', 'booking_item', p_booking_item_id, v_actor, null, null,
        p_reason,
        jsonb_build_object('link_id', v_link,
                           'provider_branch_id', p_provider_branch_id,
                           'provider_department_id', p_provider_department_id,
                           'requester_branch_id', v_req_branch,
                           'requester_department_id', v_req_dept)
    );

    return v_link;
end;
$$;
grant execute on function app.link_internal_supplier(uuid, uuid, uuid, text) to authenticated;
