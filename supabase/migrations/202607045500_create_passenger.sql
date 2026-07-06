-- Migration: create_passenger
-- Phase 5 (Booking Core). Creates a passenger (traveler) record -- the natural prerequisite of
-- passenger linkage (booking_item_passengers). A passenger may optionally reference the customer it
-- belongs to / relates to (05: related family members or travelers). Passport/travel-document identity
-- lives here at the passenger level (16 / 05). Guarded by CREATE_BOOKING_ITEM via app.authorize -- there
-- is no dedicated passenger permission in 28, and passengers are built by the same booking-execution
-- staff who create booking items and link travelers. SECURITY INVOKER; RLS is the backstop.
-- No table/schema change. No state machine / required event for passengers (not a lifecycle entity).
create or replace function app.create_passenger(
    p_first_name text,
    p_family_name text,
    p_full_name text default null,
    p_passenger_type_code text default 'adult',
    p_customer_id uuid default null,
    p_relationship_to_customer_code text default null,
    p_date_of_birth date default null,
    p_nationality_code text default null,
    p_passport_number text default null,
    p_passport_issue_date date default null,
    p_passport_expiry_date date default null,
    p_passport_issuing_country_code text default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_full text;
    v_passenger uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('CREATE_BOOKING_ITEM');

    if p_first_name is null or p_family_name is null then
        raise exception 'first_name and family_name are required';
    end if;

    if not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'passenger_type' and code = p_passenger_type_code
    ) then
        raise exception 'unknown passenger_type_code: %', p_passenger_type_code;
    end if;

    if p_customer_id is not null and not exists (
        select 1 from public.customers where id = p_customer_id and tenant_id = v_tenant
    ) then
        raise exception 'customer is not in your tenant';
    end if;

    -- Reference-data (nationalities/countries) is only partially seeded; validate with a friendly
    -- message when provided rather than surfacing a raw FK error.
    if p_nationality_code is not null and not exists (
        select 1 from public.nationalities where code = p_nationality_code
    ) then
        raise exception 'unknown nationality_code: %', p_nationality_code;
    end if;
    if p_passport_issuing_country_code is not null and not exists (
        select 1 from public.countries where code = p_passport_issuing_country_code
    ) then
        raise exception 'unknown passport_issuing_country_code: %', p_passport_issuing_country_code;
    end if;

    if p_passport_issue_date is not null and p_passport_expiry_date is not null
       and p_passport_issue_date >= p_passport_expiry_date then
        raise exception 'passport issue date must be before expiry date';
    end if;

    v_full := coalesce(nullif(trim(p_full_name), ''), p_first_name || ' ' || p_family_name);

    insert into public.passengers (
        tenant_id, customer_id, first_name, family_name, full_name, passenger_type_code,
        relationship_to_customer_code, date_of_birth, nationality_code, passport_number,
        passport_issue_date, passport_expiry_date, passport_issuing_country_code
    )
    values (
        v_tenant, p_customer_id, p_first_name, p_family_name, v_full, p_passenger_type_code,
        p_relationship_to_customer_code, p_date_of_birth, p_nationality_code, p_passport_number,
        p_passport_issue_date, p_passport_expiry_date, p_passport_issuing_country_code
    )
    returning id into v_passenger;

    return v_passenger;
end;
$$;
grant execute on function app.create_passenger(
    text, text, text, text, uuid, text, date, text, text, date, date, text
) to authenticated;
