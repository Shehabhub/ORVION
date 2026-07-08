-- Migration: issue_invoice
-- Phase 6 (Finance Core). app.issue_invoice moves a customer invoice draft -> issued, the point at which
-- it becomes a live RECEIVABLE that app.customer_balance counts (balance reads issued/partially_paid/
-- paid/overdue). Only a draft may be issued; partially_paid/paid/overdue are payment-driven (later
-- payment-allocation slice) and voided/archived invoices are terminal here. The invoice number was already
-- assigned at create (SPEC-100), so issuing is purely the status finalisation + event.
--
-- Auth: CREATE_INVOICE (owner/ceo/finance_manager) -- issuing is part of the invoice authority already
-- granted to finance; no new permission is minted (Earn-It / ADR-0015). If operational experience shows
-- issue authority must diverge from create, mint an ISSUE_INVOICE permission then, with evidence.
-- SECURITY INVOKER; RLS backstop. Emits invoice_issued. No table/schema change.
create or replace function app.issue_invoice(
    p_invoice_id uuid,
    p_reason text default null
)
returns text
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_inv record;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    select id, status_code, invoice_number, customer_id, currency_code, total_amount,
           voided_at, is_archived
      into v_inv
    from public.invoices
    where id = p_invoice_id and tenant_id = v_tenant;
    if not found then
        raise exception 'invoice is not in your tenant';
    end if;
    if v_inv.is_archived or v_inv.voided_at is not null then
        raise exception 'invoice is archived or voided';
    end if;
    if v_inv.status_code <> 'draft' then
        raise exception 'only a draft invoice can be issued (is %)', v_inv.status_code;
    end if;

    perform app.authorize('CREATE_INVOICE');

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    update public.invoices
    set status_code = 'issued',
        updated_at = now()
    where id = p_invoice_id;

    perform app.record_event(
        v_tenant, 'invoice_issued', 'invoice', p_invoice_id, v_actor,
        'draft', 'issued', p_reason,
        jsonb_build_object('invoice_number', v_inv.invoice_number, 'customer_id', v_inv.customer_id,
                           'currency_code', v_inv.currency_code, 'total_amount', v_inv.total_amount),
        'info'
    );

    return 'issued';
end;
$$;
grant execute on function app.issue_invoice(uuid, text) to authenticated;
