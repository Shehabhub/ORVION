-- Migration: customer_identity
-- Phase 4 (CRM Core). Customer creation + duplicate detection (05_customer_identity).
--   * app.find_customer_duplicates(...) -- read-only candidate search across identity signals.
--   * app.create_customer(...)          -- CREATE_CUSTOMER-gated; seeds identity signals; enforces
--                                          the "primary phone unique within tenant unless an approved
--                                          exception exists" rule via a duplicate guard + override.
-- Duplicate detection uses identity signals (phone / whatsapp / email / passport / official document),
-- never name alone (05). The sensitive merge (MERGE_CUSTOMER_IDENTITY, must emit an event and re-point
-- references) is a separate deferred CR. SECURITY INVOKER; RLS is the backstop. No table/schema change.

-- Candidate search: returns tenant customers matching any provided identity signal. Read-only; RLS
-- limits visibility to the caller's tenant. Matches on the customers' own primary_phone/primary_email
-- and on recorded customer_identity_signals.
create or replace function app.find_customer_duplicates(
    p_phone text default null,
    p_email text default null,
    p_whatsapp text default null,
    p_passport_number text default null,
    p_document_number text default null
)
returns table (customer_id uuid, full_name text, matched_signal_type text, matched_value text)
language sql
stable
security invoker
set search_path = ''
as $$
    -- direct profile fields
    select c.id, c.full_name, 'phone'::text, c.primary_phone
    from public.customers c
    where c.is_archived = false and p_phone is not null and c.primary_phone = p_phone
    union
    select c.id, c.full_name, 'email'::text, c.primary_email
    from public.customers c
    where c.is_archived = false and p_email is not null and c.primary_email = p_email
    union
    -- recorded identity signals
    select c.id, c.full_name, s.signal_type_code, s.signal_value
    from public.customer_identity_signals s
    join public.customers c on c.id = s.customer_id and c.is_archived = false
    where (s.signal_type_code in ('phone','whatsapp') and s.signal_value = p_phone)
       or (s.signal_type_code in ('phone','whatsapp') and s.signal_value = p_whatsapp)
       or (s.signal_type_code = 'email' and s.signal_value = p_email)
       or (s.signal_type_code = 'passport_number' and s.signal_value = p_passport_number)
       or (s.signal_type_code = 'official_document_number' and s.signal_value = p_document_number);
$$;
grant execute on function app.find_customer_duplicates(text, text, text, text, text) to authenticated;

-- Create a customer within the caller's tenant. Guarded by CREATE_CUSTOMER via app.authorize (MFA
-- composes). Enforces primary-phone uniqueness in-tenant (05) unless p_allow_duplicate = true (the
-- "approved exception", available to any CREATE_CUSTOMER holder). Seeds identity signals from the
-- primary phone / whatsapp / email so future duplicate detection has data to match on.
create or replace function app.create_customer(
    p_customer_type_code text,
    p_full_name text,
    p_first_name text default null,
    p_family_name text default null,
    p_company_name text default null,
    p_primary_phone text default null,
    p_primary_email text default null,
    p_whatsapp text default null,
    p_preferred_language_code text default null,
    p_preferred_contact_method_code text default null,
    p_marketing_opt_in boolean default false,
    p_branch_id uuid default null,
    p_allow_duplicate boolean default false
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_customer uuid;
    v_dupe uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('CREATE_CUSTOMER');

    if not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'customer_type' and code = p_customer_type_code
    ) then
        raise exception 'unknown customer_type_code: %', p_customer_type_code;
    end if;

    if p_preferred_contact_method_code is not null and not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'contact_method_type' and code = p_preferred_contact_method_code
    ) then
        raise exception 'unknown preferred_contact_method_code: %', p_preferred_contact_method_code;
    end if;

    if p_branch_id is not null and not exists (
        select 1 from public.branches where id = p_branch_id and tenant_id = v_tenant
    ) then
        raise exception 'branch is not in your tenant';
    end if;

    -- Primary-phone uniqueness (05): unique in-tenant unless an approved exception is requested.
    if p_primary_phone is not null and not p_allow_duplicate then
        select id into v_dupe from public.customers
        where tenant_id = v_tenant and is_archived = false and primary_phone = p_primary_phone
        limit 1;
        if v_dupe is not null then
            raise exception 'duplicate primary phone for customer %; pass p_allow_duplicate to override', v_dupe
                using errcode = 'unique_violation';
        end if;
    end if;

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    insert into public.customers (
        tenant_id, customer_type_code, first_name, family_name, full_name, company_name,
        primary_phone, primary_email, preferred_language_code, preferred_contact_method_code,
        marketing_opt_in, first_registered_branch_id, created_by
    )
    values (
        v_tenant, p_customer_type_code, p_first_name, p_family_name, p_full_name, p_company_name,
        p_primary_phone, p_primary_email, p_preferred_language_code, p_preferred_contact_method_code,
        p_marketing_opt_in, p_branch_id, v_actor
    )
    returning id into v_customer;

    -- Seed identity signals (only for provided values) so duplicate detection has data to match on.
    insert into public.customer_identity_signals (tenant_id, customer_id, signal_type_code, signal_value)
    select v_tenant, v_customer, t.st, t.sv
    from (values
        ('phone',    p_primary_phone),
        ('whatsapp', p_whatsapp),
        ('email',    p_primary_email)
    ) as t(st, sv)
    where t.sv is not null;

    return v_customer;
end;
$$;
grant execute on function app.create_customer(
    text, text, text, text, text, text, text, text, text, text, boolean, uuid, boolean
) to authenticated;
