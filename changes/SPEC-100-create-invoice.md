# Change Request — SPEC-100

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

Add `app.create_invoice(...)`, the first finance-transaction write capability: create a customer invoice in `draft` status with a per-tenant, year-prefixed, DB-unique sequential number.

---

## Business Reason

Phase 6 Finance Core "Invoices" (07/14 Finance Lite) and the keystone that turns the read-only `app.customer_balance` primitive into a live receivable pipeline (issuing an invoice later makes it a receivable). Invoice numbering follows researched legal/industry practice: unique and sequential/traceable (not necessarily gapless), per-tenant, year-prefixed (`INV-YYYY-NNNN`).

---

## Risks

Low. Additive: one partial-free unique index on `(tenant_id, invoice_number)` and one `SECURITY INVOKER` RPC; no table/column change. Numbering is race-safe (per-(tenant,year) advisory lock + `max+1`) and DB-unique (the index), so concurrent callers cannot collide. Creates only `draft` invoices (not receivables), so it cannot perturb `customer_balance` or the issuance risk flag. Verified by clean `db reset`, smoke-test, and behavioral tests of numbering/sequence, authority, amount validation, and the cross-tenant guard.

---

## Supersedes / Depends On

Depends on the finance-transaction tables (migration 12), `app.current_tenant_id`/`app.authorize`/`app.record_event`, and the seeded `CREATE_INVOICE` (migration 36). Consumed later by issue-invoice and payment-recording slices. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607046900_create_invoice.sql
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-100-create-invoice.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable); any `_ORVION_CANONICAL/**` except the manifest (no canon change: `CREATE_INVOICE` and `invoice_status_code`/`draft` are already canonical; `invoice_created` is a plain-text event per ADR-0006); AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`, `32_execution_roadmap.md`.

---

## Minimum Reading List

- _ORVION_CANONICAL/14_finance_rules.md (Finance Lite scope)
- supabase/migrations/202607042500_create_finance_transaction_tables.sql (invoices table)
- supabase/migrations/202607046300_customer_balance.sql (which invoice statuses are receivables)

---

## Implementation Steps

1. Verify `202607046900_create_invoice.sql` does not exist. Add it: (a) `create unique index if not exists invoices_tenant_number_key on public.invoices (tenant_id, invoice_number)`; (b) `create or replace function app.create_invoice(p_customer_id uuid, p_currency_code text, p_total_amount numeric, p_booking_id uuid default null, p_booking_item_id uuid default null, p_invoice_date date default current_date, p_due_date date default null) returns uuid` — `security invoker`, `set search_path=''`; tenant via `app.current_tenant_id()`; validate `total_amount > 0` and that customer/booking/booking_item are in-tenant; `app.authorize('CREATE_INVOICE')`; allocate `INV-YYYY-NNNN` under `pg_advisory_xact_lock(hashtextextended(tenant||':'||year,0))` via `max(split_part(number,'-',3)::int)+1`; insert status `draft`; emit `invoice_created`; `grant execute ... to authenticated`.
2. Sync `manifest.md` per `CR_LIFECYCLE.md §9`.

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607046900`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: an authorized caller (finance_manager/owner) creates an invoice; the number is `INV-2026-0001`, status `draft`, and an `invoice_created` event is emitted.
- [x] Behavioral: a second invoice for the same tenant/year is numbered `INV-2026-0002` (sequential, unique).
- [x] Behavioral: a caller without `CREATE_INVOICE` (senior_employee) is blocked; `total_amount <= 0` raises; a customer not in the caller's tenant raises.
- [x] No canonical doc other than the manifest modified.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607046900_create_invoice.sql` created (unique index + `app.create_invoice`).
- Step 2: Applied — manifest synced.

Verification: `npx supabase db reset` clean incl. `202607046900`; smoke-test → ALL CHECKS PASSED (71 tables). Behavioral (authenticated-caller sim, rolled back): owner created two invoices → `INV-2026-0001` then `INV-2026-0002`, both `draft`, each with an `invoice_created` event carrying the number; `total_amount = 0` → raised; customer from another tenant → raised; senior_employee → `permission denied: CREATE_INVOICE`.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently re-verified against live DB. `db reset` clean (202607046900 applied), smoke-test ALL CHECKS PASSED (71 tables). `create_invoice` produces sequential per-tenant/year numbers (`INV-2026-0001`/`0002`), enforced unique by `invoices_tenant_number_key`; creates `draft` invoices (confirmed excluded from `customer_balance`); emits `invoice_created`; and enforces `CREATE_INVOICE`, positive amount, and tenant membership. Numbering is race-safe (advisory lock) and non-gapless by design, matching researched legal/industry practice. Additive; no canon change beyond the manifest; no new architectural decision (Finance Core direction, ADR-0014/0021).

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

First finance-transaction write capability. Numbering scheme researched (unique + sequential + per-tenant + year-prefixed; gapless not required). Natural next slices: issue-invoice (`draft -> issued`, making it a receivable), then payment recording (drives `partially_paid`/`paid` via `payment_allocations`), then receipts/refund workflows and profit-per-item — the remaining Phase-6 Finance Core outputs.
