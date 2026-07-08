# Change Request — SPEC-109

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

Add `app.upload_document(...)`, the first Phase-7 capability: create a document, its first version, and a link to the subject entity (passenger / booking / booking item / invoice / receipt / supplier) in one transaction, in `active` status.

---

## Business Reason

Phase 7 Documents (`08`/`16`). The foundational document capability: upload + versioning start + linkage, honoring the canonical rules (controlled document-type catalog, passport-at-passenger and service-doc-at-booking-item placement, MVP file-type whitelist, tenant/linkage/permission security).

---

## Risks

Low–moderate (opens the document domain; verified across the rule matrix). Additive, `SECURITY INVOKER`, RLS-backed. Validates document type, file-type whitelist (executables rejected), file size, link-target catalog, target tenancy, and the two canonical placement rules. Creates document (`active`) + version 1 (`is_current`) + link atomically; sets `current_version_id`. Guarded by `UPLOAD_DOCUMENT`; emits `document_uploaded` + `document_linked`. Proper MIME sniffing is a storage/edge concern (deferred); this validates the declared `file_type_code`. No table/schema change. Verified by clean `db reset`, smoke-test, and behavioral tests of a valid upload, both placement rules, file-type/type/target validation, and the authority guard.

---

## Supersedes / Depends On

Depends on the document tables (`documents`/`document_versions`/`document_links`, migrations 6/15) and the seeded `UPLOAD_DOCUMENT` + document catalogs. First Phase-7 CR. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607047900_upload_document.sql
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-109-upload-document.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable); any `_ORVION_CANONICAL/**` except the manifest (document types/lifecycle/link-target already canonical; events plain-text per ADR-0006); AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`, `32_execution_roadmap.md`.

---

## Minimum Reading List

- _ORVION_CANONICAL/08_document_model.md
- _ORVION_CANONICAL/16_document_types_and_rules.md
- supabase/migrations/202607041900_create_document_core_tables.sql
- supabase/migrations/202607042800_create_document_links_table.sql

---

## Implementation Steps

1. Verify `202607047900_upload_document.sql` does not exist. Add `app.upload_document(p_document_type_code text, p_title text, p_file_name text, p_file_type_code text, p_storage_path text, p_link_target_type text, p_link_target_id uuid, p_file_size bigint default null, p_expires_at timestamptz default null, p_is_confidential boolean default false) returns uuid` — `security invoker`, `set search_path=''`; validate document_type + file-type whitelist + file_size + link-target catalog + target tenancy + placement rules (passport→passenger, ticket/visa/hotel_voucher→booking_item); `app.authorize('UPLOAD_DOCUMENT')`; insert `documents` (`active`) + `document_versions` (v1, current) + set `current_version_id` + `document_links` (matching column); emit `document_uploaded` + `document_linked`; `grant execute ... to authenticated`.
2. Sync `manifest.md` per `CR_LIFECYCLE.md §9` (trimmed).

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607047900`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: uploading a passport linked to a passenger creates an `active` document with a current version 1 and a `document_links` row, emitting `document_uploaded` + `document_linked`.
- [x] Behavioral: a passport linked to a non-passenger, a ticket linked to a non-booking-item, a disallowed file type, an unknown document type, and a target not in the tenant are all rejected.
- [x] Behavioral: a caller without `UPLOAD_DOCUMENT` (employee) is blocked.
- [x] No canonical doc other than the manifest modified.

---

## Execution Log

### 2026-07-09 — Claude (Opus 4.8), Phase 7 execution

Outcome: Complete

Step results:
- Step 1: Applied — migration `202607047900_upload_document.sql` created.
- Step 2: Applied — manifest synced (trimmed).

Verification: `npx supabase db reset` clean incl. `202607047900`; smoke-test → ALL CHECKS PASSED (71 tables). Behavioral (rolled back): passport→passenger upload → document `active`, version 1 `is_current`, `current_version_id` set, one `document_links` row, `document_uploaded` + `document_linked` events; passport→booking rejected (placement); ticket→passenger rejected (placement); file type `exe` rejected; unknown type rejected; foreign-tenant target rejected; employee → `permission denied: UPLOAD_DOCUMENT`.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-09 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently verified against live DB — `db reset` clean, smoke ALL CHECKS PASSED (71 tables). `upload_document` atomically creates document + current version + link, enforces the document-type/file-type/target catalogs, tenant target ownership, both canonical placement rules, and the `UPLOAD_DOCUMENT` guard; emits both events. Additive; no canon change beyond the manifest; no new architectural decision (realises `08`/`16`).

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

First Phase-7 capability. Next: document lifecycle (`advance_document`: active → superseded on new version, active/superseded → archived with reason) and versioning (`add_document_version`), then expiry surfacing and financial-document visibility. `subscription_payment`/`quotation` link targets are supported by the schema but deferred until their upload paths are built.
