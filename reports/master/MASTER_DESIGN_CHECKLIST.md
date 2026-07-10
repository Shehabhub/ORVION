# ORVION MASTER DESIGN CHECKLIST

Status: **Permanent cumulative design checklist.** Never recreate; evolve. A finding is checked only when its **design** is integrated into canon (implementation timing is separate — see `MASTER_EXECUTION_PLAN.md`). This is the certification gate list. Cross-reference: `MASTER_GAP_REGISTER.md`, `MASTER_CERTIFICATION_STATUS.md`.

Last updated: 2026-07-11. `[ ]` open · `[~]` design-ready (specified, not in canon) · `[x]` design in canon · `[✓]` implemented+verified.

## Batch 0 — Foundation-lock
- [ ] DC-16 pgTAP harness + invariant tests (RLS coverage V5, money-currency, append-only)
- [~] DC-1/R7 money precision → numeric(19,4) + per-currency rounding
- [~] DC-13 UUIDv7 — **DEFERRED (session 4)**: not Batch 0; trigger = PG18 upgrade / hot table >~2–5M rows / partitioning
- [~] R1 events + schema_version/correlation_id/causation_id
- [~] R2 journal_entry_lines dimension columns (hooks)
- [~] R3 invoices + invoice_lines + INV-1 roll-up
- [~] R4 booking_items product/reference links + DC-7 ticketing_deadline + BF-1 references
- [~] R5 attribution_clicks gbraid/wbraid/consent + leads.attribution_click_id
- [~] R6 customers/suppliers party_id + customer credit terms
- [~] R8/B3 business-key unique constraints
- [~] INV-1..4 derived-primitive invariants (amend ADR-0021)
- [~] DC-2 idempotency-keys substrate
- [~] DC-4 PII-erasure boundary decision
- [ ] Consolidated ADRs recorded (Party, Product, Pricing+Tax, Accounting-depth, Integration+outbox, Event-contract+registry, Engagement+consent, Subscription two-plane, Franchise-read-path, Localization)

## Batch 1 — Cross-cutting substrate
- [~] CDD-1 party + contact-identities + N5 single consent
- [~] CDD-5 accounting dimensions model (base)
- [~] CDD-6 document_sequences + next_document_number
- [~] N1 event_type registry (validate record_event; amend ADR-0006)
- [~] CDD-7 integration providers/outbox/webhook-inbox (selective, C2)
- [~] DC-3 concurrency discipline (documented invariant + locking)
- [~] DC-6 sensitive-read access log
- [~] DC-8 reconciliation sweepers
- [~] DC-9 branch timezone anchor
- [~] CDD-11 i18n translations (base)
- [~] N2 feature-flags + permission×feature composition rule
- [~] DC-4 erasure implementation

## Batch 2 — Pre-production hardening
- [ ] A1 RLS (select …) init-plan wrapping
- [ ] A2 18 tenant_id indexes
- [ ] B5 DML grants + anon read scope
- [~] DC-5 document storage + Storage RLS
- [ ] DC-15 service_role least-privilege + tenant assertions
- [ ] B2 remaining CHECK constraints
- [ ] B1 reference-data integrity (+airports)
- [ ] B6 status-column naming normalization
- [ ] OPS-1 structured logging/metrics/tracing + documented RPO/RTO

## Batch 3 — Phase 8 Offline Conversion
- [ ] Attribution capture at intake · attribution engine · conversion events · delivery+retry (Google Ads Data Manager + consent — owner decision open)

## Batch 4 — Finance depth
- [~] BF-4/CDD-4 tax/VAT · [~] R2/CDD-5 dimension posting · [~] BF-7 AP supplier_bills · [ ] DC-10 opening balances · [ ] DC-11 realized FX · [~] periods · [~] BF-6 treasury · [~] revaluation · [~] BF-10 amendments · [~] CDD-3 price-components

## Batch 5 — Operational domains
- [~] CDD-2 product/inventory · [ ] DC-12 passenger_relationships + BF-2 groups · [~] CDD-10/RC-2 engagement + DC-17 realtime · [~] BF-5 HR/payroll · [ ] procurement · [~] BF-12 fleet/resources · [~] CDD-9 franchise + DC-14 offboarding · [~] RC-1 subscription lifecycle · [ ] RC-4 reporting read-model layer (first views/matviews) + BF-11 statements · [~] CDD-11 localization build-out · [~] BF-8/9 fraud/chargeback · [ ] DC-18 pgvector · [~] FOE-4/5/6/8 (owner-scoped)

## Standing invariants (verify every review)
- [ ] Every table with `tenant_id` has RLS enabled (V5 test)
- [ ] Every money column scale ≥ max currency decimal_places
- [ ] Every append-only table has the immutability trigger
- [ ] No new "can be added later" language in any report
- [ ] Every new finding has all Master-register fields populated
