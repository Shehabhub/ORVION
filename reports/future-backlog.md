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
| Table-level CHECK constraints from `31` "Rules" | Documented invariants must be DB-enforced, not prose: journal debit/credit exclusivity (mig 12), `booking_items`/`booking_item_passengers` non-negative (10), `document_links` single-target (15), `document_versions` single-current (7), passenger `passport_issue < expiry` (9). | Each in its own table's migration | Within each migration's CR |
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
| `bookings.booking_reference` / `quotations.quotation_number` per-tenant unique | These are human-facing business keys; duplicates cause operational confusion and break lookups. `31` does not state a unique constraint. Cheap to add now (empty tables); painful dedup later on populated data. | Soon — a small `31`/migration decision before real booking data accrues | Yes — small canonical + ALTER CR (add `unique (tenant_id, booking_reference)` / `unique (tenant_id, quotation_number)`) |

## Business-Key Uniqueness (from Migration 14, SPEC-044)

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| `subscription_plans.plan_code`, `feature_entitlements(subscription_plan_id, feature_code)`, `usage_counters(tenant_id, usage_metric_code, period_start, period_end)` uniqueness | These are natural business keys; duplicates cause plan/feature/usage ambiguity. `31` models them as fields (not PKs) and states no unique constraint. Cheap to add now (empty tables); painful dedup later. Same class as the booking_reference/quotation_number finding. | Soon — a small `31`/migration decision before real subscription data accrues | Yes — small canonical + ALTER CR |

## Finance Value Non-Negativity (from Migration 12, SPEC-042)

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| Non-negative CHECKs on finance money columns (`invoices.total_amount`, `payments.amount`, `refunds.amount`, `payment_allocations.allocated_amount`/`allocated_amount_invoice_currency`) | `31` mandates the journal debit/credit CHECK (implemented) but is silent on non-negativity elsewhere; `booking_items` already got non-negative CHECKs because `31` Rules required them there. Consistency suggests the same guard on finance amounts, but it was not invented without canonical basis. | A small canonical decision, or the finance-hardening/RLS pass | Yes — small canonical + ALTER CR |

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
| **Event-requirements (`28`) not emitted** — `lead_created`, role-assigned/permission-change security events defined in canon but not fired by RPCs; audit trail under-populated | `phase-03/04/05` reports | Before/with Phase 8 (event backbone feeds RI + conversion events); relates to register **N1** (event_type registry) | Yes — emit the missing events in their RPCs |
| **Booking-item roll-up never consumed** — item cost/selling + passenger overrides stored but never rolled to an item/booking total; `finance_approval_required` set but never read | `phase-05` §4 | With invoicing depth; relates to register **R3** (invoice_lines) | Within the finance/invoicing CR |
| **Finance-gated booking transitions partial** — only the execution-approval slice (SPEC-081) built; `confirmed`/`issued`/`void`/`refunded`/`reissue`/`completed` + capability set (Submit/Approve/Issue/Cancel/Refund/Reissue) still per-consumer | `phase-05`; ADR-0020 | As each booking consumer is built | Per-consumer CRs |
| **`chart_of_accounts.account_type` has no governing catalog** despite `14_finance_rules.md` promising a default chart | `reports/history/phase-02-prioritized-findings.md` finding 14 | Finance seed / chart-of-accounts work | Small catalog + seed CR |

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

## Future Candidates — Domain Reference Layer Expansion (continuously evaluate, do not add now)

Per standing guidance, continuously evaluate whether ORVION should add dedicated reference tables for travel-domain entities, and surface each as a Finding **only when repository evidence justifies it** (i.e., a migration introduces a column that needs the integrity/UX a reference table provides):

- Airlines, Hotel Chains, Aircraft Types, Cabin Classes, Fare Classes
- Visa Types, Passport Types
- Payment Providers, Banks
- Airport Time Zones, Country Phone Codes, Currency Locales

These are **not** approved for implementation. Each remains a candidate until a specific migration provides the evidence that promotes it to a classified Finding and its own Change Request.

---

## Strategic Direction & Future Domains (evidence-backed; guides later phases)

Forward-looking direction validated by research (2026-07). These do not change the current roadmap; they orient the later integration phases and are recorded so the direction survives without conversation history. See `PROJECT_CONTEXT.md` §11 for the vision framing (ORVION as source of truth; external platforms are consumers).

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| Attribution capture at lead intake (`gclid`/`gbraid`/`wbraid` + landing/UTM context + consent signals `ad_user_data`/`ad_personalization`) | Closed-loop offline conversion (Phase 8) is impossible without click IDs captured at the moment the lead is created — they are **unrecoverable retroactively**. Asymmetric cost: nullable columns now are trivial; missing them means permanent attribution blindness on every prior lead. | **Verify the CRM lead schema now**; if absent, a small additive nullable-column CR at a natural CRM intersection (does **not** block Finance Core). Delivery target is Google's **Data Manager API** (legacy Ads API offline import blocked 2026-06-15), not the legacy import. | Yes — small additive migration if columns absent |
| Customer Communications as a first-class capability (company-owned conversations, unified inbox, assignment, transfers, internal notes, timeline, attachments) | Replaces operational dependence on employees' personal WhatsApp; the shared-inbox/collaboration layer is built on the Cloud API, not native to it. **Architectural shape deliberately UNDECIDED** — decide via a proper Design Challenge among standalone domain / CRM capability / Customer Workspace / Automation, on evidence. Design channel-agnostic (WhatsApp is one channel; email/SMS/in-app others), reusing the event backbone + Phase-7 document linkage. | **After Phase 7 (Documents)** — that provides the attachment substrate conversations reference | Yes — its own domain CR(s), preceded by Learn-Before-Designing research |
| Full Meta-ecosystem research | Before designing the communication/marketing layer: Meta Business Platform/Portfolio, WhatsApp Business Platform, Marketing API, Messenger, Instagram Messaging, Embedded Signup, System Users, App Review, Business Verification, conversation ownership, shared-inbox architecture, multi-agent messaging. Per `AGENTS.md` §3 Learn-Before-Designing. | Communication/marketing layer (Phase 10 or the Communications domain) | Research task, then design CR(s) |
| Revenue Intelligence delivery posture | Later integrations (Phase 8 Google Ads, Phase 10 Meta/analytics) are **outbound/push, ORVION-owns-the-truth**: ORVION emits verified events/values; platforms ingest. Do not build a home-grown attribution/measurement black box — deliver to each platform's ingestion API. | Phases 8 and 10 design | Within those phases' CRs |

## How items enter and leave this backlog

1. A review or migration surfaces an improvement not justified for immediate implementation.
2. It is added here with a classification, a why, and a trigger — evidence required.
3. When its trigger is reached and evidence justifies it, it becomes a Finding and then its own Change Request.
4. On completion, it is removed from this backlog (git history preserves the record).
