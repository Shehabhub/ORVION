-- Migration: issue_receipt
-- Phase 6 (Finance Core). app.issue_receipt issues a receipt document for a recorded payment (07/14
-- Finance Lite "Receipts"): one receipt per payment, with a per-tenant, year-prefixed, DB-unique
-- sequential number 'RCP-YYYY-NNNN'. Same numbering discipline as invoices (SPEC-100): unique + sequential
-- + per-tenant + year-prefixed, not gapless (researched legal/industry practice), race-safe via a
-- per-(tenant,year) advisory lock. A payment may have at most one receipt (unique index on (tenant,payment)).
--
-- Auth: CREATE_RECEIPT (owner/ceo/finance_manager, seeded). SECURITY INVOKER; RLS backstop. Emits
-- receipt_issued. Additive: two partial-free unique indexes + one RPC; no table/column change.

create unique index if not exists receipts_tenant_number_key
    on public.receipts (tenant_id, receipt_number);
create unique index if not exists receipts_tenant_payment_key
    on public.receipts (tenant_id, payment_id);

create or replace function app.issue_receipt(
    p_payment_id uuid
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_pay record;
    v_year text := to_char(now(), 'YYYY');
    v_seq integer;
    v_number text;
    v_receipt_id uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    select id, customer_id, currency_code, amount
      into v_pay
    from public.payments
    where id = p_payment_id and tenant_id = v_tenant;
    if not found then
        raise exception 'payment is not in your tenant';
    end if;

    if exists (select 1 from public.receipts
               where payment_id = p_payment_id and tenant_id = v_tenant) then
        raise exception 'a receipt already exists for this payment';
    end if;

    perform app.authorize('CREATE_RECEIPT');

    -- Per-(tenant,year) receipt number allocation; gaps acceptable, collisions not.
    perform pg_advisory_xact_lock(hashtextextended(v_tenant::text || ':RCP:' || v_year, 0));
    select coalesce(max(split_part(r.receipt_number, '-', 3)::integer), 0) + 1
      into v_seq
    from public.receipts r
    where r.tenant_id = v_tenant
      and r.receipt_number like 'RCP-' || v_year || '-%';
    v_number := 'RCP-' || v_year || '-' || lpad(v_seq::text, 4, '0');

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    insert into public.receipts (tenant_id, payment_id, receipt_number, created_by)
    values (v_tenant, p_payment_id, v_number, v_actor)
    returning id into v_receipt_id;

    perform app.record_event(
        v_tenant, 'receipt_issued', 'receipt', v_receipt_id, v_actor,
        null, 'issued', null,
        jsonb_build_object('receipt_number', v_number, 'payment_id', p_payment_id,
                           'customer_id', v_pay.customer_id, 'currency_code', v_pay.currency_code,
                           'amount', v_pay.amount),
        'info'
    );

    return v_receipt_id;
end;
$$;
grant execute on function app.issue_receipt(uuid) to authenticated;
