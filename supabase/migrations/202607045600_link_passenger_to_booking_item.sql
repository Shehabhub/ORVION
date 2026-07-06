-- Migration: link_passenger_to_booking_item
-- Phase 5 (Booking Core). Links a passenger (traveler) to a booking item -- the traveler manifest of an
-- item (booking_item_passengers, unique per item+passenger), with optional per-passenger amount
-- overrides (e.g. a child fare differing from the item's default). Guarded by CREATE_BOOKING_ITEM via
-- app.authorize. SECURITY INVOKER; RLS is the backstop. No table/schema change.
-- Both the item and passenger must be in the caller's tenant; the item's booking must not be terminal
-- or archived, and the item itself must not be in a terminal item state (cancelled/no_show).
create or replace function app.link_passenger_to_booking_item(
    p_booking_item_id uuid,
    p_passenger_id uuid,
    p_selling_amount_override numeric default null,
    p_cost_amount_override numeric default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_item record;
    v_link uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('CREATE_BOOKING_ITEM');

    select bi.id, bi.base_status_code, bi.is_archived as item_archived,
           b.booking_status_code, b.is_archived as booking_archived
      into v_item
    from public.booking_items bi
    join public.bookings b on b.id = bi.booking_id and b.tenant_id = v_tenant
    where bi.id = p_booking_item_id and bi.tenant_id = v_tenant;
    if not found then
        raise exception 'booking item is not in your tenant';
    end if;
    if v_item.item_archived or v_item.base_status_code in ('cancelled', 'no_show') then
        raise exception 'cannot add a passenger to a % booking item', v_item.base_status_code;
    end if;
    if v_item.booking_archived or v_item.booking_status_code in ('completed', 'cancelled') then
        raise exception 'cannot add a passenger to an item on a % booking', v_item.booking_status_code;
    end if;

    if not exists (
        select 1 from public.passengers where id = p_passenger_id and tenant_id = v_tenant
    ) then
        raise exception 'passenger is not in your tenant';
    end if;

    if (p_selling_amount_override is not null and p_selling_amount_override < 0)
       or (p_cost_amount_override is not null and p_cost_amount_override < 0) then
        raise exception 'amount overrides must be non-negative';
    end if;

    begin
        insert into public.booking_item_passengers (
            tenant_id, booking_item_id, passenger_id, selling_amount_override, cost_amount_override
        )
        values (
            v_tenant, p_booking_item_id, p_passenger_id, p_selling_amount_override, p_cost_amount_override
        )
        returning id into v_link;
    exception when unique_violation then
        raise exception 'passenger is already linked to this booking item';
    end;

    return v_link;
end;
$$;
grant execute on function app.link_passenger_to_booking_item(uuid, uuid, numeric, numeric)
    to authenticated;
