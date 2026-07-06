# Change Request — SPEC-080

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

Phase 5 (Booking Core) — internal supplier linkage as an organizational fulfilment capability. `app.link_internal_supplier(...)` records that a provider branch/department fulfils a booking item on behalf of the item's owning (requester) branch/department, appending a fulfilment-history row and publishing an `internal_supplier_linked` event. ASSIGN_SUPPLIER-guarded.

---

## Business Reason

`internal_supplier_links` (schema) models internal cross-branch/department fulfilment (provider vs requester org units), distinct from external supplier assignment (`booking_items.supplier_id`). `32_execution_roadmap.md` lists "Supplier linkage" as a Phase 5 output. Operational history of who fulfilled what and when supports audit, reporting, commissions, workload, and future SLA — the table has no uniqueness constraint, so appending rows naturally preserves it.

---

## Risks

Low. One `SECURITY INVOKER` RPC; RLS backstop. No table/schema change. Item + provider org unit are tenant-verified; linkage is blocked on a terminal/archived item or booking. Requester is derived from the item's owning org unit. History is append-only (new row per linkage); an `internal_supplier_linked` event is published for audit/reaction. No service-specific assumptions (Booking Core stays generic).

---

## Supersedes / Depends On

Depends On: SPEC-075 (`create_booking_item`), `app.authorize` (SPEC-062), `record_event` (SPEC-065). Related: external supplier assignment (`booking_items.supplier_id`, set at item creation). Future (recorded): a unified fulfilment view combining internal links + external supplier + future provider types; supplier entity management RPCs.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607045900_link_internal_supplier.sql
- _ORVION_CANONICAL/manifest.md (state update)

---

## Out of Scope — Files Forbidden to Modify

- Any existing migration ; table structure ; RBAC/catalog seed data ; external supplier entity management ; finance/commission computation ; service-specific fulfilment logic

---

## Minimum Reading List

- _ORVION_CANONICAL/03_company_structure.md (branches/departments) ; 06_booking_and_travel_products.md ; 28_permissions_matrix.md (ASSIGN_SUPPLIER)
- supabase/migrations/202607042300_create_booking_core_tables.sql (internal_supplier_links) ; 202607045400_create_booking_item.sql

---

## Implementation Steps

1. Create `supabase/migrations/202607045900_link_internal_supplier.sql`: `app.link_internal_supplier(p_booking_item_id, p_provider_branch_id, p_provider_department_id, p_reason)` — `SECURITY INVOKER`, `set search_path=''`, `app.authorize('ASSIGN_SUPPLIER')`. Load the item joined to its booking, in-tenant; reject if the item is archived/`cancelled`/`no_show` or the booking is archived/`completed`/`cancelled`. Derive requester = item `owner_branch_id`/`owner_department_id` (fallback booking branch/department). Verify provider department-within-branch-within-tenant. Append an `internal_supplier_links` row (history). Publish `internal_supplier_linked` (payload: link/provider/requester org units). Return the link id. `grant execute … to authenticated`.

---

## Acceptance Criteria

- [x] Migration exists; `npx supabase db reset` applies cleanly; smoke-test still passes.
- [x] Linking a provider branch/department to an item creates an `internal_supplier_links` row (requester derived from the item) and emits one `internal_supplier_linked` event.
- [x] A second linkage appends a new row (history preserved; both rows present, latest = current) rather than overwriting.
- [x] An invalid provider (department not in provider branch / not in tenant) is rejected; linkage to a terminal/archived item or booking is rejected.
- [x] `link_internal_supplier` is denied without `ASSIGN_SUPPLIER` (42501).

---

## Execution Log

### 2026-07-07 — Claude (Tier 1)

Outcome: Complete

Step results:
- Step 1: Applied — `app.link_internal_supplier(...)` added. `npx supabase db reset` applied cleanly; `scripts/verify_database.sql` reports ALL CHECKS PASSED.

Behavioral test (Sara = senior_employee with ASSIGN_SUPPLIER; a draft item owned by branch/dept A; provider dept B):
- Link provider (branch A / dept Ops) to the item → link row created, requester = the item's owner branch/dept, one `internal_supplier_linked` event (payload provider/requester).
- A second link to a different provider dept → appends a second row (2 rows total; history preserved).
- Provider department not in provider branch → rejected; provider dept in another tenant → rejected; link to a `cancelled` item → rejected; link to an item on a cancelled booking → rejected.
- `link_internal_supplier` as a trainee (no ASSIGN_SUPPLIER) → 42501.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-07 — Claude (independent review)

Verdict: Confirmed Complete

Findings: Internal supplier linkage is modelled as organizational fulfilment (provider vs requester org units), derived requester from the item's ownership, and correctly kept distinct from external `supplier_id`. Fulfilment history is preserved by appending rows (no overwrite; the table's lack of a unique constraint is used as intended), and an `internal_supplier_linked` event gives an immutable audit/reaction seam for future reporting/commissions/SLA — honoring the owner's history + orchestration-boundary guidance without adding complexity. Tenant + org-unit validation and terminal-state guards are correct. No service-specific assumptions; Booking Core stays generic. `SECURITY INVOKER`; no schema change; no file outside Scope modified.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

**Organizational fulfilment framing (owner suggestion #1):** the fulfilling party today is another branch/department (internal, `internal_supplier_links`) or an external supplier (`booking_items.supplier_id`); an internal-operations-team / future-provider-type would extend via the same booking-item seam. A unified fulfilment view across internal + external + future providers is recorded as a future observation (not built — would be solving a future problem). **History (suggestion #2):** preserved by append-only linkage rows + the event; the latest row is the current provider. **Service-agnostic (suggestion #3):** no flight/hotel/visa/etc. assumptions. No inequality check between provider and requester is imposed (a unit may fulfil its own item); if a business rule later forbids self-fulfilment it is a small addition. Amounts/commissions from fulfilment are Finance Core (not computed here).
