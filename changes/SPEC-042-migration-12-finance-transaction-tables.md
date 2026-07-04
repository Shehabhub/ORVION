# Change Request — SPEC-042

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word anywhere in a Change Request.

---

## Assigned Model Tier

[ ] Tier 1 — Strong reasoning model
[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Create migration 12, `create_finance_transaction_tables`, defining `journal_entries`, `journal_entry_lines`, `invoices`, `payments`, `payment_allocations`, `receipts`, `refunds`, `approval_requests`, and `company_assets` per `31_schema_draft.md` section 5 and `30_database_conventions.md`.

---

## Business Reason

`33` migration 12 adds the finance transaction layer. It depends on migrations 6 (exchange_rates/chart_of_accounts/financial_accounts), 7 (documents), 8 (customers), and 10 (bookings/booking_items). `approval_requests` needs both `booking_items` and `documents`. Structure only.

---

## Risks

Moderate (9 tables). Prerequisites live. Money `numeric(14,2)`; status/type/method/direction/reason codes plain text (SPEC-030). The journal debit/credit exclusivity CHECK (`31` Rules) is DB-enforced. Polymorphic `source_entity_id`/`related_entity_id` are plain columns. Physical choices in Notes.

---

## Supersedes / Depends On

Depends On: `SPEC-035` (finance foundation), `SPEC-036` (documents), `SPEC-038` (customers/leads), `SPEC-039` (suppliers), `SPEC-040` (bookings/booking_items), `SPEC-028` (moddatetime) — all Complete.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607042500_create_finance_transaction_tables.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; any later migration ; seed data

---

## Minimum Reading List

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/33_sql_migration_plan.md

---

## Implementation Steps

1. Create `supabase/migrations/202607042500_create_finance_transaction_tables.sql` defining the nine tables per `31` section 5: `journal_entries`, `journal_entry_lines` (with the debit/credit exclusivity CHECK), `invoices`, `payments`, `payment_allocations`, `receipts`, `refunds`, `approval_requests`, `company_assets`; all FKs `restrict`/`no action`; `currency_code`→`currencies`, `chart_account_id`→`chart_of_accounts`, `financial_account_id`→`financial_accounts`, `exchange_rate_id`→`exchange_rates`; status/type/method/direction/reason codes plain text; `updated_at` triggers on `invoices`/`payments`/`refunds`/`company_assets`; FK/tenant/status indexes.

---

## Acceptance Criteria

- [x] `supabase/migrations/202607042500_create_finance_transaction_tables.sql` exists.
- [x] `npx supabase db reset` applies every migration on a clean database with no error.
- [x] All nine tables exist; all foreign keys `restrict`/`no action`; no FK on any code column.
- [x] `journal_entry_lines` has a CHECK enforcing exactly one of debit/credit populated; verified behaviorally (both-zero rejected, both-positive rejected, one-positive accepted).
- [x] `updated_at` triggers exist on `invoices`, `payments`, `refunds`, `company_assets` (4) and nowhere else in this migration.

---

## Execution Log

### 2026-07-05 — Claude (Tier 2 execution)

Outcome: Complete

Step results:
- Step 1: Applied — created the migration; `npx supabase db reset` applied all 14 migrations cleanly.

Database Audit: 9 tables present; no FK deviates from restrict/no-action; no FK on any `_code` column; `updated_at` triggers on invoices/payments/refunds/company_assets only; the `journal_entry_lines_debit_xor_credit_check` constraint exists. Behavioral: both-zero and both-positive journal lines rejected, one-positive accepted; a currency FK rejected an unknown code (restrict).

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-05 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Re-checked all nine tables against `31` section 5 — column sets, nullability, archive fields on `invoices` only (per `31`), and money `numeric(14,2)` match. Referential Action Standard upheld; codes plain text (SPEC-030); polymorphic id columns carry no FK. The debit/credit exclusivity CHECK enforces the `31` journal Rule. `updated_at` triggers correct. Clean `db reset` and behavioral tests reproduced. No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Physical decisions: `journal_entry_lines.debit_amount`/`credit_amount` are `numeric(14,2) not null default 0` with a CHECK requiring both `>= 0` and exactly one `> 0` (enforcing the `31` "exactly one of debit or credit" Rule); polymorphic `journal_entries.source_entity_id` and `approval_requests.related_entity_id` are plain `uuid` columns (no FK); `approval_requests.payload` and no other finance table use `jsonb`; archive fields exist only on `invoices` (per `31`); `company_assets.currency_code` and `purchase_amount` are nullable per `31`. Non-negative CHECKs on other finance money columns (invoices/payments/refunds/allocations) are not mandated by `31` and were not added — logged as a Recommended backlog item for a later canonical decision.
