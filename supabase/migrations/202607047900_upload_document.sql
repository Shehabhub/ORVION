-- Migration: upload_document
-- Phase 7 (Documents) -- first capability. app.upload_document creates a document, its first version, and a
-- link to the subject entity in one transaction (08 Document Model; 16 Document Types And Rules). The
-- document starts 'active' (26 Document Lifecycle State Machine: active -> superseded/archived).
--
-- Canon 16 rules enforced: document_type must be a controlled catalog value (document_type); the file type
-- must be in the MVP whitelist (pdf/jpg/jpeg/png/webp -- executables rejected); the link target must be a
-- controlled document_link_target_type and the target entity must exist in the caller's tenant; PLACEMENT:
-- passports are stored at passenger level (not customer), and ticket/visa/hotel_voucher service documents
-- at booking item level. Security rule: extension/type/size validated here; tenant ownership + entity
-- linkage + user permission are enforced (UPLOAD_DOCUMENT). MIME validation proper is an edge/storage
-- concern (deferred to the upload surface); this RPC validates the declared file_type_code + size.
--
-- Auth: UPLOAD_DOCUMENT. SECURITY INVOKER; RLS backstop. Emits document_uploaded + document_linked.
-- Additive: one RPC; no table/schema change.
create or replace function app.upload_document(
    p_document_type_code text,
    p_title text,
    p_file_name text,
    p_file_type_code text,
    p_storage_path text,
    p_link_target_type text,
    p_link_target_id uuid,
    p_file_size bigint default null,
    p_expires_at timestamptz default null,
    p_is_confidential boolean default false
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
    v_actor uuid;
    v_document_id uuid;
    v_version_id uuid;
    v_target_ok boolean;
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    if not exists (select 1 from public.catalog_values
                   where catalog_type_code = 'document_type' and code = p_document_type_code) then
        raise exception 'unknown document_type: %', p_document_type_code;
    end if;
    if lower(coalesce(p_file_type_code, '')) not in ('pdf', 'jpg', 'jpeg', 'png', 'webp') then
        raise exception 'file type % is not allowed (MVP: pdf, jpg, jpeg, png, webp)', p_file_type_code;
    end if;
    if p_file_size is not null and p_file_size <= 0 then
        raise exception 'file_size must be greater than zero';
    end if;
    if not exists (select 1 from public.catalog_values
                   where catalog_type_code = 'document_link_target_type' and code = p_link_target_type) then
        raise exception 'unknown document_link_target_type: %', p_link_target_type;
    end if;

    -- Placement rules (16): passport at passenger level; ticket/visa/hotel_voucher at booking item level.
    if p_document_type_code = 'passport' and p_link_target_type <> 'passenger' then
        raise exception 'passport documents are stored at passenger level';
    end if;
    if p_document_type_code in ('ticket', 'visa', 'hotel_voucher') and p_link_target_type <> 'booking_item' then
        raise exception '% documents are stored at booking item level', p_document_type_code;
    end if;

    -- Target entity must exist in the caller's tenant.
    v_target_ok := case p_link_target_type
        when 'passenger'    then exists (select 1 from public.passengers    where id = p_link_target_id and tenant_id = v_tenant)
        when 'booking'      then exists (select 1 from public.bookings       where id = p_link_target_id and tenant_id = v_tenant)
        when 'booking_item' then exists (select 1 from public.booking_items  where id = p_link_target_id and tenant_id = v_tenant)
        when 'invoice'      then exists (select 1 from public.invoices       where id = p_link_target_id and tenant_id = v_tenant)
        when 'receipt'      then exists (select 1 from public.receipts       where id = p_link_target_id and tenant_id = v_tenant)
        when 'supplier'     then exists (select 1 from public.suppliers      where id = p_link_target_id and tenant_id = v_tenant)
        else false
    end;
    if not v_target_ok then
        raise exception '% target % is not in your tenant (or that target type is not yet supported)',
            p_link_target_type, p_link_target_id;
    end if;

    perform app.authorize('UPLOAD_DOCUMENT');

    select id into v_actor
    from public.users
    where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

    insert into public.documents (
        tenant_id, document_type_code, title, lifecycle_status_code,
        is_confidential, expires_at, created_by
    ) values (
        v_tenant, p_document_type_code, p_title, 'active',
        p_is_confidential, p_expires_at, v_actor
    ) returning id into v_document_id;

    insert into public.document_versions (
        tenant_id, document_id, version_number, file_name, file_type_code, file_size,
        storage_path, uploaded_by, is_current
    ) values (
        v_tenant, v_document_id, 1, p_file_name, lower(p_file_type_code), p_file_size,
        p_storage_path, v_actor, true
    ) returning id into v_version_id;

    update public.documents set current_version_id = v_version_id, updated_at = now()
    where id = v_document_id;

    insert into public.document_links (
        tenant_id, document_id, passenger_id, booking_id, booking_item_id,
        invoice_id, receipt_id, supplier_id, created_by
    ) values (
        v_tenant, v_document_id,
        case when p_link_target_type = 'passenger'    then p_link_target_id end,
        case when p_link_target_type = 'booking'      then p_link_target_id end,
        case when p_link_target_type = 'booking_item' then p_link_target_id end,
        case when p_link_target_type = 'invoice'      then p_link_target_id end,
        case when p_link_target_type = 'receipt'      then p_link_target_id end,
        case when p_link_target_type = 'supplier'     then p_link_target_id end,
        v_actor
    );

    perform app.record_event(
        v_tenant, 'document_uploaded', 'document', v_document_id, v_actor,
        null, 'active', null,
        jsonb_build_object('document_type_code', p_document_type_code, 'file_type_code', lower(p_file_type_code),
                           'link_target_type', p_link_target_type, 'link_target_id', p_link_target_id),
        'info'
    );
    perform app.record_event(
        v_tenant, 'document_linked', 'document', v_document_id, v_actor,
        null, p_link_target_type, null,
        jsonb_build_object('link_target_type', p_link_target_type, 'link_target_id', p_link_target_id),
        'info'
    );

    return v_document_id;
end;
$$;
grant execute on function app.upload_document(text, text, text, text, text, text, uuid, bigint, timestamptz, boolean) to authenticated;
