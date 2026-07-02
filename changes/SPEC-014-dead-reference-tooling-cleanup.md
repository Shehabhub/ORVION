# Change Request — SPEC-014

## Status
[x] In Progress

## Assigned Model Tier
[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

## Objective
Fix `scripts/start-aider.ps1`'s broken `--read` paths, remove `AGENTS.md`'s dead `docs/**` Protected Resources entry, and correct the one live unprefixed self-reference to `30_database_conventions.md` in `31_schema_draft.md`.

## Business Reason
`scripts/start-aider.ps1` is a tracked, committed file that would fail to load its intended context if run today — it references `docs/PROJECT_CONTEXT.md` and `.ai/rules/global-rules.md`, neither of which has ever existed in this repository's current structure (confirmed directly; `docs/` and `.ai/` do not exist anywhere). `AGENTS.md`'s Protected Resources list protects the same nonexistent `docs/**` folder — a dead rule with no repository evidence it was ever anything but a leftover from an earlier directory structure. `31_schema_draft.md`'s self-reference omits its own file's numeric prefix, a minor but real inconsistency in a Frozen Baseline canonical document.

## Risks
None. Every change is a path correction or a dead-entry removal. No table, schema, or business-domain decision is touched.

## Supersedes / Depends On
Supersedes: None.
Depends on: None — fully independent of SPEC-013 and every other package in the current program.

## Scope — Files Allowed to Modify
- scripts/start-aider.ps1
- AGENTS.md
- _ORVION_CANONICAL/31_schema_draft.md

## Out of Scope — Files Forbidden to Modify
Scope above is exhaustive. Explicitly includes: `changes/SPEC-002-phase1-database-foundation.md` — it contains the same unprefixed `database_conventions.md` reference, but a Complete Change Request's content is fixed once Approved per SPEC-010's living-artifact principle; correcting historical CR text is out of scope here and not warranted for a citation this minor. Every other file not listed above.

## Minimum Reading List
- scripts/start-aider.ps1
- AGENTS.md
- _ORVION_CANONICAL/31_schema_draft.md

## Implementation Steps

### Step 1 — Fix start-aider.ps1's broken paths
Verify: search for the exact string `--read PROJECT_CONTEXT.md`. If found: Already Applied, skip. If not found: replace `--read docs/PROJECT_CONTEXT.md` with `--read PROJECT_CONTEXT.md`, and replace `--read .ai/rules/global-rules.md` with `--read global-rules.md`.

### Step 2 — Remove the dead docs/** Protected Resources entry
Verify: search `AGENTS.md`'s `# Protected Resources` section for the exact string `docs/**`. If not found: Already Applied, skip. If found: remove the line `- docs/**` from the list, leaving `AGENTS.md`, `README.md`, and `_ORVION_CANONICAL/**` unchanged.

### Step 3 — Fix 31_schema_draft.md's unprefixed self-reference
Verify: search for the exact string "`30_database_conventions.md`) is a safe default". If found: Already Applied, skip. If not found: replace "(see `database_conventions.md`)" with "(see `30_database_conventions.md`)" at the Money Standard cross-reference.

## Acceptance Criteria
- [x] `scripts/start-aider.ps1`'s `--read` flags reference `PROJECT_CONTEXT.md` and `global-rules.md` at their actual root-level paths.
- [x] `AGENTS.md`'s Protected Resources list no longer includes `docs/**`; `AGENTS.md`, `README.md`, `_ORVION_CANONICAL/**` remain.
- [x] `31_schema_draft.md`'s Money Standard cross-reference reads `30_database_conventions.md`.
- [x] No file outside Scope was modified, including `changes/SPEC-002-phase1-database-foundation.md`.
- [x] No table, schema, or business-domain decision was altered.

## Execution Log

### 2026-07-02 20:02 — Claude (Sonnet 5)

Outcome: Complete

Step results:
- Step 1: Applied — start-aider.ps1's --read flags now point to PROJECT_CONTEXT.md and global-rules.md at their actual root paths.
- Step 2: Applied — AGENTS.md's Protected Resources list no longer includes docs/**.
- Step 3: Applied — 31_schema_draft.md's Money Standard cross-reference now reads 30_database_conventions.md.

Commits: pending — recorded at commit time in the same commit as this entry.

Verification performed before this entry: `git status --porcelain` confirmed exactly the three Scope files changed.

## Verification Notes

### 2026-07-02 20:03 — Claude (Sonnet 5)

Verdict: Confirmed Complete

Findings: `git diff b5a0223 HEAD` on the three Scope files matches every Implementation Step exactly. `changes/SPEC-002-phase1-database-foundation.md` confirmed untouched — the historical CR text was deliberately left alone, as specified.

Recommendation to human: Set Status to Complete

## Review Gate
- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied.
- [x] No file outside the Scope list was modified or created.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] The repository is in a clean, releasable state.

## Notes
`changes/SPEC-002-phase1-database-foundation.md`'s identical unprefixed reference is deliberately not corrected here — it is historical CR narrative text, fixed once Approved, and the citation is minor enough not to warrant its own corrective Change Request.
