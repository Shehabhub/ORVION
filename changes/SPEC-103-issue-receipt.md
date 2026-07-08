# Change Request — SPEC-103

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

Add `app.issue_receipt(...)`, issuing a receipt document for a recorded payment with a per-tenant, year-prefixed, DB-unique sequential number (`RCP-YYYY-NNNN`), at most one per payment.

---

## Business Reason

Phase 6 Finance Core "Receipts" (07/14 Finance Lite). A receipt is the customer-facing acknowledgement of a recorded payment; it completes the cash-collection paper trail (invoice → payment → receipt). Numbering reuses the researched invoice-number discipline (unique/sequential/per-tenant/year-prefixed, not gapless).

---

## Risks

Low (Routine: mirrors `create_invoice`). Additive: two unique indexes (`(tenant_id, receipt_number)`, `(tenant_id, payment_id)`) + one `SECURITY INVOKER` RPC; no table/column change. One receipt per payment (enforced by index + a pre-check); numbering race-safe via a per-(tenant,year) advisory lock. Verified by clean `db reset`, smoke-test, and behavioral tests of numbering/sequence, the one-per-payment rule, cross-tenant guard, and authority.

---

## Supersedes / Depends On

Depends on SPEC-102 (`app.record_payment` — receipts are issued for payments); uses the seeded `CREATE_RECEIPT`. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607047200_issue_receipt.sql
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-103-issue-receipt.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable); any `_ORVION_CANONICAL/**` except the manifest (no canon change: `CREATE_RECEIPT` already canonical; `receipt_issued` is plain-text per ADR-0006); AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`, `32_execution_roadmap.md`.

---

## Minimum Reading List

- supabase/migrations/202607046900_create_invoice.sql (numbering pattern being mirrored)
- supabase/migrations/202607047100_record_payment.sql (payments that receipts acknowledge)

---

## Implementation Steps

1. Verify `202607047200_issue_receipt.sql` does not exist. Add it: (a) `create unique index if not exists receipts_tenant_number_key on public.receipts (tenant_id, receipt_number)` and `receipts_tenant_payment_key on public.receipts (tenant_id, payment_id)`; (b) `create or replace function app.issue_receipt(p_payment_id uuid) returns uuid` — `security invoker`, `set search_path=''`; tenant via `app.current_tenant_id()`; load in-tenant payment; reject if a receipt already exists for it; `app.authorize('CREATE_RECEIPT')`; allocate `RCP-YYYY-NNNN` under a per-(tenant,year) advisory lock via `max(split_part(number,'-',3)::int)+1`; insert the receipt; emit `receipt_issued`; `grant execute ... to authenticated`.
2. Sync `manifest.md` per `CR_LIFECYCLE.md §9` (trimmed).

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607047200`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: issuing a receipt for a payment returns an id, number `RCP-2026-0001`, and emits `receipt_issued`; a second payment's receipt is `RCP-2026-0002`.
- [x] Behavioral: issuing a second receipt for the same payment is rejected; a payment not in the caller's tenant is rejected.
- [x] Behavioral: a caller without `CREATE_RECEIPT` (senior_employee) is blocked.
- [x] No canonical doc other than the manifest modified.

---

## Execution Log

### 2026-07-09 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607047200_issue_receipt.sql` created (two unique indexes + `app.issue_receipt`).
- Step 2: Applied — manifest synced (trimmed).

Verification: `npx supabase db reset` clean incl. `202607047200`; smoke-test → ALL CHECKS PASSED (71 tables). Behavioral (authenticated-caller sim, rolled back): two payments → receipts `RCP-2026-0001`/`RCP-2026-0002`, each with a `receipt_issued` event; a second receipt on the same payment → `a receipt already exists for this payment`; a payment from another tenant → `payment is not in your tenant`; senior_employee → `permission denied: CREATE_RECEIPT`.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-09 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently re-verified against live DB. `db reset` clean (202607047200 applied), smoke-test ALL CHECKS PASSED (71 tables). `issue_receipt` produces sequential per-tenant/year numbers (`RCP-2026-0001`/`0002`), enforces one receipt per payment (index + pre-check), emits `receipt_issued`, and rejects cross-tenant payments and callers lacking `CREATE_RECEIPT`. Numbering mirrors the invoice discipline (race-safe, non-gapless). Additive; no canon change beyond the manifest; no new architectural decision.

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

Fourth invoicing/receivables slice; completes the customer-side paper trail (invoice → payment → receipt). Natural next: supplier payables (the `supplier_payment` direction mirror — supplier invoices/bills and payments), then refund workflows, basic journal entries, and profit per booking item to close Phase 6.
