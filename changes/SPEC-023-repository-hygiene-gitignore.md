# Change Request — SPEC-023

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
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

Correct repository hygiene for the project-local Supabase CLI environment by ignoring its transient artifacts and untracking transient files committed in early history.

---

## Business Reason

Verifying SPEC-022's environment revealed two repository-hygiene defects, both independent of SQL work: (1) the root `.gitignore` does not ignore `node_modules/`, `supabase/.temp/`, or `supabase/.branches/`, so `repository-all.ps1`'s `git add .` would sweep the entire `node_modules/` tree into a commit; (2) `supabase/.temp/cli-latest`, `supabase/.temp/pgdelta/*.json`, and `supabase/.branches/_current_branch` — transient Supabase CLI state — are already tracked in git history, contrary to Supabase's own default ignore conventions. This Change Request fixes only those two defects. The npm dependency manifest (`package.json`, `package-lock.json`) is deliberately out of scope: whether to track it and what it should contain is a dependency decision, not repository hygiene, and repository governance does not treat an untracked manifest as an architectural commitment (no rule references `package.json`; `AGENTS.md` and `PROTOCOL.md` locate the source of truth in tracked repository state, not scratch files). That decision is deferred to its own future Change Request, consistent with `PROJECT_CONTEXT.md` §9 ("defer rather than invent unsupported decisions").

---

## Risks

Minimal. `.gitignore` edits are additive. `git rm --cached` untracks files without deleting the working copies (the local Supabase stack is unaffected). No canonical document, no SQL, no application behavior, and no dependency manifest is touched. After this Change Request, `package.json` and `package-lock.json` remain untracked and visible in `git status` — this is intended, pending their own Change Request.

---

## Supersedes / Depends On

None.

---

## Scope — Files Allowed to Modify

- .gitignore
- supabase/.temp/cli-latest
- supabase/.temp/pgdelta/catalog-local-migrations-e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855-1782419221382.json
- supabase/.branches/_current_branch

(The three `supabase/.temp` and `supabase/.branches` paths are in scope only for untracking via `git rm --cached`; their working-copy contents are not edited or deleted.)

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** (no canonical document is touched)
- supabase/config.toml
- supabase/migrations/** (no SQL work in this Change Request)
- scripts/repository-all.ps1
- package.json (npm dependency manifest — deferred to its own Change Request; not tracked or edited here)
- package-lock.json (same deferral as package.json)
- Any file under node_modules/

---

## Minimum Reading List

- .gitignore

---

## Implementation Steps

1. Verification check: search `.gitignore` for the exact line `node_modules/`. If present, record this step as Already Applied. If absent, append the following block to the end of `.gitignore`, exactly:

```
# Node / project-local Supabase CLI
node_modules/

# Supabase local CLI state (transient)
supabase/.temp/
supabase/.branches/
```

2. Verification check: run `git ls-files supabase/.temp supabase/.branches`. If it returns no output, record this step as Already Applied. If it lists tracked files, untrack them (working copies retained) with:

```
git rm --cached -r supabase/.temp supabase/.branches
```

---

## Acceptance Criteria

- [ ] `.gitignore` contains `node_modules/`, `supabase/.temp/`, and `supabase/.branches/`.
- [ ] `git check-ignore node_modules/ supabase/.temp/ supabase/.branches/` lists all three as ignored.
- [ ] `git ls-files supabase/.temp supabase/.branches` returns no output (nothing tracked under those paths).
- [ ] After commit, `git status --short` shows no untracked `node_modules/` or `supabase/.temp/` entries. (`package.json` and `package-lock.json` remaining untracked is expected and out of scope.)

---

## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request, before
IMPLEMENT is considered complete, per synchronization as defined in AGENTS.md's Agent Handoff
Protocol — this file is always implicitly in scope for this section.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]

### 2026-07-04 11:07 — Claude Code (Opus 4.8), IMPLEMENT

Outcome: Complete

Step results:
- Step 1: Applied — `node_modules/` was absent from `.gitignore`; appended the two-section block (`node_modules/`, then `supabase/.temp/` and `supabase/.branches/`).
- Step 2: Applied — `git ls-files` showed three tracked transient files (`supabase/.branches/_current_branch`, `supabase/.temp/cli-latest`, `supabase/.temp/pgdelta/…json`); ran `git rm --cached -r supabase/.temp supabase/.branches` (working copies retained).

Verification against Acceptance Criteria:
- `.gitignore` contains `node_modules/`, `supabase/.temp/`, `supabase/.branches/` — confirmed.
- `git check-ignore node_modules/ supabase/.temp/ supabase/.branches/` listed all three — confirmed.
- `git ls-files supabase/.temp supabase/.branches` returned no output — confirmed.
- `git status --short` shows no untracked `node_modules/` or `supabase/.temp/` entries; `package.json`/`package-lock.json` remain untracked as intended (out of scope) — confirmed.

Commits: this Implement commit (modifies `.gitignore`, removes the three transient files from the index, and synchronizes this Change Request). No package.json/package-lock.json or SQL change was made.

---

## Verification Notes

[Appended by the reviewing agent (Tier 1) after independently re-checking the Execution Log
against the live repository state. Append-only — never edit or delete a prior entry.]

### <YYYY-MM-DD HH:MM> — <agent identifier>

Verdict: Confirmed Complete | Discrepancy Found | Needs Corrective Change Request

Findings: <what was independently re-checked, and what was found>

Recommendation to human: Set Status to Complete | Set Status to Cancelled | Approve corrective
Change Request `changes/SPEC-00N-*.md`

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

This Change Request is deliberately scoped to repository hygiene only and contains no SQL or migration work, per the instruction not to combine hygiene with SQL implementation. The transient-file tracking was inherited from early repository history and aligns the repository with Supabase's own default ignore conventions (`.temp/`, `.branches/`).

The npm dependency manifest (`package.json`, `package-lock.json`) is intentionally excluded. Verification against repository governance found no rule treating the presence of runtime dependencies in `package.json` as an architectural commitment; the source of truth is tracked repository state (`AGENTS.md`, `PROTOCOL.md`), and an untracked manifest is not part of it. Deciding whether to track that manifest, and whether it should carry only the Supabase CLI dev dependency or also application runtime dependencies (`@supabase/ssr`, `@supabase/supabase-js`), is a dependency decision to be made in its own future Change Request with explicit justification, not folded into repository hygiene.
