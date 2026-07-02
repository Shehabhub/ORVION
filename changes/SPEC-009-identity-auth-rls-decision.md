# Change Request — SPEC-009

## Status

[x] Complete

---

## Assigned Model Tier

[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Record the approved identity/authentication/RLS architecture into `_ORVION_CANONICAL/31_schema_draft.md` as a relationship-level decision, record the physical identity key strategy into `_ORVION_CANONICAL/30_database_conventions.md` as a project-wide convention, and bring `_ORVION_CANONICAL/33_sql_migration_plan.md` into consistency with both — without generating SQL or migrations.

---

## Business Reason

The identity/authentication/RLS architecture — Supabase Auth as the authentication source of truth, `users` in a mandatory one-to-one relationship with `auth.users`, authorization remaining entirely inside ORVION RBAC, JWT treated as authentication-only, and RLS resolving authorization through `auth.uid()` and a `SECURITY DEFINER` lookup function against ORVION's own tables — has been approved as final project architecture (see conversation record). A separate, narrower question — whether that one-to-one relationship is physically implemented as a shared primary key (`users.id = auth.users.id`) or as a decoupled `users.id` plus a separate `auth_user_id` column — was initially folded into the same decision, then deliberately separated after architectural review: it is not an architectural relationship (that belongs in `31_schema_draft.md`) and not a safe-to-leave-open implementation detail either (multiple independently-authored artifacts — the `users` table migration, the RLS identity-lookup function, and any future application code resolving `auth.uid()` to a business user — must all agree on the same physical pattern, or the system breaks in ways that do not fail loudly). It is a project-wide convention, the exact category of decision `30_database_conventions.md` already exists to hold once, centrally, before dependent artifacts are written — the same role that document's existing Status Standard plays for catalog-backed fields. This task records the architecture in `31_schema_draft.md`, the convention in `30_database_conventions.md`, and updates `33_sql_migration_plan.md` to reflect both, preserving the separation between architecture, convention, and implementation throughout.

---

## Risks

None. Every edit is additive or corrective prose in three already-existing documents. No table, column, index, constraint, or relationship is added, removed, or redefined; the one SQL-shaped line in this task (a single illustrative column declaration in the new Identity Key Standard section) matches the existing, established style of every other section in `30_database_conventions.md` (Primary Key Standard, Tenant Scope Standard, Timestamp Standard, Actor Standard, Archive Standard, and Money Standard all already contain identical illustrative snippets) and is not a migration or runnable SQL artifact. Numbering of `31_schema_draft.md`'s `# 13. Review Required` items is preserved (item 3 is resolved in place, not deleted or renumbered), since other documents already reference specific item numbers.

---

## Supersedes / Depends On

Supersedes: None.

Depends on: `SPEC-007-sql-migration-plan.md` and `SPEC-008-migration-plan-blocked-items-fix.md` must already be `Complete` — confirmed prior to this task being written. Both the architecture decision and the physical key strategy convention this task records must already be approved — confirmed prior to this task being written (see conversation record).

---

## Scope — Files Allowed to Modify

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/33_sql_migration_plan.md
- _ORVION_CANONICAL/30_database_conventions.md

---

## Out of Scope — Files Forbidden to Modify

Scope above is exhaustive. Every other file is out of scope, with no exceptions, including but not limited to:

- _ORVION_CANONICAL/24_entity_registry.md, 25_catalog_registry.md, 26_state_machines.md, 27_event_catalog.md, 28_permissions_matrix.md, 29_relationship_map.md, 32_execution_roadmap.md — not touched.
- Within `30_database_conventions.md` itself: no section other than the new `# Identity Key Standard` section and the version header is touched. In particular, `# RLS Standard`, `# Primary Key Standard`, `# Status Standard`, and every other existing section are left exactly as they are — the new section is self-contained and does not require editing any neighboring section.
- supabase/** — this task produces no SQL and no migration file.
- AGENTS.md, PROTOCOL.md, changes/TEMPLATE.md, _ORVION_CANONICAL/manifest.md — no workflow or governance change is in scope here.
- reports/**, changes/SPEC-002 through SPEC-008 — historical records, not touched.
- No table, column, index, constraint, or relationship is added, removed, or redefined anywhere by this task. No new identity model, technology, or architecture is introduced beyond restating the already-approved decision and convention in prose.

---

## Minimum Reading List

- _ORVION_CANONICAL/31_schema_draft.md
- _ORVION_CANONICAL/33_sql_migration_plan.md
- _ORVION_CANONICAL/30_database_conventions.md

---

## Implementation Steps

### Step 1 — Resolve `31_schema_draft.md` `# 13. Review Required` item 3 (relationship only)

Verify: search for the exact string `3. RESOLVED:` within `# 13. Review Required`.
- If found: Already Applied, skip.
- If not found (item 3 reads as below): locate the exact line:

```
3. `users` table may extend Supabase auth users. Final implementation depends on chosen auth structure.
```

Replace it with:

```
3. RESOLVED: `users` has a mandatory one-to-one relationship with `auth.users`. Supabase Auth is the authentication identity; `users` is ORVION's business profile layer. Authorization remains entirely inside ORVION RBAC (`roles`, `permissions`, `role_permissions`, `user_role_assignments`) — the JWT issued by Supabase Auth is authentication-only and is never the authoritative source of business permissions. RLS resolves authorization through `auth.uid()` and a `SECURITY DEFINER` lookup function against the current ORVION RBAC tables, not through JWT claims. The physical key strategy implementing this relationship is a project-wide convention, defined in `30_database_conventions.md`'s Identity Key Standard, and is not part of this architectural statement. This decision applies to future SQL migrations, RLS implementation, and authorization logic unless a future approved Change Request explicitly supersedes it.
```

Do not renumber any other item in this list.

### Step 2 — Update the `users` table's Notes in `31_schema_draft.md` (relationship only)

Verify: within the `## users` table section, search for the exact string `mandatory one-to-one relationship with \`auth.users\``.
- If found: Already Applied, skip.
- If not found: locate the exact block:

```
Notes:

- If Supabase auth is used, this table may extend auth.users through matching id.

## user_branch_assignments
```

Replace it with:

```
Notes:

- This table has a mandatory one-to-one relationship with `auth.users`. Supabase Auth is the authentication identity; this table is ORVION's business profile layer. Authorization remains entirely inside ORVION RBAC — the JWT is authentication-only, never the authoritative source of business permissions. The physical key strategy is defined in `30_database_conventions.md`'s Identity Key Standard. See `# 13. Review Required` item 3.

## user_branch_assignments
```

### Step 3 — Bump `31_schema_draft.md` version marker

Verify: search for the exact line `Version: 0.5`.
- If found: Already Applied, skip.
- If not found (file shows `Version: 0.4`): replace `Version: 0.4` with `Version: 0.5`.

### Step 4 — Add Identity Key Standard to `30_database_conventions.md`

Verify: search for the exact heading `# Identity Key Standard`.
- If found: Already Applied, skip.
- If not found: locate the exact block, the boundary between `# Primary Key Standard` and `# Tenant Scope Standard`:

```
UUID strategy: UUIDs must be generated server-side using `gen_random_uuid()` (pgcrypto). Ensure the database enables the `pgcrypto` extension in migrations before creating tables.

---

# Tenant Scope Standard
```

Replace it with:

```
UUID strategy: UUIDs must be generated server-side using `gen_random_uuid()` (pgcrypto). Ensure the database enables the `pgcrypto` extension in migrations before creating tables.

---

# Identity Key Standard

`users` has a mandatory one-to-one relationship with `auth.users` (see `31_schema_draft.md`, `# 13. Review Required` item 3). The physical key strategy implementing that relationship is fixed here, once, because it is read by multiple independently-authored artifacts — the `users` table migration, the RLS identity-lookup function, and any future application code resolving `auth.uid()` to a business user — that must all agree on the same pattern.

Decision: `users` uses its own independently-generated `id` (per the Primary Key Standard above), plus a separate column:

```sql
auth_user_id uuid not null unique references auth.users(id)
```

Do not set `users.id = auth.users.id` as a shared primary key. `auth_user_id` is the sole link between ORVION's business identity and the Supabase Auth identity backing it.

Rationale: a separate column keeps `users.id` stable and provider-independent, since every other table's foreign key already points at `users.id`. It also allows a `users` row to exist before its corresponding `auth.users` row does (for example, an invited-but-not-yet-activated employee), and leaves room for a future second identity provider (for example, enterprise SSO) without a breaking migration to the primary key every other table already references.

The RLS identity lookup function SHALL resolve `auth.uid()` to the corresponding ORVION business user through `auth_user_id`, not through a shared primary key. The function's exact implementation — its full body, return shape, and any additional identity or role context it resolves in the same call — belongs to RLS/migration planning (migration 19), not to this convention.

---

# Tenant Scope Standard
```

### Step 5 — Bump `30_database_conventions.md` version marker

Verify: search for the exact line `Version: 0.2` in `_ORVION_CANONICAL/30_database_conventions.md`.
- If found: Already Applied, skip.
- If not found (file shows `Version: 0.1`): replace `Version: 0.1` with `Version: 0.2`.

### Step 6 — Resolve `33_sql_migration_plan.md` `# Blocked Items` section

Verify: search for the exact string `None currently.` within `# Blocked Items`.
- If found: Already Applied, skip.
- If not found: locate the exact block:

```
# Blocked Items

The following are not resolved by this plan and must be decided, by a human, before the migration(s) they block can be written correctly. This plan does not invent an answer for any of them.

## 1. `users` / Supabase Auth integration strategy

Blocks: migration 5's `users` table content.

`31_schema_draft.md` `# 13. Review Required` item 3: "`users` table may extend Supabase auth users. Final implementation depends on chosen auth structure." No further design exists anywhere in `_ORVION_CANONICAL/`.

## 2. RLS enforcement mechanism

Blocks: migration 19 in full.

`30_database_conventions.md`'s RLS Standard states the rule (tenant → branch → department isolation) but not the mechanism (helper functions, JWT custom claims, or another approach). Directly downstream of Blocked Item 1.

---

# Recommended (Non-Blocking)
```

Replace it with:

```
# Blocked Items

None currently. Both items originally listed here — the `users`/Supabase Auth integration strategy and the RLS enforcement mechanism — were resolved by approved architectural decision; see `31_schema_draft.md` `# 13. Review Required` item 3 for the relationship and authorization architecture, and `30_database_conventions.md`'s Identity Key Standard for the physical key pattern the RLS lookup function must use.

---

# Recommended (Non-Blocking)
```

### Step 7 — Update migration 5's row in `# Migration Sequence`

Verify: search for the exact string `` `users` migration content is unblocked ``.
- If found: Already Applied, skip.
- If not found: locate the exact table row:

```
| 5 | `NN_create_identity_and_access_tables.sql` | `users` (see Blocked Items), `roles`, `permissions`, `role_permissions`, `user_branch_assignments`, `user_role_assignments` | 4 | `users` migration content is blocked — see Blocked Items 1. |
```

Replace it with:

```
| 5 | `NN_create_identity_and_access_tables.sql` | `users`, `roles`, `permissions`, `role_permissions`, `user_branch_assignments`, `user_role_assignments` | 4 | `users` migration content is unblocked — relationship in `31_schema_draft.md` `# 13. Review Required` item 3; physical column pattern (`auth_user_id`, not a shared `id`) in `30_database_conventions.md`'s Identity Key Standard. |
```

### Step 8 — Update migration 19's row in `# Migration Sequence`

Verify: search for the exact string `Unblocked — resolved via`.
- If found: Already Applied, skip.
- If not found: locate the exact table row:

```
| 19 | `NN_create_rls_policies.sql` | RLS policies on every tenant-owned table | all preceding | Fully blocked — see Blocked Items 1 and 2. |
```

Replace it with:

```
| 19 | `NN_create_rls_policies.sql` | RLS policies on every tenant-owned table | all preceding | Unblocked — resolved via `31_schema_draft.md` `# 13. Review Required` item 3 (`auth.uid()` plus a `SECURITY DEFINER` lookup function against ORVION RBAC tables; no JWT claims) and `30_database_conventions.md`'s Identity Key Standard (lookup function must use `auth_user_id`, not `id`). |
```

### Step 9 — Update `# Next Step` in `33_sql_migration_plan.md`

Verify: search for the exact string `All Blocked Items resolved`.
- If found: Already Applied, skip.
- If not found: locate the exact line:

```
Resolve Blocked Items 1–2, then write SQL migrations in the sequence defined above.
```

Replace it with:

```
Write SQL migrations in the sequence defined above. All Blocked Items resolved; see `31_schema_draft.md` `# 13. Review Required` item 3 and `30_database_conventions.md`'s Identity Key Standard.
```

### Step 10 — Bump `33_sql_migration_plan.md` version marker

Verify: search for the exact line `Version: 0.2` in `_ORVION_CANONICAL/33_sql_migration_plan.md`.
- If found: Already Applied, skip.
- If not found (file shows `Version: 0.1`): replace `Version: 0.1` with `Version: 0.2`.

---

## Acceptance Criteria

- [x] Step 1: `31_schema_draft.md` `# 13. Review Required` item 3 begins with `3. RESOLVED:`, states the relationship and authorization architecture only (no shared-PK or `auth_user_id` wording), and points to `30_database_conventions.md` for the physical key strategy; items 1–2 and 4–8 are unchanged and unrenumbered.
- [x] Step 2: the `## users` table's Notes state the mandatory one-to-one relationship, contain no physical-key wording, and reference both `# 13. Review Required` item 3 and the Identity Key Standard; no other line in the `## users` section is changed.
- [x] Step 3: `31_schema_draft.md` header reads `Version: 0.5`.
- [x] Step 4: `30_database_conventions.md` contains a `# Identity Key Standard` section, positioned between `# Primary Key Standard` and `# Tenant Scope Standard`, stating the `auth_user_id` decision and prohibiting a shared `users.id`/`auth.users.id` primary key.
- [x] Step 5: `30_database_conventions.md` header reads `Version: 0.2`.
- [x] Step 6: `33_sql_migration_plan.md`'s `# Blocked Items` section states `None currently.` and references both `31_schema_draft.md` and the Identity Key Standard.
- [x] Step 7: migration 5's row states `users` is unblocked and references both the relationship and the physical column pattern.
- [x] Step 8: migration 19's row states it is unblocked and references both the relationship and the physical column pattern.
- [x] Step 9: `33_sql_migration_plan.md`'s `# Next Step` no longer instructs the reader to resolve Blocked Items and references both documents.
- [x] Step 10: `33_sql_migration_plan.md` header reads `Version: 0.2`.
- [x] No file outside Scope (`31_schema_draft.md`, `33_sql_migration_plan.md`, `30_database_conventions.md`) was modified or created.
- [x] No table, column, index, constraint, or relationship in `31_schema_draft.md` was added, removed, or altered — only prose in item 3 and the `## users` Notes changed.
- [x] No section in `30_database_conventions.md` other than the new `# Identity Key Standard` section and the version header was changed.
- [x] The `# Migration Sequence` table in `33_sql_migration_plan.md` still has exactly 20 rows, and no row other than 5 and 19 was changed. The `# Recommended (Non-Blocking)` section is unchanged.

---

## Execution Log

### 2026-07-02 14:35 — Claude (Sonnet 5)

Outcome: Complete

Step results:
- Step 1: Applied — `31_schema_draft.md` `# 13. Review Required` item 3 replaced with the RESOLVED relationship/authorization text.
- Step 2: Applied — `## users` table Notes replaced with the mandatory one-to-one relationship statement.
- Step 3: Applied — `31_schema_draft.md` version bumped 0.4 -> 0.5.
- Step 4: Applied — `# Identity Key Standard` section added to `30_database_conventions.md` between `# Primary Key Standard` and `# Tenant Scope Standard`.
- Step 5: Applied — `30_database_conventions.md` version bumped 0.1 -> 0.2.
- Step 6: Applied — `33_sql_migration_plan.md` `# Blocked Items` replaced with the `None currently.` resolution text.
- Step 7: Applied — migration 5's row updated to unblocked, referencing the relationship and the physical column pattern.
- Step 8: Applied — migration 19's row updated to unblocked, referencing the relationship and the physical column pattern.
- Step 9: Applied — `# Next Step` updated to remove the resolve-Blocked-Items instruction.
- Step 10: Applied — `33_sql_migration_plan.md` version bumped 0.1 -> 0.2.

Commits: e018fb1

This entry is added retroactively: the edits above were applied during the architectural-decision conversation and left uncommitted. Before this entry was written, each of the three Scope files was independently re-diffed against the live repository (not trusted from memory or from the earlier conversational review) and committed in `e018fb1`, which this entry cites.

---

## Verification Notes

### 2026-07-02 14:35 — Claude (Sonnet 5)

Verdict: Confirmed Complete

Findings: Independently re-diffed `_ORVION_CANONICAL/30_database_conventions.md`, `31_schema_draft.md`, and `33_sql_migration_plan.md` against the prior commit touching each, and checked every changed line against every Acceptance Criterion above. All 10 Implementation Steps match the approved text exactly (byte-for-byte, not paraphrased); no file outside Scope was touched; no table, column, index, constraint, or relationship was added, removed, or altered in `31_schema_draft.md`; the `# Migration Sequence` table still has exactly 20 rows with only rows 5 and 19 changed; `30_database_conventions.md` has no section changed other than the new Identity Key Standard section and its version header.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [x] No file outside the Scope list was modified or created.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On: confirmed `SPEC-007` and `SPEC-008` were already `Complete`, and both the architecture decision and the Identity Key Standard convention were already approved, before this task began.
- [x] The repository is in a clean, releasable state.

---

## Notes

This revision replaces the initial `SPEC-009` draft, which folded the physical key strategy into `31_schema_draft.md`'s architectural statement — an error caught during architectural review before approval (see conversation record) and corrected here rather than left for a future corrective Change Request, since the original draft was never approved or executed. The one SQL-shaped line in Step 4 (`auth_user_id uuid not null unique references auth.users(id)`) is an illustrative column declaration matching `30_database_conventions.md`'s own established style, used identically by every other Standard section in that document; it is not a migration and does not by itself constitute "generating SQL" in the sense excluded from this task. This task does not design, generate, or imply any specific migration DDL or RLS policy body. It deliberately stops short of prescribing the lookup function's exact predicate or implementation: on review, that crosses from convention (the invariant that lookups go through `auth_user_id`, never a shared `id`) into implementation (the function's actual body), which belongs to migration 19, not this document. The actual SQL for migrations 5 and 19 remains future work.
