# Change Request — SPEC-102

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

Add `app.record_payment(...)`, recording a customer payment against an issued invoice, allocating it, and deriving the invoice status (`partially_paid`/`paid`) — closing the invoicing→receivable loop.

---

## Business Reason

Phase 6 Finance Core "Payments" (07/14 Finance Lite). Completes create → issue → pay: a recorded payment allocates to an issued invoice, drives its status, and draws down the receivable in `app.customer_balance`. This is the core cash-collection primitive the outstanding-balance picture depends on.

---

## Risks

Moderate (finance-sensitive; verified across the matrix). Additive, `SECURITY INVOKER`, RLS-backed. Customer and currency derive from the invoice (no mismatch); only issued/partially_paid/overdue invoices are payable; over-allocation is rejected; allocation is serialised per invoice with an advisory lock so concurrent payments cannot over-allocate; status is derived from the live allocation sum (cannot drift). No table/schema change. Verified by clean `db reset`, smoke-test, and behavioral tests: partial then full payment (status + balance progression), over-allocation rejection, invalid method, non-payable status, and the authority guard.

---

## Supersedes / Depends On

Depends on SPEC-101 (`app.issue_invoice`) and `app.customer_balance` (SPEC-089); uses the seeded `RECORD_PAYMENT`. Consumed later by receipts. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607047100_record_payment.sql
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-102-record-payment.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable); any `_ORVION_CANONICAL/**` except the manifest (no canon change: statuses/direction/method are already canonical; the events are plain-text per ADR-0006); AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`, `32_execution_roadmap.md`.

---

## Minimum Reading List

- supabase/migrations/202607042500_create_finance_transaction_tables.sql (payments, payment_allocations)
- supabase/migrations/202607047000_issue_invoice.sql (issued invoices)
- supabase/migrations/202607046300_customer_balance.sql (receivable definition)

---

## Implementation Steps

1. Verify `202607047100_record_payment.sql` does not exist. Add it: `create or replace function app.record_payment(p_invoice_id uuid, p_amount numeric, p_payment_method_code text, p_paid_at timestamptz default now(), p_reference_number text default null) returns uuid` — `security invoker`, `set search_path=''`; tenant via `app.current_tenant_id()`; validate `amount > 0` and `payment_method` catalog; load in-tenant invoice, reject archived/voided and status not in issued/partially_paid/overdue; `app.authorize('RECORD_PAYMENT')`; advisory-lock the invoice, compute already-allocated, reject over-allocation; insert `payments` (customer_payment; customer/currency from invoice) + `payment_allocations`; derive status `paid`/`partially_paid` and update the invoice; emit `payment_recorded` and the invoice `invoice_paid`/`invoice_partially_paid` transition event; `grant execute ... to authenticated`.
2. Sync `manifest.md` per `CR_LIFECYCLE.md §9` (trimmed).

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607047100`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: a partial payment on an issued invoice sets status `partially_paid` and reduces `customer_balance` by the amount; a further payment covering the remainder sets `paid` and brings the receivable to 0.
- [x] Behavioral: a payment exceeding the invoice outstanding is rejected; an unknown `payment_method` is rejected; a draft/paid/voided invoice is not payable.
- [x] Behavioral: a caller without `RECORD_PAYMENT` (senior_employee) is blocked.
- [x] No canonical doc other than the manifest modified.

---

## Execution Log

### 2026-07-09 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607047100_record_payment.sql` created (`app.record_payment`).
- Step 2: Applied — manifest synced (trimmed).

Verification: `npx supabase db reset` clean incl. `202607047100`; smoke-test → ALL CHECKS PASSED (71 tables). Behavioral (authenticated-caller sim, rolled back): on an issued USD 1000 invoice — pay 400 → status `partially_paid`, balance 600, `payment_recorded` + `invoice_partially_paid`; pay 600 → status `paid`, balance 0, `invoice_paid`; a third 100 → rejected `payment ... exceeds invoice outstanding`; unknown method → rejected; draft invoice → not payable; senior_employee → `permission denied: RECORD_PAYMENT`.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-09 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently re-verified against live DB. `db reset` clean (202607047100 applied), smoke-test ALL CHECKS PASSED (71 tables). `record_payment` allocates to the invoice, derives status from the live allocation sum (partial → `partially_paid`, full → `paid`), and `customer_balance` tracks the drawdown exactly (1000 → 600 → 0). Over-allocation, invalid method, non-payable status, and missing `RECORD_PAYMENT` are all rejected; the advisory lock serialises per-invoice allocation. Additive; no canon change beyond the manifest; no new architectural decision (Finance Core direction, ADR-0021).

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

Third invoicing/receivables slice; closes create → issue → pay. Natural next: receipts (a receipt document per payment, `receipts` table), supplier payables (the `supplier_payment` direction mirror), refund workflows, basic journal entries, and profit per booking item. Multi-invoice allocation, on-account credit/overpayment, and cross-currency allocation (`exchange_rate_id`) are deferred future slices recorded here.
