-- Migration: capture_attribution_click (Phase 8 — canon 21 §Captured Click Data / Attribution Flow)
-- Landing-page ingestion: a click is captured BEFORE (or at) lead creation, typically pre-auth,
-- so this is called server-side by the integration path (n8n receiving the GTM/landing webhook)
-- with an explicit tenant — SECURITY DEFINER, integration-role-only, no reliance on a JWT tenant.
-- Writes an attribution_clicks row and, when a lead is already known, sets the lead's first-touch
-- anchor (leads.attribution_click_id) only if still null (first-touch wins; idempotent). Consent is
-- stored as captured (SPEC-119 domain); it is NOT enforced here — the claim RPC is the single
-- consent gate (One Authority, ADR-0023).

create or replace function app.capture_attribution_click(
    p_tenant_id uuid,
    p_attribution_source_code text,
    p_gclid text default null,
    p_gbraid text default null,
    p_wbraid text default null,
    p_session_id text default null,
    p_click_id text default null,
    p_landing_page_url text default null,
    p_utm_source text default null,
    p_utm_medium text default null,
    p_utm_campaign text default null,
    p_utm_content text default null,
    p_utm_term text default null,
    p_consent_ad_user_data text default 'unspecified',
    p_consent_ad_personalization text default 'unspecified',
    p_marketing_campaign_id uuid default null,
    p_lead_id uuid default null,
    p_clicked_at timestamptz default now()
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
    v_click uuid;
begin
    if p_tenant_id is null then
        raise exception 'tenant_id is required';
    end if;
    if not exists (select 1 from public.tenants where id = p_tenant_id) then
        raise exception 'unknown tenant: %', p_tenant_id;
    end if;
    if not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'attribution_source' and code = p_attribution_source_code
    ) then
        raise exception 'unknown attribution_source_code: %', p_attribution_source_code;
    end if;
    -- consent domain mirrors the attribution_clicks CHECK (granted/denied/unspecified)
    if p_consent_ad_user_data not in ('granted','denied','unspecified')
       or p_consent_ad_personalization not in ('granted','denied','unspecified') then
        raise exception 'consent values must be granted|denied|unspecified';
    end if;
    if p_marketing_campaign_id is not null and not exists (
        select 1 from public.marketing_campaigns
        where id = p_marketing_campaign_id and tenant_id = p_tenant_id
    ) then
        raise exception 'marketing campaign is not in this tenant';
    end if;
    if p_lead_id is not null and not exists (
        select 1 from public.leads where id = p_lead_id and tenant_id = p_tenant_id
    ) then
        raise exception 'lead is not in this tenant';
    end if;

    insert into public.attribution_clicks (
        tenant_id, lead_id, attribution_source_code, marketing_campaign_id,
        gclid, gbraid, wbraid, session_id, click_id, landing_page_url,
        utm_source, utm_medium, utm_campaign, utm_content, utm_term,
        consent_ad_user_data, consent_ad_personalization, clicked_at
    ) values (
        p_tenant_id, p_lead_id, p_attribution_source_code, p_marketing_campaign_id,
        p_gclid, p_gbraid, p_wbraid, p_session_id, p_click_id, p_landing_page_url,
        p_utm_source, p_utm_medium, p_utm_campaign, p_utm_content, p_utm_term,
        p_consent_ad_user_data, p_consent_ad_personalization, p_clicked_at
    )
    returning id into v_click;

    -- First-touch anchor: attach to the lead only if it has none yet.
    if p_lead_id is not null then
        update public.leads
        set attribution_click_id = v_click
        where id = p_lead_id and attribution_click_id is null;
    end if;

    perform app.record_event(
        p_tenant_id, 'attribution_click_captured', 'attribution_click', v_click, null,
        null, null, null,
        jsonb_build_object('attribution_source_code', p_attribution_source_code,
                           'has_gclid', p_gclid is not null,
                           'lead_id', p_lead_id,
                           'consent_ad_user_data', p_consent_ad_user_data),
        'info'
    );
    return v_click;
end;
$$;
revoke execute on function app.capture_attribution_click(uuid, text, text, text, text, text, text, text, text, text, text, text, text, text, text, uuid, uuid, timestamptz) from public, authenticated;
grant execute on function app.capture_attribution_click(uuid, text, text, text, text, text, text, text, text, text, text, text, text, text, text, uuid, uuid, timestamptz) to orvion_integration;
