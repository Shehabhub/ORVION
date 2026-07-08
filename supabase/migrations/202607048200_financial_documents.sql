-- Migration: financial_documents
-- Phase 7 (Documents) -- final capability. app.financial_documents lists a tenant's FINANCIAL documents
-- (16/28: "Financial documents require stricter visibility"). A document is financial if its type is
-- invoice/receipt OR it is linked to an invoice or receipt (document_links.invoice_id/receipt_id).
--
-- Unlike the other read primitives (which rely on tenant-wide RLS), this read is EXPLICITLY GUARDED by
-- VIEW_FINANCIAL_DOCUMENTS: RLS on documents is tenant-wide (every member can read documents), but canon
-- requires financial documents to be visible only to finance roles (owner/ceo/finance_manager). This is the
-- earned case for an app.authorize on a read -- the permission provides finer control than RLS. Travel
-- documents remain readable under the general document access (VIEW_TRAVEL_DOCUMENTS scope) and need no
-- special read. Read-only: no writes, no events. STABLE, SECURITY INVOKER. No table/schema change.
create or replace function app.financial_documents()
returns table (
    document_id uuid,
    document_type_code text,
    title text,
    lifecycle_status_code text,
    is_confidential boolean,
    invoice_id uuid,
    receipt_id uuid
)
language plpgsql
stable
security invoker
set search_path = ''
as $$
declare
    v_tenant uuid := app.current_tenant_id();
begin
    if v_tenant is null then
        raise exception 'no active tenant for caller';
    end if;

    perform app.authorize('VIEW_FINANCIAL_DOCUMENTS');

    return query
    select
        d.id,
        d.document_type_code,
        d.title,
        d.lifecycle_status_code,
        d.is_confidential,
        dl.invoice_id,
        dl.receipt_id
    from public.documents d
    left join lateral (
        select l.invoice_id, l.receipt_id
        from public.document_links l
        where l.document_id = d.id
          and (l.invoice_id is not null or l.receipt_id is not null)
        limit 1
    ) dl on true
    where d.tenant_id = v_tenant
      and d.is_archived = false
      and (d.document_type_code in ('invoice', 'receipt')
           or dl.invoice_id is not null
           or dl.receipt_id is not null)
    order by d.created_at desc;
end;
$$;
grant execute on function app.financial_documents() to authenticated;
