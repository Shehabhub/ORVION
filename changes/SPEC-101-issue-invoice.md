# Change Request — SPEC-101

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

Add `app.issue_invoice(...)` moving a customer invoice `draft -> issued` — the point at which it becomes a live receivable counted by `app.customer_balance`.

---

## Business Reason

Phase 6 Finance Core invoicing pipeline, the slice after `create_invoice` (SPEC-100). A draft invoice is not a receivable; issuing finalises it so it enters `customer_balance` (which counts `issued/partially_paid/paid/overdue`) and, via that balance, the booking issuance risk flag. Reuses the existing `CREATE_INVOICE` authority (finance) — no new permission (Earn-It).

---

## Risks

Low. Additive, `SECURITY INVOKER`, RLS-backed. One narrow transition (`draft -> issued`); non-draft/voided/archived invoices are rejected. Emits `invoice_issued`. No table/schema change. Verified by clean `db reset`, smoke-test, and behavioral tests: issue makes the invoice appear in `customer_balance`; re-issuing / issuing a voided invoice is rejected; a caller without `CREATE_INVOICE` is blocked.

---

## Supersedes / Depends On

Depends on SPEC-100 (`app.create_invoice`) and `app.customer_balance` (SPEC-089). Consumed later by payment recording. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607047000_issue_invoice.sql
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-101-issue-invoice.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable, incl. `202607046900_create_invoice.sql`); any `_ORVION_CANONICAL/**` except the manifest (no canon change: statuses already canonical; `invoice_issued` is plain-text per ADR-0006); AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`, `32_execution_roadmap.md`.

---

## Minimum Reading List

- supabase/migrations/202607046900_create_invoice.sql (invoice create + statuses)
- supabase/migrations/202607046300_customer_balance.sql (which statuses are receivables)

---

## Implementation Steps

1. Verify `202607047000_issue_invoice.sql` does not exist. Add it: `create or replace function app.issue_invoice(p_invoice_id uuid, p_reason text default null) returns text` — `security invoker`, `set search_path=''`; tenant via `app.current_tenant_id()`; load the in-tenant invoice; reject archived/voided and any non-`draft` status; `app.authorize('CREATE_INVOICE')`; update `status_code='issued'`; emit `invoice_issued` (`draft`->`issued`); `grant execute ... to authenticated`.
2. Sync `manifest.md` per `CR_LIFECYCLE.md §9` (trimmed: single `Last Completed`, no history chain).

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607047000`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: issuing a `draft` invoice returns `issued`, emits `invoice_issued`, and the invoice then appears in `app.customer_balance` as outstanding (was absent while draft).
- [x] Behavioral: issuing a non-`draft` (already issued) invoice raises; issuing a voided/archived invoice raises.
- [x] Behavioral: a caller without `CREATE_INVOICE` (senior_employee) is blocked.
- [x] No canonical doc other than the manifest modified.

---

## Execution Log

### 2026-07-09 — Claude (Opus 4.8), Phase 6 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607047000_issue_invoice.sql` created (`app.issue_invoice`).
- Step 2: Applied — manifest synced (trimmed).

Verification: `npx supabase db reset` clean incl. `202607047000`; smoke-test → ALL CHECKS PASSED (71 tables). Behavioral (authenticated-caller sim, rolled back): a draft invoice was absent from `customer_balance`; after `issue_invoice` → returned `issued`, emitted `invoice_issued`, and appeared in `customer_balance` (USD outstanding = its total); re-issuing raised `only a draft invoice can be issued (is issued)`; issuing after void raised `invoice is archived or voided`; senior_employee → `permission denied: CREATE_INVOICE`.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-09 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently re-verified against live DB. `db reset` clean (202607047000 applied), smoke-test ALL CHECKS PASSED (71 tables). `issue_invoice` performs exactly the `draft -> issued` transition, makes the invoice a receivable visible to `app.customer_balance`, emits `invoice_issued`, and rejects non-draft/voided/archived invoices and callers lacking `CREATE_INVOICE`. Additive; no canon change beyond the manifest; no new architectural decision (Finance Core direction).

Recommendation to human: Set Status to Complete (autonomous per `CR_LIFECYCLE.md` §5).

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

Second invoicing slice. Natural next: payment recording (`payments` + `payment_allocations` → drives `partially_paid`/`paid`, and closes the receivable). If the invoice status set (draft/issued/partially_paid/paid/overdue/voided) grows a genuine multi-edge lifecycle, propose adding an invoice state machine to `26` at that point (Design-Review call).
