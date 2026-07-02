# Repository Communication Protocol — Claude Code ⇄ Codex

Version: 0.1
Status: Proposal (not yet adopted — becomes binding only once `changes/SPEC-005-agent-handoff-protocol.md` is approved and executed)
Normative for: any agent operating under `AGENTS.md` in this repository
Companion document: `reports/workflow-architecture-report.md` (rationale and rejected alternatives)

---

## 1. Roles

| Agent | Modes | Responsibilities |
| --- | --- | --- |
| Claude Code | ANALYZE, PLAN, REVIEW, REFACTOR (`Assigned Model Tier` = Tier 1 in `changes/TEMPLATE.md`) | Analysis, architecture review, specification design, Change Request authoring, QA/verification of executed Change Requests |
| Codex | IMPLEMENT only (`Assigned Model Tier` = Tier 2) | Deterministic execution of Approved Change Requests; reporting scope/verification discrepancies via the Execution Log |
| Human | All modes; sole authority over Status transitions | Approves Change Requests, performs the final Review Gate, approves phase transitions |

Neither agent may act outside its assigned mode, per `AGENTS.md` §Operating Modes, unchanged by this protocol.

---

## 2. File Inventory And Ownership

| Location | Producer | Consumer | Permanence | Committed to Git? |
| --- | --- | --- | --- | --- |
| `changes/SPEC-NNN-*.md` | Claude (Draft) | Human (Approved), Codex (executes), Claude (verifies) | Permanent — never deleted, only superseded by a new numbered CR | Yes, always |
| `changes/TEMPLATE.md` | Human/Claude (governance edits only, via a CR) | Both agents (format reference) | Permanent | Yes |
| `reports/*.md` | Claude | Human, future agents | Permanent — historical/analysis record | Yes |
| `_ORVION_CANONICAL/manifest.md` `Active Change Request` field | Claude (sets on handoff), Human (clears on Complete/Cancelled) | Both agents (first file read each session) | Permanent (the field), transient (its value) | Yes, every change committed |
| `.aider.chat.history.md`, `.aider.input.history`, `.aider.tags.cache.v4/` | Codex tooling (Aider) | Nobody — local scratch | Transient | No — already gitignored, unchanged by this protocol |
| Any ad hoc scratch file created during analysis (e.g., temp notes) | Either agent | Nobody once the task ends | Transient | **No** — must not be committed; use the session scratchpad directory instead, never the repository working tree |

No new folder and no new file type is introduced. See `reports/workflow-architecture-report.md` §3 for why `handoff/`/`workflow/`/`execution/` and a lock file were both rejected.

---

## 3. Unit Of Work: The Change Request Lifecycle

Unchanged Status vocabulary (`changes/TEMPLATE.md`), now with explicit ownership per transition:

```text
Draft         (written by Claude)
  -> Approved   (flipped by Human only)
  -> In Progress (flipped by Codex, at start of execution)
  -> Complete    (flipped by Human only, after Review Gate)
  -> Cancelled   (flipped by Human only, at any point)
```

No agent may flip a Status to `Complete` or `Cancelled`. Codex may flip `Approved -> In Progress` as the first action of its own execution run, and must not proceed past that point if it finds any Status other than `Approved`.

---

## 4. Handoff: Claude → Codex

1. Claude authors the CR file in `changes/`, Status: Draft, fully complying with `TEMPLATE.md` (Scope, Out of Scope, deterministic verification-gated Steps, Acceptance Criteria).
2. Claude does **not** set `manifest.md`'s `Active Change Request` field yet — that field must only ever point at an `Approved` or `In Progress` CR, never a `Draft` one, so that Codex can trust the pointer without re-checking Status on every unrelated file.
3. The human reviews the Draft CR and, if acceptable, flips Status to Approved and sets `manifest.md`'s `Active Change Request: changes/SPEC-NNN-*.md`. (This single combined edit is the entire "handoff" — one commit, no chat message required.)
4. On its next invocation, Codex reads `manifest.md` first (per existing `SYSTEM_PROMPT.md`/`manifest.md` convention — unchanged), sees the pointer, opens exactly that one file, confirms Status: Approved, and begins execution.

If `manifest.md`'s `Active Change Request` field is `None`, Codex has no work and must not scan `changes/` looking for one — this is an explicit rule to prevent the O(n) folder-scan `manifest.md` was already designed to avoid ("Codex should never scan the entire repository").

---

## 5. Handoff: Codex → Claude (Execution Reporting)

Codex appends a new `## Execution Log` entry to the CR file itself — a new section between `## Acceptance Criteria` and `## Review Gate` in `TEMPLATE.md` (added by `SPEC-005`). Entries are **append-only**: never edit or delete a prior entry, even a failed one.

Required entry format:

```markdown
### <YYYY-MM-DD HH:MM> — Codex

Outcome: Complete | Blocked | Failed

Step results:
- Step 1: Already Applied | Applied | Failed — <one-line reason>
- Step 2: ...

Commits: <commit hash(es) for this run, space-separated>

Blocker: <only present if Outcome is Blocked or Failed — one factual paragraph describing
exactly which verification check produced an unanticipated result and where. State the
discrepancy. Do not propose or apply a guessed resolution.>
```

Rules:

- Every Implementation Step must appear in "Step results," even ones that were Already Applied — this is what lets Claude's later verification pass be a read, not a re-derivation.
- "Commits" references Git history rather than re-pasting diffs, keeping the entry cheap to read on every future session (§ Token-Usage Rules, §9).
- If any step could not be resolved deterministically, Codex sets Outcome to `Blocked`, stops immediately (unchanged from today's rule — `TEMPLATE.md` already requires this), and does not flip Status past `In Progress`. A `Blocked` outcome is not an error state to hide; it is the expected, correct output of the "never guess" rule.

---

## 6. Handoff: Claude's Review → Human (Verification Reporting)

Claude appends a `## Verification Notes` entry, immediately after `## Execution Log` in the same file:

```markdown
### <YYYY-MM-DD HH:MM> — Claude

Verdict: Confirmed Complete | Discrepancy Found | Needs Corrective Change Request

Findings: <what was independently re-checked against the live repository, and what was found>

Recommendation to human: Set Status to Complete
                        | Set Status to Cancelled
                        | Approve corrective Change Request `changes/SPEC-00N-*.md` (see below)
```

Claude's verification must independently re-read the actual target files and re-check each Acceptance Criterion — it must not simply trust Codex's self-reported "Applied." This is the QA function the human currently performs implicitly by relaying and re-reading chat output; this protocol moves it into a file-based, repeatable step instead of removing it.

---

## 7. Failure And Blocker Reporting

There is no separate "blocker file" and no new Status value (see rationale in the companion Workflow Architecture Report, §3.3). A blocker is reported exactly once, in the `## Execution Log` entry that encountered it (§5), and is never silently retried by guessing. If Claude's Verification pass independently discovers a problem Codex did not report (e.g., a step that was marked Applied but does not actually satisfy its Acceptance Criterion), that also goes in `## Verification Notes` with `Verdict: Discrepancy Found` — never as a silent fix.

---

## 8. Corrective Change Requests

A CR, once its Status reaches `Complete`, is a closed historical record and must never have its Implementation Steps, Acceptance Criteria, Execution Log, or Verification Notes edited retroactively — this mirrors the repository's own "events are immutable" principle (`27_event_catalog.md` §Event Principles) applied to the workflow layer itself. If Codex's execution or Claude's verification reveals the original CR was incomplete or wrong, the fix is a new, sequentially numbered CR whose `Supersedes / Depends On` section names the prior one — exactly the pattern already established by `SPEC-003` correcting `SPEC-002`. This rule is not new; this protocol only names and generalizes it.

---

## 9. Commit Conventions

- Claude's CR authoring (Draft) is its own commit, not mixed with other file changes.
- The human's Draft → Approved edit (plus the `manifest.md` pointer update) is its own small commit.
- Codex's execution is committed once its full step sequence for that run completes (or is Blocked) — one commit per Execution Log entry is the target granularity, referencing the CR ID in the commit message (e.g., `SPEC-005: apply Execution Log / Verification Notes template sections`), so `git log` becomes a directly queryable audit trail without opening any file, consistent with `PROTOCOL.md`'s "Git is the execution history."
- Claude's Verification Notes append is its own commit.
- The human's final Status → Complete/Cancelled edit (plus clearing the `manifest.md` pointer) is its own commit.

This keeps every actor's contribution independently attributable and revertible in `git log`/`git blame`, without requiring any commit message convention beyond "mention the CR ID" — already implicitly followed by this repo's existing commit style.

---

## 10. What Must Never Be Committed

Unchanged from the existing `.gitignore`: Aider runtime state (`.aider.chat.history.md`, `.aider.input.history`, `.aider.tags.cache.v4/`), OS artifacts, Python caches. This protocol introduces no new transient artifact, so no `.gitignore` change is proposed. Any scratch file either agent needs mid-task belongs in that agent's own session-scratch area (for Claude Code, the scratchpad directory noted in its environment context), never in the repository working tree, even temporarily.

---

## 11. Token-Usage Rules

- Both agents read `_ORVION_CANONICAL/manifest.md` first, every session — unchanged existing convention, now load-bearing for handoff too via the `Active Change Request` field.
- If the pointer is `None`, no further `changes/` files need to be opened to determine "is there work for me" — this is the single biggest token saving in this design over a folder-scan approach.
- Execution Log and Verification Notes entries are structured bullets, not prose narrative, and must reference commit hashes rather than re-pasting diffs or full file contents.
- Neither agent re-reads a CR's already-closed Execution Log/Verification Notes history once its Status is `Complete`, except when explicitly asked to — closed CRs are archival, not part of the "current working set" either agent needs to hold in context.

---

## 12. Phase Completion And Next-Phase Initiation

Unchanged from current practice, and deliberately **not** automated by this protocol (see Workflow Architecture Report §6): `_ORVION_CANONICAL/32_execution_roadmap.md`'s per-phase Status field and `manifest.md`'s Current Phase/Module/Task fields are edited by Claude in ANALYZE or PLAN mode, with explicit human approval, only after every CR belonging to the current phase has reached `Complete`. Neither agent may advance a phase automatically as a side effect of a CR closing.

---

## 13. Explicit Non-Goals

This protocol does not: remove the human Approved/Complete gates; enable Codex or Claude to approve their own or each other's work; introduce a new folder, file type, or Status value; introduce any lock file, queue, or live signaling mechanism; require any new tooling, extension, or background process beyond what VS Code and Git already provide; or automate phase transitions.
