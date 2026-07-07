# Change Request — SPEC-081

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word anywhere in a Change Request.

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model
[ ] Tier 2 — Local execution agent (Qwen3.8B)

---

## Objective

Phase 5 (Booking Core) — Finance Approval Gate execution-approval slice, step 1 (ADR-0020): `app.request_finance_approval(booking_item, reason?)` opens a `pending` `finance_execution_approval` on a booking item, marks the item, and emits `finance_approval_requested`.

---

## Business Reason

The Finance Approval Gate (`13`, `26` Finance Approval State Machine) is the next major Phase-5 capability. ADR-0020 splits it into an execution-approval slice built now (request → review → gate the execution edge) and a deferred negative-balance risk flag (needs a Finance Core `customer_balance()` primitive). This CR is the request primitive: it is self-contained and independently testable, and it consumes the ready `approval_requests(finance_execution_approval)` schema and the item finance fields without any schema change.

---

## Risks

Low. One `SECURITY INVOKER` RPC; RLS backstop; no table/schema change. Mints no new permission (reuses `CREATE_BOOKING_ITEM`, per ADR-0020). Blocks a duplicate `pending` request and requests on a terminal/archived item or booking. `finance_approval_status_code` is written only with `approval_status_code` catalog values. Approve/reject and the execution-edge precondition are separate following CRs; until they exist, a requested approval has no execution effect (safe).

---

## Supersedes / Depends On

Depends On: ADR-0020 (finance-gate design); SPEC-075 (`create_booking_item`); `app.authorize` (SPEC-062); `app.record_event` (SPEC-065). Followed by: `review_finance_approval` (approve/reject/cancel) and the `confirmed → in_progress` gate precondition.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607046000_request_finance_approval.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; RBAC/catalog seed data ; advance_booking_item / advance_booking ; review/approve logic ; finance transaction (invoice/payment/refund) logic ; customer-balance or risk-flag logic

---

## Minimum Reading List

- reports/architecture-decision-records.md (ADR-0020)
- _ORVION_CANONICAL/26_state_machines.md (Finance Approval State Machine) ; 27_event_catalog.md (Finance Events)
- supabase/migrations/202607042500_create_finance_transaction_tables.sql (approval_requests) ; 202607042300_create_booking_core_tables.sql (booking_items finance fields) ; 202607045700_advance_booking_item.sql (conventions)

---

## Implementation Steps

1. Create `supabase/migrations/202607046000_request_finance_approval.sql`: `app.request_finance_approval(p_booking_item_id, p_reason)` — `SECURITY INVOKER`, `set search_path=''`, `app.authorize('CREATE_BOOKING_ITEM')`. Load the item joined to its booking in-tenant; reject if the item is archived/`cancelled`/`no_show` or the booking is archived/`completed`/`cancelled`; reject if a `pending` `finance_execution_approval` already exists for the item. Insert an `approval_requests` row (`finance_execution_approval`, `pending`, requested_by = actor, booking_item_id, related_entity = booking_item). Set the item `finance_approval_required = true`, `finance_approval_status_code = 'pending'`. Emit `finance_approval_requested` (info). Return the request id. `grant execute … to authenticated`.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] Requesting on an eligible item creates one `pending` `finance_execution_approval` row, sets the item `finance_approval_required`/`finance_approval_status_code='pending'`, and emits one `finance_approval_requested` event.
- [x] A second request while one is `pending` is rejected.
- [x] Request on a `cancelled`/`no_show`/archived item, or on a `completed`/`cancelled`/archived booking, is rejected.
- [x] `request_finance_approval` is denied without `CREATE_BOOKING_ITEM` (42501).

---

## Execution Log

### 2026-07-07 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `app.request_finance_approval(...)` added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (Sara = senior_employee with CREATE_BOOKING_ITEM; a draft flight_ticket item on a draft booking; a cancelled item; an item on a cancelled booking; Dan = trainee):
- Request on the eligible item → one `pending` `finance_execution_approval` row (requested_by = Sara), item `finance_approval_required=true` + `finance_approval_status_code='pending'`, one `finance_approval_requested` event.
- Second request while pending → rejected.
- Request on the cancelled item → rejected; request on the item whose booking is cancelled → rejected.
- Request as a trainee (no CREATE_BOOKING_ITEM) → 42501.

Commits: committed at Complete (autonomous completion under standing execution authority — capability fully verified, AC met, no new architectural decision; ADR-0020 pre-approved).

Blocker: none.

---

## Verification Notes

### 2026-07-07 — Claude (independent review)

Verdict: Confirmed Complete

Findings: `request_finance_approval` opens the Finance Approval State Machine at `pending` correctly, keyed to the generic booking item (service-agnostic) and the ready `approval_requests(finance_execution_approval)` schema — no schema change. Duplicate-pending guard, terminal/archived item+booking guards, and tenant scoping are correct; `finance_approval_status_code` uses only catalog values. Mints no new permission (reuses `CREATE_BOOKING_ITEM`) per ADR-0020, keeping the capability set recorded-but-per-consumer. `SECURITY INVOKER`; no file outside Scope modified. Approve/reject and the execution-edge precondition are correctly left to following CRs.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

First Phase-5 ADR (ADR-0020) precedes this CR. This is slice 1 of the execution-approval gate; `review_finance_approval` (approve/reject/cancel, `APPROVE_FINANCE`) and the `confirmed → in_progress` gate precondition follow. Negative-balance risk flag deferred to Finance Core (`customer_balance()`), per ADR-0020.
