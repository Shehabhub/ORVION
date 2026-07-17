# Decision Record — Google Offline-Conversion Transport (Phase 8)

Class: **Decision Record** (technical advisory analysis; awaiting owner ratification → becomes ADR-0023 on decision). Prepared 2026-07-17 under the Technical-Advisory-Board directive.
Status: **RESOLVED 2026-07-17 → ADR-0023** (owner ratified: Data Manager API + Enhanced Conversions for Leads, **orchestrated by n8n** — the owner selected n8n over the recommended Edge Function, confirming n8n as ORVION's primary orchestration layer). This record is now the immutable analysis behind that ADR.
Purpose: give the owner an *informed* transport decision for delivering ORVION's verified conversion outcomes to Google Ads — the one open Phase-8 business/compliance decision.

## Why this decision exists (and can't be objectively derived)
ORVION emits *verified* offline outcomes (a lead that became a paid booking, tied to a click via `attribution_clicks.gclid/gbraid/wbraid` + consent). Delivering them to Google is what closes the ad-spend feedback loop. The **transport** cannot be derived from the repository because it commits ORVION to (a) sending customer-derived data + consent to a third party under a specific policy — a **compliance/legal posture**, and (b) a Google-account/API-access setup only the owner can authorize. **Reversibility:** the *transport adapter* is reversible (a pluggable boundary — see Phase-8 core design); the *compliance commitment* (what data leaves, under what consent) is a standing policy, harder to walk back once live.

## The transports actually available in 2026 (evidence-based)
Google restructured this surface in 2026 — verified against Google's own developer blog + Help.

| Transport | How it works | Lifecycle (2026) | Fit for ORVION |
|---|---|---|---|
| **Legacy Google Ads API `UploadClickConversions`** | Server→server GCLID upload via `ConversionUploadService` | **DEAD for new integrations** — blocked from **2026-06-15**; a token with no upload between Dec 2025–May 2026 gets `CUSTOMER_NOT_ALLOWLISTED`. ORVION has never uploaded → **cannot use it.** | ❌ Unavailable |
| **Data Manager API + Enhanced Conversions for Leads (ECL)** | Server→server. Match keys = **GCLID + hashed first-party data (email/phone)**; conversion + value + consent signals. OAuth2 with the distinct `datamanager` scope. | **CURRENT + Google-recommended.** Plain-GCLID import is now "legacy"; ECL is the recommended successor (attributes even when GCLID is lost). Unified enhanced-conversions setting (Apr 2026) accepts Data-Manager + API + tag data simultaneously. | ✅ **Best fit** — server-to-server, no UI needed, ORVION owns the hashed first-party data |
| **Google tag / GTM (gtag) client-side ECL** | Browser tag collects GCLID + user data at form-submit; conversions matched client-side | Current, but **tag/browser-based** | ⚠️ Needs a web frontend + tag; ORVION has **no UI yet**, and this puts attribution logic in the browser, not in ORVION's verified-outcome layer — against the Revenue-Intelligence posture (PROJECT_CONTEXT §11) |
| **Manual / scheduled file upload (Data Manager UI / Google Ads UI)** | Human uploads CSV, or a scheduled sheet | Current, non-programmatic | ⚠️ Fallback only — not automatable to ORVION's event backbone; operational toil |

## The §2 checklist, applied to the recommended transport (Data Manager API + ECL)
- **Required APIs:** Google **Data Manager API** (`datamanager` OAuth2 scope — separate credential flow from the Ads API).
- **Required infrastructure:** an outbound server-side caller. Per ADR-0014/0018 → a **Supabase Edge Function** (or n8n) triggered by ORVION events / pg_cron; ORVION logic stays in RPCs, external I/O at the Edge. **No standalone service** needed.
- **Permissions:** a Google Ads account + developer access + OAuth2 client with the `datamanager` scope; owner-authorized.
- **Consent Mode:** ECL requires passing consent signals — **already captured** (SPEC-119: `consent_ad_user_data` / `consent_ad_personalization`). ORVION must forward them; deliver only when consent = granted.
- **PII implications:** ECL sends **hashed** (SHA-256, normalized) email/phone + GCLID — never raw PII. Hashing happens in the Edge Function; ORVION stores the outcome, not Google's copy.
- **Security:** OAuth2 client secret + refresh token in secret store (never committed, per the `.mcp.json`/env pattern); egress only from the Edge Function; least-privilege scope.
- **Operational model:** ORVION records a verified `offline_conversion` → an Edge Function batches undelivered rows → Data Manager API → delivery status + retry recorded in `offline_conversion_deliveries` (state machine already designed in the Phase-8 core).

## §3 Ecosystem compatibility (architect for what ORVION is becoming)
- **PostgreSQL/Supabase:** native — logic in RPCs, trigger via pg_cron/Edge (ADR-0018). ✅
- **n8n:** an alternative/adjunct caller (n8n has HTTP + could hold the OAuth flow) — viable if the owner prefers low-code orchestration over an Edge Function. ✅ (transport-agnostic boundary keeps both open)
- **GTM / GA4:** complementary, not competing — the **unified enhanced-conversions** setting (Apr 2026) lets Data-Manager (server) + tag (GTM/GA4) data coexist; ORVION's server-side truth is authoritative, GTM/GA4 can still run client-side. ✅
- **Meta WhatsApp Cloud API / Meta CAPI:** same pattern reused later — a server-side outbound adapter forwarding verified outcomes with consent (Phase 10). The Phase-8 delivery abstraction should be **channel-generic** so Meta CAPI plugs into the same `*_deliveries` state-machine. ✅ (design implication captured)
- **AI agents / portals / dashboards / BI / mobile / future APIs:** all are *consumers* of ORVION's verified outcomes; none depend on the ad transport. The read-model (ADR-0022) is the shared truth. ✅

## Recommendation
**Adopt the Google Data Manager API with Enhanced Conversions for Leads, delivered from a Supabase Edge Function (n8n an acceptable alternative), forwarding hashed first-party data + GCLID + consent.** It is the only current, Google-recommended, server-to-server path (the legacy one is unavailable to ORVION), it needs no UI, it maximizes attribution resilience (survives GCLID loss), it reuses already-captured consent, and it keeps ORVION the owner of the verified truth.

## Rationale / risks / migration
- **Rationale:** legacy path is dead for us; Data Manager is mandated + current; ECL is Google's recommended match strategy; consent already modeled; fits Supabase-native architecture.
- **Risks:** (a) fast-moving surface — the Data Manager API is <1yr old; **build behind a transport-agnostic adapter** so a future Google change is an adapter swap, not a Phase-8 redesign. (b) Compliance — sending hashed customer data + consent to Google is a legal posture the owner must own. (c) OAuth `datamanager`-scope credential setup is new; needs owner Google-account action.
- **Future migration:** the channel-generic delivery state-machine means Meta CAPI (Phase 10) and any future platform reuse the same boundary — no rework.

## The owner decision (how to choose, not just what)
Decide **two things**: (1) **Authorize the Data Manager API + ECL compliance posture** (hashed email/phone + GCLID + consent to Google, delivering only on consent=granted)? (2) **Caller preference** — Supabase Edge Function (recommended, in-architecture) **or** n8n (if you prefer low-code orchestration)? Everything else in Phase 8 is transport-agnostic and I build regardless. If you want the strongest-default and no further input: **Data Manager API + ECL + Edge Function**, which I'll implement behind a swappable adapter.
