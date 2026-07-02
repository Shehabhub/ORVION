# Phase 2 Catalog & Lifecycle Audit — Report

Version: 0.1
Status: Final
Audit Scope: `_ORVION_CANONICAL/26_state_machines.md`, `27_event_catalog.md`, `28_permissions_matrix.md`, cross-referenced against `24_entity_registry.md`, `25_catalog_registry.md`, `29_relationship_map.md`, `30_database_conventions.md`, `31_schema_draft.md` (v0.4, Frozen Baseline)
Mode: ANALYZE — no repository file was modified while producing this report.

---

## 1. Method

Every file in scope was read directly from disk in this session (not recalled from prior conversation state). For each entity named in the audit brief, the following was checked by direct text search across all eight documents:

1. Does the entity have a status/lifecycle column in `31_schema_draft.md`?
2. Does that status column's catalog exist in `25_catalog_registry.md`, and with what values?
3. Does `26_state_machines.md` contain a state machine section governing those values?
4. Does `27_event_catalog.md` contain lifecycle events for the entity's transitions?
5. Does `28_permissions_matrix.md` contain permission rows governing who may create/transition/view the entity?
6. Does `29_relationship_map.md` define the entity's ownership/relationship rules, and are they consistent with `31_schema_draft.md`'s actual columns?

Confirmed facts are cited with the exact document and, where useful, the exact catalog/state list found. No finding in this report is based on an assumption about a document's contents — every gap below was confirmed by direct inspection of the current file content, not inferred from its absence in a summary.

This audit does not reopen `31_schema_draft.md`, `24_entity_registry.md`, `29_relationship_map.md`, `25_catalog_registry.md`'s Reference Data section, or `30_database_conventions.md` — SPEC-002 and SPEC-003 are treated as closed and correct. Where this audit references those five files, it is only to verify what they already say, not to re-litigate their content.

---

## 2. Primary Finding

`31_schema_draft.md`, `# 13. Review Required`, item 8 (added by SPEC-003) states as fact:

> "State machines, events, and permissions for the CRM-extension entities (Task, Quotation, Conversation, Complaint, Service Request, Marketing Campaign) remain open and are explicitly deferred to the Phase 2 Catalog & Lifecycle Audit — no changes to `26_state_machines.md`, `27_event_catalog.md`, or `28_permissions_matrix.md` have been made as of this entry."

This audit **confirms that statement is accurate on every point** as of the current on-disk state. `26_state_machines.md`, `27_event_catalog.md`, and `28_permissions_matrix.md` are all still at `Version: 0.1, Status: Draft` — unchanged since before SPEC-002/003 — while `24_entity_registry.md`, `25_catalog_registry.md`, `29_relationship_map.md`, and `31_schema_draft.md` have all been revised (v0.2–v0.4). The six named entities all have tables in the frozen schema draft and catalog-controlled status columns, but zero governance in any of the three primary-scope documents.

---

## 3. Per-Entity Audit (entities named in the audit brief)

### 3.1 Task

| Check | Result |
| --- | --- |
| Schema table | `tasks` exists (`31_schema_draft.md` §3), with `task_type_code`, `task_status_code`, non-nullable `owner_user_id`/`owner_department_id`/`owner_branch_id` |
| Catalog | `task_type_code` (11 values), `task_status_code` — **5 values**: `open, in_progress, completed, cancelled, overdue` (`25_catalog_registry.md` §Task Catalogs) |
| State machine | **Missing.** No "Task State Machine" section anywhere in `26_state_machines.md`. |
| Events | **Missing.** No `task_*` event exists in `27_event_catalog.md`. |
| Permissions | **Missing.** No `CREATE_TASK`/`ASSIGN_TASK`/`COMPLETE_TASK`/task-visibility permission exists in `28_permissions_matrix.md`, and none of these keys exist in `25_catalog_registry.md`'s `permission_key` catalog either. |
| Ownership rule | `31_schema_draft.md` states "Every pending task must belong to exactly one responsible employee," matching `29_relationship_map.md`'s "Task is owned by exactly one User, Department, and Branch." Consistent — no gap here. |
| Notable ambiguity | `overdue` is a **stored** `task_status_code` value (unlike Lead SLA, which `26_state_machines.md` explicitly documents as "not a status field, derived from events"). Nothing defines what process transitions a task into `overdue`, or what states it may transition to/from. |

### 3.2 Complaint

| Check | Result |
| --- | --- |
| Schema table | `complaints` exists (`31_schema_draft.md` §3), `complaint_category_code`, `complaint_severity_code`, `complaint_status_code`, nullable owner fields |
| Catalog | `complaint_status_code` — **7 values**: `new, acknowledged, in_progress, awaiting_customer, awaiting_supplier, resolved, closed` |
| State machine | **Missing entirely.** |
| Events | **Missing entirely.** No `complaint_*` event exists. |
| Permissions | **Missing entirely.** No `CREATE_COMPLAINT`/`RESOLVE_COMPLAINT`/visibility permission exists anywhere. |
| Relationship/ownership | `29_relationship_map.md` §CRM Extension Relationships defines Customer→Complaint and Booking/Booking Item→Complaint cardinalities correctly; no gap there. Owner fields are nullable (unlike Task's non-nullable owner), and no rule states whether an unowned complaint is valid business state — plausible, since resolution work can route through a linked `Task`, but this is not stated anywhere. |
| Notable ambiguity | `complaint_severity_code` includes `urgent`/`critical`, but — unlike Leads' explicit 15-minute SLA — no escalation timing rule exists for high-severity complaints. |

### 3.3 Service Request

| Check | Result |
| --- | --- |
| Schema table | `service_requests` exists, `service_request_type_code`, `service_request_severity_code`, `service_request_status_code`, nullable owner fields |
| Catalog | `service_request_status_code` — **6 values**: `requested, in_progress, awaiting_customer, awaiting_supplier, resolved, closed` |
| State machine | **Missing entirely.** |
| Events | **Missing entirely.** |
| Permissions | **Missing entirely.** |
| Relationship/ownership | Correctly defined in `29_relationship_map.md`; same "no escalation timing rule for high severity" ambiguity as Complaint. |

### 3.4 Quotation

| Check | Result |
| --- | --- |
| Schema table | `quotations` exists, `quotation_status_code`, `currency_code`, `total_amount` |
| Catalog | `quotation_status_code` — **6 values**: `draft, sent, accepted, rejected, expired, cancelled` |
| State machine | **Missing entirely.** |
| Events | **Missing entirely.** Note: `27_event_catalog.md` has `lead_quotation_sent` under **Lead Events**, but that is the *lead's* milestone event, not a `quotation`-entity event — it carries no `quotation_id` and does not fire for quotations created directly against a `customer_id` (quotations may originate without a lead per `29_relationship_map.md`). |
| Permissions | **Missing entirely.** No `CREATE_QUOTATION`/`SEND_QUOTATION`/`ACCEPT_QUOTATION`. |
| Relationship | `29_relationship_map.md` states "Quotation may produce zero or one Booking upon acceptance" (`quotation 1 -> 0..1 booking`) and `31_schema_draft.md`'s `bookings` table carries `quotation_id nullable` (added by SPEC-002). **No event marks the accept-to-booking-creation transition** — nothing in the event catalog explains how/when `bookings.quotation_id` gets populated, which is a direct implementation blocker for whoever writes the booking-creation code path. |

### 3.5 Quotation Item

| Check | Result |
| --- | --- |
| Schema table | `quotation_items` exists, reuses `service_type_code` (already governed by an existing state machine indirectly via `booking_items`) and `currency_code` |
| Catalog | No dedicated status column exists on `quotation_items` — item state is implicit in the parent Quotation's status. This is a reasonable design, not a gap. |
| State machine | Not applicable (no status column) — confirmed by inspection, not assumed. |
| Events | No item-level events exist; this is consistent with how `quotation_items` has no status of its own. **Not a blocker** — flagged as Recommended only (§5). |
| Permissions | Covered implicitly by Quotation permissions once those exist (§3.4). |

### 3.6 Conversation

| Check | Result |
| --- | --- |
| Schema table | `conversations` exists, `channel_code`, `conversation_status_code`, plus `current_branch_id`/`current_department_id` for department handoffs |
| Catalog | `conversation_status_code` — **6 values**: `open, assigned, pending_customer, pending_internal, escalated, closed` |
| State machine | **Missing entirely.** The schema draft's own notes describe `current_branch_id`/`current_department_id` as supporting "active department handoffs" — a real operational transition with zero governing rule for who may hand a conversation off or what state it must be in to do so. |
| Events | **Missing entirely.** No `conversation_*` event exists. |
| Permissions | **Missing entirely.** |

### 3.7 Conversation Message

| Check | Result |
| --- | --- |
| Schema table | `conversation_messages` exists, `sender_type_code`, `message_direction_code` |
| Catalog | Governed by `sender_type_code`/`message_direction_code`, both present and complete. |
| State machine | Not applicable (no status column) — correct, not a gap. |
| Events | **Missing.** `31_schema_draft.md`'s own Rules text for this table states: "Business-critical outcomes should be recorded in `lead_interactions` and events" — but no `conversation_message_*` event type exists anywhere in `27_event_catalog.md`. The schema draft promises event coverage that the event catalog does not deliver. |
| Permissions | **Missing.** No `VIEW_CONVERSATION`/`SEND_MESSAGE` permission. |

### 3.8 Marketing Campaign

| Check | Result |
| --- | --- |
| Schema table | `marketing_campaigns` exists (added by SPEC-002), `platform_code`, `status_code` |
| Catalog | `campaign_status_code` — **5 values**: `draft, active, paused, ended, archived` |
| State machine | **Missing entirely.** |
| Events | **Missing entirely.** No `marketing_campaign_*` event exists. |
| Permissions | **Missing entirely.** |
| Ownership | No owner_user_id/branch/department fields exist on `marketing_campaigns` (tenant-scoped only) — this is an intentional, reasonable design (a tenant-wide marketing dashboard concept), not a gap. |

### 3.9 Campaign Daily Metric

| Check | Result |
| --- | --- |
| Schema table | `campaign_daily_metrics` exists (added by SPEC-002), pure metrics row (spend, impressions, clicks, leads, bookings, revenue) |
| Catalog | No status column — none required. |
| State machine | Not applicable — correct, not a gap. |
| Events | No event exists for metric ingestion. Flagged as Recommended only (§5) — this is an analytics-ingestion table, not a business-workflow entity with a lifecycle. |
| Permissions | No dedicated `VIEW_MARKETING_DASHBOARD` permission exists yet; folded into the Marketing Campaign gap (§3.8). |

### 3.10 Payment Allocation

| Check | Result |
| --- | --- |
| Schema table | `payment_allocations` exists (added by SPEC-002), links `payment_id` + `invoice_id`, no status column |
| Catalog | No status catalog needed — this is a pure junction/settlement record, not a stateful entity. Confirmed correct design, not a gap. |
| State machine | Not applicable — correctly absent. |
| Events | **Missing.** No `payment_allocation_created` event exists. This matters because `31_schema_draft.md`'s own text states: *"`invoice_status_code` values `partially_paid` and `paid` are derived from the sum of this table's allocated amounts for the invoice"* — meaning `payment_allocations` rows drive a real financial state transition (`invoices.status_code`) with no event marking either the allocation itself or the resulting invoice status change (see §4 for the related, broader `invoices` gap). |
| Permissions | No dedicated permission exists for allocating a payment to an invoice, distinct from `RECORD_PAYMENT`. Minor — folded into the Finance permission-key gap in §4. |

### 3.11 Customer Identity Merge

| Check | Result |
| --- | --- |
| Schema table | `customer_identity_merges` exists (added by SPEC-002) |
| Catalog | No status column needed — a merge is a single atomic recorded action, not a multi-state entity. |
| State machine | Not applicable — correctly absent. |
| Events | **Present.** `customer_identity_merged` already exists in `27_event_catalog.md` §Customer Events (severity: critical; requires actor, source, target, reason) — matches `31_schema_draft.md`'s note that the table "supplements, and does not replace" this event. |
| Permissions | **Present.** `MERGE_CUSTOMER_IDENTITY` exists in `28_permissions_matrix.md` §CRM Permissions and in `25_catalog_registry.md`'s `permission_key` catalog. |
| Verdict | **Fully governed. No gap.** This entity was audited in full per the brief and found complete — reported here for completeness, not as a finding. |

---

## 4. Cross-Cutting Findings (discovered during mandatory cross-referencing, not confined to the 11 named entities)

These were found while verifying the 11 named entities against the full set of cross-reference documents, as instructed. Each is objectively evidenced below, not inferred from absence in a summary.

### 4.1 `booking_item_base_status` catalog has two values with zero governing transitions

`25_catalog_registry.md` defines `booking_item_base_status` with **7 values**: `draft, pending, confirmed, in_progress, completed, cancelled, no_show`.

`26_state_machines.md` §Booking Item Base State Machine lists only **5 states**: `draft, pending, confirmed, in_progress, completed` — `cancelled` and `no_show` are absent from both the `## States` list and the `## Allowed Transitions` table.

This is not theoretical: `31_schema_draft.md`'s `booking_items` table carries `cancellation_reason_code`, `cancelled_at`, `cancelled_by`, `no_show_at`, `no_show_recorded_by` fields, with the explicit note "Booking items may be cancelled or marked no-show independently of parent booking state." The schema assumes these states are reachable; the state machine does not say from which states, or whether they are terminal. A SQL engineer implementing a `base_status_code` transition constraint would have to guess.

This gap pre-dates SPEC-002/003 (which explicitly excluded `26_state_machines.md` from their scope) and is exactly the class of "proven implementation blocker" the audit brief authorizes reporting even though Phase 1 is closed.

### 4.2 12 permission keys used in `28_permissions_matrix.md` do not exist in `25_catalog_registry.md`'s `permission_key` catalog

`28_permissions_matrix.md` references, in its Booking, Finance, and Document permission tables: `UPDATE_BOOKING_ITEM_STATUS`, `ASSIGN_SUPPLIER`, `ENTER_SELLING_PRICE`, `ENTER_COST`, `CREATE_INVOICE`, `CREATE_RECEIPT`, `RECORD_PAYMENT`, `RECORD_REFUND`, `CREATE_JOURNAL_ENTRY`, `VIEW_TRAVEL_DOCUMENTS`, `CREATE_DOCUMENT_VERSION`, `VIEW_SUBSCRIPTION_STATUS`.

None of these 12 keys appear in `25_catalog_registry.md`'s `## permission_key` Initial values list (31 keys total, checked exhaustively against the permissions matrix). Since `permission_key` is a System Catalog ("Employees must not create... permission keys freely," `25_catalog_registry.md` §Purpose) that must be seeded before RLS/permission-check logic can reference it, this is a real seed-data gap, not a cosmetic one — permissions_matrix.md is currently specifying enforcement for permission keys that the catalog registry never declared to exist.

### 4.3 `approval_requests` is generic across 7 approval types; only 2 of the 7 have any event/permission coverage

`25_catalog_registry.md`'s `approval_type_code` lists 7 values: `finance_execution_approval, refund_approval, discount_approval, booking_override, manual_price_change, sensitive_data_change, subscription_approval`. `31_schema_draft.md` confirms `approval_requests` is the single generic table backing all 7 (Review Required item 5).

- `finance_execution_approval` — fully covered (`finance_approval_*` events, `APPROVE_FINANCE` permission).
- `subscription_approval` — fully covered (`subscription_payment_proof_uploaded/approved/rejected` events, `REVIEW_SUBSCRIPTION_PAYMENT` permission).
- `refund_approval, discount_approval, booking_override, manual_price_change, sensitive_data_change` — **zero events, zero permissions, zero entity registry notes.** These 5 values exist only as catalog strings; nothing in the repository defines what happens when one is requested, approved, or rejected, or who is authorized to review it.

### 4.4 `chart_of_accounts.account_type` has no governing catalog

`31_schema_draft.md`'s `chart_of_accounts` table has an `account_type` column (note: without the `_code` suffix the rest of the schema uses for catalog-controlled fields — see `30_database_conventions.md` §Naming Rules: "Use `{catalog}_code` for stable machine code values"). No `account_type` catalog (e.g., asset/liability/equity/revenue/expense) exists in `25_catalog_registry.md`. `14_finance_rules.md` explicitly promises "The system provides a default chart of accounts" — that default cannot be seeded without a governed set of account types. This is a real gap but is deliberately **excluded from SPEC-004** (see Out of Scope) because it touches finance-schema territory adjacent to, but outside, the state-machine/event/permission mandate of this audit; it is recommended as a follow-up CR.

### 4.5 Minor: dangling code-fence typo in every existing state machine section (cosmetic)

Every "Allowed Transitions" table in the 9 pre-existing state machines in `26_state_machines.md` (Lead, Booking, Booking Item, Finance Approval, Document, Subscription, Offline Conversion Delivery, Trusted Device, OTP Challenge) is followed by a stray unmatched "```" line — a leftover code-fence marker with no corresponding opener for that block. This is a pure Markdown rendering defect, uniform across all 9 sections, present before this audit. It does not affect meaning and is not a Phase 1 decision to reopen. Flagged as Low/Recommended only; not corrected by SPEC-004 to avoid an unrelated, purely-cosmetic mass edit inside a document whose substantive content this audit is otherwise extending.

---

## 5. Distinguishing Required-Before-SQL from Recommended / Future

`22_database_ready_gap_analysis.md`'s own Risk Assessment states: *"No schema should be written before entity registry, catalog registry, state machines, event catalog, and relationship map exist."* Since `31_schema_draft.md` already contains tables for all 11 named entities, but 3 of the 5 prerequisite documents (state machines, events, permissions) do not yet govern 6 of those entities, this audit classifies the primary findings (§3.1–3.4, 3.6–3.8, and §4.1–4.3) as **Required Before SQL** — consistent with the project's own previously-stated gating policy, not a new standard invented for this audit.

| Category | Findings |
| --- | --- |
| **Required Before SQL** | Task, Complaint, Service Request, Quotation, Conversation, Marketing Campaign state machines/events/permissions (§3.1, 3.2, 3.3, 3.4, 3.6, 3.8); `booking_item_base_status` cancelled/no_show gap (§4.1); missing 12 permission_key catalog entries (§4.2); generic approval-type event/permission gap for the 4 non-financial, non-subscription approval types (§4.3, conservative fix only — see SPEC-004 Notes) |
| **Required Before Application Code** | `conversation_message_*` events (§3.7); `payment_allocation_created` event (§3.10); exact role-mapping refinement for `discount_approval`/`booking_override`/`manual_price_change`/`sensitive_data_change` beyond the conservative default added by SPEC-004 (§4.3) |
| **Recommended** | Escalation/SLA timing rule for high-severity Complaints/Service Requests (§3.2, 3.3); `chart_of_accounts.account_type` catalog (§4.4); dangling code-fence cleanup (§4.5) |
| **Future Enhancement** | `quotation_items`/`campaign_daily_metrics` per-row events (§3.5, 3.9) |

---

## 6. Verdict

Phase 2 is **not** yet complete. Six named entities (Task, Complaint, Service Request, Quotation, Conversation, Marketing Campaign) have schema tables and catalog-controlled status columns but no governing state machine, no lifecycle events, and no permission coverage — confirming `31_schema_draft.md` Review Required item 8's own prediction. Three cross-cutting gaps were additionally found during mandatory cross-referencing (§4.1–4.3) that meet the audit brief's bar for "an implementation blocker that would force the SQL engineer to guess." An executable, deterministic Change Request (`changes/SPEC-004-phase2-catalog-lifecycle.md`) has been produced to close all of these without reopening any Phase 1 decision or redesigning any existing architecture.
