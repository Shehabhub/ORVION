# Change Request — SPEC-026

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

Amend the `Complete SPEC-NNN` command definition in `AGENTS.md` so that completing a Change Request also publishes its commits by pushing to the current branch's configured upstream and confirming that upstream contains the new Complete commit.

---

## Business Reason

The local branch is currently 12 commits ahead of its upstream — completed Change Requests have not been published, so the remote does not reflect the repository's true state. This amendment makes remote publication a defined part of `Complete` (the only transition that closes a Change Request), removing the reliance on a separately-remembered manual push — the same Zero-Memory principle already applied to state synchronization in `SPEC-012`. It deliberately does not adopt any branch or Pull Request topology (that remains intentionally undefined) and names no specific branch; it defines only that Complete publishes the existing commits to the current branch's upstream.

---

## Risks

Low, and bounded by design. Push is a best-effort publish performed after the Complete commit; if it cannot complete (no network or authentication), the Complete transition remains valid locally because the repository history is the source of truth (`PROTOCOL.md`), and the commits publish on the next successful push. No separate remote commit hash is recorded — that would duplicate git history and would require editing a closed Change Request's append-only Execution Log (`AGENTS.md` Multi-Agent / Handoff rules), which is forbidden. `repository-all.ps1` is intentionally not used here: its `git add .` and interactive commit prompt would create a new commit and stage deliberately-untracked files, rather than publishing the existing Complete commit.

---

## Supersedes / Depends On

None.

---

## Scope — Files Allowed to Modify

- AGENTS.md

---

## Out of Scope — Files Forbidden to Modify

- _ORVION_CANONICAL/** (no canonical document is touched)
- PROTOCOL.md, CR_LIFECYCLE.md (the Complete command is defined only in AGENTS.md; no restatement is added elsewhere)
- scripts/repository-all.ps1 (not the mechanism; not modified)
- changes/TEMPLATE.md (no new Execution Log field is added; the published hash is not recorded)
- Any changes/SPEC-*.md file other than this one

---

## Minimum Reading List

- AGENTS.md

---

## Implementation Steps

1. Verification check: search `AGENTS.md` for the string `then publishes by running`. If present, record this step as Already Applied and make no change. If absent, in the `Complete SPEC-NNN` bullet of the Agent Handoff Protocol, replace the exact substring:

`which remains a separate human-gated command; commits. If no Verification Notes entry exists yet`

with:

`which remains a separate human-gated command; commits; then publishes by running \`git push\` and confirming the current branch's configured upstream contains the new Complete commit — equivalently, that no local commit remains ahead of the upstream (for example \`git rev-list @{u}..HEAD\` is empty). This sends all of the Change Request's commits — Approve, Implement, Review, Complete — to the remote at once. If the push cannot complete (for example, no network, no configured upstream, or authentication failure), the Complete transition remains valid locally — the repository history is the source of truth — and the commits are published on the next successful push; no separate remote commit hash is recorded, since git history is already the authoritative record. If no Verification Notes entry exists yet`

Change nothing else in the file.

---

## Acceptance Criteria

- [ ] `AGENTS.md`'s `Complete SPEC-NNN` bullet contains the clause beginning `then publishes by running \`git push\``.
- [ ] The clause states that a failed push does not invalidate the local Complete transition.
- [ ] The clause states that no separate remote commit hash is recorded.
- [ ] No other line in `AGENTS.md` is changed, and no other file is modified.
- [ ] The `Complete` command remains defined only in `AGENTS.md` (no duplicate definition is introduced in `PROTOCOL.md` or `CR_LIFECYCLE.md`).

---

## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request, before
IMPLEMENT is considered complete, per synchronization as defined in AGENTS.md's Agent Handoff
Protocol — this file is always implicitly in scope for this section.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]

### 2026-07-04 12:29 — Claude Code (Opus 4.8), IMPLEMENT

Outcome: Complete

Step results:
- Step 1: Applied — `then publishes by running` was absent from `AGENTS.md`; the anchor substring existed exactly once; performed the exact replacement adding the branch-agnostic publish clause to the `Complete SPEC-NNN` bullet.

Verification against Acceptance Criteria:
- `AGENTS.md`'s `Complete` bullet contains the clause beginning ``then publishes by running `git push` `` — confirmed.
- The clause states a failed push does not invalidate the local Complete transition ("Complete transition remains valid locally") — confirmed.
- The clause states no separate remote commit hash is recorded — confirmed.
- `git diff --stat` shows only `AGENTS.md` changed, one line — confirmed; no other file modified.
- The `Complete` command remains defined only in `AGENTS.md`; `then publishes by running` is not present in `PROTOCOL.md` or `CR_LIFECYCLE.md` — confirmed.

Commits: this Implement commit (modifies `AGENTS.md` and synchronizes this Change Request).

Note: the new publish clause first takes effect when a Change Request is Completed. This Change Request's own Complete (a later, human-gated step) will be the first to exercise it.

---

## Verification Notes

[Appended by the reviewing agent (Tier 1) after independently re-checking the Execution Log
against the live repository state. Append-only — never edit or delete a prior entry.]

### 2026-07-04 12:33 — Claude Code (Opus 4.8), REVIEW

Verdict: Confirmed Complete

Findings: Every Acceptance Criterion and Review Gate item was re-checked independently against live `AGENTS.md`, not against the Execution Log.
- The `Complete` bullet now contains the added clause verbatim: ``commits; then publishes by running `git push` and confirming the current branch's configured upstream contains the new Complete commit … no separate remote commit hash is recorded, since git history is already the authoritative record.`` — confirmed.
- Failed-push non-fatal wording present ("Complete transition remains valid locally"); no-hash wording present — confirmed.
- Branch-agnostic: `grep` finds no `origin/main` (or any hardcoded branch) in `AGENTS.md` — confirmed; the clause uses "the current branch's configured upstream" and `@{u}`.
- The `Complete` command remains defined only in `AGENTS.md`; the clause is absent from `PROTOCOL.md` and `CR_LIFECYCLE.md` — confirmed (no duplicated authority).
- Review Gate — scope: `git show --stat 416d286` confirms the Implement commit touched only `AGENTS.md` and this Change Request file; no other file. Supersedes/Depends On is None. Working tree is releasable.

Recommendation to human: Set Status to Complete. Note that this Complete will be the first to exercise the new clause and will push the accumulated local commits plus this Change Request's own to the current branch's upstream.

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

This side task is independent of the SQL migration flow and does not change the execution sequence; after it closes, the main flow resumes at `Approve SPEC-025`.

This Change Request will itself be the first Complete to exercise the new clause: completing it will push the accumulated local commits (currently 12 ahead of the upstream) plus this Change Request's own commits to the remote.

Design decisions and rejected alternatives, for the reviewer:
- The published hash is deliberately not recorded anywhere. Git already records it; the Complete commit's message already names the command; and recording it inside the Change Request would require editing a closed, append-only record.
- `repository-all.ps1` is deliberately not the mechanism. Plain `git push` publishes the existing Complete commit; the script would instead create a new commit via `git add .` (staging deferred files) and an interactive prompt.
- Only publish-to-upstream is defined. Branch and Pull Request topology remain intentionally undefined, consistent with the repository's prior governance conclusion.
