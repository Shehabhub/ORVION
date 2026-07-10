# Phase 2 Catalog & Lifecycle Audit — Prioritized Findings

Version: 0.1
Status: Final
Companion to: `reports/phase-02-catalog-lifecycle-audit.md`
Executable fix for the Required-Before-SQL items: `changes/SPEC-004-phase2-catalog-lifecycle.md`

Severity legend: **Critical** (blocks correct implementation / silent data-integrity risk), **High** (blocks a SQL engineer from proceeding without guessing), **Medium** (blocks correct application behavior but not table creation), **Low** (cosmetic / non-blocking).

---

## Required Before SQL

| # | Finding | Entity/File | Severity | Evidence |
| --- | --- | --- | --- | --- |
| 1 | No state machine, events, or permissions for **Task** | `26/27/28` vs. `31_schema_draft.md` `tasks` table | High | `task_status_code` has 5 catalog values (`25_catalog_registry.md`); zero coverage in all 3 target docs |
| 2 | No state machine, events, or permissions for **Complaint** | `complaints` table | High | `complaint_status_code` has 7 values; zero coverage |
| 3 | No state machine, events, or permissions for **Service Request** | `service_requests` table | High | `service_request_status_code` has 6 values; zero coverage |
| 4 | No state machine, events, or permissions for **Quotation** | `quotations` table | High | `quotation_status_code` has 6 values; zero coverage. Additionally: no event marks the Quotation→Booking acceptance transition that populates `bookings.quotation_id` |
| 5 | No state machine, events, or permissions for **Conversation** | `conversations` table | High | `conversation_status_code` has 6 values; zero coverage; department-handoff fields (`current_branch_id`/`current_department_id`) have no governing rule |
| 6 | No state machine, events, or permissions for **Marketing Campaign** | `marketing_campaigns` table | High | `campaign_status_code` has 5 values; zero coverage |
| 7 | `booking_item_base_status` catalog has 7 values; state machine only governs 5 | `26_state_machines.md` §Booking Item Base State Machine | High | `cancelled`/`no_show` are reachable per `booking_items` schema fields (`cancelled_at`, `no_show_at`, etc.) but have zero transition rules — a proven pre-existing blocker, not a Phase 1 redesign |
| 8 | 12 permission keys used in `28_permissions_matrix.md` are absent from `25_catalog_registry.md`'s `permission_key` catalog | Cross-document | High | `UPDATE_BOOKING_ITEM_STATUS`, `ASSIGN_SUPPLIER`, `ENTER_SELLING_PRICE`, `ENTER_COST`, `CREATE_INVOICE`, `CREATE_RECEIPT`, `RECORD_PAYMENT`, `RECORD_REFUND`, `CREATE_JOURNAL_ENTRY`, `VIEW_TRAVEL_DOCUMENTS`, `CREATE_DOCUMENT_VERSION`, `VIEW_SUBSCRIPTION_STATUS` — none seeded |
| 9 | `approval_requests` is generic across 7 approval types; `refund_approval`, `discount_approval`, `booking_override`, `manual_price_change`, `sensitive_data_change` have zero events/permissions | `25_catalog_registry.md` `approval_type_code` vs. `27/28` | Medium-High | Only `finance_execution_approval` and `subscription_approval` are governed; SPEC-004 adds a conservative generic fallback, not per-type nuance (see Open Questions below) |

## Required Before Application Code

| # | Finding | Entity/File | Severity |
| --- | --- | --- | --- |
| 10 | `conversation_messages` has no lifecycle events despite the schema draft's own text promising them | `31_schema_draft.md` `conversation_messages` Rules vs. `27_event_catalog.md` | Medium |
| 11 | `payment_allocation_created` event missing, despite `payment_allocations` driving `invoices.status_code` derivation | `27_event_catalog.md` | Medium |
| 12 | Fine-grained role mapping for `discount_approval`/`booking_override`/`manual_price_change`/`sensitive_data_change` beyond the conservative Owner/CEO/Finance-Manager default added by SPEC-004 | `28_permissions_matrix.md` | Medium |

## Recommended

| # | Finding | Severity |
| --- | --- | --- |
| 13 | No escalation/SLA timing rule for `urgent`/`critical` Complaints or Service Requests (unlike Leads' explicit 15-minute rule) | Low-Medium |
| 14 | `chart_of_accounts.account_type` has no governing catalog, despite `14_finance_rules.md` promising a default chart of accounts | Medium (deferred — out of SPEC-004 scope, recommend separate CR) |
| 15 | Dangling/unmatched code-fence (`` ``` ``) after every "Allowed Transitions" table in all 9 pre-existing state machines — cosmetic Markdown defect, uniform and pre-existing | Low |

## Future Enhancement

| # | Finding |
| --- | --- |
| 16 | Per-row events for `quotation_items` (line-item level) |
| 17 | Per-row events for `campaign_daily_metrics` (metric-ingestion audit trail) |

---

## Verified Complete (no action needed)

- **Customer Identity Merge** — entity, event (`customer_identity_merged`), and permission (`MERGE_CUSTOMER_IDENTITY`) are all present and consistent. Audited per the brief's explicit instruction to check it; found fully governed.
- **Payment Allocation** — correctly has no state machine (not a stateful entity); only its missing event (finding #11) is open.

---

## Open Questions Requiring a Business Decision (not resolved by SPEC-004)

These are explicitly **not** guessed or invented, per repository governance ("Never invent... business rules... Stop. Report the missing information," `global-rules.md`):

1. What role(s) should be authorized to review `discount_approval`, `booking_override`, `manual_price_change`, and `sensitive_data_change` approval requests? SPEC-004 applies a conservative Owner/CEO/Finance-Manager-only default (`REVIEW_APPROVAL_REQUEST`) so no approval type is left completely ungoverned, but does not assume finer per-type role logic.
2. Should Complaints and Service Requests have an explicit SLA/escalation timer analogous to the Lead 15-minute rule, or is manager-visible queue triage (as with Tasks) sufficient? Not addressed by SPEC-004.
3. Is a Task's `overdue` status meant to be system-set by a scheduled process (this audit's working assumption, applied conservatively in SPEC-004's Task State Machine) or should it be computed/derived like Lead SLA rather than stored? Confirm the intended mechanism before implementing the scheduler.

---

## Final Statement

Phase 2 is **not** complete as of this audit. The three Required-Before-SQL categories above (findings #1–9) are fully addressed by the deterministic, verification-gated Change Request `changes/SPEC-004-phase2-catalog-lifecycle.md`. Once SPEC-004 is executed and verified, findings #10–12 (Required Before Application Code) remain as documented, scoped follow-up work for the application layer, and findings #13–17 remain optional. No architecture was redesigned and no Phase 1 decision was reopened to produce these findings.
