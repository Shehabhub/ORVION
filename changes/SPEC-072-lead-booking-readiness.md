# Change Request — SPEC-072

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

Phase 4 (CRM Core) — final capability: lead-to-booking preparation, realized as the **canonical Phase 4 → Phase 5 (Booking Core) handoff contract**. `app.lead_booking_readiness(p_lead_id)` returns, for a lead: whether it is booking-ready, a normalized reason (code + message) for why/why-not, and the normalized business context Booking Core will consume. Read-only — it creates no booking and changes no state. Completes Phase 4.

---

## Business Reason

`32_execution_roadmap.md`: Phase 4's final output is "Lead-to-booking preparation"; "Booking creation" is Phase 5. `12_lead_statuses_and_rules.md` (Lead-To-Booking rule): a booking may be created after lead creation / preliminary request / qualification / negotiation, must never delete the lead, and requires a customer (`bookings.customer_id` NOT NULL; `bookings.lead_id` links the origin). This CR encodes the eligibility rule once — explicitly (`04`: "an explicit rule, not inferred informally") — as the single authoritative boundary between the two phases, so Phase 5 never re-derives it.

---

## Risks

Minimal. One read-only `SECURITY INVOKER` function (RLS backstop); no writes, no booking rows, no schema change, no phase-5 logic. Returns nothing a caller's RLS cannot already see (raises if the lead is not in the caller's tenant).

---

## Supersedes / Depends On

Depends On: SPEC-064..071 (the lead lifecycle + customer link that populate the fields this contract normalizes). Consumed by: Phase 5 booking creation (`bookings.lead_id` / `customer_id`). Establishes the Phase 4↔5 handoff contract. **Completes Phase 4 (CRM Core).**

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607045100_lead_booking_readiness.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; RBAC/catalog seed data ; booking creation / any Phase 5 logic (no booking rows written) ; schema additions (no booking_request table)

---

## Minimum Reading List

- _ORVION_CANONICAL/32_execution_roadmap.md (Phase 4 vs Phase 5 boundary) ; 12_lead_statuses_and_rules.md (Lead-To-Booking rule, closure reasons) ; 04_lead_lifecycle.md (explicit-rule principle)
- supabase/migrations/202607042300_create_booking_core_tables.sql (bookings.lead_id / customer_id) ; 202607045000_convert_lead.sql

---

## Implementation Steps

1. Create `supabase/migrations/202607045100_lead_booking_readiness.sql`: `app.lead_booking_readiness(p_lead_id)` — `SECURITY INVOKER`, `stable`, `set search_path=''`, returns a single row `(lead_id, is_ready, reason_code, reason, customer_id, lead_status_code, requested_service_type_code, branch_id, department_id, assigned_user_id, expected_value, title)`. Load the lead in-tenant (raise if absent). Verdict: `lead_archived` → not ready; status in `lost/spam/duplicate` → `lead_closed_negative`; `customer_id is null` → `no_customer_linked`; else `ready`. Return the normalized handoff payload. `grant execute … to authenticated`.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] A converted (or otherwise open) lead with a linked customer returns `is_ready=true`, `reason_code='ready'`, and the normalized payload (customer, service type, branch/department, assigned user, expected value, title).
- [x] A lead with no linked customer returns `is_ready=false`, `reason_code='no_customer_linked'`.
- [x] A lead closed as lost/spam/duplicate returns `is_ready=false`, `reason_code='lead_closed_negative'`; an archived lead returns `reason_code='lead_archived'`.
- [x] The function is read-only (no booking row created, lead state unchanged); a lead outside the caller's tenant raises.

---

## Execution Log

### 2026-07-06 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `app.lead_booking_readiness(...)` added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (leads in several states, one converted+linked, one won-unlinked, one lost, one archived):
- Converted lead linked to customer C → `is_ready=true`, `reason_code='ready'`; payload carried customer C, requested_service_type, branch/department, assigned user, expected_value, title.
- Won lead with `customer_id` null → `is_ready=false`, `reason_code='no_customer_linked'`.
- Lost lead → `is_ready=false`, `reason_code='lead_closed_negative'` (message names the closing status); archived lead → `reason_code='lead_archived'`.
- No booking row exists after the calls and lead state is unchanged (read-only); a lead id from another tenant raises "lead is not in your tenant".

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-06 — Claude (independent review)

Verdict: Confirmed Complete

Findings: The contract encodes the `12` Lead-To-Booking eligibility rule in exactly one place, with a normalized `reason_code` vocabulary (`ready` / `no_customer_linked` / `lead_closed_negative` / `lead_archived`) and the business payload Booking Core consumes — so Phase 5 depends on this boundary rather than re-deriving eligibility. It is strictly read-only (`stable`, no writes), respects tenant isolation (RLS + explicit in-tenant load), and adds no schema. Correctly Phase-4-scoped: it prepares/《decides》readiness but never creates a booking. This is the last Phase 4 (CRM Core) output; Phase 4 is now complete.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Realized as the **canonical Phase 4 → Phase 5 handoff contract** (owner guidance): the single authoritative definition of booking-readiness, the reason, and the normalized consumption payload — Phase 4 owns *determining readiness and preparing business context*; Phase 5 owns *creating and managing bookings*. This keeps the phase boundary clean and prevents duplicated business rules. Deliberately not implemented: any booking write, a "preliminary booking request" record (would require inventing a frozen-schema table), or status-specific gating beyond the customer + non-negative-closure requirement (`12` permits booking across positive statuses; the customer is the authoritative anchor). With this, **Phase 4 (CRM Core) is complete** — a short phase-transition retrospective precedes any Phase 5 work.
