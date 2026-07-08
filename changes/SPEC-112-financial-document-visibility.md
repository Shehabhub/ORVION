# Change Request — SPEC-112

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model

[ ] Tier 2 — Local execution agent (Qwen3.8B)

---

## Objective

Add `app.financial_documents()`, a `VIEW_FINANCIAL_DOCUMENTS`-guarded read listing a tenant's financial documents (invoice/receipt type or invoice/receipt-linked) — enforcing the stricter visibility canon requires — completing Phase 7.

---

## Business Reason

Phase 7 Documents (`16`/`28`: "Financial documents require stricter visibility"). Financial documents must be visible only to finance roles; since RLS on `documents` is tenant-wide, this finer control is an explicit `VIEW_FINANCIAL_DOCUMENTS` gate on a dedicated read — the last Phase-7 output.

---

## Risks

Low. Read-only function; no schema/table change, no writes, no events. Explicitly authorizes `VIEW_FINANCIAL_DOCUMENTS` (the earned exception to the RLS-only read precedent, because canon requires finer-than-RLS visibility). Excludes archived documents. `SECURITY INVOKER`. Verified by clean `db reset`, smoke-test, and behavioral tests: finance role sees invoice/receipt-typed and invoice/receipt-linked documents but not travel documents; a non-finance role is blocked.

---

## Supersedes / Depends On

Depends on `app.upload_document` (documents + links, SPEC-109) and the seeded `VIEW_FINANCIAL_DOCUMENTS`. Last Phase-7 CR. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607048200_financial_documents.sql
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-112-financial-document-visibility.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable); any `_ORVION_CANONICAL/**` except the manifest; AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`. `32_execution_roadmap.md` is updated only by the separate `Freeze Phase 7` governance step.

---

## Minimum Reading List

- _ORVION_CANONICAL/16_document_types_and_rules.md (financial vs travel documents)
- _ORVION_CANONICAL/28_permissions_matrix.md (VIEW_FINANCIAL_DOCUMENTS)
- supabase/migrations/202607047900_upload_document.sql (documents + document_links)

---

## Implementation Steps

1. Verify `202607048200_financial_documents.sql` does not exist. Add `app.financial_documents() returns table(document_id uuid, document_type_code text, title text, lifecycle_status_code text, is_confidential boolean, invoice_id uuid, receipt_id uuid)` — `stable`, `security invoker`, `set search_path=''`; tenant via `app.current_tenant_id()`; `app.authorize('VIEW_FINANCIAL_DOCUMENTS')`; select non-archived documents whose type is invoice/receipt or which are linked to an invoice/receipt (lateral join to `document_links`); `grant execute ... to authenticated`.
2. Sync `manifest.md` per `CR_LIFECYCLE.md §9` (trimmed).

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607048200`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: a finance role (owner) sees an invoice-linked document and an `invoice`/`receipt`-typed document, with the linked `invoice_id`/`receipt_id`, but not a passport/travel document.
- [x] Behavioral: a non-finance role (branch_manager) is blocked by `VIEW_FINANCIAL_DOCUMENTS`.
- [x] No canonical doc other than the manifest modified.

---

## Execution Log

### 2026-07-09 — Claude (Opus 4.8), Phase 7 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607048200_financial_documents.sql` created.
- Step 2: Applied — manifest synced (trimmed).

Verification: `npx supabase db reset` clean incl. `202607048200`; smoke-test → ALL CHECKS PASSED (71 tables). Behavioral (rolled back): as owner — an invoice-linked document and an `invoice`-typed document were returned (with the linked invoice_id), a passport travel document was excluded; as branch_manager — `permission denied: VIEW_FINANCIAL_DOCUMENTS`.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-09 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently verified against live DB — `db reset` clean, smoke ALL CHECKS PASSED (71 tables). `financial_documents` returns only financial documents (invoice/receipt type or invoice/receipt-linked), excludes travel documents and archived, exposes the financial linkage, and is gated by `VIEW_FINANCIAL_DOCUMENTS` (the earned read-permission exception per canon `28`). Additive; no canon change beyond the manifest; no new architectural decision.

Recommendation to human: Set Status to Complete (autonomous per `CR_LIFECYCLE.md` §5). This is the last Phase-7 output; `Freeze Phase 7` may now apply.

---

## Review Gate

- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied.
- [x] No file outside the Scope list was modified or created.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On handled (nothing to supersede).
- [x] The repository is in a clean, releasable state.

---

## Notes

Completes Phase 7 Documents (all `32` Phase-7 outputs: types, passenger/booking-item/financial documents, expiry, archive, versioning). `Freeze Phase 7` + the Phase-7 completion review follow as a governance step.
