# Change Request — SPEC-008

## Status

[x] Complete

---

## Assigned Model Tier

[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Correct the stale "Resolve Blocked Items 1–3" reference to "Resolve Blocked Items 1–2" in both `changes/SPEC-007-sql-migration-plan.md`'s own Step 1 specification text and `_ORVION_CANONICAL/33_sql_migration_plan.md`, matching the current, already-approved two-item Blocked Items section in both documents.

---

## Business Reason

`SPEC-007`'s Review (recorded in its own Execution Log and Verification Notes) found that both documents' closing "Next Step" line still instructs the reader to "Resolve Blocked Items 1–3," a leftover from before the `event_type` catalog item was reclassified from a third Blocked Item to a non-blocking Recommended item, reducing Blocked Items from three to two. This was missed by the prior correction commit's consistency sweep, which searched for the string "Blocked Item 3" (singular) and did not match this text's actual wording, "Blocked Items 1–3" (a range). The defect is not an execution error: `SPEC-007`'s own Step 1 specification already contained it, and the created canonical document reproduced it faithfully and correctly per that specification. Both documents currently list exactly two Blocked Items, then instruct the reader to resolve "1–3" — an internal self-contradiction that this task removes.

---

## Risks

None. This is a single-number correction ("3" to "2") applied to one line, in two files, with no other text touched in either file.

---

## Supersedes / Depends On

Supersedes: None.

Depends on: `SPEC-007-sql-migration-plan.md` must already be in the state left by its Review (Status `In Progress`, `# Blocked Items` containing exactly 2 items, `# Recommended (Non-Blocking)` containing exactly 1 item, in both `SPEC-007`'s own Step 1 text and `_ORVION_CANONICAL/33_sql_migration_plan.md`) — confirmed present before this task was written.

---

## Scope — Files Allowed to Modify

- changes/SPEC-007-sql-migration-plan.md
- _ORVION_CANONICAL/33_sql_migration_plan.md

---

## Out of Scope — Files Forbidden to Modify

Scope above is exhaustive. Every other file is out of scope, with no exceptions, including but not limited to:

- Any other section, heading, table row, or sentence in `changes/SPEC-007-sql-migration-plan.md` or `_ORVION_CANONICAL/33_sql_migration_plan.md` other than the exact line named in Implementation Steps below. In particular: the `# Migration Sequence` table, the `# Blocked Items` section's own two items, and the `# Recommended (Non-Blocking)` section are not to be altered, reworded, reordered, or re-numbered by this task.
- `_ORVION_CANONICAL/31_schema_draft.md`, `30_database_conventions.md`, `25_catalog_registry.md`, and every other existing `_ORVION_CANONICAL/**` file.
- `reports/phase-2-database-foundation-readiness-report.md`, `reports/phase-2-sql-migration-planning-report.md`, `reports/phase-2-migration-planning-prioritized-findings.md` — not touched by this task.
- `_ORVION_CANONICAL/manifest.md`, `AGENTS.md`, `changes/TEMPLATE.md` — no workflow bookkeeping or governance change is in scope here; this is an engineering-content fix only.
- `changes/SPEC-002-phase1-database-foundation.md`, `SPEC-003-phase1-consistency-fix.md`, `SPEC-004-phase2-catalog-lifecycle.md`, `SPEC-005-agent-handoff-protocol.md` — historical records, not touched.

---

## Minimum Reading List

- changes/SPEC-007-sql-migration-plan.md
- _ORVION_CANONICAL/33_sql_migration_plan.md

---

## Implementation Steps

### Step 1 — Correct `_ORVION_CANONICAL/33_sql_migration_plan.md`

Verify: search for the exact string `Resolve Blocked Items 1–2`.
- If found: Already Applied, skip.
- If not found (file shows the block below): locate the exact final three lines of the file:

```
# Next Step

Resolve Blocked Items 1–3, then write SQL migrations in the sequence defined above.
```

Replace them with:

```
# Next Step

Resolve Blocked Items 1–2, then write SQL migrations in the sequence defined above.
```

Do not alter any other line in the file.

### Step 2 — Correct `changes/SPEC-007-sql-migration-plan.md`'s own Step 1 specification text

Verify: within the Implementation Steps section, search for the exact string `Resolve Blocked Items 1–2`.
- If found: Already Applied, skip.
- If not found: locate the exact block, which appears inside Step 1's specified file content (near the end of that embedded content, immediately before the closing code fence):

```
# Next Step

Resolve Blocked Items 1–3, then write SQL migrations in the sequence defined above.
```
```

Replace it with:

```
# Next Step

Resolve Blocked Items 1–2, then write SQL migrations in the sequence defined above.
```
```

Do not alter any other line in the file, including the Objective, Business Reason, Acceptance Criteria, Execution Log, Verification Notes, or Review Gate sections already present from `SPEC-007`'s own authoring and Review.

---

## Acceptance Criteria

- [x] Step 1: `_ORVION_CANONICAL/33_sql_migration_plan.md`'s final line reads exactly `Resolve Blocked Items 1–2, then write SQL migrations in the sequence defined above.`, and every other line in the file is unchanged from its state before this task ran.
- [x] Step 2: `changes/SPEC-007-sql-migration-plan.md`'s embedded Step 1 specification text contains the same corrected line, and every other line in the file — including its Execution Log and Verification Notes entries recorded during Review — is unchanged from its state before this task ran.
- [x] No file outside Scope (`changes/SPEC-007-sql-migration-plan.md`, `_ORVION_CANONICAL/33_sql_migration_plan.md`) was modified or created.
- [x] Neither file's `# Migration Sequence` table, `# Blocked Items` section, nor `# Recommended (Non-Blocking)` section differs from its state before this task ran, other than the one corrected line.

---

## Execution Log

### 2026-07-02 — Unidentified agent/process (recorded retroactively by Claude)

Outcome: Complete

Step results:
- Step 1: Applied — `_ORVION_CANONICAL/33_sql_migration_plan.md`'s final line corrected to `Resolve Blocked Items 1–2, then write SQL migrations in the sequence defined above.`, confirmed via `git diff` to be a single-line change with zero other modifications.
- Step 2: Applied — `changes/SPEC-007-sql-migration-plan.md`'s embedded Step 1 specification text corrected identically, confirmed via `git diff` to be a single-line change (line 158) with zero other modifications, including `SPEC-007`'s own Execution Log and Verification Notes entries from its Review, which remain untouched.

Commits: none — both edits were found already applied in the working tree; `git status` shows both files as modified-but-uncommitted at Review time. This Change Request's own Status field remained `Approved` throughout, never recording that execution had occurred.

Blocker: None. Process note — this entry does not reflect a live-recorded execution; no agent identity could be determined.

---

## Verification Notes

### 2026-07-02 — Claude

Verdict: Confirmed Complete

Findings: `git diff` against the last commit for both `_ORVION_CANONICAL/33_sql_migration_plan.md` and `changes/SPEC-007-sql-migration-plan.md` shows exactly one changed line in each file, both changing `Resolve Blocked Items 1–3` to `Resolve Blocked Items 1–2`, and nothing else. All 4 Acceptance Criteria confirmed true by direct diff inspection, not by trusting a self-report. `git status` confirmed no file outside Scope was touched. This is a clean pass with no discrepancy, unlike `SPEC-007`'s own Review — the correction was applied exactly as specified.

Recommendation to human: Set Status to Complete.

---

## Review Gate

- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [x] No file outside the Scope list was modified or created.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Supersedes / Depends On: confirmed `SPEC-007`'s Review state (Status `In Progress`, 2 Blocked Items, 1 Recommended item) was present before this task began.
- [x] The repository is in a clean, releasable state.

---

## Notes

This task closes the single finding from `SPEC-007`'s Review (`Verdict: Needs Corrective Change Request`). It does not re-examine, re-derive, or alter the migration sequence, the Blocked Items themselves, the Recommended item's reasoning, or any other architectural decision already made and agreed in this session — those remain exactly as approved. Once this task is applied, verified, and both files' Review Gates are satisfied, `SPEC-007` may be reconsidered for `Complete` in a separate action; this task does not itself change `SPEC-007`'s Status.
