# Repository Communication Protocol — v0.2 Addendum: Command Vocabulary

Version: 0.2 (amends `reports/repository-communication-protocol.md` v0.1 — v0.1 is not edited; this
document supersedes it for the topics covered here, following the same "never retroactively edit,
always supersede" rule this protocol itself defines for Change Requests)
Status: Proposal (not yet adopted — becomes binding only once a future Change Request, tentatively
`SPEC-006`, applies it to `AGENTS.md` / `PROTOCOL.md`)
Scope of this addendum: defines a small, closed set of natural-language commands the human may issue,
and exactly what repository bookkeeping each one authorizes an agent to perform — so the human never
opens a Markdown file to move a Change Request or phase through its lifecycle.

---

## 1. The Governing Rule

**A command authorizes an agent to perform bookkeeping. It never authorizes an agent to make the
decision the bookkeeping records.**

Every command below either (a) *is itself* the human's decision, restated as an instruction to act on
it, or (b) triggers an agent action whose only judgment is a mechanical precondition check, never a
substantive one. Nowhere in this vocabulary does an agent decide, on its own initiative, that a piece
of work is acceptable and then close the record — that would reproduce exactly the self-certification
risk already rejected for this repository (see `reports/workflow-architecture-report.md` §3 and the
prior design review that rejected fully autonomous Complete).

The specific mechanism that enforces this: **`Complete` is conditional on a Verification Notes entry
that already exists, committed in the repository, before the command is issued.** Not on the agent's
memory of the current conversation, and not on the command text alone. If no such entry exists yet,
the command does not close anything — it performs a `Review` and stops, waiting for a second, informed
command. This makes the safety property robust to session boundaries: it does not matter whether the
human read the verification result five seconds ago in this chat, or three weeks ago in a different
session — what matters is whether the evidence is in the file.

---

## 2. Command Table

| Command | Precondition the agent must check first | What the agent does | What the agent must refuse or flag |
| --- | --- | --- | --- |
| `Approve SPEC-NNN` | CR Status is currently `Draft` | Flip Status to `Approved`; set `manifest.md`'s `Active Change Request` to this CR's path; commit | If Status is already `Approved` or further along, report that instead of re-applying |
| `Execute SPEC-NNN` | CR Status is `Approved` | Flip Status to `In Progress`; perform the CR's Implementation Steps exactly as written; append an `## Execution Log` entry; commit | If Status is still `Draft`, refuse and state it has not been approved yet — never treat `Execute` as an implicit `Approve` |
| `Review SPEC-NNN` | CR Status is `In Progress` with at least one `## Execution Log` entry | Independently re-verify every Acceptance Criterion and Review Gate item against the live repository state (not against the Execution Log's self-report); append a `## Verification Notes` entry; commit | If no Execution Log entry exists yet, report that there is nothing to review |
| `Complete SPEC-NNN` | A `## Verification Notes` entry exists with `Verdict: Confirmed Complete` | Flip Status to `Complete`; clear `manifest.md`'s `Active Change Request`; commit | If no such entry exists yet, perform `Review` first, surface the result, and stop — do not close on this command alone. If the existing Verification Notes entry says `Discrepancy Found`, refuse and point to it |
| `Start Phase N` | Prior phase's status in `32_execution_roadmap.md` is `Complete` | Update the roadmap's phase table; update `manifest.md`'s Current Phase/Module/Task | If the prior phase is not `Complete` (e.g. open CRs remain), flag this explicitly and wait for the human to either resolve it or explicitly acknowledge the override — never silently proceed |
| `Freeze Phase N` | All Change Requests scoped to that phase are `Complete` or `Cancelled` | Update that phase's status to `Complete` in the roadmap | If any CR for that phase is still `Draft`/`Approved`/`In Progress`, list them and refuse until the human addresses or explicitly overrides |

A command maps to exactly one Status transition. `Complete SPEC-006` issued against a CR still in
`Draft` is not interpreted as "approve, execute, review, and complete it" — it is refused, with the
agent stating which command is actually needed next.

---

## 3. Why `Approve` And `Complete` Have Different Preconditions

`Approve` requires only the human's word, because the human is fully equipped to make that call
themselves — a Draft CR is a specification, and reading a specification is exactly the kind of review
a human can do unaided. `Complete` requires a committed Verification Notes entry, because it certifies
that the *implementation* matches the specification against the live repository state — a check that
specifically depends on independently reading the actual current file content, not just the plan for
it, and is exactly the class of work this protocol already assigns to Claude's REVIEW mode. Requiring
the evidence to already exist in the file (rather than trusting the command alone) is what keeps
`Complete` from becoming a rubber stamp.

---

## 4. Agent Assignment

`Execute` remains exclusively Tier 2 (Codex) work — mechanical, deterministic, fully specified by the
CR it acts on, unchanged from the base protocol. `Approve`, `Review`, `Complete`, `Start Phase`, and
`Freeze Phase` are Tier 1 (Claude) work — each involves a precondition check that requires judgment
(recognizing a contradiction, reading a Verification Notes verdict correctly) even though the resulting
file edit is small. This mirrors the same Tier 1/Tier 2 split `changes/TEMPLATE.md` already encodes.

---

## 5. Auditability: Commit Attribution

Every commit produced in response to a human command must state, in its message, that it was
human-directed and which command triggered it — e.g. `SPEC-006: Approve (human command)` — distinct
from Codex's own step-execution commits and Claude's own analytical commits (Verification Notes,
reports). This means `git log` alone — without any chat transcript, which is not part of the permanent
repository record — is sufficient to reconstruct, for any Status transition, whether it was a human
decision transcribed by an agent or an agent's own reported analysis. This is a net auditability
*improvement* over manual editing, not a regression: today, a human's hand-edited commit carries no
structured signal distinguishing "I decided this" from "I was just fixing a typo I noticed."

---

## 6. Residual Risk (stated plainly, not hidden)

This design does not protect against a human issuing `Complete` without actually having read the
Verification Notes entry that makes it valid — that risk exists identically today, whether the human
types the file edit themselves or asks an agent to. This protocol's guarantee is structural, not
behavioral: it guarantees an agent cannot close a record with **zero** human action, ever. It does not
and cannot guarantee the human's action was well-considered. That limitation is inherent to any
human-in-the-loop system and is not introduced or worsened by this addendum.

---

## 7. Verdict Against The Five Preservation Criteria

- **Repository safety** — preserved. No command allows an agent to both judge sufficiency and close
  the record without a prior, separately-committed, independently-produced verification artifact.
- **Auditability** — improved. Commit-message attribution now distinguishes human-directed bookkeeping
  from agent-authored analysis, which the manual-editing workflow never captured.
- **Deterministic execution** — preserved. The command table is closed and each row's action is fully
  specified; no command's effect depends on interpretation.
- **Git-native history** — preserved. No new infrastructure; the evidence a `Complete` command checks
  for is itself a Git-committed file section, not conversational or session state.
- **AGENTS.md philosophy** — preserved. Every refusal path above is a direct application of "if the
  request is ambiguous, stop and ask" and "never continue automatically to the next task" — a command
  never silently cascades into more than the one transition it names.

---

## 8. Next Step

This addendum is a design proposal only. Formalizing it requires a new Change Request (tentatively
`SPEC-006`) whose Scope would be `AGENTS.md` (extending the `## Agent Handoff Protocol` subsection
`SPEC-005` adds), and, once `SPEC-005` executes, the pointer text in `AGENTS.md` may need updating to
reference this addendum alongside `reports/repository-communication-protocol.md`. That Change Request
has not been drafted; it is recommended as the logical next step once `SPEC-005` itself is executed
and this addendum's design is confirmed acceptable.
