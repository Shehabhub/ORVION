# ORVION VALIDATED ARCHITECTURE DECISIONS

Status: **Permanent record of findings that PASSED the 9-stage evidence pipeline** (Discovery → Evidence → External validation → Counter-proof → Owner impact → Classification → Confidence → Priority → Decision). Only findings here are accepted architectural gaps in `MASTER_GAP_REGISTER.md`. Never delete; a later review may move an item to PENDING/REJECTED with reasoning.

Last updated: 2026-07-11 (session 4 — Evidence Validation). Pipeline detail per item: `ARCHITECTURE_PROOF_LOG.md`. External sources: `INDUSTRY_REFERENCES.md`.

## A. Newly-validated (DC-series that survived counter-proof)
| ID | Class | Confidence | Counter-proof result (why it survived) | Priority driver |
|---|---|---|---|---|
| DC-1 money precision | REQUIRED | **100%** | Alternative (integer minor-units) exists but numeric(19,4) is simpler and standard; no serious multi-currency ERP stores scale-2 for 3-dp currencies. Schema self-declares `decimal_places=3`. | Correctness + foundation (modifies built money columns; cheapest pre-data) |
| DC-2 write idempotency | REQUIRED | 90% | Natural unique keys cover *some* cases (booking_reference) but not payments; Stripe-style idempotency is the standard for financial writes. | Correctness (duplicate money) |
| DC-3 concurrency control | REQUIRED | 95% | Solution is options, not dogma: `FOR UPDATE` **or** SERIALIZABLE isolation — the *need* (prevent oversell/lost-update) is inescapable. | Correctness (oversell) |
| DC-4 PII erasure boundary | REQUIRED | 90% | Legal-basis retention narrows scope; events already ID-based (erasure-safe). The mutable-PII boundary still needs design. | Compliance |
| DC-5 document storage RLS | REQUIRED | 90% | App-only enforcement is insufficient (defense-in-depth); bytes must mirror `financial_documents` visibility. | Security |
| DC-7 ticketing deadline | REQUIRED | 90% | A notes field can't drive reminders; IATA fare-hold expiry is structured + time-critical. | Ops ("back to WhatsApp") |
| DC-11 realized FX posting | REQUIRED* | 85% | *Where accrual + multi-currency; cash-basis SME could absorb it. Standard double-entry requires it. | Accounting correctness |
| DC-12 passenger mahram | REQUIRED | 85% | **Counter-proof improved the design:** a self-FK `passengers.mahram_passenger_id` beats a full relationship graph — simpler, sufficient for KSA mahram declaration. | KSA compliance |
| DC-15 service_role bounding | REQUIRED | 85% | Audit found no bypass, but unbounded service_role is the largest residual blast radius; explicit tenant assertion is cheap defense-in-depth. | Security |
| DC-16 pgTAP harness | REQUIRED (process) | 95% | Reclassified as an **engineering-process** requirement, not a schema gap — but a hard precondition for safely running the built-table retrofits. | Quality gate |
| DC-27 state-based (not event-sourced) ADR | REQUIRED (ADR) | 95% | Not a gap — a **missing explicit decision**; recording it prevents a class of misimplementation. Near-zero cost. | Clarity |
| DC-28 legacy bulk-import | REQUIRED | 80% | Distinct from DC-10 (records vs balances); onboarding a real agency's history needs a staging+dedup framework (reuses ADR-0019 merge). | Onboarding |
| DC-21 Hijri calendar | REQUIRED (presentation) | 85% | **Reclassified:** store Gregorian instant, **render** Hijri + season rules in app logic → near-zero schema impact. Real product requirement, minimal architecture weight. | Umrah/Hajj UX |

\* DC-11 conditional on accrual accounting.

## B. Inherited findings — validated by the prior corpus (multiply-reviewed)
Accepted as VALIDATED on the strength of their existing evidence trail across `engineering-audit`, `business-stress-test`, `architecture-synthesis`, `design-evolution-plan`, and schema verification. No counter-proof overturned them this session:
- **Built-table retrofits:** R1 (events dims), R2 (JE dims), R3 (invoice_lines), R4 (booking_items product/ref), R5 (attribution consent), R6 (party_id) — 90–95%.
- **Correctness/integrity:** R8/B3 unique keys, B2 CHECKs, INV-1..4 — 90–100%.
- **Scale/perf:** A1 (RLS init-plan), A2 (tenant indexes) — 95% (verified V2).
- **Access:** B5 DML grants — 95%.
- **Domains (design-complete):** CDD-1 party, CDD-5 accounting-depth, CDD-6 numbering, CDD-7 outbox, CDD-9 franchise, CDD-10 comms, CDD-11 i18n; BF-1 PNR, BF-2 groups, BF-4 tax, BF-5 HR, BF-6 treasury, BF-7 AP/BSP, BF-8 chargeback, BF-9 fraud, BF-10 amendment, BF-11 statements, BF-12 resources — 85–95%.
- **Contract/events:** N1 event registry, N5 consent — 90%.
- **Ops:** OPS-1 observability/DR — 85%.

## C. Net effect of validation
The "required-now" structural set **shrank** (DC-13 deferred; DC-6/8/10/20/22/24/25 downgraded — see `PENDING_ARCHITECTURE_FINDINGS.md`). This is the intended outcome: fewer, stronger, evidence-backed decisions. **Batch 0 structural touches are now: R1–R8 + DC-1 (money) only** — DC-13 removed. Everything else in Batch 0 is ADRs + the DC-16 test net.
