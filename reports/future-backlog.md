# ORVION Engineering Future Backlog

Version: 0.1
Status: Living document (not canonical, not a Change Request)
Owner: maintained by the engineering/audit role during Change Requests and reviews

---

## Purpose

A permanent, evidence-driven record of valuable engineering ideas that are **not yet justified for immediate implementation**, so nothing important is silently forgotten or silently implemented. This is **not** a Change Request, not implementation work, and not a wish list — every entry must be backed by repository or authoritative external evidence, carry a classification, and state its trigger (when it should be reconsidered). Items graduate out of this backlog only through their own Change Request.

Classifications: **Required Soon**, **Recommended**, **Nice to Have**, **Future Candidate**. Review this document at the start of each new phase and whenever a listed trigger is reached.

---

## Required Soon (evidence-backed, near-term)

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| ~~Reference Data Layer — core (countries, nationalities, languages, currencies)~~ — **DONE** (verified 2026-07-13 live-DB audit) | Core reference tables exist and **all 19 reference-code columns are FK-backed** (`passengers.nationality_code`/`passport_issuing_country_code`, `customers.preferred_language_code`, `bookings.destination_country_code`, all `*currency_code`). The "no integrity backing" concern is resolved. | Closed | Implemented (reference tables + FKs) |
| Reference Data Layer — travel-specific (cities, airports) | Still free-text/absent; distinct from the core layer above. Tracked as domain reference expansion. | See **Future Candidates — Domain Reference Layer Expansion** below (evidence-gated: a migration must introduce a column needing the integrity) | Yes, when promoted |
| ~~Table-level CHECK constraints from `31` "Rules"~~ — **DONE** (verified 2026-07-17 against migrations) | All five `31`-Rule invariants are DB-enforced in their creating migrations: journal debit/credit exclusivity + non-neg (`042500`), `booking_items`/`booking_item_passengers` non-negative (`042300`), `document_links` single-target (`042800`), `document_versions` single-current partial-unique (`041900`), passenger `passport_issue < expiry` (`042200`). This row was stale. | Closed | Implemented in the Phase-2 table migrations |
| Process safeguard for Complete-sync | The `Active Change Request` pointer-clear was omitted twice (SPEC-024, SPEC-027). A Claude Stop/PostToolUse hook (or scripted check) verifying `Active Change Request: None` after Complete would prevent recurrence. | Any time | Yes — small `settings.json` CR |

## Identity Lifecycle (from the 2026-07-04 Identity Lifecycle Review; SPEC-031 resolved the nullability contradiction)

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| `auth_user_id` → `auth.users(id)` referential action | Determines what happens if a Supabase admin deletes an auth user. SPEC-027's default `on delete restrict` would *block* that deletion; `on delete set null` lets the ORVION user survive unlinked/re-invitable. Must be a conscious choice, not defaulted. | **Migration 5 Design Review Gate** (recommend `set null`) | Decided within the Migration 5 CR (not a separate CR) |
| Invitation / activation lifecycle model | "Invited-but-not-activated" is currently only implicit (`is_active=false` + `auth_user_id` null). No invitation record, `invited_at`/`activated_at`, `invited_by`, user status/state machine, or activation/deactivation events (`26`/`27` have none for users). Re-invite reuse-vs-new is undefined. | After Migration 5 (users table exists); when the invitation UX is designed | Yes — its own feature CR |
| `users` deletion/archive clarification | `users` uses `is_active` (deactivate), has no archive fields, and is not in `30`'s no-physical-delete list — so hard-delete isn't explicitly forbidden. Clarify: deactivate-only, or add `users` to the no-physical-delete rule. | Documentation checkpoint before RLS/audit hardening | Small canonical CR if a rule is added |
| ~~Auth-support tables belong to the human, not the membership~~ — **RESOLVED** (SPEC-046 / ADR-0012) | Decided: `trusted_devices`/`otp_challenges`/`totp_enrollments` re-home to the Human Identity, keyed by `auth_user_id` → `auth.users(id)`, no `tenant_id`, cascade on human deletion. Governed by `34_authentication_and_identity_principles.md` (Principles 1/6/7). `31` §9 and `33` migration 16 amended. | Closed 2026-07-05 | Implemented by SPEC-047 (Migration 16) |
| Active-tenant RLS context (SPEC-033 / ADR-0011) | RLS must resolve `auth.uid()` + active-tenant → membership; degrades to the single membership when a human has one. The active-tenant claim/plumbing is only wired up when multi-membership UX ships. | **Migration 19** (RLS) design | Part of the RLS migration |

## Business-Key Uniqueness (from Migration 10, SPEC-040)

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| ~~`bookings.booking_reference` / `quotations.quotation_number` per-tenant unique~~ — **DONE** (migration `048800`, 2026-07-17) | `unique (tenant_id, booking_reference)` / `unique (tenant_id, quotation_number)` added; canon `31` synced. The deferred *format/sequence* decision (SPEC-073) remains separate and open — the uniqueness guard does not decide it. | Closed | Implemented (migration 048800) |

## Business-Key Uniqueness (from Migration 14, SPEC-044)

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| ~~`subscription_plans.plan_code`, `feature_entitlements(subscription_plan_id, feature_code)`, `usage_counters(tenant_id, usage_metric_code, period_start, period_end)` uniqueness~~ — **DONE** (migration `048800`, 2026-07-17) | Added `unique (plan_code)` (platform-global — `subscription_plans` has no `tenant_id`), `unique (subscription_plan_id, feature_code)`, `unique (tenant_id, usage_metric_code, period_start, period_end)`; canon `31` synced. | Closed | Implemented (migration 048800) |

## Finance Value Non-Negativity (from Migration 12, SPEC-042)

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| ~~Non-negative CHECKs on finance money columns~~ — **DONE** (migration `048800`, 2026-07-17) | Added `>= 0` CHECKs on `invoices.total_amount`, `payments.amount`, `refunds.amount`, `payment_allocations.allocated_amount`/`allocated_amount_invoice_currency`; canon `31` synced. Parity with the existing `booking_items`/`journal_entry_lines` guards. (`receipts` intentionally excluded — it has no amount column; it references a payment.) | Closed | Implemented (migration 048800) |

## Role Privileges (from Migration 19, SPEC-052)

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| DML `GRANT`s to `authenticated` on tenant/global tables | Migration 19 delivers RLS (row-scoping), but RLS sits *on top of* table privileges. Verified: `authenticated` has only `TRUNCATE/REFERENCES/TRIGGER` (Supabase default), **not** `SELECT/INSERT/UPDATE/DELETE`, so end-user clients cannot access any table yet. Current state is safe (fully locked), not a hole. The grant model (broad-with-RLS vs granular; whether `anon` gets read on global/reference tables) is an access-layer decision that pairs with the API/backend design, and there is no client consumer yet. | **Backend/API phase** (first client integration) | Yes — grant DML to `authenticated` (RLS enforces rows); decide `anon` read scope |

## Naming Consistency (from the Database Naming Audit, post-Migration 20)

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| Status-column naming normalization | The audit found the schema otherwise fully consistent (constraints/indexes/table-plurals/`_at` timestamps/`_id`-vs-`_by`-vs-`_user_id` FK conventions). The one real inconsistency: `tenants.status` and `company_assets.status` use bare `status`; `invoices`/`marketing_campaigns`/`otp_challenges`/`subscription_payment_proofs`/`trusted_devices` use unprefixed `status_code` vs `<entity>_status_code` elsewhere. Cosmetic (functional today), no current consumer, but renaming post-code is a breaking change across API/frontend/queries. | **Backend/API phase start** — before any code references these columns; still cheap then, and pays off when consistency matters | Yes — small `31` amendment + `ALTER ... RENAME COLUMN` migration. Optionally include the two non-`is_`/`has_` booleans (`finance_approval_required`, `marketing_opt_in`) if a strict Boolean Standard is enforced. |

## Pre-Phase-8 Audit Orphans (from the 2026-07-13 readiness audit)

Capabilities surfaced in `reports/history/` phase reports and confirmed present-but-inert by the 2026-07-13 live-DB + reports audit — previously tracked in **no** living register. Promoted here so they are not re-discovered. Each is evidence-backed with a trigger; cross-refs avoid duplicating existing IDs.

| Item | Evidence | Trigger / when | CR? |
| --- | --- | --- | --- |
| **Quotations are inert** — tables `quotations`/`quotation_items` + state machine (`26`) + events exist, but there are **no quotation RPCs** (verified: 55 `app` RPCs, none create/advance a quotation); `advance_lead` sets `quotation_sent` with no `quotations` row → "a lead flag with no entity behind it" | `reports/history/phase-05-finance-gate-readiness.md` §3B/§4; live RPC inventory | When the Sales quotation-issuance workflow is scheduled | Yes — quotation RPC set + link `bookings.quotation_id` |
| **Event-requirements (`28`) — partly by-design (corrected 2026-07-17 vs implementation).** `lead_created` is **NOT a gap**: `app.create_lead` deliberately emits no creation event ("events are mandated on transitions… earned at the assignment capability", migration `044300` rationale) — ORVION emits on state transitions, not initial creation. Role-assigned/permission-change security-event emission is **still to be verified** per-RPC (not assumed missing). | migration `044300` header; `phase-03/04/05` reports | Verify security-event emission per-RPC before Phase 8; relates to register **N1** | Only for events verified missing against implementation |
| **Booking-item roll-up never consumed** — item cost/selling + passenger overrides stored but never rolled to an item/booking total; `finance_approval_required` set but never read | `phase-05` §4 | With invoicing depth; relates to register **R3** (invoice_lines) | Within the finance/invoicing CR |
| **Finance-gated booking transitions partial** — only the execution-approval slice (SPEC-081) built; `confirmed`/`issued`/`void`/`refunded`/`reissue`/`completed` + capability set (Submit/Approve/Issue/Cancel/Refund/Reissue) still per-consumer | `phase-05`; ADR-0020 | As each booking consumer is built | Per-consumer CRs |
| ~~`chart_of_accounts.account_type` has no governing catalog~~ — **NOT A GAP (corrected 2026-07-17)**. `account_type` is **plain text by ratified decision ADR-0006** (`journal_entries.sql:9`), consistent with the canon-30 type-code convention (plain text; validity via seed + app logic; no FK mandated). Values are the standard accounting types seeded by `app.seed_default_chart_of_accounts` (asset/liability/equity/revenue/expense). Nothing to implement. | ADR-0006; `journal_entries.sql:9`; canon `30` §type-codes | Closed | None — ratified as-is |

## Recommended (evidence-backed, medium-term)

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| DB-enforced event immutability | `30` forbids updating events but nothing enforces it; a trigger/RLS blocking UPDATE/DELETE on `events`/`security_events` hardens audit integrity. | Events migration (13) or RLS (19) | Yes |
| `pg_trgm` fuzzy matching | Real duplicate-detection intent (`customer_identity_signals`, name/phone). `pg_trgm` + GIN indexes materially improve fuzzy matching. | When CRM identity/dedup is built | Yes (enable-extension step) |
| RLS sequencing confirmation | All RLS deferred to Migration 19; acceptable because `config.toml` does not auto-expose new tables. Confirm no client access to tenant tables before 19; if incremental client use is planned, enable RLS per-table instead. | Before any client integration | Decision; possibly CR |
| Disable Docker `tcp://localhost:2375` (no-TLS daemon exposure) | Enabled during a past environment repair. **Evidence (2026-07-13): no longer required** — all `docker`/`supabase`/MCP operations run over the default named pipe with no `DOCKER_HOST` set. It **fails Earn-It** (zero measurable benefit) and carries a real security cost (unauthenticated root-equivalent Docker/host control on localhost, reachable by any local process incl. `npm`/`npx` postinstall). Kept for now only to avoid changing a variable right before the comprehensive review. | **After the comprehensive ORVION review completes** — disable via Docker Desktop → Settings → General, then re-run the full environment health check. If everything works without 2375, removal permanently earns it; if something breaks, investigate the dependency before further change. | No — a config toggle + verification, not a repo CR |

## Engineering Methodology Artifacts (approved 2026-07-04)

| Item | Why it matters | Status / trigger | CR? |
| --- | --- | --- | --- |
| Architecture Decision Records (ADR) | Preserve reasoning behind major decisions for future contributors. | **Created** — `reports/architecture-decision-records.md` (seeded, ADR-0001..0010). Append a new ADR when a genuinely architectural decision is made. | No (living doc); new ADRs added inline |
| Database Naming Audit | Catch table/column/index/constraint/trigger/function/view/migration naming inconsistencies before the schema grows large. | **Recommended** — run at a milestone (e.g., after the Configuration + Core-Business tables, before the schema passes ~half of 71 tables). Findings surfaced as CRs, never silent edits. | Yes, if inconsistencies found |
| Migration Regression Checklist | Confirm each migration's tables/FKs/constraints/indexes/triggers/functions/extensions/RLS/views match both the canonical docs and the migration spec. | **Active** — already performed as the post-migration Database Audit (SPEC-024 onward). Keep applying; consider scripting it once the object count grows. | Optional (a script would be its own CR) |
| Migration Dependency Graph | Prevent accidental ordering-dependency violations. | **Partially exists** — `33_sql_migration_plan.md`'s "Depends on (#)" column is the current graph. An explicit standalone graph is a Nice-to-Have enhancement once the sequence is deep. | Nice to Have |

## Nice to Have (future optimization)

| Item | Why it matters | Trigger |
| --- | --- | --- |
| `pg_cron` scheduled jobs | OTP cleanup (Deletion Rule), subscription grace→read-only transitions, `usage_counters` rollups. | When those lifecycles are implemented |
| Declarative partitioning | High-volume tables (`events`, `conversation_messages`, `security_events`, `campaign_daily_metrics`, `attribution_clicks`) at scale. | When data volume warrants; not before real load |
| `citext`, partial indexes, generated columns | Case-insensitive emails; `document_versions WHERE is_current`; derived `full_name` as GENERATED. | Per-migration micro-optimizations |
| Impeccable (`pbakaus/impeccable`) — frontend design skill pack | Evaluated 2026-07-13 and **intentionally deferred** (not rejected). It is 100% frontend/UI tooling (typography, color, motion, visual-hierarchy critique, browser Live Mode, 44 frontend detector rules). ORVION is backend-only today (no UI surface), so an agent could not use it — it fails Earn-It *now*, not permanently. Recorded so future agents do not re-run this research. | **Trigger: the first real application UI / dashboard implementation.** Same trigger class as Playwright (`.workstation/manifest.md §4`). |

## Structural-Completeness Assessment (2026-07-17, under the Fundamental-Domain-Structure principle, `AGENTS.md §3`)

Owner directive: inevitable *domain structure* belongs in the repo now even without a consumer; only *features/infrastructure* are Earn-It-deferrable. Applying the 6-criteria test (+ the 5-year question) to every remaining structural candidate against the built schema (71 tables, 79 catalog families, all reference-code columns FK-backed). Finding: ORVION is already structurally near-complete; each remaining candidate fails at least one criterion — **not** blind-add foundational.

| Candidate | Verdict | Reason (which criterion fails) | Promotes when |
|---|---|---|---|
| Airports / airlines / cities (reference tables) | **Trigger-defer** | "Architecturally-correct *now*" fails — the validated shape (timezone/coords/ICAO/metadata) is driven by the **unbuilt flight-ticketing** feature; canon 25 §Reference Data defers on exactly this. Empty pre-creation avoids no FK-wiring migration and risks a wrong-shape one. | Flight-ticketing design (defines what airport/airline metadata must be validated) |
| First-class `invoice_lines` (+ tax lines) | **Owner decision** | Not inevitable for ORVION — current model *derives* invoice detail from linked `booking_items`; lines-as-table vs derived-detail are two valid models; tax/VAT lines are a compliance decision (ETA e-invoicing). | Owner selects the invoicing model |
| Document-number sequences (booking/invoice/quotation/receipt) | **Owner decision → then foundational** | Structure is modelable but the **format/scheme** is a business decision (SPEC-073 deferred it); uniqueness already guarded (migration 048800). | Owner sets the identifier-format policy |
| Structured address model | **Defer** | Not clearly canonical — ORVION uses `customer_contact_methods`; free-text/JSON addresses are a valid mature-SaaS choice; no evidence it's required. | Evidence a validated address is needed |
| Aircraft types, hotel chains, fare-class detail, GDS/PNR structures | **Feature-defer** | Feature-specific ticketing internals, not stable domain structure. | Their feature's design |

Rationale recorded so this is not re-litigated: the comprehensive up-front design is *why* little inevitable structure remains. Two owner decisions (invoicing model; identifier format) would each unlock foundational structure that would then be added immediately, not deferred.

---

## Strategic Direction & Future Domains (evidence-backed; guides later phases)

Forward-looking direction validated by research (2026-07). These do not change the current roadmap; they orient the later integration phases and are recorded so the direction survives without conversation history. See `PROJECT_CONTEXT.md` §11 for the vision framing (ORVION as source of truth; external platforms are consumers).

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| ~~Attribution capture at lead intake (`gclid`/`gbraid`/`wbraid` + consent `ad_user_data`/`ad_personalization`)~~ — **capture side DONE (SPEC-119 / R5)** | Click IDs are unrecoverable retroactively, so the columns had to exist before Phase-8 intake. `attribution_clicks` now carries `gbraid`/`wbraid` + consent signals; `leads` carries a first-touch `attribution_click_id` anchor. | Closed 2026-07-13. **Still open (delivery side):** the outbound transport — Google's **Data Manager API** + consent mode (legacy Ads offline import blocked 2026-06-15) — is an owner decision to settle in Phase 8's first Design Challenge. | Capture: implemented (SPEC-119). Delivery: Phase-8 CR |
| Customer Communications as a first-class capability (company-owned conversations, unified inbox, assignment, transfers, internal notes, timeline, attachments) | Replaces operational dependence on employees' personal WhatsApp; the shared-inbox/collaboration layer is built on the Cloud API, not native to it. **Architectural shape deliberately UNDECIDED** — decide via a proper Design Challenge among standalone domain / CRM capability / Customer Workspace / Automation, on evidence. Design channel-agnostic (WhatsApp is one channel; email/SMS/in-app others), reusing the event backbone + Phase-7 document linkage. | **After Phase 7 (Documents)** — that provides the attachment substrate conversations reference | Yes — its own domain CR(s), preceded by Learn-Before-Designing research |
| Full Meta-ecosystem research | Before designing the communication/marketing layer: Meta Business Platform/Portfolio, WhatsApp Business Platform, Marketing API, Messenger, Instagram Messaging, Embedded Signup, System Users, App Review, Business Verification, conversation ownership, shared-inbox architecture, multi-agent messaging. Per `AGENTS.md` §3 Learn-Before-Designing. | Communication/marketing layer (Phase 10 or the Communications domain) | Research task, then design CR(s) |
| Revenue Intelligence delivery posture | Later integrations (Phase 8 Google Ads, Phase 10 Meta/analytics) are **outbound/push, ORVION-owns-the-truth**: ORVION emits verified events/values; platforms ingest. Do not build a home-grown attribution/measurement black box — deliver to each platform's ingestion API. | Phases 8 and 10 design | Within those phases' CRs |

## Group 3 architectural determinations (2026-07-17, Chief-Architect review under full delegation)

Reconstructed from implementation; each "Group 3" capability assessed for whether a full ADR is *earned now* (Earn-It / Learn-Before-Designing "study the strongest implementations at the trigger, not before") versus deferred with a trigger.

| Capability | Determination | Trigger for a full ADR |
|---|---|---|
| **FX / presentation currency** | **RESOLVED via ADR-0022** as the one isolated owner business-policy decision (per-currency default vs single presentation currency). The FX conversion primitive (`reporting.convert_amount` over the existing `exchange_rates`) is designed and additive; built only if the owner elects single-currency. | Owner selects single-currency presentation |
| **Read-model / reporting** | **RESOLVED — ADR-0022** (full architecture, implementation-ready). | Done |
| **Quotations workflow** | Deferred. Schema + state machine + events exist (inert). A full ADR needs the *business* quotation→booking workflow (product decision), not derivable from implementation. Not on the P9→P8 critical path. | When the Sales quotation-issuance workflow is scheduled |
| **Subscription lifecycle** | Deferred by ADR-0016 ("separate future slice"). Full schema exists; lifecycle RPCs need subscription-*strategy* (owner business policy: plans, grace, billing). Phase-9 reports the *state*; it does not require the lifecycle to exist. | Subscription/billing go-live decision |
| **Communications domain** | Deferred — shape explicitly undecided; requires Meta-ecosystem Learn-Before-Designing (per PROJECT_CONTEXT). Premature to ADR now. | First customer-communications capability (post-attachment substrate, Phase 7 done) |
| **Notifications delivery** | Deferred. In-DB notifications are written (e.g., SLA); external delivery needs the outbound infra decision (Edge/n8n/pg_net) shared with Phase 8. Fold into the Phase-8 outbound-infra ADR rather than a standalone one (Anti-Entropy). | Phase 8 outbound-integration design |

Rationale: producing full ADRs for the four deferred domains now would be speculative architecture for future, business-policy-dependent capabilities off the critical path — a Learn-Before-Designing / Earn-It violation. Each is preserved with a concrete trigger so nothing is lost.

## Repository-Improvement Evaluation (2026-07-17, §5 of the Advisory-Board directive)

Every proposal evaluated against what already exists (the owner proposes; repository evidence decides). **Dominant finding: most proposals already exist under a different name** (the Master suite + SSOT matrix + guard already provide them) — adopting them again would duplicate authority (One-Authority / Anti-Entropy). A few earn a *later* trigger; almost none earn *now*.

| Proposal | Verdict | Evidence |
|---|---|---|
| Repository Health / Maturity / Phase-Readiness / Automation-Readiness **Scores** | **Reject** | Scalar "scores" are vanity metrics; `MASTER_REPOSITORY_HEALTH.md` (§17) + `MASTER_CERTIFICATION_STATUS.md` + roadmap/manifest already give richer, decision-driving state. A number adds no confidence. |
| Knowledge / Architecture / Governance / Canon / ADR **Coverage Matrices** | **Reject (duplicate)** | Already are: GOVERNANCE §2 SSOT matrix, `MASTER_COVERAGE_SCORE.md`, GOVERNANCE §5 registry, ai-map `canonical_docs`, ADR log + `MASTER_ARCHITECTURE_DECISIONS`. |
| Repository Traceability Matrix / Cross-reference Completeness | **Adopt Later → already scoped** | Covered by the consistency-guard broken-ref check + the §19 periodic orphan/lineage steward scan. No new artifact. |
| Architecture-Decision Dashboard / Repository-Health Dashboard | **Reject (exists)** | ADR log + `MASTER_ARCHITECTURE_DECISIONS`; `MASTER_REPOSITORY_HEALTH.md`. |
| Domain Dependency Matrix | **Reject (exists)** | `MASTER_ENTITY_RELATIONSHIP_MAP.md` + canon 29 relationship map. |
| Capability Dependency Graph | **Adopt Later** | `MASTER_DEPENDENCY_GRAPH.md` covers finding-deps; a capability-level graph earns it when capability count/coupling makes phase-order reasoning hard. Trigger: post-Phase-10 or on evidence. |
| Event Flow Map | **Adopt Later** | canon 27 + `MASTER_DATA_FLOW.md` define events; a concise event→consumer flow view earns it **at Phase 8** (offline-conversion consumes events). Trigger: Phase 8. |
| RPC Dependency Map | **Adopt Later** | 67 RPCs are migration-ordered + self-documenting today; a map earns it when coupling makes reasoning hard. Trigger: on evidence. |
| Dashboard contracts / per-department dashboard architecture / KPI Catalog / Widget Catalog / Dashboard Permission Matrix | **Adopt Later (UI trigger)** | Pure frontend concerns; ORVION has no UI. The Phase-9 `reporting` views already are the data contracts; RBAC + RLS already gate access. Trigger: first dashboard/frontend implementation (same trigger class as the deferred frontend design pack). |
| **Permanent Integration Catalog** (Google/Meta/WhatsApp/n8n/AI/Email/SMS/Payment/External) | **Adopt Later — soon** | Genuine cross-cutting value (unlike the dashboards): a single canonical registry of external integrations + transport + status + decision-record link. Not yet earned (only one integration is imminent), but **trigger = Phase 8 lands** → seed it with the Google Data Manager decision (`google-offline-conversion-transport-decision-2026-07-17.md`) and grow it as Meta/WhatsApp/n8n arrive. Strongest of the §5 proposals. |

Net: **1 near-term adopt (Integration Catalog, trigger Phase 8), ~6 UI/scale-triggered defers, the rest rejected as duplicates of the existing Master suite.** This is Earn-It doing its job against governance bloat — the owner proposed, the evidence decided.

## How items enter and leave this backlog

1. A review or migration surfaces an improvement not justified for immediate implementation.
2. It is added here with a classification, a why, and a trigger — evidence required.
3. When its trigger is reached and evidence justifies it, it becomes a Finding and then its own Change Request.
4. On completion, it is removed from this backlog (git history preserves the record).
