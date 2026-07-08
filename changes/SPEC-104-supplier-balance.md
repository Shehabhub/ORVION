# Change Request — SPEC-104

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

Add `app.supplier_balance(...)`, the derived, read-only, per-currency definition of what ORVION owes an external supplier — the payables mirror of `app.customer_balance`.

---

## Business Reason

Phase 6 Finance Core "Supplier payables" (07/14 Finance Lite). There is no supplier-bill table; Design Review confirmed the payable must be derived (like the customer receivable). This is the authoritative payable primitive: `outstanding = locked booking-item cost owed to the supplier − supplier payments`, per currency. Unblocks supplier-payables reporting (Phase 9) and a future supplier-payment-recording slice.

---

## Risks

Low. Read-only function; no schema/table change, no writes, no events. Definition parallels `customer_balance` (ADR-0021): counts only cost-locked, non-cancelled/no_show, non-archived items (cost is provisional until finance approval locks it, per `14`); per-currency, never collapsed. `SECURITY INVOKER`, RLS-backed (read-RPC precedent — no `app.authorize`). Verified by clean `db reset`, smoke-test, and behavioral tests covering the locked/unlocked/cancelled exclusions, supplier payments, multi-currency, the booking filter, and the cross-tenant guard.

---

## Supersedes / Depends On

Depends on the booking-item cost fields (migration 11), `payments` (migration 12), and `app.current_tenant_id`. Establishes the payables analogue of `app.customer_balance` (SPEC-089, ADR-0021). Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607047300_supplier_balance.sql
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-104-supplier-balance.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable); any `_ORVION_CANONICAL/**` except the manifest; AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`, `32_execution_roadmap.md`.

---

## Minimum Reading List

- supabase/migrations/202607046300_customer_balance.sql (the receivables primitive being mirrored)
- supabase/migrations/202607042300_create_booking_core_tables.sql (booking_items cost fields)
- _ORVION_CANONICAL/14_finance_rules.md (cost locks at finance approval)

---

## Implementation Steps

1. Verify `202607047300_supplier_balance.sql` does not exist. Add it: `create or replace function app.supplier_balance(p_supplier_id uuid, p_booking_id uuid default null) returns table(currency_code text, cost_amount numeric, paid_amount numeric, outstanding_payable numeric)` — `stable`, `security invoker`, `set search_path=''`; tenant via `app.current_tenant_id()` (raise if null); raise if the supplier is not in the caller's tenant; per-currency `cost − paid` over locked/non-cancelled/non-archived booking-item `cost_amount` for the supplier and `supplier_payment` payments to the supplier; optional booking filter; `grant execute ... to authenticated`.
2. Sync `manifest.md` per `CR_LIFECYCLE.md §9` (trimmed).

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607047300`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: payable = Σ(locked cost) − Σ(supplier payments) per currency; an unlocked-cost item, a cancelled item, and a customer_payment are all excluded.
- [x] Behavioral: `p_booking_id` narrows both sources to that booking; multi-currency stays separated.
- [x] Behavioral: a supplier not in the caller's tenant raises `supplier is not in your tenant`.
- [x] No canonical doc other than the manifest modified.

---

## Execution Log

### 2026-07-09 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607047300_supplier_balance.sql` created (`app.supplier_balance`).
- Step 2: Applied — manifest synced (trimmed).

Verification: `npx supabase db reset` clean incl. `202607047300`; smoke-test → ALL CHECKS PASSED (71 tables). Behavioral (authenticated-caller sim, rolled back): a supplier with two locked-cost USD items (500 + 300) and one supplier_payment (200) → USD cost 800 / paid 200 / outstanding 600; an unlocked-cost item, a cancelled locked item, and a customer_payment were all excluded; a second-currency item stayed a separate row; `p_booking_id` narrowed to one booking; a foreign supplier raised `supplier is not in your tenant`.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-09 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently re-verified against live DB. `db reset` clean (202607047300 applied), smoke-test ALL CHECKS PASSED (71 tables). `supplier_balance` derives `cost − paid` per currency, correctly excluding unlocked/cancelled/archived items and non-supplier_payment payments, with the booking filter and tenant guard working. Read-only, `security invoker`, no permission — consistent with the `customer_balance` precedent (ADR-0021). Additive; no canon change beyond the manifest; no new architectural decision.

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

Payables mirror of `app.customer_balance`. Natural next: record supplier payments (the `supplier_payment` write, drawing down this payable), then basic journal entries and profit per booking item (selling price − cost) to close Phase 6 Finance Core.
