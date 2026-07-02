# Change Request — [TASK-ID]

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word (for example
"Ready", "Implemented", or "Rejected") anywhere in a Change Request.

---

## Assigned Model Tier

Mark one:

[ ] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

[ ] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

[One sentence. State exactly what this task produces. No ambiguity. No compound objectives.
Context, rationale, and anything that does not fit in one sentence belongs in Business Reason
or Notes below, not here.]

---

## Business Reason

[Why this task exists, in business or architectural terms. This section is for human reviewers
evaluating whether to approve the task — the execution agent is not required to read or act on
it. One short paragraph or a short bullet list.]

---

## Risks

[What could go wrong if this task is approved and executed, and how severe. For human reviewers
only, same as Business Reason. If there is no material risk, state that explicitly rather than
leaving the section blank.]

---

## Supersedes / Depends On

[List any other changes/*.md files this task replaces, extends, or requires to have already been
completed. Write "None" if not applicable. A Change Request that supersedes another must state so
explicitly here, and the superseded file's Status must be updated to Cancelled with a note pointing
to the new file — never leave two files describing overlapping work both marked Draft or Approved.]

---

## Scope — Files Allowed to Modify

[List every file that MAY be read or modified during this task. Exact paths only. No wildcards.]

-

---

## Out of Scope — Files Forbidden to Modify

[List every file that must NOT be touched. Include files the agent might reasonably assume are in
scope. Scope above is exhaustive: any file not listed in Scope is out of scope by default, with no
exceptions, whether or not it is separately listed here. This section exists to call out specific
files that pose a realistic risk of being assumed in-scope (adjacent files in the same folder,
related governance files, the changes/ folder itself) — it is not required to enumerate the entire
repository, but every file it does name must be an exact path, never a category or a wildcard.]

-

---

## Minimum Reading List

[List only the files the agent must read to complete this task. No additional files may be read.]

-

---

## Implementation Steps

[Number each step. Each step must be deterministic. Each step must identify exactly what to change,
exactly where to change it, and exactly what must remain untouched. No step may require inference,
judgment, or improvisation. If a step cannot be written deterministically, stop and escalate.

Every step must begin with a verification check: the exact string or heading to search for that
proves the step has already been applied. If the check matches, the step is skipped and recorded
as Already Applied — it is never re-applied. If the check does not match, the step's edit is
applied exactly as written. This makes every Change Request safe to run against a repository whose
exact current state was not independently confirmed before the task was written. If a verification
check produces a result the step did not anticipate (for example, the target exists but only
partially matches), the agent must stop and report the discrepancy rather than guess which state
is correct.]

1.

---

## Acceptance Criteria

[Binary. Every item must be verifiable by reading the repository after the task completes.
No subjective criteria. Prefer one criterion per Implementation Step over a small number of
broad criteria — this makes partial completion and partial failure both individually visible.]

- [ ]

---

## Execution Log

[Appended by the executing agent (Tier 2) after each run against this Change Request.
Append-only — never edit or delete a prior entry, including a Blocked or Failed one.
Leave this section's bracketed instructions in place in an unused template; remove them
only in a CR that has at least one real entry.]

### <YYYY-MM-DD HH:MM> — <agent identifier>

Outcome: Complete | Blocked | Failed

Step results:
- Step 1: Already Applied | Applied | Failed — <one-line reason>

Commits: <commit hash(es) for this run>

Blocker: <only present if Outcome is Blocked or Failed. One factual paragraph describing
exactly which verification check produced an unanticipated result and where. Do not propose
or apply a guessed resolution.>

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

[Optional. Record architectural context, blockers encountered, or decisions made during this task.
Leave blank if not needed.]
