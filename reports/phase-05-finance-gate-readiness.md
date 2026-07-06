# Phase 5 — Finance Gate Readiness Report

Date: 2026-07-07
Author: Claude (Tier 1), owner-requested architectural checkpoint
Status: For owner review. **No Finance Gate code written; awaiting explicit approval.**
Method: evidence-based review of migrations, catalogs, events, RPCs, and canon — written to find problems, not to confirm the design.

---

## 1. Current implementation status

**Phase 5 completed (SPEC-073…080), all verified E2E on fresh `db reset`, smoke-test green:**
create_booking (073, consumes the `lead_booking_readiness` handoff contract) · currencies reference seed (074) · create_booking_item (075) · create_passenger (076) · passenger linkage (077) · booking-item lifecycle transitions (078) · booking-level transitions pre-finance slice (079) · internal supplier linkage (080).

**Remaining before Finance:** the Finance Approval Gate itself, plus the finance-entangled booking transitions deferred from SPEC-079 (`confirmed`/`in_progress`/`issued`/`void`/`refunded`/`reissue`/`completed`).

**Optional micro-capabilities (not blockers):** booking-item sub-status-only change (`booking_item_sub_status_changed`) and `pending→draft` return-for-correction. **Recommendation: do NOT complete these first** — they are independent of the gate and would only delay it. Fold them in opportunistically later.

---

## 2. Architectural readiness

**Booking Core naturally supports the gate — no Booking Core rework required.** Evidence:
- `approval_requests` exists with `approval_type_code` (incl. `finance_execution_approval`), `approval_status_code` (`pending/approved/rejected/cancelled`), `booking_item_id`, `requested_by`, `reviewed_by`, `reviewed_at`, and is indexed on `(tenant, status)` and `booking_item_id`.
- `booking_items` already carries `finance_approval_required`, `finance_approval_status_code`, `cost_locked_at`, `issued_at` — the exact fields a gate needs.
- The execution edge (`confirmed → in_progress`) and issuance are **already marked integration points** in `advance_booking_item` / `advance_booking` (no rework — the gate adds a precondition additively).
- `APPROVE_FINANCE` (owner/ceo/finance_manager) and `ALLOW_ISSUE_WITH_NEGATIVE_BALANCE` are seeded; the `record_event` + `notifications` (`finance_approval_result`) seams exist.

**One scoping reality (not a defect):** the gate splits cleanly into two parts with different readiness — see §3, item A.

---

## 3. Missing / at-risk business concepts

**A. Negative-balance risk flag depends on a balance function that doesn't exist yet (most important finding).**
`13` requires that issuing before full collection creates a risk flag recording *customer balance*. There is **no `customer_balances` table** (by design — balance is derivable: `invoices`/`payments`/`refunds` all carry `customer_id` + `booking_id` + `amount`), and **no balance function** is implemented, and **no finance transaction RPCs** exist yet. There is also **no `risk_flags` table** — per `28` the risk flag is an **event** (`creates risk flag event`), which is fine. **Consequence:** the *execution-approval* gate is fully buildable now; the *issue-before-payment negative-balance risk flag* needs a customer-balance primitive that belongs to Finance Core. → The gate should be **scoped**: build execution approval now; defer the negative-balance risk flag (or emit it with an explicit "balance not yet computed" until the ledger exists).

**B. Quotations are entirely unimplemented (integration gap).** The `quotations`/`quotation_items` tables, a full Quotation state machine (`26`), and quotation events all exist, and `bookings.quotation_id` is a ready FK — but there are **no quotation RPCs**, `bookings.quotation_id` is **never set**, and `advance_lead` sets the lead status `quotation_sent` **without creating a `quotations` row**. So "quotation" is currently a lead flag with no entity behind it. Not a finance-gate blocker, but a genuine missing capability between CRM and Booking. **Recorded.**

**C. Finance events not yet emitted (expected).** `26` Finance Approval State Machine requires `finance_approval_requested/approved/rejected/cancelled/resubmitted`; none exist yet — they are the gate's job. `notification_type` includes `finance_approval_result` (ready).

**D. `finance_approval_status_code` has no catalog validation.** It's plain text (SPEC-030). The gate should validate it against `approval_status_code` values (`pending/approved/rejected/cancelled`) for consistency.

**E. Reference data for money is thin.** `currencies` seeded (074), but `exchange_rates` is **empty** and `booking_items.exchange_rate_id` is nullable. Multi-currency cost/profit and `exchange_rate_adjustments` need `SET_EXCHANGE_RATE` + seeded/entered rates — a **Finance Core** dependency, not a gate blocker.

**F. Permissions:** the execution gate maps to `APPROVE_FINANCE`; `28`'s note confirms `REVIEW_APPROVAL_REQUEST` covers the *other* approval types (refund/discount/override/etc.). The capability-driven **booking** permission set (Submit/Approve/Issue/Cancel/Refund/Reissue) is still to be minted — planned for this ADR (memory `booking-transition-authority-model`). No RLS/index gaps found for the gate (`approval_requests` is indexed; all finance tables are `tenant_id`-scoped → generic `tenant_isolation`).

---

## 4. Missing integrations between existing capabilities

- **Quotation ↔ lead ↔ booking:** the strongest disconnect (see §3B) — `advance_lead('quotation_sent')` and `bookings.quotation_id` never meet.
- **Booking ↔ lead:** connected correctly (`bookings.lead_id` set by `create_booking`; `booking_created` payload carries `lead_id`). No reverse pointer needed.
- **`finance_approval_required` is set at item creation but never consumed** — nothing currently reads it. The gate closes this loop (it becomes the precondition trigger).
- **Item cost/selling + passenger overrides are stored but never rolled up** — no item/booking total. Belongs to Finance Core (profit-per-item, outstanding balance). Recorded.
- **28 Event Requirements retrofit still pending** (`lead_created`, security events) — a standing deferral, unaffected by the gate.

---

## 5. Future compatibility review

Booking Core is **service-agnostic and future-compatible** (memory `booking-orchestration-boundary`): items carry `service_type_code` + service sub-status with no per-type tables (`13`), and the header/transition layer encodes no service specifics. Flight Ticketing (PNR, segments, fare class, ticket number, baggage, seats), Hotels, Visa, Transport, Cruises/Nile Cruises, Tours, Umrah/Hajj, Insurance, Car Rental all plug in later via booking-item detail + events. **One caution to preserve:** keep the Finance Gate keyed to the **generic booking item** (cost/selling/approval/currency), never to a service type — otherwise it would leak service assumptions into Finance. No change needed now; just hold the line during the gate build.

---

## 6. Canonical consistency review

Aligned, no material drift found:
- **ADR-0014** (Supabase-native): all logic in `app` RPCs on the frozen schema; zero schema changes in Phase 5.
- **ADR-0015** (binary RBAC, point-of-use scope): authorization via `app.authorize`; capability-driven booking perms will extend this cleanly.
- **ADR-0018** (background processing) & **event philosophy**: single `record_event` seam; state transitions emit canonical events.
- **Orchestration boundary** & **Earn-It**: honored (currencies seeded only when hard-blocked; no generic engine; finance behavior deferred).
- **Identity/RLS**: `SECURITY INVOKER` + `tenant_isolation` throughout; `SECURITY DEFINER` only where completeness demands (merge, SLA) with explicit authz.
- **Naming**: `advance_*` transition RPCs, `create_*`, `link_*` — consistent.
Minor drift watch: `finance_approval_status_code` (unvalidated plain text, §3D) and the quotation gap (§3B) — both recorded, neither a violation.

---

## 7. Opportunities discovered (proposals only)

1. **Introduce a read-only `app.customer_balance(customer_id[, booking_id])`** as the first Finance Core primitive — it cleanly unlocks the negative-balance risk flag and outstanding-balance reporting, and keeps balance derived (no stored-balance drift). Earned exactly when the risk flag is.
2. **Model the risk flag as a first-class event type** (`booking_item_issued_with_negative_balance` or similar) with a structured payload (user/time/item/balance/reason/approval source) — matches `28` and the event philosophy; no table needed.
3. **A thin `finance_approval_result` notification helper** reused by approve/reject — avoids duplicating notification logic across finance RPCs.
4. **Record the Quotation capability as a planned slice** (CRM/Booking bridge) so `quotation_sent` gains a real entity and `bookings.quotation_id` gets populated.
5. **Validate `finance_approval_status_code` against `approval_status_code`** when the gate writes it (cheap consistency win).

---

## 8. Finance Gate readiness verdict

**READY TO BEGIN — with one scoping decision (execution-approval now; negative-balance risk flag deferred).**

Booking Core requires no rework: the approval schema, item finance fields, marked integration points, permissions, events, and notifications all exist. The only genuine constraint is that the *negative-balance risk flag* depends on a customer-balance primitive that belongs to Finance Core (§3A). Everything else (execution-approval gate + the finance-gated booking/item transitions + capability permissions + finance events) is buildable now against the current schema. The quotation gap (§3B) and event-retrofit (§4) are real but independent and should not block the gate.

---

## 9. Execution recommendation

If approved, I intend to build the Finance Gate as **ADR-000X (first Phase-5 ADR)** in this order:
1. **ADR** — record the gate design: execution-approval via `approval_requests(finance_execution_approval)` + `APPROVE_FINANCE`; the capability-driven booking permission set (Submit/Approve/Issue/Cancel/Refund/Reissue) with role mappings; and the explicit deferral of the negative-balance risk flag to Finance Core (`customer_balance` primitive).
2. **Request approval** — `app.request_finance_approval(booking_item)`: sets `finance_approval_required`, opens a `pending` `approval_requests` row, emits `finance_approval_requested`, notifies finance.
3. **Approve/Reject** — `app.review_finance_approval(...)` under `APPROVE_FINANCE`: sets item `finance_approval_status_code` + `cost_locked_at` on approve, emits `finance_approval_approved`/`rejected`, notifies the requester (`finance_approval_result`).
4. **Gate the execution edge** — add the precondition to `confirmed → in_progress` (and issuance) at the already-marked integration point: block unless an approved finance approval exists. This is the additive change; no rework.
5. **Finance-gated booking transitions + capability permissions** — introduce `pending_approval → confirmed`, execution, issuance, void/refund/reissue with their new permissions.
6. **Defer** the negative-balance risk flag until Finance Core provides `customer_balance` (proposal §7.1); at that point emit the risk-flag event (proposal §7.2).

**Sequence rationale:** approval primitives first (they're self-contained and testable), then wire the gate at the marked seam, then extend the transitions that depend on it. This keeps each step independently verifiable and touches Booking Core only additively. **Risk watched:** scope creep from finance transactions (invoices/payments) into the gate — I will hold the gate to *approval + execution-blocking only*, leaving ledger/balance to Finance Core.

**I will not begin implementation until you review and explicitly approve this report.**
