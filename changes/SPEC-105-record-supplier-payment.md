# Change Request — SPEC-105

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model

[ ] Tier 2 — Local execution agent (Qwen3.8B)

---

## Objective

Add `app.record_supplier_payment(...)`, recording a payment ORVION makes to an external supplier (`supplier_payment` direction), drawing down `app.supplier_balance`.

---

## Business Reason

Phase 6 Finance Core "Payments" (supplier side). Completes the payables flow: `supplier_balance` (SPEC-104) shows what is owed; this records the disbursement that reduces it. No supplier-bill table exists, so the payment is recorded directly against the supplier (optionally a booking), mirroring how supplier payables are derived.

---

## Risks

Low. Additive, `SECURITY INVOKER`, RLS-backed. Validates amount, payment method, supplier/booking tenancy. Over-payment is intentionally allowed (supplier prepayment/credit). No allocation table involved. No table/schema change. Verified by clean `db reset`, smoke-test, and behavioral tests: a supplier payment reduces `supplier_balance`; invalid method/amount, cross-tenant supplier, and the authority guard are all rejected.

---

## Supersedes / Depends On

Depends on SPEC-104 (`app.supplier_balance`) and the seeded `RECORD_PAYMENT`. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607047400_record_supplier_payment.sql
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-105-record-supplier-payment.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable); any `_ORVION_CANONICAL/**` except the manifest; AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`, `32_execution_roadmap.md`.

---

## Minimum Reading List

- supabase/migrations/202607047300_supplier_balance.sql (the payable being drawn down)
- supabase/migrations/202607047100_record_payment.sql (customer-payment sibling)

---

## Implementation Steps

1. Verify `202607047400_record_supplier_payment.sql` does not exist. Add it: `create or replace function app.record_supplier_payment(p_supplier_id uuid, p_amount numeric, p_currency_code text, p_payment_method_code text, p_booking_id uuid default null, p_paid_at timestamptz default now(), p_reference_number text default null) returns uuid` — `security invoker`, `set search_path=''`; tenant via `app.current_tenant_id()`; validate amount > 0, payment_method catalog, supplier/booking tenancy; `app.authorize('RECORD_PAYMENT')`; insert `payments` (direction `supplier_payment`); emit `supplier_payment_recorded`; `grant execute ... to authenticated`.
2. Sync `manifest.md` per `CR_LIFECYCLE.md §9` (trimmed).

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607047400`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: recording a supplier payment reduces `app.supplier_balance` outstanding by the amount and emits `supplier_payment_recorded`.
- [x] Behavioral: amount ≤ 0, unknown payment method, and a cross-tenant supplier are rejected; a caller without `RECORD_PAYMENT` is blocked.
- [x] No canonical doc other than the manifest modified.

---

## Execution Log

### 2026-07-09 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607047400_record_supplier_payment.sql` created.
- Step 2: Applied — manifest synced (trimmed).

Verification: `npx supabase db reset` clean incl. `202607047400`; smoke-test → ALL CHECKS PASSED (71 tables). Behavioral (rolled back): a supplier with USD 500 locked cost → payable 500; record supplier payment 200 → payable 300 and `supplier_payment_recorded` emitted; amount 0 / unknown method / foreign supplier rejected; senior_employee → `permission denied: RECORD_PAYMENT`.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-09 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently verified against live DB — `db reset` clean, smoke ALL CHECKS PASSED (71 tables); a recorded supplier payment draws down `supplier_balance` exactly, guards fire, event emitted. Additive; no canon change beyond the manifest; no new architectural decision.

Recommendation to human: Set Status to Complete (autonomous per `CR_LIFECYCLE.md` §5).

---

## Review Gate

- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied.
- [x] No file outside the Scope list was modified or created.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On handled (nothing to supersede).
- [x] The repository is in a clean, releasable state.

---

## Notes

Supplier-payment write; draws down `supplier_balance`. Remaining Phase 6: refund workflow (`record_refund`), basic journal entries, profit per booking item.
