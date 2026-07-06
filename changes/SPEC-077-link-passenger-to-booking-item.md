# Change Request — SPEC-077

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

Phase 5 (Booking Core) — passenger linkage. `app.link_passenger_to_booking_item(...)` links a passenger to a booking item (`booking_item_passengers`, unique per item+passenger) with optional per-passenger amount overrides. CREATE_BOOKING_ITEM-guarded. Completes the create-then-link passenger sequence begun in SPEC-076.

---

## Business Reason

`32_execution_roadmap.md`: "Passenger linkage" is a Phase 5 output. `06_booking_and_travel_products.md` / schema: a booking item's traveler manifest is the set of passengers linked to it (`booking_item_passengers`), with per-passenger selling/cost overrides for cases like differing child fares. The link must be unique per (item, passenger). Passengers now exist (SPEC-076), so linkage is the immediate next step.

---

## Risks

Low. One `SECURITY INVOKER` RPC; RLS backstop. No table/schema change. Item and passenger are tenant-verified; the link is blocked on a terminal/archived item (`cancelled`/`no_show`) or a terminal/archived booking (`completed`/`cancelled`); duplicate links raise a friendly message (unique constraint also enforces); overrides are non-negative (RPC + table CHECK).

---

## Supersedes / Depends On

Depends On: SPEC-075 (`create_booking_item`), SPEC-076 (`create_passenger`), `app.authorize` (SPEC-062). Precedes: item lifecycle transitions, internal supplier linkage, finance-approval gate (later Phase 5).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607045600_link_passenger_to_booking_item.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; RBAC/catalog seed data ; item/booking state transitions ; finance approval / amounts recomputation ; passenger creation (SPEC-076)

---

## Minimum Reading List

- _ORVION_CANONICAL/06_booking_and_travel_products.md ; 13_booking_statuses_and_rules.md (item independence)
- supabase/migrations/202607042300_create_booking_core_tables.sql (booking_item_passengers) ; 202607045400_create_booking_item.sql ; 202607045500_create_passenger.sql

---

## Implementation Steps

1. Create `supabase/migrations/202607045600_link_passenger_to_booking_item.sql`: `app.link_passenger_to_booking_item(p_booking_item_id, p_passenger_id, p_selling_amount_override, p_cost_amount_override)` — `SECURITY INVOKER`, `set search_path=''`, `app.authorize('CREATE_BOOKING_ITEM')`. Load the item joined to its booking, in-tenant; reject if the item is archived / `cancelled`/`no_show`, or the booking is archived / `completed`/`cancelled`. Tenant-verify the passenger. Non-negative overrides. Insert the link; catch `unique_violation` → friendly "already linked". Return the link id. `grant execute … to authenticated`.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] Linking an in-tenant passenger to an in-tenant item on an active booking succeeds and returns the link id; optional overrides are stored.
- [x] Re-linking the same (item, passenger) is rejected with a friendly "already linked" message.
- [x] Linking a passenger to an item on a cancelled booking, or to a `cancelled`/`no_show` item, is rejected; a negative override is rejected; a cross-tenant passenger or item is rejected.
- [x] `link_passenger_to_booking_item` is denied without `CREATE_BOOKING_ITEM` (42501).

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `app.link_passenger_to_booking_item(...)` added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (Sara = senior_employee; a draft booking with a draft flight item; two passengers; a cancelled item):
- Link passenger P1 to the item (selling override 950) → link created, override stored.
- Re-link P1 to the same item → rejected "passenger is already linked to this booking item".
- Link P2 to the item → second link created (manifest of 2).
- Negative override → rejected; link to a `cancelled` item → rejected; link to an item on a cancelled booking → rejected; cross-tenant passenger → rejected.
- `link_passenger_to_booking_item` as a trainee (no CREATE_BOOKING_ITEM) → 42501.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Linkage builds the item's traveler manifest with per-passenger overrides, uniqueness enforced per (item, passenger) with a friendly duplicate message (the table constraint is the backstop). Item and passenger are tenant-verified, and the link is correctly blocked on terminal/archived items and bookings — consistent with the item-independence and terminal-state rules of `13`/`26`. Overrides are non-negative (RPC + table CHECK). `SECURITY INVOKER`; no schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Per-passenger amount overrides are stored as given; they are not yet rolled up into item/booking totals — total recomputation belongs with the finance/amounts capability (Finance Core plugs in later). No event is emitted (linkage is not a state transition; `26` mandates none). Removing/unlinking a passenger and per-passenger status are later refinements. With create + link complete, the natural next Phase-5 capabilities are booking/booking-item state transitions (`26`) and then the finance-approval gate (`13`, the likely first Phase-5 ADR).
