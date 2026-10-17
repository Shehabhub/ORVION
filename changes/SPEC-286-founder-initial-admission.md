# Change Request — SPEC-286

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Admit one exact, history-preserving founder bootstrap through the existing ORVION evidence and release judgments.

## Business Reason

The owner authorized one-time SECONDARY recovery after its source snapshot lost the certified source ancestry. Current founder main cannot pass ordinary historical replay. Adopt the exact certified source context while retaining every founder commit and founder-only file, then judge all new engineering through the existing lifecycle. This first dependency does not claim founder workstation, downstream customer release or hosted runtime readiness.

## Risks

An unrestricted substituted range would bypass governance. Bind the exception to the exact founder repository, old main, adopted object and sole first recovery contract; require an independent frozen owner bootstrap judge and unchanged source certification before owner release. Old history remains historically refused, never retroactively passed. CTRL-19 remains OPEN.

## Supersedes / Depends On

Depends on completed changes/SPEC-285-anonymous-public-github-readers.md and the owner's exact one-time founder initial-admission decision. Supersedes no terminal contract. Founder profile adaptation remains a subsequent dependency, not a readiness claim of this contract.

## Write Scope

- `.githooks/pre-commit`
- `scripts/resolve_initial_admission.ps1`
- `scripts/test_initial_admission.ps1`
- `scripts/check_agent_continuity.ps1`
- `.github/workflows/orvion-acceptance.yml`
- `reports/architecture-decision-records.md`
- `_ORVION_CANONICAL/manifest.md`
- `ai-map.json`
- `repository-index.md`
- `GOVERNANCE.md`

## Out of Scope — Files Forbidden to Modify

- `scripts/publish_candidate.ps1`
- `scripts/promote_main.ps1`
- `scripts/github_public_read.ps1`
- `scripts/test_agent_continuity.ps1`
- `scripts/test_certification_receipts.ps1`
- `.github/workflows/agent-control.yml`
- `.github/workflows/repository-consistency.yml`
- `.workstation/doctor.ps1`
- `.workstation/prepare.ps1`
- `.mcp.json`
- `CR_LIFECYCLE.md`
- `AGENTS.md`
- `reports/evidence/primary-ledger-evidence.json`
- `reports/evidence/database-parity-evidence.json`

All source writes are confined to the independent SECONDARY clone. No PRIMARY changes, credentials, Rulesets, databases, installed owner launchers, source receipt edits, historical CR changes, automatic publication or promotion. The exact adopted object is a pre-implementation owner-authorized admission context, not a synthetic successful historical replay.

## Required Reading

- `AGENTS.md` §§1–3,6–8
- `CR_LIFECYCLE.md` §§4–5,8–9
- `GOVERNANCE.md` §§6,15
- `ENGINEERING_METHOD.md` §§1–3
- `changes/TEMPLATE.md`
- `scripts/check_agent_continuity.ps1`: range setup, Get-PublicationSegments, allocator, Trusted, receipt binding and Certify-Remote
- `scripts/publish_candidate.ps1`
- `scripts/promote_main.ps1`
- `.github/workflows/agent-control.yml`
- `.github/workflows/orvion-acceptance.yml`
- `reports/architecture-decision-records.md`

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Required Capabilities

None

## Additional Verification

- pwsh -NoProfile -File scripts/test_initial_admission.ps1
- pwsh -NoProfile -File scripts/test_certification_receipts.ps1

## Pre-Approval Evidence

Change Class: Owner-Decision

Preparation predicates: Consumer Closure PASS; Execution-Boundary Satisfiability PASS; Permanent-Control Admission PASS. Existing allocation remains the sole SPEC-identity judge. This frozen Draft grants no implementation authority before Human Gate 1. The final exact frozen Draft approval and publication-range rehearsal results are attached in Gate-1-evidence.json; no previous synthetic approval is owner authorization.

Physical founder base: `35865ca63539f74bbaaf7fa624366defcd784d4b`. Certified source: `fd118fae6c76271100d67fdb44923bb0b406c986`. Owner-directed adopted context: `d429e4295f020c5231af82d093fad1c2536b0391`; parents are certified source first, physical founder base second. Its tree retains all 976 source entries exactly, including executable hook mode, and all eight founder-only entries exactly. The physical founder-to-adopted tree diff is exactly the in-scope .githooks/pre-commit mode restoration 100644 to 100755 with the same blob; no content changes. The unchanged allocator derives cursor 285 and next legal identity 286 at this adopted context; no production allocation has occurred. Old-to-adopted replay retains AMBIGUOUS_GOVERNING_CR, not PASS.

Source anchors at adopted context:

| Path | Git blob |
| --- | --- |
| `.githooks/pre-commit` | `40e6df021b0a9959462c51aab30981b7a82af860` |
| `scripts/resolve_initial_admission.ps1` | `ABSENT` |
| `scripts/test_initial_admission.ps1` | `ABSENT` |
| `scripts/check_agent_continuity.ps1` | `86e15ae7d85401a3d09388603515997dec121d40` |
| `.github/workflows/orvion-acceptance.yml` | `b242e4c7401258404c5d43bffb49c3f53f42467e` |
| `reports/architecture-decision-records.md` | `0bc32a7ec591cfbeeb7b26333ce66825d04c3e26` |
| `_ORVION_CANONICAL/manifest.md` | `b6151fdc7b304ac9bcf8067ed83e6e8656c30725` |
| `ai-map.json` | `d0eeb2248e125cb45b97b16444eee7d902317165` |
| `repository-index.md` | `d075792a248fc781d7012cc0296fcd8bc15a47d5` |

Additional source anchor: `GOVERNANCE.md` blob `5670c47888bbd6b4194f6c41c54476ee42cb7bdf`. The new owner-directed priority is a current-state authority change, not a product roadmap rewrite. Both exact lines and their §6 pins change together; the Batch 6 surface-coverage pin remains unchanged.

Proposed exact pinned lines:

Current Module: Founder ownership recovery — prerequisites and stop boundaries are owned by ADR-0032 in `reports/architecture-decision-records.md`; the product capability sequence is unchanged.

Next capability: Follow the next unmet founder recovery prerequisite in ADR-0032 (`reports/architecture-decision-records.md`). Ordinary product work waits for that sequence; resumed Batch 6 selection remains owned by `scripts/batch6_select_target.ps1`.

| File | Line | Value owned by | SHA-256 of the line |
| --- | --- | --- | --- |
| `_ORVION_CANONICAL/manifest.md` | `Current Module` | `reports/architecture-decision-records.md` | `6439b6e8bbcd28a38197484f00daa7fd45b0f1ae00b35f50331ca9303f39840b` |
| `_ORVION_CANONICAL/manifest.md` | `Next capability` | `reports/architecture-decision-records.md` | `316c22cf93727281371b02f88743438d694a46fe0d5b98f1393a8bcafc12c64f` |

External one-use owner preparation adapter: `Owner-Initial-Promote.prototype.ps1`, SHA-256 `02ecfb2df890fdc16f5e98b6fd133b121e3cd39766aa5fa8739f8d2e8223977a`. It is frozen preparation, not installed or authorized for automatic use. Human publication and initial promotion gates remain required. The exact owner-selected completion must pass the original source receipt reader, original source Certify-Remote and outside-candidate Trusted Gate, existing CI watcher, owner-authenticated protection assertions and exact-old Git lease before its sole owner-invoked push. No permanent third launcher is introduced.

### Consumer Closure

Applicability: APPLICABLE

| Changed fact or surface | Relevant consumer | Disposition | Evidence / preserved behavior |
| --- | --- | --- | --- |
| Exact initial governing boundary | evaluator local/range/binding and both existing CI callers | WRITE | One bounded helper supplies the exact admitted baseline only for old/zero initial ranges; ordinary Gate judges every post-adoption state. |
| Initial local pending context | Protect-PendingCertifications and unchanged pending/receipt judgments | WRITE | The same resolver supplies only the initial enumeration input. Actual inherited enumeration fails historical Status parsing before correction; imported baseline is not pending local work. Preserve all saved-record and working-evidence predicates and prove later unbound completions still block. |
| Executable hook mode | .githooks/pre-commit and Git hook dispatch | WRITE | Restore only the original certified 100755 mode from founder 100644; identical blob. No hook body or PRIMARY configuration change. |
| New helper and tests | Get-ControlSurface and required acceptance | WRITE | Both paths derive CONTROL; required acceptance runs the actual new suite and checks its exit. |
| Independent judgment | unchanged pinned source Trusted evaluator and external frozen owner bootstrap preparation | VERIFY | Candidate is data only; use adopted-to-candidate range only after exact physical ancestry, source Certify-Remote and authenticated no-bypass metadata proof. |
| Normal owner release adapters | publisher/promoter and installed CRM launchers | UNAFFECTED | Normal initial promoter intentionally still refuses; an exact one-use owner bootstrap adapter is frozen externally before Gate 1, never a permanent third launcher or automatic owner action. |
| Source certificate and evidence readers | Certify-Remote, Inherited-Run, public reader and retained source receipt | VERIFY | Original source byte view and receipt reproduced unchanged; real anonymous source certification READY; no new workflow success or receipt authority. |
| Governance record and projections | ADR, manifest, ai-map and index | WRITE | Append the approved bounded decision; synchronize active/last-completed state and owner-directed recovery routing; generator owns projections. |
| Founder workstation and hosted target selection | doctor, prepare, capabilities, ledger/parity and integration catalog | UNAFFECTED | This bootstrap does not alter or certify these target-specific consumers; full founder development readiness remains blocked until their own closed, approved contract. |

| Current Module / Next capability | GOVERNANCE.md and _ORVION_CANONICAL/manifest.md | WRITE | Move both exact current-priority lines and their pins together to the existing ADR authority; preserve the Batch 6 coverage pin and business phase. |
| Priority transition | CR_LIFECYCLE.md | VERIFY | Generic Complete routing already preserves a programme owner; no command/state/schema changes. |
| Priority scheduling | reports/master/MASTER_EXECUTION_PLAN.md | VERIFY | Manifest owns the next executable task; Batch 6 selector clause applies inside Batch 6, which resumes after founder readiness. |
| Prior authority incidents | reports/master/MASTER_GAP_REGISTER.md | UNAFFECTED | Historical CTRL and documentation findings keep their evidence/status; no old incident is rewritten. |
| Generated-state comparison | reports/master/MASTER_REPOSITORY_HEALTH.md and scripts/check_repository_consistency.ps1 | VERIFY | Compare actual field values and phase, not a hardcoded current package; regenerate projections and run the real guard. |
| Authority enforcement | scripts/check_agent_continuity.ps1 | WRITE | Existing ACI/SACI code remains byte-identical; use it to judge both pin changes and every discovered consumer. |
| Projection generation | scripts/generate-ai-map.ps1 | VERIFY | Extracts live fields without knowing their values; use existing generator unchanged. |
| Authority and receipt regressions | scripts/test_agent_continuity.ps1 and scripts/test_certification_receipts.ps1 | VERIFY | Existing fixture-owned authorities and receipt formats stay unchanged; source command feasibility reused, final commands fresh. |

Unresolved Material Consumers: None

### Execution-Boundary Satisfiability

Applicability: APPLICABLE

Irreversible Action Step: NONE

| Invariant | Required At | Red Opens After Step | Restored By Step | Mandatory Gate Before Step |
| --- | --- | --- | --- | --- |
| Exact admitted context and legal frozen contract | BEFORE_IMPLEMENTATION | NONE | NONE | 1 |
| New boundary helper and CI consumer agree | BEFORE_COMPLETION | 2 | 3 | 4 |
| Scope, generated state and release-template inputs agree | BEFORE_COMPLETION | 2 | 3 | 4 |

Measured feasibility: the source's retained spec-285-finish.log reports exit 0 for all five mandatory CONTROL commands, repository consistency and diff checking. Those are reused baseline command measurements, not fresh results of this change. Focused isolated proof: boundary suite 29/0 including six independently killed mutants and later-range/reuse/multiple-contract cases; original receipt suite 64/0 (profile children stubbed, HTTP synthetic, actual Git); actual prototype local old-main and zero-before first-push ranges READY; unchanged pinned-source Trusted range READY; actual source Trusted negatives reject frozen objective mutation and status regression; workflow YAML syntax and unchanged existing semantics proven, suite-step success/failure 2/0; owner metadata assertions 16/0 with real HTTP positive and synthetic negatives; exact original source receipt with real anonymous Certify-Remote READY; original owner metadata transport real HTTP PASS; actual local bare-Git lease proof 5/0. These classes are separate, never combined into hosted acceptance. Source comparison must confirm 106 existing functions unchanged and the public reader blob unchanged; the only existing function differences are control registration and the exact pending enumeration input, with one new bounded context resolver. The first receipt result predates the pending-input correction and is retained as prior evidence only; the corrected prototype requires a fresh full receipt suite. Its final counts and pending/context/pin proofs are recorded in the accompanying exact evidence manifest before presentation. New pointer/pin and exact frozen approval/range rehearsals must also pass before this Draft is presented. Final mandatory CONTROL/REPOSITORY checks and both additions must run freshly through watched Finish after implementation; hosted preflight and post-promotion certification are still unexecuted POST_PUSH evidence.

### Permanent-Control Admission

Applicability: APPLICABLE

Existing Mechanism Reusable: YES

Existing Mechanism: ordinary Gate, immutable CRs, existing allocator, timed Finish, candidate receipts, expected workflow deriver, unchanged Certify-Remote and outside-candidate Trusted evaluation.

Added Property: one exact owner-authorized founder history admission without retroactive historical verdicts or general range substitution.

Causal Negative: current founder ordinary Draft Gate fails recorded-ledger ancestry; ancestry union alone still fails AMBIGUOUS_GOVERNING_CR in unchanged independent trusted evaluation. Adopted context Boot succeeds, but unchanged publisher/promoter still refuse old-to-new historical replay.

Positive Test Design: exact bootstrap with a nonempty ordinary recovery lifecycle; clean source receipt certification through real anonymous HTTP; physical old-main ancestry; all source and founder-only entries retained; normal ranges remain byte-for-byte unchanged.

Negative Test Design: wrong repository or event repository, moved target, absent/wrong adopted parent order, bare adoption without recovery CR, wrong recovery contract, head mismatch, malformed SHA, missing ancestry and normal gates refusing illegal transitions or frozen-scope changes. Unreadable source or protection metadata prevents owner release.

Non-Empty Population Obligation: both retained histories, 976 exact certified source entries, eight exact founder-only entries, one legal first recovery contract and actual source exact-SHA expected workflow observations.

Mutation Obligation: independently remove load-bearing target, physical-base, adoption ancestry, exact first-contract and head binding checks; require their forbidden fixtures to escape, then prove restored refusal. Redundant exact-OID consequences are not counted as independent mutations.

Post-Implementation Proof Obligation: all derived CONTROL/REPOSITORY and Additional Verification commands execute through timed/watched Finish; independent Review and exact-SHA local preparation follow only successful certification. Required hosted preflight and main certification are POST_PUSH owner-gated observations, never local PASS claims.

## Implementation Steps

1. Check exact frozen Draft hash, source anchors, source certificate and owner authorization against the external Gate 1 handoff; otherwise stop. Check adopted context `d429e4295f020c5231af82d093fad1c2536b0391` has exactly source-first and retained-founder-second parents and exact prepared tree before allocating this contract; the only physical founder-tree delta is the scoped .githooks/pre-commit mode restoration 100644 to 100755, with its blob unchanged. Recheck that the unchanged allocator selects 286 there; stop on drift. Record owner approval using normal lifecycle, then enter In Progress as the first implementation action. Do not treat a rehearsal approval as owner authorization.
2. Check for `function Get-InitialAdmissionBase` in scripts/check_agent_continuity.ps1 and the complete matching helper at scripts/resolve_initial_admission.ps1; if both match the frozen prototype, record Already Applied; if either only partly matches, stop. Otherwise add the proven bounded helper at scripts/resolve_initial_admission.ps1 and register it and its suite in Get-ControlSurface. In non-Trusted range mode only, before existing Assert-Ref/history work, map the exact old or first-push zero base to the exact adopted context only when the helper proves the exact founder origin/event identity, full matching head, tracked main old-or-the-exact-main-replay head; actual remote main is independently re-read at the owner release gate, exact adoption object and ordered parents, adopted ancestry, and sole new recovery contract path. Preserve the existing base on every other range. Reuse the same exact context resolver for Protect-PendingCertifications enumeration when the local upstream is the exact initial founder main; imported baseline history is not pending local engineering. Preserve every subsequent saved-record, digest, ancestry and working-evidence check verbatim. Ordinary and post-bootstrap pending ranges remain unchanged and still refuse unbound completions. Keep Trusted mode, allocator, frozen-contract walker, source reader, certification, receipt formats, inheritance, expected-workflow and literal-success judgments unchanged. No historical replay verdict is reclassified.
3. Check for `Attack the exact initial-admission boundary` in .github/workflows/orvion-acceptance.yml, the complete matching suite at scripts/test_initial_admission.ps1 and both proposed manifest/pin pairs; if all match, record Already Applied; stop on partial matches. Otherwise add the tested nonempty positive/negative/mutation fixtures and invoke their real suite with exit checking in orvion-acceptance before the ordinary range Gate. Append the owner-approved one-time context and boundary limits to the existing ADR authority. Replace exactly the manifest Current Module and Next capability lines with the proposed lines above and replace their two GOVERNANCE.md §6 rows with the proposed owner and hashes in the same commit; leave the Batch 6 surface-coverage pin and business phase untouched. Consumer Closure declares WRITE on both pinned lines and dispositions every live consumer found at the adopted base. Synchronize manifest active/last-completed state through normal lifecycle and regenerate both projections with the existing generator. Preserve installed release launchers and normal publisher/promoter source.
4. Check final scope, deterministic generated artifacts and local candidate evidence. Commit Resume Step DONE and run timed Finish with its watcher concurrently; run every derived mandatory command and both additions freshly. Independently Review, synchronize and Complete only after success. Prepare the exact SHA locally against the admitted context and verify it independently from the pinned source judge. Stop for owner publication and initial promotion actions from the frozen external bootstrap adapter; never publish, promote or change a Ruleset automatically. Do not declare founder profile/runtime or downstream readiness. CTRL-19 remains OPEN.

## Acceptance Criteria

- [ ] Initial admission is confined to the exact founder context and first recovery contract, with no ordinary range or Trusted behavior changed.
- [ ] The source and both founder histories, all founder-only entries and every terminal CR remain intact.
- [ ] Every post-adoption transition is judged by the existing lifecycle, frozen scope, allocation and receipt authorities.
- [ ] Required acceptance executes the new positive, negative and mutation suite and cannot hide its failure.
- [ ] Unchanged source certification, inherited evidence, exact SHA, branch, event, current attempt, expected workflow and literal success remain the sole evidence judgments.
- [ ] Normal publisher/promoter and installed CRM launchers remain unchanged; initial owner release remains separately gated.
- [ ] Founder profile, downstream release and hosted runtime readiness are explicitly unproven by this bootstrap.
- [ ] Boot routes a fresh session to the founder recovery prerequisite authority; both corresponding pins agree and all consumers remain closed.

## Execution Log

None.

## Verification Notes

None.

## Review Gate

- [ ] Every change matches the frozen steps.
- [ ] No file outside Write Scope changed.
- [ ] Every Acceptance Criterion is true.
- [ ] Required checks and final certification are observed, never inferred.
- [ ] Repository state and generated artifacts are synchronized.
- [ ] Owner release boundaries and CTRL-19 OPEN are preserved.

## Notes

Frozen owner-review Draft. Production refs, original receipt-bearing checkouts and both hosted databases remain untouched. Gate-1-evidence.json owns the exact final rehearsal observations; implementation, publication and promotion each retain their owning authorization boundary.
