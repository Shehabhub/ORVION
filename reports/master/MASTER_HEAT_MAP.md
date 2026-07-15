# ORVION MASTER HEAT MAP

Status: **Permanent architectural-importance ranking.** Never recreate; evolve. Ranks domains/concerns by how foundational they are — how much of the platform breaks or must be reopened if they are wrong. This is the engineering priority map (distinct from severity: a ★★★★★ domain that is 98% done still outranks a ★★☆ domain that is 40% done for *architectural attention*). Cross-reference: `MASTER_COVERAGE_SCORE.md`, `MASTER_EXECUTION_PLAN.md`.

Last updated: 2026-07-11. ★ = architectural criticality (blast radius if wrong), not completeness.

## ★★★★★ Critical Core (a defect here reopens the foundation)
| Domain / concern | Why critical | Completion | Priority action |
|---|---|---|---|
| Tenant isolation / RLS | every table depends on it; a leak is fatal | 98% | A1/A2 (perf), keep single primitive |
| Event backbone + contract | RI/AI/integrations/audit all consume it | 88% | R1 cols + N1 registry (Batch 0/1) |
| Money / Finance correctness | wrong numbers destroy trust; cross-cutting | 82% | **DC-1 money-scale now** + INV-1..4 |
| Party / counterparty identity | customers/suppliers/sub-agents/employees hang off it | 88% | CDD-1 party (Batch 1) |
| Accounting foundation (GL/dimensions/posting) | every finance event posts through it | 82% | CDD-5 (Batch 4) — design locked now |
| Identity keys / PK strategy | painful to change after data | 96% | DC-13 UUIDv7 (DEFERRED → PG18 trigger; not Batch 0) |
| Test assurance | the net that makes retrofits safe | 60% | DC-16 pgTAP (Batch 0, first) |

## ★★★★☆ High (broad reach; additive but pervasive)
Integration layer + outbox (CDD-7) · Booking/Reservations core + product linkage (R4/CDD-2) · Concurrency discipline (DC-2/DC-3) · Documents + storage (DC-5) · Subscription/entitlement two-plane · Privacy/erasure boundary (DC-4) · Franchise/tenant-hierarchy (CDD-9).

## ★★★☆☆ Medium (important domains, self-contained additive)
Tax/VAT (BF-4) · Pricing/price-components (CDD-3) · Engagement/comms + templates/consent (CDD-10/N5) · Treasury (BF-6) · AP supplier-bills/BSP (BF-7) · Opening balances (DC-10) · Reporting read-model layer (RC-4) · Observability/DR (OPS-1) · Reference-data integrity (B1) · service_role bounding (DC-15).

## ★★☆☆☆ Lower (valuable, clearly independent)
HR/Payroll (BF-5) · Procurement · Fleet/Resources (BF-12) · Groups + passenger relationships (BF-2/DC-12) · Amendment/chargeback (BF-10/BF-8) · Fraud/blacklist (BF-9) · Realized FX (DC-11) · Statements (BF-11) · Realtime (DC-17) · Localization build-out (CDD-11) · Timezone (DC-9).

## ★☆☆☆☆ Peripheral (niche/optional modules)
Asset depreciation (FOE-4) · Insurance claims (FOE-5) · Workflow engine overlay (FOE-6) · Loyalty (FOE-8) · pgvector/semantic AI (DC-18) · pg_trgm fuzzy (B7) · partitioning (B8).

## Reading the map
- **Attention now** = ★★★★★ items with completion <90% → **Money correctness (DC-1)**, Event contract, Accounting, Test assurance, PK strategy. These are the Batch-0 spine.
- **Excluded (off-map):** Warehouse/MRP, Retail POS (proven not part of a Travel ERP).
- Importance × completion-gap yields the same conclusion as the risk register: **Batch 0 (foundation-lock) is the highest-leverage work.**
