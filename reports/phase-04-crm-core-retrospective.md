# Phase 4 (CRM Core) — Transition Retrospective

Date: 2026-07-06
Status: Phase 4 complete; Phase 5 (Booking Core) not yet started.
Scope: one-time phase-END retrospective (3 questions) per the workflow-cadence policy. Evidence-based; not a re-review of each CR (each was verified + independently confirmed at Complete).

---

## What was delivered

Phase 4's seven roadmap outputs (`32_execution_roadmap.md`), each a CR verified E2E on a fresh `db reset` with the foundation smoke-test green:

| Roadmap output | CR | Surface |
| --- | --- | --- |
| Lead intake | SPEC-064 | `app.create_lead` (→ `new`) |
| Round-robin assignment | SPEC-065 | `app.assign_lead` / `assign_lead_round_robin` + reusable `app.record_event` seam |
| Lead SLA escalation | SPEC-067 | `app.process_lead_sla` (pg_cron) + **ADR-0018** |
| Customer identity matching | SPEC-069, SPEC-070 | `create_customer` + `find_customer_duplicates`; `merge_customer_identity` + **ADR-0019** |
| Lead closure | SPEC-068 | `app.advance_lead` (pipeline progression + closures) |
| Lead-to-customer link | SPEC-071 | `app.convert_lead` (`won → converted`) |
| Lead-to-booking preparation | SPEC-072 | `app.lead_booking_readiness` (Phase 4→5 handoff contract) |

The lead state machine (`26`) is fully realized: `new → assigned → contacted → qualified → quotation_sent → negotiation → won → converted`, plus `lost/spam/duplicate` closures and SLA-driven reassignment. Two ADRs (0018 background processing, 0019 customer-merge participation) were earned and recorded.

---

## Q1 — Does the delivered capability cohere end-to-end, and does it match canon?

Yes. A lead flows intake → route → respond → qualify/quote/negotiate → win → convert → booking-ready as one connected pipeline, each transition emitting its mandated event through the single `record_event` seam. The customer sub-domain (create → detect duplicates → merge) is complete and feeds conversion. The Phase 4↔5 boundary is an explicit, tested contract (`lead_booking_readiness`) rather than an implicit assumption. No canonical contradictions surfaced; the state-machine and permission-matrix rules were followed as written.

## Q2 — What did we learn / what drift or debt emerged?

- **Authorization patterns settled into two reusable shapes**: `authorize(PERMISSION)` (permission + MFA composed) for privileged actions, and "assigned-handler OR ASSIGN_LEAD + mfa_satisfied" for handler-owned progression. Applied consistently across `advance_lead`, `record_lead_interaction`, `convert_lead`.
- **DEFINER vs INVOKER is now a deliberate choice**: system/complete-coverage operations (`process_lead_sla`, `merge_customer_identity`) are `SECURITY DEFINER` with explicit authorization + tenant checks; everything else is `INVOKER` behind RLS. Documented in ADR-0018/0019.
- **Dynamic catalog-driven logic earned its place** (ADR-0019 merge) — the ~14 FK referrers of `customers` made a static list a real hazard; this is the template for future whole-entity operations.
- **Debt / deferrals (all recorded, none silently dropped)**: terminal-state reopening (`lead_reopened`); manual `REASSIGN_LEAD`; external notification delivery (Edge/n8n); merge value-level conflict resolution; the `28` Event-Requirements retrofit at each trigger; active-tenant selection (ADR-0011). No new schema debt — Phase 4 added zero table/schema changes (all logic in `app` RPCs on the frozen schema).

## Q3 — What should change before / at Phase 5 (Booking Core)?

- **Consume, don't re-derive**: Phase 5 booking creation must build on `lead_booking_readiness` (set `bookings.lead_id` + `customer_id` from its payload), keeping booking-eligibility in one place.
- **Reuse the seams**: `record_event` for every booking transition (`26` Booking State Machine), the two authorization shapes, and the DEFINER/INVOKER discipline.
- **Watch for the first earned booking-side ADR**: the finance-approval gate (`13`) and negative-balance issuance risk flag are likely the first Phase-5 decisions that need recording.
- **Reference-data reminder**: `currencies` remains empty (provisioning passes null currency). Bookings/finance will likely be the point where the reference-data layer is finally earned — evaluate at Phase 5/6 boundary, per the backlog.

---

## Verdict

Phase 4 (CRM Core) is coherent, canon-aligned, and releasable. Recommend proceeding to Phase 5 (Booking Core) capability-by-capability under the same CR discipline, starting from the `lead_booking_readiness` contract.
