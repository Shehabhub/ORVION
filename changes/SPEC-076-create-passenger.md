# Change Request — SPEC-076

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

Phase 5 (Booking Core) — passenger creation, the natural prerequisite of passenger linkage. `app.create_passenger(...)` creates a traveler record (optionally related to a customer), with passport/travel-document identity at the passenger level. CREATE_BOOKING_ITEM-guarded. Passenger linkage follows immediately (SPEC-077).

---

## Business Reason

`booking_item_passengers` links a passenger to a booking item (FK to `passengers`), so passengers must exist first — there is no `create_passenger` yet. `05_customer_identity.md` / `16_document_types_and_rules.md`: passport and travel-document details live at the passenger level, and a customer profile may reference related family members/travelers. `passenger_type` is a controlled catalog (adult/child/infant). Passenger creation is a genuine prerequisite of the Phase 5 "Passenger linkage" output, not a future capability.

---

## Risks

Low. One `SECURITY INVOKER` RPC; RLS backstop. No table/schema change. `passenger_type` is catalog-validated; `customer_id` (optional) is tenant-verified; `nationality_code` / `passport_issuing_country_code` (optional) are validated with friendly messages against the reference tables (partially seeded — callers pass null until earned); the passport issue<expiry rule is checked (table CHECK also enforces). No dedicated passenger permission exists in `28`; CREATE_BOOKING_ITEM is used (the booking-execution staff who build the traveler manifest).

---

## Supersedes / Depends On

Depends On: `passengers` table (migration 9, `202607042200_create_suppliers_and_passengers_tables.sql`), `app.authorize` (SPEC-062). Precedes: SPEC-077 (passenger linkage — `booking_item_passengers`). Related deferred: passenger passport documents + expiry alerts (Phase 7 Documents); `nationalities`/`countries` reference-data seeds (still deferred, nullable).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607045500_create_passenger.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; RBAC/catalog seed data ; booking_item_passengers linkage (SPEC-077) ; passenger documents / expiry alerts (Phase 7) ; nationalities/countries seeds

---

## Minimum Reading List

- _ORVION_CANONICAL/05_customer_identity.md (passport at passenger level; related travelers) ; 16_document_types_and_rules.md (passenger documents)
- supabase/migrations/202607042200_create_suppliers_and_passengers_tables.sql (passengers) ; 202607044800_customer_identity.sql (create pattern)

---

## Implementation Steps

1. Create `supabase/migrations/202607045500_create_passenger.sql`: `app.create_passenger(p_first_name, p_family_name, p_full_name, p_passenger_type_code default 'adult', p_customer_id, p_relationship_to_customer_code, p_date_of_birth, p_nationality_code, p_passport_number, p_passport_issue_date, p_passport_expiry_date, p_passport_issuing_country_code)` — `SECURITY INVOKER`, `set search_path=''`, `app.authorize('CREATE_BOOKING_ITEM')`. Require first+family name; validate `passenger_type` catalog; tenant-verify optional customer; friendly-validate optional nationality/issuing-country; enforce passport issue<expiry; derive `full_name` = `coalesce(p_full_name, first || ' ' || family)`. Insert the passenger; return the id. `grant execute … to authenticated`.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] Creating a passenger with first+family (no full_name) derives `full_name` and returns the id; `passenger_type` defaults to `adult`.
- [x] Linking an optional in-tenant `customer_id` works; a customer from another tenant is rejected.
- [x] An unknown `passenger_type`, an unknown nationality/issuing-country (when provided), and passport issue≥expiry are each rejected.
- [x] `create_passenger` is denied without `CREATE_BOOKING_ITEM` (42501).

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `app.create_passenger(...)` added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (Sara = senior_employee with CREATE_BOOKING_ITEM; customer C in tenant):
- `create_passenger('Ann','Ali')` → passenger created, `full_name='Ann Ali'`, `passenger_type_code='adult'`.
- With `p_customer_id=C`, `p_passenger_type_code='child'` → created and linked to C.
- Unknown passenger_type 'giant' → rejected; unknown nationality 'XX' (provided) → rejected; passport issue ≥ expiry → rejected; customer from another tenant → rejected.
- `create_passenger` as a trainee (no CREATE_BOOKING_ITEM) → 42501.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Passenger creation is the correct prerequisite for linkage (sequenced per owner guidance). Passport/travel-document identity is captured at the passenger level per `05`/`16`; `full_name` is derived when omitted (name fields honored). Optional customer relation is tenant-verified; optional nationality/issuing-country get friendly validation against the partially-seeded reference tables rather than raw FK errors; the passport date rule is enforced in the RPC and by the table CHECK. CREATE_BOOKING_ITEM is a reasonable gate absent a dedicated passenger permission. `SECURITY INVOKER`; no schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

A passenger is a traveler record distinct from the customer (the buyer): `customer_id` is optional so a passenger may be the customer, a related traveler, or an unrelated named traveler (`05`). Passport/visa fields are stored but their **documents** and **expiry alerts** are Phase 7 (Documents); nothing here generates expiry notifications. There is no passenger state machine, so no event is emitted. `nationalities`/`countries` remain deferred reference data (nullable); when a hard requirement earns them they get a seed like SPEC-074's currencies. Next: SPEC-077 passenger linkage (`booking_item_passengers`, unique per item+passenger, optional per-passenger amount overrides).
