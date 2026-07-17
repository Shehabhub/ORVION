-- Migration: events_consumer_cursor
-- 10-year architecture review (2026-07-17), Fundamental-Domain-Structure (AGENTS §3):
-- the event backbone will feed n8n/automation consumers ("every business event reusable
-- across future automations" — owner vision). An at-least-once consumer needs a stable,
-- gapless-enough monotonic cursor; uuid PKs don't sort and created_at has ties. A bigint
-- identity column is the standard outbox/CDC watermark. Inevitable structure, trivially
-- additive while the tables are empty; adding it to a populated multi-million-row events
-- table later forces a full-table rewrite. Applied to both append-only audit tables.
alter table public.events
    add column seq bigint generated always as identity;
alter table public.security_events
    add column seq bigint generated always as identity;

-- Consumer read path: WHERE seq > :cursor ORDER BY seq. (tenant_id, seq) serves the
-- tenant-scoped variant; RLS still gates rows.
create unique index events_seq_idx on public.events (seq);
create unique index security_events_seq_idx on public.security_events (seq);
create index events_tenant_seq_idx on public.events (tenant_id, seq);
