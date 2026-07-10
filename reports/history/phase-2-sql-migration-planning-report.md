# Phase 2: SQL Migration Planning Report

Version: 0.1
Status: Final
Companion to: `reports/phase-2-database-foundation-readiness-report.md`, `reports/phase-2-migration-planning-prioritized-findings.md`
Scope discipline: this report contains **no SQL** and defines **no migration file content** — only file grouping, sequencing, and the dependency reasoning behind that sequencing, per this task's explicit constraint.

---

## 1. Method

Every one of the 71 tables in `31_schema_draft.md` was checked for every foreign-key-shaped field it declares (including nullable ones — a nullable column with a foreign key constraint still requires its target table to already exist at constraint-creation time; nullability does not relax this). Tables were then grouped into a dependency-respecting sequence. Two genuine ordering hazards were found that a naive "migrate in document order" approach would hit:

1. **`documents` and `document_versions` mutually reference each other** — `documents.current_version_id` references `document_versions(id)`, and `document_versions.document_id` references `documents(id)`. Neither can be created first with its FK constraint intact. Standard resolution: create `documents` without the `current_version_id` FK constraint (column present, constraint deferred), create `document_versions`, then `ALTER TABLE documents ADD CONSTRAINT` for `current_version_id`.
2. **`document_links` and `approval_requests` both reference tables created much later than "Documents" as a domain** — `document_links` references `quotation_id`, `booking_id`, `booking_item_id`, `invoice_id`, `receipt_id`, `supplier_id`, and `subscription_payment_proof_id` (all nullable, all real FKs), meaning it cannot be created until Booking, Finance, and Subscription tables all already exist. `approval_requests` similarly references `booking_item_id` and `document_id`. Both are moved to dedicated late migrations rather than bundled with their nominal domain.

---

## 2. Planned Migration Sequence

Filenames follow `30_database_conventions.md`'s Migration Rule exactly (`YYYYMMDDHHMM_description.sql`); the timestamp component shown below is a placeholder ordinal (`NN`) — actual timestamps are assigned at execution time by whoever writes the migrations, not fixed here.

| # | Filename pattern | Tables | Depends on (#) | Why this position |
| --- | --- | --- | --- | --- |
| 1 | `NN_enable_extensions.sql` | — (enables `pgcrypto`) | — | `30_database_conventions.md` Primary Key Standard requires `pgcrypto` before any `gen_random_uuid()` default can be used. |
| 2 | `NN_create_system_catalog_tables.sql` | `catalog_types`, `catalog_values` | 1 | No FK dependencies on business tables; every later table's `_code` columns conceptually reference these via the composite pattern. |
| 3 | `NN_create_reference_tables.sql` | `currencies` | 1 | No dependencies; every `currency_code` column elsewhere references `currencies.code`. |
| 4 | `NN_create_organization_tables.sql` | `tenants`, `branches`, `departments`, `branch_business_hours`, `holidays` | 1 | `tenants` is the isolation root; everything tenant-scoped depends on it, directly or transitively. |
| 5 | `NN_create_identity_and_access_tables.sql` | `users` **(blocked — see Readiness Report Finding 1)**, `roles`, `permissions`, `role_permissions`, `user_branch_assignments`, `user_role_assignments` | 4 | `roles`/`permissions` have no cross-domain dependencies and could technically move earlier, but are kept with `users` for domain cohesion since `user_role_assignments` needs both. |
| 6 | `NN_create_finance_foundation_tables.sql` | `exchange_rates`, `chart_of_accounts`, `financial_accounts` | 4 | Moved out of the main "Finance" group and earlier: `booking_items.exchange_rate_id` (migration 10) requires `exchange_rates` to already exist. `chart_of_accounts`/`financial_accounts` have no dependency forcing them later, so they move with it for one less migration. |
| 7 | `NN_create_document_core_tables.sql` | `documents` (FK to `document_versions` deferred), `document_versions`, then `ALTER TABLE documents ADD CONSTRAINT` for `current_version_id` | 4 | Resolves the mutual-reference hazard (§1.1) as early as possible, since many later tables (`subscription_payment_proofs`, `document_links`) need `documents` to exist. |
| 8 | `NN_create_crm_core_tables.sql` | `customers`, `customer_contact_methods`, `customer_identity_signals`, `customer_identity_merges`, `customer_notes`, `leads`, `lead_assignments`, `lead_interactions` | 4, 5 | `customers` has no dependency on `leads` (no `lead_id` column on `customers`); `leads.customer_id` is nullable, so `customers` is created first within this migration, `leads` second. |
| 9 | `NN_create_suppliers_and_passengers_tables.sql` | `suppliers`, `passengers` | 4, 8 | Both are needed by Booking (migration 10); `passengers.customer_id` is nullable and references `customers` (migration 8). |
| 10 | `NN_create_booking_core_tables.sql` | `quotations`, `quotation_items`, `bookings`, `booking_items`, `booking_item_passengers`, `internal_supplier_links`, `exchange_rate_adjustments` | 6, 8, 9 | `quotations` needs `leads`+`customers`; `bookings` needs `leads`+`quotations`+`customers`; `booking_items` needs `bookings`+`suppliers`+`exchange_rates`; `internal_supplier_links.booking_item_id` is non-nullable, so it must follow `booking_items` within this same migration. |
| 11 | `NN_create_crm_extension_tables.sql` | `tasks`, `complaints`, `service_requests`, `conversations`, `conversation_messages` | 8, 10 | `complaints`/`service_requests`/`conversations` all carry nullable `booking_id`/`booking_item_id` FKs — this is the ordering hazard a document-order migration would miss, since these entities are described in `31_schema_draft.md` §3 (CRM Tables), *before* Booking (§4), but cannot actually be created until Booking exists. |
| 12 | `NN_create_finance_transaction_tables.sql` | `journal_entries`, `journal_entry_lines`, `invoices`, `payments`, `payment_allocations`, `receipts`, `refunds`, `approval_requests`, `company_assets` | 6, 7, 8, 10 | `approval_requests` needs both `booking_items` (10) and `documents` (7) — another hazard a naive read of §5 (Finance Tables) alone would miss, since `documents` isn't described until §6. |
| 13 | `NN_create_event_and_notification_tables.sql` | `events`, `security_events`, `notifications`, `notification_deliveries` | 4 | `events`/`security_events` use polymorphic `entity_type`/`entity_id` fields, not real FKs, so they have no hard dependency beyond `tenants`; positioned here for domain grouping, not a hard requirement. |
| 14 | `NN_create_subscription_tables.sql` | `subscription_plans`, `feature_entitlements`, `subscriptions`, `subscription_payment_proofs`, `usage_counters` | 4, 7 | `subscription_payment_proofs.document_id` requires `documents` (7). |
| 15 | `NN_create_document_links_table.sql` | `document_links` | 7, 9, 10, 12, 14 | Isolated into its own migration precisely because of §1.2 — it is the single latest-dependent table in the schema, needing `quotations`/`bookings`/`booking_items` (10), `suppliers` (9), `invoices`/`receipts` (12), and `subscription_payment_proofs` (14). |
| 16 | `NN_create_authentication_support_tables.sql` | `trusted_devices`, `otp_challenges`, `totp_enrollments` | 5 | All reference `users` only. |
| 17 | `NN_create_marketing_and_offline_conversion_tables.sql` | `marketing_campaigns`, `campaign_daily_metrics`, `attribution_clicks`, `offline_conversions`, `offline_conversion_deliveries` | 8, 10, 12 | `offline_conversions` carries nullable FKs to `leads` (8), `bookings`/`booking_items` (10), and `payments` (12). |
| 18 | `NN_seed_system_catalogs.sql` | seed data only, no DDL | 2 | Populates `catalog_values` from every catalog in `25_catalog_registry.md`; per `30_database_conventions.md`'s Seed Data Rule, kept separate from table-creation DDL. Not blocked: `event_type_code`/`severity_code` require no catalog to be written correctly (see Readiness Report §4a, Observation A) and simply are not seeded from one — every other catalog seeds normally. |
| 19 | `NN_create_rls_policies.sql` **(blocked — see Readiness Report Finding 2)** | RLS policies on every tenant-owned table | all preceding | Cannot be written until the auth/RLS mechanism (Finding 1 and 2) is decided. Placed last deliberately — every table must exist before its policy can be attached, and this is the correct final gate before the database is considered "foundation-complete" per the roadmap's own Phase 2 Outputs list (`RLS baseline`). |
| 20 | `NN_create_verification_checklist.sql` (or a non-SQL checklist document) | — | all preceding | Roadmap Phase 2 Outputs explicitly lists "Database verification checklist" as a deliverable distinct from the migrations themselves. |

---

## 3. What This Plan Deliberately Does Not Resolve

Migrations 5 (partially) and 19 are explicitly blocked pending the human decisions identified in the Readiness Report (Findings 1 and 2). Migration 18 is **not** blocked — the `event_type_code`/`severity_code` catalog question (Readiness Report §4a, Observation A) is an open architectural question, not a migration blocker, and this report was corrected after review to stop treating it as one. This plan sequences *around* the two genuine gaps — it does not invent an auth strategy or an RLS mechanism to fill them. The accompanying Change Request formalizes this exact sequence as a canonical planning document without attempting to resolve either.
