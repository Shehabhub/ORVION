# Change Request — SPEC-094

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

[ ] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Implement the booking-level Progress transitions `confirmed -> in_progress` and `in_progress -> completed` in `app.advance_booking`, reusing the existing `CREATE_BOOKING` authority (no new permission).

---

## Business Reason

Slice 2 of the ADR-0020 booking capability set, continuing the lifecycle after Approve (SPEC-093). "Operations started" (`confirmed -> in_progress`) and non-ticket completion (`in_progress -> completed`) carry no distinct capability in the ADR-0020 model, so they are booking-operator workflow under `CREATE_BOOKING` — the same authority the pre-finance slice uses for submit/cancel. The item-level finance execution gate is unaffected: it lives on the booking *item*'s `confirmed -> in_progress` edge, not this header summary transition.

---

## Risks

Low. Additive, service-agnostic: two new allowed transitions, canonical events already mandated by 26 (`booking_in_progress`, `booking_completed`), no new permission, no canon change. `create or replace` of `advance_booking` changes only the transition table, the `completed_at` set, and the deferred-contract message; all other behaviour preserved byte-for-byte. Verified by clean `db reset`, smoke-test, and a behavioral walk `confirmed -> in_progress -> completed` plus the bad-state guard.

---

## Supersedes / Depends On

Depends on SPEC-093 (`202607046400_advance_booking_approve.sql`, the version being replaced). Extends ADR-0020. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607046500_advance_booking_progress.sql
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-094-booking-progress-transitions.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable, incl. `202607046400_advance_booking_approve.sql`); any completed `changes/SPEC-0*.md`; all `_ORVION_CANONICAL/**` except the manifest (no canon change: the transitions and events are already canonical in 26, and no permission is minted); AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`.

---

## Minimum Reading List

- supabase/migrations/202607046400_advance_booking_approve.sql (the function being replaced)
- _ORVION_CANONICAL/26_state_machines.md (Booking State Machine)

---

## Implementation Steps

1. Verify `202607046500_advance_booking_progress.sql` does not already exist. Add it: `create or replace function app.advance_booking(uuid, text, text)` adding rows `('confirmed','in_progress','booking_in_progress','CREATE_BOOKING')` and `('in_progress','completed','booking_completed','CREATE_BOOKING')` to the transition table; set `completed_at = now()` when `p_to_status = 'completed'`; remove `'in_progress'` and `'completed'` from the deferred-contract `in (...)` list (leaving `issued/void/refunded/reissue`). No permission mint, no canon change. `grant execute ... to authenticated`.
2. Sync `manifest.md`: `Current Module`, `Last Completed`, `Next capability` per `CR_LIFECYCLE.md §9`.

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607046500`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: an authorized caller walks a booking `confirmed -> in_progress` (emits `booking_in_progress`) then `in_progress -> completed` (emits `booking_completed`, sets `completed_at`).
- [x] Behavioral: `confirmed -> completed` (skipping in_progress) raises "transition not allowed"; `pending_approval -> confirmed` (Approve, SPEC-093) still works (regression).
- [x] No new permission; no canonical doc other than the manifest modified.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607046500_advance_booking_progress.sql` created (`create or replace app.advance_booking`, two new transitions, `completed_at` set).
- Step 2: Applied — manifest synced.

Verification: `npx supabase db reset` clean incl. `202607046500`; smoke-test → ALL CHECKS PASSED (71 tables). Behavioral (authenticated owner, rolled back): `confirmed -> in_progress` → `in_progress` + `booking_in_progress` event; `in_progress -> completed` → `completed`, `completed_at` set, `booking_completed` event; `confirmed -> completed` → `transition not allowed`; `pending_approval -> confirmed` regression → `confirmed`.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently re-verified against live DB. `db reset` clean (migration 202607046500 applied), smoke-test ALL CHECKS PASSED (71 tables). Behavioral walk confirmed both new transitions, their events, the `completed_at` timestamp, the bad-state guard, and the SPEC-093 Approve regression. Additive, no new permission, no canon change beyond the manifest; introduces no new architectural decision (ADR-0020 governs).

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

Slice 2 of 5 (ADR-0020 booking capability set). Next: Issue (`in_progress/reissue -> issued`, `issued -> completed`), minting `ISSUE_BOOKING` and landing the deferred negative-balance issuance risk flag (ADR-0020, now unblocked by `app.customer_balance()`) as a first-class event.
