# Change Request — SPEC-036

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word (for example
"Ready", "Implemented", or "Rejected") anywhere in a Change Request.

---

## Assigned Model Tier

[ ] Tier 1 — Strong reasoning model
[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Create migration 7, `create_document_core_tables`, defining `documents` and `document_versions` per `31_schema_draft.md` section 6 and `30_database_conventions.md`, resolving their mutual reference via a deferred foreign key.

---

## Business Reason

`33_sql_migration_plan.md` migration 7 creates the document core. `documents` and `document_versions` reference each other (`documents.current_version_id` → `document_versions`, and `document_versions.document_id` → `documents`), so neither can be created first with both foreign keys intact; the plan resolves this by deferring `documents.current_version_id`'s constraint to an `ALTER` after `document_versions` exists. Structure only — no data.

---

## Risks

Low. Two new tables plus one `ALTER`. Prerequisites live (`tenants` mig 4, `users` mig 5). The mutual reference is resolved by the deferred-`ALTER` pattern documented in `33`. The one-current-version rule (`31` §6) is enforced by a partial unique index. Status/type codes are plain text (SPEC-030). Physical choices not fixed by the canon are in Notes.

---

## Supersedes / Depends On

Depends On: `SPEC-029` (tenants), `SPEC-032` (users), `SPEC-028` (moddatetime) — all Complete.

---

## Scope — Files Allowed to Modify

- supabase/migrations/202607041900_create_document_core_tables.sql

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** ; supabase/config.toml ; any existing migration ; any later migration (document_links is migration 15) ; seed data

---

## Minimum Reading List

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/33_sql_migration_plan.md

---

## Implementation Steps

1. Verification check: if any file matches `supabase/migrations/*_create_document_core_tables.sql`, record Already Applied. Otherwise create `supabase/migrations/202607041900_create_document_core_tables.sql` with exactly:

```sql
-- Migration: create_document_core_tables
-- Plan reference: 33_sql_migration_plan.md migration 7
-- Creates documents and document_versions per 31_schema_draft.md section 6 and 30.
-- Resolves the documents <-> document_versions mutual reference: documents is created first
-- with current_version_id as a plain nullable column (no FK), then document_versions (with
-- its document_id FK), then documents.current_version_id's FK is added via ALTER.
-- Status/type codes are plain text (SPEC-030). documents has archive fields + an updated_at
-- trigger; document_versions has uploaded_at only (no updated_at, no trigger).

create table documents (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    document_type_code text not null,
    title text not null,
    current_version_id uuid,
    lifecycle_status_code text not null,
    is_confidential boolean not null default false,
    expires_at timestamptz,
    created_by uuid references users (id) on delete restrict on update no action,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    is_archived boolean not null default false,
    archived_at timestamptz,
    archived_by uuid references users (id) on delete restrict on update no action,
    archive_reason text
);

create table document_versions (
    id uuid primary key default gen_random_uuid(),
    tenant_id uuid not null references tenants (id) on delete restrict on update no action,
    document_id uuid not null references documents (id) on delete restrict on update no action,
    version_number integer not null,
    file_name text not null,
    file_type_code text not null,
    file_size bigint,
    storage_path text not null,
    uploaded_by uuid references users (id) on delete restrict on update no action,
    uploaded_at timestamptz not null default now(),
    is_current boolean not null default false
);

-- Resolve the mutual reference: add documents.current_version_id -> document_versions(id).
alter table documents
    add constraint documents_current_version_id_fkey
    foreign key (current_version_id) references document_versions (id)
    on delete restrict on update no action;

-- At most one current version per document (31 section 6 document_versions Rule).
create unique index document_versions_one_current_idx
    on document_versions (document_id)
    where is_current;

-- Indexes (30 Index Standard: foreign keys, tenant filtering).
create index documents_tenant_id_idx on documents (tenant_id);
create index document_versions_document_id_idx on document_versions (document_id);
create index document_versions_tenant_id_idx on document_versions (tenant_id);

-- updated_at trigger (documents only; document_versions has no updated_at).
create trigger documents_set_updated_at
    before update on documents
    for each row execute function moddatetime(updated_at);
```

---

## Acceptance Criteria

- [ ] `supabase/migrations/202607041900_create_document_core_tables.sql` exists with exactly the Step 1 content.
- [ ] `npx supabase db reset` applies every migration (1–8) on a clean database with no error.
- [ ] `documents` and `document_versions` exist.
- [ ] `documents.current_version_id` has a foreign key to `document_versions(id)` (added by the `ALTER`); `document_versions.document_id` has a foreign key to `documents(id)`; all foreign keys are `restrict`/`no action`.
- [ ] The partial unique index `document_versions_one_current_idx` exists on `(document_id) WHERE is_current`.
- [ ] No foreign key exists on any status/type-code column (`document_type_code`, `lifecycle_status_code`, `file_type_code`).
- [ ] A trigger exists on `documents`; `document_versions` has no `updated_at` trigger.
- [ ] Behavioral check (rolled back): a second `is_current = true` `document_versions` row for the same `document_id` is rejected. No data persists.

---

## Execution Log

### <YYYY-MM-DD HH:MM> — <agent identifier>

Outcome: Complete | Blocked | Failed

Step results:
- Step 1: Already Applied | Applied | Failed — <one-line reason>

Commits: <commit hash(es) for this run>

Blocker: <only if Blocked/Failed.>

---

## Verification Notes

### <YYYY-MM-DD HH:MM> — <agent identifier>

Verdict: Confirmed Complete | Discrepancy Found | Needs Corrective Change Request

Findings: <what was independently re-checked>

Recommendation to human: Set Status to Complete | Set Status to Cancelled

---

## Review Gate

- [ ] Every change matches the Implementation Steps.
- [ ] No file outside Scope was modified.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] The repository is in a clean, releasable state.

---

## Notes

Physical decisions: `current_version_id` FK uses `restrict` (the default) — `set null` is a possible alternative for this nullable optional reference but is unnecessary since document versions are not physically deleted; `file_size` is `bigint` nullable; `version_number` is `integer`; `created_by`/`archived_by`/`uploaded_by` nullable. `documents` carries the standard archive fields (Archive Standard).

Finding (Recommended, not added — surfaced): `document_versions` could carry a `unique (document_id, version_number)`; it is implied but not stated in `31`, so it is left to a future decision rather than added silently.
