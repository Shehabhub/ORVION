# Phase 2: SQL Migration Planning — Prioritized Findings

Version: 0.1
Status: Final
Companions: `reports/phase-2-database-foundation-readiness-report.md`, `reports/phase-2-sql-migration-planning-report.md`
Executable next step for the sequencing findings: `changes/SPEC-007-sql-migration-plan.md`

---

## Required Before SQL (blocks writing correct migration content, not just planning)

| # | Finding | Blocks | Severity |
| --- | --- | --- | --- |
| 1 | `users`/Supabase Auth integration strategy is unresolved (`31_schema_draft.md` Review Required item 3; zero design exists anywhere in `_ORVION_CANONICAL/`) | Migration 5 (`users` table specifically); indirectly, every RLS policy | Critical |
| 2 | No RLS enforcement mechanism (helper functions, JWT claim strategy) is designed anywhere | Migration 19 (all RLS policies) | Critical |

## Required Before This Phase Is Fully Planned (resolved by this session's work, not open)

None remaining — the dependency-ordering hazards found (`documents`↔`document_versions` circularity; `document_links` and `approval_requests`' late dependencies) are fully resolved in the Migration Planning Report's sequence and require no further human decision.

## Recommended

| # | Finding | Severity |
| --- | --- | --- |
| 3 | No `event_type` catalog exists for the ~150 event names in `27_event_catalog.md`. Reclassified after architectural review: `30_database_conventions.md`'s composite catalog pattern applies "where applicable," not universally, `31_schema_draft.md` states no FK requirement for `event_type_code`/`severity_code`, and the pattern's actual purpose (stopping employee free-text entry) doesn't apply to system-generated event records. This is an open architectural question — whether to add catalog governance later for consistency — not a migration blocker. Does not block migration 5, 18, or 19. | Low |
| 4 | `30_database_conventions.md` is still `Version: 0.1, Status: Draft` despite being canonical and load-bearing throughout Phase 1 and this planning pass; `SPEC-002` edited its content without bumping its version | Low |
| 5 | `catalog_values.catalog_type_code` is not explicitly stated as a foreign key to `catalog_types.code` — implied by naming convention but never written as a rule | Low |

## Future Enhancement

| # | Finding |
| --- | --- |
| 6 | The `documents`/`document_versions` deferred-constraint pattern (create without FK, add via `ALTER TABLE` after both tables exist) should be documented as a reusable convention in `30_database_conventions.md` once it's used, in case a similar mutual reference appears in a future schema addition. |

---

## What Closes Phase 2 Readiness For SQL Writing

Findings 1 and 2 require an explicit human decision — most likely made together, since the RLS mechanism (Finding 2) is directly downstream of the auth strategy (Finding 1). Neither should be resolved by an agent inventing an answer; per this repository's own standing rule, the correct action when they surface is exactly what this report does — stop, document precisely what's missing, and wait. Recommended item 3 (`event_type` catalog governance) is an open architectural question the project owner may decide at any time, on any schedule, since it blocks nothing.

## Final Statement

SQL Migration *Planning* is complete: `reports/phase-2-sql-migration-planning-report.md` gives a full, dependency-correct 20-migration sequence covering every one of the 71 tables in `31_schema_draft.md`, with two previously-undocumented sequencing hazards identified and resolved. SQL Migration *writing* cannot begin for the `users` table or any RLS policy until Findings 1–2 are resolved. Every other migration in the sequence — including the catalog seed migration — is unblocked and ready to be written once approved.
