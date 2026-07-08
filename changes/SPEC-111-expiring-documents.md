# Change Request — SPEC-111

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

Add `app.expiring_documents(p_within_days)`, the derived, read-only query behind document expiry alerts — non-archived documents expiring on or before now + N days (including already-expired), with `days_until_expiry`.

---

## Business Reason

Phase 7 Documents (`16`: official documents support expiry; expiry alerts are controlled by notification rules). The query primitive a scheduled notification workload (ADR-0018) consumes to warn on expiring/expired passports, visas, IDs, and medical certificates.

---

## Risks

Low. Read-only function; no schema/table change, no writes, no events. Excludes archived documents; surfaces both expired and soon-to-expire; validates `p_within_days`. `SECURITY INVOKER`, RLS-backed (read-RPC precedent). Verified by clean `db reset`, smoke-test, and behavioral tests of the window, exclusions, and the tenant guard.

---

## Supersedes / Depends On

Depends on `app.upload_document` (documents carry `expires_at`, SPEC-109) and `app.current_tenant_id`. Consumed later by a scheduled expiry-notification workload (Phase 10 / ADR-0018). Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607048100_expiring_documents.sql
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-111-expiring-documents.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable); any `_ORVION_CANONICAL/**` except the manifest; AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`, `32_execution_roadmap.md`.

---

## Minimum Reading List

- _ORVION_CANONICAL/16_document_types_and_rules.md (expiry rule)
- supabase/migrations/202607047900_upload_document.sql (documents.expires_at)

---

## Implementation Steps

1. Verify `202607048100_expiring_documents.sql` does not exist. Add `app.expiring_documents(p_within_days integer default 30) returns table(document_id uuid, document_type_code text, title text, expires_at timestamptz, days_until_expiry integer, is_confidential boolean)` — `stable`, `security invoker`, `set search_path=''`; tenant via `app.current_tenant_id()`; validate `p_within_days >= 0`; select non-archived documents with `expires_at <= now() + make_interval(days => p_within_days)`, ordered by `expires_at`; `grant execute ... to authenticated`.
2. Sync `manifest.md` per `CR_LIFECYCLE.md §9` (trimmed).

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607048100`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: with documents expiring in −5 / +10 / +200 days, `expiring_documents(30)` returns the first two (negative and within-window), ordered by `expires_at`, with correct `days_until_expiry`; the +200 one is excluded.
- [x] Behavioral: an archived expiring document and a document with null `expires_at` are excluded; a negative `p_within_days` is rejected.
- [x] No canonical doc other than the manifest modified.

---

## Execution Log

### 2026-07-09 — Claude (Opus 4.8), Phase 7 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607048100_expiring_documents.sql` created.
- Step 2: Applied — manifest synced (trimmed).

Verification: `npx supabase db reset` clean incl. `202607048100`; smoke-test → ALL CHECKS PASSED (71 tables). Behavioral (rolled back): documents at −5/+10/+200 days → `expiring_documents(30)` returned the −5 (days_until_expiry −5) then +10 rows, excluded +200; an archived expiring doc and a null-`expires_at` doc were excluded; `p_within_days = -1` raised.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-09 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently verified against live DB — `db reset` clean, smoke ALL CHECKS PASSED (71 tables). `expiring_documents` surfaces expired + soon-to-expire non-archived documents within the window with correct `days_until_expiry`, excludes archived/null-expiry, orders by `expires_at`, and validates its argument. Read-only, `security invoker`, no permission — consistent with the read-primitive precedent. Additive; no canon change beyond the manifest; no new architectural decision.

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

Expiry query primitive; the scheduled expiry-notification workload that consumes it is a Phase-10 / ADR-0018 concern. Remaining Phase 7: financial-document visibility (`VIEW_FINANCIAL_DOCUMENTS` — distinguishing financial documents from travel documents), after which Phase 7 is complete.
