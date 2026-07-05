-- Migration: create_marketing_and_offline_conversion_tables
-- Plan reference: 33_sql_migration_plan.md migration 17
-- Creates marketing_campaigns, campaign_daily_metrics, attribution_clicks, offline_conversions,
-- offline_conversion_deliveries per 31 section 10 and 30. currency_code -> currencies; other FKs to
-- tenants/leads/bookings/booking_items/payments/marketing_campaigns/attribution_clicks. Platform/
-- status/source/event codes plain text (SPEC-030). Money columns (spend_amount, revenue_amount,
-- conversion_value) numeric(14,2); count metrics numeric per 31. attribution_clicks precedes
-- offline_conversions (offline_conversions.attribution_click_id references it). updated_at triggers on
-- marketing_campaigns and campaign_daily_metrics only.

create table marketing_campaigns (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    platform_code text not null,
    external_campaign_id text,
    campaign_name text not null,
    status_code text,
    started_at timestamptz,
    ended_at timestamptz,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table campaign_daily_metrics (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    marketing_campaign_id uuid not null references marketing_campaigns (id) on delete restrict on update no action,
    metric_date date not null,
    spend_amount numeric(14, 2),
    currency_code text references currencies (code) on delete restrict on update no action,
    impressions numeric,
    clicks numeric,
    leads_count numeric,
    bookings_count numeric,
    revenue_amount numeric(14, 2),
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table attribution_clicks (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    lead_id uuid references leads (id) on delete restrict on update no action,
    attribution_source_code text not null,
    marketing_campaign_id uuid references marketing_campaigns (id) on delete restrict on update no action,
    gclid text,
    session_id text,
    click_id text,
    landing_page_url text,
    utm_source text,
    utm_medium text,
    utm_campaign text,
    utm_content text,
    utm_term text,
    clicked_at timestamptz not null default now(),
    created_at timestamptz not null default now()
);

create table offline_conversions (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    lead_id uuid references leads (id) on delete restrict on update no action,
    booking_id uuid references bookings (id) on delete restrict on update no action,
    booking_item_id uuid references booking_items (id) on delete restrict on update no action,
    payment_id uuid references payments (id) on delete restrict on update no action,
    attribution_click_id uuid references attribution_clicks (id) on delete restrict on update no action,
    marketing_campaign_id uuid references marketing_campaigns (id) on delete restrict on update no action,
    conversion_event_type_code text not null,
    conversion_value numeric(14, 2),
    currency_code text references currencies (code) on delete restrict on update no action,
    conversion_at timestamptz not null default now(),
    created_at timestamptz not null default now()
);

create table offline_conversion_deliveries (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    offline_conversion_id uuid not null references offline_conversions (id) on delete restrict on update no action,
    platform_code text not null,
    delivery_status_code text not null,
    attempt_number integer not null default 1,
    sent_at timestamptz,
    failed_at timestamptz,
    response_payload jsonb,
    error_message text,
    created_at timestamptz not null default now()
);

-- Indexes (30 Index Standard: FKs, tenant filtering).
create index marketing_campaigns_tenant_id_idx on marketing_campaigns (tenant_id);
create index campaign_daily_metrics_campaign_date_idx on campaign_daily_metrics (marketing_campaign_id, metric_date);
create index campaign_daily_metrics_tenant_id_idx on campaign_daily_metrics (tenant_id);
create index attribution_clicks_tenant_id_idx on attribution_clicks (tenant_id);
create index attribution_clicks_lead_id_idx on attribution_clicks (lead_id);
create index attribution_clicks_marketing_campaign_id_idx on attribution_clicks (marketing_campaign_id);
create index offline_conversions_tenant_id_idx on offline_conversions (tenant_id);
create index offline_conversions_lead_id_idx on offline_conversions (lead_id);
create index offline_conversions_booking_id_idx on offline_conversions (booking_id);
create index offline_conversions_marketing_campaign_id_idx on offline_conversions (marketing_campaign_id);
create index offline_conversion_deliveries_conversion_id_idx on offline_conversion_deliveries (offline_conversion_id);

-- updated_at triggers (marketing_campaigns, campaign_daily_metrics have updated_at).
create trigger marketing_campaigns_set_updated_at before update on marketing_campaigns for each row execute function moddatetime(updated_at);
create trigger campaign_daily_metrics_set_updated_at before update on campaign_daily_metrics for each row execute function moddatetime(updated_at);
