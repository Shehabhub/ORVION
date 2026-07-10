# ORVION Repository & Engineering Operating System Review (2026-07-11, session 6)

Status: **Repository-architecture review (analysis/planning only).** Historical-immutable. No file moved/created/deleted beyond this report + a Living health refresh. No protected file, canon, or roadmap changed. Phase 8 not started.

External validation this session: [agents.md standard](https://www.augmentcode.com/guides/how-to-build-agents-md), [AGENTS.md 150-line/inference-cost research](https://blog.buildbetter.ai/agents-md-complete-guide-for-engineering-teams-in-2026/), [llms.txt for agent readiness](https://auto-post.io/blog/publish-llms-txt-for-agent-readiness).

---

## 0. The honest headline (truth over consistency, as the mission demands)

**ORVION's repository is architecturally sound and, for AI-first setup, ahead of most engineering organizations. Its single biggest problem is not under-design — it is that six consecutive architecture/governance reviews have produced ~15 new documents and *zero* implementation since Phase 7.** No top engineering org (Google/Stripe/GitHub/Linear/Anthropic) would run six architecture reviews before writing the next migration. The review process has itself become the largest source of repository growth (this is review #6; `reports/` went 20→44 files this month).

**The highest-value next action is to STOP reviewing and START executing** — ratify the pending ADRs and run Batch 0. Further governance review now has negative marginal value. I say this as the top finding because a principled repository architect must, even when asked for more review.

Everything below is the requested review, delivered — but read §0 first.

---

## 1. Repository assessment vs. top engineering orgs (Task 2)

| Dimension | ORVION | Verdict vs Google/Stripe/GitHub/Supabase/Linear/Anthropic |
|---|---|---|
| AI-agent entry (`AGENTS.md`, 108 lines) | present, lean, industry-standard | ✅ **ahead** — most orgs adopted AGENTS.md only in 2025/26; ORVION's is within the 150-line budget |
| Per-tool config (CLAUDE/GEMINI 3-line pointers, .cursor, copilot-instructions) | thin pointers to AGENTS | ✅ correct anti-fragmentation pattern |
| Docs-as-code (markdown, in-repo, diffable) | yes | ✅ standard |
| ADR log (Nygard/MADR-aligned) | `architecture-decision-records.md`, 21 ADRs | ✅ standard |
| Governance OS (SSOT, lifecycles) | `GOVERNANCE.md` | ✅ **ahead** (most orgs lack an explicit knowledge-SSOT) |
| CI (migration CI, claude review) | `.github/workflows/*` (3) | ✅ present |
| Schema-as-migrations, single source | `supabase/migrations/` (71) | ✅ standard |
| **Docs-to-code ratio** | ~15 review docs, 0 Phase-8 code | ❌ **behind** — top orgs keep docs lean and close to code; primary artifact is code+tests, not analysis reports |
| **Folder scaling** (`changes/` 112, `reports/` 44 flat) | flat | ⚠ orgs foldier these by year/phase before this size |
| **Governance enforcement** | prose conventions | ⚠ orgs enforce via CI lint/fitness-functions, not prose |
| **Stray artifacts** (`backup/`, untracked) | present | ❌ `backup/` in a git repo is an anti-pattern |

**Conclusion:** the *structure* is what a top org would build; the *balance* (documentation-heavy, implementation-light, enforcement-by-prose) is not.

## 2. Root-file evaluation (Task 4) — per file

| File | Lines | Why it exists / owner | Verdict |
|---|---|---|---|
| `README.md` | 57 | human entry point | **Keep** (protected) |
| `AGENTS.md` | 108 | agent operating model (industry standard) | **Keep** — add 1-line GOVERNANCE pointer (owner-gated) |
| `GOVERNANCE.md` | 289 | knowledge/decision OS | **Keep** — reference-not-boot; watch size |
| `PROJECT_CONTEXT.md` | 147 | product identity/vision | **Keep** — read on demand |
| `CR_LIFECYCLE.md` | 111 | CR state machine (authoritative) | **Keep** |
| `CODING_STANDARDS.md` | 50 | standards | **Keep** |
| `CLAUDE.md` / `GEMINI.md` | 3 / 3 | thin tool pointers | **Keep** (correct pattern) |
| `repository-index.md` | 45 | auto-generated index | **Keep** (generated, never hand-edit) |
| `PROTOCOL.md` | 38 | collaboration principles; **self-declares deference to AGENTS** | **RETIRE-candidate** — owns nothing exclusive (§9) |
| `global-rules.md` | 88 | "AI rules"; generic ("correctness, maintainability…") | **RETIRE-candidate** — generic filler current research flags as harmful to agents; owns nothing exclusive |
| `opencode.json`, `.aider.conf.yml`, `package.json`, `.gitignore`, `.vscode/` | — | tool/build config | **Keep** (config) |
| `backup/` (untracked) | — | ad-hoc backup dir | **RETIRE** — anti-pattern; git is the backup → gitignore or remove |

## 3. MASTER-document evaluation (Task 5)
Each MASTER owns exactly one responsibility (verified in `governance-eos-consolidation §2`). No MASTER is oversized or a dumping ground. The only cluster (DOMAIN_CATALOG/ER_MAP/DATA_FLOW) is three justified views. `MASTER_REPOSITORY_HEALTH` (new) is the one that should stay auto-generated once tooling exists. **No MASTER should merge or retire.** Watch-item: if any MASTER exceeds ~400 lines, split by responsibility — none does today.

## 4. Proposed repository hierarchy (Task 6 — PROPOSAL, not executed)
```
/                     README, AGENTS, GOVERNANCE, CR_LIFECYCLE, CODING_STANDARDS, PROJECT_CONTEXT
                      (+ thin tool pointers CLAUDE/GEMINI; + proposed llms.txt)
/_ORVION_CANONICAL/   business + schema canon (unchanged)
/changes/            → /changes/YYYY/ or /changes/phase-N/  (112 flat files → foldered)
/reports/
   /master/          Living Masters (SSOT set)
   /evidence/        VALIDATED/PENDING/REJECTED/INDUSTRY_REFERENCES/PROOF_LOG
   /history/         dated review + phase + process reports (immutable)
   README.md, architecture-decision-records.md, future-backlog.md at reports/ root
/scripts/            automation (repository-all.ps1, verify_database.sql, …)
/supabase/           migrations + config
```
**Not executed** (mission: "do not move files yet"). Moving breaks cross-references in Masters/memory/scripts → owner-approved migration CR with an atomic link-update pass. The `reports/README.md` + `repository-index.md` deliver self-explanation now without the move.

## 5. Repository boot flow (Task 9) — per actor, unambiguous
| Actor | Boot sequence |
|---|---|
| **Human** | README → AGENTS → GOVERNANCE → manifest → `reports/README` + `MASTER_CERTIFICATION_STATUS` (`GOVERNANCE §9`, ~52 min) |
| **Claude / Codex / Cursor / Gemini / Copilot / any AGENTS.md-reader** | AGENTS.md (auto-read) → manifest → active CR or roadmap-32 → task-specific canon (`AGENTS §4`). *(All these tools read AGENTS.md per the 2026 standard.)* |
| **MCP / automation / CI** | `repository-index.md` (map) + the specific artifact; write only via CR/Masters per `GOVERNANCE §8` |
| **Governance boot** | GOVERNANCE.md §2 SSOT matrix — where to write anything |
| **Knowledge boot** | `reports/README` → the relevant MASTER |
**Gap:** AGENTS.md/README do not yet *point* to GOVERNANCE.md (protected files) → the one onboarding non-determinism. Fix = migration step (owner-gated).

## 6. Scalability (Task 10) & knowledge layers (Task 11)
- **44→400→4000 reports:** the flat folder fails at ~400 without §4 subfoldering + an auto-generated manifest (`repository-all.ps1` extension). The **taxonomy** (🟢/🔵/🟠) and SSOT-by-ID scale fine; the **physical folder** does not. → subfolder + auto-manifest is the scalability fix.
- **112→ changes/:** same class; folder by year/phase.
- **Knowledge layers** already map to `GOVERNANCE §1` (Boot/Conduct/Canon/State/Execution/Findings/Evidence/History) + the GENERIC/ORVION portability split (`GOVERNANCE §16`). No new layer needed.

## 7. Duplication & token-efficiency (Tasks 12, 13)
- **Duplication:** resolved at the fact level (SSOT matrix); residual *document* redundancy = `PROTOCOL.md` + `global-rules.md` (own nothing exclusive) → retire (§9).
- **Token waste (evidence-backed):** `global-rules.md` (88 lines of generic "write clean code"-class rules) is exactly the anti-pattern current research shows *reduces* agent success and *raises* inference cost — retiring it is a net token win. The 6 dated review reports are large but are 🟠 history that the boot flow correctly excludes; risk only if an agent reads all of `reports/` — mitigated by `reports/README` + a proposed **`llms.txt`** (curated agent map). GOVERNANCE.md (289 lines) is reference-not-boot; acceptable, tighten if it grows.

## 8. Tooling & automation (Task 16) — evidence-based
Carried from `GOVERNANCE §11` + one **new** current-practice item:
- **`llms.txt` (NEW, Recommended-now):** a root curated map of the knowledge surface for AI agents (agent-readiness standard 2025/26). Directly serves "self-discoverable, AI-friendly." Cheap, additive, high leverage given 44 reports + 39 canon. *Proposed content:* one-screen index → README, AGENTS, GOVERNANCE, manifest, reports/README, MASTER_GAP_REGISTER, roadmap. **Propose, not create** (mission: analysis only).
- pgTAP (Critical) · governance-lint hook (High) · Supabase/Postgres MCP (High) · squawk/sqlfluff (High) · lychee link-checker (Medium) · repository-all.ps1 extension for a `reports/` manifest (High). None self-installed (config/CI). Priority: pgTAP → governance-lint → llms.txt → MCP → linters.

## 9. Retirement proposal (Task 17 — do NOT delete; propose)
| File | Why retire | Replaced by | Migration |
|---|---|---|---|
| `PROTOCOL.md` | subordinate; self-declares deference to AGENTS; owns nothing exclusive | AGENTS.md (conduct) + GOVERNANCE.md (collaboration model) | move any unique line into AGENTS §7; leave a 1-line tombstone pointer; owner-gated |
| `global-rules.md` | generic filler (research: harms agents, raises cost); owns nothing exclusive | AGENTS.md + CODING_STANDARDS.md | fold any unique rule; tombstone; owner-gated |
| `backup/` | anti-pattern (git is the backup); untracked | git history | gitignore or remove |
| `_ORVION_CANONICAL/codex.md`, `SYSTEM_PROMPT.md` | already marked Deprecated in index | AGENTS.md | formally move to a history note or delete; owner-gated (protected) |
| 6 dated review reports (design-*, governance-*, this) | findings fully absorbed into Masters | the MASTER set (SSOT) | **keep as immutable history**; no retirement — flagged only so agents read Masters, not session logs |

## 10. Implementation roadmap for repository/EOS improvements (Task 18 — safest order)
1. **(Owner) Ratify pending ADRs + run Batch 0** — *this is #1; everything below is secondary to shipping.*
2. Add `llms.txt` + 1-line GOVERNANCE pointer in AGENTS.md/README (additive; owner-gated for protected files). *Low risk, high onboarding value.*
3. Install governance automation (pgTAP → governance-lint → link-checker → repository-all.ps1 manifest). *Turns convention into enforcement.*
4. Retire `PROTOCOL.md`/`global-rules.md` + remove `backup/` (owner-gated). *Reduces conduct docs 3→1, cuts token waste.*
5. Physical `reports/` + `changes/` subfoldering with atomic link-update. *Scalability; do once, carefully.*
Steps 2–5 are all **secondary to step 1.**

## 11. Self-challenge (Task, honest)
- *"You keep producing review reports while telling the owner to stop reviewing — hypocritical."* — **Valid and conceded.** This report exists because it was requested; its own §0 says it should be the last governance review before implementation. If the owner runs a 7th, I will open by declining-in-place: recommend execution over further review unless a concrete new trigger exists.
- *"Retiring PROTOCOL/global-rules could lose a unique rule."* — Mitigated: migration folds unique content first; tombstone preserves discoverability. But I have **not** line-by-line proven they contain zero unique rules — so retirement is **owner-gated with a diff step**, not asserted-safe. Confidence: 80%.
- *"llms.txt duplicates repository-index.md."* — Different: repository-index is an exhaustive auto-generated file listing; llms.txt is a *curated, prioritized* agent map (~1 screen). Complementary, not duplicate. But if agents already boot via AGENTS.md reliably, llms.txt is Recommended, not Required — 75%.
- *"Is the folder reorg worth the cross-reference risk?"* — Only at scale; today the index suffices. Deferred correctly.
- I could not construct a repository-drift or onboarding-ambiguity scenario that the SSOT matrix + boot flow + `reports/README` don't already prevent — except the AGENTS→GOVERNANCE pointer gap (step 2) and enforcement-by-prose (step 3). Both are in the roadmap.

## 12. FINAL CERTIFICATION (the one question)
> *"Could a completely new engineering team build ORVION from this repository alone, without rediscovering architecture, governance, knowledge, implementation strategy, or engineering decisions?"*

**YES — for everything they can reach through the corpus (Canon + AGENTS + GOVERNANCE + Masters + ADRs + reports), with three known, non-blocking blockers.** Evidence: deterministic boot flow (§5); SSOT for every fact (`GOVERNANCE §2`); complete finding/decision pipeline with evidence (`MASTER_GAP_REGISTER` + evidence reports); measurable health; industry-standard AI-first setup (validated). 

**Blockers (all owner-gated, none requiring rediscovery):**
1. **Proposed ADRs not yet ratified** → a team reading *only Canon* misses ~40% of the design; reading Canon + reports, they don't. (Ratify → integrate.)
2. **AGENTS.md/README don't point to GOVERNANCE.md** → the one onboarding non-determinism. (1-line pointer.)
3. **Governance is convention, not enforced** → drift is prevented by discipline, not tooling. (Install governance-lint/pgTAP.)

After blockers 1–3, the answer is an unqualified YES. **None of the three is a rediscovery problem — they are ratify/point/enforce actions.** The architecture, governance, and knowledge are already discoverable and non-conflicting.

**Therefore the correct next step is not a 7th review — it is execution:** ratify → Batch 0 → Phase 8, applying repository steps 2–5 opportunistically alongside.

*End of repository/EOS review 2026-07-11 #6. Analysis/planning only; nothing moved or implemented; protected files/canon/roadmap unchanged; Phase 8 not started.*

**Sources:** [AGENTS.md guide & 150-line research](https://blog.buildbetter.ai/agents-md-complete-guide-for-engineering-teams-in-2026/) · [How to build AGENTS.md](https://www.augmentcode.com/guides/how-to-build-agents-md) · [llms.txt agent readiness](https://auto-post.io/blog/publish-llms-txt-for-agent-readiness) · [Structuring codebases for AI tools 2025](https://www.propelcode.ai/blog/structuring-codebases-for-ai-tools-2025-guide)
