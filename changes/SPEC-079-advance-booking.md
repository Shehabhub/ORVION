# Change Request — SPEC-079

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

Phase 5 (Booking Core) — booking-level lifecycle transitions, **Option A pre-finance slice**. `app.advance_booking(p_booking_id, p_to_status, p_reason)` implements the finance-free booking transitions (`draft → pending_approval`, `draft/pending_approval → cancelled`) and publishes the canonical `booking_*` events as the booking orchestration boundary. Finance-entangled transitions are deferred to the finance-approval gate.

---

## Business Reason

`26_state_machines.md` (Booking State Machine): a booking is submitted for approval (`booking_submitted_for_approval`) or cancelled (`booking_cancelled`), each a mandated event. Per the owner-approved Option A, only the booking-domain-owned, finance-free transitions are implemented now; the rest (`confirmed`/`in_progress`/`issued`/`void`/`refunded`/`reissue`/`completed`) are inseparable from the finance-approval gate (`13`) and land with it. Establishes Booking as an orchestration boundary that future domains react to via events.

---

## Risks

Low. One `SECURITY INVOKER` RPC; RLS backstop. No table/schema change. Only the three finance-free transitions succeed; requesting a finance-gated target returns a clear "arrives with the finance-approval gate" message (not a generic error). Cancellation stamps `cancelled_at` (bookings has no cancellation-reason column; the reason is carried in the event). Gated by `CREATE_BOOKING` (booking-owner early-lifecycle authority) pending the capability-driven permission set at the finance-gate ADR.

---

## Supersedes / Depends On

Depends On: SPEC-073 (`create_booking`), `app.authorize` (SPEC-062), `record_event` (SPEC-065); pattern from SPEC-068/078. Deferred (recorded): finance-entangled booking transitions + the capability-driven booking permissions (Submit/Approve/Issue/Cancel/Refund/Reissue) — to be introduced together at the finance-approval-gate ADR. Establishes the booking orchestration-boundary principle.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607045800_advance_booking.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; RBAC/catalog seed data ; finance-gated booking transitions (confirmed/issued/void/refunded/reissue/completed) ; finance approval behavior ; new booking permissions (deferred to the finance-gate ADR)

---

## Minimum Reading List

- _ORVION_CANONICAL/26_state_machines.md (Booking State Machine) ; 13_booking_statuses_and_rules.md (finance gate) ; 28_permissions_matrix.md (Booking Permissions — the gap)
- supabase/migrations/202607044700_advance_lead.sql (pattern) ; 202607045200_create_booking.sql ; 202607045700_advance_booking_item.sql

---

## Implementation Steps

1. Create `supabase/migrations/202607045800_advance_booking.sql`: `app.advance_booking(p_booking_id, p_to_status, p_reason)` — `SECURITY INVOKER`, `set search_path=''`. Load the booking in-tenant (reject if archived). Look up `(booking_status, p_to_status)` in the encoded finance-free transition table (`draft→pending_approval` `booking_submitted_for_approval`; `draft→cancelled` and `pending_approval→cancelled` `booking_cancelled`); if absent and the target is a finance-gated status, raise a clear "arrives with the finance-approval gate" message, else "transition not allowed". `app.authorize('CREATE_BOOKING')`. Update `booking_status_code` (+ `cancelled_at` on cancel). Publish the mapped `booking_*` event with `{customer_id, lead_id, booking_reference}` payload. Return the new status. `grant execute … to authenticated`.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] `draft → pending_approval` succeeds and emits `booking_submitted_for_approval` (prev `draft`, new `pending_approval`, payload carries customer/lead/reference).
- [x] `draft → cancelled` and `pending_approval → cancelled` succeed, set `cancelled_at`, and emit `booking_cancelled`.
- [x] Requesting a finance-gated target (e.g. `confirmed`, `issued`) returns the "arrives with the finance-approval gate" message; a truly invalid target returns "transition not allowed".
- [x] `advance_booking` is denied without `CREATE_BOOKING` (42501); an archived booking is rejected.

---

## Execution Log

### 2026-07-07 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `app.advance_booking(...)` added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (Sara = senior_employee with CREATE_BOOKING; a draft booking B1, a draft B2, a pending_approval B3):
- `advance_booking(B1, 'pending_approval')` → `pending_approval`; one `booking_submitted_for_approval` event (draft→pending_approval; payload customer/lead/reference).
- `advance_booking(B2, 'cancelled', 'customer withdrew')` → `cancelled`, `cancelled_at` set, `booking_cancelled` event; `advance_booking(B3, 'cancelled')` (from pending_approval) → `cancelled`.
- `advance_booking(B1, 'confirmed')` → "transition … is finance-gated and arrives with the finance-approval gate"; `advance_booking(B1, 'draft')` → "transition not allowed".
- `advance_booking` as a trainee (no CREATE_BOOKING) → 42501; archived booking → rejected.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-07 — Claude (independent review)

Verdict: Confirmed Complete

Findings: The pre-finance slice implements exactly the booking-domain-owned transitions (submit, cancel) using the shared table-driven pattern and publishing canonical `booking_*` events with business-key payloads — the orchestration boundary, with no cross-domain logic. Finance-gated targets are surfaced with a distinct, honest message rather than silently failing, making the deferral explicit in the contract. No finance behavior; `cancelled_at` stamped; `CREATE_BOOKING` gate is a documented interim pending the capability-driven permission set at the finance-gate ADR. Booking Core stays service-agnostic (no service-specific logic), preserving future service modules. `SECURITY INVOKER`; no schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

**Permission model (owner suggestion #1, adopted as recorded direction):** booking transitions are capability-driven — Submit / Approve / Issue / Cancel / Refund / Reissue Booking — rather than a generic `UPDATE_BOOKING_STATUS`. Introducing that permission set (with role mappings) is deferred to the finance-approval-gate ADR, where Approve/Issue/Refund/Reissue all appear together; until then Submit/Cancel use `CREATE_BOOKING` (booking-owner authority). This is preferable to minting a generic status permission. **Orchestration boundary (suggestion #2):** future domains subscribe to `booking_*` events; do not expand `advance_booking` with finance/document/notification logic. **Service-agnostic Booking Core (suggestions #3/#4):** the header/transition layer encodes no service specifics, so Flight Ticketing (PNR, segments, fare class, ticket number, baggage, seats) and the other travel/non-travel modules plug in later via `booking_items` detail + events without rebuilding. The finance-approval gate is the next major Phase-5 capability and the likely first Phase-5 ADR; it introduces the finance-gated transitions, their capability permissions, the execution/issuance preconditions, and the issue-before-payment risk flag.
