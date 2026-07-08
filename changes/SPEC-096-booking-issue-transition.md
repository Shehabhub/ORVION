# Change Request — SPEC-096

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

Implement the booking-level Issue transitions `in_progress -> issued` and `issued -> completed` in `app.advance_booking`, minting `ISSUE_BOOKING` and landing the ADR-0020 negative-balance issuance risk flag as a first-class event.

---

## Business Reason

Slice 3 of the ADR-0020 booking capability set. Issuance ("one or more issuable items issued", 26) is finance-consequential, so it mints `ISSUE_BOOKING`. It also resolves the risk flag deferred by ADR-0020 until `app.customer_balance()` existed (SPEC-089): issuing before full collection requires `ALLOW_ISSUE_WITH_NEGATIVE_BALANCE` (28) and records the canonical `booking_item_risk_flag_created` event (severity `risk`) capturing the customer balance snapshot — a first-class event, no table (event philosophy). `issued -> completed` is booking-operator workflow under `CREATE_BOOKING`.

---

## Risks

Low-moderate (finance-sensitive, so verified across the full gate matrix). Additive and service-agnostic. The balance snapshot is authoritative: `app.customer_balance` is tenant-scoped by the generic `tenant_isolation` RLS policy, which every `ISSUE_BOOKING` role satisfies, so the gate cannot be silently bypassed by caller row-visibility. `create or replace` of `advance_booking` changes only the transition table, the issuance risk-flag block, and the deferred-contract message. No table/schema change. Verified by clean `db reset`, smoke-test, and behavioral tests covering: issuance fully-paid (no flag, no override needed), issuance owing (override required + risk flag emitted with snapshot), issuance blocked without `ISSUE_BOOKING`, and `issued -> completed`.

---

## Supersedes / Depends On

Depends on SPEC-094 (`202607046500_advance_booking_progress.sql`, replaced here), `app.customer_balance` (SPEC-089), and the seeded `ALLOW_ISSUE_WITH_NEGATIVE_BALANCE`. Extends ADR-0020/ADR-0021. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607046600_advance_booking_issue.sql
- _ORVION_CANONICAL/25_catalog_registry.md
- _ORVION_CANONICAL/28_permissions_matrix.md
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-096-booking-issue-transition.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable, incl. `202607046500_advance_booking_progress.sql` and `202607046300_customer_balance.sql`); `_ORVION_CANONICAL/26_state_machines.md` and `27_event_catalog.md` (the transitions and the `booking_item_risk_flag_created` event are already canonical); any completed `changes/SPEC-0*.md`; AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`, `32_execution_roadmap.md`.

---

## Minimum Reading List

- supabase/migrations/202607046500_advance_booking_progress.sql (the function being replaced)
- supabase/migrations/202607046300_customer_balance.sql (balance primitive)
- _ORVION_CANONICAL/27_event_catalog.md (`booking_item_risk_flag_created`, severity `risk`)
- reports/architecture-decision-records.md (ADR-0020, ADR-0021)

---

## Implementation Steps

1. Verify `202607046600_advance_booking_issue.sql` does not exist. Add it: (a) mint `ISSUE_BOOKING` (`on conflict do nothing`) + grant to owner/ceo/branch_manager/finance_manager; (b) `create or replace app.advance_booking` adding rows `('in_progress','issued','booking_issued','ISSUE_BOOKING')` and `('issued','completed','booking_completed','CREATE_BOOKING')`; on `p_to_status='issued'` snapshot `app.customer_balance(customer_id, booking_id)`, set `v_owes = any currency outstanding_balance > 0`, and if owing `perform app.authorize('ALLOW_ISSUE_WITH_NEGATIVE_BALANCE')`; after the `booking_issued` event, when owing emit `booking_item_risk_flag_created` (entity `booking`, severity `risk`) with permission used + balance snapshot + reason; remove `'issued'` from the deferred-contract `in (...)` list (leaving `void/refunded/reissue`).
2. Add `ISSUE_BOOKING` to `25_catalog_registry.md` permission_key list (after `APPROVE_BOOKING`).
3. Add the `ISSUE_BOOKING` row + Notes to `28_permissions_matrix.md` Booking Permissions.
4. Sync `manifest.md` per `CR_LIFECYCLE.md §9`.

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607046600`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] `ISSUE_BOOKING` exists and is granted to exactly owner/ceo/branch_manager/finance_manager.
- [x] Behavioral: fully-paid booking `in_progress -> issued` succeeds with NO risk-flag event and no `ALLOW_ISSUE_WITH_NEGATIVE_BALANCE` requirement.
- [x] Behavioral: owing booking `in_progress -> issued` requires `ALLOW_ISSUE_WITH_NEGATIVE_BALANCE` (blocked without it) and, with it, emits one `booking_item_risk_flag_created` event carrying the per-currency balance snapshot.
- [x] Behavioral: `in_progress -> issued` is blocked for a caller without `ISSUE_BOOKING`; `issued -> completed` succeeds under `CREATE_BOOKING`.
- [x] `ISSUE_BOOKING` recorded in canon 25 and 28; no other canonical doc modified.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607046600_advance_booking_issue.sql` created (mint + grants + `create or replace` with issuance risk-flag block).
- Step 2: Applied — `ISSUE_BOOKING` added to `25_catalog_registry.md`.
- Step 3: Applied — `ISSUE_BOOKING` row + Notes added to `28_permissions_matrix.md`.
- Step 4: Applied — manifest synced.

Verification: `npx supabase db reset` clean incl. `202607046600`; smoke-test → ALL CHECKS PASSED (71 tables). Grant check: `ISSUE_BOOKING` = {owner, ceo, branch_manager, finance_manager}. Behavioral (authenticated-caller sim, rolled back): fully-paid issue → `issued`, 0 risk-flag events; owing issue without override (branch_manager lacking? — used a finance_manager with/without) → blocked `permission denied: ALLOW_ISSUE_WITH_NEGATIVE_BALANCE`; owing issue with override → `issued` + 1 `booking_item_risk_flag_created` with the USD snapshot; issue without `ISSUE_BOOKING` (senior_employee) → blocked; `issued -> completed` → `completed`.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently re-verified against live DB. `db reset` clean (202607046600 applied), smoke-test ALL CHECKS PASSED (71 tables). `ISSUE_BOOKING` granted to exactly the four finance-consequential roles. Behavioral gate matrix passed: fully-paid issuance emits no risk flag and needs no override; owing issuance is blocked without `ALLOW_ISSUE_WITH_NEGATIVE_BALANCE` and, with it, emits exactly one `booking_item_risk_flag_created` event whose payload carries `permission_used` and the per-currency `customer_balance_snapshot`; issuance is blocked without `ISSUE_BOOKING`; `issued -> completed` works. Balance snapshot is authoritative under the tenant_isolation RLS. Canon 25/28 register the permission; 26/27 untouched (transition + event already canonical). No new architectural decision (ADR-0020/0021 govern).

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

Slice 3 of 5 (ADR-0020 booking capability set); closes the long-deferred negative-balance issuance risk flag. Next: Cancel/Void (`confirmed/in_progress -> cancelled`, `issued -> void`, `void -> completed`), minting `CANCEL_BOOKING`; then Refund/Reissue (`issued -> refunded/reissue`, `reissue -> issued`, `refunded -> completed`), minting `REFUND_BOOKING`/`REISSUE_BOOKING` — completing the booking lifecycle.
