-- Migration: create_booking_core_tables
-- Plan reference: 33_sql_migration_plan.md migration 10
-- Creates quotations, quotation_items, bookings, booking_items, booking_item_passengers,
-- internal_supplier_links, exchange_rate_adjustments per 31 sections 3-5 and 30.
-- currency_code -> currencies; bookings.destination_country_code -> countries (SPEC-037);
-- booking_items.exchange_rate_id -> exchange_rates (migration 6). Status/type/reason codes plain
-- text (SPEC-030). Money numeric(14,2); commission_rate numeric(5,2). CHECK: booking_items and
-- booking_item_passengers non-negative amounts (31 Rules). internal_supplier_links follows
-- booking_items. Archive fields on quotations/bookings/booking_items.

create table quotations (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    lead_id uuid references leads (id) on delete restrict on update no action,
    customer_id uuid not null references customers (id) on delete restrict on update no action,
    owner_user_id uuid references users (id) on delete restrict on update no action,
    owner_department_id uuid references departments (id) on delete restrict on update no action,
    owner_branch_id uuid references branches (id) on delete restrict on update no action,
    quotation_status_code text not null,
    quotation_number text not null,
    currency_code text not null references currencies (code) on delete restrict on update no action,
    total_amount numeric(14, 2) not null default 0,
    valid_until timestamptz,
    sent_at timestamptz,
    accepted_at timestamptz,
    rejected_at timestamptz,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text
);

create table quotation_items (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    quotation_id uuid not null references quotations (id) on delete restrict on update no action,
    service_type_code text not null,
    description text,
    quantity numeric(14, 2) not null default 1,
    unit_price numeric(14, 2) not null default 0,
    total_amount numeric(14, 2) not null default 0,
    currency_code text not null references currencies (code) on delete restrict on update no action,
    created_at timestamptz not null default now()
);

create table bookings (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    branch_id uuid not null references branches (id) on delete restrict on update no action,
    department_id uuid not null references departments (id) on delete restrict on update no action,
    owner_user_id uuid references users (id) on delete restrict on update no action,
    owner_department_id uuid references departments (id) on delete restrict on update no action,
    owner_branch_id uuid references branches (id) on delete restrict on update no action,
    lead_id uuid references leads (id) on delete restrict on update no action,
    quotation_id uuid references quotations (id) on delete restrict on update no action,
    customer_id uuid not null references customers (id) on delete restrict on update no action,
    booking_status_code text not null,
    title text not null,
    booking_reference text not null,
    travel_start_date date,
    travel_end_date date,
    destination_country_code text references countries (code) on delete restrict on update no action,
    destination_city text,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    completed_at timestamptz,
    cancelled_at timestamptz,
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text
);

create table booking_items (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    booking_id uuid not null references bookings (id) on delete restrict on update no action,
    service_type_code text not null,
    base_status_code text not null,
    sub_status_code text,
    supplier_id uuid references suppliers (id) on delete restrict on update no action,
    operational_owner_user_id uuid references users (id) on delete restrict on update no action,
    owner_user_id uuid references users (id) on delete restrict on update no action,
    owner_department_id uuid references departments (id) on delete restrict on update no action,
    owner_branch_id uuid references branches (id) on delete restrict on update no action,
    sales_owner_user_id uuid references users (id) on delete restrict on update no action,
    sales_owner_department_id uuid references departments (id) on delete restrict on update no action,
    sales_owner_branch_id uuid references branches (id) on delete restrict on update no action,
    currency_code text not null references currencies (code) on delete restrict on update no action,
    cost_amount numeric(14, 2) not null default 0,
    selling_amount numeric(14, 2) not null default 0,
    commission_rate numeric(5, 2),
    exchange_rate_id uuid references exchange_rates (id) on delete restrict on update no action,
    finance_approval_required boolean not null default false,
    finance_approval_status_code text,
    cancellation_reason_code text,
    cancelled_at timestamptz,
    cancelled_by uuid references users (id) on delete restrict on update no action,
    no_show_at timestamptz,
    no_show_recorded_by uuid references users (id) on delete restrict on update no action,
    cost_locked_at timestamptz,
    issued_at timestamptz,
    completed_at timestamptz,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text,
    constraint booking_items_amounts_nonneg_check check (cost_amount >= 0 and selling_amount >= 0)
);

create table booking_item_passengers (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    booking_item_id uuid not null references booking_items (id) on delete restrict on update no action,
    passenger_id uuid not null references passengers (id) on delete restrict on update no action,
    selling_amount_override numeric(14, 2),
    cost_amount_override numeric(14, 2),
    created_at timestamptz not null default now(),
    constraint booking_item_passengers_item_passenger_key unique (booking_item_id, passenger_id),
    constraint booking_item_passengers_overrides_nonneg_check check (
        (selling_amount_override is null or selling_amount_override >= 0)
        and (cost_amount_override is null or cost_amount_override >= 0)
    )
);

create table internal_supplier_links (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    booking_item_id uuid not null references booking_items (id) on delete restrict on update no action,
    provider_branch_id uuid not null references branches (id) on delete restrict on update no action,
    provider_department_id uuid not null references departments (id) on delete restrict on update no action,
    requester_branch_id uuid not null references branches (id) on delete restrict on update no action,
    requester_department_id uuid not null references departments (id) on delete restrict on update no action,
    created_at timestamptz not null default now()
);

create table exchange_rate_adjustments (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    booking_item_id uuid not null references booking_items (id) on delete restrict on update no action,
    original_exchange_rate_id uuid not null references exchange_rates (id) on delete restrict on update no action,
    new_exchange_rate_id uuid not null references exchange_rates (id) on delete restrict on update no action,
    reason_code text,
    reason_text text,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now()
);

-- Indexes (30 Index Standard: FKs, tenant filtering, status).
create index quotations_tenant_status_idx on quotations (tenant_id, quotation_status_code);
create index quotations_customer_id_idx on quotations (customer_id);
create index quotation_items_quotation_id_idx on quotation_items (quotation_id);
create index bookings_tenant_status_idx on bookings (tenant_id, booking_status_code);
create index bookings_customer_id_idx on bookings (customer_id);
create index booking_items_booking_id_idx on booking_items (booking_id);
create index booking_items_tenant_status_idx on booking_items (tenant_id, base_status_code);
create index booking_items_supplier_id_idx on booking_items (supplier_id);
create index booking_item_passengers_passenger_id_idx on booking_item_passengers (passenger_id);
create index internal_supplier_links_booking_item_id_idx on internal_supplier_links (booking_item_id);
create index exchange_rate_adjustments_booking_item_id_idx on exchange_rate_adjustments (booking_item_id);

-- updated_at triggers (quotations, bookings, booking_items have updated_at).
create trigger quotations_set_updated_at before update on quotations for each row execute function moddatetime(updated_at);
create trigger bookings_set_updated_at before update on bookings for each row execute function moddatetime(updated_at);
create trigger booking_items_set_updated_at before update on booking_items for each row execute function moddatetime(updated_at);
