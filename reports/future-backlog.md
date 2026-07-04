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

## Recommended (evidence-backed, medium-term)

| Item | Why it matters | Trigger / when | CR? |
| --- | --- | --- | --- |
| DB-enforced event immutability | `30` forbids updating events but nothing enforces it; a trigger/RLS blocking UPDATE/DELETE on `events`/`security_events` hardens audit integrity. | Events migration (13) or RLS (19) | Yes |
| `pg_trgm` fuzzy matching | Real duplicate-detection intent (`customer_identity_signals`, name/phone). `pg_trgm` + GIN indexes materially improve fuzzy matching. | When CRM identity/dedup is built | Yes (enable-extension step) |
| RLS sequencing confirmation | All RLS deferred to Migration 19; acceptable because `config.toml` does not auto-expose new tables. Confirm no client access to tenant tables before 19; if incremental client use is planned, enable RLS per-table instead. | Before any client integration | Decision; possibly CR |

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
