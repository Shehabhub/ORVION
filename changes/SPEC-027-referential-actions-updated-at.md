# Change Request — SPEC-027

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word (for example
"Ready", "Implemented", or "Rejected") anywhere in a Change Request.

---

## Assigned Model Tier

Mark one:

[ ] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Amend `30_database_conventions.md` to define two conventions that the schema needs before migration 4: the default foreign-key referential actions (`on delete` / `on update`), and the mechanism that maintains `updated_at`.

---

## Business Reason

Migration 4 (organization tables) is the first migration to create real foreign keys and update-sensitive tables. `30_database_conventions.md` currently defines foreign-key *naming* but no `on delete`/`on update` behaviour, and sets `updated_at ... default now()` but no mechanism to advance it on update. Without these, every migration author would choose referential actions ad hoc, and `updated_at` would silently never change after insert. This amendment settles both as project-wide conventions, derived from `30`'s existing principles (archive-not-delete; immutable primary keys), so migration 4 onward has one authoritative rule to follow. It changes documentation only — no SQL and no schema — and touches no other canonical document.

---

## Risks

Low. Documentation-only change to a single protected canonical document (`30_database_conventions.md`), added explicitly to Scope. The referential-action policy is derived from `30`'s own Archive Standard, Deletion Rule, and Primary Key/Catalog stability rules, not invented. The `updated_at` mechanism is stated as a convention (database-managed via a trigger, with `moddatetime` recommended as one valid implementation); enabling any extension and creating the triggers is separate migration work (Finding F1), so this Change Request applies no SQL. Referential actions require no retrofit — migrations 2 and 3 created zero enforced foreign keys — so the default first applies at migration 4.

---

## Supersedes / Depends On

None.

---

## Scope — Files Allowed to Modify

- _ORVION_CANONICAL/30_database_conventions.md

---

## Out of Scope — Files Forbidden to Modify

- All other `_ORVION_CANONICAL/**` documents (only `30_database_conventions.md` is amended)
- supabase/migrations/** (no SQL is written or changed by this Change Request)
- Any changes/SPEC-*.md file other than this one

---

## Minimum Reading List

- _ORVION_CANONICAL/30_database_conventions.md

---

## Implementation Steps

1. Verification check: search `30_database_conventions.md` for the heading `# Referential Action Standard`. If present, record this step as Already Applied. If absent, replace the exact substring:

`# Deletion Rule

Physical delete is allowed only for:`

with:

`# Referential Action Standard

Every foreign key declares its \`on delete\` and \`on update\` behaviour explicitly. The default, used unless a migration documents otherwise for a specific foreign key, is:

\`\`\`sql
references <parent> (<column>) on delete restrict on update no action
\`\`\`

Rationale:

- \`on delete restrict\` matches this repository's archive-not-delete philosophy (see Archive Standard and Deletion Rule): important parent records are archived, never physically deleted, so a referenced parent must not be removable while children still reference it.
- \`on update no action\` is safe because every primary key in this schema is immutable: surrogate keys are UUIDs (Primary Key Standard) and natural keys are stable codes that are never renamed (Catalog Standard; \`currencies.code\`). A parent key value never changes, so cascading updates never occur.

Permitted deviations, each stated explicitly on the specific foreign key in its own migration (never applied silently or as a blanket default):

- \`on delete cascade\` — only for a dependent child/detail row that has no independent existence and is physically deleted together with its parent (for example a pure junction or line-item table whose rows are meaningless without the parent).
- \`on delete set null\` — only for a nullable, optional reference where clearing the link is the correct behaviour when the referenced row is removed; never on a \`not null\` foreign key.

A migration that uses \`cascade\` or \`set null\` for a foreign key states, in that migration, why the default \`restrict\` does not apply.

---

# Deletion Rule

Physical delete is allowed only for:`

Change nothing else in this step.

2. Verification check: search `30_database_conventions.md` for the string `Maintaining \`updated_at\``. If present, record this step as Already Applied. If absent, replace the exact substring:

`- expires_at
- sent_at

---`

with:

`- expires_at
- sent_at

Maintaining \`updated_at\`:

\`updated_at\` is maintained by the database, not by application code, so that every update — including direct SQL and service-role writes that bypass the application — advances it. The convention is the guarantee: every table that has an \`updated_at\` column has a \`before update\` trigger that sets it to the current time. The recommended implementation is the \`moddatetime\` extension (a standard PostgreSQL contrib module supported by Supabase); an equivalent hand-written \`plpgsql\` trigger function that produces the same result is acceptable. Example using the recommended \`moddatetime\`:

\`\`\`sql
-- enabled once, in a migration, before the first trigger that uses it:
create extension if not exists moddatetime;

-- per table that has an updated_at column:
create trigger <table>_set_updated_at
    before update on <table>
    for each row execute function moddatetime(updated_at);
\`\`\`

Whichever mechanism is used, it is enabled or created in a migration before the first trigger that depends on it. \`created_at\` remains a plain \`default now()\` and is never modified after insert. Application code does not set \`updated_at\` directly.

---`

Change nothing else in this step. (This replaces only the first occurrence — the one immediately following the Timestamp Standard's `- sent_at` example.)

---

## Acceptance Criteria

- [ ] `30_database_conventions.md` contains a `# Referential Action Standard` section stating the default `on delete restrict on update no action` and the two permitted deviations (`cascade`, `set null`).
- [ ] The `# Deletion Rule` section still exists, unchanged, immediately after the new section.
- [ ] The `# Timestamp Standard` section now contains a `Maintaining \`updated_at\`` subsection specifying database-managed maintenance via a `before update` trigger, with `moddatetime` named as the recommended (not the only) implementation and a hand-written trigger function noted as an acceptable equivalent.
- [ ] No other section of `30_database_conventions.md` is altered, and no other file is modified.

---

## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request, before
IMPLEMENT is considered complete, per synchronization as defined in AGENTS.md's Agent Handoff
Protocol — this file is always implicitly in scope for this section.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]

### 2026-07-04 13:12 — Claude Code (Opus 4.8), IMPLEMENT

Outcome: Complete

Step results:
- Step 1: Applied — `# Referential Action Standard` was absent; inserted the new section (default `on delete restrict on update no action`, `cascade`/`set null` deviations, rationale) immediately before `# Deletion Rule`.
- Step 2: Applied — `Maintaining `updated_at`` was absent; inserted the subsection into `# Timestamp Standard` (database-managed via `before update` trigger; `moddatetime` recommended; hand-written `plpgsql` function noted as equivalent).

Verification against Acceptance Criteria:
- `# Referential Action Standard` present with `on delete restrict on update no action` and both `cascade`/`set null` deviations — confirmed.
- `# Deletion Rule` still present, unchanged, immediately after the new section (lines 455 then 477) — confirmed.
- `# Timestamp Standard` now contains the `Maintaining `updated_at`` subsection with `moddatetime` as recommended and a hand-written trigger function as an acceptable equivalent — confirmed.
- `git diff --stat` shows only `_ORVION_CANONICAL/30_database_conventions.md` changed (+38 lines); no other file — confirmed.

Commits: this Implement commit (modifies `30_database_conventions.md` and synchronizes this Change Request). No SQL, no other document.

Observation (Finding F3 below): markdownlint reports pre-existing MD025 (multiple top-level `#` headings) across the whole document; the new section conforms to that existing repository style and introduces no new style deviation. Not actioned — outside this Change Request's approved scope.

---

## Verification Notes

[Appended by the reviewing agent (Tier 1) after independently re-checking the Execution Log
against the live repository state. Append-only — never edit or delete a prior entry.]

### 2026-07-04 13:16 — Claude Code (Opus 4.8), REVIEW

Verdict: Confirmed Complete

Findings: Every Acceptance Criterion and Review Gate item was re-checked independently against live `30_database_conventions.md`, not against the Execution Log.
- `# Referential Action Standard` present with default `references <parent> (<column>) on delete restrict on update no action`, and both permitted deviations (`on delete cascade`, `on delete set null` with the `not null` caveat) — confirmed.
- `# Deletion Rule` still present immediately after the new section, with its "Physical delete is not allowed for" list intact (leads … events) — confirmed.
- `# Timestamp Standard` now contains the `Maintaining `updated_at`` subsection: database-managed via a `before update` trigger, `moddatetime` named as the recommended implementation, a hand-written `plpgsql` trigger function stated as an acceptable equivalent, and the ordering rule ("enabled or created in a migration before the first trigger that depends on it") — confirmed.
- Review Gate — scope: `git show --stat ac93c64` confirms the Implement commit touched only `_ORVION_CANONICAL/30_database_conventions.md` and this Change Request file; no other file. No SQL. Supersedes/Depends On is None. Working tree is releasable.
- Finding F3 (pre-existing MD025 markdownlint style) is correctly recorded and not actioned, consistent with the approved documentation-only scope.

Recommendation to human: Set Status to Complete.

---

## Review Gate

[Human-completed. Do not mark Status as Complete until every item below is checked.]

- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as
      Already Applied per its verification check.
- [ ] No file outside the Scope list was modified or created.
- [ ] No section was added, removed, or restructured outside the approved steps.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] Any step that could not be resolved deterministically was reported, not guessed.
- [ ] If this Change Request's Supersedes / Depends On section names another file, that file's
      Status has been updated accordingly.
- [ ] The repository is in a clean, releasable state.

---

## Notes

Design decisions, for the reviewer:
- **`on delete restrict` (default)** over `no action`: both prevent deleting a referenced parent; `restrict` states the intent explicitly and checks immediately. It is the safe pairing with the archive-not-delete philosophy — business parents are archived, not deleted, so blocking a delete that would orphan children is the correct default.
- **`on update no action`**: chosen because no primary key in this schema ever changes value (UUIDs; non-renamable codes), making cascade-on-update dead machinery. Documented rather than `cascade` to avoid implying keys are mutable.
- **`updated_at` database-managed (trigger)** over application-managed: the repository emphasises database-enforced guarantees (RLS, constraints, immutable events, financial auditability), and the Supabase `service_role` routinely writes outside application code. A trigger guarantees `updated_at` advances for every writer; application-managed maintenance would silently miss direct and service-role writes. The convention fixes only this guarantee.
- **`moddatetime` is a recommended implementation, not a repository mandate.** Verified: no canonical or governance document previously references `moddatetime` or any `updated_at` trigger — it is proposed here as a design choice. It is a standard PostgreSQL contrib module supported by Supabase and is the least-code option; a hand-written `plpgsql` trigger function is explicitly allowed as an equivalent. The reviewer may prefer to mandate a custom function instead; the convention is written to permit either.

---

## Findings

- **F1 — Existing `updated_at` tables need the trigger retrofitted, and the chosen mechanism enabled — before migration 4.** `catalog_values` (SPEC-024) and `currencies` (SPEC-025) already have `updated_at` columns but no trigger, and no trigger mechanism (e.g. `moddatetime`) is yet enabled. A small future Change Request should enable the chosen mechanism and add the `before update` trigger to those two tables. This must land **before migration 4**, not merely alongside it: migration 4's tables (`tenants`, `branches`, `departments`, `branch_business_hours`, `holidays`) all carry `updated_at` and, per this convention, add their own triggers — which requires the mechanism already enabled. Verified: no existing migration (1–3) creates a trigger or depends on the mechanism, so nothing already applied is affected; the dependency is only forward. **Classification: Required Soon.** (Smallest future CR: one migration file — enable the mechanism plus two `create trigger` statements for the existing tables.)
- **F2 — Referential actions need no retrofit.** Migrations 2 and 3 created no enforced foreign keys (`catalog_values`' backward FKs are deferred per SPEC-024 F2; `currencies` has none), so the new default first applies at migration 4 and when the deferred `catalog_values` foreign keys are added. **Classification: Informational** (no action).
- **F3 — Pre-existing markdownlint MD025 across canonical documents.** The editor reports MD025 (multiple top-level `#` headings) on `30_database_conventions.md`; this is the established heading style of every ORVION canonical document, not a defect introduced here — the new `# Referential Action Standard` deliberately matches it. Normalizing heading levels would be a repository-wide documentation-style change touching many protected canonical files, well outside this Change Request's scope. **Classification: Nice to Have** (a possible future documentation-style Change Request, if ever desired; no action now).
