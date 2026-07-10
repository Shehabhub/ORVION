# ORVION MASTER ENTITY-RELATIONSHIP MAP

Status: **Permanent CRUD + reference map.** Never recreate; evolve. For each major entity: who creates/reads/updates/deletes it, what it references, and what references it. Deletion is **archive-not-delete** platform-wide (ADR-0007); "Delete" = archive/soft unless noted. Full column specs: `complete-platform-physical-design-2026-07.md`. Cross-reference: `29_relationship_map.md` (canon), `MASTER_DOMAIN_CATALOG.md`.

Last updated: 2026-07-11. Actor = the RPC/role that performs the action (RLS-scoped to tenant). `[D]` = designed, not built.

| Entity | Create | Read | Update | Archive | References (FK →) | Referenced by |
|---|---|---|---|---|---|---|
| tenants | provision_tenant (service_role) | members | platform | — | — | ~57 tenant tables |
| users | create_tenant_user / provision_tenant | tenant members | user-mgmt RPCs | is_active=false | tenants, auth.users | assignments, leads, bookings, events (actor) |
| leads | create_lead (CREATE_LEAD) | sales/managers | advance_lead, assign | closure state | tenant, branch, department, customer, `[D]`attribution_clicks | lead_assignments, interactions, conversations, bookings(via readiness) |
| customers | create_customer | sales/finance | update RPCs, merge | merge/archive | tenant, `[D]`party_id | leads, bookings, invoices, payments, refunds, quotations, complaints, conversations, passengers(via booking) |
| suppliers | supplier mgmt | ops/finance | update | archive | tenant, `[D]`party_id | booking_items, supplier payments, `[D]`supplier_bills, supplier_rates |
| bookings | create_booking | sales/ops/finance | advance_booking | cancel/void | tenant, customer, lead, branch, department | booking_items, invoices, offline_conversions, documents(link) |
| booking_items | create_booking_item | ops/finance | advance_booking_item, finance-gate | cancel | booking, supplier, `[D]`product_id/refs | booking_item_passengers, invoices(line), profit, payments(alloc), `[D]`resource_assignments, commission_settlements |
| passengers | create_passenger | ops | update | archive | tenant, customer | booking_item_passengers, documents(passport), `[D]`passenger_relationships |
| invoices | create_invoice, issue_invoice | finance | issue/void | void | tenant, customer, booking, booking_item | payment_allocations, `[D]`invoice_lines, credit_notes, receipts |
| payments | record_payment / record_supplier_payment | finance | — (immutable-ish) | — | tenant, customer/supplier, financial_account | payment_allocations, journal_entries, `[D]`bill_allocations |
| payment_allocations | record_payment | finance | — | — | payment, invoice | customer_balance (derived) |
| refunds | record_refund, advance_refund | finance | advance | — | tenant, customer/supplier, booking | journal_entries, customer_balance |
| journal_entries | create_journal_entry, `[D]`post_transaction | finance/audit | — (append) | — | tenant, source doc | journal_entry_lines |
| journal_entry_lines | create_journal_entry | finance | — | — | journal_entry, chart_of_accounts, `[D]`dimensions | GL reports |
| documents | upload_document | per-permission + financial_documents gate | add_version, archive | archive | tenant, uploader | document_versions, document_links |
| document_links | upload_document | RLS | — | — | document, target (passenger/booking/item/invoice/receipt/supplier) | — |
| events | record_event | audit_read (tenant) | **blocked (immutable)** | never | tenant, actor_user, entity | RI/AI/outbox `[D]`, dashboards |
| approval_requests | request_finance_approval | reviewers | review_finance_approval | — | tenant, target item | finance gate, `[D]`other approval types |
| conversations | comms RPCs `[D]` | assigned users | assign/close | archive | tenant, customer, lead, `[D]`channel | conversation_messages |
| subscriptions | provisioning + `[D]`lifecycle | owner/platform | `[D]`upgrade/suspend | — | tenant, subscription_plan | subscription_payment_proofs, usage_counters |
| `[D]`parties | upsert_party | tenant | grant_role, merge_party | archive | tenant | customers, suppliers, employees, contact_identities, consent_records |
| `[D]`products | create_product | ops | update, retire | retire | tenant, category, default_supplier | product_components, package_departures, supplier_rates, booking_items |
| `[D]`inventory_allotments | hold_allotment (FOR UPDATE, DC-3) | ops | release_allotment | expire | product, departure, contract | allotment_movements, booking_items |
| `[D]`supplier_bills | approve_bill | finance | approve/void | void | supplier, booking | supplier_bill_lines, bill_allocations, AP balance |
| `[D]`event_outbox | enqueue_delivery (selective) | integration | claim/mark (SKIP LOCKED) | archive-delivered | events, connection | connectors |

## Referential integrity rules (standing)
- Every tenant entity: `tenant_id NOT NULL → tenants` (RLS predicate; V5: NOT NULL is what triggers RLS coverage).
- FK default `on delete restrict on update no action` (ADR-0007); cascade/set-null opt-in with justification.
- Merge completeness: any new table referencing `customers`(and `[D]`parties) auto-participates in merge via dynamic FK discovery (ADR-0019) unless explicitly excluded.
- Boundary rule (Synth §7): a domain may reference another's aggregate by FK but writes it only through that domain's RPC.
- **DC-13:** high-insert entities (events, security_events, conversation_messages, attribution_clicks, campaign_daily_metrics, notification_deliveries) → UUIDv7 PK.
