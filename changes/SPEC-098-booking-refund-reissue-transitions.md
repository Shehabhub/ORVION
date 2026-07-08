# Change Request — SPEC-098

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

Implement the final booking-level transitions (`issued -> refunded`, `issued -> reissue`, `reissue -> issued`, `refunded -> completed`) in `app.advance_booking`, minting `REFUND_BOOKING` and `REISSUE_BOOKING` — completing the 26 Booking State Machine and the ADR-0020 capability set.

---

## Business Reason

Slice 5 (final) of the ADR-0020 booking capability set. Refund and Reissue are finance-consequential and mint their own permissions. Completing a re-issuance (`reissue -> issued`) reuses `ISSUE_BOOKING`, so it inherits the negative-balance risk-flag gate exactly like a first issuance. After this the entire booking lifecycle is implemented and no transition remains deferred.

---

## Risks

Low. Additive and service-agnostic. `create or replace` of `advance_booking` adds four transitions, extends the `warning` severities to `refunded`/`reissue`, and removes the now-empty deferred-contract in-list; issuance risk-flag logic, the cancellation-reason guard, and all other transitions are unchanged. No table/schema change. Verified by clean `db reset`, smoke-test, and behavioral tests of the refund path, the reissue→issued re-issuance path (incl. its risk-flag inheritance), and the authority guards.

---

## Supersedes / Depends On

Depends on SPEC-097 (`202607046700_advance_booking_cancel_void.sql`, replaced here). Extends ADR-0020. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607046800_advance_booking_refund_reissue.sql
- _ORVION_CANONICAL/25_catalog_registry.md
- _ORVION_CANONICAL/28_permissions_matrix.md
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-098-booking-refund-reissue-transitions.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable); `_ORVION_CANONICAL/26_state_machines.md` and `27_event_catalog.md` (transitions/events already canonical); any completed `changes/SPEC-0*.md`; AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`, `32_execution_roadmap.md`.

---

## Minimum Reading List

- supabase/migrations/202607046700_advance_booking_cancel_void.sql (the function being replaced)
- _ORVION_CANONICAL/26_state_machines.md (Booking State Machine — final transitions)
- _ORVION_CANONICAL/27_event_catalog.md (`booking_refunded`, `booking_reissue_started` severities)

---

## Implementation Steps

1. Verify `202607046800_advance_booking_refund_reissue.sql` does not exist. Add it: (a) mint `REFUND_BOOKING` + `REISSUE_BOOKING` (`on conflict do nothing`) + grant both to owner/ceo/branch_manager/finance_manager; (b) `create or replace app.advance_booking` adding rows `('issued','refunded','booking_refunded','REFUND_BOOKING')`, `('issued','reissue','booking_reissue_started','REISSUE_BOOKING')`, `('reissue','issued','booking_issued','ISSUE_BOOKING')`, `('refunded','completed','booking_completed','CREATE_BOOKING')`; add `'refunded'`/`'reissue'` to the `warning` severity set; remove the deferred-contract `in (...)` block entirely (an unknown target now falls through to "transition not allowed").
2. Add `REFUND_BOOKING` and `REISSUE_BOOKING` to `25_catalog_registry.md` permission_key list (after `CANCEL_BOOKING`).
3. Add the two rows + Notes to `28_permissions_matrix.md` Booking Permissions (capability set now complete).
4. Sync `manifest.md` per `CR_LIFECYCLE.md §9`.

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607046800`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] `REFUND_BOOKING` and `REISSUE_BOOKING` each exist and are granted to exactly owner/ceo/branch_manager/finance_manager.
- [x] Behavioral: `issued -> refunded` (warning), `refunded -> completed`, `issued -> reissue` (warning), and `reissue -> issued` (info) each succeed for an authorized caller.
- [x] Behavioral: `reissue -> issued` while the customer owes requires `ALLOW_ISSUE_WITH_NEGATIVE_BALANCE` and emits the risk flag (re-issuance inherits the issuance gate).
- [x] Behavioral: a caller without `REFUND_BOOKING` is blocked on `issued -> refunded`.
- [x] The full lifecycle has no remaining deferred transition; `REFUND_BOOKING`/`REISSUE_BOOKING` recorded in canon 25 and 28.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607046800_advance_booking_refund_reissue.sql` created (mint + grants + final `create or replace`, deferred in-list removed).
- Step 2: Applied — `REFUND_BOOKING`/`REISSUE_BOOKING` added to `25_catalog_registry.md`.
- Step 3: Applied — two rows + Notes added to `28_permissions_matrix.md` (capability set complete).
- Step 4: Applied — manifest synced.

Verification: `npx supabase db reset` clean incl. `202607046800`; smoke-test → ALL CHECKS PASSED (71 tables). Grants: `REFUND_BOOKING` and `REISSUE_BOOKING` = {owner, ceo, branch_manager, finance_manager} each. Behavioral (authenticated-caller sim, rolled back): `issued -> refunded` → refunded (warning); `refunded -> completed` → completed; `issued -> reissue` → reissue (warning); `reissue -> issued` → issued (info); `reissue -> issued` while owing → blocked without override, and with override → issued + 1 `booking_item_risk_flag_created`; `issued -> refunded` as senior_employee → `permission denied: REFUND_BOOKING`.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently re-verified against live DB. `db reset` clean (202607046800 applied), smoke-test ALL CHECKS PASSED (71 tables). Both new permissions granted to exactly the four finance-consequential roles. Behavioral matrix passed: the refund path, the reissue path, and re-issuance all produce the correct status/event/severity; re-issuance correctly inherits the negative-balance gate and risk flag; and `REFUND_BOOKING` is required for refund. The transition table now covers every edge of the 26 Booking State Machine with no deferred transitions. Canon 25/28 register the permissions and note the completed capability set; 26/27 untouched. No new architectural decision (ADR-0020 governs).

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

Completes the ADR-0020 capability-driven booking lifecycle (Submit/Approve/Issue/Cancel/Refund/Reissue) and the full 26 Booking State Machine. Recommended next: a brief Phase-6 booking-lifecycle coherence check, then the remaining Finance Core roadmap outputs (payments/receipts/invoices/refunds workflows, profit per booking item).
