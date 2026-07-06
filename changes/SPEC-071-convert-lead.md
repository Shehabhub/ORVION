# Change Request — SPEC-071

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

Phase 4 (CRM Core) — lead → customer conversion. `app.convert_lead(p_lead_id, p_customer_id, p_reason)` links a `won` lead to a customer (explicit, or the one linked at intake) and performs the terminal `won → converted` transition, preserving the lead as history and emitting `lead_converted`. Completes the lead state machine's normal flow.

---

## Business Reason

`12_lead_statuses_and_rules.md` (Lead-To-Customer rule): "A lead becomes a customer when the person is approved as an actual customer … The system must preserve the original lead and link it to the customer record." `26_state_machines.md`: `won → converted` ("Customer and/or booking created") with a `lead_converted` event. SPEC-068 deliberately excluded `converted` pending the customer capability (SPEC-069/070); this CR delivers it.

---

## Risks

Low. One `SECURITY INVOKER` RPC; RLS is the backstop. No table/schema change. Single responsibility — the customer must already exist (via `create_customer` or intake linking), so this RPC never creates a customer and needs no `CREATE_CUSTOMER` gate; it only links and transitions. Authorization mirrors lead progression (assigned handler OR `ASSIGN_LEAD` + MFA). Only a `won` lead converts; the lead is preserved (never deleted).

---

## Supersedes / Depends On

Depends On: SPEC-068 (`advance_lead` brings a lead to `won`; excluded `converted`), SPEC-069/070 (customer exists / is canonical), SPEC-065 (`record_event`). Unblocks: lead → booking prep (a converted lead's customer anchors bookings). Deferred (recorded): terminal-state reopening (`lost/spam/duplicate → assigned`, `lead_reopened`).

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607045000_convert_lead.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; RBAC/catalog seed data ; customer creation (stays in create_customer) ; booking creation ; terminal-state reopening

---

## Minimum Reading List

- _ORVION_CANONICAL/12_lead_statuses_and_rules.md (Lead-To-Customer, closure reasons) ; 26_state_machines.md (won→converted, lead_converted)
- supabase/migrations/202607044700_advance_lead.sql (progression guard, transition pattern) ; 202607044800_customer_identity.sql (create_customer)

---

## Implementation Steps

1. Create `supabase/migrations/202607045000_convert_lead.sql`: `app.convert_lead(p_lead_id, p_customer_id default null, p_reason default null)` — `SECURITY INVOKER`, `set search_path=''`. Load the lead in-tenant; require `lead_status_code = 'won'`; resolve the target customer as `coalesce(p_customer_id, leads.customer_id)` and require it (in-tenant). Guard: caller is the assigned handler OR holds `ASSIGN_LEAD`, plus `app.mfa_satisfied()`. Update the lead to `converted`, set `customer_id`, `closure_reason_code = 'converted_customer'`, `closed_at = now()`; emit `lead_converted` (prev `won`, new `converted`, payload `{customer_id}`) via `record_event`. Return the customer id. `grant execute … to authenticated`.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] A `won` lead with a linked customer converts: status `converted`, `customer_id` set, `closure_reason_code = 'converted_customer'`, `closed_at` set, one `lead_converted` event (prev `won`, new `converted`, payload carries the customer id); the lead row still exists (preserved).
- [x] Converting with an explicit `p_customer_id` links that customer; converting a lead with no linked customer and no argument is rejected.
- [x] A non-`won` lead is rejected (`… must be won`).
- [x] Conversion by a non-assigned caller lacking `ASSIGN_LEAD` is denied (42501).

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `app.convert_lead(...)` added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (Sara = senior_employee assigned handler; a won lead linked to customer C):
- `convert_lead(won_lead)` (no arg) → returns C; lead status `converted`, `customer_id = C`, `closure_reason_code = 'converted_customer'`, `closed_at` set; one `lead_converted` event (won→converted, payload `{customer_id: C}`); the lead still exists.
- A second won lead with no linked customer: `convert_lead` without an argument → rejected ("no customer to convert to"); with explicit `p_customer_id = C2` → converts and links C2.
- A `contacted` (non-won) lead → rejected ("must be won").
- Conversion by Bob (employee, not the handler, no ASSIGN_LEAD) → 42501.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: `convert_lead` realizes the Lead-To-Customer rule — the lead is linked to the customer and preserved (soft terminal, never deleted), and the `won → converted` transition emits `lead_converted` per `26`. Single-responsibility holds: the customer must pre-exist (composed with `create_customer`/intake), so no `CREATE_CUSTOMER` gate is needed and the signature stays lean; the transition authority mirrors progression (assigned handler OR `ASSIGN_LEAD` + MFA). Only a `won` lead converts; the target customer is required and tenant-verified. `converted_customer` is the official closure reason (`12`). `SECURITY INVOKER`; no schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Conversion links to a pre-existing customer by design — the two natural sources are `app.create_customer` (called first for a brand-new customer) and the customer linked on the lead at intake; keeping creation out of `convert_lead` avoids duplicating the customer parameter surface and lets duplicate detection / merge (SPEC-069/070) run before conversion. `converted` is terminal (`26`); it is recorded like a closure (`closed_at`, `closure_reason_code = 'converted_customer'`) but is a positive outcome, not a lost/spam/duplicate closure. The lead is never deleted — it remains part of the customer and booking history (`12`). Lead → booking prep (a converted lead's customer anchoring a booking, `13_booking_statuses_and_rules.md`) is the next capability. Terminal-state reopening (`lead_reopened`) remains a recorded deferred follow-up.
