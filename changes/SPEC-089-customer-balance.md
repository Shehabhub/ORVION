# Change Request — SPEC-089

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Objective

Add `app.customer_balance(...)`, the derived, read-only, per-currency definition of a customer's outstanding balance — the first Phase 6 (Finance Core) capability.

---

## Business Reason

Finance Core's "Customer receivables" / "Outstanding balance" (07/14). The keystone read primitive: outstanding-balance reporting (Phase 9) and the negative-balance issuance risk flag deferred by ADR-0020 both depend on a single authoritative balance definition rather than each re-deriving it. Derived (not stored) so it can never drift from the underlying invoices/payments/refunds. Recorded as ADR-0021.

---

## Risks

Low. Read-only function, no schema change, no writes, no events. Definition decisions (which invoice statuses count, refund completion, multi-currency, signed convention, no new permission) are recorded in ADR-0021. Verified by behavioral test covering exclusions, multi-currency, booking filter, and the cross-tenant guard.

---

## Supersedes / Depends On

Depends on the finance-transaction tables (migration 12) and `app.current_tenant_id()` (migration 19). Forward-referenced by ADR-0020. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607046300_customer_balance.sql
- reports/architecture-decision-records.md
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-089-customer-balance.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file; any completed `changes/SPEC-0*.md`; AGENTS.md, CR_LIFECYCLE.md, README.md, PROTOCOL.md, PROJECT_CONTEXT.md, `_ORVION_CANONICAL/32_execution_roadmap.md`.

---

## Minimum Reading List

- _ORVION_CANONICAL/07_finance_model.md
- _ORVION_CANONICAL/14_finance_rules.md
- supabase/migrations/202607042500_create_finance_transaction_tables.sql
- supabase/migrations/202607045100_lead_booking_readiness.sql (read-RPC precedent)

---

## Implementation Steps

1. Add migration `202607046300_customer_balance.sql` defining `app.customer_balance(p_customer_id uuid, p_booking_id uuid default null) returns table(currency_code text, invoiced_amount numeric, paid_amount numeric, refunded_amount numeric, outstanding_balance numeric)`: `stable`, `security invoker`, `set search_path=''`; tenant via `app.current_tenant_id()` (raise if null); raise if the customer is not in the caller's tenant; per-currency `invoiced − paid + refunded` over live invoices (issued/partially_paid/paid/overdue; not voided/archived), `customer_payment` payments, and completed `customer_refund` refunds; optional booking filter; `grant execute ... to authenticated`.
2. Record ADR-0021 in `reports/architecture-decision-records.md`.

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607046300`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: full balance returns per-currency `invoiced − paid + refunded`, excluding draft/voided invoices, `supplier_payment`, and non-completed refunds (USD 1000/400/100/700; EUR 200/200/0/0).
- [x] Behavioral: `p_booking_id` narrows all three sources to that booking (USD 1000/400/0/600).
- [x] Behavioral: a customer not in the caller's tenant raises `customer is not in your tenant`.
- [x] Read-only (no writes/events); no new permission; follows the read-RPC precedent (RLS backstop).
- [x] ADR-0021 recorded.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607046300_customer_balance.sql` created. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` → ALL CHECKS PASSED (71 tables).
- Step 2: Applied — ADR-0021 appended.

Behavioral test (authenticated-caller simulation, rolled back): full → EUR 200/200/0/0, USD 1000/400/100/700; booking-filtered → USD 1000/400/0/600; unknown customer → raised `customer is not in your tenant`. Draft/voided invoices, `supplier_payment`, and non-completed refund all correctly excluded; multi-currency separated; RLS permitted the tenant member (read-RPC precedent confirmed).

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently re-ran `db reset` (clean, migration applied) and the smoke-test (ALL CHECKS PASSED, 71 tables). Re-ran the behavioral scenario against live DB state: all four assertions match expected values exactly, confirming the balance formula, the status/direction/refund-status exclusions, per-currency grouping, the booking filter, and the tenant guard. Function is read-only, `security invoker`, no new permission — consistent with ADR-0021 and the `lead_booking_readiness` precedent.

Recommendation to human: Set Status to Complete (autonomous per `CR_LIFECYCLE.md` §5 — the decision is recorded in ADR-0021; implementation verified).

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside the Scope list was modified or created.
- [x] No completed CR (append-only history) was altered.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On handled.
- [x] The repository is in a clean, releasable state.

---

## Notes

First Phase 6 (Finance Core) capability. Next candidates within Finance Core: outstanding-balance surfacing per booking, and — now that `customer_balance()` exists — the negative-balance issuance risk flag deferred by ADR-0020.
