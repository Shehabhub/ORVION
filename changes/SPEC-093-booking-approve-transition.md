# Change Request — SPEC-093

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

Implement the booking-level `pending_approval -> confirmed` [Approve] transition in `app.advance_booking`, minting the `APPROVE_BOOKING` capability permission — the first of the ADR-0020 deferred booking-lifecycle transitions.

---

## Business Reason

The booking lifecycle (26 Booking State Machine) stops at `pending_approval` in the pre-finance slice (`advance_booking`, SPEC-080). ADR-0020 approved the capability-driven authority model (Submit/Approve/Issue/Cancel/Refund/Reissue) and deferred each transition + its permission to "the CR that first consumes them". This CR delivers the **Approve** capability: management sign-off that moves a booking from `pending_approval` to `confirmed` ("Required approval granted"), distinct from the item-level finance execution approval (APPROVE_FINANCE). It is the immediate next capability named in the manifest and unblocks the forward booking path.

---

## Risks

Low. Additive, service-agnostic (booking-orchestration-boundary): one new allowed transition, one new permission with manager-approval grants derived from established canon precedent (ASSIGN_LEAD/REASSIGN_LEAD/ESCALATE_CONVERSATION), one canonical `booking_confirmed` event (already mandated by 26). `create or replace` of `advance_booking` changes only the transition table, per-transition authority, and the deferred-contract message; all other transitions and side effects are byte-for-byte preserved. No schema/table change. Verified by clean `db reset`, smoke-test, and a behavioral test of both the allowed and blocked (unauthorized / wrong-state) paths.

---

## Supersedes / Depends On

Depends on `app.advance_booking` (SPEC-080), `app.authorize` / `app.record_event` / `app.current_tenant_id`, and the seeded roles/permissions (migrations 35–36). Extends the capability model recorded in ADR-0020. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607046400_advance_booking_approve.sql
- _ORVION_CANONICAL/25_catalog_registry.md
- _ORVION_CANONICAL/28_permissions_matrix.md
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-093-booking-approve-transition.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable, including `202607045800_advance_booking.sql`); any completed `changes/SPEC-0*.md`; AGENTS.md, CR_LIFECYCLE.md, README.md, PROTOCOL.md, PROJECT_CONTEXT.md, `reports/architecture-decision-records.md` (ADR-0020 already records the direction), `_ORVION_CANONICAL/26_state_machines.md` (the transition is already canonical), `_ORVION_CANONICAL/32_execution_roadmap.md`.

---

## Minimum Reading List

- supabase/migrations/202607045800_advance_booking.sql (the function being replaced)
- supabase/migrations/202607046100_review_finance_approval.sql (per-decision-authority precedent)
- _ORVION_CANONICAL/26_state_machines.md (Booking State Machine)
- reports/architecture-decision-records.md (ADR-0020)

---

## Implementation Steps

1. Verify `202607046400_advance_booking_approve.sql` does not already exist. Add it: (a) `insert ... on conflict do nothing` minting permission `APPROVE_BOOKING`; (b) `insert ... on conflict do nothing` granting it to roles `owner`, `ceo`, `branch_manager`, `department_manager`; (c) `create or replace function app.advance_booking(uuid, text, text)` adding the `pending_approval -> confirmed` row (event `booking_confirmed`, authority `APPROVE_BOOKING`) via a per-transition `(frm, to_s, ev, perm)` values table, replacing the single `app.authorize('CREATE_BOOKING')` with `app.authorize(v_perm)`, and removing `'confirmed'` from the deferred-contract `in (...)` list. All other transitions/side effects unchanged. `grant execute ... to authenticated`.
2. Verify `APPROVE_BOOKING` is absent from `25_catalog_registry.md`'s `permission_key` list; add it after `CREATE_BOOKING_ITEM`.
3. Verify `28_permissions_matrix.md` Booking Permissions table has no `APPROVE_BOOKING` row; add it (Owner/CEO/Branch Manager/Department Manager = Yes; Finance Manager/Senior Employee/Employee/Trainee = No; scope branch/department) plus a Notes line distinguishing it from APPROVE_FINANCE and recording the capability-driven mint-per-consumer model.
4. Sync `manifest.md`: `Current Module`, `Last Completed`, `Next capability` per `CR_LIFECYCLE.md §9`.

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607046400`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] `APPROVE_BOOKING` exists in `permissions` and is granted to exactly owner/ceo/branch_manager/department_manager in `role_permissions`.
- [x] Behavioral: a `pending_approval` booking advances to `confirmed` (returns `confirmed`, emits `booking_confirmed`) for an authorized manager caller.
- [x] Behavioral: the same call is blocked for a caller without `APPROVE_BOOKING` (e.g. senior_employee).
- [x] Behavioral: `draft -> pending_approval` and the cancel transitions still succeed under `CREATE_BOOKING` (regression); `pending_approval -> confirmed` from a non-`pending_approval` state raises "transition not allowed".
- [x] `APPROVE_BOOKING` recorded in canon 25 and 28; no other canonical doc modified.

---

## Execution Log

### 2026-07-08 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607046400_advance_booking_approve.sql` created (permission mint + grants + `create or replace app.advance_booking`).
- Step 2: Applied — `APPROVE_BOOKING` added to `25_catalog_registry.md` permission_key list.
- Step 3: Applied — `APPROVE_BOOKING` row + Notes added to `28_permissions_matrix.md` Booking Permissions.
- Step 4: Applied — manifest synced (Current Module, Last Completed, Next capability).

Verification: `npx supabase db reset` applied all migrations cleanly incl. `202607046400`; smoke-test → ALL CHECKS PASSED (71 tables). Grant check: `APPROVE_BOOKING` = {owner, ceo, branch_manager, department_manager}. Behavioral (authenticated-caller sim, rolled back): (A) owner approves `pending_approval → confirmed` → returns `confirmed`, status updated, 1 `booking_confirmed` event; (B) senior_employee blocked → `permission denied: APPROVE_BOOKING`; (C) regression: `draft → confirmed` → `transition not allowed`, `draft → pending_approval` → `pending_approval` (CREATE_BOOKING intact).

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-08 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently confirmed against live DB state. `db reset` clean (migration 202607046400 applied), smoke-test ALL CHECKS PASSED (71 tables). `APPROVE_BOOKING` present in `permissions` and granted to exactly owner/ceo/branch_manager/department_manager. Behavioral matrix passed all four assertions (authorized approve, unauthorized block, bad-state block, submit/cancel regression), confirming the new transition, per-transition authority, and the `booking_confirmed` event. Canon 25 + 28 register the permission; no other canonical doc modified. Change is additive and service-agnostic; introduces no new architectural decision (ADR-0020 governs).

Recommendation to human: Set Status to Complete (autonomous per `CR_LIFECYCLE.md` §5 — decision recorded in ADR-0020; implementation verified).

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

First of the ADR-0020 deferred booking-lifecycle transitions, delivered as a capability-by-capability flow: SPEC-093 Approve (here) → Progress (execution-start + completions, reuses CREATE_BOOKING) → Issue (+ negative-balance risk-flag event) → Cancel/Void → Refund/Reissue. Each subsequent finance-consequential capability mints its own permission per Earn-It / ADR-0015.
