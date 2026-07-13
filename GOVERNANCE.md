# ORVION GOVERNANCE — Knowledge & Decision Operating System

Status: **Authoritative governance operating system for the knowledge/decision/reports layer.** This document governs *how ORVION knows things and decides things* — where truth lives, how a decision travels from idea to canon, how documents evolve, and how drift is prevented. It is the single entry point for any engineer or AI agent asking "where does this belong / who is authoritative / how do I record this?"

**Precedence & scope boundary (no overlap):** `AGENTS.md` is authoritative for **execution conduct** (how work is done, when to continue/stop, standing authorities). This document is authoritative for **knowledge governance** (where information lives and how decisions/documents flow). Where the two touch, AGENTS.md governs conduct and GOVERNANCE.md governs knowledge placement. Neither restates the other. `CR_LIFECYCLE.md` remains authoritative for the Change Request state machine.

Version 1.5 · 2026-07-13 · Governs every future human, Claude, Codex, and AI/MCP session.

**Governance changelog** (governance governs itself — §15):
- v1.5 (2026-07-13) — added the §18 **Retention Earn-It** clause (Earn-It is also a retention test, not only an adoption gate; existing artifacts are re-challenged at review cadences that already exist — no new review event). Owner-ratified. No SSOT reassignment. Confirmed idea "every memory needs a repo SSOT" already fully owned by §2/§6.5/AGENTS §6 — no addition made (would duplicate).
- v1.4 (2026-07-11) — extended §18 with the discovery-to-guard loop (implementation is the review; every fix lands a permanent guard) and an evolution-on-evidence pointer to §15/§11/AGENTS§3.2. Rejected 4 proposed duplicate rules (already owned). Owner-ratified.
- v1.3 (2026-07-11) — added §18 Repository maintenance mode & lifecycle (Maintenance Mode + Implement→Sync→Earn-It→Continue lifecycle + structural Earn-It gate; references AGENTS §3, restates nothing). Owner-ratified. No SSOT reassignment.
- v1.2 (2026-07-11) — added §6.8 one-authority consolidation rule (every governance rule lives here; conduct stays in AGENTS per §5). Owner-ratified. No SSOT reassignment.
- v1.1 (2026-07-11) — added §15 governance-change lifecycle, §16 SaaS portability layer, §17 repository-health pointer. No SSOT reassignment.
- v1.0 (2026-07-11) — initial governance operating system (hierarchy, SSOT matrix, decision/knowledge/document lifecycles, registry, drift rules, AI/human onboarding, migration).

---

## 1. Governance hierarchy (the layered model)

```
POLICY            Owner decisions · standing authorities            → AGENTS.md §2, owner directives
   ↓
GOVERNANCE        How knowledge & decisions work (this file)        → GOVERNANCE.md
   ↓
CONDUCT           How execution is performed                        → AGENTS.md · CR_LIFECYCLE.md · CODING_STANDARDS.md
   ↓
DECISIONS         Ratified architecture decisions                   → reports/architecture-decision-records.md (ADR log)
   ↓
CANON             Business rules, schema intent, principles         → _ORVION_CANONICAL/**
   ↓
STATE             Live phase / module / active CR                   → _ORVION_CANONICAL/manifest.md
   ↓
EXECUTION         The change being made                             → changes/SPEC-*.md  (built truth → supabase/migrations/**)
   ↓
FINDINGS          Accepted architectural gaps & plans               → reports/master/MASTER_*.md
   ↓
EVIDENCE          Proof, validation, citations                      → reports/evidence/{PROOF_LOG,VALIDATED,PENDING,REJECTED,INDUSTRY_REFERENCES}
   ↓
HISTORY           Dated review/session reports (immutable)          → reports/history/*-YYYY-MM* , phase-* , process reports
```
Read top-down to answer "what am I allowed to do?"; read a specific layer to answer "where does this fact live?".

---

## 2. Single Source of Truth (SSOT) matrix — the core rule

**Every fact has exactly one authoritative home. Every other mention must reference it by pointer, never restate it.** If you would type the same fact into a second file, stop — link instead.

| Information category | SSOT (authoritative — edit here) | May reference (must NOT restate) |
|---|---|---|
| Execution conduct / operating model | `AGENTS.md` | PROTOCOL.md, global-rules.md, CLAUDE/GEMINI/.cursor/.github (thin pointers) |
| Change Request state machine | `CR_LIFECYCLE.md` | AGENTS.md (points to it) |
| Boot sequence / reading order | `README.md` + `AGENTS.md §4` | this file |
| Workstation rebuild (tools/extensions/MCPs/plugins) | `.workstation/manifest.md` (what + why) + `.workstation/prepare.ps1` (how) | `WORKSTATION.md` (thin entry, points here), README |
| Coding / SQL / API / security standards | `CODING_STANDARDS.md` | ADRs, canon |
| Business & domain rules | `_ORVION_CANONICAL/00–23` | reports (rationale only) |
| Schema **intent** (planned) | `_ORVION_CANONICAL/24–33` | MASTER_DOMAIN_CATALOG (indexes it) |
| Schema **truth** (as-built) | `supabase/migrations/**` | canon 24–33 describe intent; migrations are ground truth |
| Cross-cutting principles (auth, tenancy) | `_ORVION_CANONICAL/34, 35` | ADRs reference |
| Live state (phase/module/active CR) | `_ORVION_CANONICAL/manifest.md` | never duplicated |
| Roadmap **phases** | `_ORVION_CANONICAL/32` | MASTER_EXECUTION_PLAN references phases, does not restate them |
| **Ratified** architectural decisions | `reports/architecture-decision-records.md` | MASTER_ARCHITECTURE_DECISIONS (tracking overlay only) |
| **Proposed/pending** decisions | `reports/master/MASTER_ARCHITECTURE_DECISIONS.md §B` + evidence/VALIDATED/PENDING | — |
| Accepted architectural findings/gaps | `reports/master/MASTER_GAP_REGISTER.md` | ALL other Masters reference finding **IDs**, never restate the finding |
| Finding evidence trail (9 stages) | `reports/evidence/ARCHITECTURE_PROOF_LOG.md` | — |
| Finding lifecycle stage detail | `reports/evidence/{VALIDATED,PENDING,REJECTED}_ARCHITECTURE_DECISIONS.md` | register row shows the current status |
| External citations | `reports/evidence/INDUSTRY_REFERENCES.md` | every evidence-based finding cites a ref-id |
| Risk | `reports/master/MASTER_RISK_REGISTER.md` | references finding IDs |
| Certification state | `reports/master/MASTER_CERTIFICATION_STATUS.md` | — |
| Execution batches/sequencing | `reports/master/MASTER_EXECUTION_PLAN.md` | references register IDs + roadmap phases |
| Finding dependencies | `reports/master/MASTER_DEPENDENCY_GRAPH.md` | — |
| Design completion scores | `reports/master/MASTER_COVERAGE_SCORE.md` | references register IDs |
| Domain blueprint (catalog/ER/flow) | `reports/master/MASTER_{DOMAIN_CATALOG,ENTITY_RELATIONSHIP_MAP,DATA_FLOW}.md` | reference canon + physical-design |
| Deferred backlog + triggers | `reports/future-backlog.md` | — |
| Repository file index | `repository-index.md` (auto-generated) | **do not hand-edit** |
| AI cold-start map (machine-readable) | `ai-map.json` (auto-generated from the SSOTs it points to) | **do not hand-edit** — regenerate via `scripts/generate-ai-map.ps1`; restates nothing, only points |
| AI memory | `.claude/**/memory/**` | **cache only** — never the sole home of an operational fact (AGENTS §6) |
| Historical "why" (analysis) | dated reports in `reports/` | **immutable once written** |

**Drift is defined as any fact appearing authoritatively in two places.** §6 makes it impossible.

**Reports physical layout (reorganized 2026-07-11):** `reports/master/` (Living Masters), `reports/evidence/` (validation trail), `reports/history/` (immutable dated/phase/process reports); `README.md`, `architecture-decision-records.md`, `future-backlog.md` stay at `reports/` root. **Convention:** cite any report by its **unique filename** (folder is organizational) — so references survive future moves. Index: `reports/README.md`.

---

## 3. Architectural Decision Lifecycle (permanent standard)

Every architectural decision follows this pipeline **forever** — not just in review sessions. Each stage has one home:

```
IDEA → DISCOVERY → EVIDENCE → COUNTER-PROOF → PENDING → VALIDATED → OWNER APPROVAL → CANON/ADR → IMPLEMENTATION → VERIFICATION → DEPRECATED → ARCHIVED
```
| Stage | Where it is recorded | Gate to advance |
|---|---|---|
| Idea | a dated review report | described only |
| Discovery | dated review report | stated as hypothesis |
| Evidence (S2) | `ARCHITECTURE_PROOF_LOG.md` | repo/schema/migration/ADR/report evidence collected |
| External validation (S3) | `INDUSTRY_REFERENCES.md` | official/industry source cited |
| Counter-proof (S4) | PROOF_LOG; if killed → `REJECTED_ARCHITECTURE_DECISIONS.md` | actively attempted to disprove |
| Pending | `PENDING_ARCHITECTURE_FINDINGS.md` | failed a stage; trigger recorded |
| Validated | `VALIDATED_ARCHITECTURE_DECISIONS.md` + row in `MASTER_GAP_REGISTER.md` | passed all 9 stages; confidence ≥70% |
| Owner approval | `architecture-decision-records.md` (new ADR) | owner ratifies |
| Canon | `_ORVION_CANONICAL/**` updated | ADR integrated |
| Implementation | `changes/SPEC-*.md` | CR_LIFECYCLE |
| Verification | CR Review Gate + `verify`/pgTAP | acceptance criteria met |
| Deprecated | ADR marked `Superseded` (pointer to replacement) | never deleted |
| Archived | remains in `reports/` (immutable) | history preserved |

**Rule:** a finding may not enter `MASTER_GAP_REGISTER.md` until it reaches *Validated*. Anything earlier lives in PENDING. Nothing skips owner approval to reach canon.

---

## 4. Knowledge & Document lifecycle

Three document classes — each with a fixed rule:

| Class | Rule | Examples |
|---|---|---|
| **LIVING-AUTHORITATIVE** | evolve in place; never recreate; one SSOT per fact | all `MASTER_*.md`, the 5 evidence reports, `architecture-decision-records.md`, `future-backlog.md`, canon, manifest |
| **HISTORICAL-IMMUTABLE** | never edit after the session that wrote it; it is a dated record of what was thought then | `*-2026-07*` review reports, `phase-*` reports, process reports |
| **AUTO-GENERATED** | never hand-edit; regenerated by a script | `repository-index.md` |

When a review changes a conclusion, it **updates the LIVING doc** and **writes a new dated HISTORICAL report** — it never edits an old historical report. This is how "nothing is lost" and "nothing drifts" hold simultaneously.

---

## 5. Governance document registry

| Document | Purpose | Class | Authoritative for | Updated by |
|---|---|---|---|---|
| `GOVERNANCE.md` (this) | knowledge/decision OS | Living | §2 SSOT, lifecycles | governance review |
| `AGENTS.md` | execution operating model | Living (protected) | conduct, boot, authorities | owner-authorized only |
| `README.md` | entry point / reading order | Living (protected) | boot sequence | owner-authorized only |
| `PROTOCOL.md` | **RETIRED** → tombstone pointer (session 10) | Historical | nothing — content owned by AGENTS/GOVERNANCE | frozen |
| `global-rules.md` | **RETIRED** → tombstone pointer (session 10) | Historical | nothing — content owned by AGENTS §6 | frozen |
| `CR_LIFECYCLE.md` | CR state machine | Living | CR states/transitions/vocabulary | owner-authorized |
| `CODING_STANDARDS.md` | code/SQL/API/security standards | Living | standards | as standards evolve |
| `PROJECT_CONTEXT.md` | identity/vision/boundaries | Living | product identity | owner |
| `CLAUDE/GEMINI/.cursor/.github` | tool pointers | Living | nothing — thin pointers to AGENTS | keep thin |
| `WORKSTATION.md` | engineering-environment rebuild entry | Living | how to rebuild the workstation (points to `.workstation/`) | when env reproducibility changes |
| `.workstation/manifest.md` | SSOT of tools/extensions/MCPs/plugins + Earn-It rationale | Living | what the workstation contains | when a tool earns/loses its place |
| `.workstation/*.ps1` | recover (`prepare`) · verify (`doctor`) · `update` · `cleanup` · `decommission` | Living | reproducible environment scripts (the real logic) | with the manifest |
| `bootstrap.ps1` (root) | remote pre-clone bootstrap (`irm … | iex`) | Living | nothing — ensures git, clones repo, hands off to `.workstation/prepare.ps1` | keep minimal (no setup logic) |
| `workstation.cmd` (root) → `.workstation/menu.ps1` | Recovery & Maintenance launcher (recovery-first) | Living | nothing — thin pass-through invoking `.workstation/*.ps1` | keep thin (no logic) |
| `_ORVION_CANONICAL/**` | business + schema canon | Living (protected) | domain/schema intent, principles | owner-authorized CRs |
| `manifest.md` | live state | Living | current phase/CR | every CR |
| `reports/architecture-decision-records.md` | ratified ADRs | Living | ratified decisions | on owner ratification |
| `reports/master/MASTER_*.md` (13 incl. MASTER_REPOSITORY_HEALTH) | findings/plan/blueprint/health | Living | see §2 rows | every review |
| `reports/evidence/{VALIDATED,PENDING,REJECTED}_*.md`, `INDUSTRY_REFERENCES.md`, `ARCHITECTURE_PROOF_LOG.md` | decision evidence | Living | finding lifecycle + evidence | every validation |
| `reports/future-backlog.md` | deferred + triggers | Living | deferred work | reviews |
| `reports/history/*-2026-07*`, `phase-*`, process reports | historical analysis | **Immutable** | the record of that session | never |
| `repository-index.md` | file index | Auto-gen | file listing | `scripts/repository-all.ps1` |
| `ai-map.json` | machine-readable AI cold-start map (pointers + extracted live-state) | Auto-gen | nothing — points to SSOTs | `scripts/generate-ai-map.ps1` (called by `repository-all.ps1`) |

**Redundancy resolved (was drift risk):** `MASTER_ARCHITECTURE_DECISIONS.md` overlapped the ADR log → it is now explicitly a **tracking overlay** (proposed + amendment status only), not a second decision record. `MASTER_EXECUTION_PLAN.md` overlapped canon-32 → it owns finding-**batches** and references roadmap **phases**, never restating them. `PROTOCOL.md`/`global-rules.md` overlapped AGENTS.md → both already declare deference; retained as subordinate, authoritative for nothing exclusive.

---

## 6. Drift-prevention rules (make divergence impossible)

1. **One SSOT per fact (§2).** Never type a fact into a second file — reference it.
2. **IDs, not restatements.** Findings are referenced by register ID (DC-*, R-*, BF-*, …) everywhere except their SSOT row.
3. **Living updates + immutable history.** Change conclusions by updating the LIVING doc and writing a NEW dated report; never edit an old one.
4. **Auto-generated files are never hand-edited** (`repository-index.md`, `ai-map.json`).
5. **Memory is a cache.** An operational fact must exist in the repo; memory may point to it, never replace it.
6. **Every review runs the Master Knowledge Loop** (merge → dedup → resolve contradictions → update Masters → verify nothing forgotten → write dated report). No isolated reports.
7. **Governance validation (automatable, §11):** a check that (a) every report has a class header, (b) no finding ID appears with conflicting status across Masters, (c) cross-reference links resolve.
8. **One authority per concept — governance consolidates here.** Every *knowledge-governance* rule (where a fact lives, how a decision/document flows, how drift is prevented, reports taxonomy) lives in exactly one place: this file. If such a rule is found anywhere else — AGENTS, README, a report, a template, a script, a prompt, memory — move it here and replace the original with a pointer; never duplicate it. Boundary (§5): **execution-conduct** rules remain owned by `AGENTS.md` and are *not* moved here — GOVERNANCE points to them. The same one-authority/one-owner/one-lifecycle discipline applies to every repository concept: no file may become a second authority for something another file already owns.

---

## 7. Reports organization

The full classification and index live in **`reports/README.md`** (self-explanatory folder). Summary: 3 classes — Living-Authoritative (Masters + evidence + ADR log + backlog), Historical-Immutable (dated review/phase/process reports), and the entry index. Physical subfoldering (`reports/master/`, `/evidence/`, `/history/`) is **done** (session 9); references cite by unique filename (§2) so the move broke nothing.

---

## 8. Future AI-agent governance guide (read this, then act)

Any Claude/Codex/Gemini/Cursor/MCP session:
- **Where truth lives:** §2 SSOT matrix. Always edit the SSOT, never a copy.
- **How to record a discovery:** run the §3 lifecycle. New finding → PENDING first; only Validated findings enter `MASTER_GAP_REGISTER.md`; only owner-ratified decisions enter ADRs/canon.
- **Where you may write:** LIVING docs (Masters, evidence reports, backlog) + a NEW dated report per review. **Where you must NOT write:** any HISTORICAL-IMMUTABLE report; `repository-index.md`; protected resources (`AGENTS.md`, `README.md`, `_ORVION_CANONICAL/**`) without explicit owner authorization (AGENTS §6).
- **What is immutable:** dated reports, ratified ADRs (supersede, don't edit), the event/audit backbone.
- **What needs owner approval:** any new ADR, any canon change, any roadmap change, anything irreversible (AGENTS §1 stop-conditions).
- **How evidence works:** a finding is not "true" until it survives the 9-stage pipeline incl. counter-proof; cite `INDUSTRY_REFERENCES` for external claims.
- **Never rediscover governance:** it is here. Read README → AGENTS → GOVERNANCE → manifest → active CR.

---

## 9. Human onboarding path (<1 hour)

1. `README.md` (5 min) — what/why + reading order.
2. `AGENTS.md` (15 min) — how work is done, when to stop.
3. `GOVERNANCE.md` (this, 15 min) — where truth lives, how decisions flow.
4. `manifest.md` (2 min) — where we are now.
5. `reports/README.md` + `MASTER_CERTIFICATION_STATUS.md` (15 min) — platform completeness at a glance.
Total ≈ 52 min → a new senior engineer can navigate everything and knows exactly where to write.

---

## 10. Repository organization — assessment & proposal

**Assessment:** the repo already largely reflects governance (canon isolated, changes/ for CRs, reports/ for analysis, auto-index). Two weaknesses: (a) `reports/` is flat with 40 mixed-class files; (b) three subordinate conduct docs a newcomer must read to learn they're subordinate — solved by §5 registry + this file.

**Both proposals below are now DONE:**
- `reports/` → `reports/master/` (Living Masters), `reports/evidence/` (validation set), `reports/history/` (immutable dated + phase + process), keeping `reports/README.md` + `architecture-decision-records.md` + `future-backlog.md` at top. **Completed session 9.** Safe because references cite by unique filename (§2), not path.
- **Completed session 10:** one-line `GOVERNANCE.md` pointer added to `AGENTS.md §4`, `README.md`, and `llms.txt`.

---

## 11. Tooling & governance automation (evidence-based; not self-installed — modifies config/CI)

| Tool | Governance problem it solves | Priority | Install |
|---|---|---|---|
| **Governance-lint hook** (custom, in `scripts/` + Claude PostToolUse hook) | enforces: every report has a class header; no finding ID has conflicting status across Masters; `manifest.md Active CR` cleared after Complete | **High** | `settings.json` hook + a PS/py script; via `update-config` on approval |
| Extend `scripts/repository-all.ps1` | already auto-generates `repository-index.md`; extend to emit a `reports/README.md` manifest + validate SSOT class headers | High | edit existing script (owner-approved) |
| **Markdown link checker** (e.g. `lychee`) in CI | guarantees `[[ ]]`/cross-references resolve → prevents dangling SSOT pointers | Medium | CI step |
| **pgTAP** (DC-16) | tests are governance for schema invariants (RLS coverage, money scale) | Critical | test migration + CI |
| **Supabase/Postgres MCP** | lets any agent verify schema truth directly (SSOT = migrations) instead of `docker exec psql` | High | `.mcp.json` + secret |
| **squawk/sqlfluff** | migration-safety + convention lint (enforces CODING_STANDARDS as code) | High | CI |

I did not self-install any: all modify the user's Claude config or CI. Exact steps available; apply via the `update-config` skill on approval. App-facing tools (Playwright/Sentry/Stripe) remain future-gated (no app surface).

---

## 12. Governance migration plan (to reach the target state)

| Step | Action | Owner-gated? | Risk |
|---|---|---|---|
| 1 | Adopt `GOVERNANCE.md` as the knowledge SSOT (this file) | no (additive) | none | **DONE** |
| 2 | Add `reports/README.md` index | no (additive) | none | **DONE** |
| 3 | One-line pointer to GOVERNANCE.md in `AGENTS.md §4` + `README.md` + `llms.txt` | **yes** (protected) | trivial | **DONE** (session 10) |
| 4 | Reconcile the two resolved redundancies (§5) — annotate MASTER_ARCHITECTURE_DECISIONS as overlay, MASTER_EXECUTION_PLAN as batches-not-phases | no | none | **DONE** |
| 5 | Physical `reports/` subfoldering | **yes** (migration) | none — filename-cited refs | **DONE** (session 9) |
| 6 | Governance-lint hook + repository-all.ps1 extension | **yes** (config/CI) | low | **pending owner** |
| 7 | Retire `PROTOCOL.md`/`global-rules.md` to tombstone pointers | **yes** | low | **DONE** (session 10, full-diff verified) |

Only step 6 (governance automation — config/CI) awaits owner approval. Steps 1–5, 7 are complete.

---

## 13. Governance dependency graph

```
GOVERNANCE.md ──defines──▶ SSOT matrix ──governs──▶ every LIVING doc
AGENTS.md ──authorizes──▶ conduct ──drives──▶ CR_LIFECYCLE ──drives──▶ changes/SPEC-* ──update──▶ manifest
Decision lifecycle (§3) ──feeds──▶ MASTER_GAP_REGISTER (validated) ──feeds──▶ ADR log (ratified) ──feeds──▶ canon ──feeds──▶ implementation
INDUSTRY_REFERENCES + PROOF_LOG ──evidence──▶ VALIDATED/PENDING/REJECTED ──status──▶ MASTER_GAP_REGISTER
repository-index.md ◀──generates── scripts/repository-all.ps1
```
No cycle; one direction of authority (Policy→…→History). A change enters at the correct layer and flows down; it never flows up without owner ratification.

---

## 15. Governance-change lifecycle (governance governs itself)

Governance is a subsystem and evolves through a controlled lifecycle — never silently. A change to **this file, the SSOT matrix, any lifecycle, or the reports taxonomy** follows:

```
PROPOSE → EVIDENCE → RATIFY(owner) → VERSION-BUMP → CHANGELOG → MIGRATE → CERTIFY
```
- **Propose** — a dated governance report states the change + why (evidence, not preference).
- **Ratify** — owner approves (governance changes are owner-gated, like ADRs and canon).
- **Version-bump + Changelog** — increment the version header + add a changelog line (top of this file). SemVer-lite: MAJOR = SSOT reassignment or hierarchy change; MINOR = new section/lifecycle; PATCH = clarification.
- **Migrate** — if the change moves facts between docs, do it atomically with a link-update pass (never leave dangling pointers).
- **Certify** — §14 re-certified in the governance report.
- **Retire** — a superseded governance rule is struck through with a pointer to its replacement, never deleted (mirrors the ADR supersede convention — validated as current practice, Nygard/MADR).

**Governance compatibility:** a doc written under an older governance version stays valid; the changelog states what changed so a reader reconciles. No silent breaking changes.

## 16. SaaS portability layer (reuse across future products)

Governance artifacts are tagged **GENERIC** (portable to any SaaS repo — copy as-is) or **ORVION** (product-specific — do not copy). Nothing GENERIC may depend on ORVION content.

| Artifact | Tag | Portable because / ORVION because |
|---|---|---|
| `GOVERNANCE.md` (this OS: hierarchy, SSOT method, lifecycles, drift rules) | **GENERIC** | pure knowledge-governance; swap the SSOT *rows*, keep the *method* |
| `AGENTS.md` operating model (execution-is-default, tiering, stop-conditions) | **GENERIC** | conduct framework; ORVION examples are illustrative |
| `CR_LIFECYCLE.md`, `CODING_STANDARDS.md` (structure) | **GENERIC** (content partly ORVION) | the CR state machine + standards *shape* port; SQL specifics are ORVION |
| Reports taxonomy (🟢/🔵/🟠 classes, MASTER_* responsibilities, decision/knowledge/doc lifecycles) | **GENERIC** | the *shape* of the knowledge base is product-agnostic |
| Repository-health dashboard *shape* (§17) | **GENERIC** | metrics port; values are per-repo |
| `_ORVION_CANONICAL/**`, domain MASTER_* (catalog/ER/flow), travel findings | **ORVION** | business/domain — never copy to another product |
| `PROJECT_CONTEXT.md`, `future-backlog.md` | **ORVION** | product identity + deferred work |

**Reuse procedure for a new SaaS repo:** copy the GENERIC set → empty the SSOT matrix's product rows → start its own canon + Masters + ADR log under the same lifecycles. The **Engineering Operating System is the GENERIC set**; ORVION is one instance of it.

## 17. Repository health (measurable governance)

Governance effectiveness is **measured, not asserted** — the current-practice "fitness function" approach. The dashboard + drift-detection indicators live in `reports/master/MASTER_REPOSITORY_HEALTH.md` (Living SSOT for repo health), regenerated each review and (target) by the governance-lint automation (§11). If a health indicator regresses (e.g., a duplicate finding ID, a broken reference, a stale doc), that is a governance defect to fix, not tolerate.

## 18. Repository maintenance mode & lifecycle

The repository structure is **stable** (evidence: three consecutive engineering sessions produced only sync-level fixes — stale paths, counts, one script pointer — no structural redesign; all remaining structural items are owner-gated). Repository Engineering therefore operates in **Maintenance Mode**, permanently:

- Structural work is **reactive, not proactive** — the repository is changed only when repository evidence proves the change improves it. Repository *redesign* is no longer normal work; it requires new evidence, not preference.
- Maintenance is part of the **implementation lifecycle**, not a separate project. This prevents future large cleanup passes by keeping drift near zero continuously:

  ```
  Implement (a batch/capability) → Synchronize → Earn-It maintenance gate → Continue implementing
  ```

**Synchronization pass (lightweight — after each implementation batch; not a review).** Verify only: no stale references · no duplicate authority · no broken navigation · no inconsistent paths (§2 subfolders) · no doc referencing completed work as pending (or vice-versa) · no stale counts. Fix what is inside Repository Engineering authority immediately; classify the rest.

**Earn-It structural gate.** *Every* structural repository change must first pass the Earn-It rule (`AGENTS.md §3` — not restated here). A structural change is implemented only if it demonstrably: improves navigation · improves synchronization · reduces duplication · reduces maintenance · improves AI onboarding · improves human onboarding · reduces token consumption · preserves one authority per concept (§2). If any criterion cannot be shown, the change is **not** made.

**Discovery-to-guard loop (implementation is the review).** Implementation is the primary discovery mechanism; no separate review cycle is required to find gaps. When implementing a capability, run this loop:

```
Implement → Discover a gap (missing protection/test/reference/constraint/data/rule) → Prove it with repository evidence → Earn-It → Fix (if inside authority) → add the PERMANENT guard that prevents recurrence → Continue
```

The **permanent guard** is what distinguishes this from ad-hoc fixing: every fix that closes a class of defect also lands the invariant that keeps it closed — a pgTAP fitness function, a self-gating script, a CHECK/constraint, or seed. Precedent: SPEC-113/114 (pgTAP invariants), SPEC-115 (search_path invariant), SPEC-116 (self-gating smoke-test). Do not wait for the owner to request these; implementation exposes them. A gap whose fix crosses a protected boundary (Canon/ADR/Frozen-Baseline/schema/business/product) is classified and escalated, not implemented.

**Evolution on evidence (governance & environment are never frozen).** Governance, tooling, and engineering knowledge evolve when new evidence appears (implementation experience, repository evolution, better practice, new industry standards, new AI capability, new tooling). This is not a new rule — it is the standing behaviour, owned where it already lives: governance changes follow the **§15** lifecycle; tooling adoption follows **§11**; researching current best practice before a major decision follows **`AGENTS.md §3` step 2 (Learn-Before-Designing)**. The only addition here: re-evaluation is **periodic and evidence-triggered**, never assumed-complete — but a change is adopted only if it survives Earn-It, never because it is newer.

**Retention Earn-It (does this still earn its place?).** Earn-It is not only an *adoption* gate; it is also a *retention* test. At the review cadences that **already exist** — the phase-transition checkpoint (`AGENTS.md §3` step 8) and the Design-Drift/Synchronization pass — also challenge what already exists (governance rules, docs, tools, generated artifacts, automation, repository structure) with the inverse question: *does this still earn its place, or has it become bloat, duplication, or stale?* Whatever no longer earns it is simplified, merged, or retired **through the mechanism that already owns it** — governance rules via the §15 lifecycle (Retire, never silent-delete), tools via §11, docs/structure via the Earn-It structural gate above, generated artifacts by deletion. This adds **no new review event** — it is one extra question inside reviews that already happen, and it catches the slow accumulation a purely pre-adoption gate cannot. (Precedent: the 2026-07-13 pass removed a stale `future-backlog.md` MCP entry and flagged `ai-map.json` as provisional with a kill-criterion.)

## 14. Final governance certification

**CERTIFIED — governance is complete, non-conflicting, and drift-resistant.** Migration steps 1–5 and 7 are DONE; only governance automation (step 6, config/CI) remains owner-gated and does not block operation. Evidence:
- **One hierarchy** (§1); **one SSOT per fact** (§2) with the two real redundancies resolved (§5).
- **Permanent decision, knowledge, and document lifecycles** (§3–4) — no longer living only inside review reports.
- **Drift-prevention rules** (§6) make divergence a rule violation, not an accident; automatable (§11).
- **Self-explanatory reports** (§7 + `reports/README.md`); **AI-agent guide** (§8); **<1-hour human onboarding** (§9).
- **No conflict found** among conduct docs — precedence already self-declared; retained as subordinate.

**Residual (owner-gated):** governance automation (step 6 — governance-lint hook, link-checker, pgTAP) — the only remaining item; additive, blocks nothing. It would move the §17 drift indicators from best-effort (👁) to enforced (⚙).

*This governance system is designed to operate for years across many engineers and AI agents without knowledge loss, duplication, or drift. Challenge it in any future governance review exactly as rigorously as the architecture was challenged.*
