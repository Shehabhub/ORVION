# Change Request — SPEC-034

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

[ ] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Add a Migration CI GitHub Actions workflow that verifies, on every push and pull request, that the full SQL migration sequence applies cleanly on a fresh database via `supabase db reset`.

---

## Business Reason

ORVION executes migrations direct-to-`main` (ADR-0009), so there is no pre-merge gate; a broken migration would land on `main` immediately and break every contributor's `db reset`. Migrations are cumulative and immutable-once-applied, so a single bad migration halts all subsequent work. Today the only verification is a local `db reset` run by hand. With the identity foundation complete and the remaining ~15 migrations (including Finance and RLS) being the complex majority, an automated backstop is now a baseline control: this workflow gives fast, unambiguous detection that `main`'s migration sequence still applies from scratch.

---

## Risks

Low, and additive. A new workflow file only; it changes no migration, schema, or canonical document. It uses the Supabase CLI (not bare Postgres) because the migrations require the `auth` schema (`users.auth_user_id` → `auth.users`) and Supabase-provided extensions (`pgcrypto`, `moddatetime`). Note (verification): a GitHub Action cannot be verified locally — this Change Request's Review is performed by observing the workflow run on the CI provider after the Implement push; if the first run reveals a CI-environment issue, it is corrected by a follow-up commit within this Change Request's execution, not guessed.

---

## Supersedes / Depends On

None. Complements the existing PR-triggered `claude-code-review.yml`/`claude.yml` workflows (which review PRs); this one validates that migrations apply.

---

## Scope — Files Allowed to Modify

- .github/workflows/migration-ci.yml

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** and reports/** (no canonical or documentation change)
- supabase/migrations/** (no migration is changed)
- supabase/config.toml
- The other `.github/workflows/*.yml` files
- Any pre-push local hook (a prevention layer noted as an optional future follow-on, not part of this Change Request)

---

## Minimum Reading List

- supabase/config.toml
- .github/workflows/claude-code-review.yml (for the repository's existing workflow conventions)

---

## Implementation Steps

1. Verification check: determine whether `.github/workflows/migration-ci.yml` exists. If it exists with the content below, record Already Applied. If absent, create `.github/workflows/migration-ci.yml` with exactly:

```yaml
name: Migration CI

on:
  push:
    paths:
      - "supabase/migrations/**"
      - "supabase/config.toml"
      - ".github/workflows/migration-ci.yml"
  pull_request:
    paths:
      - "supabase/migrations/**"
      - "supabase/config.toml"

jobs:
  db-reset:
    name: supabase db reset (migrations apply cleanly)
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Supabase CLI
        uses: supabase/setup-cli@v1
        with:
          version: latest

      - name: Start local Supabase stack
        run: supabase start

      - name: Apply all migrations on a clean database
        run: supabase db reset

      - name: Stop local Supabase stack
        if: always()
        run: supabase stop
```

---

## Acceptance Criteria

- [ ] `.github/workflows/migration-ci.yml` exists with exactly the content in Step 1.
- [ ] The workflow triggers on push and pull_request for changes under `supabase/migrations/**` (and `config.toml` / the workflow file).
- [ ] The workflow runs `supabase db reset` (applying all migrations on a clean database) as its verifying step.
- [ ] On the CI provider, the first workflow run for this change **succeeds** (green) — confirming the current migration sequence applies cleanly in CI. (Observed at Review time after the Implement push.)
- [ ] No file outside Scope is modified.

---

## Execution Log

[Appended by the executing agent after each run against this Change Request, before IMPLEMENT
is considered complete, per synchronization as defined in AGENTS.md's Agent Handoff Protocol.
Append-only.]

### 2026-07-05 00:33 — Claude Code (Opus 4.8), IMPLEMENT

Outcome: Complete

Step results:
- Step 1: Applied — created `.github/workflows/migration-ci.yml` with exactly the specified content (push/PR triggers on `supabase/migrations/**`, `config.toml`, and the workflow file; job runs `supabase start` then `supabase db reset`).

The workflow content is verified locally; because a GitHub Action only runs on the provider, the workflow's actual green run is observed and recorded in Verification Notes after this Implement commit is pushed.

Commits: this Implement commit (adds the workflow). No migration, canonical document, or other workflow was changed.

---

## Verification Notes

[Appended by the reviewing agent after independently re-checking against the live repository and
the observed CI run. Append-only.]

### 2026-07-05 00:55 — Claude Code (Opus 4.8), REVIEW

Verdict: Confirmed Complete

Findings: Re-checked against the live repository and the observed CI run.
- `.github/workflows/migration-ci.yml` matches the Implementation Step: push/PR triggers on `supabase/migrations/**`, `config.toml`, and the workflow file; job runs `supabase start` then `supabase db reset`, with `supabase stop` on always.
- CI run observed (GitHub Actions run 28720335555, commit d778e5f): conclusion **success**; the job "supabase db reset (migrations apply cleanly)" passed in 2m38s — confirming the full migration sequence (migrations 1–6) applies cleanly on a fresh database in CI, not only locally.
- Scope: only `.github/workflows/migration-ci.yml` (and this Change Request) changed; no migration or canonical document touched.
- Minor, non-blocking: the run annotated a Node.js 20 deprecation for `actions/checkout@v4` / `supabase/setup-cli@v1` (auto-forced to Node 24). Not a failure; a future action-version bump is recorded in the Future Backlog.

Recommendation to human: Set Status to Complete.

---

## Review Gate

- [ ] The workflow file matches the Implementation Step exactly.
- [ ] The first CI run on the provider is green.
- [ ] No file outside Scope was modified.
- [ ] The repository is in a clean, releasable state.

---

## Notes

This is the detection layer for a direct-to-`main` repository. A local pre-push `db reset` (prevention) is a reasonable future follow-on but is intentionally out of scope here to keep this Change Request minimal and self-contained. If `supabase start` proves too heavy or flaky on the runner, a fallback (a `postgres` service container plus manual application) is **not** viable as-is because the migrations reference `auth.users` and Supabase extensions — the Supabase CLI is required for fidelity; any runner issue is fixed within this Change Request rather than by weakening the check.
