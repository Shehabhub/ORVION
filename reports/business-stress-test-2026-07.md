# ORVION Business Architecture & Operational Stress Test (2026-07-09)

Status: Analysis only. NOT a Change Request. No implementation performed; no completed phase modified; Phase 8 not started.
Method: adversarial business simulation (agency owner / ops / finance / HR / reservations / airline / supplier / auditor / fraud / customer / malicious employee), live-schema evidence, current industry guidance (IATA BSP, TOMS/VAT, travel back-office). Disproof-first.

Classification per finding: **Defect / Enhancement / Future Capability / Deliberate Trade-off** + **Critical / High / Medium / Low / No Action**.

---

## Verdict on the hypothesis

> "ORVION can run a real travel company for many years without architectural redesign."

**Attempted disproof — the hypothesis SURVIVES at the architecture level, with qualification.** I searched specifically for a business gap that would force a *redesign* of the core aggregates, tenant model, event backbone, or RLS foundation. **I found none.** Every gap below is **additive** — new nullable columns, or new aggregates that hang off the existing `bookings`/`booking_items`/`customers`/`suppliers`/`events` backbone. The **service-agnostic Booking Core** (umrah/hajj/tour_package/transport/insurance/visa are all `service_type` values, not bespoke modules) is the decisive strength: it absorbs new travel verticals without structural change.

**However**, the stronger claim — "can run a real agency *today* without staff reverting to Excel/WhatsApp" — is **false for specific operations**, chiefly: recording **PNR/ticket numbers**, **group bookings**, **customer credit**, and **tax/VAT**. These are expected (the roadmap is at Phase 7; ticketing depth and later domains aren't all built), but they are the honest "business still touches Excel" findings. None require redesign; all are additive future work.

---

## Findings

### BF-1 — No PNR / ticket number / supplier confirmation on `booking_items` — **Defect · High**
- **Evidence:** `booking_items` has `service_type_code`, `sub_status_code`, `supplier_id`, cost/selling/commission — but **no** `record_locator` / `pnr` / `ticket_number` / `confirmation_number` column. Industry: the PNR + ticket number are the fundamental keys of airline ticketing (BSP reporting, reissue, refund, reconciliation all key on them).
- **Why / Business impact:** reservations/ticketing staff have nowhere to store the airline PNR, e-ticket number, or hotel/visa confirmation — they will keep them in Excel/WhatsApp, and cannot search or reconcile by PNR. This is the single most likely "forces Excel" gap for a ticketing agency.
- **Technical impact:** additive nullable columns on `booking_items` (or a small `booking_item_references` child for multiple refs); optional per-tenant uniqueness. No redesign.
- **Effort:** S. **Risk if ignored:** core ticketing lives outside the system; downstream refund/reissue/BSP flows lack the reference.
- **Modify existing phase?** No — additive migration (a new CR; does not edit a completed migration). **Belongs to:** a near-term additive capability, ideally **before real ticketing use** (i.e., ahead of or alongside Phase 8/9). Not merely recorded — recommend prioritizing.

### BF-2 — No group-booking entity (group, leader, rooming list, group fare) — **Future Capability · High**
- **Evidence:** `bookings` has a single `customer_id`; `booking_item_passengers` links passengers to items; there is no group / group-member / rooming concept.
- **Why / Business impact:** Hajj/Umrah/tour operators (named departments) sell groups of 20–500; running each as many individual bookings is unworkable — group pricing, rooming lists, and a group leader are core.
- **Technical impact:** additive new aggregate (`groups`, `group_members`) referencing `bookings`/`passengers`; the event/tenant backbone absorbs it. No redesign.
- **Effort:** L. **Risk:** group tourism runs in Excel. **Modify existing phase?** No. **Belongs to:** a future **Groups** capability (a Tourism/Packages phase). Recorded + prioritized when group tourism is activated.

### BF-3 — No customer credit limit / payment terms — **Enhancement · High**
- **Evidence:** `suppliers` have `credit_limit_amount` + `payment_term_code`; `customers` have **neither**. `app.customer_balance` shows exposure but there is no limit to check it against.
- **Why / Business impact:** B2B/corporate/credit customers buy on account with limits and terms; finance cannot enforce or monitor credit exposure, and the negative-balance issuance gate has no customer credit limit to reason about.
- **Technical impact:** additive columns on `customers` (+ optional check in the issuance gate, which already computes balance). No redesign.
- **Effort:** S–M. **Risk:** credit customers over-extend; uncontrolled receivables. **Modify existing phase?** No — additive. **Belongs to:** near-term additive CR when B2B/credit selling is activated.

### BF-4 — No tax / VAT modeling (TOMS / GCC VAT) — **Enhancement · High where VAT applies (else Future)**
- **Evidence:** no tax columns on `invoices`/`booking_items` anywhere. Industry: travel VAT is typically a **margin scheme** (UK/EU TOMS; KSA/GCC 15% VAT — directly relevant to Umrah/Hajj operators), legally required, and must be reconcilable.
- **Why / Business impact:** VAT-registered operators must compute/report VAT (often on margin) and issue tax-compliant invoices; absence is a compliance exposure and forces external tax spreadsheets.
- **Technical impact:** additive tax fields on invoices/items + tax config; margin-scheme computation is a finance-logic addition, not a redesign.
- **Effort:** M–L. **Risk:** compliance penalties, non-compliant invoices. **Modify existing phase?** No. **Belongs to:** Future Capability gated on the operating jurisdiction; promote to High/near-term if the first tenant is VAT-registered (likely for KSA).

### BF-5 — No HR / employees / payroll / staff-commission settlement — **Future Capability · Medium (High long-term)**
- **Evidence:** `users` is a tenant membership, not an HR employee record; no payroll, leave, or staff-commission payout. `booking_items.commission_rate` computes item commission but nothing settles it to the salesperson.
- **Why / Business impact:** HR/Payroll are named departments; sales incentives are central to travel sales motivation and cost accounting.
- **Technical impact:** a new HR domain (`employees`, `payroll_runs`, `commission_settlements`) referencing `users`/`booking_items`. Additive.
- **Effort:** L. **Risk:** HR/payroll stay in Excel (currently acceptable — out of roadmap). **Modify existing phase?** No. **Belongs to:** a future HR phase. Recorded.

### BF-6 — No treasury: cash/bank reconciliation, inter-account transfer, daily close, petty cash — **Future Capability · Medium**
- **Evidence:** `financial_accounts` + `payments` exist; no reconciliation, account-to-account transfer, or daily closing.
- **Why / Business impact:** finance/treasury reconcile bank & cash and close the day in Excel.
- **Technical impact:** additive treasury domain over `financial_accounts`. No redesign.
- **Effort:** M–L. **Belongs to:** future Treasury/Accounting-depth phase. Recorded.

### BF-7 — No supplier bills + BSP/IATA settlement reconciliation — **Future Capability · Medium (High for IATA agents)**
- **Evidence:** supplier payable is **derived** (no supplier-bill table — from the Engineering Audit); no BSP reconciliation. Industry: BSP reconciliation (matching airline debits/ADMs to bookings) is a core monthly workflow for IATA-accredited agents.
- **Why / Business impact:** matching airline/consolidator statements and supplier bills to bookings; dispute/ADM handling.
- **Technical impact:** a supplier-bill aggregate + reconciliation over the existing payment/booking data. Additive.
- **Effort:** L. **Risk:** finance reconciliation in Excel; airline penalties/ADM disputes untracked. **Belongs to:** future finance-depth phase, accreditation-dependent. Recorded.

### BF-8 — No chargeback / payment-dispute modeling — **Enhancement · Medium**
- **Evidence:** `payments`/`refunds` model normal flows; a **card chargeback** (disputed forced reversal) is distinct from a refund and is unmodeled.
- **Why / Business impact:** card disputes are common; they need a dispute state + a financial reversal path distinct from a voluntary refund, or accounting drifts.
- **Technical impact:** additive dispute status/entity linked to `payments`. **Effort:** M. **Belongs to:** Enhancement/Future finance-depth. Recorded.

### BF-9 — No blacklist / fraud / risk flags (customer & supplier) — **Enhancement · Medium**
- **Evidence:** no risk/blacklist/fraud flag on `customers` or `suppliers`.
- **Why / Business impact:** fraud investigators/customer service need to flag and block bad actors (repeat chargebackers, fraudulent bookings, defaulting agents).
- **Technical impact:** additive flag or a small risk-list entity + a check at booking/issue. **Effort:** S–M. **Risk:** repeat fraud with no control. **Belongs to:** Enhancement, near-term for risk control. Additive.

### BF-10 — No structured amendment / change-fee / fare-difference workflow — **Enhancement · Medium**
- **Evidence:** date change / airline reschedule generates change fees + fare differences + airline debit memos; today this would be ad-hoc new invoices with no structured link to the original ticket.
- **Why / Business impact:** reissues/changes are frequent; finance needs the original↔amendment link and the change-fee/ADM captured.
- **Technical impact:** additive amendment linkage or an invoice-adjustment type; leverages the existing reissue booking state. **Effort:** M. **Belongs to:** Enhancement/Future. Recorded.

### BF-11 — No customer account statement generation — **Future Capability · Medium (Phase 9)**
- **Evidence:** `customer_balance` is derived; there is no periodic statement.
- **Why / Business impact:** B2B/credit customers require monthly statements of invoices/payments/balance.
- **Technical impact:** a read/report over existing finance tables. **Effort:** S–M. **Belongs to:** Reporting (Phase 9). Recorded.

### BF-12 — No guide/vehicle resource scheduling — **Future Capability · Low–Medium**
- **Evidence:** guides/transport exist as `supplier_type` (freelancer/transport) but there is no resource availability/allocation/scheduling.
- **Why / Business impact:** operations assign guides/vehicles to trips/dates; done in Excel today.
- **Technical impact:** additive scheduling domain. **Effort:** M–L. **Belongs to:** future Operations phase. Recorded.

---

## Deliberate trade-offs (should remain unchanged)

- **Booking as the itinerary container** (multi-city/multi-airline via multiple `booking_items`) — correct; no separate itinerary/segment aggregate needed.
- **Derived balances / profit (not stored)** — strength; keep.
- **Service-agnostic Booking Core** (umrah/hajj/packages/transport/insurance/visa as `service_type`) — the reason the platform flexes across departments without redesign; keep.
- **No GDS/Amadeus/Sabre integration yet** — deliberately deferred (integration phase); BF-1 (PNR field) is the prerequisite data slot that makes a future GDS sync additive.
- **Derived supplier payable (no supplier-bill table) for MVP** — acceptable now; BF-7 upgrades it when BSP/statements are needed.

---

## Capabilities that ARE well-supported (no action; strengths)

- **Multi-currency** (`currencies`, `exchange_rates`, `exchange_rate_id` on items + allocations).
- **Sales vs operational ownership** on `booking_items` (supports reassignment + commission attribution).
- **B2B vs B2C** base (`customer_type` company/person) — credit is the gap (BF-3), not the distinction.
- **Partial/split payment** (`payment_allocations`; multiple payment rows across methods).
- **Refund lifecycle, finance-approval gate, negative-balance issuance flag** — already built and verified.
- **Every department can receive a dashboard** over the event backbone + read RPCs without redesign.
- **Future integrations & AI** (Google/Meta/WhatsApp/n8n/MCP) are consumers of the event/outcome model — no architectural blocker.

---

## Prioritized recommendation (for owner decision — NOT executed)

If any pre-Phase-8 business work is desired, the evidence ranks it:

1. **BF-1 PNR/ticket-number/confirmation storage** — Defect, cheap (S), highest operational payoff; unblocks real ticketing and future GDS/BSP work. *Strongest candidate for a small additive CR before Phase 8.*
2. **BF-3 customer credit limit/terms** — cheap (S–M), needed the moment B2B/credit selling starts; complements the existing issuance gate.
3. **BF-4 tax/VAT** — promote to near-term **iff** the launch tenant is VAT-registered (likely KSA/GCC).

BF-2 (groups), BF-5 (HR/payroll), BF-6 (treasury), BF-7 (BSP), BF-12 (scheduling) are genuine **future phases** — additive, not redesign — and should enter `future-backlog.md` with triggers. BF-8/BF-9/BF-10/BF-11 are enhancements at their natural finance/CRM/reporting intersections.

**No finding requires modifying a completed phase or an architectural redesign.** The architecture earns its confidence: it is business-extensible by addition.

*End of stress test. No implementation performed. Awaiting owner review.*
