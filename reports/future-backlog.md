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
| Reference Data Layer (countries, cities, nationalities, languages, airports) | `25_catalog_registry.md` recommends dedicated reference tables; columns (`passengers.nationality_code`, `passport_issuing_country_code`, `customers.preferred_language_code`, `bookings.destination_country_code`) have no integrity backing. | **Before Migrations 8–10** (customers/passengers/bookings) | Yes — adds tables + updates `31`/`33`, or a documented decision to keep free-text |
| Table-level CHECK constraints from `31` "Rules" | Documented invariants must be DB-enforced, not prose: journal debit/credit exclusivity (mig 12), `booking_items`/`booking_item_passengers` non-negative (10), `document_links` single-target (15), `document_versions` single-current (7), passenger `passport_issue < expiry` (9). | Each in its own table's migration | Within each migration's CR |
| Process safeguard for Complete-sync | The `Active Change Request` pointer-clear was omitted twice (SPEC-024, SPEC-027). A Claude Stop/PostToolUse hook (or scripted check) verifying `Active Change Request: None` after Complete would prevent recurrence. | Any time | Yes — small `settings.json` CR |

## Identity Lifecycle (from the 2026-07-04 Identity Lifecycle Review; SPEC-031 resolved the nullability contradiction)

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| `auth_user_id` → `auth.users(id)` referential action | Determines what happens if a Supabase admin deletes an auth user. SPEC-027's default `on delete restrict` would *block* that deletion; `on delete set null` lets the ORVION user survive unlinked/re-invitable. Must be a conscious choice, not defaulted. | **Migration 5 Design Review Gate** (recommend `set null`) | Decided within the Migration 5 CR (not a separate CR) |
| Invitation / activation lifecycle model | "Invited-but-not-activated" is currently only implicit (`is_active=false` + `auth_user_id` null). No invitation record, `invited_at`/`activated_at`, `invited_by`, user status/state machine, or activation/deactivation events (`26`/`27` have none for users). Re-invite reuse-vs-new is undefined. | After Migration 5 (users table exists); when the invitation UX is designed | Yes — its own feature CR |
| `users` deletion/archive clarification | `users` uses `is_active` (deactivate), has no archive fields, and is not in `30`'s no-physical-delete list — so hard-delete isn't explicitly forbidden. Clarify: deactivate-only, or add `users` to the no-physical-delete rule. | Documentation checkpoint before RLS/audit hardening | Small canonical CR if a rule is added |

## Recommended (evidence-backed, medium-term)

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| DB-enforced event immutability | `30` forbids updating events but nothing enforces it; a trigger/RLS blocking UPDATE/DELETE on `events`/`security_events` hardens audit integrity. | Events migration (13) or RLS (19) | Yes |
| `pg_trgm` fuzzy matching | Real duplicate-detection intent (`customer_identity_signals`, name/phone). `pg_trgm` + GIN indexes materially improve fuzzy matching. | When CRM identity/dedup is built | Yes (enable-extension step) |
| RLS sequencing confirmation | All RLS deferred to Migration 19; acceptable because `config.toml` does not auto-expose new tables. Confirm no client access to tenant tables before 19; if incremental client use is planned, enable RLS per-table instead. | Before any client integration | Decision; possibly CR |

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
| Supabase / Postgres MCP server | Would replace `docker exec … psql` verification with direct queries; dev-experience only. | When tooling setup is prioritized; needs approval |

## Future Candidates — Domain Reference Layer Expansion (continuously evaluate, do not add now)

Per standing guidance, continuously evaluate whether ORVION should add dedicated reference tables for travel-domain entities, and surface each as a Finding **only when repository evidence justifies it** (i.e., a migration introduces a column that needs the integrity/UX a reference table provides):

- Airlines, Hotel Chains, Aircraft Types, Cabin Classes, Fare Classes
- Visa Types, Passport Types
- Payment Providers, Banks
- Airport Time Zones, Country Phone Codes, Currency Locales

These are **not** approved for implementation. Each remains a candidate until a specific migration provides the evidence that promotes it to a classified Finding and its own Change Request.

---

## How items enter and leave this backlog

1. A review or migration surfaces an improvement not justified for immediate implementation.
2. It is added here with a classification, a why, and a trigger — evidence required.
3. When its trigger is reached and evidence justifies it, it becomes a Finding and then its own Change Request.
4. On completion, it is removed from this backlog (git history preserves the record).
