# ORVION Final Architecture Proof & Design Completion Review (2026-07-11, session 3)

Status: **Final Design Proof (analysis only).** Nothing implemented; no schema, canonical doc, or completed phase modified; Phase 8 not started. Purpose: attempt to BREAK the architecture at the **concept/pattern/question** level (not tables), then deliver a definitive TRUE/FALSE verdict on the completion statement. Builds on all prior reviews + the 12 MASTER documents; nothing overwritten.

**Verdict (proven below): the completion statement is currently FALSE, for exactly two enumerated reasons — a canon-integration gap and ten newly-discovered meta-pattern concepts (DC-20…29). After designing those (done here at spec level) and ratifying+integrating the design into Canon, the statement becomes TRUE. The conceptual discovery is now closed: the 30-vendor lens sweep + architecture stress test produced no finding beyond DC-20…29.**

---

## 1. Method — attack the meta level
Prior sessions exhausted the table/domain level (finding universe DC-1…19, R1–R8, A/B, BF-1…12, CDD, N, INV, RC, FOE, OPS — all in `MASTER_GAP_REGISTER.md`). This session attacked the categories the prompt names: missing **concepts, patterns, and unasked questions**. Ten survived as genuine gaps. Each below carries the required field set.

## 2. New findings (meta-pattern level — missed by every prior review because they are not tables)

### DC-20 — Metadata / custom-field / custom-object extensibility — **Required, High**
- **Evidence:** `catalog_values` gives tenant-extensible *dropdowns*, but no tenant can add a *field* or *object* to customers/bookings. Every enterprise SaaS CRM (Salesforce, HubSpot, Dynamics, Odoo) provides tenant custom fields — a defining SaaS pattern.
- **Root cause:** all reviews examined ORVION's *own* schema; none asked "can a tenant extend the model without a code deploy?" **Why missed:** table-level lens, not platform-extensibility lens.
- **Business/technical/architectural impact:** agencies with bespoke needs revert to Excel for the one field ORVION lacks; retrofitting an extensibility layer after entities are hot is invasive.
- **Design:** `custom_field_definitions(tenant_id, entity_type_code, field_key, data_type_code, config jsonb, uq(tenant,entity_type,field_key))` + storage either `custom_field_values(entity_type, entity_id, field_id, value)` OR a `custom_fields jsonb` column on major entities validated against the definitions registry. Includes **white-label theming** (per-tenant branding as metadata). **Catalogs:** custom_field_data_type. **Permissions:** MANAGE_CUSTOM_FIELDS. **Events:** custom_field_defined. **AI/MCP:** the definitions registry lets AI/MCP discover tenant schema. **Additive.** **Batch:** 1 (substrate). **Depends on:** none. **Modifies existing:** adds jsonb column to major entities (choose additive-column vs value-table). **Recommendation:** design now; jsonb-column approach keeps it additive.

### DC-21 — Hijri (Islamic) calendar support — **Required, Med-High (core market)**
- **Evidence:** all dates are Gregorian (`date`/`timestamptz`); **Umrah/Hajj operate on the Hijri calendar** — Hajj is Dhul-Hijjah, visa validity and package departures are pilgrim-facing in Hijri. ORVION's named departments are Umrah/Hajj.
- **Root cause:** Gregorian assumed; the travel-domain calendar was never questioned. **Why missed:** no reviewer asked "what calendar do our pilgrims think in?"
- **Impact:** Umrah/Hajj staff mentally convert dates / use external tools; season logic (Hajj/Ramadan windows) can't be expressed.
- **Design:** no new tables required for storage (keep `timestamptz` as the instant); add **Hijri rendering** (presentation) + optional `hijri_date` generated column on `package_departures`/visa validity + calendar-aware business rules; `calendar_system` catalog; tenant/party preferred calendar. **Additive.** **Batch:** 5 (reservations/localization) — **design now**. **Recommendation:** store Gregorian instant, render Hijri, express season rules against Hijri.

### DC-22 — Data residency / multi-region strategy — **Required, Med-High (compliance)**
- **Evidence (validated 2026):** **Saudi PDPL is enforced** — personal data must stay in-Kingdom by default, cross-border transfer restricted to "equivalent protection", fines up to **SAR 5M/breach** (SDAIA). EU GDPR imposes analogous localization/transfer controls. ORVION processes **pilgrim PII** and is hosted on a **single region-pinned Supabase project**.
- **Root cause:** all reviews were single-region schema-level; residency is a deployment-topology + legal concern with no owning domain. **Why missed:** nobody asked "where must this data physically live?"
- **Impact:** legal exposure (SAR 5M) + blocked KSA/EU enterprise deals; ad-data transfer to Google/Meta needs transfer controls.
- **Design:** `tenants.data_region`; a residency policy mapping tenant→region; per-region Supabase project topology (tenant provisioning routes to the correct region); cross-border transfer controls on the integration layer (Google/Meta). **Integrations:** ad-platform transfer gating. **Architectural impact:** provisioning + deployment topology (significant); schema touch is small (`data_region`). **Additive** (column) + **deployment decision**. **Batch:** 2 (compliance). **Recommendation:** decide single-region-per-tenant topology now; add the region column as a Batch-0 hook.

### DC-23 — Public API contract + versioning + rate-limiting — **Required, Medium**
- **Evidence:** ADR-0014 defers an API gateway; PostgREST auto-exposes tables once DML grants land (B5); `ACCESS_API_READ_ONLY/FULL` permissions are seeded with no consumer model, no API versioning, no rate-limit/quota. Vision names mobile/external API consumers.
- **Root cause:** no client surface yet → deferred without design. **Why missed:** "future" surface, but the *contract/versioning strategy* is architectural.
- **Design:** `api_clients`/`api_keys` (per-tenant, scoped), rate-limit/quota config (ties to usage_counters), an explicit API-versioning policy (URL/path vs header; PostgREST schema-versioning), a stable public contract vs internal RPC surface. **Additive.** **Batch:** 2 (with B5 grants). **Recommendation:** design the versioning + key/quota model before the first external consumer.

### DC-24 — Tenant-custom roles/permissions — **Required, Medium**
- **Evidence:** `roles` + `permissions` are **global-seeded** (9 roles, 64 permissions); a tenant cannot define its own role or grant. Enterprise multi-tenant SaaS supports per-tenant roles.
- **Root cause:** RBAC modeled as a fixed global set (ADR-0015); tenant-extensibility never asked. **Design:** allow tenant-scoped roles (`roles.tenant_id` nullable — global vs tenant) + tenant `role_permissions` grants within the seeded permission vocabulary; keep the binary model (ADR-0015). **Modifies existing** (roles gains tenant scope). **Batch:** 1 (with DC-20). **Recommendation:** design with the metadata/extensibility ADR.

### DC-25 — Data retention / archival / cold-storage strategy — **Required, Medium**
- **Evidence:** archive-not-delete (ADR-0007) covers *business records*; there is no **time-bounded retention** for high-volume `events`/`conversation_messages`/`security_events`/outbox-delivered rows (GDPR data-minimization + storage cost). Pairs with partitioning (B8) and selective-outbox archival (C2).
- **Root cause:** "never delete" over-generalized; retention (delete/anonymize/cold-store after N years) never designed. **Design:** `retention_policies(entity_type, retain_period, action_code[archive|anonymize|purge])`; scheduled enforcement (pg_cron); cold-storage/partition-drop for aged high-volume tables. **Additive.** **Batch:** 2. **Recommendation:** design alongside DC-4 (erasure) and B8 (partitioning) — one lifecycle model.

### DC-26 — Plugin / extension / marketplace SDK — **Optional, Low**
- **Evidence:** the extension *seam* exists (integration layer + event outbox + RPC surface); a formal plugin registry / sandboxing / third-party-developer model does not. Odoo/Salesforce ecosystems evidence the pattern for a "primary operational platform" vision.
- **Design:** `installed_extensions`, `extension_permissions`, a signed-manifest + capability model over the existing RPC/event surface. **Additive.** **Batch:** 5. **Optional** — owner decides whether ORVION becomes an ecosystem; the seam is already there, so this stays additive.

### DC-27 — Explicit "state-based, not event-sourced" + CQRS-lite stance — **Required (ADR), Medium**
- **Evidence:** `events` is an **audit/integration projection**; state-of-record is relational tables. This is a sound, deliberate choice — but it is **implicit**. A new team could misread `events` as an event-sourcing log and build wrongly.
- **Root cause:** the decision was made by practice, never recorded as an ADR. **Design:** an ADR stating: relational tables are the source of truth; `events` are immutable audit + outbound contract (not a rebuildable event store); read models (RC-4) are CQRS-lite projections. **Additive** (documentation). **Batch:** 0 (ADR). **Recommendation:** record now — cheap, prevents a class of misimplementation.

### DC-28 — Migration rollback/forward-fix + legacy bulk-import framework — **Required, Medium**
- **Evidence:** migrations are forward-only (ADR-0009 linear history); there is no documented rollback/hotfix procedure, and **DC-10 opening balances** covers *balances* but not **bulk legacy records** (a new agency's years of past bookings/customers/documents).
- **Root cause:** greenfield + forward-only assumed; production incident-recovery and legacy onboarding never designed. **Design:** a forward-fix/rollback runbook (Supabase branching + additive-revert migrations); a `legacy_import_batches` + staging-and-map RPC framework for bulk customer/booking/document import with dedup (ADR-0019 merge). **Additive.** **Batch:** 2 + pairs with DC-10. **Recommendation:** design the import framework before onboarding the first real agency.

### DC-29 — Offline / connectivity resilience — **Optional, Low**
- **Evidence:** online-only (Supabase); travel counters can have intermittent connectivity. Client-side concern (offline cache + sync/conflict), not schema. **Design:** if evidenced, a client sync/queue + conflict policy (leverages DC-2 idempotency + DC-3 concurrency). **Batch:** 5. **Optional.**

## 3. 30-vendor lens sweep (each attempted to reject; result)
- **SAP/Oracle/Dynamics/Odoo (ERP):** multi-book (DC-19), custom fields/objects (DC-20), custom roles (DC-24), retention (DC-25) → all now recorded. Nothing else.
- **Salesforce/HubSpot/ServiceNow (CRM/platform):** custom fields/objects, metadata, marketplace (DC-20/26) → recorded.
- **Travelport/Amadeus/Sabre/IATA/NDC/BSP:** PNR/refs (BF-1), BSP/ADM (BF-7/BF-10), ticketing deadline (DC-7), Hijri (DC-21) → recorded.
- **Stripe/QuickBooks/Xero:** subledgers/periods/tax/FX (CDD-5, BF-4, DC-11), idempotency (DC-2), dispute (BF-8) → recorded.
- **Snowflake/Databricks (data/BI):** read models/dimensions (RC-4), event contract (N1), pgvector (DC-18) → recorded.
- **AWS SaaS Factory/Azure/GCP architecture:** residency/multi-region (DC-22), retention (DC-25), API contract (DC-23), DR/observability (OPS-1), tenant export/import (DC-14/DC-28) → recorded.
- **Supabase/PostgreSQL core:** UUIDv7 (DC-13), partitioning (B8), RLS init-plan (A1), indexes (A2), storage RLS (DC-5) → recorded.
- **OpenAI/Anthropic (AI):** MCP over RPC/event surface (PD§21), event registry (N1), pgvector (DC-18), custom-field discovery for agents (DC-20) → recorded.
- **Google Ads/Meta/WhatsApp:** consent (R5/N5), Data Manager delivery (Batch 3), 24-hour window/templates (Engagement design), transfer controls (DC-22) → recorded.
- **Jira/Linear/ClickUp/Monday/GitHub (workflow):** approval generic + workflow engine overlay (FOE-6), CR lifecycle (built) → recorded.
- **Result:** **no vendor lens produced a finding outside DC-1…29 + the inherited universe.** The conceptual attack surface is exhausted.

## 4. Architecture stress test (each scenario → where handled)
1000 tenants / billions of rows → shared-schema RLS + partitioning (B8) + UUIDv7 (DC-13) + indexes (A2). Multi-company/franchise/white-label → CDD-9 + DC-20 (theming). Tenant export/import/legacy migration → DC-14 + DC-28 + DC-10. Custom fields/objects/workflows/reports/permissions → DC-20/DC-24/RC-4/FOE-6. Marketplace/plugin/SDK/external devs → DC-26 + DC-23. Multi-region/residency → DC-22. Multi-currency/tax/ledger → CDD-5/BF-4/DC-11/DC-19. Multi-language/calendar/timezone → CDD-11/DC-21/DC-9. API-first/event-driven/CQRS/event-sourcing → ADR-0014/N1/RC-4/**DC-27** (state-based, deliberately not event-sourced). Offline → DC-29. DR → OPS-1. **Every scenario maps to a recorded finding; none forces an unrecorded structural change.**

## 5. Contradiction & duplicate resolution (this pass)
- No contradiction found between reports after prior reconciliation. DC-24 overlaps DC-20 (both extensibility) — kept distinct (roles vs fields) but batched together. DC-25 overlaps DC-4/B8 — one **data-lifecycle** model owns retention+erasure+partition-drop (noted). No finding removed; no prior conclusion reversed.

## 6. Tooling (unchanged; not self-installed — modifies user config/CI)
pgTAP (Critical), Supabase/Postgres MCP (High), squawk/sqlfluff (High), CR-invariant hook (High), gitleaks (Medium). Additionally for this session's findings: a **schema-diff/ERD generator** (e.g. `schemaspy`/`tbls`) would keep `MASTER_ENTITY_RELATIONSHIP_MAP` auto-current (Medium). Apply on owner approval via `update-config`.

---

## 7. THE PROOF — is the completion statement TRUE or FALSE?

> *"A completely new engineering team can build ORVION from the Canon, ADRs, Reports, and MASTER documents without rediscovering any architectural concept, redesigning any foundation, or introducing structural changes."*

**Verdict: FALSE today — provably, for exactly two enumerated reasons. Neither is open-ended; both are now fully discovered and specified, which is what converts "we don't know if it's complete" into "here is precisely what remains."**

**Reason 1 — Canon-integration gap (carried, unchanged).** The complete design lives in `reports/` + MASTER documents as **proposals awaiting owner ratification**, not in `_ORVION_CANONICAL/**` or `architecture-decision-records.md`. A team reading *only Canon* rediscovers ~40% of the platform. A team reading *Canon + Reports + MASTER docs* does not — so the statement is TRUE for the full corpus and FALSE for Canon alone. **Close by:** owner ratifies the proposed ADRs; a canon-integration batch folds Batch-0/1 design into `24`–`31`/`35`.

**Reason 2 — Meta-pattern concepts were undiscovered until this session (DC-20…29).** Ten architectural *concepts* — custom-field extensibility, Hijri calendar, data residency (PDPL), public-API/versioning, tenant-custom roles, retention/archival, plugin SDK, the event-sourcing stance, legacy-import/rollback, offline — were absent from the entire corpus. Some (residency topology, custom-field storage, tenant-custom roles) **could force structural change if discovered post-implementation**. They are now **designed at spec level here** and added to the register. **Close by:** integrating DC-20…29 into the plan/canon like the rest.

**Why this is now a *complete* proof, not another "keep looking":** the 30-vendor lens sweep and the full stress-test battery produced **no finding beyond DC-20…29**. The attack moved from tables (exhausted sessions 1–2) to concepts/patterns/questions (exhausted this session). There is no further *category* of architectural concept left to sweep. Therefore:

> **The set of things that would force a foundation reopening is now closed and enumerated: {the 6 built-table retrofits + DC-1 money + DC-13 UUIDv7 (Batch 0), DC-20/DC-22/DC-24 structural hooks (extensibility/residency/roles), and the canon-integration of all of it}. Design every one of these now (all specified across the MASTER documents), and no future requirement in a complete Travel ERP/CRM/Revenue platform should reopen the foundation.**

**Path to TRUE (unconditional certification):**
1. Owner ratifies the proposed ADR set + DC-20…29 classifications.
2. Land the Batch-0 structural hooks (money scale, UUIDv7, party_id, events/JE/invoice/booking-item columns, unique keys, **+ `data_region`, `custom_fields`/definitions, `roles.tenant_id`** as additive hooks) — the only remaining structural touches, all cheap pre-data.
3. Integrate the full design into Canon (`24`–`31`/`35` + ADRs).
4. Stand up DC-16 pgTAP with the invariant tests.

After steps 1–4, the statement is TRUE with evidence: the corpus is complete, the foundation hooks are placed, and every remaining domain implements additively from the MASTER documents.

*End of Final Design Proof 2026-07-11 #3. No implementation; canon untouched; Phase 8 not started. Conceptual discovery closed pending owner ratification.*
