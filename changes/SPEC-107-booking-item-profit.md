# Change Request — SPEC-107

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

Add `app.booking_item_profit(...)`, the derived, read-only definition of profit per booking item (`selling_amount − cost_amount`, per item, per currency).

---

## Business Reason

Phase 6 Finance Core "Profit per booking item" (07/14 Finance Lite). The margin view that unblocks profitability reporting (Phase 9). Derived (never stored) from `booking_items`, mirroring the `customer_balance`/`supplier_balance` read-primitive pattern.

---

## Risks

Low. Read-only function; no schema/table change, no writes, no events. Excludes cancelled/no_show/archived items; treats null selling/cost as 0; returns `cost_locked` so consumers can distinguish projected vs realised profit. `SECURITY INVOKER`, RLS-backed (read-RPC precedent — no `app.authorize`). Verified by clean `db reset`, smoke-test, and behavioral tests of the profit computation, exclusions, filters, and the tenant guard.

---

## Supersedes / Depends On

Depends on the booking-item pricing fields (`selling_amount`/`cost_amount`, migration 11) and `app.current_tenant_id`. Completes the derived read primitives alongside `app.customer_balance`/`app.supplier_balance`. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607047700_booking_item_profit.sql
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-107-booking-item-profit.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable); any `_ORVION_CANONICAL/**` except the manifest; AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`, `32_execution_roadmap.md`.

---

## Minimum Reading List

- supabase/migrations/202607046300_customer_balance.sql (read-primitive precedent)
- supabase/migrations/202607042300_create_booking_core_tables.sql (booking_items pricing fields)

---

## Implementation Steps

1. Verify `202607047700_booking_item_profit.sql` does not exist. Add `app.booking_item_profit(p_booking_id uuid default null, p_booking_item_id uuid default null) returns table(booking_item_id uuid, booking_id uuid, currency_code text, selling_amount numeric, cost_amount numeric, profit numeric, cost_locked boolean)` — `stable`, `security invoker`, `set search_path=''`; tenant via `app.current_tenant_id()`; per-item `coalesce(selling,0) − coalesce(cost,0)` over non-cancelled/no_show/non-archived items, optional booking/item filters; `grant execute ... to authenticated`.
2. Sync `manifest.md` per `CR_LIFECYCLE.md §9` (trimmed).

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607047700`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: profit = `selling − cost` per item; a cancelled item is excluded; `cost_locked` reflects `cost_locked_at`.
- [x] Behavioral: `p_booking_item_id` narrows to one item; a null-cost item yields profit = selling.
- [x] Behavioral: a caller in another tenant sees none of this tenant's items (RLS).
- [x] No canonical doc other than the manifest modified.

---

## Execution Log

### 2026-07-09 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607047700_booking_item_profit.sql` created.
- Step 2: Applied — manifest synced (trimmed).

Verification: `npx supabase db reset` clean incl. `202607047700`; smoke-test → ALL CHECKS PASSED (71 tables). Behavioral (rolled back): items (sell 1000/cost 700 → profit 300, cost_locked true) and (sell 200/cost null → profit 200, cost_locked false); a cancelled item excluded; `p_booking_item_id` narrowed to one row; tenant guard via RLS returned only in-tenant items.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-09 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently verified against live DB — `db reset` clean, smoke ALL CHECKS PASSED (71 tables). `booking_item_profit` returns `selling − cost` per item, excludes cancelled/no_show/archived, exposes `cost_locked` for projected-vs-realised, honours the filters, and is RLS-scoped. Read-only, `security invoker`, no permission — consistent with the derived-primitive precedent (ADR-0021). Additive; no canon change beyond the manifest; no new architectural decision.

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

Completes the Phase-6 derived read primitives (receivable, payable, profit). Remaining Phase 6: basic journal entries, after which Phase 6 Finance Core is complete.
