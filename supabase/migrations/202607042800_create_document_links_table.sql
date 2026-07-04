-- Migration: create_document_links_table
-- Plan reference: 33_sql_migration_plan.md migration 15
-- Creates document_links per 31 section 6 and 30. The single latest-dependent table: links a
-- document to exactly one business entity across passengers, quotations, bookings, booking_items,
-- invoices, receipts, suppliers, subscription_payment_proofs. document_id is the source document
-- (not a target). All FKs restrict/no-action. 31 Rule "exactly one target FK per row" is enforced as
-- a DB CHECK. No updated_at, so no trigger.

create table document_links (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    document_id uuid not null references documents (id) on delete restrict on update no action,
    passenger_id uuid references passengers (id) on delete restrict on update no action,
    booking_id uuid references bookings (id) on delete restrict on update no action,
    booking_item_id uuid references booking_items (id) on delete restrict on update no action,
    invoice_id uuid references invoices (id) on delete restrict on update no action,
    quotation_id uuid references quotations (id) on delete restrict on update no action,
    receipt_id uuid references receipts (id) on delete restrict on update no action,
    supplier_id uuid references suppliers (id) on delete restrict on update no action,
    subscription_payment_proof_id uuid references subscription_payment_proofs (id) on delete restrict on update no action,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    constraint document_links_single_target_check check (
        (
            (passenger_id is not null)::int
            + (booking_id is not null)::int
            + (booking_item_id is not null)::int
            + (invoice_id is not null)::int
            + (quotation_id is not null)::int
            + (receipt_id is not null)::int
            + (supplier_id is not null)::int
            + (subscription_payment_proof_id is not null)::int
        ) = 1
    )
);

-- Indexes (30 Index Standard: source and target FKs for reverse lookups).
create index document_links_document_id_idx on document_links (document_id);
create index document_links_passenger_id_idx on document_links (passenger_id);
create index document_links_booking_id_idx on document_links (booking_id);
create index document_links_booking_item_id_idx on document_links (booking_item_id);
create index document_links_invoice_id_idx on document_links (invoice_id);
create index document_links_quotation_id_idx on document_links (quotation_id);
create index document_links_receipt_id_idx on document_links (receipt_id);
create index document_links_supplier_id_idx on document_links (supplier_id);
create index document_links_subscription_payment_proof_id_idx on document_links (subscription_payment_proof_id);
