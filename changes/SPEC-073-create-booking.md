# Change Request — SPEC-073

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

Phase 5 (Booking Core) — first capability: booking creation. `app.create_booking(...)` creates a booking in the initial `draft` status and emits `booking_created`, CREATE_BOOKING-guarded. When the booking originates from a lead it **consumes the Phase 4→5 handoff contract** `app.lead_booking_readiness` (requires `is_ready`, takes the normalized customer/branch/department/title) rather than re-deriving CRM eligibility; it also supports a direct customer booking (no lead).

---

## Business Reason

`32_execution_roadmap.md`: Phase 5's first output is "Booking creation". `26_state_machines.md` (Booking State Machine): a booking begins at `draft` and must emit `booking_created`. `12_lead_statuses_and_rules.md`: a booking may be created from a lead (after creation/qualification/negotiation/conversion) and must never delete the lead — `bookings.lead_id` links the origin, `customer_id` (NOT NULL) is the anchor. This is the natural continuation of the lead pipeline into Booking Core.

---

## Risks

Low. One `SECURITY INVOKER` RPC; RLS is the backstop. No table/schema change. Booking-eligibility is not re-derived — the lead path delegates to `lead_booking_readiness` (single source of truth). Branch/department (dept-within-branch-within-tenant) and customer are tenant-verified. `booking_reference` is auto-generated (schema has no uniqueness constraint; generated value is practically unique). Only the header booking is created — booking items, passengers, suppliers, and the finance-approval gate are later Phase 5 capabilities.

---

## Supersedes / Depends On

Depends On: SPEC-072 (`lead_booking_readiness` contract), SPEC-071 (`convert_lead` — a converted lead is booking-ready), SPEC-069 (`create_customer`), `app.authorize` (SPEC-062), `record_event` (SPEC-065). Precedes: booking item creation, passenger/supplier linkage, item lifecycle, finance-approval gate (later Phase 5).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607045200_create_booking.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; RBAC/catalog seed data ; booking items / passengers / suppliers ; finance approval / payments (Finance Core) ; booking state transitions beyond initial draft

---

## Minimum Reading List

- _ORVION_CANONICAL/13_booking_statuses_and_rules.md ; 06_booking_and_travel_products.md ; 26_state_machines.md (Booking State Machine) ; 12_lead_statuses_and_rules.md (Lead-To-Booking)
- supabase/migrations/202607042300_create_booking_core_tables.sql (bookings) ; 202607045100_lead_booking_readiness.sql ; 202607044300_create_lead.sql (authorize + validation pattern)

---

## Implementation Steps

1. Create `supabase/migrations/202607045200_create_booking.sql`: `app.create_booking(p_customer_id, p_lead_id, p_title, p_branch_id, p_department_id, p_travel_start_date, p_travel_end_date, p_destination_country_code, p_destination_city, p_booking_reference)` — `SECURITY INVOKER`, `set search_path=''`, `app.authorize('CREATE_BOOKING')`. If `p_lead_id` given: call `app.lead_booking_readiness`, require `is_ready`, derive customer/branch/department/title from its payload (allow branch/department/title override). Else require `p_customer_id`. Validate customer-in-tenant and department-within-branch-within-tenant; require branch+department+title. Auto-generate `booking_reference` if null. Insert the booking (`booking_status_code='draft'`, owner + created_by = actor, `lead_id` linked). Emit `booking_created` (new `draft`, payload `{lead_id, customer_id, booking_reference}`). Return the booking id. `grant execute … to authenticated`.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] Creating a booking from a booking-ready lead links `lead_id` + `customer_id`, sets `draft`, derives branch/department from the contract, and emits one `booking_created` event.
- [x] Creating a booking from a **not**-ready lead (e.g. no linked customer, or lost) is rejected citing the contract `reason_code`.
- [x] Creating a booking directly for an in-tenant customer (no lead) succeeds in `draft`; a missing customer / missing branch+department / missing title is rejected.
- [x] `create_booking` is denied without `CREATE_BOOKING` (42501); the booking gets an auto-generated `booking_reference` when none is passed.

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `app.create_booking(...)` added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (Sara = senior_employee with CREATE_BOOKING; a converted+linked lead L1; a lost lead L3; customer C):
- `create_booking(p_lead_id => L1)` → booking in `draft`, `lead_id=L1`, `customer_id=C`, branch/department derived from the contract, auto `booking_reference` (BK-…); one `booking_created` event (new `draft`, payload carries lead/customer/reference).
- `create_booking(p_lead_id => L3_lost)` → rejected: "lead is not booking-ready: lead_closed_negative".
- `create_booking(p_customer_id => C, branch, department, title)` (no lead) → `draft` booking created, `lead_id` null.
- Missing customer (no lead, no customer) rejected; missing branch/department rejected; missing title rejected.
- `create_booking` as a trainee (no CREATE_BOOKING) → 42501.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Booking creation consumes the handoff contract on the lead path — `is_ready` is required and the normalized payload is taken verbatim, so CRM booking-eligibility lives only in `lead_booking_readiness` (no re-derivation), exactly the phase-boundary intent. The direct-customer path is supported per the nullable `bookings.lead_id`. Initial state is `draft` with a `booking_created` event (`26`); the lead is untouched (never deleted). Customer and department-within-branch-within-tenant are verified; `CREATE_BOOKING` + MFA compose via `authorize`. Only the booking header is created — items/passengers/suppliers/finance-gate are correctly left to later Phase 5 capabilities, keeping Finance Core able to plug in later without premature complexity. `SECURITY INVOKER`; no schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

The lead path is the canonical entry (consumes `lead_booking_readiness`); the direct-customer path exists because the schema and `12` both allow a booking without a lead (e.g. a walk-in existing customer). `quotation_id` linkage is left null here — the quotation→booking path (`26` Quotation State Machine "accepted → may produce a Booking") is a later capability. `booking_reference` is auto-generated; if a tenant-scoped uniqueness/sequence format is later required, it is a small follow-up (no uniqueness constraint exists today). No finance behavior is introduced — the finance-approval gate (`13`) is a later Phase 5 capability and the first likely Phase-5 ADR; bookings are built so Finance Core plugs in later without premature complexity. Booking items (the independent-lifecycle unit, `13`/`26`) are the natural next capability.
