# Phase 2: Database Foundation — Readiness Report

Version: 0.1
Status: Final
Roadmap authority: `_ORVION_CANONICAL/32_execution_roadmap.md` (the only source of truth for phase numbering used in this report — see Naming Note below)
Mode: ANALYZE — no repository file was modified while producing this report except where explicitly noted at the end of this session as a separate, approved Change Request.

---

## 1. Naming Note (read first)

Earlier in this project's history, work closing the remaining gaps in `26_state_machines.md`, `27_event_catalog.md`, and `28_permissions_matrix.md` was informally called the **"Phase 2 Catalog & Lifecycle Audit"** (a name coined in `31_schema_draft.md`'s own `# 13. Review Required` item 8) and tracked as `changes/SPEC-004-phase2-catalog-lifecycle.md`. That work has now been confirmed to actually belong to the roadmap's **Phase 1: Database-Ready Specification** — it closed Phase 1's own outputs (state machines, event catalog, permissions matrix), not the roadmap's formally-numbered Phase 2. Phase 1 is now marked `Complete` in `32_execution_roadmap.md`. This report, and the deliverables alongside it, use `32_execution_roadmap.md` as the only authority for phase numbering, per this task's instruction — **"Phase 2" here means `32_execution_roadmap.md`'s Phase 2: Database Foundation**, not the earlier informal usage. To avoid confusion for future readers, this report and its companions are named `phase-2-*` (numeral, no leading zero) to be visually distinct from the earlier `phase-02-*` (zero-padded) audit reports, which are not renamed — renaming them would reopen closed work outside this task's scope.

---

## 2. Precondition Check

`32_execution_roadmap.md`, Phase 2's own gating text: *"Do not begin until Phase 1 is reviewed."* Phase 1's Status field now reads `Complete` (confirmed by direct read of the current file), and all three Change Requests that produced Phase 1's outputs — `SPEC-002`, `SPEC-003`, `SPEC-004` — are `Complete` (confirmed by direct read of each file's `## Status` field). **Precondition satisfied.**

`supabase/` was checked for existing migrations: only `config.toml`, `.branches/`, and `.temp/` exist — **zero files under `supabase/migrations/`**. This is a genuinely clean slate; nothing written so far needs to be reconciled or reworked.

---

## 3. What Phase 2 Inherits From Phase 1

`31_schema_draft.md` (`Version: 0.4`, `Status: Frozen Baseline`) defines **71 tables across 11 categories** (Configuration, Core Business, Financial, System, Security, Integration, plus the 2a Reference Tables addition), fully backed — as of Phase 1's closure — by:
- Complete catalog values for every status/type field (`25_catalog_registry.md`, `Version: 0.3`)
- Complete state machines for every stateful entity, including the six CRM-extension entities closed by `SPEC-004` (`26_state_machines.md`, `Version: 0.2`)
- Complete event coverage for every lifecycle transition (`27_event_catalog.md`, `Version: 0.2`)
- Complete permission coverage for every domain (`28_permissions_matrix.md`, `Version: 0.2`)
- A full relationship map (`29_relationship_map.md`) and a set of database conventions (`30_database_conventions.md`, `Version: 0.1`, still `Status: Draft` — see Finding 4 below)

This is a substantially larger and more complete input than a typical "first migration" starting point — the specification layer is genuinely mature, not a rough sketch.

---

## 4. Findings: What Blocks Correct SQL, Distinct From What Blocks Planning

This report's task was to determine "the exact engineering work required for SQL Migration Planning" — planning is possible and is delivered in the companion `phase-2-sql-migration-planning-report.md`. But two findings below are genuine content gaps in the specification layer that no amount of planning can route around — they must be resolved (by a human, not invented by an agent) before the corresponding SQL can be written correctly. A third item, originally drafted as a Finding, was reclassified after architectural review as non-blocking — see §4a. These are distinguished clearly from purely sequencing/planning findings, which the Migration Planning Report resolves without needing new decisions.

### Finding 1 — `users` / Supabase Auth integration strategy is still explicitly unresolved

`31_schema_draft.md` `# 13. Review Required` item 3, verbatim: *"`users` table may extend Supabase auth users. Final implementation depends on chosen auth structure."* This is not a stale note — a repository-wide search for `auth.users`, `JWT`, or `auth.uid` across every file in `_ORVION_CANONICAL/` returns exactly one match, and it is this same sentence. No design exists anywhere for whether `users.id` equals `auth.users.id` (extension pattern) or `users` is a fully independent table linked by a separate `auth_user_id` column. This is a foundational decision — it determines the `users` table's actual primary key strategy and every RLS policy's lookup path — and per `codex.md`/`global-rules.md`'s explicit "never invent... requirements" rule, it is not this report's place to choose one.

### Finding 2 — No RLS enforcement mechanism is designed anywhere

`30_database_conventions.md`'s RLS Standard states the *rule* ("RLS must enforce the canonical isolation hierarchy: Tenant → Branch → Department") but not the *mechanism*. There is no helper function design, no JWT custom-claim strategy, and no description of how a Postgres RLS policy determines "the current user's `tenant_id`" from a Supabase auth session at query time. This is directly downstream of Finding 1 — the RLS mechanism cannot be designed until the `users`/auth relationship is decided — and blocks writing any correct `CREATE POLICY` statement for any table.

## 4a. Non-Blocking Observations (revised after architectural review)

The two items below were originally drafted as a third numbered Finding alongside Findings 1–2. On review, neither blocks any migration, and both are reclassified here to avoid overstating their severity.

### Observation A — `events.event_type_code` / `severity_code` have no backing catalog, and do not need one to write correct SQL

`27_event_catalog.md` defines roughly 150 distinct event names and 5 severity levels, and no `event_type` catalog category exists in `25_catalog_registry.md`. This was initially treated as a gap analogous to Findings 1–2. It is not: `30_database_conventions.md`'s Status Standard qualifies the composite `(catalog_type_code, code)` pattern explicitly as applying "**where applicable**," not universally, and `31_schema_draft.md`'s `events` table definition itself states no FK requirement for `event_type_code` or `severity_code` — unlike fields such as `currency_code`, which explicitly states its reference target. More fundamentally, the catalog-governance pattern exists to stop *employees* from entering free-text values through UI forms (`25_catalog_registry.md`'s own stated purpose); `event_type_code` is never employee-entered — it is written by application code at fixed call sites when a milestone occurs. `event_type_code text not null` is complete, correct, standalone DDL with no dependency on any catalog. This is an open architectural question (should it eventually follow the same pattern for consistency?), not a blocker, and does not affect any migration's ability to be written today.

### Observation B (minor, process) — `database_conventions.md` is still `Version: 0.1, Status: Draft`

Every other document `SPEC-002` touched (`24`, `25`, `29`) was left at a bumped version; `30_database_conventions.md` received content changes (the `currencies.code` cross-reference) under `SPEC-002` but its own version header was never bumped, and its `Status` field has never moved past `Draft` despite being treated as canonical and load-bearing throughout Phase 1 and this analysis. This is bookkeeping inconsistency only, not a content gap — flagged for completeness, not treated as a blocker.

---

## 5. Verdict

**Phase 2 may begin.** The specification layer is mature enough to fully plan migration sequencing, extension prerequisites, and seed-data ordering — all of which is delivered in the companion Migration Planning Report and formalized in the accompanying Change Request, none of which requires SQL to be written. **What may not yet proceed correctly**: writing the `users` table migration, and writing any RLS policy, until Findings 1 and 2 are resolved by an explicit human decision. The Change Request accompanying this report is scoped to avoid both — it plans around them rather than guessing through them.
