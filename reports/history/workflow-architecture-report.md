# Workflow Architecture Report — Repository-Native Agent Handoff

Version: 0.1
Status: Proposal (not yet adopted)
Author: Claude Code, in ANALYZE mode
Companion documents: `reports/repository-communication-protocol.md`, `changes/SPEC-005-agent-handoff-protocol.md`

---

## 1. Purpose And Constraints

The request: replace chat-relayed coordination between Claude Code (analysis, spec authoring, QA, review) and Codex (deterministic implementation, CR execution) with a protocol expressed entirely as repository files, optimizing for determinism, git-native history, auditability, maintainability, low token cost, low human intervention, and compatibility with existing tooling (Git, VS Code, this repo's governance).

The explicit non-goal, stated by the repository's own governance and repeated in this task's brief: this is not an invitation to remove human judgment from safety-relevant gates. `AGENTS.md` already states "Never assume IMPLEMENT," "Never switch modes automatically," "Stop immediately after completing the requested work," "Never continue automatically to the next task." Any workflow design that tries to make Draft→Approved or In-Progress→Complete transitions automatic would violate the repository's own stated safety posture. The correct optimization target is therefore: **eliminate manual relaying of information between agents, without eliminating the human decision points that currently exist by design.**

---

## 2. What Already Exists And Should Not Be Replaced

Before designing anything new, the existing mechanism was audited for reuse potential:

- **`changes/TEMPLATE.md`** already defines a closed, five-value Status vocabulary (Draft / Approved / In Progress / Complete / Cancelled), an `Assigned Model Tier` field that already encodes the Claude/Codex role split (Tier 1 = ANALYZE/PLAN/REVIEW/REFACTOR, Tier 2 = IMPLEMENT only), deterministic verification-gated Implementation Steps, binary Acceptance Criteria, and a human-completed Review Gate. This is, in effect, already a state machine for a single unit of work — the exact pattern this repository already uses everywhere else (lead status, booking status, subscription status). It is well-designed and should be **extended, not replaced**.
- **`_ORVION_CANONICAL/manifest.md`** already tracks "Current Phase / Current Task / Next Planned Task" and is explicitly the first file both agents are told to read every session ("Read this document first, then load only the required files. ... Codex should never scan the entire repository"). It is already the intended low-token entry point.
- **`reports/`** was established this session as Claude's output channel for non-executable analysis (comprehension reports, audits). It already has a working precedent.
- **`changes/`** already carries a two-generation precedent for corrective work (SPEC-002 → SPEC-003, a follow-up CR fixing an earlier one's incomplete scope) — proving the "never retroactively edit a closed record, always supersede" pattern already works in practice here.
- **`PROTOCOL.md`** already states the load-bearing principle this design leans on hardest: *"Git is the execution history."*
- **`.gitignore`** already excludes every actually-transient artifact in this repo (Aider caches, chat history). No new transient artifact is introduced by this design, so no `.gitignore` change is needed.

Given how much of the target state already exists, the design below is intentionally a **small, additive delta** — two new sections inside one existing template, one new field inside one existing tracking file, and one new subsection inside `AGENTS.md`. Nothing is deleted or restructured.

---

## 3. Rejected Alternatives (and why)

The brief explicitly invited a dedicated `handoff/`, `workflow/`, or `execution/` folder, and implicitly invited some kind of live signaling mechanism. Both were seriously considered and rejected.

### 3.1 A dedicated `handoff/` (or similarly named) folder

**Rejected.** A Change Request already fully describes one unit of work: what to change, why, its scope boundary, its steps, its pass/fail criteria. Splitting "here is the work" (in `changes/`) from "here is what happened when it ran" (in a hypothetical `handoff/`) forces every future reader — human or agent — to open two files and manually correlate them by filename to reconstruct one task's history. This directly works against two of the stated optimization targets: **auditability** (a single unit of work should have a single, linear, append-only record) and **minimal token usage** (opening two files costs more context than opening one). The Execution Log therefore lives **inside** the CR file it reports on, not beside it.

### 3.2 A lock file to enforce "one task at a time"

**Rejected.** `PROTOCOL.md` already states "One task at a time... One implementation at a time" as a *rule*, not yet as a *mechanism*. A literal lock file (e.g., `changes/.active`) is a classic distributed-systems anti-pattern inside Git specifically: it causes merge conflicts on concurrent branches, and a lock left behind by a crashed or forgotten session silently blocks all future work with no self-healing path. The cheaper, git-native equivalent — a single human-readable pointer line in `manifest.md`, updated as part of normal commits — gets the same "what's active right now" answer without any of the failure modes of a lock file, and it is already inside the file both agents read first.

### 3.3 A new Status value (e.g., "Blocked") in `TEMPLATE.md`

**Rejected.** `TEMPLATE.md` is explicit and deliberate about its five-value closed vocabulary: *"Allowed values are exactly these five. Do not use any other status word."* This repo has already been burned once by vocabulary ambiguity — `CHANGE_REQUEST.md`'s deprecation note describes exactly this failure mode ("Two Change Request formats in the same folder... causes the local execution agent to stop and ask for clarification instead of executing"). Widening the Status enum to add "Blocked" risks the same class of failure for marginal benefit, since `TEMPLATE.md` already has a built-in escape hatch for this exact situation: *"If a verification check produces a result the step did not anticipate... the agent must stop and report the discrepancy rather than guess."* What was missing was not a new state — it was a **place to write down** what that escape hatch produces. That is what the Execution Log section supplies, without touching the Status vocabulary at all.

### 3.4 Chat-replacement via commit messages alone

**Considered and partially rejected.** Commit messages are good for *what changed*, but they are not queryable/structured enough to carry Acceptance-Criteria-level detail (which steps were Already Applied vs newly Applied, what a blocker's root cause was), and they are easy to write inconsistently across sessions/agents. Commit messages remain part of this design (§ "Commit Conventions" in the Protocol document) but as a *pointer*, not the payload — the payload lives in the CR file itself, which is durable, diffable, and already reviewed via the exact same Git tooling.

---

## 4. The Chosen Model

**One Change Request file is the unit of work, from birth to closure, including its own execution and review record.** Concretely:

1. Claude authors a CR in `changes/`, Status: Draft. This is unchanged from current practice (SPEC-002/003/004 already work this way).
2. The human flips one checkbox: Draft → Approved. This is the entire "coordination" the human performs to hand work to Codex — a single-line edit, not a relayed chat message. Claude also updates `manifest.md`'s new `Active Change Request` field to point at the file.
3. Codex, at the start of its own session, reads `manifest.md`'s `Active Change Request` field (not the whole `changes/` folder) to find the one file it should act on, confirms Status is `Approved`, executes the Implementation Steps exactly as written, and appends a structured `## Execution Log` entry to the *same file* — never editing the Implementation Steps or Acceptance Criteria it was given.
4. Claude, on its next invocation, reads `manifest.md`'s pointer, opens the one active CR, reads the Execution Log, independently re-verifies the Acceptance Criteria against the real repository state, and appends a structured `## Verification Notes` entry to the *same file* — recommending either "set Status to Complete," "set Status to Cancelled," or "see corrective Change Request `SPEC-00N`."
5. The human performs the final Review Gate check (unchanged — this is explicitly reserved to the human by `TEMPLATE.md` today) and flips Approved/In Progress → Complete, clearing `manifest.md`'s pointer back to `None`.
6. If Codex's execution is wrong or the CR itself was flawed, the fix is a new, numbered corrective CR (the SPEC-002→SPEC-003 pattern), never a retroactive edit — the closed CR's Execution Log and Verification Notes stand as a permanent, honest record of what actually happened, even if it was later found to be incomplete.

This means: **no new folder, no new file type, no new Status value, no lock file.** The only durable additions are two new sections in one template and one new field in one tracking file.

---

## 5. Why This Optimizes For The Stated Targets

- **Deterministic execution** — Codex's contract is unchanged (it still only ever executes verification-gated, already-approved steps); it now additionally has a mandatory, structured place to report exactly which steps were Already Applied, Applied, or produced an unanticipated result, instead of that information living only in an interactive terminal session or a chat transcript that never reaches the repository.
- **Repository history / auditability** — every unit of work is one file with a strictly append-only, chronologically ordered record (Draft → Approved → Execution Log entries → Verification Notes entries → Review Gate → Complete), directly mirroring this project's own immutable-event philosophy already documented in `27_event_catalog.md`. Nothing about a task's history is reconstructed by correlating multiple files.
- **Minimal token usage** — `manifest.md`'s new pointer field turns "which file has active work" from an O(n) folder scan into an O(1) read of a file both agents already open first; Execution Log entries are specified as terse structured bullets, not prose, and explicitly forbid re-pasting diffs (Git already has those, addressable by commit hash).
- **Minimal human intervention** — the human's only required actions become two single-field edits per CR (Draft→Approved, and the final Review-Gate-informed →Complete/Cancelled), both of which already exist in the current workflow; what is removed is the manual copy-paste of context between two chat sessions.
- **Compatibility with Git/VS Code** — every artifact is a plain Markdown file, diffable and reviewable in VS Code's native Git UI with zero new tooling, extensions, or background processes required.
- **Long-running enterprise compatibility** — the design scales to an arbitrary number of past CRs (each one closed and self-contained) without the active-state footprint growing; only `manifest.md`'s one pointer field represents "current work," so the cost of onboarding a new session (human, Claude, or Codex) into "what's happening right now" stays constant over the life of the project.

---

## 6. What This Design Deliberately Does Not Solve

Stated plainly, so it is not mistaken for an oversight:

- It does not make CR approval automatic. A human must still flip Draft → Approved before Codex may execute anything. This is intentional and matches existing governance.
- It does not make Complete automatic. The Review Gate remains human-completed, per `TEMPLATE.md`'s own words, unchanged.
- It does not automate phase transitions (`32_execution_roadmap.md`, `manifest.md`'s Current Phase/Module/Task fields). Those remain deliberate, human-approved edits performed by Claude in ANALYZE/PLAN mode — automating them would directly violate AGENTS.md's "Never continue automatically to the next task."
- It does not require any new background process, scheduler, or cross-agent live signaling. Both agents remain "pull" — each reads repository state when invoked, rather than one agent "pushing" to or waking the other. This keeps the design compatible with either agent being run manually, on a schedule, or not at all for arbitrary periods, without any coordination state going stale (unlike a lock file).

---

## 7. Migration Path

No retrofitting of `SPEC-002`, `SPEC-003`, or `SPEC-004` is required. The new `## Execution Log` / `## Verification Notes` sections are additive to `TEMPLATE.md` — existing closed CRs remain valid historical records exactly as written; only CRs authored *after* `SPEC-005` is approved and applied will carry the new sections. `SPEC-004` (still Draft as of this report) will pick up the new sections automatically once `SPEC-005` is applied, simply by virtue of being written against the updated template going forward — no edit to `SPEC-004` itself is required or proposed.
