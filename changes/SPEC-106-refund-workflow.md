# Change Request — SPEC-106

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

Add the customer refund workflow: `app.record_refund` (open a `requested` refund) and `app.advance_refund` (drive it through requested → approved → processing → completed / rejected / cancelled), where `completed` re-opens the receivable in `app.customer_balance`.

---

## Business Reason

Phase 6 Finance Core "Refunds" (07/14 Finance Lite). A refund is requested, reviewed, and completed; only a completed refund returns cash and re-opens what the customer owes (already read by `app.customer_balance`). Delivered as one capability with two functions (create + lifecycle), mirroring the invoice create-then-transition pattern, since the refund states are canonical but no refund state machine exists in `26`.

---

## Risks

Low. Additive, `SECURITY INVOKER`, RLS-backed. Two RPCs; no table/schema change. Refund states/reasons are validated against their catalogs; transitions are the natural lifecycle with rejected/cancelled off-ramps; `completed` sets `completed_at` (the balance trigger). Both guarded by `RECORD_REFUND`. Verified by clean `db reset`, smoke-test, and behavioral tests: request → approve → complete makes `customer_balance` reflect the refund; illegal transitions, catalog/tenant validation, and the authority guard are rejected.

---

## Supersedes / Depends On

Depends on `app.customer_balance` (SPEC-089, reads completed customer refunds) and the seeded `RECORD_REFUND`. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607047500_record_refund.sql
- supabase/migrations/202607047600_advance_refund.sql
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-106-refund-workflow.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable); any `_ORVION_CANONICAL/**` except the manifest (states/reasons already canonical; events plain-text per ADR-0006); AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`, `32_execution_roadmap.md`.

---

## Minimum Reading List

- supabase/migrations/202607046300_customer_balance.sql (completed refunds re-open the receivable)
- supabase/migrations/202607045800_advance_booking.sql (transition-table pattern)

---

## Implementation Steps

1. Verify `202607047500_record_refund.sql` does not exist. Add `app.record_refund(p_customer_id uuid, p_amount numeric, p_currency_code text, p_refund_reason_code text, p_booking_id uuid default null, p_original_payment_id uuid default null) returns uuid` — validates amount, `refund_reason_code` catalog, customer/booking/payment tenancy; `app.authorize('RECORD_REFUND')`; inserts a `customer_refund` in `requested`; emits `refund_requested`.
2. Verify `202607047600_advance_refund.sql` does not exist. Add `app.advance_refund(p_refund_id uuid, p_to_status text, p_reason text default null) returns text` — transition table (requested→approved/rejected/cancelled, approved→processing/completed/cancelled, processing→completed/cancelled); `app.authorize('RECORD_REFUND')`; sets `completed_at` on `completed`; emits `refund_approved/rejected/processing/completed/cancelled`.
3. Sync `manifest.md` per `CR_LIFECYCLE.md §9` (trimmed).

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607047500` and `202607047600`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: `record_refund` creates a `requested` refund; `advance_refund` walks requested→approved→completed, sets `completed_at`, and the completed refund appears in `app.customer_balance` (re-opening the receivable); a `requested` refund does not.
- [x] Behavioral: an illegal transition (e.g. requested→completed) is rejected; an unknown refund reason and a cross-tenant customer are rejected; a caller without `RECORD_REFUND` is blocked.
- [x] No canonical doc other than the manifest modified.

---

## Execution Log

### 2026-07-09 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — `202607047500_record_refund.sql` created.
- Step 2: Applied — `202607047600_advance_refund.sql` created.
- Step 3: Applied — manifest synced (trimmed).

Verification: `npx supabase db reset` clean incl. both migrations; smoke-test → ALL CHECKS PASSED (71 tables). Behavioral (rolled back): record_refund → `requested` (customer_balance unaffected); advance requested→approved→completed → `completed_at` set and customer_balance shows the refund re-opening the receivable; requested→completed rejected (`refund transition not allowed`); unknown reason / foreign customer rejected; senior_employee → `permission denied: RECORD_REFUND`.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-09 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently verified against live DB — `db reset` clean, smoke ALL CHECKS PASSED (71 tables). The refund lifecycle behaves as specified: only a completed customer refund affects `customer_balance`; illegal transitions, catalog/tenant validation, and the `RECORD_REFUND` guard all reject. Additive; no canon change beyond the manifest; no new architectural decision (states canonical; transitions realise the implied lifecycle, same pattern as `advance_booking`).

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

Refund workflow (customer side). Supplier refunds (`supplier_refund` direction) are a future mirror if needed. Remaining Phase 6: basic journal entries and profit per booking item.
