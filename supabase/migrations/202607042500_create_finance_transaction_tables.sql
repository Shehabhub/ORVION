-- Migration: create_finance_transaction_tables
-- Plan reference: 33_sql_migration_plan.md migration 12
-- Creates journal_entries, journal_entry_lines, invoices, payments, payment_allocations, receipts,
-- refunds, approval_requests, company_assets per 31 section 5 and 30. currency_code -> currencies;
-- chart_account_id -> chart_of_accounts; financial_account_id -> financial_accounts; exchange_rate_id
-- -> exchange_rates (migration 6). Status/type/method/direction/reason codes plain text (SPEC-030).
-- Money numeric(14,2). CHECK: journal_entry_lines exactly one of debit/credit populated (31 Rules).
-- Polymorphic source_entity_id / related_entity_id are plain columns (no FK). updated_at triggers on
-- invoices, payments, refunds, company_assets only.

create table journal_entries (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    source_type_code text not null,
    source_entity_id uuid,
    entry_date date not null,
    description text,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    is_voided boolean not null default false,
    voided_at timestamptz,
    voided_by uuid references users (id) on delete restrict on update no action,
    void_reason text
);

create table journal_entry_lines (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    journal_entry_id uuid not null references journal_entries (id) on delete restrict on update no action,
    chart_account_id uuid not null references chart_of_accounts (id) on delete restrict on update no action,
    debit_amount numeric(14, 2) not null default 0,
    credit_amount numeric(14, 2) not null default 0,
    currency_code text not null references currencies (code) on delete restrict on update no action,
    description text,
    created_at timestamptz not null default now(),
    constraint journal_entry_lines_debit_xor_credit_check check (
        debit_amount >= 0 and credit_amount >= 0
        and ((debit_amount > 0 and credit_amount = 0) or (credit_amount > 0 and debit_amount = 0))
    )
);

create table invoices (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    customer_id uuid not null references customers (id) on delete restrict on update no action,
    booking_id uuid references bookings (id) on delete restrict on update no action,
    booking_item_id uuid references booking_items (id) on delete restrict on update no action,
    invoice_number text not null,
    invoice_date date not null,
    due_date date,
    currency_code text not null references currencies (code) on delete restrict on update no action,
    total_amount numeric(14, 2) not null default 0,
    status_code text not null,
    voided_at timestamptz,
    voided_by uuid references users (id) on delete restrict on update no action,
    void_reason text,
    external_submission_id text,
    external_submission_status_code text,
    external_submitted_at timestamptz,
    external_response_at timestamptz,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text
);

create table payments (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    payment_direction_code text not null,
    customer_id uuid references customers (id) on delete restrict on update no action,
    supplier_id uuid references suppliers (id) on delete restrict on update no action,
    booking_id uuid references bookings (id) on delete restrict on update no action,
    booking_item_id uuid references booking_items (id) on delete restrict on update no action,
    financial_account_id uuid references financial_accounts (id) on delete restrict on update no action,
    payment_method_code text not null,
    reference_number text,
    currency_code text not null references currencies (code) on delete restrict on update no action,
    amount numeric(14, 2) not null default 0,
    paid_at timestamptz not null default now(),
    received_by uuid references users (id) on delete restrict on update no action,
    verified_by uuid references users (id) on delete restrict on update no action,
    verified_at timestamptz,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table payment_allocations (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    payment_id uuid not null references payments (id) on delete restrict on update no action,
    invoice_id uuid not null references invoices (id) on delete restrict on update no action,
    allocated_amount numeric(14, 2) not null default 0,
    currency_code text not null references currencies (code) on delete restrict on update no action,
    exchange_rate_id uuid references exchange_rates (id) on delete restrict on update no action,
    allocated_amount_invoice_currency numeric(14, 2),
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now()
);

create table receipts (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    payment_id uuid not null references payments (id) on delete restrict on update no action,
    receipt_number text not null,
    issued_at timestamptz not null default now(),
    external_submission_id text,
    external_submission_status_code text,
    external_submitted_at timestamptz,
    external_response_at timestamptz,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now()
);

create table refunds (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    payment_direction_code text not null,
    original_payment_id uuid references payments (id) on delete restrict on update no action,
    customer_id uuid references customers (id) on delete restrict on update no action,
    supplier_id uuid references suppliers (id) on delete restrict on update no action,
    booking_id uuid references bookings (id) on delete restrict on update no action,
    booking_item_id uuid references booking_items (id) on delete restrict on update no action,
    refund_reason_code text,
    currency_code text not null references currencies (code) on delete restrict on update no action,
    amount numeric(14, 2) not null default 0,
    refund_status_code text not null,
    requested_at timestamptz not null default now(),
    completed_at timestamptz,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table approval_requests (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    approval_type_code text not null,
    approval_status_code text not null,
    requested_by uuid references users (id) on delete restrict on update no action,
    reviewed_by uuid references users (id) on delete restrict on update no action,
    related_entity_type text,
    related_entity_id uuid,
    booking_item_id uuid references booking_items (id) on delete restrict on update no action,
    document_id uuid references documents (id) on delete restrict on update no action,
    requested_at timestamptz not null default now(),
    reviewed_at timestamptz,
    reason text,
    rejection_reason text,
    payload jsonb
);

create table company_assets (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    name text not null,
    asset_type text not null,
    purchase_date date,
    purchase_amount numeric(14, 2),
    currency_code text references currencies (code) on delete restrict on update no action,
    status text not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

-- Indexes (30 Index Standard: FKs, tenant filtering, status).
create index journal_entries_tenant_id_idx on journal_entries (tenant_id);
create index journal_entry_lines_journal_entry_id_idx on journal_entry_lines (journal_entry_id);
create index journal_entry_lines_chart_account_id_idx on journal_entry_lines (chart_account_id);
create index invoices_tenant_status_idx on invoices (tenant_id, status_code);
create index invoices_customer_id_idx on invoices (customer_id);
create index invoices_booking_id_idx on invoices (booking_id);
create index payments_tenant_id_idx on payments (tenant_id);
create index payments_customer_id_idx on payments (customer_id);
create index payments_supplier_id_idx on payments (supplier_id);
create index payments_booking_id_idx on payments (booking_id);
create index payment_allocations_payment_id_idx on payment_allocations (payment_id);
create index payment_allocations_invoice_id_idx on payment_allocations (invoice_id);
create index receipts_payment_id_idx on receipts (payment_id);
create index refunds_tenant_status_idx on refunds (tenant_id, refund_status_code);
create index refunds_original_payment_id_idx on refunds (original_payment_id);
create index refunds_customer_id_idx on refunds (customer_id);
create index approval_requests_tenant_status_idx on approval_requests (tenant_id, approval_status_code);
create index approval_requests_booking_item_id_idx on approval_requests (booking_item_id);
create index approval_requests_document_id_idx on approval_requests (document_id);
create index company_assets_tenant_id_idx on company_assets (tenant_id);

-- updated_at triggers (invoices, payments, refunds, company_assets have updated_at).
create trigger invoices_set_updated_at before update on invoices for each row execute function moddatetime(updated_at);
create trigger payments_set_updated_at before update on payments for each row execute function moddatetime(updated_at);
create trigger refunds_set_updated_at before update on refunds for each row execute function moddatetime(updated_at);
create trigger company_assets_set_updated_at before update on company_assets for each row execute function moddatetime(updated_at);
