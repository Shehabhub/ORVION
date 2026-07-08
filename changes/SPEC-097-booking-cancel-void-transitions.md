# Change Request — SPEC-097

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

Implement the booking-level Cancel/Void transitions (`confirmed/in_progress -> cancelled`, `issued -> void`, `void -> completed`) in `app.advance_booking`, minting `CANCEL_BOOKING` and enforcing a cancellation reason on every cancel edge.

---

## Business Reason

Slice 4 of the ADR-0020 booking capability set. Post-approval cancellation and void are finance-consequential, so they mint `CANCEL_BOOKING`; the pre-approval cancels stay under `CREATE_BOOKING` (the capability boundary is approval). Folds in a canon-27 alignment: `booking_cancelled` requires a cancellation reason, now enforced uniformly on every cancel edge (previously unenforced on the header transition).

---

## Risks

Low. Additive and service-agnostic. `create or replace` of `advance_booking` adds four transitions, a cancellation-reason guard, and `void` severity; issuance risk-flag logic and all other transitions are unchanged. The uniform reason guard changes the contract of the pre-existing `draft/pending_approval -> cancelled` edges (now require a reason) — aligning with canon 27; no production caller exists. No table/schema change. Verified by clean `db reset`, smoke-test, and behavioral tests of each new transition plus the authority and reason guards.

---

## Supersedes / Depends On

Depends on SPEC-096 (`202607046600_advance_booking_issue.sql`, replaced here). Extends ADR-0020. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607046700_advance_booking_cancel_void.sql
- _ORVION_CANONICAL/25_catalog_registry.md
- _ORVION_CANONICAL/28_permissions_matrix.md
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-097-booking-cancel-void-transitions.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable); `_ORVION_CANONICAL/26_state_machines.md` and `27_event_catalog.md` (transitions/events already canonical); any completed `changes/SPEC-0*.md`; AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`, `32_execution_roadmap.md`.

---

## Minimum Reading List

- supabase/migrations/202607046600_advance_booking_issue.sql (the function being replaced)
- _ORVION_CANONICAL/26_state_machines.md (Booking State Machine)
- _ORVION_CANONICAL/27_event_catalog.md (`booking_cancelled` requires reason; `booking_voided` severity)

---

## Implementation Steps

1. Verify `202607046700_advance_booking_cancel_void.sql` does not exist. Add it: (a) mint `CANCEL_BOOKING` (`on conflict do nothing`) + grant to owner/ceo/branch_manager/finance_manager; (b) `create or replace app.advance_booking` adding rows `('confirmed','cancelled','booking_cancelled','CANCEL_BOOKING')`, `('in_progress','cancelled','booking_cancelled','CANCEL_BOOKING')`, `('issued','void','booking_voided','CANCEL_BOOKING')`, `('void','completed','booking_completed','CREATE_BOOKING')`; add a guard raising when a `cancelled` transition has a null/blank `p_reason`; set the event severity to `warning` for `cancelled` and `void`; remove `'void'` from the deferred-contract `in (...)` list (leaving `refunded/reissue`).
2. Add `CANCEL_BOOKING` to `25_catalog_registry.md` permission_key list (after `ISSUE_BOOKING`).
3. Add the `CANCEL_BOOKING` row + Notes to `28_permissions_matrix.md` Booking Permissions.
4. Sync `manifest.md` per `CR_LIFECYCLE.md §9`.

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607046700`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] `CANCEL_BOOKING` exists and is granted to exactly owner/ceo/branch_manager/finance_manager.
- [x] Behavioral: `confirmed -> cancelled`, `in_progress -> cancelled`, `issued -> void`, `void -> completed` each succeed for an authorized caller with the right events/severities.
- [x] Behavioral: a `cancelled` transition with no reason raises "cancellation requires a reason"; a caller without `CANCEL_BOOKING` is blocked on `confirmed -> cancelled`.
- [x] `CANCEL_BOOKING` recorded in canon 25 and 28; no other canonical doc modified.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607046700_advance_booking_cancel_void.sql` created (mint + grants + `create or replace` with four transitions, reason guard, void severity).
- Step 2: Applied — `CANCEL_BOOKING` added to `25_catalog_registry.md`.
- Step 3: Applied — `CANCEL_BOOKING` row + Notes added to `28_permissions_matrix.md`.
- Step 4: Applied — manifest synced.

Verification: `npx supabase db reset` clean incl. `202607046700`; smoke-test → ALL CHECKS PASSED (71 tables). Grant check: `CANCEL_BOOKING` = {branch_manager, ceo, finance_manager, owner}. Behavioral (authenticated-caller sim, rolled back): `confirmed -> cancelled` (with reason) → cancelled + `booking_cancelled` warning; `in_progress -> cancelled` → cancelled; `issued -> void` → void + `booking_voided` warning; `void -> completed` → completed; cancel without reason → `cancellation requires a reason`; `confirmed -> cancelled` as senior_employee → `permission denied: CANCEL_BOOKING`.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently re-verified against live DB. `db reset` clean (202607046700 applied), smoke-test ALL CHECKS PASSED (71 tables). `CANCEL_BOOKING` granted to exactly the four finance-consequential roles. Behavioral matrix passed: all four new transitions produce the correct status, event, and severity; the uniform cancellation-reason guard fires; and `CANCEL_BOOKING` is required for post-approval cancellation. Canon 25/28 register the permission; 26/27 untouched. No new architectural decision (ADR-0020 governs).

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

Slice 4 of 5 (ADR-0020 booking capability set). Final slice next: Refund/Reissue (`issued -> refunded/reissue`, `reissue -> issued`, `refunded -> completed`), minting `REFUND_BOOKING`/`REISSUE_BOOKING` — after which the entire booking lifecycle (26) is implemented and the capability set is complete.
