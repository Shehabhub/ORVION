# ORVION GOVERNANCE — Knowledge & Decision Operating System

Status: **Authoritative governance operating system for the knowledge/decision/reports layer.** This document governs *how ORVION knows things and decides things* — where truth lives, how a decision travels from idea to canon, how documents evolve, and how drift is prevented. It is the single entry point for any engineer or AI agent asking "where does this belong / who is authoritative / how do I record this?"

**Precedence & scope boundary (no overlap):** `AGENTS.md` is authoritative for **execution conduct** (how work is done, when to continue/stop, standing authorities). This document is authoritative for **knowledge governance** (where information lives and how decisions/documents flow). Where the two touch, AGENTS.md governs conduct and GOVERNANCE.md governs knowledge placement. Neither restates the other. `CR_LIFECYCLE.md` remains authoritative for the Change Request state machine.

Version 1.1 · 2026-07-11 · Governs every future human, Claude, Codex, and AI/MCP session.

**Governance changelog** (governance governs itself — §15):
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
FINDINGS          Accepted architectural gaps & plans               → reports/MASTER_*.md
   ↓
EVIDENCE          Proof, validation, citations                      → reports/{PROOF_LOG,VALIDATED,PENDING,REJECTED,INDUSTRY_REFERENCES}
   ↓
HISTORY           Dated review/session reports (immutable)          → reports/*-YYYY-MM* , phase-* , process reports
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
| Coding / SQL / API / security standards | `CODING_STANDARDS.md` | ADRs, canon |
| Business & domain rules | `_ORVION_CANONICAL/00–23` | reports (rationale only) |
| Schema **intent** (planned) | `_ORVION_CANONICAL/24–33` | MASTER_DOMAIN_CATALOG (indexes it) |
| Schema **truth** (as-built) | `supabase/migrations/**` | canon 24–33 describe intent; migrations are ground truth |
| Cross-cutting principles (auth, tenancy) | `_ORVION_CANONICAL/34, 35` | ADRs reference |
| Live state (phase/module/active CR) | `_ORVION_CANONICAL/manifest.md` | never duplicated |
| Roadmap **phases** | `_ORVION_CANONICAL/32` | MASTER_EXECUTION_PLAN references phases, does not restate them |
| **Ratified** architectural decisions | `reports/architecture-decision-records.md` | MASTER_ARCHITECTURE_DECISIONS (tracking overlay only) |
| **Proposed/pending** decisions | `reports/MASTER_ARCHITECTURE_DECISIONS.md §B` + VALIDATED/PENDING | — |
| Accepted architectural findings/gaps | `reports/MASTER_GAP_REGISTER.md` | ALL other Masters reference finding **IDs**, never restate the finding |
| Finding evidence trail (9 stages) | `reports/ARCHITECTURE_PROOF_LOG.md` | — |
| Finding lifecycle stage detail | `reports/{VALIDATED,PENDING,REJECTED}_ARCHITECTURE_DECISIONS.md` | register row shows the current status |
| External citations | `reports/INDUSTRY_REFERENCES.md` | every evidence-based finding cites a ref-id |
| Risk | `reports/MASTER_RISK_REGISTER.md` | references finding IDs |
| Certification state | `reports/MASTER_CERTIFICATION_STATUS.md` | — |
| Execution batches/sequencing | `reports/MASTER_EXECUTION_PLAN.md` | references register IDs + roadmap phases |
| Finding dependencies | `reports/MASTER_DEPENDENCY_GRAPH.md` | — |
| Design completion scores | `reports/MASTER_COVERAGE_SCORE.md` | references register IDs |
| Domain blueprint (catalog/ER/flow) | `reports/MASTER_{DOMAIN_CATALOG,ENTITY_RELATIONSHIP_MAP,DATA_FLOW}.md` | reference canon + physical-design |
| Deferred backlog + triggers | `reports/future-backlog.md` | — |
| Repository file index | `repository-index.md` (auto-generated) | **do not hand-edit** |
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
| `_ORVION_CANONICAL/**` | business + schema canon | Living (protected) | domain/schema intent, principles | owner-authorized CRs |
| `manifest.md` | live state | Living | current phase/CR | every CR |
| `reports/architecture-decision-records.md` | ratified ADRs | Living | ratified decisions | on owner ratification |
| `reports/MASTER_*.md` (12) | findings/plan/blueprint | Living | see §2 rows | every review |
| `reports/{VALIDATED,PENDING,REJECTED}_*.md`, `INDUSTRY_REFERENCES.md`, `ARCHITECTURE_PROOF_LOG.md` | decision evidence | Living | finding lifecycle + evidence | every validation |
| `reports/future-backlog.md` | deferred + triggers | Living | deferred work | reviews |
| `reports/*-2026-07*`, `phase-*`, process reports | historical analysis | **Immutable** | the record of that session | never |
| `repository-index.md` | file index | Auto-gen | file listing | `scripts/repository-all.ps1` |

**Redundancy resolved (was drift risk):** `MASTER_ARCHITECTURE_DECISIONS.md` overlapped the ADR log → it is now explicitly a **tracking overlay** (proposed + amendment status only), not a second decision record. `MASTER_EXECUTION_PLAN.md` overlapped canon-32 → it owns finding-**batches** and references roadmap **phases**, never restating them. `PROTOCOL.md`/`global-rules.md` overlapped AGENTS.md → both already declare deference; retained as subordinate, authoritative for nothing exclusive.

---

## 6. Drift-prevention rules (make divergence impossible)

1. **One SSOT per fact (§2).** Never type a fact into a second file — reference it.
2. **IDs, not restatements.** Findings are referenced by register ID (DC-*, R-*, BF-*, …) everywhere except their SSOT row.
3. **Living updates + immutable history.** Change conclusions by updating the LIVING doc and writing a NEW dated report; never edit an old one.
4. **Auto-generated files are never hand-edited** (`repository-index.md`).
5. **Memory is a cache.** An operational fact must exist in the repo; memory may point to it, never replace it.
6. **Every review runs the Master Knowledge Loop** (merge → dedup → resolve contradictions → update Masters → verify nothing forgotten → write dated report). No isolated reports.
7. **Governance validation (automatable, §11):** a check that (a) every report has a class header, (b) no finding ID appears with conflicting status across Masters, (c) cross-reference links resolve.

---

## 7. Reports organization

The full classification and index live in **`reports/README.md`** (self-explanatory folder). Summary: 3 classes — Living-Authoritative (Masters + evidence + ADR log + backlog), Historical-Immutable (dated review/phase/process reports), and the entry index. Physical subfoldering (`reports/master/`, `/evidence/`, `/history/`) is **proposed** in §10 as an owner-approved migration (it moves paths other docs reference) — the index in `reports/README.md` delivers self-explanation now without that risk.

---

## 8. Future AI-agent governance guide (read this, then act)

Any Claude/Codex/Gemini/Cursor/Aider/MCP session:
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

**Proposal (owner-approved migration, §12 tooling required to keep links intact):**
- `reports/` → `reports/master/` (Living Masters), `reports/evidence/` (validation set), `reports/history/` (immutable dated + phase + process), keeping `reports/README.md` + `architecture-decision-records.md` + `future-backlog.md` at top. **Deferred to a migration CR** because moving files breaks cross-references in Masters, memory, AGENTS, and scripts — must be done atomically with a link-update pass. Not done unilaterally.
- Root stays as-is; add a one-line pointer to `GOVERNANCE.md` in `AGENTS.md §4` and `README.md` (owner-authorized, since both are protected).

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
| 1 | Adopt `GOVERNANCE.md` as the knowledge SSOT (this file) | no (additive) | none |
| 2 | Add `reports/README.md` index (done with this review) | no (additive) | none |
| 3 | One-line pointer to GOVERNANCE.md in `AGENTS.md §4` + `README.md` | **yes** (protected) | trivial |
| 4 | Reconcile the two resolved redundancies (§5) — annotate MASTER_ARCHITECTURE_DECISIONS as overlay, MASTER_EXECUTION_PLAN as batches-not-phases | no | none (annotations added) |
| 5 | Physical `reports/` subfoldering + link-update pass | **yes** (migration CR + tooling) | medium (cross-refs) — do atomically |
| 6 | Governance-lint hook + repository-all.ps1 extension | **yes** (config/CI) | low |
| 7 | Optionally retire `PROTOCOL.md`/`global-rules.md` into GOVERNANCE/AGENTS if the owner wants fewer conduct files | **yes** | low — currently harmless (subordinate) |

Steps 1–2 and 4 are done by this review. 3, 5–7 await owner approval (protected files / config / CI).

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

Governance effectiveness is **measured, not asserted** — the current-practice "fitness function" approach. The dashboard + drift-detection indicators live in `reports/MASTER_REPOSITORY_HEALTH.md` (Living SSOT for repo health), regenerated each review and (target) by the governance-lint automation (§11). If a health indicator regresses (e.g., a duplicate finding ID, a broken reference, a stale doc), that is a governance defect to fix, not tolerate.

## 14. Final governance certification

**CERTIFIED — governance is complete, non-conflicting, and drift-resistant, conditional on migration steps 3, 5–7.** Evidence:
- **One hierarchy** (§1); **one SSOT per fact** (§2) with the two real redundancies resolved (§5).
- **Permanent decision, knowledge, and document lifecycles** (§3–4) — no longer living only inside review reports.
- **Drift-prevention rules** (§6) make divergence a rule violation, not an accident; automatable (§11).
- **Self-explanatory reports** (§7 + `reports/README.md`); **AI-agent guide** (§8); **<1-hour human onboarding** (§9).
- **No conflict found** among conduct docs — precedence already self-declared; retained as subordinate.

**Residual (owner-gated):** the pointer into AGENTS.md/README (step 3), the physical reports reorg (step 5), and governance automation (step 6). None blocks operation; all are additive. Until step 5, the `reports/README.md` index provides the self-explanation.

*This governance system is designed to operate for years across many engineers and AI agents without knowledge loss, duplication, or drift. Challenge it in any future governance review exactly as rigorously as the architecture was challenged.*
