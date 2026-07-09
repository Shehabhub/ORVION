# ORVION Complete Platform — Physical Design & Domain Register (2026-07-09)

Status: **Proposal for owner approval.** Design/analysis only. Nothing implemented; no schema, canonical doc, or completed phase modified; Phase 8 not started. Earn-It suspended for this review only.

Owner mandate applied: I **discover, prove, design**; the owner decides product scope. Every domain is **Included** (industry evidence proves it belongs in a complete modern Travel ERP/CRM/Revenue platform → complete physical design) or **Excluded** (evidence proves it does not belong → reasoning shown). "Addable later without touching the foundation" is recorded as a *property* of a domain, never a reason to withhold its design.

Notation: `table(col type [pk|fk→table|uq|nn|def], …)`; **IX** = indexes; **CK** = check constraints; **CAT** = catalogs; **PERM** = permissions; **EVT** = events; **RPC** = functions; **DIM** = reporting/dashboard dimensions; **INT** = integration boundary. Types: `uuid, text, numeric(14,2), int, bigint, bool, date, timestamptz, jsonb`. Every tenant table carries `tenant_id uuid nn fk→tenants` + RLS `tenant_isolation` + `created_at/updated_at` + soft-archive where it is a business record; omitted below for brevity. Money columns are `numeric(14,2)` + `currency_code fk→currencies` + non-negative CK unless a signed ledger amount.

---

## 0. Domain Register (verdict index)

**Included (28):** CRM/Customer-Identity · Leads · Sales · Customer Communications · Notifications · Reservations/Booking · Product-Catalog · Inventory/Allotments · Supplier-Contracts/Rates · Service verticals (Flight/Hotel/Visa/Insurance/Transport/Umrah/Hajj/Domestic/International) · Suppliers · Pricing/Discounts · Tax/VAT · Finance/Accounting · Treasury · Documents · Assets · HR · Payroll · Procurement · Fleet/Vehicles · Guides/Resources · Branches/Org · Franchise/Multi-company · Subscription/Billing/Entitlements/Feature-Flags · Workflow/Approvals · Integration Layer (Google Ads/Meta/WhatsApp/GA4/GTM/GDS/NDC/BSP/n8n) · Event/Outbox backbone · Revenue Intelligence · AI/MCP · Reporting/Dashboards/Analytics · Localization · Audit/Security.

**Excluded (2, with proof):** Physical Warehouse / MRP manufacturing-inventory · Retail POS.
**Operational, not a data-model domain (3):** Monitoring · Logging · Backup/DR.

Every Included domain's physical design follows. Domains already **physically built in Phases 2–7** are marked *[BUILT]* with only their **extensions** specified (the migrations are the existing physical design); new domains get full tables.

---

## 1. Party / Customer-Identity / Suppliers — Included
**Evidence:** ERP party model is standard (a party plays many roles; customer⇄supplier duality is real in travel B2B). *[customers/suppliers BUILT; generalise to party.]*
- `parties(id pk, party_kind text nn[person|organization], display_name text nn, legal_name text, tax_identifier text, preferred_language_code fk→languages, primary_email text, primary_phone text, is_archived …)`
- `party_roles(id pk, party_id fk→parties nn, role_code text nn, status_code text nn, ar_credit_limit numeric, ar_payment_term_code text, ap_credit_limit numeric, ap_payment_term_code text, uq(tenant_id,party_id,role_code))`
- `party_relationships(id pk, parent_party_id fk→parties, child_party_id fk→parties, relationship_type_code text nn, valid_from date, valid_to date)`
- `party_contact_identities(id pk, party_id fk→parties nn, channel_code text nn, value text nn, is_verified bool def false, consent_marketing bool, consent_data bool, uq(tenant_id,channel_code,value))`
- **Extend built:** `customers`/`suppliers` gain `party_id fk→parties`; `customer_contact_methods` superseded by `party_contact_identities` (kept, back-linked).
- **IX:** parties(tenant,party_kind); party_roles(tenant,role_code,status_code); contact_identities(tenant,channel_code,value).
- **CAT:** party_kind, party_role, party_relationship_type, contact_channel(phone/email/whatsapp/instagram/messenger/sms/external).
- **PERM:** MANAGE_PARTY, VIEW_PARTY, MERGE_PARTY, MANAGE_CREDIT_TERMS. **EVT:** party_created/updated/merged, party_role_granted/revoked, consent_changed. **RPC:** app.upsert_party, app.grant_party_role, app.merge_party, app.set_credit_terms. **DIM:** party_role, party_kind, branch. **INT:** inbound comms resolve to party via contact_identities.

## 2. Leads / Sales / CRM — Included *[BUILT — Phase 4]*
`leads, lead_assignments, lead_interactions, customers, customer_notes, customer_identity_signals, customer_identity_merges, tasks, complaints, service_requests, quotations, quotation_items, conversations, conversation_messages` exist with RPCs (create_lead, round-robin, SLA, advance_lead, convert_lead, merge). **Extensions:** attribution columns `leads.attribution_click_id fk→attribution_clicks` + `gbraid/wbraid/consent` on `attribution_clicks` (A3); quotation→booking already via lead_booking_readiness. **Verdict:** Included, built; additive extensions only.

## 3. Reservations / Booking + Service Verticals — Included *[booking core BUILT — Phase 5]*
**Evidence:** core of a travel platform; service verticals (flight/hotel/visa/insurance/transport/umrah/hajj/domestic/international) are `service_type`/product categories, not separate schemas (they share the booking-item lifecycle). *[bookings/booking_items/passengers/links BUILT.]*
- **Extend booking_items:** `product_id fk→products`, `product_component_id fk→product_components`, `package_departure_id fk→package_departures`.
- `booking_item_references(id pk, booking_item_id fk→booking_items nn, reference_type_code text nn[record_locator|ticket_number|confirmation_no|supplier_ref|visa_no|policy_no], value text nn, issued_at timestamptz, uq(tenant_id,reference_type_code,value))` — the GDS/NDC/BSP/visa/insurance data slot.
- `service_attributes(booking_item_id fk→booking_items pk-part, attr jsonb)` OR typed per-vertical extension tables (`flight_segments(booking_item_id, from_iata, to_iata, dep_at, arr_at, marketing_carrier, operating_carrier, cabin_code, fare_basis, baggage)`, `hotel_stays(booking_item_id, hotel_ref, room_type_code, check_in date, check_out date, board_code, occupancy jsonb)`, `visa_applications(booking_item_id, visa_type_code, country_code, applied_at, decision_code, decision_at)`, `insurance_policies(booking_item_id, plan_code, coverage jsonb, insured_from date, insured_to date)`, `transport_segments(booking_item_id, vehicle_type_code, pickup, dropoff, at)`).
- **CAT:** reference_type, room_type, board_type, cabin_code, visa_type, visa_decision, transport_type. **EVT:** booking_item_reference_recorded + per-vertical status events. **PERM:** existing booking perms + MANAGE_RESERVATION_DETAIL. **DIM:** service_type, product_category, supplier, branch, destination. **INT:** GDS/NDC/hotel APIs populate references + segments via Integration Layer.
- **Note:** flight_segments/hotel_stays/etc. are additive per-vertical tables — *Included; implementable per vertical without touching the booking header.*

## 4. Product Catalog / Inventory / Allotments / Supplier Contracts — Included (new)
**Evidence (researched):** dynamic packaging = product composed of priced components; fixed departures + allotments are core to Umrah/Hajj/tour operators; NDC = offer/order product model.
- `product_categories(id pk, code text nn, name text, parent_category_id fk→product_categories)`
- `products(id pk, product_type_code text nn[service|package|fixed_departure|ancillary], category_id fk→product_categories, code text, name text nn, default_supplier_id fk→suppliers, is_sellable bool def true, status_code text nn, uq(tenant_id,code))`
- `product_components(id pk, parent_product_id fk→products nn, child_product_id fk→products nn, quantity int def 1, sequence int, is_optional bool)`
- `product_variants(id pk, product_id fk→products nn, code text, attributes jsonb)`; `product_constraints(id pk, product_id fk→products, constraint_type_code text, config jsonb)`
- `package_departures(id pk, product_id fk→products nn, departure_date date nn, return_date date, capacity int, sold int def 0, status_code text nn)`
- `supplier_contracts(id pk, supplier_id fk→suppliers nn, code text, valid_from date, valid_to date, terms jsonb, status_code text nn)`
- `supplier_rates(id pk, contract_id fk→supplier_contracts nn, product_id fk→products, rate_basis_code text, cost_amount numeric nn, currency_code fk→currencies, valid_from date, valid_to date, occupancy_code text)`
- `inventory_allotments(id pk, product_id fk→products, package_departure_id fk→package_departures, supplier_contract_id fk→supplier_contracts, allot_date date, quantity int nn, held int def 0, released int def 0, status_code text nn)`; `allotment_movements(id pk, allotment_id fk→inventory_allotments nn, movement_type_code text, quantity int, booking_item_id fk→booking_items)`
- **IX:** products(tenant,product_type_code,status_code); package_departures(tenant,product_id,departure_date); supplier_rates(tenant,contract_id,product_id,valid_from); allotments(tenant,product_id,allot_date).
- **CK:** package_departures.sold ≤ capacity; allotment held+released ≤ quantity.
- **CAT:** product_type, product_category, component_role, rate_basis, occupancy, allotment_status, departure_status, constraint_type. **EVT:** product/departure/allotment lifecycle. **PERM:** MANAGE_PRODUCT, MANAGE_INVENTORY, MANAGE_SUPPLIER_CONTRACT, VIEW_PRODUCT. **RPC:** app.create_product, app.compose_package, app.open_departure, app.hold_allotment, app.release_allotment, app.get_availability. **DIM:** product_category, product_type, departure, supplier. **INT:** hotel/airline/GDS availability sync writes allotments/availability.
- *Property:* new aggregate; booking_items link via nullable FKs → built without touching booking header structurally.

## 5. Pricing / Discounts / Promotions — Included (new)
**Evidence:** margin/tax/discount reporting needs a component breakdown; standard in travel/ERP.
- `price_components(id pk, owner_type_code text nn[quotation_item|booking_item|invoice_line], owner_id uuid nn, component_type_code text nn[base|markup|discount|fee|tax|commission], amount numeric nn, currency_code fk→currencies, tax_code fk→tax_codes, source_rule_id fk→pricing_rules)`
- `pricing_rules(id pk, rule_type_code text nn[markup|discount|fee], scope jsonb, formula jsonb, priority int, valid_from date, valid_to date, status_code text)`
- `promotions(id pk, code text, promo_type_code text, config jsonb, valid_from date, valid_to date, max_uses int, uses int def 0, uq(tenant_id,code))`; `promotion_redemptions(id pk, promotion_id fk→promotions nn, booking_id fk→bookings, redeemed_at timestamptz)`
- **IX:** price_components(tenant,owner_type_code,owner_id); pricing_rules(tenant,rule_type_code,status_code). **CAT:** price_component_type, pricing_rule_type, promo_type. **EVT:** price_calculated, discount_applied, promotion_redeemed. **PERM:** MANAGE_PRICING, APPLY_DISCOUNT(conditional), MANAGE_PROMOTION. **RPC:** app.price_line, app.apply_promotion. **DIM:** component_type, promotion.

## 6. Tax / VAT — Included (new)
**Evidence (researched):** TOMS margin scheme (UK/EU); KSA/GCC 15% VAT; tax must be reconcilable.
- `tax_authorities(id pk, code text, name text, country_code)`; `tax_codes(id pk, code text nn, name, authority_id fk→tax_authorities, scheme_code text nn[standard|margin|zero|exempt], uq(tenant_id,code))`; `tax_rates(id pk, tax_code_id fk→tax_codes nn, rate numeric nn, valid_from date, valid_to date)`
- **Relationships:** `price_components.tax_code`, `invoice_lines.tax_code`, GL tax postings. **CAT:** tax_scheme. **EVT:** tax_calculated. **PERM:** MANAGE_TAX_CONFIG. **RPC:** app.compute_tax(line/margin). **DIM:** tax_code, tax_scheme.

## 7. Finance / Accounting / Treasury — Included *[finance core BUILT — Phase 6; deepen]*
**Evidence (researched):** multi-dimensional GL, **required dimensions with N/A**, automated subledger→GL posting, locked FX + revaluation, fiscal periods. *[chart_of_accounts, journal_entries/lines, invoices, payments, payment_allocations, receipts, refunds, exchange_rates, financial_accounts BUILT + balance/profit RPCs.]*
- **Invoice lines (new):** `invoice_lines(id pk, invoice_id fk→invoices nn, booking_item_id fk→booking_items, description text, quantity numeric, unit_amount numeric, line_total numeric nn, tax_code fk→tax_codes, tax_amount numeric)` (today invoices carry a single `total_amount`; lines enable tax/margin).
- **Dimensions:** `accounting_dimensions(id pk, dimension_type_code text nn[branch|department|cost_center|trip], code text nn, name, uq(tenant_id,dimension_type_code,code)) ` incl. an **"N/A" member**; `journal_entry_lines` gains `branch_id, department_id, cost_center_id, booking_id` (nullable → N/A member).
- **Periods:** `fiscal_calendars(id pk, code, start_month int)`; `accounting_periods(id pk, calendar_id fk, code text, start_date date, end_date date, status_code text nn[open|closed|locked], uq(tenant_id,code))`.
- **Auto-posting:** `posting_rules(id pk, source_type_code text nn, gl_template jsonb nn, is_active bool)`; `app.post_transaction(source_type, source_id)` builds a balanced entry per rule.
- **AP:** `supplier_bills(id pk, supplier_id fk→suppliers nn, bill_number text, bill_date date nn, currency_code fk→currencies, total_amount numeric nn, status_code text nn[draft|approved|paid|void], booking_id fk→bookings, uq(tenant_id,bill_number))`; `supplier_bill_lines(…)`; supplier payments (exist) allocate to bills via `bill_allocations(id pk, payment_id fk→payments, supplier_bill_id fk→supplier_bills, allocated_amount numeric)`.
- **Notes:** `credit_notes`/`debit_notes(id pk, party_id fk→parties, related_invoice_id fk→invoices, number text, amount numeric, reason_code, status_code)`.
- **Treasury:** `financial_accounts` (exist) + `bank_statements(id pk, financial_account_id fk, statement_date date, opening numeric, closing numeric)` + `bank_statement_lines(…)` + `bank_reconciliations(id pk, financial_account_id fk, period_id fk→accounting_periods, status_code)` + `account_transfers(id pk, from_account_id fk, to_account_id fk, amount numeric, at timestamptz)` + `cash_sessions(id pk, financial_account_id fk, opened_by fk→users, opened_at, closed_at, opening_float numeric, counted numeric)`.
- **FX:** `currency_revaluations(id pk, period_id fk, run_at, gain_loss numeric)`.
- **IX:** journal_entry_lines(tenant, cost_center_id), (tenant,booking_id); supplier_bills(tenant,status_code); periods(tenant,status_code). **CK:** debit XOR credit (line); debits=credits (entry) via RPC; period must be `open` to post.
- **CAT:** dimension_type, journal_source_type, period_status, bill_status, note_type, reconciliation_status, transfer_type. **EVT:** journal_posted, period_closed, bill lifecycle, revaluation_posted, reconciliation_completed. **PERM:** POST_JOURNAL(exists), MANAGE_PERIOD, APPROVE_BILL, RECONCILE_ACCOUNT, MANAGE_DIMENSIONS, EDIT_LOCKED_COST(exists). **RPC:** app.post_transaction, app.close_period, app.approve_bill, app.reconcile, app.revalue_currency. **DIM:** account, cost_center, branch, department, trip/booking, period. **INT:** BSP/bank feeds → statements/bills via Integration Layer.

## 8. Documents — Included *[BUILT — Phase 7; complete]*
Add `document_sequences` (§ cross-cutting), `document_templates(id pk, doc_type_code, locale, layout jsonb, uq(tenant,doc_type_code,locale))`, `document_retention_policies`, and `documents.signature_status_code` slot (e-sign integration is a connector). **Verdict:** Included, built; additive.

## 9. Assets — Included *[company_assets table exists; deepen]*
`company_assets` (exists) + `asset_categories`, `asset_assignments(id pk, asset_id fk, assigned_to_user_id fk→users, from_date, to_date)`, `asset_depreciations(id pk, asset_id fk, period_id fk→accounting_periods, amount numeric)` (posts via §7). **CAT:** asset_category, asset_status. **PERM:** MANAGE_ASSET. **Property:** additive; depreciation posts through existing GL.

## 10. HR — Included (new)
**Evidence:** HR is a standard ERP pillar; a travel company employs staff (sales/ops/guides).
- `employees(id pk, party_id fk→parties[person], user_id fk→users, employee_no text, hire_date date, employment_type_code, department_id fk→departments, branch_id fk→branches, manager_id fk→employees, status_code text nn, uq(tenant_id,employee_no))`
- `employment_contracts(id pk, employee_id fk, contract_type_code, start_date, end_date, base_salary numeric, currency_code)`; `leave_types`, `leave_requests(id pk, employee_id fk, leave_type_code, from_date, to_date, status_code)`; `attendance(id pk, employee_id fk, work_date date, hours numeric)`.
- **CAT:** employment_type, employee_status, leave_type, leave_status. **EVT:** employee_hired/terminated, leave_requested/approved. **PERM:** MANAGE_HR, VIEW_HR, APPROVE_LEAVE. **DIM:** department, branch, employment_type. **Property:** employees reference party+users; fully additive.

## 11. Payroll — Included (new)
**Evidence:** payroll is the finance side of HR; commissions/incentives are core to travel sales.
- `payroll_runs(id pk, period_id fk→accounting_periods, run_date, status_code)`; `payroll_items(id pk, run_id fk, employee_id fk→employees, earning_type_code, amount numeric)`; `commission_settlements(id pk, employee_id fk→employees, booking_item_id fk→booking_items, commission_amount numeric, status_code, settled_at)` — reads `booking_items.commission_rate` + `sales_owner_user_id`.
- **EVT:** payroll_run_posted, commission_settled. **PERM:** RUN_PAYROLL, APPROVE_PAYROLL. Posts to GL via §7. **Property:** additive; consumes booking/HR/finance foundations.

## 12. Procurement — Included (new)
**Evidence:** agencies procure allotments, services, office goods; POs → AP bills.
- `purchase_requisitions(id pk, requested_by fk→users, status_code)`; `purchase_orders(id pk, supplier_id fk→suppliers, po_number text uq(tenant,po_number), status_code, total_amount numeric)`; `purchase_order_lines(id pk, po_id fk, product_id fk→products, quantity, unit_amount)`; PO→`supplier_bills` (§7) on receipt.
- **CAT:** po_status, requisition_status. **EVT:** po_created/approved/received. **PERM:** MANAGE_PROCUREMENT, APPROVE_PO. **Property:** additive; settles through AP subledger.

## 13. Fleet / Vehicles & Guides / Resources — Included (new)
**Evidence:** DMC/transport/Umrah-Hajj operators manage vehicles and guides as schedulable resources.
- `resources(id pk, resource_type_code text nn[vehicle|guide|room_block|staff], party_id fk→parties, supplier_id fk→suppliers, name text, attributes jsonb, status_code)`; `resource_availability(id pk, resource_id fk, from_ts timestamptz, to_ts timestamptz, status_code)`; `resource_assignments(id pk, resource_id fk→resources nn, booking_item_id fk→booking_items, from_ts, to_ts, status_code)`.
- **CAT:** resource_type, resource_status. **EVT:** resource_assigned/released. **PERM:** MANAGE_RESOURCE, ASSIGN_RESOURCE. **DIM:** resource_type, branch. **Property:** additive; links booking_items via assignment table.

## 14. Branches / Org / Franchise / Multi-company — Included *[branches/departments BUILT; add hierarchy]*
- `tenant_groups(id pk, name text, group_type_code text nn[franchise|holding|network])`; `tenant_relationships(id pk, parent_tenant_id fk→tenants, child_tenant_id fk→tenants, relationship_type_code, valid_from)`; `tenants.tenant_group_id fk→tenant_groups`.
- **RLS:** `app.current_tenant_id()` (single primitive) extended to resolve **group scope** in one place (ADR-0013) — no per-table policy change. Inter-company postings hit both ledgers (§7).
- **CAT:** tenant_group_type, tenant_relationship_type. **PERM:** MANAGE_TENANT_GROUP (service_role/platform). **DIM:** tenant, tenant_group, branch, department. **Property:** the single-primitive RLS design makes group scope additive.

## 15. Subscription / Billing / Entitlements / Feature Flags — Included *[subscription tables BUILT; complete]*
Two planes: **platform→tenant** (`subscription_plans/subscriptions/feature_entitlements/usage_counters` exist) + `feature_flags(id pk, feature_code text nn, enabled bool, scope jsonb, uq(tenant_id,feature_code))` + `platform_invoices`/metering; **tenant→customer** = Finance (§7). Primitive `app.has_feature(feature_code)`.
- **CAT:** feature_code, plan_code, entitlement_type, billing_status. **EVT:** subscription lifecycle (state machine `26`), feature_flag_changed, usage_metered. **PERM:** MANAGE_SUBSCRIPTION(exists), MANAGE_FEATURE_FLAGS. **RPC:** app.has_feature, app.meter_usage. **Property:** additive to existing SaaS tables.

## 16. Workflow / Approvals — Included *[approval_requests generic BUILT; extend]*
`approval_requests` (generic `approval_type_code`) + optional `workflow_definitions(id pk, code, steps jsonb)` + `workflow_instances`. **CAT:** approval_type(+discount/refund/credit/override/po). **PERM:** REVIEW_APPROVAL_REQUEST(exists) per type. **Property:** additive; a full engine is an overlay that doesn't alter existing approvals.

## 17. Customer Communications / Notifications / Templates / Consent — Included *[conversations/notifications BUILT; complete]*
**Evidence (researched):** WhatsApp Cloud API webhook model; message status (sent/delivered/read); template categories (marketing/utility/authentication/service); omnichannel inbox.
- **Extend conversations:** `channel_code, external_thread_id, assigned_user_id`; **conversation_messages:** `direction_code, external_message_id, status_code, template_id fk→message_templates, in_reply_to`.
- `message_templates(id pk, channel_code, category_code, locale, name, body jsonb, variables jsonb, approval_status_code, uq(tenant_id,channel_code,name,locale))`; `notification_rules(id pk, event_type_code, channel_code, template_id fk, audience jsonb)`; `notification_preferences(id pk, party_id fk→parties, channel_code, opted_in bool)`; `consent_records(id pk, party_id fk→parties, channel_code, purpose_code, granted bool, at timestamptz)`.
- **IX:** conversations(tenant,channel_code,external_thread_id); messages(tenant,status_code). **CAT:** channel_code, message_direction, message_status, template_category, notification_event, consent_purpose. **EVT:** message_received/sent/status_changed, template_submitted, consent_changed, notification_sent. **PERM:** SEND_MESSAGE(exists), MANAGE_TEMPLATE, MANAGE_NOTIFICATION_RULES. **INT:** WhatsApp/Meta/email via webhook_inbox + outbox. **Property:** conversations exist; channel/status fields + template/consent tables are additive.

## 18. Integration Layer + Event/Outbox backbone — Included (new; hosts all connectors)
**Evidence (researched):** transactional outbox = standard for reliable at-least-once + idempotent delivery; webhook-driven platforms (WhatsApp/Meta/Google).
- `integration_providers(id pk, code text nn[google_ads|google_data_manager|meta_capi|whatsapp|ga4|gtm|gds|ndc|bsp|n8n|generic], name, capabilities jsonb)`
- `integration_connections(id pk, provider_id fk→integration_providers nn, config jsonb, secret_ref text (Vault), status_code, uq(tenant_id,provider_id,config->>account))`
- `event_outbox(id pk, event_id fk→events nn, connection_id fk→integration_connections, destination_code, payload jsonb, status_code text nn[pending|sent|acked|failed|dead], attempts int def 0, next_attempt_at timestamptz, dedup_key text, last_error text, uq(tenant_id,dedup_key))`
- `webhook_inbox(id pk, provider_id fk, external_id text, payload jsonb, status_code text nn[received|processed|failed], received_at, uq(tenant_id,provider_id,external_id))`
- `integration_sync_state(id pk, connection_id fk, cursor jsonb, synced_at)`
- **IX:** event_outbox(tenant,status_code,next_attempt_at) partial where status in(pending,failed); webhook_inbox(tenant,provider_id,external_id). **CAT:** integration_provider, delivery_status, webhook_status. **EVT:** integration_connected, delivery_sent/failed, webhook_received. **PERM:** MANAGE_INTEGRATION, VIEW_INTEGRATION_LOGS. **RPC:** app.enqueue_delivery, app.claim_outbox_batch (FOR UPDATE SKIP LOCKED), app.mark_delivered, app.ingest_webhook. **INT boundary:** each connector (Google Ads Data Manager, Meta CAPI, WhatsApp Cloud API, GA4/GTM, GDS/NDC, BSP, n8n) = a `provider` row + an Edge Function relay reading `event_outbox` / writing `webhook_inbox`.
- **Connectors (each = provider config + Edge relay, not new schema):** Google Ads (offline conversions via Data Manager API — legacy blocked 2026-06-15), Meta CAPI, WhatsApp Cloud API, GA4/GTM (tagging), GDS/NDC (availability/booking), BSP (settlement feed), n8n (automation). All **Included** as connectors of this one layer.

## 19. Event Contract / Audit / Security — Included *[events/security_events BUILT; harden]*
- **Extend events:** `schema_version int, correlation_id uuid, causation_id uuid` + documented per-type payload contract (`27`). DB-enforced immutability trigger (backlog B4). RBAC (`role_permissions`, ADR-0015) + `app.authorize` + `app.has_feature`; RLS (ADR-0013). **PERM/EVT:** as built. **Property:** additive columns + trigger; the contract is what RI/AI/integrations consume.

## 20. Revenue Intelligence / Reporting / Dashboards / Analytics — Included (consumer)
**Evidence:** the platform vision is a verified-outcome source of truth; RI/reporting are consumers of events + dimensions.
- **Design:** read models / materialized views over `events` (contract §19) + finance **dimensions** (§7) + operational dimensions. `report_definitions`/`dashboard_definitions(id pk, code, config jsonb, dimensions jsonb)` optional metadata; RI delivery via `event_outbox` (§18). No write-side change.
- **DIM (available to every dashboard):** branch, department, cost_center, trip/booking, product_category, service_type, supplier, party_role, channel, period, campaign, employee. **PERM:** VIEW_REPORTS, VIEW_ADVANCED_DASHBOARDS(exists). **Property:** additive read layer; **the dimensions it needs are defined in §7/§2 foundations**, so no foundation change.

## 21. AI / MCP — Included (consumer)
**Evidence:** AI agents/MCP operate over a stable RPC + event surface; this is an access pattern, not new core schema.
- **Design:** an MCP server exposes ORVION read RPCs + guarded action RPCs as tools; AI observes via `events`/`event_outbox`; optional `ai_agent_runs(id pk, agent_code, input jsonb, output jsonb, at)` + `ai_recommendations(id pk, subject_type, subject_id, recommendation jsonb, score numeric)` audit tables. **PERM:** AI actions reuse existing RPC permissions + `app.has_feature('ai')`. **Property:** additive; the agent boundary *is* the existing RPC/event surface.

## 22. Localization / i18n — Included (new)
`locales(code pk, name)`; `translations(id pk, entity_type_code text nn, entity_key text nn, field_code text nn, locale text nn, value text nn, uq(tenant_id,entity_type_code,entity_key,field_code,locale))`. Drives catalog labels, product content, templates, document layouts; party `preferred_language_code` selects. **PERM:** MANAGE_TRANSLATIONS. **Property:** additive translation layer.

---

## Cross-cutting physical (designed once)

- `document_sequences(id pk, doc_type_code text nn, branch_id fk→branches, prefix text, format text, next_value bigint def 1, reset_policy_code text[none|annual], last_reset_period text, is_gapless bool, uq(tenant_id,doc_type_code,branch_id))` + `app.next_document_number(doc_type, branch)`.
- Dimensions, outbox, event contract, party, i18n, entitlements, RLS-group — as above; each used by every downstream domain.

---

## Excluded domains (with proof)

### E1. Physical Warehouse / MRP manufacturing-inventory — **Excluded**
- **Evidence/reasoning:** a travel company is a **service** business; "inventory" in travel means **allotments/seats/rooms** (fully designed in §4), not physical stock, SKUs, bins, or manufacturing BOM/MRP. Travel back-office references (Traveltek, GP Solutions, Trawex) model *travel inventory* as allotments, never warehouse stock. Including an MRP/warehouse module would import concepts (reorder points, stock movements, production) with no travel referent.
- **Narrow edge case handled elsewhere:** physical give-aways (Umrah kits/ihram) are low-volume consumables — covered, if ever needed, by a light `procurement` receipt + `assets`/consumable count, **not** a warehouse/MRP domain. **Verdict: Excluded** (not part of a Travel ERP); revisit only if ORVION pivots to selling physical goods at scale.

### E2. Retail POS — **Excluded**
- **Evidence/reasoning:** POS (in-store retail checkout, cash-drawer/terminal, barcode) is a **retail** pattern. Travel counter sales are already modeled as **bookings + payments + receipts + cash_sessions** (§3/§7). A POS module would duplicate these with retail semantics that don't fit itinerary-based selling. **Verdict: Excluded**; counter/cash sales are served by existing booking+treasury design.

## Operational concerns — Included as platform ops, NOT data-model domains
- **Monitoring / Logging / Backup / Disaster Recovery:** these are **infrastructure** (Supabase PITR/backups, external observability/metrics/tracing, log drains), realized in project settings and the Edge/runtime layer — **no tables, no schema**. They belong to the platform's *operations*, documented as an ops runbook, and require **no data-model design**. Business **audit** (who did what) *is* a data domain and is covered by `events`/`security_events` (§19).

---

## Summary
- **28 domains Included** — each with a complete physical design (new domains: full tables/columns/keys/indexes/catalogs/permissions/events/RPCs/dimensions/integration boundary; built domains: referenced + extensions specified).
- **2 domains Excluded with proof** (Warehouse/MRP, Retail POS) — evidence shows they are not part of a Travel ERP/CRM/Revenue platform.
- **3 operational concerns** (Monitoring/Logging/Backup-DR) are platform-ops, not schema domains.
- **No completed phase requires rework.** Every addition is additive around the built Phases 2–7; the foundational domains (party, product/inventory, dimensions, outbox/event-contract, tenant-group, engagement, i18n, entitlements, numbering) are the shared substrate that keeps every other domain additive.

The **product-scope decision is entirely yours** — this register only proves what a complete platform contains and designs each Included domain physically. Approve the domains you want, and I will record the ADRs, integrate the physical design into `24`/`25`/`26`/`27`/`28`/`29`/`31`/`35`, phase it in `32`, and resume execution.

*End of Complete Platform Physical Design & Domain Register. No implementation performed. Awaiting owner product-scope decision.*
