# Change Request — SPEC-045

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word anywhere in a Change Request.

---

## Assigned Model Tier

[ ] Tier 1 — Strong reasoning model
[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Create migration 15, `create_document_links_table`, defining `document_links` per `31_schema_draft.md` section 6 and `30_database_conventions.md`, including the DB-level single-target-FK CHECK.

---

## Business Reason

`33` migration 15 adds `document_links`, the single latest-dependent table in the schema. It links a document to exactly one business entity and therefore depends on migrations 7 (documents), 9 (passengers/suppliers), 10 (quotations/bookings/booking_items), 12 (invoices/receipts), and 14 (subscription_payment_proofs). Structure only.

---

## Risks

Low (1 table) but carries the schema's most explicit invariant: `31` requires the "exactly one target FK per row" rule to be a database-level constraint, not only application logic. Enforced here as `document_links_single_target_check`.

---

## Supersedes / Depends On

Depends On: `SPEC-036` (documents), `SPEC-039` (passengers/suppliers), `SPEC-040` (quotations/bookings/booking_items), `SPEC-042` (invoices/receipts), `SPEC-044` (subscription_payment_proofs) — Complete.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607042800_create_document_links_table.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; any later migration ; seed data

---

## Minimum Reading List

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/33_sql_migration_plan.md

---

## Implementation Steps

1. Create `supabase/migrations/202607042800_create_document_links_table.sql` defining `document_links` per `31` section 6: `document_id` (source) plus eight nullable target FKs (passenger/booking/booking_item/invoice/quotation/receipt/supplier/subscription_payment_proof), all `restrict`/`no action`; a CHECK enforcing exactly one target non-null; reverse-lookup indexes on the source and each target FK. No `updated_at`, so no trigger.

---

## Acceptance Criteria

- [x] `supabase/migrations/202607042800_create_document_links_table.sql` exists.
- [x] `npx supabase db reset` applies every migration on a clean database with no error.
- [x] The table exists; all foreign keys `restrict`/`no action`.
- [x] `document_links_single_target_check` enforces exactly one target FK non-null; verified behaviorally (zero targets rejected, two targets rejected, one target accepted).
- [x] No `updated_at` trigger was created (the table has no `updated_at`).

---

## Execution Log

### 2026-07-05 — Claude (Tier 2 execution)

Outcome: Complete

Step results:
- Step 1: Applied — created the migration; `npx supabase db reset` applied all 17 migrations cleanly.

Database Audit: table present; all 11 FKs restrict/no-action; the `document_links_single_target_check` constraint exists; no trigger. Behavioral: a row with zero targets rejected, a row with two targets rejected, a row with exactly one target (a document linked to a booking) accepted.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-05 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Re-checked `document_links` against `31` section 6 — the source `document_id` plus eight nullable target FKs, all `restrict`/`no action`. The single-target CHECK enforces the `31` Rule at the database level as required. No `updated_at`, hence no trigger. Clean `db reset` and behavioral tests reproduced (0/2 targets rejected, 1 accepted). No file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Physical decisions: `document_id` is the source document and is excluded from the single-target CHECK (the eight business-entity FKs are the targets); the CHECK sums `(col is not null)::int` across the eight targets and requires `= 1`, satisfying `31`'s database-level enforcement mandate; every target FK is individually indexed to support reverse lookups ("all documents for this booking/invoice/..."). This is the final migration of the approved migrations 10–15 continuous phase; the next unit (migration 16, authentication support tables) is an owner architectural gate per ADR-0011.
