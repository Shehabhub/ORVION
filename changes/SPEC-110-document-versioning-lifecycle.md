# Change Request — SPEC-110

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

Add `app.add_document_version` (new current version of an existing document) and `app.archive_document` (retire a document to `archived` with a reason), completing the document versioning and lifecycle.

---

## Business Reason

Phase 7 Documents (`08`/`16`/`26`). After upload (SPEC-109), documents need versioning (re-upload a corrected file) and archival (retire incorrect/expired documents — canon: archive, don't delete). Realises the Document Lifecycle around the frozen `document_versions`/`current_version_id` design.

---

## Risks

Low. Additive, `SECURITY INVOKER`, RLS-backed. `add_document_version` validates the file-type whitelist, blocks archived documents, flips `is_current`, advances `current_version_id`, and keeps the document `active`; `archive_document` requires a reason, blocks double-archive, and sets `is_archived`/`archived_*`/`archived` lifecycle. Guarded by `CREATE_DOCUMENT_VERSION` / `ARCHIVE_DOCUMENT`. No table/schema change. Verified by clean `db reset`, smoke-test, and behavioral tests of versioning, archival, the guards, and the reason/whitelist validations.

---

## Supersedes / Depends On

Depends on SPEC-109 (`app.upload_document`) and the seeded `CREATE_DOCUMENT_VERSION` / `ARCHIVE_DOCUMENT`. Supersedes nothing.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607048000_document_versioning_lifecycle.sql
- _ORVION_CANONICAL/manifest.md
- changes/SPEC-110-document-versioning-lifecycle.md

---

## Out of Scope — Files Forbidden to Modify

- Any other `supabase/migrations/**` file (all applied migrations are immutable, incl. `202607047900_upload_document.sql`); any `_ORVION_CANONICAL/**` except the manifest — including `26_state_machines.md` (the `superseded`-wording observation is recorded here, not corrected in canon without owner direction); AGENTS.md, CR_LIFECYCLE.md, README.md, `reports/**`, `32_execution_roadmap.md`.

---

## Minimum Reading List

- supabase/migrations/202607047900_upload_document.sql (document + first version)
- _ORVION_CANONICAL/26_state_machines.md (Document Lifecycle State Machine)
- _ORVION_CANONICAL/16_document_types_and_rules.md

---

## Implementation Steps

1. Verify `202607048000_document_versioning_lifecycle.sql` does not exist. Add `app.add_document_version(p_document_id uuid, p_file_name text, p_file_type_code text, p_storage_path text, p_file_size bigint default null) returns uuid` — validate file-type whitelist; load in-tenant document, reject if archived; `app.authorize('CREATE_DOCUMENT_VERSION')`; `version_number = max+1`; flip prior `is_current`; insert new current version; set `current_version_id`; emit `document_version_created`.
2. Add `app.archive_document(p_document_id uuid, p_reason text) returns text` — require reason; load in-tenant document, reject if already archived; `app.authorize('ARCHIVE_DOCUMENT')`; set `lifecycle_status_code='archived'`, `is_archived`, `archived_at/by`, `archive_reason`; emit `document_archived`.
3. Sync `manifest.md` per `CR_LIFECYCLE.md §9` (trimmed).

---

## Acceptance Criteria

- [x] `npx supabase db reset` applies all migrations cleanly including `202607048000`.
- [x] Smoke-test `scripts/verify_database.sql` still reports ALL CHECKS PASSED (71 tables).
- [x] Behavioral: `add_document_version` creates version 2 as `is_current` (version 1 no longer current), advances `current_version_id`, keeps the document `active`, and emits `document_version_created`.
- [x] Behavioral: `archive_document` sets `archived` + `is_archived` + reason and emits `document_archived`; adding a version to an archived document and archiving twice are rejected; archiving without a reason is rejected.
- [x] Behavioral: callers lacking `CREATE_DOCUMENT_VERSION` / `ARCHIVE_DOCUMENT` are blocked.
- [x] No canonical doc other than the manifest modified.

---

## Execution Log

### 2026-07-09 — Claude (Opus 4.8), Phase 7 execution

Outcome: Complete

Step results:
- Step 1–2: Applied — migration `202607048000_document_versioning_lifecycle.sql` created (`add_document_version` + `archive_document`).
- Step 3: Applied — manifest synced (trimmed).

Verification: `npx supabase db reset` clean incl. `202607048000`; smoke-test → ALL CHECKS PASSED (71 tables). Behavioral (rolled back): upload (v1) → add_document_version → v2 `is_current`, v1 not current, `current_version_id`=v2, document still `active`, `document_version_created` emitted; archive_document → `archived`+`is_archived`+reason, `document_archived` (warning); add version to archived → rejected; double archive → rejected; archive without reason → rejected; employee → `permission denied` for both.

Commits: (recorded on commit)

---

## Verification Notes

### 2026-07-09 — Claude (Opus 4.8)

Verdict: Confirmed Complete

Findings: Independently verified against live DB — `db reset` clean, smoke ALL CHECKS PASSED (71 tables). Versioning rotates the current version and advances `current_version_id` while the document stays `active`; archival sets the lifecycle/flags/reason and emits its event; all guards and validations reject as specified. The canon-26 `superseded`-wording divergence is recorded as an Engineering Observation (frozen schema governs; document-level supersede reserved for a future explicit op), not silently ignored. Additive; no canon change beyond the manifest; no new architectural decision.

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

Engineering Observation (recorded, not silently implemented): canon `26` "active → superseded on new version" diverges from the frozen `current_version_id` intra-document versioning design; the document stays `active` across versions, and the document-level `superseded` state + `document_superseded` event are reserved for a future explicit document-replacement operation. A canon-`26` wording reconciliation is a candidate future doc-consistency CR (owner-directed). Remaining Phase 7: document expiry surfacing (official-doc `expires_at`, `16`) and financial-document visibility (`VIEW_FINANCIAL_DOCUMENTS`).
