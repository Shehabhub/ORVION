-- Migration: offline_conversion_core (Phase 8 first slice — ADR-0023)
-- ORVION-side core of the offline-conversion engine (canon 21): conversion recording +
-- the n8n-facing database outbox (claim/ack) over offline_conversions/_deliveries.
-- Division of responsibility per ADR-0023: ORVION owns truth/state (mapping, consent gate,
-- delivery state, retry bookkeeping); n8n is a stateless caller that claims, hashes at the
-- edge, calls Google Data Manager API, and acks. Consent is enforced IN the database so no
-- orchestration bug can ship an unconsented row. Channel-generic via platform_code
-- (Meta CAPI reuses this mechanism in Phase 10). Canon-21 critical rule holds: CRM state
-- never depends on delivery success.

-- 1. Integration role: the identity n8n (and future orchestrators) connect with.
--    Created NOLOGIN; an operator enables login + sets the password outside the repo
--    (secrets never in migrations). Grants are function-level only — no table access.
do $$
begin
    if not exists (select 1 from pg_roles where rolname = 'orvion_integration') then
        create role orvion_integration nologin;
    end if;
end
$$;

-- 2. Record a conversion (tenant-scoped; marketing owns conversions per canon 28).
--    Emits offline_conversion_created. Value semantics: REVENUE, never profit (ADR-0023).
create or replace function app.record_offline_conversion(
    p_conversion_event_type_code text,
    p_lead_id uuid default null,
    p_booking_id uuid default null,
    p_booking_item_id uuid default null,
    p_payment_id uuid default null,
    p_attribution_click_id uuid default null,
    p_marketing_campaign_id uuid default null,
    p_conversion_value numeric default null,
    p_currency_code text default null,
    p_conversion_at timestamptz default now()
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_id uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('MANAGE_MARKETING_CAMPAIGN');

    if not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'offline_conversion_event_type'
          and code = p_conversion_event_type_code
    ) then
        raise exception 'unknown conversion_event_type_code: %', p_conversion_event_type_code;
    end if;
    if p_conversion_value is not null and p_conversion_value < 0 then
        raise exception 'conversion_value must be non-negative';
    end if;
    if p_conversion_value is not null and p_currency_code is null then
        raise exception 'currency_code is required when conversion_value is set';
    end if;
    if p_attribution_click_id is not null and not exists (
        select 1 from public.attribution_clicks
        where id = p_attribution_click_id and tenant_id = v_tenant
    ) then
        raise exception 'attribution click is not in your tenant';
    end if;
    if p_lead_id is not null and not exists (
        select 1 from public.leads where id = p_lead_id and tenant_id = v_tenant
    ) then
        raise exception 'lead is not in your tenant';
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    insert into public.offline_conversions (
        tenant_id, lead_id, booking_id, booking_item_id, payment_id,
        attribution_click_id, marketing_campaign_id,
        conversion_event_type_code, conversion_value, currency_code, conversion_at
    ) values (
        v_tenant, p_lead_id, p_booking_id, p_booking_item_id, p_payment_id,
        p_attribution_click_id, p_marketing_campaign_id,
        p_conversion_event_type_code, p_conversion_value, p_currency_code, p_conversion_at
    )
    returning id into v_id;

    perform app.record_event(
        v_tenant, 'offline_conversion_created', 'offline_conversion', v_id, v_actor,
        null, 'created', null,
        jsonb_build_object('conversion_event_type_code', p_conversion_event_type_code,
                           'conversion_value', p_conversion_value,
                           'currency_code', p_currency_code,
                           'lead_id', p_lead_id),
        'info'
    );
    return v_id;
end;
$$;
grant execute on function app.record_offline_conversion(text, uuid, uuid, uuid, uuid, uuid, uuid, numeric, text, timestamptz)
    to authenticated;

-- 3. Outbox CLAIM (integration role only). SECURITY DEFINER: reads across tenants; returns
--    only tenant-tagged work items. Claimable = has an attribution click with
--    consent_ad_user_data = 'granted' (in-DB consent gate, SPEC-119) AND no pending/sent
--    delivery for the platform AND fewer than 5 attempts.
--    ponytail: fixed retry ceiling of 5; move to reporting-style config if policy ever varies.
create or replace function app.claim_conversion_deliveries(
    p_platform_code text,
    p_batch integer default 50
)
returns table (
    delivery_id uuid,
    conversion_id uuid,
    tenant_id uuid,
    conversion_event_type_code text,
    conversion_value numeric,
    currency_code text,
    conversion_at timestamptz,
    gclid text,
    gbraid text,
    wbraid text,
    consent_ad_user_data text,
    consent_ad_personalization text,
    customer_phone text,
    customer_email text,
    attempt_number integer
)
language plpgsql
security definer
set search_path = ''
as $$
begin
    return query
    with claimable as (
        select oc.id, oc.tenant_id
        from public.offline_conversions oc
        join public.attribution_clicks ac
          on ac.id = oc.attribution_click_id
         and ac.consent_ad_user_data = 'granted'
        where not exists (
                select 1 from public.offline_conversion_deliveries d
                where d.offline_conversion_id = oc.id
                  and d.platform_code = p_platform_code
                  and d.delivery_status_code in ('pending', 'sent')
              )
          and (select count(*) from public.offline_conversion_deliveries d2
               where d2.offline_conversion_id = oc.id
                 and d2.platform_code = p_platform_code) < 5
        order by oc.conversion_at
        limit p_batch
        for update of oc skip locked
    ),
    retire_failed as (
        -- previous failed attempt becomes 'retried' the moment a new attempt is claimed
        update public.offline_conversion_deliveries d
        set delivery_status_code = 'retried'
        from claimable c
        where d.offline_conversion_id = c.id
          and d.platform_code = p_platform_code
          and d.delivery_status_code = 'failed'
    ),
    new_deliveries as (
        insert into public.offline_conversion_deliveries
            (tenant_id, offline_conversion_id, platform_code, delivery_status_code, attempt_number)
        select c.tenant_id, c.id, p_platform_code, 'pending',
               coalesce((select max(d.attempt_number)
                         from public.offline_conversion_deliveries d
                         where d.offline_conversion_id = c.id
                           and d.platform_code = p_platform_code), 0) + 1
        from claimable c
        returning offline_conversion_deliveries.id,
                  offline_conversion_deliveries.offline_conversion_id,
                  offline_conversion_deliveries.tenant_id,
                  offline_conversion_deliveries.attempt_number
    )
    select nd.id, oc.id, oc.tenant_id,
           oc.conversion_event_type_code, oc.conversion_value, oc.currency_code, oc.conversion_at,
           ac.gclid, ac.gbraid, ac.wbraid, ac.consent_ad_user_data, ac.consent_ad_personalization,
           cu.primary_phone, cu.primary_email,
           nd.attempt_number
    from new_deliveries nd
    join public.offline_conversions oc on oc.id = nd.offline_conversion_id
    left join public.attribution_clicks ac on ac.id = oc.attribution_click_id
    left join public.leads l on l.id = oc.lead_id
    left join public.customers cu on cu.id = l.customer_id;
end;
$$;
revoke execute on function app.claim_conversion_deliveries(text, integer) from public, authenticated;
grant execute on function app.claim_conversion_deliveries(text, integer) to orvion_integration;

-- 4. Outbox ACK (integration role only). pending -> sent | failed; emits the canonical event.
create or replace function app.record_conversion_delivery_result(
    p_delivery_id uuid,
    p_success boolean,
    p_response jsonb default null,
    p_error text default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
    v_d record;
begin
    select * into v_d
    from public.offline_conversion_deliveries
    where id = p_delivery_id
    for update;
    if not found then
        raise exception 'unknown delivery id: %', p_delivery_id;
    end if;
    if v_d.delivery_status_code <> 'pending' then
        raise exception 'delivery % is % — only pending deliveries can be resolved',
            p_delivery_id, v_d.delivery_status_code;
    end if;

    update public.offline_conversion_deliveries
    set delivery_status_code = case when p_success then 'sent' else 'failed' end,
        sent_at   = case when p_success then now() else sent_at end,
        failed_at = case when p_success then failed_at else now() end,
        response_payload = p_response,
        error_message = p_error
    where id = p_delivery_id;

    perform app.record_event(
        v_d.tenant_id,
        case when p_success then 'offline_conversion_sent' else 'offline_conversion_failed' end,
        'offline_conversion', v_d.offline_conversion_id, null,
        'pending', case when p_success then 'sent' else 'failed' end, p_error,
        jsonb_build_object('platform_code', v_d.platform_code,
                           'attempt_number', v_d.attempt_number,
                           'delivery_id', p_delivery_id),
        case when p_success then 'info' else 'warning' end
    );
end;
$$;
revoke execute on function app.record_conversion_delivery_result(uuid, boolean, jsonb, text) from public, authenticated;
grant execute on function app.record_conversion_delivery_result(uuid, boolean, jsonb, text) to orvion_integration;
