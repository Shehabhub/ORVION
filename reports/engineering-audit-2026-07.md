# ORVION Engineering Audit — Phases 2–7 (2026-07-09)

Status: Audit report (analysis only; NOT a Change Request; no implementation performed).
Scope: Phases 2–7 as one integrated system. Method: repository + live-DB evidence, current official guidance (Supabase, PostgreSQL, Google Ads), adversarial disproof. Recommendations are NOT implemented pending owner approval.

Severity: **Critical / High / Medium / Low / No Action**. Cost: S (<½ day) / M (½–2 days) / L (>2 days).

---

## Executive summary

The platform is in **strong** engineering shape for its stage. Tenant isolation, the single RLS resolution primitive (ADR-0013), the catalog strategy, the append-only event backbone, capability-driven RPCs with Earn-It permissions, and derived-not-stored finance primitives are all sound and match current best practice. **No Critical defects were found in built code.** The most valuable findings are (a) two evidence-backed **RLS scale** optimizations to apply before the first client integration, (b) a **Phase-8 attribution gap** (missing `gbraid`/`wbraid`/consent) that is cheap now and unrecoverable later, and (c) a set of **DB-enforced-invariant** items already tracked in `future-backlog.md` with correct triggers. Most "missing domains" (HR/Payroll/Procurement/Treasury/Packages) are simply **out of the current roadmap scope**, not defects.

---

## A. Findings that are genuinely new (not already in future-backlog)

### A1 — RLS policies do not use the `(select …)` initPlan wrapping — **High (scale), Low (now)**
- **Evidence:** every tenant policy is `USING (tenant_id = app.current_tenant_id())` (verified via `pg_policy`). Supabase's official RLS performance guidance is to wrap functions as `(select app.current_tenant_id())` so the optimizer runs an initPlan and evaluates once per query instead of per row.
- **Why / Impact:** at scale, per-row evaluation of a `SECURITY DEFINER` function materially slows large scans. `current_tenant_id()` being `STABLE` mitigates but does not match the documented pattern.
- **Cost:** S — it is generated in ONE loop (`202607043300`), and ADR-0013's single-primitive design means the fix lands in one place. Applied as a **new additive migration** that `CREATE OR REPLACE`s the policies (does not modify the old migration).
- **Urgency:** before first client integration / production data. **Future capability (backend/API phase)**, not a change to a completed phase's file.

### A2 — 18 tenant-scoped tables lack a `tenant_id` index — **High (scale), Low (now)**
- **Evidence:** 57 tables carry `tenant_id`; 18 have no index leading with it — mostly high-volume child tables: `journal_entry_lines`, `payment_allocations`, `document_links`, `document_versions`, `quotation_items`, `lead_interactions`, `lead_assignments`, `notification_deliveries`, `offline_conversion_deliveries`, `conversation_messages`, `booking_item_passengers`, `customer_contact_methods`, `customer_notes`, `exchange_rate_adjustments`, `internal_supplier_links`, `branch_business_hours`, `customer_identity_merges`, `customer_identity_signals`, `user_role_assignments`.
- **Why / Impact:** RLS filters every query by `tenant_id`; without a supporting index these become seq scans under load. Supabase guidance: index every column used in a policy. (Some child tables are usually accessed via an indexed FK to the parent, softening this — but the RLS predicate is on `tenant_id`.)
- **Cost:** S–M — additive `CREATE INDEX` migration; pairs naturally with A1.
- **Urgency:** with A1, before production. **Future capability (backend/API phase).**

### A3 — Phase-8 attribution capture is incomplete — **High (Phase 8), and time-sensitive**
- **Evidence:** `attribution_clicks` has `gclid, click_id, utm_*, clicked_at` but **no `gbraid`, `wbraid`, or consent signals** (`ad_user_data`, `ad_personalization`); `leads` has no click-ID linkage column. Google (confirmed 2026): legacy offline import is **blocked 2026-06-15** → **Data Manager API**; **enhanced conversions for leads** now uses GCLID + hashed user data and **consent is required**; `gbraid`/`wbraid` are the privacy-safe iOS/web-app click IDs.
- **Why / Impact:** click IDs and consent are **captured at intake and unrecoverable retroactively**. Missing them = permanent attribution blindness on all prior leads and non-compliant delivery.
- **Cost:** S — additive nullable columns (`gbraid`/`wbraid`/consent) on `attribution_clicks`, and confirm `create_lead` populates + links attribution.
- **Urgency:** **do at Phase-8 start** (the future-backlog flags the gclid half; this audit adds `gbraid`/`wbraid`/consent + the lead-linkage verification). Future capability within Phase 8.

### A4 — Domains absent vs the department ambition — **No Action now (future phases)**
- **Evidence:** no tables for **HR / employees / payroll**, **procurement / purchase orders**, **treasury / cash-management** (beyond `financial_accounts` + `payments`), or a **product/package catalog** (Umrah/Hajj/packages are handled service-agnostically via `booking_items` + `service_type_code`, which is correct for the core but has no bundled-product entity). `company_assets` **does** exist (asset register).
- **Why / Impact:** these are real future departments but **outside the approved roadmap (Phases 2–10)**. Representing them later is additive (new aggregates), not a redesign — the tenant/event/RLS backbone already supports them.
- **Cost:** L each, **as future phases**. **No action now** beyond recording direction.
- **Recommendation:** when scoped, run Learn-Before-Designing per domain; a **package/itinerary product** entity is the most likely near-term (multi-service bundles with their own pricing) if packaged tourism becomes a first-class sell.

---

## B. Findings already tracked in `future-backlog.md` (audit confirms + prioritizes)

These are **not new** — the backlog already records them with correct triggers. The audit confirms their validity and suggests grouping them into a **"pre-production hardening" pass** at the backend/API phase.

| # | Item | Severity | Backlog trigger |
|---|---|---|---|
| B1 | Reference-data layer (countries/cities/nationalities/languages/airports) integrity | Medium | Required Soon |
| B2 | DB CHECK constraints (journal debit/credit exclusivity, finance non-negativity, `document_links` single-target, `document_versions` single-current, passport issue<expiry) | Medium | Per-table / hardening |
| B3 | Business-key uniqueness (`bookings.booking_reference`, `quotations.quotation_number`, `subscription_plans.plan_code`, `feature_entitlements`, `usage_counters`) | **High** (cheap now, painful later) | Before real data |
| B4 | DB-enforced event immutability (block UPDATE/DELETE on `events`/`security_events`) | Medium | Events/RLS |
| B5 | DML `GRANT`s to `authenticated` (+ `anon` read scope) — currently fully locked (safe) | High (blocks clients) | Backend/API phase |
| B6 | Status-column naming normalization (`tenants.status`, `company_assets.status`, unprefixed `status_code`) | Low | Before code references columns |
| B7 | `pg_trgm` fuzzy matching for identity/dedup | Low | When dedup is built |
| B8 | Partitioning for high-volume tables (`events`, `conversation_messages`, `attribution_clicks`, `campaign_daily_metrics`) | Low | At real volume |

Audit note: **B3 and B5 are the most consequential** of the backlog set. B3 (unique business keys) is trivial on empty tables and a data-migration hazard later — recommend promoting to the next hardening CR. B5 gates every client and pairs with A1/A2.

---

## C. Architecture validation (adversarial)

- **DDD / module boundaries — Strong.** Booking Core is service-agnostic (`booking-orchestration-boundary`); Finance consumes booking events; Documents links polymorphically without coupling. Aggregates are coherent.
- **Event model — Strong, one gap.** Append-only `events` + `security_events` give a real backbone for dashboards, AI, and integrations. Gap: immutability is convention, not DB-enforced (B4). Some lifecycle events are emitted with `entity_type` reuse (e.g. `booking_item_risk_flag_created` on a `booking` entity — a recorded Engineering Observation), acceptable but worth a future canon reconciliation.
- **RPC strategy — Strong.** `SECURITY INVOKER` + RLS backstop + `app.authorize()` + `record_event()` is consistent across ~30 RPCs. Derived-not-stored finance primitives (`customer_balance`/`supplier_balance`/`booking_item_profit`) eliminate drift.
- **AuthZ — Strong + evolving.** Binary `role_permissions` (ADR-0015) with scope/condition enforced at point-of-use; MFA via `aal` claim (ADR-0017). Read-permission exception now precedented (`financial_documents`).
- **API strategy — deliberately deferred.** No REST/GraphQL surface or DML grants yet (ADR-0014 Supabase-native). Correct for stage; B5 is the trigger.
- **Observability / logging — adequate for stage, thin for production.** Business events are captured; there is no structured application logging, metrics, or tracing yet (belongs to the Edge/backend layer). **Medium**, future.
- **Backup / DR — not in repo (Supabase-managed).** PITR/backups are a Supabase project-settings concern, not migrations. **Recommend** documenting the DR posture (RPO/RTO, PITR tier) as an ops note. **Medium**, future ops.

---

## D. Multi-tenant SaaS readiness

- **Infrastructure present:** `tenants`, `subscription_plans`, `subscriptions`, `feature_entitlements`, `usage_counters`, `subscription_payment_proofs`. Provisioning is platform-mediated (ADR-0016).
- **Gap — subscription lifecycle logic not built:** no RPCs yet for upgrade/downgrade/suspend/reactivate or entitlement enforcement; the subscription state machine (`26`) is unrealized. Tenant isolation is **not** coupled to subscription state (ADR-0013 kept them distinct — correct). **Medium**, a future Subscription/Billing slice; the tables are ready, so it is additive.
- **Plan gating (Starter/Professional/Enterprise):** modeled in `feature_entitlements` but not enforced anywhere yet (no consumer). Earn-It-correct; enforce when a plan-gated capability ships. **No action now.**
- **Verdict:** the schema is SaaS-ready; the **runtime billing/entitlement layer is the main unbuilt SaaS piece** — expected at this phase, not a defect.

---

## E. Integrations & AI readiness

- **Google Ads (Phase 8):** deliver via **Data Manager API** (legacy blocked 2026-06-15); use **enhanced conversions for leads** (GCLID + hashed identifiers); **capture consent**. Fix A3 first. Tables (`attribution_clicks`/`offline_conversions`/`offline_conversion_deliveries`) exist with a delivery+retry state machine.
- **GTM/GA4/Meta/WhatsApp/n8n/Framer:** no integration code yet (Phase 10). The **outbound/push, ORVION-owns-the-truth** posture (backlog) is the right model. Full Meta-ecosystem + Communications research is correctly deferred to Phase 10.
- **AI / MCP / Revenue Intelligence — well-positioned.** The event backbone + read-RPC surface + verified-outcome model is exactly what an MCP/AI layer or revenue-intelligence consumer needs. No architectural blocker; AI is a **consumer** of events (correct per the vision). **No action now**; strength.

---

## F. Dashboards

Every domain **already emits events and exposes query primitives**, so per-department dashboards (Lead performance, Sales, Booking pipeline, Finance outstanding, Profit-by-item, Subscription) are achievable **without architectural redesign** — they are read models over `events` + the derived RPCs. **No action; strength.** (Reporting is Phase 9; the substrate is ready.)

---

## G. "If I wanted ORVION to fail in production, where would I attack?"

1. **Unbounded scans under RLS** (A1/A2) — the most realistic performance failure at scale. *Mitigated cheaply pre-production.*
2. **Duplicate business keys** (B3) — `booking_reference`/`quotation_number` collisions corrupt lookups and operator trust. *Trivial to prevent now.*
3. **Attribution blindness** (A3) — silent, permanent, and compliance-relevant. *Fix at Phase-8 start.*
4. **Invariant drift without DB CHECKs** (B2) — application logic is correct today, but a future direct-SQL/service_role writer could violate non-negativity/exclusivity. *DB constraints close this.*
5. **No entitlement enforcement** — a client could access plan-gated features once DML grants land (B5) unless entitlement checks ship with them. *Enforce at the gating capability.*
6. **Tenant isolation** — audited as **solid**: default-deny, single primitive, service_role-only platform access. No bypass found in built RPCs (all `SECURITY INVOKER` with tenant checks; `SECURITY DEFINER` used only where justified with explicit tenant guards).

---

## H. Where the current design is already the strongest practical solution (explicit)

- Tenant isolation via one resolution primitive (ADR-0013).
- Derived-not-stored finance balances (no drift).
- Service-agnostic Booking Core + event-driven cross-domain reaction.
- Catalog + reference-table strategy (ADR-0005/0010).
- Capability-driven, Earn-It permission minting.
- Supabase-native backbone with no premature backend service (ADR-0014).
- Append-only event/audit backbone.

**Change none of these.**

---

## Consolidated recommendation

Bundle a single **"Pre-Production Hardening" pass** (all additive; modifies **no** completed-phase file) at the backend/API phase, sequenced: **B5** (grants) + **A1/A2** (RLS wrapping + tenant indexes) + **B3** (unique keys) + **B2/B4** (CHECKs + event immutability). Handle **A3** at Phase-8 start. Everything else stays backlog-tracked at its trigger. No completed phase requires modification; no Critical rework exists.

*End of audit. Awaiting owner review before any implementation resumes.*
