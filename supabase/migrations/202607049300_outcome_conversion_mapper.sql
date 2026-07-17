-- Migration: outcome_conversion_mapper (Phase 8 — canon 21 "Engine Responsibilities": receive
-- CRM outcomes, create internal conversion records).
-- Consumes the events backbone via the seq cursor (mig 049000 — its designed first consumer)
-- and maps verified outcomes to offline_conversions rows. Scheduler decision (ADR-0018/0023,
-- n8n-first): NO pg_cron — n8n invokes the mapper at the start of its delivery workflow
-- (map -> claim -> send -> ack), so one orchestrator drives the whole pipeline and no new
-- extension/infrastructure is introduced. Any future scheduler can call the same RPC.
-- Idempotency: source_event_seq provenance column + unique index — an event maps at most once.
-- Value semantics: revenue on payment_received (payments.amount), never profit (ADR-0023).

-- 1. Provenance for idempotent mapping.
alter table public.offline_conversions
    add column source_event_seq bigint;
create unique index offline_conversions_source_event_seq_idx
    on public.offline_conversions (source_event_seq)
    where source_event_seq is not null;

-- 2. Cursor store (platform infra, not tenant data: RLS enabled with no policies = locked to
--    service paths; SECURITY DEFINER functions and service_role only).
create table public.integration_cursors (
    name text primary key,
    last_seq bigint not null default 0,
    updated_at timestamptz not null default now()
);
alter table public.integration_cursors enable row level security;
create trigger integration_cursors_set_updated_at
    before update on public.integration_cursors
    for each row execute function moddatetime(updated_at);
insert into public.integration_cursors (name) values ('outcome_conversion_mapper');

-- 3. The mapper. SECURITY DEFINER (reads events across tenants; writes tenant-tagged rows).
--    Mapping (canon 21): lead_qualified -> qualified_lead · booking_created -> booking_created ·
--    payment_recorded -> payment_received (value = amount) · booking_issued -> ticket_issued.
--    Only leads carrying a first-touch attribution_click_id (SPEC-119) produce conversions;
--    consent is NOT checked here — the claim RPC is the single consent gate (One Authority).
create or replace function app.map_outcomes_to_conversions(p_batch integer default 500)
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
    v_cursor bigint;
    v_max_seq bigint;
    v_inserted integer := 0;
begin
    select last_seq into v_cursor
    from public.integration_cursors
    where name = 'outcome_conversion_mapper'
    for update;

    select max(sub.seq) into v_max_seq from (
        select e.seq from public.events e
        where e.seq > v_cursor
          and e.event_type_code in
              ('lead_qualified', 'booking_created', 'payment_recorded', 'booking_issued')
        order by e.seq
        limit p_batch
    ) sub;
    if v_max_seq is null then
        return 0;   -- nothing new
    end if;

    with batch as (
        select e.seq, e.tenant_id, e.event_type_code, e.entity_type, e.entity_id, e.payload,
               e.created_at
        from public.events e
        where e.seq > v_cursor
          and e.event_type_code in
              ('lead_qualified', 'booking_created', 'payment_recorded', 'booking_issued')
        order by e.seq
        limit p_batch
    ),
    resolved as (
        select b.seq, b.tenant_id, b.created_at,
               case b.event_type_code
                   when 'lead_qualified'   then 'qualified_lead'
                   when 'booking_created'  then 'booking_created'
                   when 'payment_recorded' then 'payment_received'
                   when 'booking_issued'   then 'ticket_issued'
               end as conversion_type,
               coalesce(
                   case when b.event_type_code = 'lead_qualified' then b.entity_id end,
                   case when b.event_type_code = 'booking_created'
                        then (b.payload ->> 'lead_id')::uuid end,
                   case when b.event_type_code = 'booking_issued' then bk.lead_id end,
                   case when b.event_type_code = 'payment_recorded' then pbk.lead_id end
               ) as lead_id,
               case when b.event_type_code = 'payment_recorded' then p.id end as payment_id,
               case when b.event_type_code in ('booking_created', 'booking_issued')
                    then b.entity_id
                    when b.event_type_code = 'payment_recorded' then p.booking_id end as booking_id,
               case when b.event_type_code = 'payment_recorded' then p.amount end as conv_value,
               case when b.event_type_code = 'payment_recorded' then p.currency_code end as conv_ccy
        from batch b
        left join public.bookings bk
               on b.event_type_code = 'booking_issued' and bk.id = b.entity_id
        left join public.payments p
               on b.event_type_code = 'payment_recorded' and p.id = b.entity_id
        left join public.bookings pbk
               on p.booking_id = pbk.id
    )
    insert into public.offline_conversions
        (tenant_id, lead_id, booking_id, payment_id, attribution_click_id,
         conversion_event_type_code, conversion_value, currency_code,
         conversion_at, source_event_seq)
    select r.tenant_id, l.id, r.booking_id, r.payment_id, l.attribution_click_id,
           r.conversion_type, r.conv_value, r.conv_ccy, r.created_at, r.seq
    from resolved r
    join public.leads l on l.id = r.lead_id
    where l.attribution_click_id is not null
    on conflict (source_event_seq) where source_event_seq is not null do nothing;

    get diagnostics v_inserted = row_count;

    update public.integration_cursors
    set last_seq = v_max_seq, updated_at = now()
    where name = 'outcome_conversion_mapper';

    return v_inserted;
end;
$$;
revoke execute on function app.map_outcomes_to_conversions(integer) from public, authenticated;
grant execute on function app.map_outcomes_to_conversions(integer) to orvion_integration;
