# Change Request — SPEC-075

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

Phase 5 (Booking Core) — booking item creation. `app.create_booking_item(...)` adds an item to a booking in the initial base status `draft` (independent item lifecycle) and emits `booking_item_created`, CREATE_BOOKING_ITEM-guarded, with service-type-aware sub-status validation. No finance behavior (the finance-approval gate is a later capability).

---

## Business Reason

`13_booking_statuses_and_rules.md`: every booking item has an independent lifecycle over one shared base lifecycle (`draft → pending → confirmed → in_progress → completed`), with service-specific sub-status (ticket/visa/hotel) and no per-type tables. `26_state_machines.md` (Booking Item Base State Machine): an item begins at `draft` and must emit `booking_item_created`. `32_execution_roadmap.md`: "Booking item creation" is a Phase 5 output. This is the execution unit that carries service, supplier, and money detail under the booking header.

---

## Risks

Low. One `SECURITY INVOKER` RPC; RLS backstop. No table/schema change. Items can only be added to a non-terminal, non-archived booking in the caller's tenant. Amounts are non-negative (RPC check + table CHECK). Sub-status is validated only against the service type's catalog (ticket/visa/hotel); other service types reject a sub-status. `finance_approval_required` is stored as intent only — the execution/issuance gate is deliberately not implemented here.

---

## Supersedes / Depends On

Depends On: SPEC-073 (`create_booking` — the booking header), SPEC-074 (currencies seed — `currency_code` FK), `app.authorize` (SPEC-062), `record_event` (SPEC-065). Precedes: passenger linkage (`booking_item_passengers`), internal supplier linkage, item lifecycle transitions, the finance-approval gate (later Phase 5).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607045400_create_booking_item.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; RBAC/catalog seed data ; finance approval / cost-lock / issuance gate ; passengers / suppliers creation ; item state transitions beyond initial draft

---

## Minimum Reading List

- _ORVION_CANONICAL/13_booking_statuses_and_rules.md (item base lifecycle, sub-status, finance gate) ; 26_state_machines.md (Booking Item Base State Machine) ; 06_booking_and_travel_products.md
- supabase/migrations/202607042300_create_booking_core_tables.sql (booking_items) ; 202607045200_create_booking.sql ; 202607045300_seed_currencies.sql

---

## Implementation Steps

1. Create `supabase/migrations/202607045400_create_booking_item.sql`: `app.create_booking_item(p_booking_id, p_service_type_code, p_currency_code, p_cost_amount, p_selling_amount, p_commission_rate, p_supplier_id, p_sub_status_code, p_finance_approval_required)` — `SECURITY INVOKER`, `set search_path=''`, `app.authorize('CREATE_BOOKING_ITEM')`. Load the booking in-tenant; reject if archived or in `completed`/`cancelled`. Validate `service_type` catalog, `currency_code` (currencies), optional supplier-in-tenant, and (if given) `sub_status` against the service type's catalog (flight_ticket→ticket_sub_status, visa→visa_sub_status, hotel→hotel_sub_status; else reject). Non-negative amounts. Insert the item (`base_status_code='draft'`, owner/sales-owner/operational-owner = actor, owner branch/department from the booking). Emit `booking_item_created` (new `draft`, payload `{booking_id, service_type_code, currency_code}`). Return the item id. `grant execute … to authenticated`.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] Creating an item on a draft booking sets `base_status_code='draft'`, links `booking_id`, sets owner/sales/operational owner + owner branch/department from the booking, and emits one `booking_item_created` event.
- [x] A valid service sub-status is accepted (e.g. flight_ticket + `reserved`); a sub-status on a non-supporting service type, or a wrong sub-status value, is rejected; an unknown service_type or currency is rejected.
- [x] Adding an item to a `completed`/`cancelled`/archived booking is rejected; negative cost/selling is rejected.
- [x] `create_booking_item` is denied without `CREATE_BOOKING_ITEM` (42501).

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `app.create_booking_item(...)` added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (Sara = senior_employee with CREATE_BOOKING_ITEM; a draft booking B):
- `create_booking_item(B, 'flight_ticket', 'USD', cost 800, selling 1000, sub 'reserved')` → item in `draft`, `booking_id=B`, owner/sales/operational owner = Sara, owner branch/department from B, `sub_status='reserved'`; one `booking_item_created` event (new `draft`).
- `create_booking_item(B, 'hotel', 'SAR', sub 'checked_in')` accepted; `create_booking_item(B, 'insurance', sub 'reserved')` → rejected (service type has no sub-status); flight_ticket + bogus sub-status → rejected; unknown service_type / unknown currency → rejected.
- Negative selling → rejected; adding an item to a cancelled booking → rejected.
- `create_booking_item` as a trainee (no CREATE_BOOKING_ITEM) → 42501.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: The item is created in its own `draft` lifecycle (`26`) with a `booking_item_created` event, carrying service/supplier/money detail under the booking header — the independent-lifecycle model of `13`. Sub-status is validated against the correct per-service catalog and rejected for service types that define none, avoiding cross-type contamination without per-type tables. Currency (now seeded), service type, and supplier are validated in-tenant; amounts are non-negative (RPC + table CHECK); items cannot attach to a terminal/archived booking. Finance behavior is correctly excluded — `finance_approval_required` is stored as intent only, keeping Finance Core pluggable. `SECURITY INVOKER`; no schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Owner columns are set from the actor and the booking's branch/department (sales owner = operational owner = creator for now); a distinct operational-vs-sales ownership assignment (e.g. cross-department fulfilment via `internal_supplier_links`) is a later capability. `finance_approval_required` is recorded but not enforced — the finance-approval execution gate (`13`: execution/issuance blocked until finance approval) is the next significant Phase-5 capability and the likely first Phase-5 ADR; issuing before full payment + the risk flag (`13`) also belong there. Passenger linkage (`booking_item_passengers`, unique per item+passenger) and internal supplier linkage are the immediate next items. Booking header status is not auto-advanced by adding an item (booking stays `draft` until an explicit transition), consistent with the item/booking independence principle.
