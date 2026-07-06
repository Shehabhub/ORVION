-- Migration: activate_membership
-- Phase 3 (Identity & Access) -- invitation/activation. Links an authenticated Supabase identity
-- (auth.users) to its pre-created, unlinked users membership(s) by matching the caller's
-- Supabase-verified email. Supabase Auth owns the invite (token + email delivery); ORVION only
-- performs the membership-claim binding. SECURITY DEFINER because the caller has no membership yet
-- and thus cannot see/update the waiting users row under RLS. No schema change.
create or replace function app.activate_membership()
returns table (membership_id uuid, tenant_id uuid, tenant_name text, is_active boolean)
language plpgsql
security definer
set search_path = ''
as $$
declare
    v_uid uuid := (select auth.uid());
    v_email text;
begin
    if v_uid is null then
        raise exception 'not authenticated';
    end if;

    select email into v_email from auth.users where id = v_uid;
    if v_email is null then
        raise exception 'no verified email for caller';
    end if;

    -- Claim every unlinked, active membership for the caller's verified email. The caller's
    -- auth.users row exists only after Supabase verified this email, so the match is an
    -- authorization proof. Bounded to one row per tenant by users_tenant_email_key.
    update public.users u
    set auth_user_id = v_uid
    where lower(u.email) = lower(v_email)
      and u.auth_user_id is null
      and u.is_active;

    -- Return the caller's memberships (same shape as app.my_memberships()); idempotent.
    return query
    select u.id, u.tenant_id, t.name, u.is_active
    from public.users u
    join public.tenants t on t.id = u.tenant_id
    where u.auth_user_id = v_uid
    order by t.name;
end;
$$;
grant execute on function app.activate_membership() to authenticated;
