# AGENTS.md — ORVION Operating Model

This file is the **execution brain** for any engineering session in this repository — human or AI, any tool. It follows the cross-tool `AGENTS.md` convention (a README for agents). Read it once at the start of a session; it tells you how work is done here and where to look next. It is written to be lean on purpose: detail lives in the files it points to and is read only when the current state calls for it.

**Precedence.** A live instruction from the owner overrides this file. Otherwise this file is the authoritative operating model: where it and any older document (`PROTOCOL.md`, `global-rules.md`, or prose in `_ORVION_CANONICAL/`) appear to conflict, this file wins. `CR_LIFECYCLE.md` is authoritative for the Change Request state machine specifically.

---

## 1. How execution flows

**Execution is the default state; interruptions are the rare exception.** A standing approval is standing authorization to keep executing the approved roadmap. Do not stop for routine confirmations ("Proceed?", "Continue?", "Go ahead?") or for routine engineering — bash, git, commits, pushes, branch ops, repo sync, verification scripts, tests, doc/manifest sync — that is simply the next step of approved work. Do them and report.

**A checkpoint is not a pause.** Synchronizing the repository and reporting a short status at a completed capability is a *checkpoint* — it always happens and never stops execution. A *pause* — halting to await the owner — happens only when one of the five conditions below genuinely occurs. When a capability is Complete, verified, synchronized, committed, and no such condition holds, continue directly to the next dependency-ready capability; never append a routine confirmation ("Say the word", "Let me know", "Shall I continue?") — that is the pause §1 forbids, wearing checkpoint's clothes.

**Stop only when one of these genuinely occurs:**
1. an owner-level architectural decision,
2. a canonical contradiction,
3. a significant long-term architectural tradeoff,
4. an unexpected blocker that materially affects the project,
5. a potentially destructive or irreversible action outside the approved workflow.

A decision that follows from an already-approved ADR, a canonical rule, or a prior owner decision is **implementation, not escalation** — choose the strongest option the canon, ADRs, repository state, and current evidence support, and continue; escalation is reserved for a genuinely *new* direction, never for applying one already approved. When in doubt and the action is within the approved plan and reversible: proceed and report — do not ask.

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
2. **Research when it materially helps (Learn-Before-Designing).** Use current external evidence as a lightweight Design Review tool whenever it would measurably improve a decision — validating a current best practice, evolving external-platform behaviour, an official spec, or an assumption before implementation. Scale it to the decision: a quick check for a routine choice touching a fast-moving external surface; for a *major* capability (UI, AI, communications, reporting, automation, analytics, search, integrations), a fuller study of the strongest current implementations — why they work, why users prefer them, where they fail, what to adopt vs deliberately avoid. Verify against up-to-date official sources (the ecosystem moves fast). When a fast-moving surface is in play — SDKs, APIs, AI tooling, cloud/infrastructure, external-platform behaviour — **prefer verifying current official information over relying on historical/stored knowledge**, because stored knowledge goes stale silently and a wrong assumption there is expensive. Goal: strengthen engineering judgment with evidence, not replace it — and not research every task.
3. **Design Review** — gather the minimum context, then confirm canonical fit: read *only* the relevant canonical docs and the *required* schema/migrations for this capability, and look for an existing precedent (an RPC or pattern already in the repo) to reuse rather than re-invent. Minimal, precedent-first reading is what keeps a capability both correct and cheap.
4. **Design Challenge** — *Significant only.* Objective: can we reasonably demonstrate the selected solution is the strongest practical solution among realistic alternatives? Adversarial sweep for what is MISSING or SIMPLER/BETTER (relationships, business concepts, catalog values, events, permissions, validations, integration points, hidden assumptions, simplification). Output = short findings list resolving to one of three engineering outcomes — reject, improve, or confirm the approach — then implement; a question to the owner is *not* an outcome, and is warranted only if the sweep surfaces a genuine architectural conflict (a stop condition). A full written report only at phase/gate boundaries.
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

Supporting references, pulled only when relevant: **`GOVERNANCE.md`** (knowledge/decision operating system — where every fact lives (SSOT map), the decision/report lifecycles, and where agents may/may not write), **`CR_LIFECYCLE.md`** (Change Request state machine and command vocabulary), **`PROJECT_CONTEXT.md`** (project identity, vision, boundaries, business context), **`CODING_STANDARDS.md`** (naming, SQL, API, security standards).

---

## 5. Build and verify

Local stack is Supabase (Postgres 17) via the CLI; the database container is `supabase_db_ORVION` (from `supabase/config.toml` `project_id`). Application logic is SQL migrations + `app`-schema RPCs in `supabase/migrations/` (filename `2026MMDDHHMM_<name>.sql`, applied in order).

- **Apply migrations:** `npx supabase start` (once), then `npx supabase db reset` applies every migration on a clean database.
- **Smoke-test (must pass):** `docker exec -i supabase_db_ORVION psql -U postgres -d postgres -f - < scripts/verify_database.sql` → prints `ALL CHECKS PASSED` (currently 71 tables); a non-zero exit is a regression.
- **Behavioral test:** exercise the new RPC through `docker exec -i supabase_db_ORVION psql -U postgres -d postgres`, confirming both the allowed and the blocked paths.
- **CI:** `.github/workflows/migration-ci.yml` re-runs `supabase db reset` on every push/PR.

RPC conventions (match existing migrations, e.g. `202607045700_advance_booking_item.sql`): `security invoker`; `set search_path = ''`; resolve tenant via `app.current_tenant_id()`; gate with `app.authorize('<PERMISSION>')`; emit business events via `app.record_event(...)`; `grant execute ... to authenticated`.

## 6. Guardrails

- **Protected resources** — do not modify `AGENTS.md`, `README.md`, or `_ORVION_CANONICAL/**` unless the current task explicitly authorizes it.
- **One task at a time; one implementation; one reviewer.** A completed task leaves the repository in a releasable state. No partial or placeholder implementations; no TODO comments unless requested.
- **Every task solves one business problem.** Prefer several small changes over one large change. When multiple valid choices exist, prefer the one that leaves the next Change Request easier to execute — less maintenance, less duplicated knowledge, less duplicated authority, less required context.
- **Git is the source of truth.** Never rewrite history. Always leave a clean working tree. Handoff happens through `changes/*.md` and the manifest's `Active Change Request` field — never through chat.
- **Recoverable at every meaningful checkpoint.** Durability is defined around engineering checkpoints, not a timer: each meaningful step — a verified migration, a completed CR Implementation Step, a synchronized doc, a phase transition — becomes durable the moment it is reached. A commit is the mechanism; git history + `manifest.md` + the active Change Request's living artifact are the only durable state — never the conversation. At each checkpoint ask: *if execution stopped permanently right now, could a completely fresh session continue from the repository alone?* If not, make it so before continuing — commit the finished step atomically and update the manifest's `Active Change Request` and the CR's `Execution Log` to the true current state. Recovery is then a cold boot (README → this file → manifest → active CR), never a reconstruction. Git cannot recover uncommitted work, so checkpoint at each meaningful step, not only at `Complete` or phase-end. External `.claude` memory is a cache only: never let an operational fact live solely there — if it matters for continuity, it lives in the repository.
- **No guessing.** Never invent APIs, tables, files, business rules, or requirements. When information is missing, stop and report it. Never redesign existing architecture unless explicitly instructed.

---

## 7. Multi-agent and tool files

`AGENTS.md` is the single source of truth for agent behavior; do not duplicate it into tool-specific files. `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`, and `.cursor/rules/` are thin pointers into the repository entry point and must stay that way. If instructions genuinely conflict and this file does not resolve them, stop and ask.

---

## 8. Maintaining this file

- English, Markdown, concise. This file is read at the start of every session — every line spends context budget, so keep it lean and imperative.
- It holds the operating model and the boot sequence only. Push mechanics into their owning file (Change Request mechanics → `CR_LIFECYCLE.md`; coding detail → `CODING_STANDARDS.md`; state → `manifest.md`) and point to them rather than restating them.
- Do not add project-specific business rules here; those belong in `PROJECT_CONTEXT.md` and `_ORVION_CANONICAL/`.
