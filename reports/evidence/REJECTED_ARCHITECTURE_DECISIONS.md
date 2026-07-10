# ORVION REJECTED ARCHITECTURE DECISIONS

Status: **Permanent record of designs/sub-solutions that were considered and REJECTED, with reasoning.** A rejected decision is as valuable as an accepted one — it stops the idea being re-proposed. Never delete; if evidence later reverses a rejection, record the reversal (don't erase the original).

Last updated: 2026-07-11 (session 4 — Evidence Validation). These reject *specific design choices*, not the underlying needs (needs live in VALIDATED/PENDING).

| # | Rejected decision | Proposed in | Why rejected (evidence) | What replaces it |
|---|---|---|---|---|
| RJ-1 | **UUIDv7 PKs as a Batch-0 required-now change** | design-review/certification (this session's prior turns) | Benchmarks: UUIDv4 fine until millions of rows/table; native `uuidv7()` is PG18 (Supabase = PG17); ORVION pre-launch SME scale. Batch-0 urgency unjustified. | DC-13 → PENDING/DEFERRED with a concrete trigger (PG18 upgrade / hot table >~2–5M rows / partitioning). |
| RJ-2 | **Dedicated `opening_balance_batches` domain as required** | design-authority (DC-10) | `create_journal_entry` already supports opening entries; a dedicated domain is convenience, not structural necessity. | DC-10 → OPTIONAL; bulk onboarding folds into DC-28 legacy-import. |
| RJ-3 | **Full custom-field EAV framework, now, as required** | final-proof (DC-20) | ORVION is a vertical travel CRM, not a horizontal platform; opinionated fixed schema is a legitimate, simpler choice. EAV adds query complexity. | DC-20 → OPTIONAL; if adopted, jsonb-column + definitions registry (not EAV). |
| RJ-4 | **"Saudi PDPL data-localization" as the residency driver** | final-proof (DC-22) | ORVION's tenants are Egyptian; pilgrims mostly Egyptian residents → Egypt PDPL 151/2020 more likely governs than KSA PDPL. The SAR-5M/in-Kingdom framing was over-stated. | DC-22 → NEEDS MORE EVIDENCE (residency-as-decision kept; jurisdiction TBD); cheap `data_region` hook retained. |
| RJ-5 | **Full `passenger_relationships` graph for mahram** | final-proof (DC-12) | A self-referential `passengers.mahram_passenger_id` (+ optional relationship_type) satisfies the KSA mahram-declaration need with far less complexity than an N:N relationship table. | DC-12 kept REQUIRED, simplified solution (self-FK). |
| RJ-6 | **Tenant-custom roles as a required-now RBAC change** | final-proof (DC-24) | ADR-0015 deliberately kept RBAC binary/simple; vertical products ship fixed roles. Not a universal requirement. | DC-24 → OPTIONAL (owner product-posture decision). |
| RJ-7 | **Universal sensitive-read logging as required** | certification (DC-6) | GDPR mandates access control + breach notification, not universal read-audit; over-broad. | DC-6 → OPTIONAL/Recommended for regulated data. |
| RJ-8 | **Reconciliation sweepers as a required domain** | certification (DC-8) | Stuck states are prevented by correct transactions (DC-2/DC-3), not a required healing subsystem; can mask design defects. | DC-8 → OPTIONAL/DEFERRED pending real incidents. |

## Rejections carried from prior reviews (reaffirmed)
- **Warehouse/MRP** and **Retail POS** domains — proven not part of a Travel ERP (`complete-platform-physical-design` E1/E2). Reaffirmed.
- **Event sourcing** as the state model — rejected in favor of state-based tables + `events` as audit/integration projection (now to be recorded explicitly, DC-27).
- **Stored/materialized customer balance** — rejected in favor of derived primitive (ADR-0021). Reaffirmed.
- **Enriching `role_permissions` with scope/condition columns** — rejected (ADR-0015). Reaffirmed.
- **Tenant-group changing RLS isolation predicate** — rejected; franchise is a consolidation read path (Synthesis C1). Reaffirmed.
- **Universal outbox over every event** — rejected; selective enqueue (Synthesis C2). Reaffirmed.

## Reversal policy
If a rejected decision is later reversed, append a dated "REVERSED" note here pointing to the new VALIDATED entry — never edit the original rejection away.
