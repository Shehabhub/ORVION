-- Migration: journal_entries
-- Phase 6 (Finance Core). Basic double-entry journal entries (07/14 Finance Lite "Basic journal entries").
-- Two RPCs:
--   * app.seed_default_chart_of_accounts() -- seeds the caller tenant's DEFAULT chart of accounts. The
--     chart is per-tenant (chart_of_accounts.tenant_id) and canon 14 makes it customizable per company, so
--     this is a starting default (is_system_default = true), not a locked decision. The minimal set is the
--     researched travel-agency Finance-Lite structure (asset/liability/equity/revenue/expense: bank, AR, AP,
--     customer trust deposits, equity, sales revenue, service fees, cost of sales, operating expenses,
--     refunds/returns). account_type is plain text (ADR-0006). Idempotent on (tenant_id, code).
--   * app.create_journal_entry(source_type, entry_date, description, lines jsonb, source_entity_id?) --
--     records a balanced entry: inserts journal_entries + journal_entry_lines from a jsonb array
--     [{account_code, debit, credit, currency, description?}], enforcing sum(debit) = sum(credit) > 0 and
--     that every line references an existing in-tenant chart account with exactly one non-zero side.
--
-- Auth: CREATE_JOURNAL_ENTRY (owner/ceo/finance_manager, seeded). SECURITY INVOKER; RLS backstop. Emits
-- journal_entry_created. Additive: one unique index + two RPCs; no table/column change.

create unique index if not exists chart_of_accounts_tenant_code_key
    on public.chart_of_accounts (tenant_id, code);

create or replace function app.seed_default_chart_of_accounts()
returns integer
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_count integer;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    perform app.authorize('CREATE_JOURNAL_ENTRY');

    insert into public.chart_of_accounts (tenant_id, code, name, account_type, is_system_default)
    select v_tenant, c.code, c.name, c.account_type, true
    from (values
        ('1000', 'Bank / Cash',                'asset'),
        ('1100', 'Accounts Receivable',        'asset'),
        ('2000', 'Accounts Payable',           'liability'),
        ('2100', 'Customer Deposits (Trust)',  'liability'),
        ('3000', 'Owner Equity',               'equity'),
        ('4000', 'Sales Revenue',              'revenue'),
        ('4100', 'Service Fees',               'revenue'),
        ('4900', 'Refunds / Sales Returns',    'revenue'),
        ('5000', 'Cost of Sales',              'expense'),
        ('6000', 'Operating Expenses',         'expense')
    ) as c(code, name, account_type)
    on conflict (tenant_id, code) do nothing;

    get diagnostics v_count = row_count;
    return v_count;
end;
$$;
grant execute on function app.seed_default_chart_of_accounts() to authenticated;

create or replace function app.create_journal_entry(
    p_source_type_code text,
    p_entry_date date,
    p_description text,
    p_lines jsonb,
    p_source_entity_id uuid default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_entry_id uuid;
    v_line jsonb;
    v_debit numeric;
    v_credit numeric;
    v_total_debit numeric := 0;
    v_total_credit numeric := 0;
    v_account_id uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    if p_lines is null or jsonb_typeof(p_lines) <> 'array' or jsonb_array_length(p_lines) < 2 then
        raise exception 'a journal entry requires at least two lines (a jsonb array)';
    end if;

    perform app.authorize('CREATE_JOURNAL_ENTRY');

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    insert into public.journal_entries (tenant_id, source_type_code, source_entity_id, entry_date, description, created_by)
    values (v_tenant, p_source_type_code, p_source_entity_id, p_entry_date, p_description, v_actor)
    returning id into v_entry_id;

    for v_line in select * from jsonb_array_elements(p_lines)
    loop
        v_debit := coalesce((v_line->>'debit')::numeric, 0);
        v_credit := coalesce((v_line->>'credit')::numeric, 0);
        if v_debit < 0 or v_credit < 0 then
            raise exception 'debit/credit amounts must be non-negative';
        end if;
        if (v_debit > 0) = (v_credit > 0) then
            raise exception 'each line must have exactly one of debit or credit greater than zero';
        end if;

        select id into v_account_id
        from public.chart_of_accounts
        where tenant_id = v_tenant and code = (v_line->>'account_code') and is_active;
        if v_account_id is null then
            raise exception 'unknown or inactive chart account code: %', (v_line->>'account_code');
        end if;

        insert into public.journal_entry_lines (
            tenant_id, journal_entry_id, chart_account_id, debit_amount, credit_amount,
            currency_code, description
        ) values (
            v_tenant, v_entry_id, v_account_id, v_debit, v_credit,
            v_line->>'currency', v_line->>'description'
        );

        v_total_debit := v_total_debit + v_debit;
        v_total_credit := v_total_credit + v_credit;
    end loop;

    if v_total_debit <> v_total_credit then
        raise exception 'journal entry is not balanced: debits % <> credits %', v_total_debit, v_total_credit;
    end if;
    if v_total_debit = 0 then
        raise exception 'journal entry total must be greater than zero';
    end if;

    perform app.record_event(
        v_tenant, 'journal_entry_created', 'journal_entry', v_entry_id, v_actor,
        null, p_source_type_code, p_description,
        jsonb_build_object('total_amount', v_total_debit, 'line_count', jsonb_array_length(p_lines)),
        'info'
    );

    return v_entry_id;
end;
$$;
grant execute on function app.create_journal_entry(text, date, text, jsonb, uuid) to authenticated;
