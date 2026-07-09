# ORVION Design Evolution Plan — Complete Platform Design (2026-07-09)

Status: **Proposal for owner approval.** Analysis + design only. NOT a Change Request. Nothing implemented; no completed phase modified; no canonical doc changed; Phase 8 not started. Earn-It suspended **for this review only** (owner decision); it continues to govern implementation.

Purpose: identify everything the platform must be **designed** to support so that no future business capability forces a redesign of the existing foundation. Implementation stays phased; the *design* becomes complete now.

Classification: **CDD = Current Design Dependency** (must enter the design now — retrofitting later would alter existing tables/relationships/aggregates/events/permissions/catalogs/boundaries) · **RC = Roadmap Capability** (already fits the design; only implementation remains) · **FOE = Future Optional Extension** (independent module addable later without touching the foundation).

Design principle applied: for each CDD, define the **complete target model**, but distinguish the **foundational hook that must land early** (a key, discriminator, dimension, or reference that is expensive to add to populated hot tables) from the **body that implements in its phase**. Strongest long-term platform, minimum irreversible commitment.

---

## PART 1 — CURRENT DESIGN DEPENDENCIES (design now; ADR-level where noted)

### CDD-1 · Party / Account model (customer ⇄ supplier ⇄ sub-agent ⇄ corporate) — **ADR**
- **Evidence/why:** ERP standard is a general *party* that can play multiple roles; travel specifically needs **B2B sub-agents** (agencies selling through you), **corporate accounts**, and entities that are **both customer and supplier** (a partner travel company). Today `customers` (person/company) and `suppliers` are disjoint, both hot FKs (`bookings.customer_id`, `payments.customer_id/supplier_id`).
- **Retrofit risk:** high — later B2B/partner/inter-company work would re-point booking/finance FKs.
- **Target design:** a `parties` (or `accounts`) core with `party_roles` (customer/supplier/sub_agent/corporate/partner), or — minimal hook — a nullable `party_id` on `customers`/`suppliers` + a `sub_agent` account type + a customer↔supplier cross-reference. Adds `customer.credit_limit_amount`/`payment_term_code` (BF-3) as AR credit terms.
- **Owner decision:** full party model vs role-extension. **Recommendation:** introduce the `parties` abstraction now (design) with `customers`/`suppliers` as role projections; implement incrementally.

### CDD-2 · Product / Package / Component + Inventory-Allotment model — **ADR**
- **Evidence/why (researched):** dynamic packaging = a product composed of priced components (flight+hotel+transfer+ancillary); Umrah/Hajj/fixed-departure tourism = **fixed departures with seat/room allotments**; NDC = offer/order product model. Today `booking_items` are ad-hoc lines with **no product catalog, no package-component structure, no inventory/allotment**.
- **Retrofit risk:** high — a product/inventory layer sits *under* bookings; adding it later re-parents booking_items.
- **Target design:** `products` (types: package / fixed_departure / service / ancillary), `product_components`, `rate_plans`, `inventory_allotments` (blocks/release), and `booking_items.product_id` + `booking_items.product_component_id` (nullable hooks now). PNR/ticket/confirmation references (**BF-1**) land here as `booking_item_references` (record_locator / ticket_number / confirmation_no) — the GDS/NDC/BSP data slot.
- **Owner decision:** product-catalog + allotment scope. **Recommendation:** design the full product+component+allotment model; add the `product_id`/reference hooks to `booking_items` early; implement packaging/inventory in a Reservations/Packaging phase.

### CDD-3 · Price-component model (base / markup / discount / fee / tax / commission) — **CDD**
- **Evidence/why:** a single `booking_items.selling_amount` cannot express discounts, service fees, taxes, or margin breakdown needed for pricing, promotions, tax, and RI. ERP/travel systems reconcile costs/revenues/margins per component.
- **Retrofit risk:** high — tax/discount/fee reporting later must decompose a single amount across items + invoices.
- **Target design:** `price_components` (line → component_type, amount, tax_code) on booking_items and invoice lines; discount/promo linkage (`promotions`). Folds CDD-12 pricing rules.

### CDD-4 · Tax / VAT model (rates, codes, margin scheme/TOMS) — **CDD** (promotes BF-4)
- **Evidence/why (researched):** travel VAT is often the **margin scheme (TOMS)**; KSA/GCC 15% VAT is directly relevant to Umrah/Hajj operators; invoices must be tax-compliant and reconcilable.
- **Retrofit risk:** high — tax touches invoices, invoice lines, booking items, and ledger posting.
- **Target design:** `tax_codes`/`tax_rates` reference, `tax_code`/`tax_amount` on price components + invoice lines, a `margin_scheme` flag, and tax postings in the ledger. Implement per jurisdiction; **design now**.

### CDD-5 · Full accounting foundation: subledgers + auto-posting + dimensions + periods + AP bills — **ADR** (promotes BF-7)
- **Evidence/why (researched):** a complete ERP posts **every** finance event to a double-entry ledger via **AR/AP/cash subledgers**, tagged with **accounting dimensions** (branch / department / cost-center / trip-booking), within **fiscal periods** (period close), with **currency revaluation**. Today: derived balances + a *manual* journal RPC; **no supplier bills (AP documents), no dimensions, no periods, no auto-posting**.
- **Retrofit risk:** very high — automated posting, dimensions, and periods are cross-cutting to the entire finance layer.
- **Target design:** `journal_entry_lines` gains dimension refs (`branch_id`, `department_id`, `cost_center_id`, `booking_id`); `accounting_periods` (open/closed, period-close events); `supplier_bills` (AP document aggregate) + AP subledger; `credit_notes`/`debit_notes`; posting-rule design so invoices/payments/refunds auto-generate balanced entries; currency revaluation on open AR/AP. **Biggest finance design item.**

### CDD-6 · Document numbering / sequences model — **CDD**
- **Evidence/why:** numbering is currently ad-hoc per RPC (`INV-`, `RCP-`); a complete platform needs configurable **per-tenant, per-doc-type, per-branch, fiscal-year-reset, template-format** sequences across invoices, receipts, credit/debit notes, vouchers, POs, quotations, bills.
- **Retrofit risk:** medium-high — a numbering config replaces logic spread across every numbering RPC.
- **Target design:** `document_sequences` (tenant, doc_type, branch, prefix/format, next_value, reset_policy, gapless_flag) + a shared `app.next_document_number(...)`.

### CDD-7 · Integration foundation + Transactional Outbox — **ADR** (promotes A3 delivery)
- **Evidence/why (researched):** the **transactional outbox** is the industry standard for reliable, at-least-once, idempotent outbound event delivery (Google Ads Data Manager, Meta CAPI, WhatsApp, GDS/NDC, BSP). Today `events` is an **audit log** (no delivery status/retry/dedup); `offline_conversion_deliveries` is one bespoke delivery log — inconsistent to repeat per integration.
- **Retrofit risk:** high — reliable delivery + connection/credential management must be uniform; retrofitting per-integration tables fragments it.
- **Target design:** `integration_connections` (per-tenant external system + config), credential/secret **references** (secrets in Supabase Vault, not the table), `event_outbox` (or a delivery-tracking projection over `events`: status, attempts, next_attempt, dedup key, DLQ), `webhook_inbox` (inbound + idempotent consumer), and delivery-status catalogs. Consumed by Phase 8/10 Edge Functions/n8n.

### CDD-8 · Event contract hardening for Revenue Intelligence — **CDD**
- **Evidence/why:** RI + reliable integrations need a **stable, versioned, typed event contract** with correlation/causation IDs and guaranteed emission on every state change. Today events are free-text `event_type_code` with ad-hoc payloads (ADR-0006) and no version/correlation.
- **Retrofit risk:** medium-high — downstream consumers (RI, ad platforms) break when payload shapes drift.
- **Target design:** event conventions — `schema_version`, `correlation_id`, `causation_id`, a documented payload contract per event type (Event Catalog `27` extended), and an audit that all financial/booking/document state transitions emit. Pairs with CDD-7.

### CDD-9 · Tenant hierarchy / Franchise / Multi-company — **ADR**
- **Evidence/why:** the vision names **Franchise** and **Multi-company SaaS**. Today the model is flat `tenants` + `branches`. Franchises/company-groups need a **tenant hierarchy or group**, possibly **inter-company transactions** and **consolidated reporting**.
- **Retrofit risk:** very high — the tenant model + RLS resolution (`app.current_tenant_id()`, ADR-0013) underlies every table; adding hierarchy later is foundational.
- **Owner decision:** is a franchise a branch, a sub-tenant, or a tenant-group? **Recommendation:** design a `tenant_groups`/`tenant_relationships` layer and confirm the RLS resolution primitive can extend to group scope **without** changing per-table policies (ADR-0013's single-primitive design makes this feasible if decided now).

### CDD-10 · Omnichannel contact-identity & conversation model — **CDD**
- **Evidence/why:** Customer Communications (WhatsApp/email/SMS/in-app) needs **channel identities** (a party's WhatsApp id, email, social handles) and **external thread keys** to route inbound messages to the right party/conversation. `customer_contact_methods` + `conversations`/`conversation_messages` exist but the **channel-identity + external-thread + direction/attachment** contract must be right to avoid reworking inbound routing.
- **Retrofit risk:** medium-high — inbound-message → party resolution is an identity concern.
- **Target design:** channel-typed contact identities, `conversation.channel_code` + `external_thread_id`, message `direction`/`external_message_id`/attachment linkage (reusing Phase-7 documents). Design now; build in the Communications capability.

### CDD-11 · Localization / i18n model — **CDD**
- **Evidence/why:** multi-market vision (Arabic/English minimum for KSA) requires localized **catalog labels**, **document/invoice templates**, and **customer communications**. Catalogs carry a single `name`.
- **Retrofit risk:** medium — retrofitting i18n touches catalog labels + every template.
- **Target design:** a `translations` model (entity_type, entity_id/field, locale, value) or per-catalog localized labels; template localization; party `preferred_language_code` (exists) drives rendering.

### CDD-12 · Pricing/markup/promotion rules — folded into **CDD-2/CDD-3**
- Rate plans + markup rules + promo codes; design alongside the product and price-component models.

---

## PART 2 — ROADMAP CAPABILITIES (fit the existing design; implementation only)

| # | Capability | Fits because |
|---|---|---|
| RC-1 | Subscription/Billing lifecycle + entitlement enforcement | `subscriptions`/`subscription_plans`/`feature_entitlements`/`usage_counters` already modeled; only logic + the state machine (`26`) remain |
| RC-2 | Notification engine (channels, templates, preferences, routing) | `notifications`/`notification_deliveries` exist; channels/templates are additive rows + Edge adapters |
| RC-3 | Approval workflows (discount/refund/credit/override/PO) | `approval_requests` is already generic (`approval_type_code`); add types + guards |
| RC-4 | Reporting & Dashboards (Phase 9) | Read models over the event backbone + derived RPCs; per-department dashboards need no schema change |
| RC-5 | Customer Communications build-out | Conversations exist; **gated on CDD-10** channel model, then additive |
| RC-6 | Google Ads offline conversion delivery (Phase 8) | Tables + delivery state machine exist; **uses CDD-7 outbox** + attribution columns (A3) |
| RC-7 | Document expiry notifications, OTP cleanup, grace→read-only jobs | pg_cron over existing tables (ADR-0018) |
| RC-8 | PNR/ticket references, customer credit limit | Small additive columns — **captured in CDD-2 / CDD-1 so the design is complete** |

---

## PART 3 — FUTURE OPTIONAL EXTENSIONS (independent; add later without touching the foundation)

| # | Module | Independent because |
|---|---|---|
| FOE-1 | HR / Payroll / Employee lifecycle + staff-commission settlement | New aggregates referencing `users`; `sales_owner_user_id`/`commission_rate` hooks already exist on items |
| FOE-2 | Fleet / Vehicle + Guide management + resource scheduling | New aggregates + a booking↔resource link table; no change to existing tables |
| FOE-3 | Procurement / Purchase Orders / physical Warehouse-Inventory | Distinct from travel allotment (CDD-2); office/stock domain, self-contained |
| FOE-4 | Asset lifecycle / depreciation | Extends existing `company_assets` additively |
| FOE-5 | Insurance claims management | Self-contained domain linked to insurance service items |
| FOE-6 | Configurable workflow engine (BPMN-style) | Current hardcoded state machines keep working; an engine is an overlay |
| FOE-7 | Analytics/BI warehouse / semantic layer | A separate read model / consumer of the event outbox |
| FOE-8 | Loyalty / rewards | New aggregate keyed to party; additive |

---

## PART 4 — Required owner decisions (ADR-level) before design integration

1. **Party/Account model** (CDD-1) — full `parties` vs role-extension.
2. **Product/Package/Inventory scope** (CDD-2) — catalog + allotment depth; NDC/GDS alignment.
3. **Accounting depth** (CDD-5) — auto-posting + dimensions + periods + AP bills now-in-design vs phased.
4. **Tenant hierarchy/Franchise** (CDD-9) — branch vs sub-tenant vs tenant-group.
5. **Integration outbox** (CDD-7) — outbox-over-`events` vs a dedicated `event_outbox` table.

Each becomes an ADR; the rest of the CDDs are engineering-derivable once these five are decided.

---

## PART 5 — Proposed integration into canonical docs + roadmap (on approval)

1. **Record 5 ADRs** (the decisions above) in `reports/architecture-decision-records.md`.
2. **Extend canonical design docs** to describe the complete model (implementation stays phased): `24_entity_registry` (new aggregates), `25_catalog_registry` (party_role, product_type, tax_code, dimension, channel, doc_sequence, integration/delivery status, locale), `26_state_machines` (product/allotment, supplier_bill, accounting_period, outbox delivery, conversation), `27_event_catalog` (versioned contract + new events), `28_permissions_matrix` (product/pricing/tax/AP/treasury/integration/comms permissions), `29_relationship_map`, `31_schema_draft` (new tables + the early hooks), and `35`/RLS notes for tenant-group resolution.
3. **Update `32_execution_roadmap`** to insert/assign phases: keep Phase 8 (Offline Conversion) — now built on CDD-7; add phases for Party/Product/Packaging, Finance-Depth (subledgers/tax/periods), Communications, Franchise/Multi-company, and the FOE modules as later independent phases.
4. **Land the early foundational hooks** as small additive migrations at the safest point (nullable `party_id`, `product_id`, `booking_item_references`, ledger dimension columns, `document_sequences`) so the hot tables never need structural retrofits — *these are the only near-term schema touches; everything else implements in-phase.*
5. **`future-backlog.md`** retains only the FOE items with triggers.

---

## Summary

- **12 Current Design Dependencies** (5 ADR-level) should enter the platform **design** now; most implement later, but their **hooks** (nullable keys, ledger dimensions, sequences, outbox) should land early to keep hot tables retrofit-free.
- **8 Roadmap Capabilities** already fit — implementation only.
- **8 Future Optional Extensions** stay independent and out of the current design.
- **No completed phase requires rework**; the foundation is sound and extends by addition — the CDDs are about making the *design* complete and reserving the few expensive-to-add hooks, not re-architecting what exists.

*End of Design Evolution Plan. No implementation performed. Awaiting owner approval of the plan (and the 5 ADR decisions) before any design integration or implementation resumes.*
