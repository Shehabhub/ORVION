# Change Request — SPEC-082

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

Phase 5 (Booking Core) — Finance Approval Gate execution-approval slice, step 2 (ADR-0020): `app.review_finance_approval(request, decision, reason?)` resolves a pending `finance_execution_approval` (approved/rejected/cancelled), locks cost on approve, and emits the mandated finance-approval event.

---

## Business Reason

Step 2 of the execution-approval gate (ADR-0020), following SPEC-081's request primitive. It realizes the `26` Finance Approval State Machine decision node: finance reviews approve/reject; the requester withdraws (cancel). Approve locks the item cost and opens the execution gate that step 3 (`confirmed → in_progress` precondition) will consume. Uses the ready `approval_requests` schema and item finance fields; no schema change.

---

## Risks

Low. One `SECURITY INVOKER` RPC; RLS backstop; no schema change. Mints no new permission (ADR-0020): approve/reject under existing `APPROVE_FINANCE` (MFA composes), cancel under `CREATE_BOOKING_ITEM`. Only a `pending` `finance_execution_approval` is resolvable; approve is blocked on a terminal/archived item or booking. No booking-item lifecycle transition here (the execution edge is step 3).

---

## Supersedes / Depends On

Depends On: ADR-0020; SPEC-081 (`request_finance_approval`); `app.authorize` (SPEC-062); `app.record_event` (SPEC-065). Followed by: the `confirmed → in_progress` gate precondition in `advance_booking_item`.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607046100_review_finance_approval.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; RBAC/catalog seed data ; advance_booking_item / advance_booking ; request_finance_approval ; finance transaction (invoice/payment/refund) logic ; customer-balance or risk-flag logic

---

## Minimum Reading List

- reports/architecture-decision-records.md (ADR-0020)
- _ORVION_CANONICAL/26_state_machines.md (Finance Approval State Machine) ; 27_event_catalog.md (Finance Events)
- supabase/migrations/202607046000_request_finance_approval.sql ; 202607042500_create_finance_transaction_tables.sql (approval_requests) ; 202607042300_create_booking_core_tables.sql (booking_items finance fields)

---

## Implementation Steps

1. Create `supabase/migrations/202607046100_review_finance_approval.sql`: `app.review_finance_approval(p_approval_request_id, p_decision, p_reason)` — `SECURITY INVOKER`, `set search_path=''`. Validate `p_decision in (approved,rejected,cancelled)`. Load the request joined to item+booking in-tenant; require type `finance_execution_approval` and status `pending`; block approve on a terminal/archived item or booking. Authorize per decision: approve/reject → `APPROVE_FINANCE`, cancel → `CREATE_BOOKING_ITEM`. Set the request status + `reviewed_by`/`reviewed_at` (+ `rejection_reason` on reject); set the item `finance_approval_status_code` (+ `cost_locked_at` on approve). Emit `finance_approval_approved` (critical) / `_rejected` / `_cancelled` (warning). Return the decision. `grant execute … to authenticated`.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] Approve (finance role, aal2) sets request `approved` + item `finance_approval_status_code='approved'` + `cost_locked_at`, emits one `finance_approval_approved`.
- [x] Reject sets `rejected` (+ `rejection_reason`) + item `rejected`, emits `finance_approval_rejected`.
- [x] Cancel by the requester (`CREATE_BOOKING_ITEM`) sets `cancelled`, emits `finance_approval_cancelled`.
- [x] Reviewing an already-resolved (non-pending) request is rejected.
- [x] Approve/reject without `APPROVE_FINANCE` is denied (42501).

---

## Execution Log

### 2026-07-07 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `app.review_finance_approval(...)` added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED (71 tables).

Behavioral test (Fatima = finance_manager @ aal2 with APPROVE_FINANCE; Sara = senior_employee @ aal1, requester; Dan = trainee; four pending finance_execution_approval requests raised by Sara):
- Approve (Fatima, aal2) → request `approved`, item `finance_approval_status_code='approved'` + `cost_locked_at` set, one `finance_approval_approved` event (proves MFA composition — aal2 finance role passed).
- Reject (Fatima) → request `rejected` (`rejection_reason` stored), item `rejected`, not locked, one `finance_approval_rejected`.
- Cancel by requester (Sara, `CREATE_BOOKING_ITEM`) → request/item `cancelled`, one `finance_approval_cancelled`.
- Re-review the already-approved request → rejected: "only a pending finance approval can be reviewed (is approved)".
- Approve without `APPROVE_FINANCE` (Sara) → 42501 (permission denied: APPROVE_FINANCE).

Commits: committed at Complete (autonomous completion under standing execution authority — verified, AC met, no new architectural decision; ADR-0020 pre-approved).

Blocker: none.

---

## Verification Notes

### 2026-07-07 — Claude (independent review)

Verdict: Confirmed Complete

Findings: `review_finance_approval` realizes the `26` Finance Approval State Machine decision node correctly (pending → approved/rejected/cancelled), keyed to the generic booking item — no schema change. Per-decision authority matches ADR-0020 (approve/reject under `APPROVE_FINANCE` with MFA composing; requester-cancel under `CREATE_BOOKING_ITEM`) and mints no new permission. Approve locks cost (`cost_locked_at`) and sets the item approved (opening the gate step 3 consumes); reject/cancel do not lock. Only a pending `finance_execution_approval` is resolvable; approve is guarded against terminal/archived item/booking. Events (`finance_approval_approved` critical / `_rejected` / `_cancelled` warning) emit once each. `SECURITY INVOKER`; no file outside Scope modified.

Recommendation to human: Set Status to Complete (completed autonomously under standing execution authority).

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Slice 2 of the execution-approval gate (ADR-0020). Approve/reject and cancel are folded into one RPC keyed on the decision (the state machine's transitions out of `pending`), with per-decision authority — an implementation choice under the approved ADR. Slice 3 = the `confirmed → in_progress` precondition in `advance_booking_item`.
