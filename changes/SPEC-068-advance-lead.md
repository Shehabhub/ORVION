# Change Request — SPEC-068

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word anywhere in a Change Request.

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model
[ ] Tier 2 — Local execution agent (Qwen3.8B)

---

## Objective

Phase 4 (CRM Core) — lead pipeline progression and closure. A single table-driven RPC `app.advance_lead(p_lead_id, p_to_status, p_reason, p_closure_reason_code)` that validates the requested transition against the canonical Lead State Machine (`26_state_machines.md`), authorizes it, applies it, and emits the mandated per-transition event via `app.record_event`. Covers the forward pipeline (`contacted → qualified → quotation_sent → negotiation → won`, plus `qualified → won`, `quotation_sent → won`) and closures (`→ lost`, `→ spam`, `→ duplicate`). `won → converted` (requires the customer link) and terminal-state reopening are out of scope (deferred).

---

## Business Reason

`26_state_machines.md` / `12_lead_statuses_and_rules.md`: after intake (`new`), assignment (`assigned`), and first contact (`contacted`), a lead must be moved through the qualification/quotation/negotiation/win pipeline, or closed with a recorded closure reason (`lost`/`spam`/`duplicate`). Only allowed transitions may occur, each must record actor/previous/new/reason and create its required event, and closures must record a controlled `lead_closure_reason`. Assignment/intake RPCs (SPEC-064/065/066) delivered `new → assigned → contacted`; this CR delivers the remainder of the lead-owned pipeline.

---

## Risks

Low. One `SECURITY INVOKER` RPC; RLS remains the backstop. No table/schema change. The allowed-transition set is encoded directly from the canonical table, so illegal jumps are rejected. Two authorization paths mirror existing patterns: progression = the assigned handler OR `ASSIGN_LEAD` + MFA (as in `record_lead_interaction`); closure = `CLOSE_LEAD` via `app.authorize` (per `28_permissions_matrix.md`, "CLOSE_LEAD … Assigned only"). Closures require a validated `lead_closure_reason` and set `closed_at`.

---

## Supersedes / Depends On

Depends On: `SPEC-065` (`record_event`), `SPEC-066` (`contacted` guard pattern), catalog seed (`lead_status`, `lead_closure_reason`), RBAC seed (`CLOSE_LEAD`, `ASSIGN_LEAD`). Deferred follow-ups: `won → converted` (customer link capability), terminal-state reopening (`lost/spam/duplicate → assigned`).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607044700_advance_lead.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; RBAC seed data ; catalog seed data ; won→converted / customer creation ; terminal-state reopening ; manual reassignment (REASSIGN_LEAD)

---

## Minimum Reading List

- _ORVION_CANONICAL/26_state_machines.md (Lead State Machine — Allowed Transitions, Required Events)
- _ORVION_CANONICAL/12_lead_statuses_and_rules.md (closure reasons) ; 28_permissions_matrix.md (CLOSE_LEAD)
- supabase/migrations/202607044500_record_lead_interaction.sql (guard pattern) ; 202607044400_round_robin_lead_assignment.sql (record_event)

---

## Implementation Steps

1. Create `supabase/migrations/202607044700_advance_lead.sql`: `app.advance_lead(p_lead_id uuid, p_to_status text, p_reason text default null, p_closure_reason_code text default null)` — `SECURITY INVOKER`, `set search_path=''`. Resolve tenant + actor; load the lead (status, assigned_user_id) scoped to the tenant. Look up `(from_status, p_to_status)` in the encoded canonical transition table → mapped `event_type_code` + `is_closure`; reject if not present. If closure: `app.authorize('CLOSE_LEAD')`, require + validate `p_closure_reason_code` against `lead_closure_reason`, set `closure_reason_code` + `closed_at`. If progression: require caller is the assigned handler OR holds `ASSIGN_LEAD`, plus `app.mfa_satisfied()`. Update `lead_status_code` (+ closure columns) + `updated_at`; emit the mapped event via `app.record_event(prev, new, reason, payload)`. `grant execute … to authenticated`.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] Forward pipeline works: `contacted → qualified` (lead_qualified), `qualified → quotation_sent` (lead_quotation_sent), `quotation_sent → negotiation` (lead_negotiation_started), `negotiation → won` (lead_won); each records exactly one mapped event with correct previous/new state.
- [x] An illegal transition (e.g. `contacted → won`, `qualified → negotiation`, `won → converted`) is rejected.
- [x] Closure `→ lost` requires a valid `lead_closure_reason`, sets `closure_reason_code` + `closed_at`, emits `lead_lost`, and is denied to a caller lacking `CLOSE_LEAD`.
- [x] A progression by a non-assigned caller lacking `ASSIGN_LEAD` is denied (42501).

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `app.advance_lead(...)` added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (lead progressed by its assigned handler Sara; closure by a CLOSE_LEAD holder):
- `contacted → qualified → quotation_sent → negotiation → won`: each transition applied; four events (lead_qualified, lead_quotation_sent, lead_negotiation_started, lead_won) with correct prev/new; final status `won`.
- Illegal `contacted → won` and `won → converted` rejected ("transition not allowed").
- `qualified → lost` with `no_response`: status `lost`, `closure_reason_code='no_response'`, `closed_at` set, one `lead_lost` event.
- `→ lost` with a bogus closure reason rejected; `→ lost` without a closure reason rejected.
- Progression attempted by a non-assigned employee lacking `ASSIGN_LEAD` → 42501; closure attempted by an employee lacking `CLOSE_LEAD` → 42501.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Transitions are driven directly from the canonical `26` table, so only allowed edges succeed and each emits its mandated event with actor/previous/new/reason (`record_event` seam reused). The two authorization paths match established canon — closure via `CLOSE_LEAD` (`app.authorize`, MFA composes), progression via assigned-handler-or-`ASSIGN_LEAD` + explicit `mfa_satisfied` (mirrors `record_lead_interaction`). Closures validate the `lead_closure_reason` catalog and stamp `closed_at`. `won → converted` and reopening are correctly deferred (they need the customer link / a reopen policy). `SECURITY INVOKER`; no schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

`advance_lead` covers only the lead-owned pipeline. `won → converted` is deferred to the customer-link capability (it must create/link a `customers` row, per `12`'s Lead-To-Customer rule) — attempting it here is rejected as not-allowed. Terminal-state reopening (`lost/spam/duplicate → assigned`, "reopened by authorized user") is a separate deferred follow-up because it must also re-establish a current assignment. `new → spam` / `new → duplicate` classification and `assigned → duplicate` are included as closures; `assigned → contacted` stays in `record_lead_interaction` (SPEC-066). Progression transitions also satisfy `26`'s "lead status changed by authorized user" qualifying-interaction clause implicitly, since a progressed lead is no longer in the `assigned` SLA scan.
