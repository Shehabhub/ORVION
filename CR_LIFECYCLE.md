# Change Request Lifecycle

## 1. Purpose

This document is the single authoritative reference for the lifecycle of a Change Request in this repository — its states, allowed transitions, and the responsibility for each transition, and how mid-execution discoveries are handled. It consolidates behavior already established across `AGENTS.md`, `PROTOCOL.md`, `changes/TEMPLATE.md`, and `changes/SPEC-010-cr-living-artifact-protocol.md`. It introduces no new state, transition, responsibility, or governance beyond what those documents already establish.

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

## 11. Engineering Observations

A discovery made during IMPLEMENT or REVIEW that was not anticipated by the Change Request's own Implementation Steps is recorded as an Engineering Observation — what was discovered, why it matters, and which of two outcomes applies. It stays inside the current Change Request only if it touches a file already in that Change Request's Scope, uses a mechanism the Change Request already relies on, and requires no judgment beyond what the Change Request was already drafted to make — and only if flagged before that Change Request is Approved, never added silently afterward. Otherwise it becomes its own future Change Request. An Engineering Observation is never silently implemented and never silently discarded.

An Observation concerning the engineering methodology itself — as distinct from repository content — never interrupts the Change Request that surfaced it. The current Change Request always completes its own lifecycle normally first; only afterward is a methodology refinement considered, and only through its own Change Request. The methodology does not change inside an implementation package.
