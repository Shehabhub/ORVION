-- Migration: lead_booking_readiness
-- Phase 4 (CRM Core) -- final capability. The canonical Phase 4 -> Phase 5 (Booking Core) HANDOFF
-- CONTRACT. This is the single authoritative place that answers, for a lead:
--   * whether it is booking-ready (is_ready),
--   * WHY it is or is not ready (a normalized reason_code + human message),
--   * and the normalized business context that Booking Core will consume when it creates a booking.
-- Read-only; it creates no booking and changes no state (booking creation is Phase 5). It encodes the
-- 12_lead_statuses_and_rules Lead-To-Booking eligibility rule ONCE, explicitly (per 04's "explicit
-- rule, not inferred informally"), so Phase 5 never re-derives it. SECURITY INVOKER; RLS is the
-- backstop. No table/schema change.
--
-- Eligibility (12): a booking requires a customer (bookings.customer_id is NOT NULL) and a lead that is
-- not archived and not closed negatively (lost/spam/duplicate). Positive statuses (new..converted) are
-- booking-eligible -- 12 allows a booking directly after creation, after qualification/negotiation, or
-- at conversion; the authoritative booking anchor is the linked customer, not a specific status.
create or replace function app.lead_booking_readiness(p_lead_id uuid)
returns table (
    lead_id uuid,
    is_ready boolean,
    reason_code text,
    reason text,
    customer_id uuid,
    lead_status_code text,
    requested_service_type_code text,
    branch_id uuid,
    department_id uuid,
    assigned_user_id uuid,
    expected_value numeric,
    title text
)
language plpgsql
stable
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    l record;
    v_ready boolean;
    v_code text;
    v_msg text;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    select * into l from public.leads where id = p_lead_id and tenant_id = v_tenant;
    if not found then
        raise exception 'lead is not in your tenant';
    end if;

    -- Normalized readiness verdict (single source of truth for the phase boundary).
    if l.is_archived then
        v_ready := false; v_code := 'lead_archived';
        v_msg := 'Lead is archived and cannot originate a booking.';
    elsif l.lead_status_code in ('lost', 'spam', 'duplicate') then
        v_ready := false; v_code := 'lead_closed_negative';
        v_msg := 'Lead is closed as ' || l.lead_status_code || '; not booking-eligible.';
    elsif l.customer_id is null then
        v_ready := false; v_code := 'no_customer_linked';
        v_msg := 'No customer is linked to the lead; link or convert a customer before booking.';
    else
        v_ready := true; v_code := 'ready';
        v_msg := 'Lead is booking-ready.';
    end if;

    -- Normalized handoff payload consumed by Booking Core (Phase 5).
    return query select
        l.id, v_ready, v_code, v_msg, l.customer_id, l.lead_status_code,
        l.requested_service_type_code, l.branch_id, l.department_id, l.assigned_user_id,
        l.expected_value, l.title;
end;
$$;
grant execute on function app.lead_booking_readiness(uuid) to authenticated;
