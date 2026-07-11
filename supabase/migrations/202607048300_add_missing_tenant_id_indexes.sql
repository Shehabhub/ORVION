-- Migration: add_missing_tenant_id_indexes
-- Plan reference: 30_database_conventions.md "Index Standard" (Expected useful indexes: tenant_id);
--   ARB finding A2 (MASTER_GAP_REGISTER / MASTER_EXECUTION_PLAN Batch 1).
--
-- Every row-level-security policy filters by `tenant_id = app.current_tenant_id()`, so an
-- unindexed tenant_id column forces a sequential scan on every tenant-scoped query. Canon
-- names tenant_id as the first "expected useful index"; 18 tenant tables were built without
-- one. This migration closes that canon-vs-built gap. It is additive (indexes only) — no
-- table, column, type, relationship, or data changes.
--
-- Scope note: only the bare tenant_id index that canon names unambiguously is added here.
-- Composite refinements (tenant_id + status / customer_id / booking_id) are per-access-pattern
-- and are added by the capabilities that exercise those paths, not speculatively.

create index if not exists booking_item_passengers_tenant_id_idx        on public.booking_item_passengers (tenant_id);
create index if not exists branch_business_hours_tenant_id_idx          on public.branch_business_hours (tenant_id);
create index if not exists conversation_messages_tenant_id_idx          on public.conversation_messages (tenant_id);
create index if not exists customer_contact_methods_tenant_id_idx       on public.customer_contact_methods (tenant_id);
create index if not exists customer_identity_merges_tenant_id_idx       on public.customer_identity_merges (tenant_id);
create index if not exists customer_identity_signals_tenant_id_idx      on public.customer_identity_signals (tenant_id);
create index if not exists customer_notes_tenant_id_idx                 on public.customer_notes (tenant_id);
create index if not exists document_links_tenant_id_idx                 on public.document_links (tenant_id);
create index if not exists exchange_rate_adjustments_tenant_id_idx      on public.exchange_rate_adjustments (tenant_id);
create index if not exists internal_supplier_links_tenant_id_idx        on public.internal_supplier_links (tenant_id);
create index if not exists journal_entry_lines_tenant_id_idx            on public.journal_entry_lines (tenant_id);
create index if not exists lead_assignments_tenant_id_idx              on public.lead_assignments (tenant_id);
create index if not exists lead_interactions_tenant_id_idx             on public.lead_interactions (tenant_id);
create index if not exists notification_deliveries_tenant_id_idx       on public.notification_deliveries (tenant_id);
create index if not exists offline_conversion_deliveries_tenant_id_idx on public.offline_conversion_deliveries (tenant_id);
create index if not exists payment_allocations_tenant_id_idx           on public.payment_allocations (tenant_id);
create index if not exists quotation_items_tenant_id_idx               on public.quotation_items (tenant_id);
create index if not exists user_role_assignments_tenant_id_idx         on public.user_role_assignments (tenant_id);
