# Change Request — SPEC-050

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

Allowed values are exactly these five. Do not use any other status word anywhere in a Change Request.

---

## Assigned Model Tier

[x] Tier 1 — Strong reasoning model
[ ] Tier 2 — Local execution agent (Qwen3.8B)

---

## Objective

Establish a canonical **Tenant Isolation & Data Access Principles** document (`35`) consolidating the RLS/tenant-isolation decisions that Migration 19 depends on, so the RLS implementation is derived from stated principles rather than re-litigated per table.

---

## Business Reason

Owner directive: the tenant-isolation philosophy is distributed across ADR-0011, `30` (Tenant Scope + Identity Key Standards), and `31 §13` item 3. Consolidating it — mirroring how `34` clarified Migration 16 — lets Migration 19's ~70 policies fall out as a consequence. Execution-oriented; answers only what Migration 19 needs.

---

## Risks

Low. Documentation + canonical pointer updates only; no DDL, no migration. The doc restates already-approved decisions and adds one derivable engineering rule (single resolution primitive). No genuinely unresolved architectural question surfaced (all pre-settled).

---

## Supersedes / Depends On

Consolidates ADR-0011 (SPEC-033), `30` Standards (SPEC-027/031/033), `31 §13` item 3. Precedes Migration 19. No CR superseded.

---

## Scope — Files Allowed to Modify

- _ORVION_CANONICAL/35_tenant_isolation_and_data_access_principles.md (new)
- README.md (First Reading Order entry only)
- _ORVION_CANONICAL/31_schema_draft.md (§13 item 3 backlink only)
- reports/architecture-decision-records.md (append ADR-0013)

---

## Out of Scope — Files Forbidden to Modify

- Any migration file ; supabase/config.toml ; any other canonical section ; any table structure ; any other CR

---

## Minimum Reading List

- reports/architecture-decision-records.md (ADR-0011)
- _ORVION_CANONICAL/30_database_conventions.md (Tenant Scope Standard, Identity Key Standard)
- _ORVION_CANONICAL/31_schema_draft.md (§13 item 3)
- _ORVION_CANONICAL/34_authentication_and_identity_principles.md (pattern precedent)

---

## Implementation Steps

1. Create `_ORVION_CANONICAL/35_tenant_isolation_and_data_access_principles.md` — eight execution-oriented principles (tenant isolation philosophy, membership resolution, active tenant context, RLS interaction, cross-tenant behavior, platform/support access, audit behavior, future compatibility), an application rule for Migration 19, and an explicit "no unresolved blocking question" statement. Consolidate existing decisions (cited); add only the derivable single-resolution-primitive recommendation.
2. Add the document to README's First Reading Order.
3. Add a backlink from `31 §13` item 3 to `35`.
4. Append ADR-0013 recording the consolidation.

---

## Acceptance Criteria

- [x] `35_tenant_isolation_and_data_access_principles.md` exists, is marked Canonical, and covers the eight required topics with Findings/Recommendations/Preferences/Future-considerations distinguished.
- [x] It re-opens no settled decision; each principle cites its authority or is marked as a derivable recommendation.
- [x] README First Reading Order references `35`; `31 §13` item 3 backlinks to it; ADR-0013 appended.
- [x] No DDL, no migration, no table change.

---

## Execution Log

### 2026-07-05 — Claude (Tier 1)

Outcome: Complete

Step results:
- Steps 1–4: Applied — `35` created; README, `31 §13` backlink, and ADR-0013 updated. No DDL, no migration touched.

Commits: recorded at Complete.

Blocker: none.

---

## Verification Notes

### 2026-07-05 — Claude (independent review)

Verdict: Confirmed Complete

Findings: The document is execution-oriented and non-duplicative; all eight owner-named topics are present with explicit classification. Every principle either cites an existing authority (`30` Tenant Scope/Identity Key Standards, `31 §13` item 3, ADR-0011) or is marked a derivable recommendation (single resolution primitive; non-API SECURITY DEFINER schema; catalog_values dual-read; append-only audit). No settled decision re-opened; no genuinely unresolved question requiring owner approval. Scope respected — no migration or unrelated canon touched.

Recommendation to human: Set Status to Complete

---

## Review Gate

- [x] Every change matches the Implementation Steps.
- [x] No file outside Scope was modified.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] The repository is in a clean, releasable state.

---

## Notes

Earned per the principles-doc trigger (RLS decisions scattered across ≥3 sites + imminent Migration 19 + owner request). No new abstraction introduced; the single-resolution-primitive rule is an implementation convention for Migration 19, not a new subsystem. Migration 19 DDL (policies + resolution function) is implemented separately. Two items to sequence before/with Migration 19 remain in the backlog: the F2 FK ALTER and the subscription-state-vs-tenant-isolation authority decision.
