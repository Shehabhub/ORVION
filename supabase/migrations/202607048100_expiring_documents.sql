-- Migration: expiring_documents
-- Phase 7 (Documents). app.expiring_documents is the derived, read-only query behind document expiry alerts
-- (16: official document types -- passport/national_id/visa/medical_certificate -- must support expiry;
-- "Expiry alerts are controlled by notification rules"). Returns non-archived documents whose expires_at
-- falls on or before now + p_within_days (so BOTH already-expired and soon-to-expire are surfaced), with
-- days_until_expiry (negative = already expired). The actual alerting/notification is a separate scheduled
-- workload (ADR-0018) that consumes this query.
--
-- Read-only: no writes, no events. STABLE, SECURITY INVOKER; RLS on documents is the only access gate,
-- following the read-RPC precedent (no app.authorize on a pure read). No table/schema change.
create or replace function app.expiring_documents(
    p_within_days integer default 30
)
returns table (
    document_id uuid,
    document_type_code text,
    title text,
    expires_at timestamptz,
    days_until_expiry integer,
    is_confidential boolean
)
language plpgsql
stable
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    if p_within_days is null or p_within_days < 0 then
        raise exception 'p_within_days must be zero or positive';
    end if;

    return query
    select
        d.id,
        d.document_type_code,
        d.title,
        d.expires_at,
        (d.expires_at::date - current_date) as days_until_expiry,
        d.is_confidential
    from public.documents d
    where d.tenant_id = v_tenant
      and d.expires_at is not null
      and d.is_archived = false
      and d.lifecycle_status_code <> 'archived'
      and d.expires_at <= now() + make_interval(days => p_within_days)
    order by d.expires_at;
end;
$$;
grant execute on function app.expiring_documents(integer) to authenticated;
