-- Migration: document_versioning_lifecycle
-- Phase 7 (Documents). Two RPCs completing the document lifecycle (08 Document Model; 26 Document Lifecycle
-- State Machine; 16):
--   * app.add_document_version -- adds a new version to an existing document and makes it current. The
--     schema (document_versions + documents.current_version_id + is_current) is intra-document versioning:
--     a document keeps ONE rotating current version and remains 'active'. Emits document_version_created.
--   * app.archive_document -- retires a document (active|superseded -> archived) with a reason; sets
--     is_archived + archived_at/by + archive_reason + lifecycle_status_code='archived'. Emits
--     document_archived.
--
-- ENGINEERING OBSERVATION (26 wording vs frozen schema): 26 lists "active -> superseded: New document
-- version uploaded", but under the current_version_id design a document with a new current version is still
-- the live document, so marking it 'superseded' would contradict current_version_id. The frozen schema
-- governs the realization: a new version keeps the document 'active'. The document-level 'superseded' state
-- and document_superseded event are reserved for a future EXPLICIT document-replacement operation
-- (supersede one document by another), to be built when a real consumer needs it (Earn-It). Non-blocking;
-- no canon edit is made here.
--
-- Auth: CREATE_DOCUMENT_VERSION (add version) / ARCHIVE_DOCUMENT (archive). SECURITY INVOKER; RLS backstop.
-- No table/schema change.
create or replace function app.add_document_version(
    p_document_id uuid,
    p_file_name text,
    p_file_type_code text,
    p_storage_path text,
    p_file_size bigint default null
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_doc record;
    v_next integer;
    v_version_id uuid;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    if lower(coalesce(p_file_type_code, '')) not in ('pdf', 'jpg', 'jpeg', 'png', 'webp') then
        raise exception 'file type % is not allowed (MVP: pdf, jpg, jpeg, png, webp)', p_file_type_code;
    end if;

    select id, lifecycle_status_code, is_archived
      into v_doc
    from public.documents
    where id = p_document_id and tenant_id = v_tenant;
    if not found then
        raise exception 'document is not in your tenant';
    end if;
    if v_doc.is_archived or v_doc.lifecycle_status_code = 'archived' then
        raise exception 'cannot add a version to an archived document';
    end if;

    perform app.authorize('CREATE_DOCUMENT_VERSION');

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    select coalesce(max(version_number), 0) + 1 into v_next
    from public.document_versions
    where document_id = p_document_id and tenant_id = v_tenant;

    update public.document_versions set is_current = false
    where document_id = p_document_id and tenant_id = v_tenant and is_current;

    insert into public.document_versions (
        tenant_id, document_id, version_number, file_name, file_type_code, file_size,
        storage_path, uploaded_by, is_current
    ) values (
        v_tenant, p_document_id, v_next, p_file_name, lower(p_file_type_code), p_file_size,
        p_storage_path, v_actor, true
    ) returning id into v_version_id;

    update public.documents set current_version_id = v_version_id, updated_at = now()
    where id = p_document_id;

    perform app.record_event(
        v_tenant, 'document_version_created', 'document', p_document_id, v_actor,
        null, 'active', null,
        jsonb_build_object('version_number', v_next, 'version_id', v_version_id,
                           'file_type_code', lower(p_file_type_code)),
        'info'
    );

    return v_version_id;
end;
$$;
grant execute on function app.add_document_version(uuid, text, text, text, bigint) to authenticated;

create or replace function app.archive_document(
    p_document_id uuid,
    p_reason text
)
returns text
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_doc record;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;
    if p_reason is null or btrim(p_reason) = '' then
        raise exception 'archiving a document requires a reason';
    end if;

    select id, lifecycle_status_code, is_archived
      into v_doc
    from public.documents
    where id = p_document_id and tenant_id = v_tenant;
    if not found then
        raise exception 'document is not in your tenant';
    end if;
    if v_doc.is_archived or v_doc.lifecycle_status_code = 'archived' then
        raise exception 'document is already archived';
    end if;

    perform app.authorize('ARCHIVE_DOCUMENT');

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    update public.documents
    set lifecycle_status_code = 'archived',
        is_archived = true,
        archived_at = now(),
        archived_by = v_actor,
        archive_reason = p_reason,
        updated_at = now()
    where id = p_document_id;

    perform app.record_event(
        v_tenant, 'document_archived', 'document', p_document_id, v_actor,
        v_doc.lifecycle_status_code, 'archived', p_reason,
        jsonb_build_object('archive_reason', p_reason),
        'warning'
    );

    return 'archived';
end;
$$;
grant execute on function app.archive_document(uuid, text) to authenticated;
