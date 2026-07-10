# ORVION Complete Platform Design — Architectural Baseline (2026-07-09)

Status: **Proposal for owner approval.** Design/analysis only. Nothing implemented; no schema, canonical doc, or completed phase modified; Phase 8 not started. Earn-It suspended for this review only.

Purpose: the **complete** ORVION platform design. Every domain concludes as **(A) Complete Domain Design** — fully modelled now, implementation phased, no future foundation redesign — or **(B) Independent Optional Extension** — proven addable later touching **no** existing table/relationship/aggregate/permission/event/catalog/boundary. Optimised for the **fewest future architectural revisions**, not the smallest schema.

**Decision rule applied:** a domain is B **only if** it is genuinely additive *given the foundational domains are fully designed*. The central finding: fully designing **13 foundational domains (A)** converts **~12 operational domains to true Independent Optional Extensions (B)**.

**Method:** research-validated (ERP GL/subledger/dimensions, transactional outbox, dynamic packaging/NDC, IATA BSP, TOMS/VAT, WhatsApp Cloud API, Supabase/PostgreSQL). Architectural choices made here with evidence; genuine ties flagged for owner.

Notation per domain: **Aggregates/tables · Key relationships · Catalogs · Statuses/state-machines · Events · Permissions · Dimensions · Integration/AI boundary · Conclusion (A/B) · Touches existing?**

---

# PART I — FOUNDATIONAL DOMAINS (Complete Domain Design = A)

## 1. Party / Account & Identity — **A**
Unifies customers, suppliers, sub-agents, corporate accounts, partners, employees (ERP party model; resolves the customer⇄supplier duality).
- **Aggregates:** `parties` (party_kind: person|organization; name, legal fields, tax_id, preferred_language_code, primary contact), `party_roles` (party_id, role: customer|supplier|sub_agent|corporate|partner|employee|guide, status, role-specific attrs incl. **AR credit_limit/terms** for customer, **AP credit_limit/payment_term** for supplier), `party_relationships` (parent/child: corporate→travellers, agency→sub-agents, group leader), `party_contact_identities` (channel-typed: phone|email|whatsapp|instagram|external, value, verified, consent flags — unifies inbound routing), `party_identity_signals`/`party_merges` (dedup/merge — exists for customers, generalised).
- **Relationships:** existing `customers`/`suppliers` become **role projections** with `party_id`; `bookings`/`invoices`/`payments` continue to reference customer/supplier (unchanged) but a party lens is available.
- **Catalogs:** party_kind, party_role, party_relationship_type, contact_channel, id_document_type.
- **Events:** party_created/updated/merged, role_granted/revoked, consent_changed.
- **Permissions:** MANAGE_PARTY, VIEW_PARTY, MERGE_PARTY (extends MERGE_CUSTOMER_IDENTITY), MANAGE_CREDIT_TERMS.
- **Touches existing:** yes (adds `party_id` to customers/suppliers; contact identities generalise `customer_contact_methods`). **→ foundational, design now.**

## 2. Product, Packaging, Inventory & Supplier Contracts — **A**
Dynamic packaging + fixed departures (Umrah/Hajj) + allotments + negotiated rates (research: dynamic packaging, NDC, allotment inventory).
- **Aggregates:** `product_categories`; `products` (product_type: service|package|fixed_departure|ancillary; sellability, default rate); `product_components` (package → child products with qty/sequence); `product_variants`/`product_constraints` (options, min/max pax, date rules); `package_departures` (fixed departure dates, capacity); `supplier_contracts` (party(supplier)_id, validity, terms) + `supplier_rates` (contracted cost by product/date/occupancy); `inventory_allotments` (blocks held per product/departure/date) + `allotment_releases`; `availability` (derived or cached).
- **Relationships:** `booking_items.product_id` + `product_component_id` (nullable — ad-hoc items still allowed); `booking_item_references` (record_locator/PNR, ticket_number, confirmation_no, supplier_ref — the GDS/NDC/BSP data slot, **BF-1**).
- **Catalogs:** product_type, product_category, component_role, allotment_status, departure_status.
- **State machines:** product (draft→active→retired), departure (open→guaranteed→closed→departed), allotment (held→confirmed→released→expired).
- **Events:** product/departure/allotment lifecycle; booking_item_reference_recorded.
- **Permissions:** MANAGE_PRODUCT, MANAGE_INVENTORY, MANAGE_SUPPLIER_CONTRACT, VIEW_PRODUCT.
- **Integration/AI:** GDS/NDC/hotel-API sync populates products/availability/references via the Integration Layer (§7); AI cross-sell reads the product graph.
- **Touches existing:** yes (booking_items gains product/reference linkage). **→ foundational, design now.**

## 3. Pricing, Markup, Discounts & Promotions — **A**
Replaces single `selling_amount` with a component breakdown (needed for tax, margin, discounts, RI).
- **Aggregates:** `price_components` (owner = quote line | booking_item | invoice line; component_type: base|markup|discount|fee|tax|commission; amount, currency, tax_code); `pricing_rules`/`markup_rules` (by product/category/party/channel); `promotions`/`discount_codes` (validity, caps, eligibility).
- **Relationships:** booking_items keep `selling_amount`/`cost_amount`/`commission_rate` as roll-ups; the breakdown lives in `price_components`.
- **Catalogs:** price_component_type, pricing_rule_type, promotion_type.
- **Events:** price_calculated, discount_applied, promotion_redeemed.
- **Permissions:** MANAGE_PRICING, APPLY_DISCOUNT (conditional), MANAGE_PROMOTION.
- **Touches existing:** additive around booking_items/invoices. **→ foundational, design now.**

## 4. Tax / VAT — **A** (promotes BF-4)
Research: travel VAT margin scheme (TOMS); KSA/GCC 15%.
- **Aggregates:** `tax_authorities`, `tax_codes`, `tax_rates` (rate, validity, jurisdiction), `tax_schemes` (standard|margin/TOMS|zero|exempt).
- **Relationships:** `tax_code` on price components + invoice lines; tax postings to GL (§5); margin-scheme computation over product margin.
- **Catalogs:** tax_scheme, tax_code.
- **Events:** tax_calculated.
- **Permissions:** MANAGE_TAX_CONFIG.
- **Touches existing:** invoices/lines gain tax linkage (via price_components). **→ foundational, design now.**

## 5. Accounting, Finance, Treasury — **A** (promotes BF-7; absorbs Treasury, Cost Centers, Accounting)
Research: multi-dimensional GL, **required dimensions with N/A**, automated subledger→GL posting, locked FX + periodic revaluation, period close.
- **General Ledger:** `chart_of_accounts` (exists) + `account_types`; `accounting_dimensions` (dimension_type: branch|department|cost_center|project_trip; **required with an "N/A" member**) + `journal_entry_dimensions` (or dimension columns on `journal_entry_lines`); `accounting_periods` (open/closed, per fiscal calendar) + `fiscal_calendars`.
- **Subledgers + auto-posting:** `posting_rules` (source event → balanced GL template) so invoice/payment/receipt/refund/bill auto-generate entries; **AR** (customer invoices/payments — exists) and **AP** (`supplier_bills` = AP documents + supplier payments — closes the derived-payable gap); `credit_notes`/`debit_notes`.
- **Treasury:** `financial_accounts` (exists) + `bank_statements` + `bank_reconciliations` + `account_transfers` + `cash_sessions` (till open/close); FX: `exchange_rates` (exists) + `currency_revaluation` runs on open AR/AP.
- **Numbering:** `document_sequences` (tenant, doc_type, branch, format, next_value, fiscal reset, gapless flag) + `app.next_document_number()` — replaces per-RPC numbering (invoice/receipt/CN/DN/bill/PO/voucher).
- **Catalogs:** account_type, dimension_type, journal_source_type, period_status, reconciliation_status, bill_status, note_type.
- **State machines:** period (open→closed→locked), supplier_bill (draft→approved→paid), reconciliation (open→matched→closed).
- **Events:** journal_posted, period_closed, bill lifecycle, revaluation_posted, reconciliation_completed (all with dimensions).
- **Permissions:** POST_JOURNAL (exists CREATE_JOURNAL_ENTRY), MANAGE_PERIOD, APPROVE_BILL, RECONCILE_ACCOUNT, MANAGE_DIMENSIONS.
- **Dimensions:** every posting carries branch/department/cost_center/trip → powers all financial dashboards (§ Reporting) without redesign.
- **Touches existing:** journal_entry_lines gains dimensions; invoices/payments gain posting linkage. **→ foundational, design now** (biggest finance design item).

## 6. Multi-tenant, Branches, Franchise, Multi-company — **A**
- **Aggregates:** `tenants` (exists) + `tenant_groups` (franchise/company group) + `tenant_relationships` (parent/child, inter-company); `branches`/`departments` (exist) as intra-tenant org.
- **RLS:** the single resolution primitive (`app.current_tenant_id()`, ADR-0013) extends to **group scope** in one place — no per-table policy change (this is exactly why the single-primitive design was chosen). Inter-company transactions post to both entities' ledgers (§5).
- **Catalogs:** tenant_relationship_type.
- **Events:** tenant_group_changed, intercompany_posted.
- **Permissions:** platform/service_role for group admin; MANAGE_TENANT_GROUP.
- **Touches existing:** tenant resolution + optional `tenant_group_id`. **→ foundational, design now.**

## 7. Integration Layer + Transactional Outbox — **A** (promotes A3 delivery; enables Google/Meta/WhatsApp/GDS/NDC/BSP/n8n)
Research: transactional outbox = standard for reliable at-least-once + idempotent delivery; WhatsApp/webhook-driven.
- **Aggregates:** `integration_providers` (registry: google_ads|meta_capi|whatsapp|ga4|gtm|gds|ndc|bsp|n8n|generic), `integration_connections` (per-tenant provider config; **secrets in Supabase Vault**, table holds refs only), `integration_sync_state`, `event_outbox` (event_id, destination, payload, status, attempts, next_attempt_at, dedup_key, DLQ) — a **delivery projection** over `events`; `webhook_inbox` (inbound raw + idempotent consumer keyed by external id — WhatsApp/Meta/GDS callbacks).
- **Event contract hardening (§8):** outbox carries versioned/correlated payloads.
- **Catalogs:** integration_provider, delivery_status, webhook_status.
- **State machines:** outbox delivery (pending→sent→acked|failed→retry→dead), webhook (received→processed|failed).
- **Events:** integration_connected, delivery_sent/failed, webhook_received.
- **Permissions:** MANAGE_INTEGRATION, VIEW_INTEGRATION_LOGS.
- **AI/MCP boundary:** MCP tools and AI agents act through RPCs and observe via the outbox/events — this layer is the platform's outbound nervous system.
- **Touches existing:** adds delivery tracking around `events`. **→ foundational, design now.**

## 8. Event Backbone & Revenue-Intelligence Contract — **A**
- **Design:** event conventions — `schema_version`, `correlation_id`, `causation_id`, actor, entity, typed payload contract documented per event type (Event Catalog `27` extended); guaranteed emission on every financial/booking/document/party state change; append-only + DB-enforced immutability (backlog B4).
- **RI posture:** ORVION emits verified events/values; the **outbox** (§7) delivers to consumers (Google Data Manager, Meta CAPI, BI). RI itself is a **consumer** (Part II, B) — but the *contract* it depends on is designed here.
- **Touches existing:** event schema conventions + immutability. **→ foundational, design now.**

## 9. Customer Engagement — Communications + Notifications + Templates + Consent — **A**
Research: WhatsApp Cloud API webhook model, message status (sent/delivered/read), template categories (marketing/utility/authentication/service), omnichannel inbox.
- **Aggregates:** `conversations` (exists; add channel_code, external_thread_id, assignment, state) + `conversation_messages` (exists; add direction, external_message_id, status, template_id, attachments→documents); `message_templates` (channel, category, locale, variables, approval status) ; `notifications`/`notification_deliveries` (exist) + `notification_rules` + `notification_preferences` (per party/channel) + `consent_records` (opt-in/out per channel — GDPR/WhatsApp policy).
- **Relationships:** inbound routing uses `party_contact_identities` (§1) + `webhook_inbox` (§7).
- **Catalogs:** channel_code, message_direction, message_status, template_category, notification_event.
- **State machines:** conversation (open→assigned→pending→escalated→closed — exists), message (queued→sent→delivered→read|failed).
- **Events:** message_received/sent/status_changed, template_submitted, consent_changed, notification_sent.
- **Permissions:** VIEW_CONVERSATION/SEND_MESSAGE (exist), MANAGE_TEMPLATE, MANAGE_NOTIFICATION_RULES.
- **Touches existing:** conversations/messages gain channel + status fields; contact identities. **→ foundational, design now** (company-owned comms replace personal WhatsApp).

## 10. Localization / i18n — **A**
- **Aggregates:** `locales`; `translations` (entity_type, entity_id_or_field_key, locale, value) for catalog labels, product content, templates, document layouts.
- **Relationships:** party `preferred_language_code` (exists) drives rendering; templates (§9) + documents (§11) localised.
- **Touches existing:** catalogs/templates gain localisation. **→ foundational, design now** (Arabic/English + multi-market).

## 11. Document Management — **A** (Phase 7 built; complete it)
- **Add:** `document_sequences` (via §5), `document_templates` (localised, per doc_type — invoice/voucher/itinerary), retention/expiry policies, and an **e-signature status** field (external e-sign is FOE, but the status slot is designed). Documents already polymorphic + versioned + lifecycle (Phase 7).
- **Touches existing:** additive to the document domain. **→ complete now.**

## 12. Subscription, Billing, Entitlements, Feature Flags — **A**
Clarifies **two billing planes** (a real design point, decided here):
- **Platform→Tenant (SaaS):** `subscription_plans`/`subscriptions`/`feature_entitlements`/`usage_counters` (exist) + `feature_flags` (runtime toggles, distinct from plan entitlements) + `platform_invoices`/metering. Enforcement primitive `app.has_feature(feature_code)` alongside `app.has_permission`.
- **Tenant→Customer (operations):** the Finance domain (§5). Kept distinct from tenant isolation (ADR-0013).
- **Catalogs:** feature_code, plan_code, entitlement_type, billing_status.
- **Events:** subscription lifecycle (state machine `26`), feature_flag_changed, usage_metered.
- **Touches existing:** additive (`feature_flags`, platform billing). **→ complete now.**

## 13. Audit, Security, Access — **A** (built; harden)
- Events + security_events (audit — exist) + immutability (B4); RBAC (`role_permissions`, ADR-0015) + `app.authorize` + `app.has_feature`; RLS (ADR-0013) + group scope (§6). MFA via `aal` (ADR-0017).
- **Touches existing:** immutability trigger + feature gating. **→ complete now.**

---

# PART II — INDEPENDENT OPTIONAL EXTENSIONS (B) — proven additive given Part I

Each references only Part-I foundations and adds **new** aggregates; **no** existing table/relationship/permission/event/catalog/boundary changes.

| Domain | Why genuinely B (additive) | References |
|---|---|---|
| **HR / Payroll / Staff-commission settlement** | Employee = party(person)+employee role (§1); payroll posts via auto-posting (§5); commissions read `booking_items.commission_rate`+`sales_owner` | Party, Accounting |
| **Revenue Intelligence / Analytics / BI warehouse** | Pure consumer of the event **outbox** + versioned contract (§7/§8) + finance **dimensions** (§5); no write-side change | Outbox, Event contract, Dimensions |
| **AI Agents / MCP** | Act via existing RPCs; observe via events/outbox; MCP server exposes read/act tools — the agent boundary *is* the RPC+event surface already designed | Integration, Events, RPC surface |
| **Reporting / Dashboards** | Read models over events + accounting/operational **dimensions** (designed in §5/§2); every department dashboards without schema change | Dimensions, Events |
| **Workflow Engine (configurable)** | Overlay; `approval_requests` generic (exists) keeps working; engine adds its own tables | Events, Approvals |
| **Fleet / Vehicles / Guides / Resource scheduling** | Resources = party/supplier (§1) + a booking↔resource assignment table | Party, Booking |
| **Procurement / Purchase Orders / Warehouse-stock** | POs → AP `supplier_bills` (§5); physical stock distinct from travel allotment (§2) | Accounting, Party |
| **Asset lifecycle / depreciation** | Extends `company_assets`; depreciation auto-posts (§5) | Accounting |
| **Insurance claims** | New aggregate linked to insurance product items (§2) | Product |
| **Loyalty / rewards** | Points keyed to party (§1) | Party |
| **Full-text Search** | Additive Postgres FTS (`tsvector`/`pg_trgm`) indexes/generated columns; no relational change | — |
| **Monitoring / Logging / Backup / DR** | Operational/infra (Supabase PITR, external observability); not schema domains | — (ops) |

**These stay in `future-backlog.md` with triggers. They are the only domains that legitimately remain outside the current design.**

---

# PART III — Cross-cutting foundations designed once (used everywhere)

- **Dimensions** (branch/department/cost_center/trip) — one model, consumed by finance, reporting, RI.
- **Document numbering** (`document_sequences`) — one model, all documents.
- **Transactional outbox + webhook inbox** — one model, all integrations.
- **Event contract** (versioned/correlated/typed) — one model, all consumers/AI/RI.
- **Party + contact identities + consent** — one model, all CRM/comms/finance counterparties.
- **i18n translations** — one model, all labels/templates/documents.
- **Feature entitlements + flags** — one model, all plan/runtime gating.
- **RLS single primitive + group scope** — one model, all tenant/franchise isolation.

---

# PART IV — ADRs to record (decisions made here; owner confirms)

1. **ADR — Party/Account model** (unified `parties` + roles; customers/suppliers as projections).
2. **ADR — Product/Packaging/Inventory + Supplier Contracts** (product graph, allotments, departures, rates; booking_items link to product + references).
3. **ADR — Pricing & Tax model** (price-component breakdown; tax_codes + margin scheme).
4. **ADR — Full accounting foundation** (dimensions required, subledger auto-posting, periods, AP bills, treasury, revaluation, document_sequences).
5. **ADR — Tenant hierarchy / Franchise** (tenant_groups + relationships; RLS group scope via the single primitive).
6. **ADR — Integration Layer + Transactional Outbox** (providers/connections/outbox/webhook-inbox; secrets in Vault).
7. **ADR — Event contract & Revenue-Intelligence posture** (versioned/correlated events; outbox-delivered; RI/AI as consumers).
8. **ADR — Customer Engagement** (omnichannel conversations/templates/consent; company-owned comms).
9. **ADR — Subscription/Billing two-plane model + feature flags** (platform-billing vs operations-billing; `has_feature`).
10. **ADR — Localization model.**

No genuine ties remain requiring an owner choice among equivalents — each decision has a clear evidence-supported winner above. Owner confirmation is sought on scope/appetite, not on picking an architecture.

---

# PART V — Integration into canon + roadmap (on approval; NOT started)

1. **Record ADRs 1–10** in `reports/architecture-decision-records.md`.
2. **Extend canonical design docs to the complete model** (design complete; implementation phased): `24_entity_registry` (all new aggregates), `25_catalog_registry` (all new catalogs above), `26_state_machines` (product/departure/allotment, period, bill, reconciliation, outbox, message), `27_event_catalog` (versioned contract + all new events), `28_permissions_matrix` (all new permissions + feature codes), `29_relationship_map`, `31_schema_draft` (all new tables + the columns added to existing tables), `35`/RLS (group scope).
3. **Update `32_execution_roadmap`** to phase implementation: Phase 8 Offline Conversion (on the outbox); then Party, Product/Packaging/Inventory, Finance-Depth (dimensions/subledger/tax/periods/treasury), Engagement, Franchise/Multi-company, Localization — each a phase. Part-II (B) modules become later independent phases pulled on business demand.
4. **`future-backlog.md`** keeps only the Part-II (B) items with triggers.

---

# Executive conclusion

- **13 foundational domains are now completely designed (A).** Implementation stays phased; **no future redesign of the foundation should be required.**
- **~12 operational domains are proven Independent Optional Extensions (B)** — addable later with **zero** change to the designed foundation.
- The leverage is the **cross-cutting foundations** (dimensions, outbox, event contract, party, numbering, i18n, entitlements, RLS-group): design each **once**, and every downstream domain (reporting, RI, AI, HR, procurement, fleet, loyalty…) becomes additive.
- **No completed phase requires rework.** The current build (Phases 2–7) sits inside this design as-is; the plan adds and extends, never re-architects what exists.

*End of Complete Platform Design baseline. No implementation performed. Awaiting owner approval to record the ADRs, integrate the design into canon + roadmap, and resume phased execution.*
