-- Migration: event_type_registry_enforcement (resolves open item S-EVENT / N1)
-- Greenfield-2026 review: the event backbone is ORVION's automation contract; an unvalidated
-- event_type_code means a typo becomes a permanent immutable row that downstream automations
-- (n8n, Phase 8+) silently miss. 2026 practice = type governance at the write boundary
-- (schema-registry principle). One guard at the single emission funnel (app.record_event).
-- Vocabulary GENERATED from canon 27_event_catalog.md (the SSOT) — living-documentation
-- principle: derived from canonical evidence, not hand-typed. Seed style mirrors 043100
-- (system rows, idempotent on natural keys). Severity codes (canon 27) seeded as their own
-- family and validated at the same funnel.

insert into catalog_types (code, name, ownership_type)
values ('event_type', 'Event Type', 'system'),
       ('event_severity_code', 'Event Severity Code', 'system')
on conflict (code) do nothing;

insert into catalog_values (catalog_type_code, code, label, sort_order, is_system, is_active)
select 'event_type', c.code, initcap(replace(c.code, '_', ' ')), c.ord, true, true
from unnest(array['account_locked','approval_approved','approval_cancelled','approval_rejected','approval_requested','approval_resubmitted','attribution_click_captured','booking_cancelled','booking_completed','booking_confirmed','booking_created','booking_in_progress','booking_issued','booking_item_cancelled','booking_item_completed','booking_item_confirmed','booking_item_cost_entered','booking_item_cost_locked','booking_item_created','booking_item_in_progress','booking_item_locked_cost_edited','booking_item_no_show_recorded','booking_item_pending','booking_item_risk_flag_created','booking_item_sub_status_changed','booking_item_supplier_assigned','booking_refunded','booking_reissue_started','booking_submitted_for_approval','booking_voided','branch_created','company_asset_created','complaint_acknowledged','complaint_awaiting_customer','complaint_awaiting_supplier','complaint_closed','complaint_created','complaint_in_progress','complaint_reopened','complaint_resolved','conversation_assigned','conversation_closed','conversation_escalated','conversation_message_received','conversation_message_sent','conversation_reopened','conversation_started','customer_contact_added','customer_created','customer_cross_branch_activity_detected','customer_identity_match_found','customer_identity_merged','department_created','document_archived','document_expiry_warning','document_linked','document_superseded','document_uploaded','document_version_created','exchange_rate_adjustment_created','exchange_rate_set','finance_approval_approved','finance_approval_cancelled','finance_approval_rejected','finance_approval_requested','finance_approval_resubmitted','financial_account_created','internal_supplier_linked','invoice_created','invoice_issued','invoice_paid','invoice_partially_paid','journal_entry_created','lead_assigned','lead_contacted','lead_converted','lead_created','lead_lost','lead_marked_duplicate','lead_marked_spam','lead_negotiation_started','lead_qualified','lead_quotation_sent','lead_reassigned','lead_reopened','lead_sla_warning','lead_won','login_attempt','login_failure','login_success','marketing_campaign_activated','marketing_campaign_archived','marketing_campaign_created','marketing_campaign_ended','marketing_campaign_paused','notification_created','notification_failed','notification_read','notification_sent','offline_conversion_created','offline_conversion_failed','offline_conversion_retried','offline_conversion_send_attempted','offline_conversion_sent','otp_expired','otp_failed','otp_requested','otp_verified','passenger_created','passenger_document_added','passenger_passport_expiry_warning','password_changed','password_reset','payment_allocation_created','payment_recorded','permission_granted','permission_revoked','quotation_accepted','quotation_cancelled','quotation_created','quotation_expired','quotation_rejected','quotation_revised','quotation_sent','receipt_issued','refund_completed','refund_requested','role_assigned','role_removed','service_request_awaiting_customer','service_request_awaiting_supplier','service_request_closed','service_request_created','service_request_in_progress','service_request_reopened','service_request_resolved','subscription_activated','subscription_cancelled','subscription_created','subscription_entered_grace_period','subscription_entered_read_only','subscription_expired','subscription_payment_approved','subscription_payment_proof_uploaded','subscription_payment_rejected','subscription_reactivated','subscription_suspended','supplier_assigned_to_booking_item','supplier_created','supplier_payment_recorded','task_assigned','task_cancelled','task_completed','task_created','task_overdue','totp_challenge_failure','totp_challenge_success','totp_enrolled','trusted_device_created','trusted_device_expired','trusted_device_reverified','trusted_device_revoked','user_branch_transfer_completed','user_branch_transfer_started','user_created']) with ordinality as c(code, ord)
on conflict (catalog_type_code, code) do nothing;

insert into catalog_values (catalog_type_code, code, label, sort_order, is_system, is_active)
select 'event_severity_code', c.code, initcap(c.code), c.ord, true, true
from unnest(array['info','warning','risk','security','critical']) with ordinality as c(code, ord)
on conflict (catalog_type_code, code) do nothing;

-- Harden the single emission funnel: unknown types/severities are rejected at write time.
create or replace function app.record_event(
    p_tenant_id uuid,
    p_event_type_code text,
    p_entity_type text,
    p_entity_id uuid,
    p_actor_user_id uuid default null,
    p_previous_state text default null,
    p_new_state text default null,
    p_reason text default null,
    p_payload jsonb default null,
    p_severity_code text default 'info'
)
returns uuid
language plpgsql
security invoker
set search_path = ''
as $$
declare
    v_event uuid;
begin
    if not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'event_type' and code = p_event_type_code
    ) then
        raise exception 'unknown event_type_code: % (register it in 27_event_catalog.md + the event_type catalog first)', p_event_type_code;
    end if;
    if not exists (
        select 1 from public.catalog_values
        where catalog_type_code = 'event_severity_code' and code = p_severity_code
    ) then
        raise exception 'unknown severity_code: %', p_severity_code;
    end if;
    insert into public.events (
        tenant_id, event_type_code, severity_code, actor_user_id, entity_type, entity_id,
        previous_state, new_state, reason, payload
    )
    values (
        p_tenant_id, p_event_type_code, p_severity_code, p_actor_user_id, p_entity_type, p_entity_id,
        p_previous_state, p_new_state, p_reason, p_payload
    )
    returning id into v_event;
    return v_event;
end;
$$;
