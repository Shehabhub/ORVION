# Change Request — SPEC-078

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

Phase 5 (Booking Core) — booking-item base-lifecycle transitions. `app.advance_booking_item(...)` validates a base-status transition against the canonical Booking Item Base State Machine (`26`), applies per-transition side effects (cancel/no_show/complete timestamps + reasons), optionally sets a service-specific sub-status, and emits the mandated event. UPDATE_BOOKING_ITEM_STATUS-guarded. Reuses the `advance_lead` table-driven pattern + `record_event` (no generic engine — not yet earned).

---

## Business Reason

`26_state_machines.md` (Booking Item Base State Machine): items move `draft → pending → confirmed → in_progress → completed`, plus `cancelled`/`no_show`, and every transition must record actor/previous/new and create its required event (`booking_item_pending/confirmed/in_progress/completed/cancelled/no_show_recorded`). `13_booking_statuses_and_rules.md`: each item has an independent lifecycle with service-specific sub-status. This is the behavior layer over the item structure built in SPEC-075.

---

## Risks

Low. One `SECURITY INVOKER` RPC; RLS backstop. No table/schema change. Only canonical transitions succeed (table-driven). Cancellation requires a validated `booking_cancellation_reason_code` and stamps `cancelled_at/by`; `no_show` stamps `no_show_at/by`; `completed` stamps `completed_at`. Sub-status is validated only against the item's service catalog. Item transitions do not alter the booking status (independence principle). The `confirmed → in_progress` (execution) transition is the documented future finance-gate integration point; no finance behavior is added now.

---

## Supersedes / Depends On

Depends On: SPEC-075 (`create_booking_item`), `app.authorize` (SPEC-062), `record_event` (SPEC-065); pattern reuse from SPEC-068 (`advance_lead`). Precedes: booking-level state transitions, the finance-approval gate (which will guard `confirmed → in_progress` / issuance). Deferred (recorded): `pending → draft` (return-for-correction — `26` allows it but defines no event); a standalone sub-status-only change RPC (`booking_item_sub_status_changed`).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607045700_advance_booking_item.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; RBAC/catalog seed data ; finance approval / cost-lock / issuance gate ; booking-level transitions ; amounts recomputation

---

## Minimum Reading List

- _ORVION_CANONICAL/26_state_machines.md (Booking Item Base State Machine) ; 13_booking_statuses_and_rules.md (item independence, sub-status, finance gate)
- supabase/migrations/202607044700_advance_lead.sql (table-driven transition pattern) ; 202607045400_create_booking_item.sql

---

## Implementation Steps

1. Create `supabase/migrations/202607045700_advance_booking_item.sql`: `app.advance_booking_item(p_booking_item_id, p_to_status, p_reason, p_sub_status_code, p_cancellation_reason_code)` — `SECURITY INVOKER`, `set search_path=''`. Load the item in-tenant (reject if archived). Look up `(base_status, p_to_status)` in the encoded canonical transition table → mapped event; reject if absent. `app.authorize('UPDATE_BOOKING_ITEM_STATUS')`. If cancelling, require + validate `booking_cancellation_reason_code`. If a sub-status is given, validate it against the item's service catalog (flight_ticket/visa/hotel; else reject). Update `base_status_code` (+ sub-status, + cancel/no_show/complete timestamps & actors); emit the mapped event (prev/new base status, payload with sub-status/cancellation reason). Return the new status. `grant execute … to authenticated`.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] Forward path works: `draft → pending → confirmed → in_progress → completed`; each emits its mapped event with correct previous/new; `completed` sets `completed_at`.
- [x] An illegal transition (e.g. `draft → confirmed`, `completed → in_progress`) is rejected.
- [x] `→ cancelled` requires a valid `booking_cancellation_reason_code` (sets `cancelled_at/by`, `booking_item_cancelled` event); `→ no_show` sets `no_show_at/by` (`booking_item_no_show_recorded`); a bad/absent cancellation reason is rejected.
- [x] A valid sub-status alongside a transition is accepted; a sub-status on a non-supporting service, or a wrong value, is rejected. `advance_booking_item` is denied without `UPDATE_BOOKING_ITEM_STATUS` (42501).

---

## Execution Log

### 2026-07-07 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `app.advance_booking_item(...)` added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (Sara = senior_employee with UPDATE_BOOKING_ITEM_STATUS; a draft flight item):
- `draft → pending → confirmed → in_progress → completed` (last with sub `ticketed`): each applied; four transition events (pending/confirmed/in_progress/completed) with correct prev/new; `completed_at` set; `sub_status_code='ticketed'`.
- Illegal `draft → confirmed` and `completed → in_progress` rejected ("transition not allowed").
- On a fresh confirmed item: `→ cancelled` with `payment_not_received` → `cancelled`, `cancelled_at/by` set, `booking_item_cancelled` event; `→ no_show` on another confirmed item → `no_show_at/by` set, `booking_item_no_show_recorded`.
- `→ cancelled` without a reason rejected; bogus cancellation reason rejected; sub-status on an `insurance` item rejected; bogus ticket sub-status rejected.
- `advance_booking_item` as a trainee (no UPDATE_BOOKING_ITEM_STATUS) → 42501.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-07 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Transitions are driven from the canonical `26` table (only allowed edges succeed), each emitting its mandated event via the shared `record_event` seam — the same pattern as `advance_lead`, reused rather than abstracted into an unearned engine (status column + side effects differ per entity). Per-transition side effects are correct (cancel/no_show/complete timestamps + actors; validated cancellation reason). Sub-status is validated against the item's service catalog. Item transitions leave the booking status untouched (independence, `13`). The `confirmed → in_progress` execution edge is the documented finance-gate integration point with no finance behavior added — Finance Core stays pluggable. `SECURITY INVOKER`; no schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Architecture note (owner suggestion evaluated): kept a **dedicated per-entity transition RPC that reuses the table-driven pattern**, not a generic lifecycle engine — the reusable primitive (`record_event`) is already shared, while the status column (`base_status_code` vs `lead_status_code`) and per-transition side effects/authorization differ enough that an engine would need per-entity callbacks (abstraction without earned payoff). If booking-level + future entity transitions show the side-effects converging, an engine earns itself then. Deferred: `pending → draft` return-for-correction (`26` allows it but defines no event — needs an event-name decision); a sub-status-only change RPC emitting `booking_item_sub_status_changed`. The `confirmed → in_progress` execution edge and issuance are where the finance-approval gate (`13`) — the next major Phase-5 capability and likely first Phase-5 ADR — will plug in. Booking status is intentionally not auto-advanced by item transitions.
