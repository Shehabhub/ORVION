# Change Request — SPEC-083

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

Phase 5 (Booking Core) — Finance Approval Gate execution-approval slice, step 3 (ADR-0020): add the finance precondition to `advance_booking_item`'s `confirmed → in_progress` edge (block execution unless the item is ungated or has an approved finance approval), closing the execution-approval gate.

---

## Business Reason

Final slice of the execution-approval gate (ADR-0020). SPEC-081 opened requests, SPEC-082 resolved them (approve locks cost). This wires the approval into the booking-item lifecycle at the integration point already marked in migration 202607045700: `confirmed → in_progress` begins execution and must be blocked for a finance-gated item until finance approves. Ungated items (`finance_approval_required = false`) are unaffected. No schema change; a `create or replace` of the existing RPC (applied migrations are immutable).

---

## Risks

Low–moderate (touches a core lifecycle RPC). Mitigated: the only changes vs 202607045700 are selecting two finance columns and one gate check on the single `confirmed → in_progress` edge; all other transitions and side effects are byte-for-byte identical, and the change is regression-tested against the full SPEC-078 transition paths. Mints no new permission (still `UPDATE_BOOKING_ITEM_STATUS`). No booking-level or finance-transaction behavior touched.

---

## Supersedes / Depends On

Depends On: ADR-0020; SPEC-081 (`request_finance_approval`); SPEC-082 (`review_finance_approval`); SPEC-078 (`advance_booking_item` base). Completes the execution-approval gate. Follows: finance-gated booking-level transitions + issuance/refund/reissue (later capability); negative-balance risk flag (deferred to Finance Core).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607046200_gate_booking_item_execution.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration (incl. 202607045700_advance_booking_item.sql) ; table structure ; RBAC/catalog seed data ; advance_booking ; request/review_finance_approval ; finance transaction logic ; customer-balance or risk-flag logic

---

## Minimum Reading List

- reports/architecture-decision-records.md (ADR-0020)
- supabase/migrations/202607045700_advance_booking_item.sql (base function + marked integration point) ; 202607046000_request_finance_approval.sql ; 202607046100_review_finance_approval.sql ; 202607042300_create_booking_core_tables.sql (booking_items finance fields)

---

## Implementation Steps

1. Create `supabase/migrations/202607046200_gate_booking_item_execution.sql`: `create or replace function app.advance_booking_item(...)` reproducing 202607045700 exactly, with two additions — (a) select `bi.finance_approval_required, bi.finance_approval_status_code`; (b) after `app.authorize('UPDATE_BOOKING_ITEM_STATUS')`, if the edge is `confirmed → in_progress` and `finance_approval_required` and `finance_approval_status_code` is not `'approved'`, raise "execution blocked: finance approval is required and not approved". Everything else unchanged. Re-grant execute to authenticated.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] Regression: an ungated item (`finance_approval_required=false`) advances `draft→pending→confirmed→in_progress→completed` unchanged.
- [x] A finance-gated item (requested, not approved) is blocked at `confirmed → in_progress` with the execution-blocked error.
- [x] After `review_finance_approval` approves it, the same item advances `confirmed → in_progress`.

---

## Execution Log

### 2026-07-07 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `create or replace app.advance_booking_item(...)` with the finance gate added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED (71 tables).

Behavioral test (Sara = senior_employee @ aal1 with UPDATE_BOOKING_ITEM_STATUS + CREATE_BOOKING_ITEM; Fatima = finance_manager @ aal2):
- Ungated item e1 → `draft→pending→confirmed→in_progress→completed` all succeed (regression: gate does not affect ungated items).
- Gated item e2 (finance approval requested, still pending) → `draft→pending→confirmed` succeed, then `confirmed→in_progress` raises "execution blocked: finance approval is required and not approved for this booking item".
- Fatima approves e2's finance request → Sara's `confirmed→in_progress` now succeeds (returns in_progress).

Commits: committed at Complete (autonomous completion under standing execution authority — capability fully verified, AC met, no new architectural decision; ADR-0020 pre-approved).

Blocker: none.

---

## Verification Notes

### 2026-07-07 — Claude (independent review)

Verdict: Confirmed Complete

Findings: The finance precondition is correctly scoped to the single `confirmed → in_progress` edge and to finance-gated items only; ungated items and all other transitions behave exactly as SPEC-078 (regression-verified end to end). The gate reads the item's own `finance_approval_status_code` (set by `review_finance_approval`), so approval → execution is a clean state precondition with no cross-domain logic. `create or replace` leaves 202607045700 untouched; the diff is limited to the two-column select and the guard. Mints no new permission. `SECURITY INVOKER`. This closes the execution-approval gate (request → review → execute); negative-balance risk flag remains deferred to Finance Core per ADR-0020.

Recommendation to human: Set Status to Complete (completed autonomously under standing execution authority).

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Closes the Finance Approval Gate capability's execution-approval control (ADR-0020: SPEC-081 request + SPEC-082 review + SPEC-083 execute). Delivered as one continuous capability flow. Remaining finance-gate follow-ons (finance-gated booking-level transitions, issuance/void/refund/reissue, and the negative-balance risk flag) are a later capability, deferred per ADR-0020.
