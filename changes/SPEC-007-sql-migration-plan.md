# Change Request — SPEC-007

## Status

[x] In Progress

---

## Assigned Model Tier

[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Create `_ORVION_CANONICAL/33_sql_migration_plan.md`, formalizing the dependency-ordered SQL migration sequence from `reports/phase-2-sql-migration-planning-report.md` as a canonical planning document, per `32_execution_roadmap.md`'s Phase 2 "Immediate Next Action: Create SQL migration plan" — without writing any SQL and without resolving the two open decisions identified during planning.

---

## Business Reason

`32_execution_roadmap.md`'s Phase 2 (Database Foundation) requires a SQL migration plan as its first deliverable, distinct from the migrations themselves. `reports/phase-2-database-foundation-readiness-report.md` and `reports/phase-2-sql-migration-planning-report.md` establish that the specification layer (`31_schema_draft.md`, 71 tables) is complete enough to fully sequence, that two real ordering hazards exist (a mutual reference between `documents` and `document_versions`; `document_links` and `approval_requests` depending on tables created much later than their nominal domain) and are resolved by the proposed sequence, and that two findings remain genuinely open and are not resolved by this task: the `users`/Supabase Auth integration strategy and the RLS enforcement mechanism. A third item — whether `events.event_type_code` should be catalog-governed — was initially drafted as a blocking finding but was reclassified after architectural review as a non-blocking, open architectural question (see the plan document's `# Recommended (Non-Blocking)` section); it does not delay any migration. This task formalizes only what is fully determined, as a new canonical document, leaving the two genuinely open items explicitly marked as blocking specific later migrations, and the one non-blocking item clearly separated from them, rather than conflating the two categories.

---

## Risks

Low. This task creates one new file; it does not modify any existing canonical document, does not write SQL, and does not create any file under `supabase/migrations/`. The main risk is that the migration sequence itself contains a dependency error not caught during planning — mitigated by the fact that every foreign-key column (including nullable ones) across all 71 tables in `31_schema_draft.md` was checked against the proposed sequence before this task was written (see `reports/phase-2-sql-migration-planning-report.md` §1–2).

---

## Supersedes / Depends On

Supersedes: None.

Depends on: Phase 1 (`_ORVION_CANONICAL/32_execution_roadmap.md`) must already be `Complete` — confirmed prior to this task being written.

---

## Scope — Files Allowed to Modify

- _ORVION_CANONICAL/33_sql_migration_plan.md (new file)

---

## Out of Scope — Files Forbidden to Modify

Scope above is exhaustive. Every other file is out of scope, with no exceptions, including but not limited to:

- _ORVION_CANONICAL/31_schema_draft.md — frozen baseline; this task reads it but does not alter it, and does not resolve any of its `# 13. Review Required` items.
- _ORVION_CANONICAL/30_database_conventions.md, 25_catalog_registry.md, and every other existing `_ORVION_CANONICAL/**` file.
- Any file under `supabase/` — this task produces no SQL and no migration file.
- AGENTS.md, PROTOCOL.md, changes/TEMPLATE.md — no workflow change is in scope here.
- reports/** — no report is modified by this task; the three phase-2 reports it draws from remain as authored.

---

## Minimum Reading List

- reports/phase-2-database-foundation-readiness-report.md
- reports/phase-2-sql-migration-planning-report.md
- reports/phase-2-migration-planning-prioritized-findings.md

---

## Implementation Steps

### Step 1 — Create `_ORVION_CANONICAL/33_sql_migration_plan.md`

Verify: check whether `_ORVION_CANONICAL/33_sql_migration_plan.md` already exists.
- If it exists: Already Applied, skip (do not overwrite an existing file under this Change Request).
- If it does not exist: create it with exactly the following content:

```
# SQL Migration Plan

Version: 0.1
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
| 4 | `NN_create_organization_tables.sql` | `tenants`, `branches`, `departments`, `branch_business_hours`, `holidays` | 1 | `tenants` is the isolation root. |
| 5 | `NN_create_identity_and_access_tables.sql` | `users` (see Blocked Items), `roles`, `permissions`, `role_permissions`, `user_branch_assignments`, `user_role_assignments` | 4 | `users` migration content is blocked — see Blocked Items 1. |
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
| 16 | `NN_create_authentication_support_tables.sql` | `trusted_devices`, `otp_challenges`, `totp_enrollments` | 5 | All reference `users` only. |
| 17 | `NN_create_marketing_and_offline_conversion_tables.sql` | `marketing_campaigns`, `campaign_daily_metrics`, `attribution_clicks`, `offline_conversions`, `offline_conversion_deliveries` | 8, 10, 12 | `offline_conversions` carries nullable FKs to `leads`, `bookings`/`booking_items`, and `payments`. |
| 18 | `NN_seed_system_catalogs.sql` | seed data only, no DDL | 2 | Populates `catalog_values` from `25_catalog_registry.md`. Not blocked — see `# Recommended (Non-Blocking)` regarding `event_type_code`, which requires no catalog and is simply not seeded from one. |
| 19 | `NN_create_rls_policies.sql` | RLS policies on every tenant-owned table | all preceding | Fully blocked — see Blocked Items 1 and 2. |
| 20 | Database verification checklist | — | all preceding | Roadmap Phase 2 explicitly lists this as a distinct Output from the migrations themselves; format (SQL smoke-test script vs. documentation checklist) is not decided by this plan. |

---

# Blocked Items

The following are not resolved by this plan and must be decided, by a human, before the migration(s) they block can be written correctly. This plan does not invent an answer for any of them.

## 1. `users` / Supabase Auth integration strategy

Blocks: migration 5's `users` table content.

`31_schema_draft.md` `# 13. Review Required` item 3: "`users` table may extend Supabase auth users. Final implementation depends on chosen auth structure." No further design exists anywhere in `_ORVION_CANONICAL/`.

## 2. RLS enforcement mechanism

Blocks: migration 19 in full.

`30_database_conventions.md`'s RLS Standard states the rule (tenant → branch → department isolation) but not the mechanism (helper functions, JWT custom claims, or another approach). Directly downstream of Blocked Item 1.

---

# Recommended (Non-Blocking)

The following was originally drafted as a blocking item and was reclassified after architectural review. It does not block any migration in the sequence above and may be decided on any timeline.

## `events.event_type_code` / `severity_code` catalog governance

No `event_type` catalog exists in `25_catalog_registry.md` for the roughly 150 event names defined in `27_event_catalog.md`. This does not block migration 5, 18, or 19: `30_database_conventions.md`'s composite catalog pattern is explicitly qualified as applying "where applicable," not universally; `31_schema_draft.md`'s `events` table states no FK requirement for either column; and the catalog-governance pattern exists to stop employees entering free text through UI forms, which does not apply to `event_type_code` — it is written by application code at fixed call sites, never chosen by a user from a dropdown. `event_type_code text not null` is complete, correct, standalone DDL. Open question for later, not a gate: seed all event names as catalog values for consistency with other status fields, or leave these two columns application-validated only.

---

# Next Step

Resolve Blocked Items 1–2, then write SQL migrations in the sequence defined above.
```

---

## Acceptance Criteria

- [x] `_ORVION_CANONICAL/33_sql_migration_plan.md` exists and contains exactly the content specified in Step 1. (True as literally written — see Verification Notes for a defect this criterion does not catch.)
- [x] The file contains a `# Migration Sequence` table with exactly 20 rows.
- [x] The file contains a `# Blocked Items` section with exactly 2 items, matching Readiness Report Findings 1–2, and a separate `# Recommended (Non-Blocking)` section with exactly 1 item covering `event_type_code`/`severity_code` catalog governance.
- [x] No SQL statement appears anywhere in the file (informational mentions of `ALTER TABLE ADD CONSTRAINT` and `gen_random_uuid()` as prose references are permitted; no runnable `CREATE TABLE`/`CREATE POLICY`/DDL statement is present).
- [x] No file outside Scope (`_ORVION_CANONICAL/33_sql_migration_plan.md` only) was modified or created.
- [x] `31_schema_draft.md` and every other existing `_ORVION_CANONICAL/**` file are byte-identical to their state before this task ran.

---

## Execution Log

### 2026-07-02 — Unidentified agent/process (recorded retroactively by Claude)

Outcome: Complete

Step results:
- Step 1: Applied — `_ORVION_CANONICAL/33_sql_migration_plan.md` was found already created, matching this Change Request's Step 1 content character-for-character (confirmed by direct comparison during Review).

Commits: none — the file was found sitting untracked in the working tree; `git log --all` for this path returns no history. This Change Request's own Status field remained `Approved` throughout, never recording that execution had occurred.

Blocker: None at execution time. Process note — this entry does not reflect a live-recorded execution; no agent identity could be determined. See Verification Notes below for a defect found during Review that Step 1's execution faithfully reproduced from this Change Request's own specification text.

---

## Verification Notes

### 2026-07-02 — Claude

Verdict: Needs Corrective Change Request

Findings: `_ORVION_CANONICAL/33_sql_migration_plan.md` matches this Change Request's Step 1 content exactly, and independently satisfies Acceptance Criteria 2–6 (20-row Migration Sequence table; 2 Blocked Items plus 1 Recommended item; no SQL statements present; no file outside Scope created; every other `_ORVION_CANONICAL/**` file confirmed byte-identical via `git diff --stat`). However, Acceptance Criterion 1 surfaces a genuine defect that execution correctly reproduced rather than introduced: both the created file's final line and this Change Request's own Step 1 specification (line 158) read "Resolve Blocked Items 1–3, then write SQL migrations in the sequence defined above" — a leftover reference to the pre-correction numbering, from before the `event_type` catalog item was reclassified from Blocked Item 3 to a non-blocking Recommended item. This line was missed by the prior correction pass's consistency sweep, whose search pattern (`Blocked Item 3`, singular) did not match this text's actual wording (`Blocked Items 1–3`, a range). The created document is therefore internally self-contradictory: it lists exactly 2 Blocked Items, then instructs the reader to "resolve Blocked Items 1–3." This is a defect in engineering content (a canonical document), not workflow bookkeeping, and per this repository's established distinction is not correctable as a direct administrative action — it requires its own corrective Change Request, consistent with the `SPEC-002` → `SPEC-003` precedent.

Recommendation to human: Draft and approve a corrective Change Request (e.g. `SPEC-008`) fixing this one line in both `_ORVION_CANONICAL/33_sql_migration_plan.md` and this Change Request's own Step 1 text, before treating this Change Request as `Complete`. Do not set Status to `Complete` as-is.

---

## Review Gate

- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [ ] No file outside the Scope list was modified or created.
- [ ] No section was added, removed, or restructured outside the approved steps.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] Any step that could not be resolved deterministically was reported, not guessed.
- [ ] Supersedes / Depends On: confirmed Phase 1 was `Complete` before this task began.
- [ ] The repository is in a clean, releasable state.

---

## Notes

This task deliberately stops short of writing any SQL, per the requesting instruction. It also deliberately does not attempt to resolve Blocked Items 1–2 — per this repository's standing rule against inventing business or technical requirements, those require an explicit human decision, most efficiently made together since Item 2 is directly downstream of Item 1. The `event_type_code` catalog-governance question was initially drafted as a third Blocked Item but was reclassified after architectural review as a non-blocking, open architectural question (see `# Recommended (Non-Blocking)` in the plan document) — it delays nothing and may be decided independently, on any timeline. Once Items 1–2 are resolved, the next Change Request in this sequence would begin writing the actual migration files in the order this document defines, starting with migration 1 (extensions) through whichever migrations remain unblocked, while only migrations 5 and 19 wait on their respective Blocked Items.
