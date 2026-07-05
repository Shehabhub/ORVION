# SQL Migration Plan

Version: 0.2
Status: Draft
Canonical: Yes

---

# Purpose

This document defines the ordered sequence of SQL migration files for ORVION's first database foundation, before any SQL is written. It is the deliverable named by `32_execution_roadmap.md` Phase 2's "Immediate Next Action: Create SQL migration plan."

It does not contain SQL. It does not resolve open business or technical decisions — those are listed in `# Blocked Items` below and must be resolved separately before the migrations they block can be written.

---

# Method

Every table in `31_schema_draft.md` (71 tables across 11 categories) was checked for every foreign-key-shaped column it declares, including nullable ones — a nullable column with a foreign key constraint still requires its target table to already exist at constraint-creation time. Migrations are grouped and ordered so no migration creates a constraint referencing a table that does not yet exist.

---

# Migration Sequence

Filenames follow `30_database_conventions.md`'s Migration Rule (`YYYYMMDDHHMM_description.sql`). The `NN` placeholder below is an ordinal, not a timestamp — actual timestamps are assigned when each migration file is written.

| # | Filename pattern | Tables | Depends on (#) | Notes |
| --- | --- | --- | --- | --- |
| 1 | `NN_enable_extensions.sql` | — (enables `pgcrypto`) | — | Required before any `gen_random_uuid()` default. |
| 2 | `NN_create_system_catalog_tables.sql` | `catalog_types`, `catalog_values` | 1 | No dependencies on business tables. |
| 3 | `NN_create_reference_tables.sql` | `currencies` | 1 | No dependencies. |
| 3b | `NN_create_geo_reference_tables.sql` | `countries`, `languages`, `nationalities` | 1 | Reference data layer (SPEC-037), inserted before migration 8 (CRM core); natural-key tables like `currencies`, seeded later. |
| 4 | `NN_create_organization_tables.sql` | `tenants`, `branches`, `departments`, `branch_business_hours`, `holidays` | 1 | `tenants` is the isolation root. |
| 5 | `NN_create_identity_and_access_tables.sql` | `users`, `roles`, `permissions`, `role_permissions`, `user_branch_assignments`, `user_role_assignments` | 4 | `users` migration content is unblocked — relationship in `31_schema_draft.md` `# 13. Review Required` item 3; physical column pattern (`auth_user_id`, not a shared `id`) in `30_database_conventions.md`'s Identity Key Standard. |
| 6 | `NN_create_finance_foundation_tables.sql` | `exchange_rates`, `chart_of_accounts`, `financial_accounts` | 4 | Moved earlier than the main Finance group because `booking_items.exchange_rate_id` (migration 10) requires `exchange_rates` first. |
| 7 | `NN_create_document_core_tables.sql` | `documents` (FK to `document_versions` deferred), `document_versions`, then `ALTER TABLE documents ADD CONSTRAINT` for `current_version_id` | 4 | Resolves the mutual reference between `documents` and `document_versions`: neither can be created first with its FK intact, so `documents.current_version_id`'s constraint is deferred until after `document_versions` exists. |
| 8 | `NN_create_crm_core_tables.sql` | `customers`, `customer_contact_methods`, `customer_identity_signals`, `customer_identity_merges`, `customer_notes`, `leads`, `lead_assignments`, `lead_interactions` | 4, 5 | `customers` before `leads` within this migration (`leads.customer_id` is nullable; `customers` has no dependency on `leads`). |
| 9 | `NN_create_suppliers_and_passengers_tables.sql` | `suppliers`, `passengers` | 4, 8 | Both needed by Booking (migration 10). |
| 10 | `NN_create_booking_core_tables.sql` | `quotations`, `quotation_items`, `bookings`, `booking_items`, `booking_item_passengers`, `internal_supplier_links`, `exchange_rate_adjustments` | 6, 8, 9 | `internal_supplier_links.booking_item_id` is non-nullable, so it must follow `booking_items` within this migration. |
| 11 | `NN_create_crm_extension_tables.sql` | `tasks`, `complaints`, `service_requests`, `conversations`, `conversation_messages` | 8, 10 | `complaints`/`service_requests`/`conversations` carry nullable `booking_id`/`booking_item_id` FKs and cannot be created until Booking exists, despite being described earlier in `31_schema_draft.md`'s document order. |
| 12 | `NN_create_finance_transaction_tables.sql` | `journal_entries`, `journal_entry_lines`, `invoices`, `payments`, `payment_allocations`, `receipts`, `refunds`, `approval_requests`, `company_assets` | 6, 7, 8, 10 | `approval_requests` needs both `booking_items` (10) and `documents` (7). |
| 13 | `NN_create_event_and_notification_tables.sql` | `events`, `security_events`, `notifications`, `notification_deliveries` | 4 | `events`/`security_events` use polymorphic fields, not real FKs beyond `tenant_id`. |
| 14 | `NN_create_subscription_tables.sql` | `subscription_plans`, `feature_entitlements`, `subscriptions`, `subscription_payment_proofs`, `usage_counters` | 4, 7 | `subscription_payment_proofs.document_id` requires `documents` (7). |
| 15 | `NN_create_document_links_table.sql` | `document_links` | 7, 9, 10, 12, 14 | The single latest-dependent table in the schema: needs `quotations`/`bookings`/`booking_items` (10), `suppliers` (9), `invoices`/`receipts` (12), and `subscription_payment_proofs` (14). |
| 16 | `NN_create_authentication_support_tables.sql` | `trusted_devices`, `otp_challenges`, `totp_enrollments` | 1 | Amended per `34_authentication_and_identity_principles.md`: all key to `auth_user_id` referencing `auth.users(id)` (Human Identity), not to `users`/`tenant_id`. Depends only on the `auth` schema (migration 1 enables extensions; `auth.users` is provided by Supabase). `on delete cascade` to the human identity. |
| 17 | `NN_create_marketing_and_offline_conversion_tables.sql` | `marketing_campaigns`, `campaign_daily_metrics`, `attribution_clicks`, `offline_conversions`, `offline_conversion_deliveries` | 8, 10, 12 | `offline_conversions` carries nullable FKs to `leads`, `bookings`/`booking_items`, and `payments`. |
| 18 | `NN_seed_system_catalogs.sql` | seed data only, no DDL | 2 | Populates `catalog_values` from `25_catalog_registry.md`. Not blocked — see `# Recommended (Non-Blocking)` regarding `event_type_code`, which requires no catalog and is simply not seeded from one. |
| 19 | `NN_create_rls_policies.sql` | RLS policies on every tenant-owned table | all preceding | Unblocked — resolved via `31_schema_draft.md` `# 13. Review Required` item 3 (`auth.uid()` plus a `SECURITY DEFINER` lookup function against ORVION RBAC tables; no JWT claims) and `30_database_conventions.md`'s Identity Key Standard (lookup function must use `auth_user_id`, not `id`). |
| 20 | Database verification checklist | — | all preceding | Roadmap Phase 2 explicitly lists this as a distinct Output from the migrations themselves; format (SQL smoke-test script vs. documentation checklist) is not decided by this plan. |

---

# Blocked Items

None currently. Both items originally listed here — the `users`/Supabase Auth integration strategy and the RLS enforcement mechanism — were resolved by approved architectural decision; see `31_schema_draft.md` `# 13. Review Required` item 3 for the relationship and authorization architecture, and `30_database_conventions.md`'s Identity Key Standard for the physical key pattern the RLS lookup function must use.

---

# Recommended (Non-Blocking)

The following was originally drafted as a blocking item and was reclassified after architectural review. It does not block any migration in the sequence above and may be decided on any timeline.

## `events.event_type_code` / `severity_code` catalog governance

No `event_type` catalog exists in `25_catalog_registry.md` for the roughly 150 event names defined in `27_event_catalog.md`. This does not block migration 5, 18, or 19: `30_database_conventions.md`'s composite catalog pattern is explicitly qualified as applying "where applicable," not universally; `31_schema_draft.md`'s `events` table states no FK requirement for either column; and the catalog-governance pattern exists to stop employees entering free text through UI forms, which does not apply to `event_type_code` — it is written by application code at fixed call sites, never chosen by a user from a dropdown. `event_type_code text not null` is complete, correct, standalone DDL. Open question for later, not a gate: seed all event names as catalog values for consistency with other status fields, or leave these two columns application-validated only.

---

# Next Step

Write SQL migrations in the sequence defined above. All Blocked Items resolved; see `31_schema_draft.md` `# 13. Review Required` item 3 and `30_database_conventions.md`'s Identity Key Standard.
