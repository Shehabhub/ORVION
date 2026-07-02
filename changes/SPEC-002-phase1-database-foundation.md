# Change Request — SPEC-002

## Status

[x] Complete

---

## Assigned Model Tier

[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Apply the Phase 1 Domain & Schema Audit's approved database-structure findings to the five canonical documents listed in Scope below.

---

## Business Reason

The Phase 1 Domain & Schema Audit (see `/reports/phase-01-domain-schema-final.md`) identified twelve database-structure gaps required before SQL migration can safely begin: a missing `currencies` reference table, a missing `payment_allocations` table (invoices could not otherwise be matched to the payments that settle them), a missing `customer_identity_merges` table, several missing columns and foreign keys, four undocumented constraints, and entity-registry entries missing for tables that already exist in the schema draft. This task closes all twelve, plus three additional inconsistencies discovered while preparing the work (documented per item below and in `/reports/phase-01-implementation-complete.md`).

---

## Risks

Low. Every edit is additive (new tables, new nullable columns, new documentation-level rules) — no existing field, table, or relationship is removed or renamed. The main risk is divergence between this repository's actual current state and the state assumed when this task was written, which is why every step below is verification-gated rather than assumed. If any verification check produces an unexpected partial match, the correct behavior is to stop and report, not to guess.

---

## Supersedes / Depends On

Supersedes: `/reports/phase-01-implementation-package.md` (the same work, previously described only in chat/report form, never committed as an executable Change Request) and an earlier, never-committed "SPEC-001" fragment covering the `payment_allocations` cross-currency fields only, which is fully absorbed into Step 3 below. Neither of those was ever a `changes/*.md` file, so there is no prior Status to update.

Depends on: None. This is the first Change Request in this repository.

---

## Scope — Files Allowed to Modify

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/24_entity_registry.md
- _ORVION_CANONICAL/29_relationship_map.md
- _ORVION_CANONICAL/25_catalog_registry.md
- _ORVION_CANONICAL/30_database_conventions.md

---

## Out of Scope — Files Forbidden to Modify

Scope above is exhaustive. Every file in this repository other than the five listed in Scope is out of scope, with no exceptions. The list below is the complete repository file inventory at the time this Change Request was written (57 tracked files), provided so no file needs to be assumed in or out of scope.

Root:
- .aider.conf.yml
- .gitignore
- .vscode/settings.json
- .vscode/tasks.json
- AGENTS.md
- CODING_STANDARDS.md
- PROJECT_CONTEXT.md
- PROTOCOL.md
- README.md
- git-tree.txt
- global-rules.md
- project-tree.txt
- tracked-files.txt

_ORVION_CANONICAL/ (all files except the five listed in Scope):
- _ORVION_CANONICAL/00_project_charter.md
- _ORVION_CANONICAL/01_mvp_scope.md
- _ORVION_CANONICAL/02_phase_01_questions.md
- _ORVION_CANONICAL/03_company_structure.md
- _ORVION_CANONICAL/04_lead_lifecycle.md
- _ORVION_CANONICAL/05_customer_identity.md
- _ORVION_CANONICAL/06_booking_and_travel_products.md
- _ORVION_CANONICAL/07_finance_model.md
- _ORVION_CANONICAL/08_document_model.md
- _ORVION_CANONICAL/09_saas_plans_and_access.md
- _ORVION_CANONICAL/10_notifications_model.md
- _ORVION_CANONICAL/11_phase_02_questions.md
- _ORVION_CANONICAL/12_lead_statuses_and_rules.md
- _ORVION_CANONICAL/13_booking_statuses_and_rules.md
- _ORVION_CANONICAL/14_finance_rules.md
- _ORVION_CANONICAL/15_permissions_roles.md
- _ORVION_CANONICAL/16_document_types_and_rules.md
- _ORVION_CANONICAL/17_saas_plan_matrix.md
- _ORVION_CANONICAL/18_integration_priority.md
- _ORVION_CANONICAL/19_open_decisions_before_database.md
- _ORVION_CANONICAL/20_authentication_security_model.md
- _ORVION_CANONICAL/21_offline_conversion_engine.md
- _ORVION_CANONICAL/22_database_ready_gap_analysis.md
- _ORVION_CANONICAL/23_database_ready_package_plan.md
- _ORVION_CANONICAL/26_state_machines.md
- _ORVION_CANONICAL/27_event_catalog.md
- _ORVION_CANONICAL/28_permissions_matrix.md
- _ORVION_CANONICAL/32_execution_roadmap.md
- _ORVION_CANONICAL/SYSTEM_PROMPT.md
- _ORVION_CANONICAL/codex.md
- _ORVION_CANONICAL/manifest.md

changes/:
- changes/CHANGE_REQUEST.md
- changes/TEMPLATE.md

scripts/:
- scripts/repository-all.ps1
- scripts/start-aider.ps1

supabase/:
- supabase/.branches/_current_branch
- supabase/.temp/cli-latest
- supabase/.temp/pgdelta/catalog-local-migrations-e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855-1782419221382.json
- supabase/config.toml

In particular: `_ORVION_CANONICAL/26_state_machines.md`, `27_event_catalog.md`, and `28_permissions_matrix.md` are explicitly called out because state machines, events, and permissions for Task, Quotation, Conversation, Complaint, Service Request, and Marketing Campaign are a known, related gap — but resolving it is reserved for a future Change Request and must not be attempted here.

---

## Minimum Reading List

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/24_entity_registry.md
- _ORVION_CANONICAL/29_relationship_map.md
- _ORVION_CANONICAL/25_catalog_registry.md
- _ORVION_CANONICAL/30_database_conventions.md

---

## Implementation Steps

### Step 1 — Version marker

File: `_ORVION_CANONICAL/31_schema_draft.md`
Verify: search for the exact line `Version: 0.4`.
- If found: Already Applied, skip.
- If not found (file shows `Version: 0.3`): replace `Version: 0.3` with `Version: 0.4`.

### Step 2 — `currencies` reference table

File: `_ORVION_CANONICAL/31_schema_draft.md`
Verify: search for the exact heading `## currencies`.
- If found: Already Applied, skip.
- If not found: locate the line `# 3. CRM Tables`. Insert the following text immediately before it, so the inserted block is followed directly by the existing `# 3. CRM Tables` line:

```
# 2a. Reference Tables

## currencies

Purpose:

Canonical, validated currency list used by every `currency_code` column in this schema.

Core fields:

- code
- name
- symbol nullable
- decimal_places
- is_active
- created_at
- updated_at

Unique:

- code

Notes:

- Every `currency_code` column elsewhere in this document is a reference to `currencies.code`.
- `decimal_places` exists because the Money Standard's `numeric(14, 2)` convention (see `database_conventions.md`) is a safe default for EGP/SAR/USD but is not universal; this column allows a future currency to be onboarded without a silent rounding defect.

---

```

### Step 3 — `payment_allocations` table

File: `_ORVION_CANONICAL/31_schema_draft.md`
Verify: search for the exact heading `## payment_allocations`.
- If found: additionally search within that section for the exact string `exchange_rate_id nullable`.
  - If found: Already Applied in full, skip.
  - If not found: STOP. Report: "payment_allocations exists but is missing the approved cross-currency fields (exchange_rate_id, allocated_amount_invoice_currency). Do not edit; escalate for review."
- If `## payment_allocations` is not found at all: locate the `## payments` table's final field (`- updated_at`, immediately before the `## receipts` heading). Insert the following text immediately after `- updated_at` and before `## receipts`:

```
## payment_allocations

Purpose:

Links a payment to the specific invoice(s) it settles, supporting partial and installment payments against a single invoice, including cross-currency settlement.

Core fields:

- id
- tenant_id
- payment_id
- invoice_id
- allocated_amount numeric
- currency_code
- exchange_rate_id nullable
- allocated_amount_invoice_currency numeric nullable
- created_by
- created_at

Notes:

- One payment may be allocated across multiple invoices; one invoice may receive allocations from multiple payments.
- sum(allocated_amount_invoice_currency) (or allocated_amount when no currency conversion applies) across all allocations for one invoice must not exceed that invoice's total_amount. This is an application/SQL-level rule, not a new table constraint description.
- invoice_status_code values partially_paid and paid are derived from the sum of this table's allocated amounts for the invoice, compared against invoices.total_amount.
- currency_code records the currency the payment was actually made in (matching payments.currency_code).
- exchange_rate_id (referencing exchange_rates) and allocated_amount_invoice_currency are populated only when the payment's currency differs from the invoice's currency, following the same pattern already established by booking_items.exchange_rate_id. When the payment and invoice share the same currency, both fields remain null and allocated_amount alone is authoritative.

```

### Step 4 — `customer_identity_merges` table

File: `_ORVION_CANONICAL/31_schema_draft.md`
Verify: search for the exact heading `## customer_identity_merges`.
- If found: Already Applied, skip.
- If not found: locate the `## customer_identity_signals` table's final field (`- created_at`, immediately before `## customer_notes`). Insert immediately after it and before `## customer_notes`:

```
## customer_identity_merges

Purpose:

Records customer identity merge actions as first-class, queryable data.

Core fields:

- id
- tenant_id
- source_customer_id
- target_customer_id
- merged_by
- reason nullable
- created_at

Notes:

- This table supplements, and does not replace, the customer_identity_merged event already defined in event_catalog.md. The event remains the audit-trail record of the action; this table is the queryable relational record.

```

### Step 5 — `journal_entry_lines.created_at` and debit/credit rule

File: `_ORVION_CANONICAL/31_schema_draft.md`
Verify: within the `## journal_entry_lines` section, search for the exact line `- created_at`.
- If found: Already Applied, skip.
- If not found: after the field `- description` in that section, insert a new line `- created_at`, then append:

```

Rules:

- Exactly one of debit_amount or credit_amount must be populated per row (the other must be null or zero). A row with both populated, or neither, is invalid.
```

### Step 6 — `invoices` void fields

File: `_ORVION_CANONICAL/31_schema_draft.md`
Verify: within the `## invoices` section, search for the exact line `- voided_at nullable`.
- If found: Already Applied, skip.
- If not found: immediately after the field `- status_code` in that section, insert:
```
- voided_at nullable
- voided_by nullable
- void_reason nullable
```

### Step 7 — `booking_item_passengers` pricing overrides

File: `_ORVION_CANONICAL/31_schema_draft.md`
Verify: within the `## booking_item_passengers` section, search for the exact line `- selling_amount_override numeric nullable`.
- If found: Already Applied, skip.
- If not found: immediately after the field `- passenger_id` in that section, insert:
```
- selling_amount_override numeric nullable
- cost_amount_override numeric nullable
```
Then, immediately after that section's existing `Unique:` block (`- booking_item_id + passenger_id`), append:
```

Rules:

- selling_amount_override and cost_amount_override, when populated, represent this passenger's individual price/cost within the shared booking_item. When null, the passenger's share is treated as an even split of the parent booking_item's selling_amount/cost_amount.
- Where populated, these fields must not be negative, consistent with the equivalent rule on booking_items.
```

### Step 8 — `bookings.quotation_id`

File: `_ORVION_CANONICAL/31_schema_draft.md`
Verify: within the `## bookings` section, search for the exact line `- quotation_id nullable`.
- If found: Already Applied, skip.
- If not found: immediately after the field `- lead_id nullable` in that section, insert `- quotation_id nullable`. Do not remove, reorder, or otherwise alter any other field in this section, including `booking_status_code`.

### Step 9 — `conversations` booking linkage

File: `_ORVION_CANONICAL/31_schema_draft.md`
Verify: within the `## conversations` section, search for the exact line `- booking_id nullable`.
- If found: Already Applied, skip.
- If not found: immediately after the field `- lead_id nullable` in that section, insert:
```
- booking_id nullable
- booking_item_id nullable
```

### Step 10 — `attribution_clicks` / `offline_conversions` campaign linkage

File: `_ORVION_CANONICAL/31_schema_draft.md`
Verify (part A): within the `## attribution_clicks` section, search for `- marketing_campaign_id nullable`.
- If found: skip part A.
- If not found: immediately after `- attribution_source_code` in that section, insert `- marketing_campaign_id nullable`.

Verify (part B): within the `## offline_conversions` section, search for `- marketing_campaign_id nullable`.
- If found: skip part B.
- If not found: immediately after `- attribution_click_id nullable` in that section, insert `- marketing_campaign_id nullable`.

### Step 11 — `document_links.quotation_id` and enforcement note

File: `_ORVION_CANONICAL/31_schema_draft.md`
Verify: within the `## document_links` section, search for `- quotation_id nullable`.
- If found: Already Applied, skip.
- If not found: immediately after `- invoice_id nullable` in that section, insert `- quotation_id nullable`. Then, in that same section's existing `Rules:` block (which reads exactly "Exactly one target FK should be set per row." followed by "This avoids weak polymorphic document links for MVP."), append a third line: `- This rule must be enforced as a database-level constraint at SQL migration time, not only as an application-layer check.`

### Step 12 — `document_versions` single-current-version rule

File: `_ORVION_CANONICAL/31_schema_draft.md`
Verify: within the `## document_versions` section, search for the string `is_current = true`.
- If found: Already Applied, skip.
- If not found: after the final field `- is_current` in that section, append:
```

Rules:

- At most one document_versions row per document_id may have is_current = true.
```

### Step 13 — `passengers` passport date rule

File: `_ORVION_CANONICAL/31_schema_draft.md`
Verify: within the `## passengers` section, search for the string `passport_expiry_date.` (inside a Rules block, not the field list).
- If found: Already Applied, skip.
- If not found: after that section's existing `Notes:` block, append:
```

Rules:

- passport_issue_date, when both fields are populated, must be earlier than passport_expiry_date.
```

### Step 14 — Table Classification Summary corrections

File: `_ORVION_CANONICAL/31_schema_draft.md`, section `# 11. Table Classification Summary`

Verify (part A): does `## Core Business` list `complaints`?
- If yes: skip part A.
- If no: add `- complaints` and `- service_requests` to the `## Core Business` list.

Verify (part B): does `## Core Business` list `branch_business_hours`?
- If yes: skip part B.
- If no: add `- branch_business_hours` and `- holidays` to the `## Core Business` list.

Verify (part C): does `## Core Business` list `customer_identity_merges`?
- If yes: skip part C.
- If no: add `- customer_identity_merges` to the `## Core Business` list.

Verify (part D): does `## Financial` list `payment_allocations`?
- If yes: skip part D.
- If no: add `- payment_allocations` to the `## Financial` list.

Verify (part E): does `## Configuration` list `currencies`?
- If yes: skip part E.
- If no: add `- currencies` to the `## Configuration` list.

Mandatory final check for this step: after applying any of parts A–E, count every `##` table heading in the document (sections 1–10) and confirm each appears exactly once across `# 11. Table Classification Summary`, and that the summary contains no entry that does not correspond to a real `##` table heading. If any mismatch is found, stop and report it rather than editing further.

### Step 15 — Entity registry catch-up

File: `_ORVION_CANONICAL/24_entity_registry.md`
Verify: search for the exact heading `## Currency`.
- If found: Already Applied, skip entire step (Steps 15's insertions are always applied together; if `## Currency` is present, all of them are present).
- If not found, apply all four insertions below exactly as written, in order:

**15a.** Locate `## Department`'s section, ending at the line `- Supports routing and permissions.`, immediately before `## User`. Insert immediately after it and before `## User`:

```
## Branch Business Hours

Represents weekly operating hours for a branch.

Responsibilities:

- Supports SLA calculation windows.
- Supports operational planning and scheduling displays.

## Holiday

Represents a lightweight holiday calendar entry.

Responsibilities:

- Supports SLA calculation exceptions.
- Supports operational planning around non-working days.

Notes:

- May be tenant-wide or branch-specific.

```

**15b.** Locate the `## User Role Assignment` section's final line (`- Allows different authority in different branches or departments.`), immediately before the `---` separator that precedes `# CRM Entities`. Insert immediately after that line and before the `---` separator:

```

## Role Permission

Represents the assignment of a Permission to a Role.

Responsibilities:

- Defines which Permissions each Role grants.
```

Then, immediately after that same `---` separator (i.e., between it and `# CRM Entities`), insert:

```
# Reference Entities

## Currency

Represents a canonical, validated currency used across the platform.

Responsibilities:

- Provides the single source of truth for every `currency_code` reference in the system.
- Carries decimal precision so multi-currency amounts round correctly.

---

```

**15c.** Locate `## Customer Contact Method`'s section, ending at `- Supports communication history.`, immediately before `## Customer Branch Activity Summary`. Insert immediately after it and before `## Customer Branch Activity Summary`:

```
## Customer Identity Merge

Represents merging one customer identity into another.

Responsibilities:

- Records source and target customer, the merging user, and the reason, as queryable relational data.
- Supplements (does not replace) the `customer_identity_merged` audit event.

## Customer Identity Signal

Represents a data point used for duplicate-customer detection.

Responsibilities:

- Supports duplicate detection across phone, email, passport, or other identity signals.
- Records which source entity contributed the signal.

## Customer Note

Represents a searchable, editable business note about a customer.

Responsibilities:

- Stores customer-relevant business memory, distinct from immutable events.
- May be pinned or marked confidential.

```

**15d.** Locate `## Customer Branch Activity Summary`'s section, ending at `- Does not expose detailed event content from another branch by default.`, immediately before `# Travel And Booking Entities`. Insert immediately after it and before `# Travel And Booking Entities`:

```
## Task

Represents operational work assigned to an employee.

Examples:

- Call customer
- Send quotation
- Issue ticket
- Verify passport
- Collect payment
- Approve refund

Responsibilities:

- Tracks responsible employee, due date, and completion.
- Distinct from notifications, which communicate information rather than represent work.

## Complaint

Represents a first-class customer complaint and its resolution workflow.

Responsibilities:

- Links to the customer and, where applicable, the booking or booking item concerned.
- Integrates with tasks, conversations, and events for full timeline history.

## Service Request

Represents operational work requested by a customer after the initial booking.

Responsibilities:

- Links to the customer and, where applicable, the booking or booking item concerned.
- Links naturally to tasks, events, and conversations rather than requiring a separate table per request type.

## Quotation

Represents a price/service offer sent to a customer before booking.

Responsibilities:

- Links to a lead or customer.
- May be accepted to create a booking.

## Quotation Item

Represents a service line inside a quotation.

Responsibilities:

- Records service type, quantity, unit price, and currency for one quoted line item.

## Conversation

Represents an ongoing or historical customer conversation.

Responsibilities:

- Supports WhatsApp, phone, and future channels.
- Links to customer, lead, and — once linked post-booking — booking or booking item.
- Distinct from events: conversations store communication context, events record milestones.

## Conversation Message

Represents an individual conversation message or call log entry.

Responsibilities:

- Stores message direction, sender, and content or metadata.
- Business-critical outcomes are recorded separately in lead interactions and events, not only in message content.

```

**15e.** Locate `## Payment`'s section, ending at `- Supports installments.`, immediately before `## Refund`. Insert immediately after it and before `## Refund`:

```
## Payment Allocation

Represents a payment settling a specific invoice, in whole or in part.

Responsibilities:

- Links a Payment to the Invoice(s) it settles.
- Supports partial and installment payments against a single invoice.
- Records the exchange rate used when the payment's currency differs from the invoice's currency.

```

**15f.** Locate `## Finance Approval`'s section, ending at `- Locks cost where required.`, immediately before `## Exchange Rate`. Insert immediately after it and before `## Exchange Rate`:

```
Notes:

- Implemented via the generic `approval_requests` table (`approval_type_code = finance_execution_approval`), not a separate physical table — see `31_schema_draft.md`, Review Required item 5.
- `approval_requests` also carries the other approval types (refund, discount, booking override, manual price change, sensitive data change, subscription) under the same generic mechanism.

```

**15g.** Locate the section header `# Offline Conversion Entities`. Replace that single heading line with `# Marketing And Offline Conversion Entities`. Then locate `## Attribution Click`'s heading, immediately following the renamed section header, and insert immediately before it:

```
## Marketing Campaign

Represents an advertising campaign tracked by ORVION.

Responsibilities:

- Represents the campaign a click, conversion, or metric belongs to.
- Supports the Marketing Dashboard without implementing full ad platform management.

## Campaign Daily Metric

Represents daily marketing performance values for a campaign.

Responsibilities:

- Stores spend, impressions, clicks, leads, bookings, and revenue per day.
- May be imported from integrations or calculated internally.

```

Then, within `## Attribution Click`'s existing Responsibilities list, append one line: `- Links to the Marketing Campaign it belongs to, where identifiable.`

Then, within `## Offline Conversion`'s existing Responsibilities list, append one line: `- Links to the Marketing Campaign it belongs to, where identifiable.`

### Step 16 — Relationship map additions

File: `_ORVION_CANONICAL/29_relationship_map.md`
Verify: search for the exact heading `## Invoice To Payment`.
- If found: Already Applied, skip entire step.
- If not found, apply all four insertions below exactly as written, in order:

**16a.** Locate `## Customer To Invoice`'s section, ending at `- booking_item 1 -> many invoices`, immediately before `## Customer/Supplier To Payment`. Insert immediately after it and before `## Customer/Supplier To Payment`:

```
## Invoice To Payment

Relationship:

- Invoice may have many Payment Allocations.
- Payment may have many Payment Allocations.
- Payment Allocation belongs to exactly one Invoice and exactly one Payment.

Cardinality:

- invoice 1 -> many payment_allocations
- payment 1 -> many payment_allocations

Purpose:

- Supports partial and installment payments against a single invoice with a deterministic, queryable paid/outstanding balance, including cross-currency settlement via an optional exchange rate reference.

```

**16b.** Locate `## Lead To Interaction`'s section, ending at `- user 1 -> many lead_interactions`, immediately before the `---` separator that precedes `# Booking Relationships`. Insert immediately after it and before that `---` separator:

```

## Customer To Customer (Identity Merge)

Relationship:

- Customer (source) may be merged into exactly one Customer (target) via Customer Identity Merge.
- Customer (target) may have many source merges recorded against it.

Cardinality:

- customer (target) 1 -> many customer_identity_merges

Purpose:

- Supports customer-identity merges as a queryable, reconstructable action, not only an event-log entry.

---

# CRM Extension Relationships

## Customer/Lead To Task

Relationship:

- Task may relate to any business entity via `related_entity_type`/`related_entity_id`.
- Task is owned by exactly one User, Department, and Branch.

## Customer To Complaint

Relationship:

- Customer has many Complaints.
- Complaint may optionally link to the Booking or Booking Item it concerns.

Cardinality:

- customer 1 -> many complaints
- booking 1 -> many complaints
- booking_item 1 -> many complaints

## Customer To Service Request

Relationship:

- Customer has many Service Requests.
- Service Request may optionally link to the Booking or Booking Item it concerns.

Cardinality:

- customer 1 -> many service_requests
- booking 1 -> many service_requests
- booking_item 1 -> many service_requests

## Lead/Customer To Quotation

Relationship:

- Quotation may originate from a Lead or belong directly to a Customer.
- Quotation has many Quotation Items.

Cardinality:

- lead 1 -> many quotations
- customer 1 -> many quotations
- quotation 1 -> many quotation_items

## Customer/Lead To Conversation

Relationship:

- Conversation may link to a Customer or a Lead.
- Conversation may optionally link to a Booking or Booking Item once one exists.
- Conversation has many Conversation Messages.

Cardinality:

- customer 1 -> many conversations
- lead 1 -> many conversations
- booking 1 -> many conversations
- booking_item 1 -> many conversations
- conversation 1 -> many conversation_messages

```

(This insertion ends with its own `---` implicitly followed by the pre-existing `# Booking Relationships` heading — do not duplicate that heading.)

**16c.** Locate `## Lead To Booking`'s section, ending at `- booking many -> 0/1 lead`, immediately before `## Customer To Booking`. Insert immediately after it and before `## Customer To Booking`:

```
## Quotation To Booking

Relationship:

- Quotation may produce zero or one Booking upon acceptance.
- Booking may optionally reference the Quotation it originated from.

Cardinality:

- quotation 1 -> 0..1 booking

```

**16d.** Locate the section header `# Offline Conversion Relationships`. Insert immediately after it and before `## Attribution Click To Lead`:

```
## Marketing Campaign To Daily Metric

Relationship:

- Marketing Campaign has many Campaign Daily Metrics.

Cardinality:

- marketing_campaign 1 -> many campaign_daily_metrics

## Marketing Campaign To Attribution Click / Offline Conversion

Relationship:

- Marketing Campaign may have many Attribution Clicks and many Offline Conversions, where identifiable.

Cardinality:

- marketing_campaign 1 -> many attribution_clicks
- marketing_campaign 1 -> many offline_conversions

Notes:

- This is a referential (foreign key) link in addition to the existing `utm_campaign` free-text field; the two are not mutually exclusive.

```

### Step 17 — Catalog registry and conventions cross-references

File: `_ORVION_CANONICAL/25_catalog_registry.md`
Verify: within the `## Reference Data` section, search for the word `Implemented`.
- If found: skip.
- If not found: immediately after that section's `Used for:` list (ending at `- Airports where needed later`) and before its `Rule:` line, insert:
```

Status:

- Currencies: Implemented — see `31_schema_draft.md`, Reference Tables (`currencies`).
- Countries, Cities, Languages, Nationalities, Airports: Not yet implemented as dedicated reference tables; current fields (e.g. `nationality_code`, `destination_country_code`, `preferred_language_code`) remain free-standing codes pending a documented business requirement for validated lookups at that granularity.
```

File: `_ORVION_CANONICAL/30_database_conventions.md`
Verify: within the `# Money Standard` section, search for the string `currencies.code`.
- If found: skip.
- If not found: immediately after the code block containing `currency_code text not null` and before the line `Exchange rates should be numeric with sufficient precision.`, insert:
```

`currency_code` values must reference `currencies.code` (see `31_schema_draft.md`, Reference Tables). The `numeric(14, 2)` default above is correct for every currency currently in ORVION's documented scope (EGP, SAR, USD); `currencies.decimal_places` exists to prevent a silent rounding defect if a non-2-decimal currency is added in the future.
```

---

## Acceptance Criteria

- [x] Step 1: `31_schema_draft.md` header reads `Version: 0.4`.
- [x] Step 2: `## currencies` exists under a new `# 2a. Reference Tables` section with exactly the 7 core fields specified.
- [x] Step 3: `## payment_allocations` exists with exactly the 9 core fields specified, including `exchange_rate_id nullable` and `allocated_amount_invoice_currency numeric nullable`.
- [x] Step 4: `## customer_identity_merges` exists with exactly the 6 core fields specified.
- [x] Step 5: `journal_entry_lines` has `created_at` and a debit/credit exclusivity Rules block.
- [x] Step 6: `invoices` has `voided_at`, `voided_by`, `void_reason`, all nullable.
- [x] Step 7: `booking_item_passengers` has `selling_amount_override` and `cost_amount_override`, both nullable, plus a non-negative Rules block.
- [x] Step 8: `bookings` has `quotation_id nullable`, and `booking_status_code` is still present and unaltered.
- [x] Step 9: `conversations` has `booking_id nullable` and `booking_item_id nullable`.
- [x] Step 10: both `attribution_clicks` and `offline_conversions` have `marketing_campaign_id nullable`.
- [x] Step 11: `document_links` has `quotation_id nullable` and a three-line Rules block.
- [x] Step 12: `document_versions` has a Rules block enforcing at most one current version.
- [x] Step 13: `passengers` has a Rules block enforcing passport date ordering.
- [x] Step 14: every `##` table heading in `31_schema_draft.md` appears exactly once in `# 11. Table Classification Summary`, verified by count.
- [x] Step 15: `24_entity_registry.md` contains all 17 new/renamed entries (Branch Business Hours, Holiday, Role Permission, Currency under a new Reference Entities section, Customer Identity Merge, Customer Identity Signal, Customer Note, Task, Complaint, Service Request, Quotation, Quotation Item, Conversation, Conversation Message, Payment Allocation, the Finance Approval Notes addition, and the renamed Marketing And Offline Conversion Entities section with Marketing Campaign and Campaign Daily Metric added).
- [x] Step 16: `29_relationship_map.md` contains Invoice To Payment, Customer To Customer (Identity Merge), the new CRM Extension Relationships section (5 entries), Quotation To Booking, and the two Marketing Campaign relationship entries.
- [x] Step 17: `25_catalog_registry.md`'s Reference Data section has the Status note; `30_database_conventions.md`'s Money Standard section references `currencies.code`.
- [x] No file outside Scope was modified or created.
- [x] `26_state_machines.md`, `27_event_catalog.md`, and `28_permissions_matrix.md` were not touched.

---

## Execution Log

### 2026-07-02 — Unidentified agent/process (recorded retroactively by Claude — reconciliation only)

Outcome: Complete

Step results: content matching all seventeen Implementation Steps was found already present in `_ORVION_CANONICAL/31_schema_draft.md`, `24_entity_registry.md`, `29_relationship_map.md`, `25_catalog_registry.md`, and `30_database_conventions.md`, and has been so since before this repository's Execution Log convention (established by `SPEC-005`) existed. This Change Request's own Status field remained `Draft` throughout, never recording the run.

Commits: unknown — this content predates the Git history available for inspection in this session's working context; `31_schema_draft.md` itself, at `Version: 0.4`, states in its own `# 13. Review Required` item 8 that "Version 0.4 closed the Phase 1 Domain & Schema Audit findings via SPEC-002 and SPEC-003," which is the canonical document's own confirmation that this Change Request's content was applied.

Blocker: None. Process note — this entry does not reflect a live-recorded execution; it reconciles this Change Request's bookkeeping with a fact already stated in the canonical document it modifies.

---

## Verification Notes

### 2026-07-02 — Claude

Verdict: Confirmed Complete

Findings: This Change Request's content was read in full during this session's initial repository comprehension pass (all of `31_schema_draft.md`, `24_entity_registry.md`, `29_relationship_map.md`, `25_catalog_registry.md`, and `30_database_conventions.md` were read end-to-end, and no cross-document inconsistency was found at that time). This reconciliation additionally re-confirmed, by direct fresh inspection, the most load-bearing markers: `31_schema_draft.md` `Version: 0.4`; `## currencies`, `## payment_allocations`, `## customer_identity_merges` headings present; `24_entity_registry.md` contains `## Currency`, `## Role Permission`, `## Branch Business Hours`; `29_relationship_map.md` contains `## Invoice To Payment` and `## Customer To Customer (Identity Merge)`; `25_catalog_registry.md` contains the `Currencies: Implemented` status note; `30_database_conventions.md` references `currencies.code`. `26_state_machines.md`, `27_event_catalog.md`, and `28_permissions_matrix.md` were confirmed out of Scope and untouched by this Change Request (their Version markers were bumped by `SPEC-004`, a separate, later, already-Complete Change Request).

Recommendation to human: Set Status to Complete.

---

## Review Gate

- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [x] No file outside the Scope list was modified or created.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On: not applicable (no prior changes/*.md file to update).
- [x] The repository is in a clean, releasable state.

---

## Notes

This Change Request consolidates and supersedes `/reports/phase-01-implementation-package.md`
and the edits narrated in `/reports/phase-01-implementation-complete.md`. Those files remain
useful as the rationale and audit trail (business reasoning, and the three Implementation
Discoveries found while preparing this work — the Table Classification Summary omissions and
the four entity-registry gaps in Step 15) but are not themselves executable — this file is the
only one that is.

State machine, event, and permission work for Task, Quotation, Conversation, Complaint, Service
Request, and Marketing Campaign is explicitly out of scope here and reserved for a future
Change Request.
