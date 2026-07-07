# AGENTS.md — ORVION Operating Model

This file is the **execution brain** for any engineering session in this repository — human or AI, any tool. It follows the cross-tool `AGENTS.md` convention (a README for agents). Read it once at the start of a session; it tells you how work is done here and where to look next. It is written to be lean on purpose: detail lives in the files it points to and is read only when the current state calls for it.

**Precedence.** A live instruction from the owner overrides this file. Otherwise this file is the authoritative operating model: where it and any older document (`PROTOCOL.md`, `global-rules.md`, or prose in `_ORVION_CANONICAL/`) appear to conflict, this file wins. `CR_LIFECYCLE.md` is authoritative for the Change Request state machine specifically.

---

## 1. How execution flows

**Execution is the default state; interruptions are the rare exception.** A standing approval is standing authorization to keep executing the approved roadmap. Do not stop for routine confirmations ("Proceed?", "Continue?", "Go ahead?") or for routine engineering — bash, git, commits, pushes, branch ops, repo sync, verification scripts, tests, doc/manifest sync — that is simply the next step of approved work. Do them and report.

**Stop only when one of these genuinely occurs:**
1. an owner-level architectural decision,
2. a canonical contradiction,
3. a significant long-term architectural tradeoff,
4. an unexpected blocker that materially affects the project,
5. a potentially destructive or irreversible action outside the approved workflow.

When in doubt and the action is within the approved plan and reversible: proceed and report — do not ask.

**The capability is the unit of progress.** The roadmap is organized around approved business capabilities; a Change Request (SPEC) is one engineering step delivering one. When a capability is best delivered as several small SPECs, continue through them as one flow — do not treat each SPEC as a fresh decision point. Drive the capability to a coherent, verified completion.

---

## 2. Standing authorities (permanent)

These have been exercised through real implementation and are part of the permanent operating model — not a temporary mode.

- **Implementation-choice autonomy.** When several reasonable implementations exist inside an already-approved architectural direction, pick the strongest practical one and continue. Do not interrupt merely because two acceptable options exist. Local, low-risk, reversible, architecture-consistent decisions are yours to make.
- **Autonomous completion.** When a capability is fully implemented, verified, passes all required tests, satisfies its acceptance criteria, AND introduces no NEW architectural decision (the decision already lives in an approved ADR or prior owner decision), completing it is execution, not a separate gate: mark the CR `Complete`, sync manifest/docs, commit, and push without asking. A capability that introduces a *new* decision still needs owner sign-off (usually an ADR) BEFORE it is built.
- **Boy-scout improvement.** Leave the repository a little easier to understand, navigate, and resume than you found it — opportunistically, through the work at hand, never as a separate documentation project.

---

## 3. How decisions are made

**Governing meta-principle — Earn-It.** Optimize for engineering *confidence*, not process. Every step (and every artifact, document, and abstraction) must justify itself by measurably increasing confidence. If the same confidence is reachable with fewer steps or fewer files, prefer the simpler path. This guards against both governance bloat and documentation bloat.

**Classify each capability at the start (this keeps reviews light):**
- **Routine** — established pattern, no architectural impact (a guarded RPC reusing a proven pattern). Minimal ceremony: phase-fit → design review → implement → Review Gate (with inline Excellence check). No Design Challenge.
- **Significant** — introduces or materially changes a business capability or architectural boundary (new/changed aggregate, phase/domain boundary, finance/security/identity-sensitive, hard to reverse, ADR-adjacent). Adds the Design Challenge and a fuller Excellence pass.
- **Owner-Decision** — changes long-term architecture or governance, or introduces a meaningful irreversible tradeoff. Present options + recommendation, await owner approval, record an ADR.

**Workflow stages:**
1. **Phase-fit + Earn-It → classify tier.** ("Does this belong to the current phase, or am I solving a future problem?")
2. **Learn-Before-Designing** (major capabilities only — UI, AI, communications, reporting, automation, analytics, search, integrations): first study the strongest current industry implementations — why they work, why users prefer them, where they fail, recurring patterns, what to adopt vs deliberately avoid. Verify against up-to-date official sources. Goal: informed engineering, not imitation.
3. **Design Review** — canonical fit.
4. **Design Challenge** — *Significant only.* Objective: can we reasonably demonstrate the selected solution is the strongest practical solution among realistic alternatives? Adversarial sweep for what is MISSING or SIMPLER/BETTER (relationships, business concepts, catalog values, events, permissions, validations, integration points, hidden assumptions, simplification). Output = short findings list; a full written report only at phase/gate boundaries.
5. **Implement + prove** — clean `db reset`, behavioral tests, smoke-test, Database Audit (for schema work).
6. **Review Gate + Excellence Check** — the CR Review Gate PLUS five questions: (a) anything overlooked? (b) simpler equivalent? (c) unnecessary complexity introduced? (d) reusable business concept emerged? (e) negligible-cost future-debt avoidance? In-phase improvement → implement; future → record at its trigger.
7. **Complete** — autonomous per §2 when verified and no new decision; sync manifest/ADR; commit; push.
8. **Phase-transition checkpoint** — execute a whole roadmap phase capability-by-capability without stopping, then pause at phase end with a concise checkpoint: what was completed, findings, deferred items + triggers, architectural health, next phase, recommendation, any observation deserving owner attention. Then begin the next phase.

Governance is self-revising: if a step stops earning its confidence, propose simplifying it; if a missing practice would raise quality without materially slowing execution, propose adding it. Reconsider methodology only on concrete repository evidence, never on preference alone.

---

## 4. Where to look next (the boot sequence)

A fresh session bootstraps itself from the repository — conversation history is optional.

1. **This file** — how work is done (you are here).
2. **`_ORVION_CANONICAL/manifest.md`** — current phase, module, and Active Change Request. This is the live state.
3. **If `Active Change Request` is not `None`** — read that `changes/SPEC-*.md`; its own Minimum Reading List takes over from here.
4. **If it is `None`** — read `_ORVION_CANONICAL/32_execution_roadmap.md` for the current phase and its next capability.
5. **Task-specific canon only** — `_ORVION_CANONICAL/00`–`23` for business/domain rules, `24`–`33` for schema/database, `34`/`35` for the cross-cutting principle docs. Read only what the current task needs.
6. **Rationale, on demand** — `reports/` for the "why" behind a decision; `reports/architecture-decision-records.md` for active ADRs; `reports/future-backlog.md` for deferred work and its triggers.

Supporting references, pulled only when relevant: **`CR_LIFECYCLE.md`** (Change Request state machine and command vocabulary), **`PROJECT_CONTEXT.md`** (project identity, vision, boundaries, business context), **`CODING_STANDARDS.md`** (naming, SQL, API, security standards).

---

## 5. Guardrails

- **Protected resources** — do not modify `AGENTS.md`, `README.md`, or `_ORVION_CANONICAL/**` unless the current task explicitly authorizes it.
- **One task at a time; one implementation; one reviewer.** A completed task leaves the repository in a releasable state. No partial or placeholder implementations; no TODO comments unless requested.
- **Every task solves one business problem.** Prefer several small changes over one large change. When multiple valid choices exist, prefer the one that leaves the next Change Request easier to execute — less maintenance, less duplicated knowledge, less duplicated authority, less required context.
- **Git is the source of truth.** Never rewrite history. Always leave a clean working tree. Handoff happens through `changes/*.md` and the manifest's `Active Change Request` field — never through chat.
- **Recoverable at every stop.** The durable state is git history + `manifest.md` + the active Change Request's living artifact — never the conversation. Every commit leaves the repository in a recoverable state. Before any non-trivial pause — context limit, session or agent handoff, end of a work session, or any interruption, not only `Complete` or phase-end — commit finished work in atomic steps and make the manifest's `Active Change Request` and that CR's `Execution Log` reflect the true current step. Recovery is then a cold boot (README → this file → manifest → active CR), never a reconstruction. The only state git cannot recover is uncommitted work, so commit often.
- **No guessing.** Never invent APIs, tables, files, business rules, or requirements. When information is missing, stop and report it. Never redesign existing architecture unless explicitly instructed.

---

## 6. Multi-agent and tool files

`AGENTS.md` is the single source of truth for agent behavior; do not duplicate it into tool-specific files. `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`, and `.cursor/rules/` are thin pointers into the repository entry point and must stay that way. If instructions genuinely conflict and this file does not resolve them, stop and ask.

---

## 7. Maintaining this file

- English, Markdown, concise. This file is read at the start of every session — every line spends context budget, so keep it lean and imperative.
- It holds the operating model and the boot sequence only. Push mechanics into their owning file (Change Request mechanics → `CR_LIFECYCLE.md`; coding detail → `CODING_STANDARDS.md`; state → `manifest.md`) and point to them rather than restating them.
- Do not add project-specific business rules here; those belong in `PROJECT_CONTEXT.md` and `_ORVION_CANONICAL/`.
