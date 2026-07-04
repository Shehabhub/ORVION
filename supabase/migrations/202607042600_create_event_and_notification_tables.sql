-- Migration: create_event_and_notification_tables
-- Plan reference: 33_sql_migration_plan.md migration 13
-- Creates events, security_events, notifications, notification_deliveries per 31 section 7 and 30.
-- events/security_events use polymorphic entity fields (no FK beyond tenant_id/actor). tenant_id is
-- nullable on events and security_events (platform-level rows). Type/severity/channel/status codes
-- plain text (SPEC-030). payload jsonb. ip_address uses native inet type. No table here carries
-- updated_at, so there are no moddatetime triggers. DB-enforced event immutability is deferred to
-- the RLS migration (19) per reports/future-backlog.md.

create table events (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid references tenants (id) on delete restrict on update no action,
    event_type_code text not null,
    severity_code text not null,
    actor_user_id uuid references users (id) on delete restrict on update no action,
    entity_type text not null,
    entity_id uuid not null,
    previous_state text,
    new_state text,
    reason text,
    payload jsonb,
    created_at timestamptz not null default now()
);

create table security_events (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid references tenants (id) on delete restrict on update no action,
    user_id uuid references users (id) on delete restrict on update no action,
    security_event_type_code text not null,
    ip_address inet,
    user_agent text,
    payload jsonb,
    created_at timestamptz not null default now()
);

create table notifications (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    target_user_id uuid not null references users (id) on delete restrict on update no action,
    notification_type_code text not null,
    title text not null,
    body text not null,
    related_entity_type text,
    related_entity_id uuid,
    is_read boolean not null default false,
    created_at timestamptz not null default now(),
    read_at timestamptz
);

create table notification_deliveries (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    notification_id uuid not null references notifications (id) on delete restrict on update no action,
    channel_code text not null,
    delivery_status_code text not null,
    sent_at timestamptz,
    failed_at timestamptz,
    error_message text,
    created_at timestamptz not null default now()
);

-- Indexes (31 events index spec; 30 Index Standard for the rest).
create index events_tenant_entity_idx on events (tenant_id, entity_type, entity_id, created_at);
create index events_tenant_type_idx on events (tenant_id, event_type_code, created_at);
create index security_events_tenant_id_idx on security_events (tenant_id, created_at);
create index security_events_user_id_idx on security_events (user_id);
create index notifications_target_user_idx on notifications (target_user_id, is_read);
create index notifications_tenant_id_idx on notifications (tenant_id);
create index notification_deliveries_notification_id_idx on notification_deliveries (notification_id);
