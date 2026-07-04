# Change Request — SPEC-030

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

Amend the Status Standard in `30_database_conventions.md` to define an implementable, canonical pattern for enforcing status/type code columns, resolving the fact that a single code column cannot carry the composite `(catalog_type_code, code)` foreign key the current text describes as the canonical strategy.

---

## Business Reason

The Migration 4 Design Review Gate surfaced Finding F1: `30`'s Status Standard states that a status column "references `catalog_values(catalog_type_code, code)`" as "the canonical strategy," but a single column cannot reference a two-column composite key — the pattern is not physically implementable. This is a canonical design defect, not a migration detail: every status/type column across migrations 4–17 would otherwise inherit an impossible rule, and a future engineer could try to "fix" it by retrofitting composite foreign keys across many populated multi-tenant tables. Resolving it once, before the first status column is created (Migration 4), guarantees every status column is born under a final rule and prevents widespread status-related refactoring later. The resolution also reconciles `30` with `26_state_machines.md`, which already qualifies status enforcement as "validated by application logic and, where practical, database constraints" — a single-column composite FK is not practical. This is the same shape and timing as SPEC-027, which amended `30` for referential actions before Migration 4.

---

## Risks

Very low. Documentation-only change to one protected canonical document (`30_database_conventions.md`, explicitly in Scope). No SQL, no schema, no data. No retrofit: zero status/type columns exist in the database yet (migrations 2–3 created catalog and reference tables only), so no built table is affected — Migration 4 (SPEC-029) will be the first status-bearing migration and will be authored against this resolved standard. The resolution keeps the composite UNIQUE on `catalog_values` intact; it only corrects the claim that a single status column carries the composite foreign key.

---

## Supersedes / Depends On

None. (Informs the yet-to-be-approved `changes/SPEC-029-migration-4-organization-tables.md`, whose status columns already comply with this resolution.)

---

## Scope — Files Allowed to Modify

- _ORVION_CANONICAL/30_database_conventions.md

---

## Out of Scope — Files Forbidden to Modify

- All other `_ORVION_CANONICAL/**` documents (in particular `26_state_machines.md` and `25_catalog_registry.md` are consistent with this change and are not edited)
- supabase/migrations/** (no SQL)
- changes/SPEC-029-migration-4-organization-tables.md (adjusted separately, after this Change Request completes)
- Any other changes/SPEC-*.md file

---

## Minimum Reading List

- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/26_state_machines.md
- _ORVION_CANONICAL/25_catalog_registry.md

---

## Implementation Steps

1. Verification check: search `30_database_conventions.md` for the string `Decision — physical enforcement of status/type codes`. If present, record this step as Already Applied. If absent, in the `# Status Standard` section replace the exact block:

`Decision: Status foreign keys will use a composite reference pattern to \`catalog_values\` by (\`catalog_type_code\`, \`code\`) where applicable. This allows a stable mapping without introducing tight per-catalog table definitions. Example (logical):

\`\`\`sql
-- catalog_values: (catalog_type_code, code)
-- booking: booking_status_code references catalog_values(catalog_type_code, code)
\`\`\`

The canonical strategy is composite \`(catalog_type_code, code)\` referencing the seeded catalog values for stable status enforcement.`

with:

`Decision — physical enforcement of status/type codes:

Status and type code columns (for example \`lead_status_code\`, \`booking_status_code\`, \`department_type_code\`) are stored as plain \`text\` and are not required to carry a database foreign key. A single code column cannot reference \`catalog_values\`' composite key \`(catalog_type_code, code)\`, and these codes are written by application code at fixed call sites and governed by the state machines in \`26_state_machines.md\` — not typed freely by users into a form.

Each such column belongs to exactly one catalog family registered in \`25_catalog_registry.md\` (for example \`lead_status\`, \`booking_status\`, \`invoice_status\`), identified by its \`catalog_type_code\`. That registry — not this document — is the authoritative list of families; the \`(catalog_type_code, code)\` scoping already guarantees that codes in different families never collide.

Code validity is guaranteed by (1) the seeded catalog values in \`catalog_values\`, and (2) application logic and state-machine enforcement — consistent with \`26_state_machines.md\`: "validated by application logic and, where practical, database constraints." This is safe without a foreign key because catalog codes are stable: per the Catalog Standard they are never renamed and never physically deleted once used — a deprecated value is marked inactive (\`is_active = false\`) — so a status value stored in event, report, or audit data stays valid permanently.

Enforcement is domain-dependent: no single mechanism is mandated for every status field. The default is application plus state-machine validation. Optional hard database enforcement may be added for a specific column where it genuinely warrants it (for example a tenant-extendable dropdown that must reject invalid values at the database), chosen and justified per column in that column's own migration, using either:

- a \`before insert/update\` validation trigger checking the \`(catalog_type_code, code)\` pair against \`catalog_values\`; or
- a stored constant \`catalog_type_code\` column on the referencing table plus a composite foreign key to \`catalog_values(catalog_type_code, code)\`.

The composite UNIQUE \`(catalog_type_code, code)\` on \`catalog_values\` remains required — it supports the optional composite-foreign-key technique above and general catalog integrity. What is corrected here is the earlier statement that a single status column carries that composite foreign key as "the canonical strategy": it cannot; the composite foreign key is an optional per-column technique, not the mandated pattern for every status field.`

Change nothing else.

---

## Acceptance Criteria

- [ ] `30_database_conventions.md`'s `# Status Standard` section contains the heading `Decision — physical enforcement of status/type codes`.
- [ ] The section states that status/type code columns are plain `text` and are not required to carry a database foreign key, validated by the seeded catalog plus application/state-machine logic.
- [ ] The section states each status/type column belongs to one catalog family registered in `25_catalog_registry.md`, citing `25` (not this document) as the authoritative family list.
- [ ] The section states code stability (never renamed, never physically deleted, deprecated → `is_active = false`), citing the Catalog Standard, as the reason plain-text codes are safe for event/report/audit history.
- [ ] The section states enforcement is domain-dependent (no single mandated mechanism) and documents the two optional per-column enforcement techniques (validation trigger; constant `catalog_type_code` column plus composite FK).
- [ ] The section states the composite UNIQUE `(catalog_type_code, code)` on `catalog_values` remains required.
- [ ] The former sentence declaring the single-column composite reference "the canonical strategy" is no longer present.
- [ ] No other section of `30_database_conventions.md` is altered, and no other file is modified.

---

## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request, before
IMPLEMENT is considered complete, per synchronization as defined in AGENTS.md's Agent Handoff
Protocol — this file is always implicitly in scope for this section.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]

### 2026-07-04 15:24 — Claude Code (Opus 4.8), IMPLEMENT

Outcome: Complete

Step results:
- Step 1: Applied — `Decision — physical enforcement of status/type codes` was absent; replaced the un-implementable composite-FK "canonical strategy" block in the `# Status Standard` section with the resolved standard (plain text; family registered in `25`; code stability citing the Catalog Standard; domain-dependent enforcement with two optional per-column techniques; composite UNIQUE retained).

Verification against Acceptance Criteria:
- Heading `Decision — physical enforcement of status/type codes` present — confirmed.
- States status/type columns are plain `text`, not required to carry a FK — confirmed.
- States each column belongs to one family registered in `25_catalog_registry.md`, citing `25` as authoritative — confirmed.
- States code stability (never renamed / never physically deleted / deprecated → `is_active = false`) citing the Catalog Standard — confirmed.
- States enforcement is domain-dependent with the two optional techniques (validation trigger; constant type column + composite FK) — confirmed.
- States the composite UNIQUE `(catalog_type_code, code)` remains required — confirmed.
- The former "The canonical strategy is composite … stable status enforcement" sentence is no longer present (grep count 0) — confirmed.
- `git diff --stat` shows only `_ORVION_CANONICAL/30_database_conventions.md` changed; no other file — confirmed.

Commits: this Implement commit (modifies `30_database_conventions.md` and synchronizes this Change Request). No SQL, no other document.

---

## Verification Notes

[Appended by the reviewing agent (Tier 1) after independently re-checking the Execution Log
against the live repository state. Append-only — never edit or delete a prior entry.]

### 2026-07-04 15:27 — Claude Code (Opus 4.8), REVIEW

Verdict: Confirmed Complete

Findings: Re-checked independently against live `30_database_conventions.md`.
- The `# Status Standard` section now contains the resolved decision: status/type columns are plain `text` with no required FK; each column belongs to one family registered in `25_catalog_registry.md` (cited as authoritative); code stability (never renamed / never physically deleted / deprecated → inactive) is cited from the Catalog Standard as the audit-safety basis; enforcement is domain-dependent with the two optional per-column techniques; composite UNIQUE retained.
- The former standalone claim that the single-column composite reference is "the canonical strategy" is gone; "canonical strategy" now appears only inside the sentence that corrects it.
- `25_catalog_registry.md` and `26_state_machines.md` are untouched — no duplicated authority introduced; the amendment cites them.
- Scope: `git show --stat 92470f5` confirms only `30_database_conventions.md` and this Change Request changed. No SQL. Working tree releasable.
- Consistency: the resolution matches `26`'s "where practical" clause, `25`'s ownership of families, `31`'s plain-text status columns, and protects `27_event_catalog.md` state history via the stability clause.

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

This resolves Migration 4 Design Review Gate Finding F1 canonically. It does not redesign the catalog architecture: `catalog_types`/`catalog_values` and the composite UNIQUE are unchanged; only the Status Standard's enforcement wording is corrected to something implementable and consistent with `26_state_machines.md`.

After this Change Request is Complete, work returns to `SPEC-029` (Migration 4). SPEC-029's status/type columns (`tenants.status`, `branches.branch_type`, `departments.department_type_code`) are already plain `text` with no foreign key, so they already comply with this resolution; SPEC-029's Finding F1 note will be updated to cite this resolved standard rather than an open question, with no change to its DDL.

---

## Findings

- **F1 — No retrofit required.** No status/type column exists in the database yet (migrations 1–3 created extensions, catalog tables, and `currencies`). Migration 4 (SPEC-029) is the first status-bearing migration and is authored against this resolved standard, so no already-built table needs alteration. **Classification: Informational.**
- **F2 — Future per-column enforcement is now a documented option, not an obligation.** If a specific tenant-extendable dropdown later needs hard database validation, it uses one of the two documented techniques in its own migration and is recorded as a Finding at that time. Tracked as a standing evaluation item alongside the reference-data work in `reports/future-backlog.md`. **Classification: Informational.**
- **F3 — A separate Status Type Registry in `30` was evaluated and rejected as duplicated authority.** `25_catalog_registry.md` already registers every status/type family (`lead_status`, `booking_status`, `invoice_status`, `subscription_status`, and so on) and links them to `26_state_machines.md`; the `(catalog_type_code, code)` composite already prevents cross-family collision. This amendment therefore *cites* `25` as the authoritative registry rather than creating a second one in `30`. **Classification: Informational.**
- **F4 — Status code evolution rules already exist and are reused, not duplicated.** The "never rename; deactivate instead" rule is already in `30`'s Catalog Standard; this amendment cites it and adds the audit-integrity rationale (never physically deleted; deprecated → inactive) that makes plain-text status columns safe. No competing rule is introduced. **Classification: Informational.**
