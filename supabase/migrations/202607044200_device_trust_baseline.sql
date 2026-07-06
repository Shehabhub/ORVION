-- Migration: device_trust_baseline
-- Phase 3 (Identity & Access) -- "Device trust baseline". RPCs over the ORVION-owned trusted_devices
-- table (ADR-0017; Principles 1/6: device trust is a Human-Identity artifact keyed to auth.users,
-- with no tenant/membership). SECURITY INVOKER: owner-only RLS (migration 19) is the backstop and
-- every operation is scoped to the caller's auth.uid(). No table/schema change.

-- Register (or refresh) a trusted device for the calling human. Idempotent per (auth_user_id,
-- device_identifier): re-recording updates last_seen_at rather than duplicating. Returns device id.
create or replace function app.record_trusted_device(p_device_identifier text)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_uid uuid := (select auth.uid());
    v_id uuid;
begin
    if v_uid is null then
        raise exception 'not authenticated';
    end if;

    update public.trusted_devices
    set last_seen_at = now(),
        status_code = 'trusted',
        verified_at = coalesce(verified_at, now()),
        revoked_at = null
    where auth_user_id = v_uid and device_identifier = p_device_identifier
    returning id into v_id;

    if v_id is null then
        insert into public.trusted_devices (auth_user_id, device_identifier, status_code, verified_at)
        values (v_uid, p_device_identifier, 'trusted', now())
        returning id into v_id;
    end if;

    return v_id;
end;
$$;
grant execute on function app.record_trusted_device(text) to authenticated;

-- List the calling human's trusted devices.
create or replace function app.my_trusted_devices()
returns table (
    id uuid,
    device_identifier text,
    status_code text,
    first_seen_at timestamptz,
    last_seen_at timestamptz,
    verified_at timestamptz,
    revoked_at timestamptz
)
language sql
stable
security invoker
set search_path = ''
as $$
    select d.id, d.device_identifier, d.status_code, d.first_seen_at, d.last_seen_at,
           d.verified_at, d.revoked_at
    from public.trusted_devices d
    where d.auth_user_id = (select auth.uid())
    order by d.last_seen_at desc;
$$;
grant execute on function app.my_trusted_devices() to authenticated;

-- Revoke one of the calling human's trusted devices.
create or replace function app.revoke_trusted_device(p_device_id uuid)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_uid uuid := (select auth.uid());
    v_id uuid;
begin
    if v_uid is null then
        raise exception 'not authenticated';
    end if;

    update public.trusted_devices
    set status_code = 'revoked', revoked_at = now()
    where id = p_device_id and auth_user_id = v_uid
    returning id into v_id;

    if v_id is null then
        raise exception 'device not found';
    end if;
end;
$$;
grant execute on function app.revoke_trusted_device(uuid) to authenticated;
