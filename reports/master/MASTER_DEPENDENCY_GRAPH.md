# ORVION MASTER DEPENDENCY GRAPH

Status: **Permanent cumulative dependency map.** Never recreate; evolve. Resolves Depends-On / Blocks / Required-Before/After / Parallelizable / Migration-order for every finding. Cross-reference: `MASTER_GAP_REGISTER.md`, `MASTER_EXECUTION_PLAN.md`.

Last updated: 2026-07-11.

## Foundational chains (must respect order)

```
DC-16 (pgTAP)  ──required before──▶  all built-table retrofits (R1..R8, DC-1/R7, DC-13)
                                     [no regression net → do not refactor built RPCs without it]

DC-1/R7 (money scale) ──required before──▶ INV-1..4 (derived primitives) ──▶ Batch-4 finance depth
                                            [primitives must not derive from truncated inputs]

CDD-1 Party ──required before──▶ R6 (party_id), N5 consent, DC-4 erasure, DC-14 offboarding,
                                  BF-5 HR, BF-9 fraud, CDD-10 comms identity, DC-12 relationships*

CDD-5 Accounting (dimensions/periods/posting) ──required before──▶ R2 dims, DC-10 opening balances,
                                  DC-11 realized FX, BF-6 treasury, BF-7 AP bills, BF-10 amendments,
                                  BF-4 tax posting

CDD-7 Integration+outbox ──required before──▶ Batch-3 Phase 8, Batch-5 Meta/WhatsApp/n8n, DC-14 export
CDD-8/N1 event registry ──required before──▶ RI/AI consumers, reliable outbox delivery

R3 invoice_lines ──required before──▶ BF-4 tax (line tax), CDD-3 price-components, BF-11 statements
R4 booking_item product/refs ──required before──▶ CDD-2 product/inventory, BF-1 references, BF-10 reissue
```
\* DC-12 (passenger_relationships) depends on passengers (built), not on Party; grouped with BF-2.

## Parallelizable (no inter-dependency)
- Batch 0: DC-13 (UUIDv7) ∥ R7 (money) ∥ R8 (unique keys) ∥ R1 (events dims) — independent column/DDL changes; sequence only behind DC-16.
- Batch 1: DC-6 (read log) ∥ DC-8 (reconciliation) ∥ DC-9 (timezone) ∥ document_sequences ∥ i18n — independent.
- Batch 2: A1 ∥ A2 ∥ B2 ∥ B6 ∥ B1 (independent hardening); B5+DC-5 (grants+storage RLS) pair; DC-15 pairs with B5.

## Blocks / blocked-by (critical)
- **DC-16 blocks** the entire built-table retrofit set (safety precondition).
- **B5 (DML grants) blocked-by** A1+A2 (don't expose tables to clients before RLS is performant) and **blocks** all client/API work and Batch-3+ real usage; pairs with DC-5 storage RLS and DC-15 service_role bounding.
- **DC-1/R7 blocks** correct finance reporting/statements (BF-11) and RI finance metrics.
- **N1 event registry blocks** trustworthy RI/AI/outbox (DC-8, Batch-3/5 integrations).

## Migration ordering rule
Built-table structural changes (R1–R7, DC-13) land as **new additive migrations that `CREATE OR REPLACE`/`ALTER`** — never edit a completed migration file (ADR-0009 linear history). Each such migration is preceded in the same batch by its pgTAP test (DC-16).
