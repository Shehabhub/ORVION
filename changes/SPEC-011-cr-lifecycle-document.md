# Change Request — SPEC-011

## Status

[x] In Progress

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model
    Permitted modes: ANALYZE, PLAN, REVIEW, REFACTOR

Note, matching the precedent set by `SPEC-010`: this Change Request creates and edits governance/authority documents (`CR_LIFECYCLE.md`, `AGENTS.md`), requiring judgment about wording and placement, not mechanical text insertion.

---

## Objective

Create `CR_LIFECYCLE.md`, a single canonical document consolidating the already-approved Change Request state machine — states, transitions, and responsibilities — defining the meaning of REVIEW, and pointing to `AGENTS.md`'s existing definitions of IMPLEMENT and Synchronization.

---

## Business Reason

The Change Request lifecycle is currently correct but distributed: `AGENTS.md`'s Agent Handoff Protocol carries the living-artifact principle and the definitions of IMPLEMENT and Synchronization (`SPEC-010`); `changes/TEMPLATE.md` carries the five-value Status vocabulary and the per-field mechanics; `PROTOCOL.md` carries the general collaboration principles; and the state-transition table, responsibility-per-transition mapping, and the meaning of REVIEW have never been written down in one place — they exist only as behavior demonstrated across `SPEC-004`, `SPEC-005`, `SPEC-007`, `SPEC-008`, `SPEC-009`, and `SPEC-010`. This task consolidates that already-approved behavior into one authoritative reference before SQL implementation begins, introducing no new state, transition, responsibility, or governance.

`CR_LIFECYCLE.md` is placed at repository root, alongside `AGENTS.md` and `PROTOCOL.md`, because its content is conduct-governing authority (who may perform which transition, when IMPLEMENT/REVIEW are satisfied) — the same category of document as its root-level peers — not descriptive artifact documentation like `changes/TEMPLATE.md`.

---

## Risks

None. This task creates one new file whose entire content is already-approved behavior consolidated for reference, and makes one single-line pointer edit in `AGENTS.md` so the new document is reachable from the existing governance entry point. No existing rule in `AGENTS.md`, `PROTOCOL.md`, or `changes/TEMPLATE.md` is altered, removed, or contradicted.

---

## Supersedes / Depends On

Supersedes: None.

Depends on: `SPEC-005-agent-handoff-protocol.md` and `SPEC-010-cr-living-artifact-protocol.md` must already be applied, since this document's content assumes both (the `## Agent Handoff Protocol` section and the IMPLEMENT/Synchronization definitions it contains) already exist in `AGENTS.md` — confirmed prior to this task being written.

---

## Scope — Files Allowed to Modify

- CR_LIFECYCLE.md (new file, repository root)
- AGENTS.md

---

## Out of Scope — Files Forbidden to Modify

Scope above is exhaustive for engineering artifacts: any engineering file not listed in Scope is out of scope by default, with no exceptions, whether or not it is separately listed here.

- `PROTOCOL.md`, `changes/TEMPLATE.md` — this task references both but modifies neither; their content is already correct and is not restated in `CR_LIFECYCLE.md`, only summarized at the relationship level (§9 of the new document).
- `AGENTS.md`'s `# Protected Resources` list — not touched. Adding `CR_LIFECYCLE.md` to that list would be introducing new governance (a new protection rule), which this task is not authorized to do.
- `README.md` — not touched. Registering the new file in the Repository Structure list is a reasonable future documentation task but is not required for this document to be authoritative, and touching it is not requested.
- Every `_ORVION_CANONICAL/**` file, `reports/**`, and every existing `changes/SPEC-002` through `SPEC-010` file — historical or business-specification content, not touched.

Exception: this Change Request's own file is always implicitly in scope for synchronization, as defined in `AGENTS.md`'s Agent Handoff Protocol. Updating it in that sense is never a Scope violation; this exception is defined once, there, and is not restated here.

---

## Minimum Reading List

- AGENTS.md
- changes/TEMPLATE.md
- changes/SPEC-010-cr-living-artifact-protocol.md

---

## Implementation Steps

### Step 1 — Create `CR_LIFECYCLE.md` at repository root

Verify: check whether `CR_LIFECYCLE.md` already exists at the repository root.
- If it exists: Already Applied, skip (do not overwrite an existing file under this Change Request).
- If it does not exist: create it with exactly the following content:

```
# Change Request Lifecycle

## 1. Purpose

This document is the single authoritative reference for the lifecycle of a Change Request in this repository — its states, allowed transitions, and the responsibility for each transition. It consolidates behavior already established across `AGENTS.md`, `PROTOCOL.md`, `changes/TEMPLATE.md`, and `changes/SPEC-010-cr-living-artifact-protocol.md`. It introduces no new state, transition, responsibility, or governance beyond what those documents already establish.

## 2. Lifecycle Overview

A Change Request begins as a proposal (`Draft`), authored against `changes/TEMPLATE.md`. A human approves it (`Approved`). An executing agent applies its Implementation Steps and synchronizes the Change Request's own state as the final part of the same task (`In Progress`). An independent agent then reviews the work against the live repository, without trusting the Execution Log's self-report, and records its findings — this activity does not change Status. A human closes the Change Request once the Review Gate is satisfied (`Complete`). A Change Request may be abandoned at any point before closure (`Cancelled`). Throughout this lifecycle, the Change Request is a living repository artifact, not merely an instruction document — its own state is part of the work, not separate from it.

## 3. Official CR States

Exactly five, per `changes/TEMPLATE.md`:

- `Draft`
- `Approved`
- `In Progress`
- `Complete`
- `Cancelled`

No other status word is used. In particular, "Review" is not a Status value — it is an activity performed while Status remains `In Progress` (see §7).

## 4. Allowed State Transitions

| From | To |
| --- | --- |
| `Draft` | `Approved` |
| `Draft` | `Cancelled` |
| `Approved` | `In Progress` |
| `Approved` | `Cancelled` |
| `In Progress` | `Complete` |
| `In Progress` | `Cancelled` |

`Complete` and `Cancelled` are terminal. A closed Change Request is never reopened; a correction is made through a new Change Request (see `changes/SPEC-003-phase1-consistency-fix.md` for the established precedent).

## 5. Responsibility Of Each Transition

| Transition | Responsible party |
| --- | --- |
| `Draft` -> `Approved` | Human only |
| `Draft` -> `Cancelled` | Human only |
| `Approved` -> `In Progress` | The executing agent, as the first action of its own execution run |
| `Approved` -> `Cancelled` | Human only |
| `In Progress` -> `Complete` | Human only, after the Review Gate is satisfied |
| `In Progress` -> `Cancelled` | Human only |

No agent may set Status to `Complete` or `Cancelled` under any circumstance.

This table arranges the responsibility rule already stated in `AGENTS.md`'s Agent Handoff Protocol against each transition; that document remains authoritative if the two ever appear to differ.

## 6. Meaning Of IMPLEMENT

IMPLEMENT's meaning, including when it is considered complete, is defined once in `AGENTS.md`'s Agent Handoff Protocol and is not restated here.

## 7. Meaning Of REVIEW

REVIEW is independent verification of a Change Request's execution against the live repository state, not against the Execution Log's self-report. REVIEW checks every Acceptance Criterion and every Review Gate item, and records its findings as a Verification Notes entry with a verdict (`Confirmed Complete`, `Discrepancy Found`, or `Needs Corrective Change Request`). REVIEW does not change Status — a human, informed by REVIEW's findings, decides whether to advance Status to `Complete` or `Cancelled`. REVIEW is an activity, performed while Status is `In Progress`; it is not itself a Status value.

## 8. Meaning Of Synchronization

Synchronization is defined once, in `AGENTS.md`'s Agent Handoff Protocol, and is not restated here — consistent with the single-source-of-truth rule established in `changes/SPEC-010-cr-living-artifact-protocol.md`. See that section for the exact definition of which sections synchronization covers and which it never authorizes modifying.

## 9. Relationship Between Governance Documents

- **`AGENTS.md`** — the operational authority for agent execution. Takes precedence over `PROTOCOL.md` where the two would otherwise conflict. Holds the canonical definitions of IMPLEMENT and Synchronization.
- **`PROTOCOL.md`** — collaboration principles only. Defers to `AGENTS.md` on execution rules.
- **`changes/TEMPLATE.md`** — the per-Change-Request document format. Defines the fields every Change Request contains and the mechanical exception that makes a Change Request's own workflow-state sections always in scope for synchronization.
- **This document** — the single authoritative reference for the Change Request state machine specifically: its states, transitions, and responsibilities. It consolidates what the three documents above already establish; it does not add to or duplicate their content.

## 10. State Machine

```text
Draft
  -> Approved     (human)
  -> Cancelled    (human)

Approved
  -> In Progress  (executing agent, first action of its own execution run)
  -> Cancelled    (human)

In Progress
  -> Complete     (human, after Review Gate satisfied)
  -> Cancelled    (human)

  Review is an activity performed here, not a transition:
  Verification Notes are appended while Status remains In Progress.

Complete    (terminal)
Cancelled   (terminal)
```
```

### Step 2 — Point `AGENTS.md`'s protocol reference at the new document

Verify: search for the exact string `CR_LIFECYCLE.md` in `AGENTS.md`.
- If found: Already Applied, skip.
- If not found: locate the exact line:

```
* Full protocol: `reports/repository-communication-protocol.md`.
```

Replace it with:

```
* Full protocol: `CR_LIFECYCLE.md` (the authoritative Change Request state-machine reference); design rationale: `reports/repository-communication-protocol.md`.
```

Do not alter any other line in `AGENTS.md`.

---

## Acceptance Criteria

- [x] `CR_LIFECYCLE.md` exists at the repository root with all 10 sections present, in order.
- [x] §3 lists exactly five states and explicitly states Review is not a Status value.
- [x] §5's responsibility table is followed by the derived-view note citing `AGENTS.md` as authoritative.
- [x] §6 is a pointer to `AGENTS.md`'s definition of IMPLEMENT and does not restate it.
- [x] §8 references `AGENTS.md`'s Synchronization definition and does not restate it.
- [x] `AGENTS.md`'s `Full protocol:` bullet now references `CR_LIFECYCLE.md` (root path); no other line in `AGENTS.md` is changed.
- [x] No file outside Scope was modified or created.
- [x] `AGENTS.md`'s Protected Resources list, `README.md`, `PROTOCOL.md`, and `changes/TEMPLATE.md` are unchanged.

---

## Execution Log

### 2026-07-02 14:43 — Claude (Sonnet 5)

Outcome: Complete

Step results:
- Step 1: Applied — `CR_LIFECYCLE.md` did not exist at repository root; created with all 10 sections exactly as specified.
- Step 2: Applied — `AGENTS.md` did not yet reference `CR_LIFECYCLE.md`; the `Full protocol:` line was replaced exactly as specified. No other line in `AGENTS.md` was changed (confirmed by diff: a single line changed).

Commits: e564bcf

Note on synchronization scope for this run: per `AGENTS.md`'s Agent Handoff Protocol, IMPLEMENT's synchronization requires Status advanced and the Execution Log appended — that is what this entry does. Acceptance Criteria and Review Gate items were verified true against the live repository (see below) but their checkboxes are intentionally left unchecked here, since checking them is Review's synchronization, not IMPLEMENT's, and the two are not merged (`AGENTS.md`, `CR_LIFECYCLE.md` §6/§7).

Acceptance Criteria verification (informational, not a Review pass):
- `CR_LIFECYCLE.md` exists at repository root with all 10 sections present, in order — confirmed.
- §3 lists exactly five states and states Review is not a Status value — confirmed.
- §5's responsibility table is followed by the derived-view note citing `AGENTS.md` — confirmed.
- §6 is a pointer to `AGENTS.md`'s IMPLEMENT definition, not a restatement — confirmed.
- §8 references `AGENTS.md`'s Synchronization definition, not a restatement — confirmed.
- `AGENTS.md`'s `Full protocol:` bullet references `CR_LIFECYCLE.md`; no other line changed — confirmed via `git diff`.
- No file outside Scope was modified or created — confirmed via `git status` (only `AGENTS.md` modified, `CR_LIFECYCLE.md` new).
- `AGENTS.md`'s Protected Resources list, `README.md`, `PROTOCOL.md`, and `changes/TEMPLATE.md` are unchanged — confirmed, none were touched.

---

## Verification Notes

### 2026-07-02 14:53 — Claude (Sonnet 5)

Verdict: Confirmed Complete

Findings: Independently re-checked against live repository state, not against the Execution Log's self-report.

- Read `CR_LIFECYCLE.md` directly: all 10 sections present, in order, content matching SPEC-011 Step 1's specified text exactly.
- `git diff c9bd236 HEAD -- AGENTS.md`: exactly one line changed (the `Full protocol:` bullet), matching Step 2 exactly.
- `git diff c9bd236 HEAD -- PROTOCOL.md README.md changes/TEMPLATE.md`: empty — confirmed untouched.
- Grepped `AGENTS.md`'s `# Protected Resources` list directly: still exactly `AGENTS.md`, `README.md`, `docs/**`, `_ORVION_CANONICAL/**` — `CR_LIFECYCLE.md` not added.
- `git status --porcelain`: no file outside Scope (plus this Change Request's own implicitly-in-scope file) shows any change.
- All 8 Acceptance Criteria and all 7 Review Gate items independently confirmed true; checkboxes below updated accordingly.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [x] No file outside the Scope list was modified or created.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] Confirmed `SPEC-005` and `SPEC-010` were already applied before this task began.
- [x] The repository is in a clean, releasable state.

---

## Notes

This task is a documentation consolidation only. It does not alter the Status vocabulary, does not add a "Review" state, does not change any transition or responsibility already established, and does not restate the IMPLEMENT or Synchronization definitions `AGENTS.md` already holds. File location (repository root) was pressure-tested across two review rounds: an initial folder-precedent argument favored `changes/`, but the final review applied architectural-responsibility reasoning only (authority-over-conduct vs. artifact-shape documentation) and concluded root is correct, since this document's content governs conduct the same way `AGENTS.md` and `PROTOCOL.md` do, rather than describing one artifact's structure the way `changes/TEMPLATE.md` does. Two deliberate exclusions recorded rather than silently made: `AGENTS.md`'s Protected Resources list is not extended (new governance, forbidden during drafting), and `README.md`'s Repository Structure list is not updated (future task, not required for authority).
