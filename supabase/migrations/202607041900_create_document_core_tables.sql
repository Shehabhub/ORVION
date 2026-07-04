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
