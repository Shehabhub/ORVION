-- Migration: seed_system_catalogs
-- Plan reference: 33_sql_migration_plan.md migration 18 (seed data only, no DDL)
-- Provenance: catalog codes transcribed from 25_catalog_registry.md (v0.3). System rows only
-- (tenant_id null, is_system true). Idempotent: on conflict on the natural keys
-- (catalog_types.code, catalog_values(catalog_type_code, code)) do nothing, so db reset / CI
-- re-application never duplicates or errors. Labels are deterministic placeholders
-- (initcap of the code) pending localization per 25 section 26; sort_order follows registry order
-- via unnest ordinality.
--
-- Scope (per the migration-18 design validation): seeds catalog_types + catalog_values only.
-- Excluded by design and seeded elsewhere or intentionally not seeded:
--   * dedicated tables: role_code (roles), permission_key (permissions),
--     subscription_plan_code (subscription_plans), feature_code (feature_entitlements)
--   * reference data: currencies, countries, languages, nationalities, preferred_language_code
--   * deprecated: finance_approval_type (25 marks it deprecated in favour of approval_type_code)
--   * no consuming column yet: functional_role_code (no schema home), cabin_class_code,
--     fare_type_code, expense_category_code

-- Catalog types (ownership per 25). name is a deterministic placeholder.
insert into catalog_types (code, name, ownership_type)
select t.code, initcap(replace(t.code, '_', ' ')), t.ownership
from (values
    ('lead_status', 'system'),
    ('lead_closure_reason', 'system'),
    ('lead_source', 'tenant_extendable_system'),
    ('lead_interaction_type', 'system'),
    ('priority_code', 'system'),
    ('customer_type', 'system'),
    ('contact_method_type', 'system'),
    ('customer_identity_signal_type', 'system'),
    ('preferred_contact_method_code', 'system'),
    ('department_type', 'system'),
    ('branch_transfer_type', 'system'),
    ('task_type_code', 'system'),
    ('task_status_code', 'system'),
    ('booking_status', 'system'),
    ('booking_item_base_status', 'system'),
    ('service_type', 'tenant_extendable_system'),
    ('ticket_sub_status', 'system'),
    ('visa_sub_status', 'system'),
    ('hotel_sub_status', 'system'),
    ('passenger_type', 'system'),
    ('passenger_relationship_code', 'system'),
    ('quotation_status_code', 'system'),
    ('booking_cancellation_reason_code', 'system'),
    ('service_request_type_code', 'system'),
    ('service_request_status_code', 'system'),
    ('service_request_severity_code', 'system'),
    ('complaint_status_code', 'system'),
    ('complaint_severity_code', 'system'),
    ('complaint_category_code', 'system'),
    ('channel_code', 'system'),
    ('conversation_status_code', 'system'),
    ('sender_type_code', 'system'),
    ('message_direction_code', 'system'),
    ('supplier_type', 'tenant_extendable_system'),
    ('supplier_payment_term_code', 'system'),
    ('approval_type_code', 'system'),
    ('approval_status_code', 'system'),
    ('invoice_status_code', 'system'),
    ('refund_status_code', 'system'),
    ('tax_submission_status_code', 'system'),
    ('payment_direction', 'system'),
    ('payment_method', 'tenant_extendable_system'),
    ('refund_reason_code', 'system'),
    ('financial_account_type', 'system'),
    ('journal_entry_source_type', 'system'),
    ('exchange_rate_adjustment_reason', 'system'),
    ('document_type', 'system'),
    ('allowed_file_type', 'system'),
    ('document_lifecycle_status', 'system'),
    ('confidentiality_level_code', 'system'),
    ('document_link_target_type', 'system'),
    ('notification_type', 'system'),
    ('notification_channel', 'system'),
    ('notification_delivery_status', 'system'),
    ('subscription_status', 'system'),
    ('usage_metric_code', 'system'),
    ('verification_method', 'system'),
    ('trusted_device_status', 'system'),
    ('otp_challenge_status', 'system'),
    ('security_event_type', 'system'),
    ('offline_conversion_event_type', 'system'),
    ('offline_conversion_delivery_status', 'system'),
    ('attribution_source', 'system'),
    ('platform_code', 'system'),
    ('campaign_status_code', 'system')
) as t(code, ownership)
on conflict (code) do nothing;

-- Catalog values. Each type carries an ordered array of codes; unnest ordinality drives sort_order,
-- label is a deterministic placeholder, all rows are system (tenant_id null, is_system true).
insert into catalog_values (catalog_type_code, code, label, sort_order, is_system)
select t.type, v.code, initcap(replace(v.code, '_', ' ')), v.ord, true
from (values
    ('lead_status', array['new','assigned','contacted','qualified','quotation_sent','negotiation','won','converted','lost','spam','duplicate']),
    ('lead_closure_reason', array['booked','postponed','price_rejected','no_response','duplicate','spam','invalid_contact','not_interested','service_unavailable','competitor','customer_cancelled','converted_customer','other']),
    ('lead_source', array['google_ads_call','google_ads_form','direct_call','whatsapp','website_form','manual_entry','meta_ads','referral','repeat_customer','other']),
    ('lead_interaction_type', array['phone_call','whatsapp_message','chat_opened','customer_reply','note','follow_up','quotation_sent']),
    ('priority_code', array['low','normal','high','urgent']),
    ('customer_type', array['person','company']),
    ('contact_method_type', array['primary_phone','secondary_phone','whatsapp','email','facebook','instagram','other_social','other']),
    ('customer_identity_signal_type', array['phone','whatsapp','email','social_identity','passport_number','official_document_number']),
    ('preferred_contact_method_code', array['phone','whatsapp','email','social']),
    ('department_type', array['sales','operations','ticketing','finance','customer_service','administration','management']),
    ('branch_transfer_type', array['temporary','permanent']),
    ('task_type_code', array['call_customer','send_quotation','issue_ticket','verify_passport','collect_payment','approve_refund','follow_up','upload_document','review_booking','resolve_complaint','other']),
    ('task_status_code', array['open','in_progress','completed','cancelled','overdue']),
    ('booking_status', array['draft','pending_approval','confirmed','in_progress','issued','void','refunded','reissue','completed','cancelled']),
    ('booking_item_base_status', array['draft','pending','confirmed','in_progress','completed','cancelled','no_show']),
    ('service_type', array['flight_ticket','hotel','visa','umrah','hajj','tour_package','insurance','transport','custom_service']),
    ('ticket_sub_status', array['reserved','ticketed','reissued','void']),
    ('visa_sub_status', array['documents_pending','embassy_submitted','approved','rejected']),
    ('hotel_sub_status', array['reserved','confirmed','checked_in','checked_out']),
    ('passenger_type', array['adult','child','infant']),
    ('passenger_relationship_code', array['self','spouse','child','parent','relative','friend','employee','other']),
    ('quotation_status_code', array['draft','sent','accepted','rejected','expired','cancelled']),
    ('booking_cancellation_reason_code', array['customer_cancelled','payment_not_received','supplier_unavailable','price_changed','document_missing','duplicate_booking','operational_error','other']),
    ('service_request_type_code', array['complaint','flight_change','hotel_change','seat_request','meal_request','extra_baggage','invoice_request','airport_transfer','special_assistance','visa_follow_up','other']),
    ('service_request_status_code', array['requested','in_progress','awaiting_customer','awaiting_supplier','resolved','closed']),
    ('service_request_severity_code', array['low','normal','high','urgent','critical']),
    ('complaint_status_code', array['new','acknowledged','in_progress','awaiting_customer','awaiting_supplier','resolved','closed']),
    ('complaint_severity_code', array['low','normal','high','urgent','critical']),
    ('complaint_category_code', array['service_quality','pricing','supplier_issue','ticketing','documentation','baggage','visa','other']),
    ('channel_code', array['phone','whatsapp','email','website_form','internal','other']),
    ('conversation_status_code', array['open','assigned','pending_customer','pending_internal','escalated','closed']),
    ('sender_type_code', array['customer','user','system','external_provider']),
    ('message_direction_code', array['inbound','outbound','internal']),
    ('supplier_type', array['airline','hotel','embassy','visa_provider','travel_company','freelancer','internal_department','general_supplier']),
    ('supplier_payment_term_code', array['prepaid','pay_on_confirmation','net_7','net_15','net_30','credit_limit']),
    ('approval_type_code', array['finance_execution_approval','refund_approval','discount_approval','booking_override','manual_price_change','sensitive_data_change','subscription_approval']),
    ('approval_status_code', array['pending','approved','rejected','cancelled']),
    ('invoice_status_code', array['draft','issued','partially_paid','paid','voided','overdue']),
    ('refund_status_code', array['requested','approved','rejected','processing','completed','cancelled']),
    ('tax_submission_status_code', array['pending','submitted','failed','accepted','rejected']),
    ('payment_direction', array['customer_payment','supplier_payment','customer_refund','supplier_refund']),
    ('payment_method', array['cash','bank_transfer','card','wallet','other']),
    ('refund_reason_code', array['customer_cancelled','supplier_cancelled','service_unavailable','price_difference','duplicate_payment','operational_error','other']),
    ('financial_account_type', array['bank','cash']),
    ('journal_entry_source_type', array['invoice','receipt','payment','refund','exchange_rate_adjustment','manual_entry','booking_item']),
    ('exchange_rate_adjustment_reason', array['incorrect_rate','post_issuance_correction','finance_review','management_approval','other']),
    ('document_type', array['passport','national_id','visa','ticket','hotel_voucher','invoice','receipt','quotation','contract','medical_certificate','photo','other']),
    ('allowed_file_type', array['pdf','jpg','jpeg','png','webp']),
    ('document_lifecycle_status', array['active','archived','superseded']),
    ('confidentiality_level_code', array['normal','confidential']),
    ('document_link_target_type', array['passenger','booking','booking_item','invoice','receipt','supplier','subscription_payment']),
    ('notification_type', array['lead_sla_warning','lead_reassigned','finance_approval_result','passport_expiry','document_expiry','customer_balance','supplier_balance','subscription_expiry','subscription_read_only','security_alert']),
    ('notification_channel', array['in_system','email','whatsapp']),
    ('notification_delivery_status', array['pending','sent','failed','read']),
    ('subscription_status', array['trial','active','grace_period','read_only','suspended','cancelled','expired']),
    ('usage_metric_code', array['users','branches','monthly_leads','monthly_bookings','storage_gb','automations']),
    ('verification_method', array['email_otp','totp']),
    ('trusted_device_status', array['trusted','revoked','expired']),
    ('otp_challenge_status', array['pending','verified','failed','expired']),
    ('security_event_type', array['login_attempt','login_success','login_failure','otp_request','otp_verification_success','otp_verification_failure','totp_enrollment','totp_challenge_success','totp_challenge_failure','new_device_verification','password_change','password_reset','account_lock','permission_change']),
    ('offline_conversion_event_type', array['qualified_phone_call','qualified_lead','booking_created','payment_received','ticket_issued']),
    ('offline_conversion_delivery_status', array['pending','sent','failed','retried']),
    ('attribution_source', array['google_ads','meta_ads','website','whatsapp','direct','manual','other']),
    ('platform_code', array['google_ads','meta_ads','whatsapp_cloud_api','website','manual','other']),
    ('campaign_status_code', array['draft','active','paused','ended','archived'])
) as t(type, codes)
cross join lateral unnest(t.codes) with ordinality as v(code, ord)
on conflict (catalog_type_code, code) do nothing;
