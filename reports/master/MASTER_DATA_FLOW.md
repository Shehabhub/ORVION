# ORVION MASTER DATA FLOW

Status: **Permanent business-flow map.** Never recreate; evolve. Every major end-to-end flow, showing the objects/events/RPCs each step touches and where designed (`[D]`) steps slot in. Proves no flow terminates prematurely (the workflow-completeness standard). Cross-reference: `MASTER_ENTITY_RELATIONSHIP_MAP.md`, `27_event_catalog.md`.

Last updated: 2026-07-11.

## Flow 1 — Revenue lifecycle (the spine)
```
Ad click (Google/Meta/Framer)
  → [D]attribution_clicks (gclid/gbraid/wbraid + consent, R5)     evt: —
Lead  → create_lead                                              evt: lead_created
  → assign_lead_round_robin                                      evt: lead_assigned
  → record_lead_interaction / process_lead_sla                   evt: lead_sla_warning/reassigned
Customer  → convert_lead → create_customer                       evt: lead_converted
  → lead_booking_readiness (canonical handoff)
Booking  → create_booking                                        evt: booking_created
Booking Item  → create_booking_item (+[D]product_id, ticketing_deadline DC-7)
  → link_passenger_to_booking_item / link_internal_supplier      evt: booking_item_added
  → request_finance_approval → review_finance_approval           evt: finance_approval_*
  → advance_booking_item (finance-gated)                         evt: booking_item_issued (+[D]PNR/ticket ref BF-1)
Invoice  → create_invoice → issue_invoice (+[D]invoice_lines R3, tax BF-4)  evt: invoice_issued
Payment  → record_payment → payment_allocations                 evt: payment_received
  → issue_receipt                                                evt: receipt_issued
Journal  → [D]post_transaction (auto-posting CDD-5, +dimensions R2, +realized FX DC-11)  evt: journal_posted
Balances → customer_balance / supplier_balance / booking_item_profit (derived, INV-1..4)
Reports  → [D]read models/matviews (RC-4, 0 today V6)
Revenue Intelligence → [D]event_outbox (selective C2) consumes events
Offline Conversion → offline_conversions → offline_conversion_deliveries (pending→sent→failed→retried)
Google Ads ← [D]Data Manager API (consent-gated) via Edge relay
```
**Completeness:** every step has table+event+RPC. Open hooks: R2/R3/R5, BF-1, BF-4, DC-1(money across all money steps), DC-7, CDD-5/7, RC-4.

## Flow 2 — Supplier / payable
```
Booking Item cost (locked at finance approval)
  → [D]supplier_bills + supplier_bill_lines (AP doc, BF-7)       evt: bill_approved
  → record_supplier_payment → [D]bill_allocations               evt: supplier_payment_recorded
  → supplier_balance ([D]re-defined: approved bills − payments, INV-3)
  → [D]BSP/statement reconciliation (bank_reconciliations)
```

## Flow 3 — Document lifecycle
```
upload_document → documents + document_versions + document_links (polymorphic)
  → [D]binary bytes → Supabase Storage bucket + Storage RLS (DC-5)
  → add_document_version / archive_document
  → expiring_documents (pg_cron surfacing) → notifications
  → financial_documents (stricter visibility gate)
```

## Flow 4 — Identity & access
```
provision_tenant (service_role) → tenant + owner users + owner role
  → create_tenant_user → activate_membership
  → assign_user_role / assign_user_branch
  → authorize / has_permission (RBAC) + requires_mfa / mfa_satisfied (aal)
  → record_trusted_device / OTP (Supabase Auth)
  → [D]erase_party (DC-4) / export_tenant (DC-14) on lifecycle end
```

## Flow 5 — Group / Umrah-Hajj operations
```
Booking (group) → [D]groups + group_members (BF-2)
  → passengers → [D]passenger_relationships (mahram/family, DC-12)
  → [D]product=fixed_departure + package_departures + inventory_allotments (hold FOR UPDATE, DC-3)
  → documents (passport, vaccine cert) → expiring_documents
  → [D]resource_assignments (guide/vehicle, BF-12)
```

## Flow 6 — Communications
```
Inbound (WhatsApp/email) → [D]webhook_inbox (idempotent)
  → resolve to [D]party_contact_identities → conversation (+[D]channel_code)
  → conversation_messages (+[D]direction/status) → [D]realtime publication (DC-17)
  → [D]consent_records checked before outbound (N5)
Outbound → [D]message_templates → [D]event_outbox → WhatsApp/Meta via Edge
```

## Flow 7 — Subscription / SaaS billing (platform→tenant)
```
provision_tenant (trial)
  → [D]subscription lifecycle: subscriptions + feature_entitlements + usage_counters
  → subscription_payment_proofs (bank-transfer proof) → owner review
  → [D]has_feature + [D]meter_usage gate capabilities (N2 permission×feature)
  → grace → read-only transitions (pg_cron, RC-1)
```

## Flow 8 — Self-healing / integrity (DC-8)
```
pg_cron → [D]reconciliation RPCs
  → detect stuck states (orphaned pending approval, held allotment never released,
     payment on voided invoice, booking wedged in transitional status)
  → auto-heal OR emit reconciliation_finding event → notification/dashboard
  → [D]reconciliation_runs log
```

**Standing check (every review):** trace each flow end-to-end; any step lacking table/event/RPC/permission/report becomes a `MASTER_GAP_REGISTER.md` finding. As of 2026-07-11 no flow terminates prematurely at the design level; open items are the `[D]` hooks listed per flow.
