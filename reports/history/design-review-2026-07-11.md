# ORVION Architecture Review Board — Session Report (2026-07-11)

Status: **ARB session (analysis only).** Nothing implemented; no schema, canonical doc, or completed phase modified; Phase 8 not started. This is the timestamped record of the session that **established the permanent Master knowledge base** and reconciled every prior review into it.

Companion (permanent, cumulative): `MASTER_GAP_REGISTER.md` · `MASTER_DEPENDENCY_GRAPH.md` · `MASTER_EXECUTION_PLAN.md` · `MASTER_DESIGN_CHECKLIST.md` · `MASTER_RISK_REGISTER.md` · `MASTER_CERTIFICATION_STATUS.md` · `MASTER_ARCHITECTURE_DECISIONS.md`.

---

## 1. Scope executed
1. Re-read & reconciled **all** reports: engineering-audit, business-stress-test, design-evolution-plan, complete-platform-baseline, complete-platform-physical-design, architecture-synthesis, design-completion-certification, future-backlog, ADR-0001..0021, plus phase retrospectives, repository-engineering-program, workflow-architecture-report, communication-protocol(s). **No forgotten/rejected idea was found unaccounted for** (design-evolution CDD/RC/FOE fully absorbed into synthesis+register; workflow report is agent-handoff process, not architecture).
2. **Revalidated the repository from scratch** (did not trust prior conclusions).
3. Established the seven Master documents (owner mandate).
4. Ran the 23-lens certification board; recorded new findings DC-10..DC-18.
5. Tooling/MCP review (below).

## 2. Repository revalidation results (verified this session)
- **71 tables · 119 indexes · 36 triggers · 66 functions (~30 distinct `app` RPCs) · 12 CHECK constraints · 0 views · 0 materialized views.**
- **V1 — RLS coverage CONFIRMED complete.** `202607043300` §1 dynamic loop enables RLS + `tenant_isolation` on every `public` table with `tenant_id NOT NULL`; all 5 marketing/offline tables qualify. The earlier "no RLS on marketing tables" concern is **overturned/resolved**.
- **V2 — Audit A1 CONFIRMED.** Policy uses bare `app.current_tenant_id()` (not `(select …)`).
- **V4 — Immutability trigger EXISTS** on events/security_events (`forbid_mutation`) — partially closes B4.
- **V5 — Latent trap:** RLS coverage silently depends on `tenant_id NOT NULL`; unguarded → DC-16 test.
- **V6 — 0 views/matviews:** the read-model layer (reporting/RI/dashboards, RC-4) does not yet exist; all reads are RPCs. Recorded, not a defect (Phase 9).
- **DC-1 CONFIRMED:** `currencies.decimal_places=3` for KWD/BHD/OMR/JOD vs 22× `numeric(14,2)`.

## 3. Certification board — new findings (detail in `MASTER_GAP_REGISTER.md`)
DC-10 opening balances (High, 5 reviewers) · DC-11 realized FX posting · DC-12 passenger relationships/mahram · DC-13 UUIDv7 hot-table keys (High, retrofit-risk) · DC-14 tenant offboarding/export · DC-15 service_role blast radius · DC-16 pgTAP harness (High, prerequisite) · DC-17 realtime publication scope · DC-18 pgvector. Convergence auto-raised DC-10/13/16.

## 4. Tooling / MCP / capability review
Per the owner mandate. I did **not** self-install: MCP servers and hooks modify the user's Claude Code config (`.mcp.json`/`settings.json`) and often need credentials — installing them unilaterally is out of scope for an analysis session. Exact steps + value below; install on owner approval (I can apply via the `update-config` skill when authorized).

| Tool | Purpose | Architectural value | Install | Self-install? | Priority |
|---|---|---|---|---|---|
| **pgTAP** (DC-16) | In-DB unit/regression tests | The safety net that makes the R1–R8/DC-1/DC-13 built-table retrofits safe; encodes RLS-coverage & money invariants | `create extension pgtap;` in a test migration; run via `pg_prove`/psql in CI | Yes, as a migration + CI step (with approval) | **Critical** |
| **Supabase/Postgres MCP server** | Direct DB introspection/query from the agent | Replaces `docker exec … psql` verification; faster, structured schema/audit queries; improves every future review | add to `.mcp.json` (`@supabase/mcp-server-postgres` or Postgres MCP), configure connection string via env/secret | Manual (config + secret) — I can draft `.mcp.json` via update-config on approval | **High** |
| **squawk** / **sqlfluff** | Migration linter (unsafe-DDL, lock, style) | Catches locking/rewrite hazards in the money-scale & UUIDv7 ALTERs before they hit prod; enforces conventions | `pip install sqlfluff` / `npx squawk`; add CI step | CI step (repo change) on approval | High |
| **CR-invariant guard hook** (memory-noted) | Claude Stop/PostToolUse hook verifying `Active Change Request: None` after Complete + RLS-coverage assertion | Prevents the pointer-clear omission recurrence (SPEC-024/027) and enforces V5 | `settings.json` hook | Via update-config on approval | High |
| **Secret scanning** (gitleaks) | Pre-commit/CI secret detection | Guards Vault-ref discipline (CDD-7) — no secrets in tables/migrations | `gitleaks` pre-commit + CI | CI step on approval | Medium |
| **Playwright / Sentry / Stripe MCP** | App E2E / error tracking / billing | Future-gated — no app surface yet (per environment policy) | — | No (no trigger yet) | Low (deferred) |

**Recommendation:** enable pgTAP as part of Batch 0 (it is finding DC-16), and stand up the Supabase/Postgres MCP + migration linter to raise review quality. All require owner approval to modify config/CI.

## 5. Self-challenge (attempted disproof of this session)
- *"A senior architect tomorrow would say you never proved the retrofits are safe."* → Correct; that is exactly why DC-16 (pgTAP) is Batch-0 first and a certification condition. Recorded.
- *"You classified franchise/HR/etc. as Required — scope creep."* → Owner policy: if evidence shows it belongs in a complete Travel ERP, its **design** is Required; **timing is the owner's**. Not scope creep — timing ≠ design.
- *"0 views means reporting is unproven."* → RC-4 introduces the read-model layer; the event+RPC substrate supports it without foundation change (V6 recorded). Not a foundation risk.
- *"Did you miss a domain?"* → Re-swept against IATA/NDC/Amadeus/SAP/Oracle/Salesforce lenses; every candidate maps to an existing register entry (party, product, finance-depth, comms, integration, HR, procurement, fleet, loyalty, insurance-claims). No new domain surfaced. The two Excluded (Warehouse/MRP, Retail POS) remain proven-excluded.
- *"Contradiction with earlier 'no RLS on marketing tables'?"* → Resolved by V1 (dynamic loop covers them); finding withdrawn.
- No further evidence-supported finding remained after the sweep.

## 6. Master Knowledge Loop — completion checklist (this session)
- [x] Merged new findings with all previous reports
- [x] Removed duplicates (DC-series deduped vs A/B/BF/CDD/N)
- [x] Resolved contradictions (V1 RLS; ADR-0002/0006/0021 amendments)
- [x] Updated master gap register (created + populated)
- [x] Updated master execution plan
- [x] Updated master design checklist
- [x] Updated master risk register + certification status + decisions + dependency graph
- [x] Verified no validated finding forgotten (phase reports/backlog cross-checked)
- [x] Cross-referenced every finding with the roadmap (batches)
- [x] Every finding carries evidence, priority, dependencies, batch, certification status
- [x] Saved this timestamped report in `reports/`

## 7. Outcome
Domain completeness and internal consistency: **CERTIFIED.** Foundation stability / production readiness: **CONDITIONAL** on Batch 0 + Batch 1 (+ Batch 2 hardening) per `MASTER_CERTIFICATION_STATUS.md`. The architecture can now be executed directly from the Master documents. Implementation timing and product scope remain the owner's decision.

*End of ARB session 2026-07-11. No implementation performed; canon untouched; Phase 8 not started.*
