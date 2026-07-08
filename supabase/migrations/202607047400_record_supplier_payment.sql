-- Migration: record_supplier_payment
-- Phase 6 (Finance Core). app.record_supplier_payment records a payment ORVION makes to an external
-- supplier (payment_direction_code = 'supplier_payment'), drawing down app.supplier_balance. There is no
-- supplier-bill table to allocate against (payables are derived from booking-item cost), so a supplier
-- payment is recorded directly against the supplier (optionally scoped to a booking); over-payment is
-- allowed (supplier prepayment/credit is legitimate and simply makes the payable negative).
--
-- Auth: RECORD_PAYMENT (owner/ceo/finance_manager, seeded -- same authority as customer payments).
-- SECURITY INVOKER; RLS backstop. Emits supplier_payment_recorded. No table/schema change.
create or replace function app.record_supplier_payment(
    p_supplier_id uuid,
    p_amount numeric,
    p_currency_code text,
    p_payment_method_code text,
    p_booking_id uuid default null,
    p_paid_at timestamptz default now(),
    p_reference_number text default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_payment_id uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    if p_amount is null or p_amount <= 0 then
        raise exception 'payment amount must be greater than zero';
    end if;
    if not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'payment_method' and code = p_payment_method_code
    ) then
        raise exception 'unknown payment_method: %', p_payment_method_code;
    end if;

    perform 1 from public.suppliers where id = p_supplier_id and tenant_id = v_tenant;
    if not found then
        raise exception 'supplier is not in your tenant';
    end if;
    if p_booking_id is not null then
        perform 1 from public.bookings where id = p_booking_id and tenant_id = v_tenant;
        if not found then
            raise exception 'booking is not in your tenant';
        end if;
    end if;

    perform app.authorize('RECORD_PAYMENT');

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    insert into public.payments (
        tenant_id, payment_direction_code, supplier_id, booking_id, currency_code,
        payment_method_code, reference_number, amount, paid_at, received_by, created_by
    ) values (
        v_tenant, 'supplier_payment', p_supplier_id, p_booking_id, p_currency_code,
        p_payment_method_code, p_reference_number, p_amount, p_paid_at, v_actor, v_actor
    ) returning id into v_payment_id;

    perform app.record_event(
        v_tenant, 'supplier_payment_recorded', 'payment', v_payment_id, v_actor,
        null, 'supplier_payment', p_reference_number,
        jsonb_build_object('supplier_id', p_supplier_id, 'booking_id', p_booking_id,
                           'amount', p_amount, 'currency_code', p_currency_code),
        'info'
    );

    return v_payment_id;
end;
$$;
grant execute on function app.record_supplier_payment(uuid, numeric, text, text, uuid, timestamptz, text) to authenticated;
