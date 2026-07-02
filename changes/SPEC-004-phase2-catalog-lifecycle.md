# Change Request — SPEC-004

## Status

[x] Approved

---

## Assigned Model Tier

[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Apply the Phase 2 Catalog & Lifecycle Audit's approved state-machine, event, and permission findings to the four canonical documents listed in Scope below.

---

## Business Reason

The Phase 2 Catalog & Lifecycle Audit (`reports/phase-02-catalog-lifecycle-audit.md`, `reports/phase-02-prioritized-findings.md`) confirmed the open item recorded in `_ORVION_CANONICAL/31_schema_draft.md` `# 13. Review Required` item 8: six CRM-extension entities that already have tables in the frozen schema draft — Task, Complaint, Service Request, Quotation, Conversation, Marketing Campaign — have catalog-controlled status columns but no governing state machine, no lifecycle events, and no permission coverage in `26_state_machines.md`, `27_event_catalog.md`, or `28_permissions_matrix.md`. The audit additionally found, through mandatory cross-document verification, three further gaps that meet the same bar (an implementation blocker that would force a SQL engineer to guess): the `booking_item_base_status` catalog has two values (`cancelled`, `no_show`) with no governing transitions even though the schema draft's own `booking_items` fields assume they are reachable; 12 permission keys used in `28_permissions_matrix.md` were never added to `25_catalog_registry.md`'s `permission_key` catalog; and 5 of the 7 `approval_type_code` values have zero event or permission coverage. This task closes all nine findings additively.

---

## Risks

Low. Every edit is additive (new sections, new table rows, new catalog values) — no existing state, transition, event, permission, or catalog value is removed, renamed, or reordered. New content follows the exact structural pattern already used by the surrounding sections in each file (same heading levels, same table column layouts, same Severity vocabulary), so it does not introduce a new format. The main risk is divergence between this repository's actual current state and the state assumed when this task was written, which is why every step below is verification-gated rather than assumed. If any verification check produces an unexpected partial match, the correct behavior is to stop and report, not to guess. One deliberate, conservative judgment call is documented in Step 13 (`REVIEW_APPROVAL_REQUEST` role mapping) — it is flagged there and in `reports/phase-02-prioritized-findings.md` as an open business decision, not a resolved one, and no other step contains an unflagged judgment call.

---

## Supersedes / Depends On

Supersedes: None.

Depends on: SPEC-002-phase1-database-foundation.md and SPEC-003-phase1-consistency-fix.md must already be applied — this task's verification checks assume `31_schema_draft.md` is at `Version: 0.4`, `Status: Frozen Baseline`, and contains `# 13. Review Required` item 8 in the form both prior Change Requests left it. This task does not modify `31_schema_draft.md`.

---

## Scope — Files Allowed to Modify

- _ORVION_CANONICAL/26_state_machines.md
- _ORVION_CANONICAL/27_event_catalog.md
- _ORVION_CANONICAL/28_permissions_matrix.md
- _ORVION_CANONICAL/25_catalog_registry.md

---

## Out of Scope — Files Forbidden to Modify

Scope above is exhaustive. Every other file in the repository is out of scope, with no exceptions, including but not limited to:

- _ORVION_CANONICAL/31_schema_draft.md (frozen baseline — no schema/table changes in this task)
- _ORVION_CANONICAL/24_entity_registry.md
- _ORVION_CANONICAL/29_relationship_map.md
- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/00_project_charter.md through _ORVION_CANONICAL/23_database_ready_package_plan.md (all business-rule and pre-database-decision documents)
- _ORVION_CANONICAL/32_execution_roadmap.md
- _ORVION_CANONICAL/SYSTEM_PROMPT.md, _ORVION_CANONICAL/codex.md, _ORVION_CANONICAL/manifest.md
- changes/SPEC-002-phase1-database-foundation.md, changes/SPEC-003-phase1-consistency-fix.md (historical records — do not edit)
- reports/phase-02-catalog-lifecycle-audit.md, reports/phase-02-prioritized-findings.md (audit deliverables — do not edit)
- Any governance file (AGENTS.md, PROTOCOL.md, README.md, global-rules.md, PROJECT_CONTEXT.md, CODING_STANDARDS.md)

In particular: `chart_of_accounts.account_type`'s missing catalog (audit finding #14, "Recommended") and the dangling code-fence typo in the 9 pre-existing state machines (audit finding #15, "Low") are explicitly out of scope for this task and reserved for a future Change Request if approved.

---

## Minimum Reading List

- _ORVION_CANONICAL/26_state_machines.md
- _ORVION_CANONICAL/27_event_catalog.md
- _ORVION_CANONICAL/28_permissions_matrix.md
- _ORVION_CANONICAL/25_catalog_registry.md
- reports/phase-02-catalog-lifecycle-audit.md
- reports/phase-02-prioritized-findings.md

---

## Implementation Steps

### Step 1 — Version marker: `26_state_machines.md`

Verify: search for the exact line `Version: 0.2` in `_ORVION_CANONICAL/26_state_machines.md`.
- If found: Already Applied, skip.
- If not found (file shows `Version: 0.1`): replace `Version: 0.1` with `Version: 0.2`.

### Step 2 — Version marker: `27_event_catalog.md`

Verify: search for the exact line `Version: 0.2` in `_ORVION_CANONICAL/27_event_catalog.md`.
- If found: Already Applied, skip.
- If not found (file shows `Version: 0.1`): replace `Version: 0.1` with `Version: 0.2`.

### Step 3 — Version marker: `28_permissions_matrix.md`

Verify: search for the exact line `Version: 0.2` in `_ORVION_CANONICAL/28_permissions_matrix.md`.
- If found: Already Applied, skip.
- If not found (file shows `Version: 0.1`): replace `Version: 0.1` with `Version: 0.2`.

### Step 4 — Version marker: `25_catalog_registry.md`

Verify: search for the exact line `Version: 0.3` in `_ORVION_CANONICAL/25_catalog_registry.md`.
- If found: Already Applied, skip.
- If not found (file shows `Version: 0.2`): replace `Version: 0.2` with `Version: 0.3`.

### Step 5 — `booking_item_base_status` states, transitions, and terminal states

File: `_ORVION_CANONICAL/26_state_machines.md`
Verify: within the `# Booking Item Base State Machine` section, search for the exact string `- no_show`.
- If found: Already Applied, skip.
- If not found: locate this exact block (the entire `## States` through `## Sub-Status Rule` heading of that section):

```
## States

- draft
- pending
- confirmed
- in_progress
- completed

## Normal Flow

```text
draft
  -> pending
  -> confirmed
  -> in_progress
  -> completed
```

## Allowed Transitions

| From | To | Rule |
| --- | --- | --- |
| draft | pending | Item submitted for approval or supplier action |
| draft | completed | Allowed only for simple already-completed manual item with authorized permission |
| pending | confirmed | Supplier/finance/operations confirms item |
| pending | draft | Returned for correction |
| confirmed | in_progress | Work starts or service execution begins |
| confirmed | completed | Allowed when service does not require in-progress step |
| in_progress | completed | Service completed |
```

## Sub-Status Rule
```

Replace it in full with:

```
## States

- draft
- pending
- confirmed
- in_progress
- completed
- cancelled
- no_show

## Normal Flow

```text
draft
  -> pending
  -> confirmed
  -> in_progress
  -> completed
```

## Allowed Transitions

| From | To | Rule |
| --- | --- | --- |
| draft | pending | Item submitted for approval or supplier action |
| draft | completed | Allowed only for simple already-completed manual item with authorized permission |
| draft | cancelled | Booking item cancelled before confirmation |
| pending | confirmed | Supplier/finance/operations confirms item |
| pending | draft | Returned for correction |
| pending | cancelled | Booking item cancelled while pending |
| confirmed | in_progress | Work starts or service execution begins |
| confirmed | completed | Allowed when service does not require in-progress step |
| confirmed | cancelled | Booking item cancelled after confirmation, per cancellation workflow |
| confirmed | no_show | Passenger/traveler did not show for a time-bound service |
| in_progress | completed | Service completed |
| in_progress | cancelled | Booking item cancelled during execution, per cancellation workflow |
| in_progress | no_show | Passenger/traveler did not show during execution |
```

## Terminal States

- cancelled
- no_show

Terminal states may not be edited directly. Corrections require adjustment events or authorized reopening in a future policy, consistent with the Booking State Machine's terminal-state rule.

## Sub-Status Rule
```

Do not alter the `## Sub-Status Rule` section or anything after it in this step.

### Step 6 — `booking_item_base_status` required events extension

File: `_ORVION_CANONICAL/26_state_machines.md`
Verify: within the `# Booking Item Base State Machine` section, search for the exact string `booking_item_cancelled`.
- If found: Already Applied, skip.
- If not found: locate that section's `## Required Events` list, which reads exactly:

```
## Required Events

- booking_item_created
- booking_item_pending
- booking_item_confirmed
- booking_item_in_progress
- booking_item_completed
- booking_item_sub_status_changed

---

# Finance Approval State Machine
```

Replace it with:

```
## Required Events

- booking_item_created
- booking_item_pending
- booking_item_confirmed
- booking_item_in_progress
- booking_item_completed
- booking_item_sub_status_changed
- booking_item_cancelled
- booking_item_no_show_recorded

---

# Finance Approval State Machine
```

### Step 7 — Insert six new state machine sections

File: `_ORVION_CANONICAL/26_state_machines.md`
Verify: search for the exact heading `# Task State Machine`.
- If found: Already Applied, skip.
- If not found: locate the exact tail of the file:

```
## Required Events

- otp_requested
- otp_verified
- otp_failed
- otp_expired

---

# Next Step

Create `27_event_catalog.md`.
```

Insert the following block immediately after `- otp_expired` and before the `---` that precedes `# Next Step` (i.e. the inserted block becomes a new set of `---`-separated sections, and the file still ends with the original `---\n\n# Next Step\n\nCreate `27_event_catalog.md`.` unchanged):

```

---

# Task State Machine

## States

- open
- in_progress
- completed
- cancelled
- overdue

## Normal Flow

```text
open
  -> in_progress
  -> completed
```

## Allowed Transitions

| From | To | Rule |
| --- | --- | --- |
| open | in_progress | Responsible employee starts work |
| open | completed | Allowed for tasks completed without a distinct in-progress step |
| open | cancelled | Task cancelled before completion |
| open | overdue | System-set when due_at passes without completion |
| in_progress | completed | Task completed |
| in_progress | cancelled | Task cancelled during execution |
| in_progress | overdue | System-set when due_at passes without completion |
| overdue | in_progress | Work resumed on an overdue task |
| overdue | completed | Task completed after its due date |
| overdue | cancelled | Overdue task cancelled |

## Terminal States

- completed
- cancelled

## Required Events

- task_created
- task_assigned
- task_completed
- task_cancelled
- task_overdue

---

# Complaint State Machine

## States

- new
- acknowledged
- in_progress
- awaiting_customer
- awaiting_supplier
- resolved
- closed

## Normal Flow

```text
new
  -> acknowledged
  -> in_progress
  -> resolved
  -> closed
```

## Allowed Transitions

| From | To | Rule |
| --- | --- | --- |
| new | acknowledged | Complaint acknowledged by responsible employee |
| acknowledged | in_progress | Investigation or resolution work started |
| in_progress | awaiting_customer | Waiting on customer response or documents |
| in_progress | awaiting_supplier | Waiting on supplier response |
| awaiting_customer | in_progress | Customer responded |
| awaiting_supplier | in_progress | Supplier responded |
| in_progress | resolved | Resolution provided to customer |
| resolved | closed | Complaint closed after resolution |
| closed | in_progress | Reopened with reason by authorized user |

## Terminal States

Terminal unless reopened by authorized action:

- closed

## Required Events

- complaint_created
- complaint_acknowledged
- complaint_in_progress
- complaint_awaiting_customer
- complaint_awaiting_supplier
- complaint_resolved
- complaint_closed
- complaint_reopened

---

# Service Request State Machine

## States

- requested
- in_progress
- awaiting_customer
- awaiting_supplier
- resolved
- closed

## Normal Flow

```text
requested
  -> in_progress
  -> resolved
  -> closed
```

## Allowed Transitions

| From | To | Rule |
| --- | --- | --- |
| requested | in_progress | Work started on the request |
| in_progress | awaiting_customer | Waiting on customer response or documents |
| in_progress | awaiting_supplier | Waiting on supplier response |
| awaiting_customer | in_progress | Customer responded |
| awaiting_supplier | in_progress | Supplier responded |
| in_progress | resolved | Request resolved |
| resolved | closed | Request closed after resolution |
| closed | in_progress | Reopened with reason by authorized user |

## Terminal States

Terminal unless reopened by authorized action:

- closed

## Required Events

- service_request_created
- service_request_in_progress
- service_request_awaiting_customer
- service_request_awaiting_supplier
- service_request_resolved
- service_request_closed
- service_request_reopened

---

# Quotation State Machine

## States

- draft
- sent
- accepted
- rejected
- expired
- cancelled

## Normal Flow

```text
draft
  -> sent
  -> accepted
```

## Allowed Transitions

| From | To | Rule |
| --- | --- | --- |
| draft | sent | Quotation sent to customer |
| draft | cancelled | Quotation cancelled before sending |
| sent | accepted | Customer accepts the quotation |
| sent | rejected | Customer rejects the quotation |
| sent | expired | valid_until passes without customer response |
| sent | cancelled | Quotation withdrawn before customer response |
| rejected | draft | Revised and prepared for resending |
| expired | draft | Revised and prepared for resending |

## Terminal States

- accepted
- cancelled

Terminal unless reopened by authorized action:

- rejected
- expired

## Effects

When accepted:

- Quotation may produce a Booking, which references the Quotation via `bookings.quotation_id`.
- `quotation_accepted` event is created.

## Required Events

- quotation_created
- quotation_sent
- quotation_accepted
- quotation_rejected
- quotation_expired
- quotation_cancelled
- quotation_revised

---

# Conversation State Machine

## States

- open
- assigned
- pending_customer
- pending_internal
- escalated
- closed

## Normal Flow

```text
open
  -> assigned
  -> closed
```

## Allowed Transitions

| From | To | Rule |
| --- | --- | --- |
| open | assigned | Conversation assigned to a user or department |
| assigned | pending_customer | Waiting on customer reply |
| assigned | pending_internal | Waiting on internal department or supplier |
| pending_customer | assigned | Customer replied |
| pending_internal | assigned | Internal response received |
| assigned | escalated | Escalated to a manager or another department |
| escalated | assigned | De-escalated back to normal handling |
| assigned | closed | Conversation closed |
| pending_customer | closed | Conversation closed without further customer response |
| escalated | closed | Conversation closed after escalation resolved |
| closed | open | Reopened with reason by authorized user |

## Terminal States

Terminal unless reopened by authorized action:

- closed

## Required Events

- conversation_started
- conversation_assigned
- conversation_escalated
- conversation_closed
- conversation_reopened

---

# Marketing Campaign State Machine

## States

- draft
- active
- paused
- ended
- archived

## Normal Flow

```text
draft
  -> active
  -> ended
  -> archived
```

## Allowed Transitions

| From | To | Rule |
| --- | --- | --- |
| draft | active | Campaign launched |
| active | paused | Campaign paused |
| paused | active | Campaign resumed |
| active | ended | Campaign ended |
| paused | ended | Campaign ended while paused |
| ended | archived | Campaign archived after ending |

## Terminal States

- archived

## Required Events

- marketing_campaign_created
- marketing_campaign_activated
- marketing_campaign_paused
- marketing_campaign_ended
- marketing_campaign_archived

```

### Step 8 — Booking Item Events extension

File: `_ORVION_CANONICAL/27_event_catalog.md`
Verify: search for the exact heading `## booking_item_cancelled`.
- If found: Already Applied, skip.
- If not found: locate the exact block:

```
## booking_item_risk_flag_created

Severity: risk

Triggers:

- Issuance before full collection

Requires:

- Permission used
- Customer balance snapshot
- Reason

---

# Passenger Events
```

Insert immediately after the `Requires:` list ending in `- Reason` and before `---\n\n# Passenger Events`:

```

## booking_item_cancelled

Severity: warning

Requires:

- Cancellation reason

## booking_item_no_show_recorded

Severity: warning

```

### Step 9 — Finance Events: generic approval events

File: `_ORVION_CANONICAL/27_event_catalog.md`
Verify: search for the exact heading `## approval_requested`.
- If found: Already Applied, skip.
- If not found: locate the exact block:

```
## finance_approval_resubmitted

Severity: info

## payment_recorded

Severity: info
```

Replace it with:

```
## finance_approval_resubmitted

Severity: info

## approval_requested

Severity: info

Triggers:

- Any `approval_requests` row created for an `approval_type_code` other than `finance_execution_approval`, which continues to use `finance_approval_requested`

## approval_approved

Severity: critical

## approval_rejected

Severity: warning

## approval_cancelled

Severity: warning

## approval_resubmitted

Severity: info

## payment_recorded

Severity: info
```

### Step 10 — Finance Events: `payment_allocation_created`

File: `_ORVION_CANONICAL/27_event_catalog.md`
Verify: search for the exact heading `## payment_allocation_created`.
- If found: Already Applied, skip.
- If not found: locate the exact block:

```
## payment_recorded

Severity: info

## receipt_created
```

Replace it with:

```
## payment_recorded

Severity: info

## payment_allocation_created

Severity: info

Requires:

- Invoice
- Payment
- Allocated amount

## receipt_created
```

Note: this step depends on Step 9 having already inserted an `## payment_recorded` block ahead of `## receipt_created`; if Step 9 was itself Already Applied, this anchor is still valid since Step 9's replacement preserves `## payment_recorded` immediately before `## receipt_created` in both the pre- and post-Step-9 states.

### Step 11 — Insert six new top-level event sections

File: `_ORVION_CANONICAL/27_event_catalog.md`
Verify: search for the exact heading `# Task Events`.
- If found: Already Applied, skip.
- If not found: locate the exact block:

```
## offline_conversion_retried

Severity: warning

---

# Events Not Required
```

Insert immediately after `Severity: warning` (the one belonging to `offline_conversion_retried`) and before `---\n\n# Events Not Required`:

```

---

# Task Events

## task_created

Severity: info

## task_assigned

Severity: info

## task_completed

Severity: info

## task_cancelled

Severity: warning

## task_overdue

Severity: warning

---

# Complaint Events

## complaint_created

Severity: warning

## complaint_acknowledged

Severity: info

## complaint_in_progress

Severity: info

## complaint_awaiting_customer

Severity: info

## complaint_awaiting_supplier

Severity: info

## complaint_resolved

Severity: info

## complaint_closed

Severity: info

## complaint_reopened

Severity: warning

Requires:

- Reopen reason
- Authorized actor

---

# Service Request Events

## service_request_created

Severity: info

## service_request_in_progress

Severity: info

## service_request_awaiting_customer

Severity: info

## service_request_awaiting_supplier

Severity: info

## service_request_resolved

Severity: info

## service_request_closed

Severity: info

## service_request_reopened

Severity: warning

Requires:

- Reopen reason
- Authorized actor

---

# Quotation Events

## quotation_created

Severity: info

## quotation_sent

Severity: info

## quotation_accepted

Severity: info

Effects:

- May produce a Booking referencing the Quotation via `bookings.quotation_id`

## quotation_rejected

Severity: info

## quotation_expired

Severity: warning

## quotation_cancelled

Severity: warning

## quotation_revised

Severity: info

---

# Conversation Events

## conversation_started

Severity: info

## conversation_assigned

Severity: info

## conversation_escalated

Severity: warning

## conversation_closed

Severity: info

## conversation_reopened

Severity: warning

Requires:

- Reopen reason
- Authorized actor

## conversation_message_received

Severity: info

## conversation_message_sent

Severity: info

---

# Marketing Campaign Events

## marketing_campaign_created

Severity: info

## marketing_campaign_activated

Severity: info

## marketing_campaign_paused

Severity: info

## marketing_campaign_ended

Severity: info

## marketing_campaign_archived

Severity: info

```

### Step 12 — Insert CRM Extension Permissions section

File: `_ORVION_CANONICAL/28_permissions_matrix.md`
Verify: search for the exact heading `# CRM Extension Permissions`.
- If found: Already Applied, skip.
- If not found: locate the exact block:

```
Notes:

- Sales employee sees assigned leads only by default.
- Department queue visibility requires explicit permission.
- Customer merge is sensitive and must create event.

---

# Booking Permissions
```

Insert immediately after that Notes block and before `---\n\n# Booking Permissions`:

```

---

# CRM Extension Permissions

| Permission | Owner | CEO | Branch Manager | Department Manager | Senior Employee | Employee | Trainee | Scope |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| CREATE_TASK | Yes | Yes | Yes | Yes | Yes | Yes | Limited | branch/department |
| ASSIGN_TASK | Yes | Yes | Yes | Yes | Optional | No | No | branch/department |
| COMPLETE_TASK | Yes | Yes | Yes | Yes | Yes | Assigned only | No | assigned |
| VIEW_ASSIGNED_TASKS | Yes | Yes | Yes | Yes | Yes | Yes | Limited | assigned |
| VIEW_DEPARTMENT_TASK_QUEUE | Yes | Yes | Yes | Yes | Optional | No | No | department |
| CREATE_COMPLAINT | Yes | Yes | Yes | Yes | Yes | Yes | No | branch/department |
| RESOLVE_COMPLAINT | Yes | Yes | Yes | Yes | Yes | Assigned only | No | assigned/department |
| VIEW_COMPLAINT | Yes | Yes | Yes | Yes | Yes | Assigned only | Limited | assigned/department |
| CREATE_SERVICE_REQUEST | Yes | Yes | Yes | Yes | Yes | Yes | No | branch/department |
| RESOLVE_SERVICE_REQUEST | Yes | Yes | Yes | Yes | Yes | Assigned only | No | assigned/department |
| VIEW_SERVICE_REQUEST | Yes | Yes | Yes | Yes | Yes | Assigned only | Limited | assigned/department |
| CREATE_QUOTATION | Yes | Yes | Yes | Yes | Yes | Assigned only | No | assigned/department |
| SEND_QUOTATION | Yes | Yes | Yes | Yes | Yes | Assigned only | No | assigned |
| ACCEPT_QUOTATION | Yes | Yes | Yes | Yes | Yes | Assigned only | No | assigned |
| VIEW_CONVERSATION | Yes | Yes | Yes | Yes | Yes | Assigned only | Limited | assigned/department |
| SEND_MESSAGE | Yes | Yes | Yes | Yes | Yes | Assigned only | No | assigned |
| ESCALATE_CONVERSATION | Yes | Yes | Yes | Yes | Optional | No | No | department |
| CLOSE_CONVERSATION | Yes | Yes | Yes | Yes | Yes | Assigned only | No | assigned |

Notes:

- Task, Complaint, Service Request, Quotation, and Conversation permissions follow the same assigned/department visibility pattern already established for Leads in the CRM Permissions table above.
- Accepting a Quotation records the customer's decision and is performed by the assigned employee, consistent with the CLOSE_LEAD pattern.

```

### Step 13 — Finance Permissions: `REVIEW_APPROVAL_REQUEST`

File: `_ORVION_CANONICAL/28_permissions_matrix.md`
Verify: search for the exact string `REVIEW_APPROVAL_REQUEST`.
- If found: Already Applied, skip.
- If not found: locate the exact block:

```
| CREATE_JOURNAL_ENTRY | Yes | Yes | Yes | No | No | No | No | tenant |

Notes:

- Assigned employee may view financial documents directly related to their lead/booking.
- Finance approval is required before controlled execution gate.
- Operations cannot edit locked cost.
```

Replace it with:

```
| CREATE_JOURNAL_ENTRY | Yes | Yes | Yes | No | No | No | No | tenant |
| REVIEW_APPROVAL_REQUEST | Yes | Yes | Yes | No | No | No | No | tenant |

Notes:

- Assigned employee may view financial documents directly related to their lead/booking.
- Finance approval is required before controlled execution gate.
- Operations cannot edit locked cost.
- REVIEW_APPROVAL_REQUEST governs `approval_requests` rows whose `approval_type_code` is not `finance_execution_approval` (covered by APPROVE_FINANCE) and not `subscription_approval` (covered by REVIEW_SUBSCRIPTION_PAYMENT) — i.e. `refund_approval`, `discount_approval`, `booking_override`, `manual_price_change`, `sensitive_data_change`. This is a conservative default; per-type role refinement is an open business decision (see `reports/phase-02-prioritized-findings.md`).
```

Note: the Finance Permissions table's header row lists columns in the order Owner, CEO, Finance Manager, Branch Manager, Department Manager, Senior Employee, Employee — the value order in the new row above (`Yes | Yes | Yes | No | No | No | No`) follows that same column order (Owner=Yes, CEO=Yes, Finance Manager=Yes, Branch Manager=No, Department Manager=No, Senior Employee=No, Employee=No), matching the pattern already used by `EDIT_LOCKED_COST`, `SET_EXCHANGE_RATE`, and `CREATE_EXCHANGE_RATE_ADJUSTMENT` immediately above it in the same table.

### Step 14 — Insert Marketing Permissions section

File: `_ORVION_CANONICAL/28_permissions_matrix.md`
Verify: search for the exact heading `# Marketing Permissions`.
- If found: Already Applied, skip.
- If not found: locate the exact block:

```
Notes:

- Incorrect files are archived, not deleted.
- Financial documents require stricter visibility.

---

# Organization Permissions
```

Insert immediately after that Notes block and before `---\n\n# Organization Permissions`:

```

---

# Marketing Permissions

| Permission | Owner | CEO | Branch Manager | Finance Manager | Scope |
| --- | --- | --- | --- | --- | --- |
| MANAGE_MARKETING_CAMPAIGN | Yes | Yes | Optional | No | tenant |
| VIEW_MARKETING_DASHBOARD | Yes | Yes | Optional | Optional | tenant |

Notes:

- Marketing campaigns are tenant-scoped (no branch/department ownership fields exist on `marketing_campaigns`), consistent with `31_schema_draft.md`.

```

### Step 15 — Catalog registry: 33 additional `permission_key` values

File: `_ORVION_CANONICAL/25_catalog_registry.md`
Verify: search for the exact string `REVIEW_APPROVAL_REQUEST` within the `## permission_key` section.
- If found: Already Applied, skip.
- If not found: locate the exact block:

```
- ACCESS_API_READ_ONLY
- ACCESS_API_FULL

Usage:
```

(this is the tail of the `## permission_key` Initial values list). Replace it with:

```
- ACCESS_API_READ_ONLY
- ACCESS_API_FULL
- UPDATE_BOOKING_ITEM_STATUS
- ASSIGN_SUPPLIER
- ENTER_SELLING_PRICE
- ENTER_COST
- CREATE_INVOICE
- CREATE_RECEIPT
- RECORD_PAYMENT
- RECORD_REFUND
- CREATE_JOURNAL_ENTRY
- VIEW_TRAVEL_DOCUMENTS
- CREATE_DOCUMENT_VERSION
- VIEW_SUBSCRIPTION_STATUS
- CREATE_TASK
- ASSIGN_TASK
- COMPLETE_TASK
- VIEW_ASSIGNED_TASKS
- VIEW_DEPARTMENT_TASK_QUEUE
- CREATE_COMPLAINT
- RESOLVE_COMPLAINT
- VIEW_COMPLAINT
- CREATE_SERVICE_REQUEST
- RESOLVE_SERVICE_REQUEST
- VIEW_SERVICE_REQUEST
- CREATE_QUOTATION
- SEND_QUOTATION
- ACCEPT_QUOTATION
- VIEW_CONVERSATION
- SEND_MESSAGE
- ESCALATE_CONVERSATION
- CLOSE_CONVERSATION
- MANAGE_MARKETING_CAMPAIGN
- VIEW_MARKETING_DASHBOARD
- REVIEW_APPROVAL_REQUEST

Usage:
```

This adds exactly 33 new values (12 that were already referenced by `28_permissions_matrix.md` before this task — `UPDATE_BOOKING_ITEM_STATUS` through `VIEW_SUBSCRIPTION_STATUS` — plus 21 new values introduced by Steps 12–14 of this task).

---

## Acceptance Criteria

- [ ] Step 1: `26_state_machines.md` header reads `Version: 0.2`.
- [ ] Step 2: `27_event_catalog.md` header reads `Version: 0.2`.
- [ ] Step 3: `28_permissions_matrix.md` header reads `Version: 0.2`.
- [ ] Step 4: `25_catalog_registry.md` header reads `Version: 0.3`.
- [ ] Step 5: Booking Item Base State Machine's `## States` list contains exactly 7 values (`draft, pending, confirmed, in_progress, completed, cancelled, no_show`), matching `booking_item_base_status` in `25_catalog_registry.md`; the Allowed Transitions table contains 13 rows; a `## Terminal States` heading listing `cancelled` and `no_show` exists in this section.
- [ ] Step 6: Booking Item Base State Machine's `## Required Events` list contains `booking_item_cancelled` and `booking_item_no_show_recorded`.
- [ ] Step 7: `26_state_machines.md` contains `# Task State Machine`, `# Complaint State Machine`, `# Service Request State Machine`, `# Quotation State Machine`, `# Conversation State Machine`, and `# Marketing Campaign State Machine`, each with States, Allowed Transitions, Terminal States (or explicit non-terminal note), and Required Events.
- [ ] Step 8: `27_event_catalog.md` contains `## booking_item_cancelled` and `## booking_item_no_show_recorded` inside the Booking Item Events section.
- [ ] Step 9: `27_event_catalog.md` contains `## approval_requested`, `## approval_approved`, `## approval_rejected`, `## approval_cancelled`, `## approval_resubmitted`.
- [ ] Step 10: `27_event_catalog.md` contains `## payment_allocation_created`.
- [ ] Step 11: `27_event_catalog.md` contains `# Task Events`, `# Complaint Events`, `# Service Request Events`, `# Quotation Events`, `# Conversation Events`, `# Marketing Campaign Events`, each populated with the events listed in this task.
- [ ] Step 12: `28_permissions_matrix.md` contains `# CRM Extension Permissions` with all 18 listed permission rows.
- [ ] Step 13: Finance Permissions table contains a `REVIEW_APPROVAL_REQUEST` row and the Finance Permissions Notes block explains its scope.
- [ ] Step 14: `28_permissions_matrix.md` contains `# Marketing Permissions` with `MANAGE_MARKETING_CAMPAIGN` and `VIEW_MARKETING_DASHBOARD`.
- [ ] Step 15: `25_catalog_registry.md`'s `permission_key` Initial values list contains exactly 64 values (31 pre-existing + 33 new), with no duplicates.
- [ ] No file outside Scope was modified or created.
- [ ] `31_schema_draft.md`, `24_entity_registry.md`, `29_relationship_map.md`, and `30_database_conventions.md` were not touched.

---

## Review Gate

- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [ ] No file outside the Scope list was modified or created.
- [ ] No section was added, removed, or restructured outside the approved steps.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] Any step that could not be resolved deterministically was reported, not guessed.
- [ ] Supersedes / Depends On: confirmed SPEC-002 and SPEC-003 were already applied before this task began.
- [ ] The repository is in a clean, releasable state.

---

## Notes

This task closes every **Required Before SQL** finding from `reports/phase-02-prioritized-findings.md` (findings #1–9). It deliberately does not address the **Required Before Application Code** findings (#10–12: `conversation_message_*` events already added in Step 11 close #10 as a byproduct; #11 is closed by Step 10; #12 — fine-grained role mapping for `discount_approval`/`booking_override`/`manual_price_change`/`sensitive_data_change` beyond the conservative default in Step 13 — remains open and is explicitly not guessed), nor the **Recommended** or **Future Enhancement** findings (#13–17), all of which require either a business decision this task is not authorized to make, or are non-blocking and reserved for separate, smaller Change Requests.

After this task, Phase 2 (Catalog & Lifecycle Audit) is closed at the specification layer with no remaining Required Before SQL items. The next recommended phase is SQL Migration Planning, per `31_schema_draft.md`'s own "Next Step" and `_ORVION_CANONICAL/32_execution_roadmap.md`'s Phase 2 (Database Foundation) objective.
