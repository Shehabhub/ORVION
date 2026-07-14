# Session Discovery Checkpoint — 2026-07-14

Status: 🟠 Historical-Immutable working engineering record (do not edit; supersede with a newer dated record if needed).
Type: **Non-canonical working record.** Preserves the complete discovery state of the 2026-07-13/14 owner-directed review+research session so that no knowledge lives only in chat. Not an ADR, not canon, not a Change Request.
Governs continuation: a fresh session should read this after the boot sequence (README → AGENTS → manifest) to continue from the preserved engineering state rather than restarting analysis.

---

## 0. Purpose and how to use this record

The owner directed a deep, evidence-first review of ORVION's whole-system coherence, external-integration compatibility, and future architecture, then approved a set of proposals and requested this checkpoint **before any implementation, roadmap rewrite, or canonical change**. Everything discovered — findings, proposals (approved/rejected/deferred/pending), research, risks, open questions, assumptions, and intended next steps — is captured below.

**Continuation rule (owner instruction, verbatim intent):** When the next session starts, decide the correct continuation from the repository state. If, after reviewing this checkpoint, another verification pass is still required, continue verification. If verification is complete, begin implementation. Do **not** restart analysis from scratch unless the stored evidence proves it necessary. Always continue from the preserved engineering state. Apply all governance — One Authority, Test-Before-Assume, Learn-Before-Designing, Earn-It, and the full Implementation → Discovery → Evidence → Fix → Permanent-Test → Synchronization lifecycle.

**Current confidence verdict (end of session):** HIGH. The verification pass (§7) confirmed **no lost architectural layer** and **no surviving architectural contradiction**; the core (money precision, RLS, DML grants, CI gating) is clean and machine-guarded. Remaining debt is **synchronization/annotation + one real event-catalog-coherence gap**, all correctable. Two numeric counts and a few external facts remain to verify (§10). Recommended next action: obtain owner approval on the consolidated package (§8), then execute the two-track plan (§9). Another full from-scratch verification pass is **not** required.

---

## 1. Owner-ratified operating principles (currently only in chat → preserved here)

The owner ratified the following as standing direction this session. These extend, and must be reconciled with, AGENTS.md and GOVERNANCE.md (see §7 governance finding G4 — persist as **pointers**, not duplicated bodies, to avoid a One-Authority violation).

1. **Evidence-gated authority over closed work.** The engineer may inspect, synchronize, and improve any part of the project — including completed phases and closed files — **if and only if** repository evidence proves: architectural drift, inconsistency, missing design, incomplete implementation, outdated decisions, synchronization issues, empty placeholders, duplicated concepts, broken layering, unnatural execution order, or conflict with current standards. Every structural change must still satisfy Earn-It before implementation.
2. **Treat the repository as one living system.** No isolated-phase thinking. Every implementation triggers verification of all related layers (synchronized, coherent, internally consistent, architecturally aligned, fully traceable, free of obsolete assumptions). Fix in-authority inconsistencies exposed; classify and stop for owner decisions where required.
3. **Always execute under the project's laws.** Never rely on conversation memory. Consciously load governing principles before major work: Earn-It, Test-Before-Assume, Learn-Before-Designing, the Impl→Discovery→Evidence→Fix→Permanent-Test→Sync loop, One Authority, Boy-Scout, GOVERNANCE, AGENTS, ADRs, all architectural + execution rules. Every delegated agent operates under the same governance.
4. **Delegate whenever it increases quality** (research, design, implementation, verification, architecture, documentation, execution). Objective is not cost/token minimization — it is maximum design and execution quality. Delegated agents follow the same governance and Earn-It.
5. **Self-Healing** approved as a true capability (not theoretical) — research proven practices, validate via Earn-It, integrate as a natural architectural capability.
6. **Self-Learning** approved as a true capability — evidence-only, each proposal must survive Earn-It.
7. **Airports and Airlines** promoted to **first-class reference domains** (owner changed the earlier decision) — research international standards, design as globally scalable reference domains, present for approval before implementation.
8. **Explain before proceeding** (delivered this session): UUIDv7, Microservice definition, ADR-0014 rationale.
9. **Long-term objective:** the system must become Complete, Coherent, Consistent, Enterprise-grade, Future-proof, Self-Healing, Self-Learning, Self-Validating, Fully synchronized. Standard loop: Implementation → Discovery → Evidence → Fix → Permanent Test → Synchronization → Continue.

Additional standing instruction: **present proposals for approval before** introducing any new architectural decision, modifying canonical governance, changing protected documents, or making owner-level decisions; once approved, continue execution immediately.

---

## 2. Approved proposals P1–P7 (approved as direction; canonical realization PENDING owner sign-off on exact diffs)

Owner approved these as execution direction. Each survived Earn-It. Canonical realization (roadmap/manifest/ADR edits) was **not** performed (this checkpoint precedes it). Full Earn-It fields are preserved.

**P1 — Add a canonical "Application & Access Layer" phase to the roadmap.**
- Evidence: `authenticated` has no SELECT/INSERT/UPDATE/DELETE historically (B5) — but see §7 schema finding OK-4: B5 grants were in fact applied in `202607043400`. 0 views/matviews (V6). DC-23 (public API) OPEN. Roadmap `32` ends at Phase 10 with no app/API/client phase; 55 RPCs have no consumer.
- Why/problem: roadmap progression never yields something a travel agency can use; the usability gate sits in no phase.
- Long-term/impl/arch impact: makes MVOS/Production/SaaS milestones answerable against a named phase; one ADR framing the access model (broad-grant-with-RLS vs granular; `anon` scope; API surface). Names the home for deferred backlog items (naming normalization, anon scope). Touches protected canon → owner-gated.
- NOTE for next session: re-verify the B5 premise against OK-4 before finalizing P1's framing — the "clients cannot access any table" claim is partially outdated; the true remaining gap is the API/UI surface + DC-23, not the grants.

**P2 — Build CDD-7 transactional outbox + N1 event_type registry substrate BEFORE Phase 8 delivery.** (Owner default confirmed: full substrate first, not a narrow Phase-8-only outbox.)
- Evidence: `MASTER_DEPENDENCY_GRAPH` "CDD-7 required before Batch-3 Phase 8"; "N1 required before reliable outbox delivery." Supabase Database Webhooks are at-most-once, no retry, no delivery guarantee (docs silent) — verified by integration research (§6). **Reinforced by §7 schema finding S-EVENT: the canon-27 event vocabulary is already unenforced free text and actively drifting** → N1 is not speculative; it arrests live drift.
- Long-term/impl/arch: one outbox+registry serves Google (Phase 8) + Meta (Phase 10) + tenant-export (DC-14) — build once. Larger up-front, strictly additive, no built-table rewrite. Resolves the roadmap-vs-dependency sequencing contradiction. Owner-decision → ADR (first item of Phase 8 Design Challenge).

**P3 — Reorder Reporting (Phase 9 / RC-4) ahead of Offline Conversion (Phase 8) for MVOS.**
- Evidence: V6 (0 views); Phase 9 outputs = outstanding balances, pipeline, profit/item — daily-operations essentials; `21` = ad optimization, not daily ops.
- Long-term/impl/arch: RC-4 read-model is also the substrate for the AI dashboard (workflow #10) and Self-Learning/RI consumers. Pure resequencing; no work discarded. Depends on P2 outcome; moot if Phase 8 kept next.

**P4 — Unified `app.ingest_lead(source, external_id, payload, attribution)` RPC as the single lead write-path + `(source, external_id)` unique dedup + provider match-key columns.**
- Evidence: integration + Meta research (§6). Match keys that are capture-or-lose: `meta_leadgen_id` (Meta CAPI Conversion-Leads match key, 15–17 digit string), `ctwa_clid` (click-to-WhatsApp), `wa_message_id` (inbound dedup), Meta ad/form/campaign ids; parallel to Google `gclid/gbraid/wbraid` already landed (SPEC-119). Mirrors SPEC-119/R5 reasoning (click IDs unrecoverable retroactively).
- Long-term/impl/arch: one choke point → dedup lives in one constraint; per-source adapters live in n8n as pure translation; adding a source later = one n8n workflow, zero schema change. New ADR.
- Earn-It nuance (important): capture columns are needed **before each source's intake goes live**, not speculatively now — today there is NO live intake of any source, so nothing is being lost this moment. Design now; add per-source columns at that source's go-live.

**P5 — Lead-level consent record (`leads.consent_granted / consent_timestamp / consent_source / data_region`).**
- Evidence: Google + Meta research — Enhanced Conversions for Leads sends the *lead's* PII, which may have no click row (phone-only lead) → click-level consent (on `attribution_clicks`) is insufficient; PDPL (Egypt) now, EU/LDU later. Consent is capture-time-or-never.
- Part of ADR-0024 (with P4).

**P6 — Phase 8 delivery = Google Data Manager API + Enhanced Conversions for Leads; add `offline_conversions.order_id` dedup key + conversion-action mapping.**
- Evidence: §6 Google research (see §6 for citations). Legacy GCLID path is closed to ORVION (no prior upload history; blocked 2026-06-15). EC-for-Leads matches on hashed phone (E.164 + SHA-256), no GCLID required, phone-only officially supported — fits Egypt. **Verified gaps in `offline_conversions` (migration `202607043000`): no order_id, no conversion-action mapping, no phone/email identifier columns.**
- New ADR (transport) + Phase-8 implementation items.

**P7 — E.164 phone canonicalization at delivery time.**
- Evidence: Google research — local `01…` format zeroes match rates; Egypt `+20`. Build-time concern (canonicalize in the delivery Edge Function), not a schema change; verify `leads` stores a recoverable phone.

---

## 3. UUIDv7 — full re-evaluation and decision (owner asked for from-scratch re-evaluation)

**Owner's framing:** do not defer merely because there is little data today (a cost-of-change argument, not an architecture argument). If UUIDv7 is objectively the better permanent architecture, adopt now while the change is cheap.

**Decisive finding (corrects the original "little data" reasoning):** the owner's cost-asymmetry premise is **factually false for this specific change.** The `id` column is type `uuid` for both v4 and v7 — only the DEFAULT expression differs. Verified in-repo: `id uuid primary key default gen_random_uuid()` appears **73 times across 19 migration files**, all identical. Therefore FKs, RLS, indexes, `on update no action` immutability are all unaffected (they reference the type + value, not the generator); mixed v4/v7 in one column is valid forever (existing rows never backfilled). The migration is `ALTER COLUMN id SET DEFAULT uuidv7()` per table — a one-liner, exactly as cheap with 71 tables as with 200. Unlike ADR-0011 (a relationship retrofit that genuinely gets costly after ~70 tables), the PK generator has **no rising-cost-later penalty** to front-run.

**Platform reality (verified):** Supabase runs **PostgreSQL 17** (`supabase/config.toml` `major_version = 17`). Native `uuidv7()` exists only in **PostgreSQL 18**. Supabase does **not** ship the `pg_uuidv7` extension (open, unanswered requests). Adopting today forces a throwaway plpgsql/TLE `uuidv7()` shim into the extensions migration + 19 table defaults, to be ripped out at PG18 — anti-Earn-It. The technical win (index locality) is measurable only at millions of rows (benchmarks ~50M rows); point-lookup/throughput at parity now. Trade-off: v7 embeds creation timestamp (mild enumeration/leakage risk for externally-exposed ids; non-issue for internal RLS-gated surrogate keys).

**DECISION (Earn-It): commit the direction now, implement at PG18.**
- **Amend ADR-0002** (or add a superseding ADR): UUIDv7 is the target PK generator, adopted via native `uuidv7()` at the Supabase PG18 upgrade; `gen_random_uuid()` (v4) remains the interim default on PG17 because the switch is a cost-neutral default swap and the only PG17 implementations are throwaway custom machinery.
- **Add a Future-Backlog trigger** keyed to "Supabase PG18 available" → then a single forward migration doing per-table `ALTER COLUMN id SET DEFAULT uuidv7()` (respects ADR-0009 linear history; no rewrite of existing files). Consider excluding any externally-exposed id (timestamp leakage) per-table at that migration.
- **Unverified/flag:** exact Supabase PG18 GA date (targeted ~Jan 2026, slipped, no official date). Owner may override Earn-It and force v7-now despite the shim cost — if so, implement the shim; the evidence recommends against it.
- Sources: `supabase/config.toml:42`; PG18 uuidv7 (Sawada blog; Nile blog); Supabase discussions #22015/#22584/#42681; benchmarks SayBackend, Better Stack; best-practice Nile/dev.to/NerdLevelTech.

---

## 4. Self-Healing — conclusions (owner §5; research-backed, Earn-It filtered)

**Verdict: not a module — a thin native capability** on the ADR-0018 substrate: a `reconciliation_runs` ledger + a `reconciliation_finding` registered event (N1) + pg_cron `SECURITY DEFINER` detect-and-repair RPCs that ride the CDD-7 outbox. Introduces **no new architectural decision** (ADR-0018 already reserves the DC-8 reconciliation slot per the Master overlay).

**Build now (Earn-It survivors):**
- (d) Outbox stuck/undelivered/lease-expired sweep: backoff + jitter, dead-letter-as-status, manual replay RPC, advisory-lock single-run guard, `FOR UPDATE SKIP LOCKED` drain. (This IS the substrate; closes the DC-8 "nothing heals stuck internal state" root cause.)
- (b) Finance derived-balance ↔ journal invariant check → **flag/quarantine, never auto-rewrite money** (DC-1 incident proves live risk in 3-dp currencies KWD/BHD/OMR).
- Shared substrate: `reconciliation_runs` ledger, one advisory-lock guard, one backoff helper.

**Defer with named triggers:** (e) SLA/assignment stuck-lead heal (trigger: SLA policy + assignment engine); (c) booking-state ↔ event reconciliation (trigger: Booking Core events stabilized); (a) offline_conversions ↔ deliveries recon (trigger: CDD-7 delivery layer live); circuit breaker (trigger: sustained outbound volume with a degrading downstream); LISTEN/NOTIFY relay wake (1–5s poll adequate now).

**Rejected under Earn-It:** saga compensation (no distributed txn — logic is single-DB-txn RPCs); anomaly/ML drift detection (no metrics/ML surface — premature); external queue Redis/BullMQ/Kafka (single poller fine below ~5–10 replicas; ORVION far below); pg_net-as-delivery-relay (fire-and-forget, weak retry/observability — delivery belongs in Edge/n8n); app-owned health remediation (Supabase platform owns it).

**Composition rule:** self-healing is a consumer + janitor of the outbox, not a parallel system. DLQ = a `status='dead'` state of the same outbox; replay = a repair RPC flipping dead/stuck → pending. Findings ride N1 + outbox. Adds only one ledger table + N event types + N sweep RPCs.

**Flags:** batch-size/interval numbers (50–200 / 1–5s) are starting heuristics — calibrate against real outbox volume once CDD-7 is live. Physical outbox/finance schemas not inspected (DESIGN-READY) — confirm columns at build.
Sources: TheCodeForge, npiontko.pro, james-carr.org, arXiv 2512.16959, DEV self-healing-job, Redpanda DLQ.

---

## 5. Self-Learning — conclusions (owner §6; evidence-only, Earn-It filtered)

**Decisive fact:** pre-launch, zero live outcome data, no reporting layer (RC-4 unbuilt, 0 views). **A model trained on no data is theater.** Almost nothing on the ML list should be *built* now.

**Earned now (not ML):**
- **Learning-ready outcome-event ledger** — immutable, timestamped, label-bearing events for every lead lifecycle transition (created → qualified → booked → paid → refunded/cancelled) with acting rep + assignment, captured **point-in-time-correct** to prevent the data-leakage bug (scoring a lead with data that only existed after it converted). This is a one-way door (cannot retroactively capture an outcome timeline). Distinct from "build the model."
- **Attribution feedback pipeline (b)** — ORVION's core purpose, deadline-driven (Data Manager API, June 15 2026). Learning/tuning content activates once outcomes flow.
- **Deterministic rule baselines** for scoring/routing/anomaly — the launch product AND the benchmark any future model must beat.

**Architecture:** in-DB pg_cron batch (≈80% of near-term value) + Edge Functions for genuine LLM calls. **No standalone ML service — ADR-0014 holds.** Models are consumers of the truth, writing re-derivable "opinion" columns; never the source of truth.

**Per-candidate Earn-It (verdict / data precondition / trigger):**
- (a) Lead scoring — design-now-as-rule / build-model at ≥~500–1000 resolved outcomes AND model beats rule on held-out data.
- (b) Attribution feedback — **adopt-now (design+pipeline)**; tuning with data.
- (c) ML routing — design-now-as-rules (SLA/skills) / ML deferred until stable per-rep close rates.
- (d) Anomaly/fraud — adopt-now-as-rules/thresholds / ML deferred to volume.
- (e) Demand/pricing — **reject** (ORVION doesn't own inventory/elasticity).
- (f) Next-best-action — defer (needs trained a+c).
- (g) RAG/pgvector (= DC-18) — design-aware / build at trigger (presence of unstructured text: transcripts/notes/emails).
- (h) NL-to-SQL — **reject raw**; documented accuracy collapse to 10–20% on real schemas; gate behind a governed semantic layer (RC-4) via Edge Function only.

**Governance note (from §7 G-fit):** Self-Learning has no current home → should enter via GOVERNANCE §3 decision lifecycle (PENDING → validated) before an ADR. Closest direction home: `PROJECT_CONTEXT.md §11` (Revenue Intelligence).
Sources: Breakcold/Frontiers, BNTouch, Google Ads Help 14274408, ALM Corp, Button Block (Data Manager sunset), Lead Distro, Digital Applied, devstarsj pgvector, AWS pgvector, Medium text-to-SQL cliff, dbt semantic-layer, arXiv 2604.25149.

---

## 6. External compatibility research — Google Ads / Meta / Integration / AI-BI (owner's core concern)

### 6.1 Google Ads (the core question: is a Supabase CRM compatible?)
**ANSWER: Yes. No partner/allow-list restriction. Custom Supabase ≠ disqualified.** (Data Manager API set-up-access, last updated 2026-07-10 — requires only a Google Cloud project, OAuth/service account, and access granted to the destination Ads account; no developer token, no vendor allow-list.) "Supported CRM" names are convenience connectors, not a gate.
- **Legacy GCLID path is CLOSED to ORVION:** from 2026-06-15 the old Google Ads API `UploadClickConversion` rejects tokens without prior upload history (~180-day window); ORVION has none → must use Data Manager API from day one.
- **Enhanced Conversions for Leads is ORVION's primary mechanism and fits Egypt:** matches on the lead's hashed phone (E.164 + SHA-256), no GCLID required; phone-only officially supported.
- **Consent Mode v2 mandatory only EEA/UK/CH, not Egypt** — but lawful consent to transmit PII still required globally. ORVION's `consent_ad_user_data`/`consent_ad_personalization` enum exactly matches Google's value set — keep it.
- **Verified schema gaps to close in Phase 8 (P6):** `offline_conversions` lacks `order_id` (dedup/adjustment key) and conversion-action mapping (event-type → Google conversion action id per tenant); hashed phone/email identifiers needed for EC-for-Leads; timestamp format `yyyy-mm-dd HH:mm:ss±HH:mm` at delivery (Egypt +02:00/+03:00).
- Sources: developers.google.com/data-manager/api/devguides/events/google-ads/offline (2026-06-16); .../quickstart/set-up-access (2026-07-10); ads-developers.googleblog.com/2026/05/changes-to-offline-click-conversion.html; developers.google.com/google-ads/api/docs/conversions/upload-offline; .../samples/upload-enhanced-conversions-for-leads; support.google.com/google-ads/answer/15713840, /13802165, /13695607, /16884284; searchengineland 477669.

### 6.2 Meta Ads + WhatsApp (workflows #1, #5, #6)
All supported against a custom Supabase backend (webhooks land on Edge Functions or n8n directly; ORVION owns the shared-inbox/assignment layer entirely — Cloud API has no native agent/assignment concept).
- Lead Ads: `leadgen` webhook → Graph API `GET /v25.0/<LEADGEN_ID>` → fields. Needs `leads_retrieval` + `pages_manage_ads`, App Review + Advanced Access + Business Verification, System User token. **Leads retrievable only 90 days.**
- WhatsApp Cloud API: `messages` webhook → lead. Business Verification, WABA, registered number, `whatsapp_business_messaging`, System User token. 24h customer-service window; business-initiated messaging limits (portfolio-level, start 250).
- Conversions API (Conversion Leads): `event_name` = free-form CRM stage sent sequentially; `event_time` within 7 days; `action_source='system_generated'`; `user_data` with **Meta Lead ID** (do NOT hash); `custom_data.event_source='crm'`. CTWA path uses `ctwa_clid`. SHA-256 hash em/ph/fn/ln/…; do NOT hash lead_id/ctwa_clid/fbc/fbp/ip/ua. Egypt phone `20…`.
- **Must-capture-now (before Meta intake go-live):** `meta_leadgen_id` (string, unique index), `meta_page_id/form_id/ad_id/adgroup_id`, `meta_lead_created_time`, `wa_id`, `phone_e164`, `wa_message_id`, `wa_phone_number_id`, `ctwa_clid`, inbound timestamp; `fbc`/`fbp`/`external_id`; consent (`consent_granted/timestamp/source`, `data_region`); `lead_source_channel` enum; CAPI tracking (`capi_last_event_name/sent_at/event_id`).
- **Start early:** App Review + Business Verification gate everything.
- Flags: Meta dev docs carry no visible dates (v25.0 current); no Egypt-specific CAPI/consent parameter (PDPL is external to Meta API); CTWA automatic_events availability to confirm per WABA.
- Sources: developers.facebook.com/docs/graph-api/webhooks/getting-started/webhooks-for-leadgen/; .../marketing-api/guides/lead-ads/retrieving/; .../permissions/reference/leads_retrieval/; facebook.com/business/help/734933888443065 & /1526849577619206; .../whatsapp/cloud-api/get-started/ & set-up-webhooks; .../conversions-api/conversion-leads-integration/payload-specification/; .../conversions-api/parameters/customer-information-parameters; .../data-processing-options/.

### 6.3 Integration & automation (workflows #3, #4, #9; informs CDD-7)
- **Single `app.ingest_lead` RPC = the only lead write-path** (P4); per-source adapters in n8n as pure translation (verify signature, bot-gate, normalize, pass native id as `external_id` idempotency key). Adding a source = one n8n workflow, zero DB change.
- **Supabase Database Webhooks are at-most-once, no retry, docs silent on delivery guarantees** (pg_net fire-and-forget; failed HTTP doesn't roll back and isn't retried). → A transactional outbox is **required, not optional** (P2/CDD-7): `id, event_type, aggregate_id, tenant_id, payload, idempotency_key (unique), status(pending|delivering|delivered|failed|dead), attempts, next_attempt_at, last_error`; drained by pg_cron + `FOR UPDATE SKIP LOCKED`; webhook **inbox** table keyed by provider idempotency id (unique) for free dedup.
- **n8n self-hosted, queue mode from day one** (Redis + workers), external Postgres (not SQLite). Native retry: `retryOnFail` 2–5 attempts, 0–5000ms; Error Trigger → DLQ. No built-in dedupe (build via idempotency key). Respond-2xx-fast then process async.
- **Framer forms officially support HMAC-signed webhooks** (doc dated 2026-06-15): `Framer-Signature` = HMAC-SHA256(payload+submission-id), `Framer-Webhook-Submission-Id` UUID, retries up to 5×, no 3xx-follow. → n8n verify → `ingest_lead`.
- **Boundary:** in-DB = all truth (validation, tenant resolution, assignment, state transitions, event emission, outbox write); n8n = edge translation only (provider sig verify, payload adapters, external API auth/format, retry/DLQ). No business logic in n8n (keeps it swappable per ADR-0014/0018).
- Flags: Supabase webhook retry/timeout semantics unverified (docs silent — treat as at-most-once); n8n queue-mode throughput numbers from third-party 2026 guides; Google/Meta exact field mappings design against official docs at build.
- Sources: framer.com/help/articles/framer-form-webhook-setup/; supabase.com/docs/guides/database/webhooks & functions; docs.n8n.io error-handling / respondtowebhook / errortrigger / webhook.

### 6.4 AI/BI dashboard (workflow #10)
- **The governing security fact:** a BI tool connects as ONE Postgres role; RLS only enforces for `authenticated`/`anon` carrying a JWT. A tool on a fixed/service role (often BYPASSRLS or owner) **sees every tenant's rows.** Views respect RLS only if `security_invoker = true` (PG15+); a plain owner-view **silently bypasses RLS**; **materialized views cannot carry RLS at all** (Supabase advisor 0016 flags API-exposed matviews).
- **Recommendation: Apache Superset (Apache-2.0, free) over native Postgres RLS.** Superset's RLS + SSO are free/in-core; Metabase's tenant isolation is **paid, tool-layer**. Connect via a **read-only, non-BYPASSRLS** role + per-tenant JWT/RLS passthrough — never `service_role`/owner.
- **Read-model (RC-4) build:** `security_invoker=true` reporting views over core tables; for heavy aggregates use **`tenant_id`-scoped aggregate TABLES with RLS**, refreshed by a `SECURITY DEFINER` RPC on pg_cron (NOT API-exposed matviews). Consume canonical handoffs (e.g. `app.lead_booking_readiness`). No warehouse (exports data out from under RLS — violates "ORVION owns the truth"). NL-to-SQL deferred until a governed semantic layer exists (Wren AI's governed model is the safest future candidate).
- Flags: verify Metabase paid-tier RLS boundary + Superset embedding SDK against current docs; Vanna 2.0 "RLS" claim is vendor's own — audit whether it enforces at Postgres layer; no turnkey "Superset + Supabase JWT passthrough" recipe found (needs a spike).
- Sources: metabase.com/docs/latest/embedding/tenants & permissions/row-and-column-security; supabase RLS docs + advisor 0016; dev.to postgres-views RLS gotcha; supabase discussion #17790; getwren.ai; Basedash 2026 comparisons.

---

## 7. Verification pass — five specialist findings registers (READ-ONLY; from source unless noted)

### 7.1 Business/domain canon (00–23)
Headline: **no live architectural contradiction survives** — every candidate against ADR-0014/0015/0016/0017/0018 is already reconciled by a later ADR/SPEC. Debt = un-annotated supersession + one naming divergence. All fixes are documentation-annotation (protected `_ORVION_CANONICAL/**` → owner-gated).
- F-01 (Med) Plan names: `09` says Basic/Integrated/Complete; `17`/`25`(seed)/`14` say Starter/Professional/Enterprise. Real wrong-impl hazard. → annotate `09`.
- F-02 (Low-Med) Excel: `01`/`08` permit upload; `16` forbids for MVP. → annotate `01`/`08` to defer to `16`.
- F-03 (wide) Auth prose in `09/19/20/10` predates ADR-0017 (phone-as-login, per-device email-OTP, ORVION-owned OTP tables). Behavior already follows ADR-0017 (artifacts→Supabase Auth; ORVION owns policy; high-risk-role TOTP via `aal`). → add "superseded by ADR-0017" banner.
- F-04 (Low) "Activation code" idea (`09`) dangling — neither adopted nor rejected. → owner-decision (backlog or Rejected).
- F-05 (Low) Subscription read-only-mode + 2-day grace (`01`/`09`) is a designed MVP capability, deferred by ADR-0016/0013 — ensure future-backlog carries the grace/read-only predicate so it isn't lost.
- F-06 (Low) `15` role list omits Finance Manager + System Administrator (authoritative set is `28`). → align/annotate.
- F-07 (Low) `18` integration order diverges from roadmap `32` (soft; `18` self-hedges). → pointer to `32` as authoritative sequencing.
- Watch: `15:80-88` "separate roles/permissions/scope" could be misread as license to add scope columns to `role_permissions` — ADR-0015 governs (binary; scope at point-of-use). Add a pointer.
- Confirmed CONSISTENT: `21` (offline conversion — carries GBRAID/WBRAID/consent/Data Manager note), `04/12/13` (statuses match seeds; SLA/gate match ADR-0018/0020), `05` (ADR-0019), `06/07/14` (ADR-0020/0021), `00/03/22/23/02/11`.

### 7.2 Governance & ADR layer
Coherent: precedence chain (AGENTS/GOVERNANCE/CR_LIFECYCLE) clean; retired-doc tombstones correct; CR state machine consistent; ADR log append-only with cross-linked supersession; Earn-It/LBD/TBA each have a single home. Next ADR number = **ADR-0022**. Master overlay §B already pre-stages CDD-7/N1/N5 as proposed ADRs.
- F1 (Med) `manifest.md:45` points a fresh session at retired `PROTOCOL.md` as an execution-rules authority. → drop "and PROTOCOL.md" (manifest routine-editable).
- F2 (Low-Med) `MASTER_ARCHITECTURE_DECISIONS.md:5` "Last updated 2026-07-11" stale vs content. → refresh.
- F3 (Med, owner-gated) `AGENTS.md §6` protected-resources list OMITS GOVERNANCE.md + CR_LIFECYCLE.md → an agent trusting §6 alone could edit governance as unprotected. → add a pointer to GOVERNANCE §5 registry (not a second list).
- F4 (Low, owner-gated) `AGENTS.md:83` hardcodes "71 tables" (drift risk). → replace with pointer to `verify_database.sql` expected count.
- **G4 One-Authority correction (critical):** the Impl→Discovery→Evidence→Fix→Permanent-Test→Sync loop ALREADY lives in `GOVERNANCE.md §18` (discovery-to-guard loop), and `AGENTS.md:36` already points to it. "Evidence-gated authority over closed work" already in `CR_LIFECYCLE.md §4` + ADR-0015/0016 escalation triggers. → persist owner's principles in AGENTS.md as **pointers, not restated bodies**; if the loop's home should move to AGENTS.md, retire the GOVERNANCE §18 body to a pointer (fact lives in exactly one place).
- Fit conflicts to resolve atomically: manifest "Next: Start Phase 8" vs inserting CDD-7/N1 (repoint together); `future-backlog.md` marks airports/airlines "not approved" → must be promoted out per its graduation rule (else live drift); DC-1 implemented (SPEC-118) but may still sit "Proposed/conditional" in the ADR overlay → reconcile/ratify; Self-Learning needs a decision-lifecycle entry before an ADR.

### 7.3 Master reports suite (13 files) — root cause: half-propagation after SPEC-118/119 (manifest/roadmap advanced to 07-13/14; 11 Master files still "07-11"). Most fixes within authority (`reports/**` agent-writable).
- F1 (High) `MASTER_GAP_REGISTER` DC-16 table row OPEN vs its own detail block + 2 files DONE. → flip row to ✅.
- F2 (High) A1/A2 OPEN in gap register, DONE everywhere else (A2 = partial: bare-index done SPEC-114, composite deferred). → update rows.
- F3 (High) `MASTER_CERTIFICATION_STATUS` still requires DC-13 (UUIDv7) which was DEFERRED (session 4) → gate currently unsatisfiable. → remove DC-13 from Batch-0 gate.
- F4 (High) Cert gate not updated for DC-1/R5 completion.
- F5 (Med-High) `MASTER_COVERAGE_SCORE` deductions cite resolved R5/DC-1/A1; 82% not recomputed.
- F6 (Med) Completion %: 82% (Coverage, SSOT) vs 84% (Domain Catalog). → align (Cert 84% is inside a dated history entry — verify intent).
- F7 (Med) Catalog-type count 61 (Masters) vs **65 (roadmap; verified correct in seed `202607043100`)**. → correct 61→65.
- F8 (Med) `MASTER_DESIGN_CHECKLIST` not advanced for DC-16/DC-1/R5/A1/A2 (design-vs-impl interpretation — owner call on whether SPEC-complete reads `[✓]`).
- F9 (Low) "12 vs 13 Master documents."
- F10 (Low, VERIFY) RLS-policy count roadmap 76 vs Execution Plan 63 — may count different sets (all policies vs tenant-SELECT wrapped); needs live DB.
- F11 (Low, VERIFY) "~54 app RPCs" vs "55 functions" vs "66 functions" — different denominators; needs live DB.
- Consistent: table count 71; ADR ledger 0001–0021 matches overlay; dependency-graph vs execution-plan ordering; Risk Register RK-01 ✅RESOLVED (SPEC-118); Data-Flow/ER-Map/Heat-Map are design maps not status ledgers.

### 7.4 Schema canon vs implementation (from source; local DB container not running)
CLEAN (refutes suspected drift): OK-1 table parity 71; **OK-2 DC-1 money precision fully applied** (`202607048600` widens all 21 money columns to `numeric(19,4)`; pgTAP `03_money_currency_precision_test` is a hard gate; DC-1 CLOSED); OK-3 RLS coverage + A1 initplan wrapping (`202607048500`, pgTAP `06`); **OK-4 B5 DML grants RESOLVED** (`202607043400` grants select/insert/update on tenant tables; select/insert on append-only events — not inert); OK-5 CI genuinely gates (`migration-ci.yml` runs supabase start → db reset → pgTAP → smoke-test w/ ON_ERROR_STOP); OK-6 six pgTAP guards present.
FINDINGS:
- **F-1 (High) — S-EVENT root:** `events.event_type_code` is `text not null` with NO FK/CHECK; no `event_type` catalog seeded; the ~150-event canon-27 vocabulary is **unenforced free text** — no single authority governs event codes. → this is precisely what N1 fixes; add `event_type` catalog + FK or pgTAP guard asserting emitted ∈ canon.
- F-2 (Med) Emitted codes drift from canon-27: `internal_supplier_linked` (canon `internal_supplier_link_created`), `receipt_issued` (canon `receipt_created`); `invoice_issued/invoice_paid/invoice_partially_paid/supplier_payment_recorded/refund_requested` emitted but absent from canon-27. → reconcile canon-27 ↔ emitters (one authority).
- F-3 (Med) `quotations`/`quotation_items` CONFIRMED inert (tables+RLS+trigger exist; zero writers; no quotation RPC; canon-27 quotation events never emitted). Expected (unbuilt slice) — track in backlog, not a defect.
- F-4 (Low-Med) `chart_of_accounts.account_type`, `financial_accounts.financial_account_type_code`, `events.severity_code` — ungoverned free text (no catalog/FK). → seed catalog + FK when finance reporting built.
- F-5 (Low) `security_events.security_event_type_code` free text (no FK to its own seeded catalog); seeded values mismatch canon-27 auth names (`otp_request` vs `otp_requested`, `new_device_verification` vs `trusted_device_created`, `permission_change` vs `role_assigned`).
- F-6 (Info) Booking-item roll-up "stored but unconsumed" — **REFUTED**: no stored booking total exists (`bookings` has no money column); totals computed on demand (`customer_balance`, `booking_item_profit`). No action.
- Unverifiable from source: catalog counts 65 types/395 values (CI-guarded at runtime; not independently counted).

### 7.5 UUIDv7 — see §3 (full).

---

## 8. Consolidated Synchronization Findings Register (the correction plan)

**One HIGH real gap:** S-EVENT (§7.4 F-1/F-2/F-5, §7.2 events) — canon-27 event vocabulary unenforced + drifting → fixed by N1 (elevates P2/N1 urgency from "substrate" to "arrests live drift") + a one-authority canon-27↔emitters reconcile.

**Master-suite staleness (S1–S9; `reports/**`, within authority):** DC-16 row (S1), A1/A2 rows (S2), cert gate DC-13 removal (S3), cert gate DC-1/R5 (S4), coverage recompute (S5), 82%-vs-84% (S6), catalog 61→65 (S7), design-checklist (S8), 12-vs-13 (S9).

**Canon annotation debt (C1–C7; `_ORVION_CANONICAL/**`, owner-gated):** plan names (C1), Excel (C2), auth prose banner (C3), activation-code + subscription-grace routing (C4/C5 → owner decision), role list (C6), integration order (C7).

**Governance structural (G1–G4):** manifest→PROTOCOL pointer (G2, routine), AGENTS §6 protected list (G1, owner-gated), AGENTS "71 tables" → pointer (G3, owner-gated), **G4 One-Authority: loop→pointer not body (owner-gated)**.

**Atomic sequencing/status (A1–A4):** manifest "Next: Start Phase 8" repoint with roadmap when CDD-7/N1 insert (A1); promote airports/airlines out of backlog (A2); reconcile/ratify DC-1 ADR overlay (A3); amend ADR-0002 for UUIDv7 (A4).

**Pending live-DB verification (V):** RLS policy count 76-vs-63 (F10); RPC count ~54/55/66 (F11); catalog 65/395 confirmation. Run at next `db reset` (or via Postgres MCP).

---

## 9. Two-track execution plan (proposed; not yet executed — awaits owner go)

**Track 1 — apply immediately on owner go (within authority: `reports/**` agent-writable + living manifest):** Master-suite staleness sweep S1–S9; write the S-EVENT reconciliation plan into the gap register; manifest PROTOCOL pointer (G2). Commit.

**Track 2 — present protected-doc diffs for owner sign-off BEFORE writing:** all `_ORVION_CANONICAL` annotations (C-series); AGENTS.md changes (G1/G3/G4 + persist owner principles as pointers); roadmap resequence (P1/P2/P3 + A1/A2); new ADRs 0022+ (app/access phase; CDD-7+N1; unified ingest+consent; Data Manager transport; self-learning posture; airports/airlines) + ADR-0002 amendment (UUIDv7). Then rebuild the single coherent roadmap and begin implementation under the full lifecycle loop with whole-system verification per change.

---

## 10. Open questions / owner decisions still pending
1. **Airline data license (BLOCKER for airline seed):** OpenFlights ~US$100 commercial license / Wikidata CC0 rebuild / official IATA DB — or airports-only for now. (Airports have clean CC0 via OurAirports; timezone backfill from MIT `lxndrblz/Airports`, NOT OpenFlights ODbL.)
2. Approve the consolidated package §8 (all or item-by-item) and confirm G4 (loop→pointer) + A4 (UUIDv7 commit-now-swap-at-PG18).
3. C4/C5 dispositions (activation-code idea; subscription grace/read-only home).
4. F8 interpretation (should a SPEC-complete design-checklist item read `[✓]`?).
5. Whether to keep Phase 8 next (then P3 reorder is moot) or adopt P3 (reporting first).

## 11. Assumptions still requiring verification (Test-Before-Assume)
- Live-DB counts: RLS policies (76 vs 63), RPCs (~54/55/66), catalog (65 types / 395 values) — DB container was down; verify at next `db reset`.
- Supabase PG18 GA date (slipped past Jan 2026; no official date) — gates the UUIDv7 swap trigger.
- P1's B5 premise: reconcile the "clients cannot access tables" framing against OK-4 (grants ARE applied) — the real remaining gap is the API/UI surface + DC-23, not the grants.
- Meta dev-doc freshness (no visible dates; Graph v25.0 current); CTWA automatic_events availability per WABA.
- Google universal offline conversion-window max (per-conversion-action, not one fixed number; treat 90 days as common configurable max — confirm at build).

## 12. Airports & Airlines — design summary (owner §7; full design in §6-adjacent research)
Design as ADR-0010 natural-key reference tables (global, no tenant_id, `is_active`, moddatetime). `airports` PK = IATA 3-letter (+ unique ICAO; timezone IANA; country_code FK; metro/city codes as `type='metro'`). `airlines` PK = IATA 2-char (+ ICAO, callsign, accounting/prefix code for ticketing, country_code FK, alliance). Aircraft-types/cities/tenant-override/temporal-history all deferred (YAGNI, no consumer). **Build/seed nothing until the first flight-booking consumer column is specced** — then table + loader (CC0 CSV upsert, not inline seed) + FK ship together in one earned migration. Booking FKs (carrier_code/origin/destination → airports/airlines, `on delete restrict`) added additively alongside the consuming column; no reopening of frozen booking schema. Sources: OurAirports (CC0), IATA codes, IATA accounting/prefix PDF, AltexSoft, lxndrblz/Airports (MIT).

## 13. Rejected under Earn-It (do not re-propose without new evidence)
UUIDv7-forced-now-on-PG17 (throwaway shim; §3); standalone microservice (ADR-0014 — duplicates DB authz); travel reference tables as speculative (superseded by owner §7 promotion for airports/airlines specifically — others still deferred); saga compensation (no distributed txn); ML anomaly detection now (no metrics surface); external queue Redis/BullMQ (single poller sufficient); raw NL-to-SQL (accuracy cliff); demand/pricing models (no inventory data); warehouse for RC-4 (exports out from under RLS).

---

End of checkpoint. Nothing from the session should now exist only in chat. Continue from this preserved engineering state.
