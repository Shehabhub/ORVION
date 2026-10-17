# Change Request — SPEC-287

## Status

[x] Draft
[ ] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Make the existing Founder development environment independently recoverable and correctly bound to its own GitHub, hosted-evidence and local-runtime targets through the existing ORVION authorities.

## Business Reason

The owner accepted remotely certified SPEC-286 and ordered Founder operational independence before controlled Platinum-to-Founder synchronization, CR C assurance, CR B Actions hardening, four independent launchers, two external dual coordinators, earned shared evidence optimization, README-to-Boot continuity, recovery proof and the unchanged Phase 8 / Batch 6 product roadmap. Correct active targets and current attribution while preserving source provenance. No new release engine, evidence framework or control plane.

## Risks

Wrong Git push URLs, inherited MCP definitions, contradictory SUPABASE_WORKDIR / CLI workdir / project-ID / npm binary overrides, a reused local Docker project, or indistinguishable ledger digests could select Platinum. Close those concrete consumer paths and fail closed on unexpected identity, metadata or evidence. Existing recorded evidence cannot cryptographically prove its remote origin (GUARD-1); require the actual authenticated read as an external action and never claim a file check performed it. A clean-clone recovery on installed Windows tools is not a bare Windows installation or permanent credential isolation. No full operational declaration precedes all required readiness evidence and owner workstation adoption. CTRL-19 remains OPEN.

## Supersedes / Depends On

Depends on terminal `changes/SPEC-286-founder-initial-admission.md` and its remotely certified exact candidate c362e417eca5496d4235bb0232f7fab9cfd5ac17. Does not supersede or edit it. Owner direction: Founder Operational Independence, Repository Synchronization & Workflow Simplification, 2026-10-17. Original receipt-bearing checkouts remain protected.

## Write Scope

- .github/workflows/migration-ci.yml
- .github/workflows/orvion-acceptance.yml
- .github/workflows/repository-consistency.yml
- .mcp.json
- .workstation/cleanup.ps1
- .workstation/decommission.ps1
- .workstation/doctor.ps1
- .workstation/manifest.md
- .workstation/prepare.ps1
- ENGINEERING_METHOD.md
- GOVERNANCE.md
- WORKSTATION.md
- _ORVION_CANONICAL/32_execution_roadmap.md
- _ORVION_CANONICAL/manifest.md
- ai-map.json
- bootstrap.ps1
- reports/architecture-decision-records.md
- reports/evidence/founder-ledger-evidence.json
- reports/master/MASTER_CERTIFICATION_STATUS.md
- reports/master/MASTER_INTEGRATION_CATALOG.md
- repository-index.md
- scripts/assert_founder_local.ps1
- scripts/batch6_select_target.ps1
- scripts/check_agent_continuity.ps1
- scripts/check_database_parity.ps1
- scripts/check_database_parity_evidence.ps1
- scripts/check_primary_ledger.ps1
- scripts/check_repository_consistency.ps1
- scripts/generate-ai-map.ps1
- scripts/generate-api-contract.ps1
- scripts/impact.ps1
- scripts/test_agent_continuity.ps1
- scripts/test_founder_environment.ps1
- scripts/test_primary_ledger_guard.ps1
- scripts/verify_api_end_to_end.ps1
- scripts/verify_care_journeys.ps1
- scripts/verify_customer_concurrency.py
- scripts/verify_journey_branches.ps1
- scripts/verify_lifecycle_branches.ps1
- scripts/verify_role_journeys.ps1
- scripts/verify_storage_end_to_end.ps1
- scripts/watch_ci.ps1
- supabase/config.toml

## Out of Scope — Files Forbidden to Modify

- AGENTS.md
- CR_LIFECYCLE.md
- PROJECT_CONTEXT.md
- package.json
- package-lock.json
- scripts/publish_candidate.ps1
- scripts/promote_main.ps1
- scripts/github_public_read.ps1
- scripts/parity_surface.sql
- scripts/verify_database.sql
- scripts/verify_workstation_idempotence.ps1
- scripts/test_certification_receipts.ps1
- reports/evidence/primary-ledger-evidence.json
- reports/master/MASTER_API_CONTRACT.md
- changes/SPEC-286-founder-initial-admission.md

The list above is not exhaustive; every engineering artifact outside Write Scope is forbidden. No migration SQL, pgTAP tests, product schema, hosted data, GitHub settings, account, credential, installed external launcher or Platinum checkout may change. Do not implement source synchronization, six launchers, shared evidence, a Finish exception or product work. No owner publication or promotion is authorized by implementation approval.

## Required Reading

- AGENTS.md
- CR_LIFECYCLE.md
- ENGINEERING_METHOD.md
- GOVERNANCE.md
- WORKSTATION.md
- .workstation/manifest.md
- reports/master/MASTER_INTEGRATION_CATALOG.md
- reports/architecture-decision-records.md
- scripts/check_primary_ledger.ps1
- scripts/check_database_parity_evidence.ps1
- scripts/check_database_parity.ps1
- scripts/check_agent_continuity.ps1
- scripts/assert_founder_local.ps1

## Runtime Checkpoint

Resume Step: 1
Blocker: MISSING_REQUIRED_CAPABILITY
Recovery Attempt: 1

## Required Capabilities

- github
- docker
- supabase-local

## Additional Verification

- pwsh -NoProfile -File scripts/test_founder_environment.ps1
- pwsh -NoProfile -File scripts/test_workstation.ps1
- pwsh -NoProfile -File scripts/watch_selftest.ps1
- pwsh -NoProfile -File scripts/test_certification_receipts.ps1
- pwsh -NoProfile -File scripts/verify_api_end_to_end.ps1
- pwsh -NoProfile -File scripts/verify_storage_end_to_end.ps1
- pwsh -NoProfile -File scripts/verify_role_journeys.ps1
- pwsh -NoProfile -File scripts/verify_lifecycle_branches.ps1
- pwsh -NoProfile -File scripts/verify_journey_branches.ps1
- pwsh -NoProfile -File scripts/verify_care_journeys.ps1
- python scripts/verify_customer_concurrency.py

## Pre-Approval Evidence

Change Class: Significant

### Consumer Closure

Applicability: APPLICABLE

| Changed fact or surface | Relevant consumer | Disposition | Evidence / preserved behavior |
| --- | --- | --- | --- |
| active Founder target | .github/workflows/migration-ci.yml | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | .github/workflows/orvion-acceptance.yml | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | .github/workflows/repository-consistency.yml | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | .mcp.json | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | .workstation/cleanup.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | .workstation/decommission.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | .workstation/doctor.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | .workstation/manifest.md | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | .workstation/prepare.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | ENGINEERING_METHOD.md | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | GOVERNANCE.md | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | WORKSTATION.md | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | _ORVION_CANONICAL/32_execution_roadmap.md | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | _ORVION_CANONICAL/manifest.md | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | ai-map.json | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | bootstrap.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | reports/architecture-decision-records.md | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | reports/evidence/founder-ledger-evidence.json | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | reports/master/MASTER_CERTIFICATION_STATUS.md | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | reports/master/MASTER_INTEGRATION_CATALOG.md | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | repository-index.md | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/assert_founder_local.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/batch6_select_target.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/check_agent_continuity.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/check_database_parity.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/check_database_parity_evidence.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/check_primary_ledger.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/check_repository_consistency.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/generate-ai-map.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/generate-api-contract.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/impact.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/test_agent_continuity.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/test_founder_environment.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/test_primary_ledger_guard.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/verify_api_end_to_end.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/verify_care_journeys.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/verify_customer_concurrency.py | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/verify_journey_branches.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/verify_lifecycle_branches.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/verify_role_journeys.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/verify_storage_end_to_end.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | scripts/watch_ci.ps1 | WRITE | Observed direct consumer; exact baseline blob in Notes |
| active Founder target | supabase/config.toml | WRITE | Observed direct consumer; exact baseline blob in Notes |
| Current Module | _ORVION_CANONICAL/manifest.md | WRITE | Move current engineering programme ownership to ADR-0033 and update its GOVERNANCE.md pin together; product phase unchanged |
| Next capability | _ORVION_CANONICAL/manifest.md | WRITE | Point at ADR-0033 as the single owner of the dependency sequence; update its pin together |
| Batch 6 surface coverage | _ORVION_CANONICAL/manifest.md | VERIFY | Preserve the exact pinned line and its existing owner unchanged |
| preserved authority / pinned-line consumer | AGENTS.md | VERIFY | conduct and existing native lifecycle retained |
| preserved authority / pinned-line consumer | CR_LIFECYCLE.md | VERIFY | Current Module / Next capability point at their owner; no lifecycle edits |
| preserved authority / pinned-line consumer | reports/master/MASTER_REPOSITORY_HEALTH.md | VERIFY | pinned-line and recorded evidence classes remain bounded |
| preserved authority / pinned-line consumer | reports/master/MASTER_GAP_REGISTER.md | VERIFY | historical incidents and CTRL-19 remain unchanged |
| preserved authority / pinned-line consumer | reports/master/MASTER_EXECUTION_PLAN.md | VERIFY | programme sequence owned by ADR-0033; product Batch 6 remains unchanged |
| preserved authority / pinned-line consumer | scripts/test_certification_receipts.ps1 | VERIFY | receipt semantics and original execution context remain unchanged |
| preserved authority / pinned-line consumer | scripts/publish_candidate.ps1 | VERIFY | existing publication authority, exact range and SHA binding unchanged |
| preserved authority / pinned-line consumer | scripts/promote_main.ps1 | VERIFY | outside-candidate Trusted judgment, fast-forward and lease unchanged |
| preserved authority / pinned-line consumer | scripts/github_public_read.ps1 | VERIFY | anonymous transport, pagination and exact-run field judgments unchanged |
| preserved authority / pinned-line consumer | scripts/watch_selftest.ps1 | VERIFY | actual watcher judgment suite reused |
| preserved authority / pinned-line consumer | scripts/verify_workstation_idempotence.ps1 | VERIFY | real Doctor-first verifier retained |
| preserved authority / pinned-line consumer | scripts/parity_surface.sql | VERIFY | the same full-surface SQL runs on both sides |
| preserved authority / pinned-line consumer | reports/master/MASTER_API_CONTRACT.md | VERIFY | unchanged SQL surface; actual L3 byte comparison passed |
| preserved authority / pinned-line consumer | reports/evidence/primary-ledger-evidence.json | VERIFY | preserved byte-for-byte as historical Platinum source reading |
| preserved authority / pinned-line consumer | changes/SPEC-286-founder-initial-admission.md | VERIFY | terminal and immutable; no reopening |

Unresolved Material Consumers: None

### Execution-Boundary Satisfiability

Applicability: APPLICABLE

Irreversible Action Step: NONE

| Invariant | Required At | Red Opens After Step | Restored By Step | Mandatory Gate Before Step |
| --- | --- | --- | --- | --- |
| Validated Founder root/config and no contradictory target before corrected local mutation | BEFORE_COMPLETION | 1 | 3 | 5 |
| Frozen source anchors and legal allocation | BEFORE_IMPLEMENTATION | NONE | NONE | 1 |
| Correct active targets, recorded evidence, projections and authority pins | BEFORE_COMPLETION | 1 | 4 | 5 |
| Native profiles, receipt and clean exact candidate | BEFORE_COMPLETION | NONE | NONE | 5 |
| Platinum, hosted databases, original receipts and installed launchers unchanged | BEFORE_IMPLEMENTATION,BEFORE_COMPLETION | NONE | NONE | 5 |

External authenticated Founder evidence is required, not inferred from capability names. The bootstrap contract deliberately uses the existing github/docker/supabase-local capabilities: declaring a capability that its own implementation adds would make its approval circular. DATABASE already mandates the same hosted-evidence adapter and ledger validator; omitting a duplicate external declaration removes no mandatory check. Register `supabase-secondary` for subsequent contracts and refuse unknown names as before. Never substitute `supabase-primary` or a renamed Platinum record for the actual Founder read.

### Permanent-Control Admission

Applicability: APPLICABLE

Existing Mechanism Reusable: YES

Existing Mechanism: RECOVER-1 full-ledger/history validator, PAR-6 adapter and one full-surface parity engine; existing mismatch-refusing MCP preparation and Doctor; native Boot/Gate/Finish/Trusted/Certify, publisher/promoter and watcher. Reuse them; add no second verdict authority.

Added Property: Founder project/read-origin/configuration and Git-direction binding, distinct local resources, effective MCP targets, and fail-closed selection before each repository-owned local CLI mutation. One small assertion owns Root/workdir/project/config checks; it executes no command and issues no certification verdict.

Causal Negative: The certified baseline ledger guard actually accepted the authenticated Founder ledger as though it were the Primary record, since it checked its set/history but never project identity (ledger-proof-fixed.log). Baseline Doctor accepted the copied Primary connector name and Platinum author while rejecting the correct Founder origin (baseline-doctor.log). Both repositories configured the same live ORVION stack and ports. These are reproduced inputs, not hypothetical search matches.

Focused revision evidence: test_founder_environment 153/0; installed CLI precedence probes 9/0; native DATABASE orchestration subset 7/0 (children explicitly stubbed); real local startup/status/253-ledger/parity/stop PASS with other container identities/states preserved. The old 526/0 Control, two 2994 pgTAP passes and 464 HTTP assertions remain historical prototype evidence. They do not certify revised bytes. Current full Finish remains mandatory after approval. The exact revision evidence packet is retained beside this Draft.

Positive Test Design: A nonempty actual Founder observation passes; preserved push-disabled receipt contexts remain readable; a clean correct Founder checkout is accepted with an unrelated commit author; isolated Doctor and idempotence succeed; matching or absent project/workdir overrides, normalized valid paths and loopback API URLs are accepted; foreign caller cwd cannot redirect explicitly rooted commands; the exact unchanged SQL surface and full behavioral protocol succeed on the separate stack; native receipts and trusted release judgments stay unchanged.

Negative Test Design: Refuse foreign/nonexistent SUPABASE_WORKDIR, conflicting explicit workdir, relative foreign cwd overrides, foreign Git roots/configurations, missing config and CLI-binary overrides before the stop/status/native capability boundary. No arbitrary caller arguments are forwarded into fixed CLI commands. Refuse wrong recorded project/URL/connector, duplicate/missing/wrong configured refs, stale or foreign histories, malformed/digest-mismatched/missing records, wrong fetch/push URLs, and bootstrap into an unrelated or dirty checkout. Preserve existing HTTP unreadability, SHA/branch/event/attempt/expected-workflow/literal-success refusals. Existing mismatching MCP definitions are reported and never silently overwritten.

Non-Empty Population Obligation: Establish the full nonempty ledger and independently read function/structural surfaces from Founder before any denial; establish a valid clean target fixture and successful allowed route before each target negative. Keep pgTAP on both sides of the HTTP writes.

Mutation Obligation: Remove the actual decommission assertion and prove forbidden nonempty input reaches an executable marker; independently neutralize workdir, project, configured identity and Git-origin predicates, restoring the guard before each allowed/refused comparison. No real destructive decommission is executed. Independently remove recorded project, read-URL and connector predicates and prove each forbidden fixture is admitted; independently exercise configured-URI and Git-direction predicate mutations, the native local-project override predicate and each HTTP target predicate; retain existing count/digest/full-identity/history mutations, watcher and receipt judgments. A failing fixture or zero population is never a mutation kill.

Post-Implementation Proof Obligation: Fresh timed/watched native Finish with every derived profile and Additional Verification command; independent live Review of exact scope, source invariants and R1–R12 evidence classes. A prerequisite or mandatory command that cannot run blocks completion. Prior SPEC-286 or prototype results never replace final SPEC-287 verification.

## Implementation Steps

1. Check that the new Founder bootstrap URL and its FOUNDER_PUSH_TARGET_MISMATCH guard are both present and the complete step payload matches the frozen implementation patch; if wholly applied, record Already Applied. Otherwise require the baseline source anchors below, revalidate Founder main, original SPEC-286 receipts, allocator eligibility and clean protected checkouts, require that the owner's exact Draft-to-Approved decision and subsequent In Progress transition have already been recorded under the native lifecycle before applying implementation. After all baseline anchors and native transitions have passed, apply the exact static patch once as one bounded delivery across the exhaustive Write Scope, excluding only the two generated projections as Notes requires. Do not apply overlapping partial file layers: Steps 2–4 validate their respective groups in this delivery and refresh only explicitly permitted measured/native fields. Already Applied skips static application only, never the fresh observation, lifecycle or verification obligations. Workstation behavior in that payload: Decommission must assert before confirmation/stop/removal, invoke only the installed pinned CLI with stop --project-id ORVION_FOUNDER --workdir validatedRoot, keep best-effort native stop failure reporting, and preserve other projects and shared credentials. No --all, --no-backup or real decommission test. Workstation payload: clone Founder into the Windows Documents/GitHub/ORVION location; reject unrelated fetch/push targets and dirt before pull/provision; use postgres-founder at local 57422, supabase-secondary at the exact Founder ref and the existing external github-secondary context. Preserve the existing provisioner's conflict refusal, Context7-equivalent transport and author/authentication distinction. Never rewrite an existing shared definition or delete user credentials. Perform provisioning/idempotence rehearsal only in an isolated profile; adoption of the owner's installed workstation remains a separate explicit owner action after certified source is available.
2. Check for the strict Founder binding block in check_primary_ledger.ps1, the Founder evidence default in both readers, and the whole step payload. If wholly applied, record static Already Applied; a partial or unexpected state stops rather than receiving layered repairs. Validate the exact reader/test/CI-filter payload from the frozen patch, retaining the historical primary-ledger-evidence.json unchanged. Capture a fresh authenticated supabase-secondary observation of get_project_url before and after an explicitly READ ONLY atomic ledger/function/structural SELECT. Use the unchanged canonical function expression and scripts/parity_surface.sql; no schema or data write. Record actual values, exact query, connector, URL, read time and current ancestor head in founder-ledger-evidence.json. The project must be brplkqmbzffpxqgkkdzo and all expected baseline surfaces must agree; any unexpected drift stops this step without repair. Refresh only these measured fields from that observation, never copy a Primary record or invent a live read. Keep all RECOVER-1, PAR-6, full-surface, L3/L5 and exit-code predicates. Add strict project/read-origin/configured-ref and repository-direction binding; keep legacy script/parameter names only as compatibility spelling, not target identity.
3. Check for ORVION_FOUNDER and the complete local consumer payload; if wholly applied record static Already Applied; otherwise stop the partial or unexpected delivery. Validate the exact payload. Set local project_id ORVION_FOUNDER, ports 57420–57429 as individually present in config.toml and inspector 8183; route every enumerated Docker/SQL/HTTP/generator/CI consumer to that stack. Use scripts/assert_founder_local.ps1 to resolve the exact Git top-level Founder root and root TOML project_id ORVION_FOUNDER. Refuse contradictory/nonexistent inherited SUPABASE_WORKDIR or explicit Workdir, non-Founder SUPABASE_PROJECT_ID, wrong origin/root/config, and any SUPABASE_CLI_BINARY_OVERRIDE before invoking the CLI. Preserve contradictory inputs for diagnosis; never silently clear them. Bind every reset/test/status/start/stop CLI call to the validated absolute --workdir; reset and test explicitly --local, stop explicitly --project-id ORVION_FOUNDER. Doctor checks this before its CLI version probe. Native capability checks before Docker, and each DATABASE child reasserts immediately before reset/test. CI Bash guards must fail the step on assertion failure, including always-cleanup; retain pinned-executable existence and best-effort native stop semantics. The six HTTP suites must check status exit success before parsing, use the pinned local executable, and reject before any HTTP/SQL write. The Batch 6 read-only selector uses only the exact Founder container and refuses its absence, never selects the first running project. Cleanup/prepare/bootstrap invoke no local Supabase runtime command and need no artificial CLI guard. Fixed Docker container consumers do not inherit workdir selection. Keep actual CLI selection proof distinct from executable-marker fixtures. Refuse each HTTP suite before its first request unless status.API_URL is http://127.0.0.1:57421 or http://localhost:57421 with an optional trailing slash. Verify exact config, absence of a hosted link, the allowed override and free isolated ports, then invoke the existing pinned CLI start with --workdir validatedRoot after the same assertion, before Finish. Keep API status/key discovery local and project-relative; preserve all SQL, HTTP assertions and the two-pass ordering. Retain original two-pass DATABASE ordering, child exit-code handling and certification judgments; the control fixture models target assertion only as a stub and the focused suite owns real target checks. Change only the capability registry's current hosted name/evidence note, leaving the validator as the single evidence judge and unknown capabilities fail-closed. Derive watcher repository from its own root and reject a non-Founder repository; preserve its SHA, branch, event, current-attempt, expected-workflow and literal-success judgments exactly. Do not edit publisher, promoter, transport or receipt format.
4. Check for ADR-0033, Founder current-state ownership, the two matching authority pins and the full documentation/projection payload. If wholly applied record static Already Applied; otherwise stop the partial or unexpected delivery. Validate its exact frozen payload. Preserve dated customer integration observations, completed contracts, migration SQL, SPEC-286 adopted object/parents and source receipts. Keep Primary evidence as historical provenance; put current Founder evidence in the existing evidence mechanism. Change only current operational catalog rules and applicability, not prior dated decisions. Keep product phase and Batch 6 states unchanged. Update Current Module and Next capability together with their GOVERNANCE pins, disposing their consumers as above; preserve the Batch 6 surface-coverage pin unchanged. Publish only measured Founder state with the existing full-function-surface hash / structural-surface hash labels. Regenerate ai-map.json and repository-index.md from their existing generator. Synchronize the governing CR/manifest active pointer through the native lifecycle; no competing programme state registry.
5. Check that Runtime Checkpoint is DONE, fresh native final receipt matches, independent Review is Confirmed Complete and all acceptance/review items hold; only then skip as Already Applied. Otherwise first reconcile each R1–R12 claim to its actual evidence class and required owner/runtime boundary. Use the existing timed runner and concurrent watcher for fresh Finish, which alone runs mandatory profiles and Additional Verification; do not duplicate its commands in an earlier step. Require every command's actual success, live independent Review against the repository and exact candidate preparation. Preserve all protected checkouts/receipts, historical source data, installed launchers, credentials, GitHub settings, hosted databases and CTRL-19 OPEN. Complete and locally prepare the exact candidate through existing native mechanisms. Stop before publication or promotion, and do not declare owner workstation adoption, a bare Windows installation, account isolation, external integrations, backups or full runtime production readiness without corresponding evidence.

## Acceptance Criteria

- [ ] Founder bootstrap selects the correct repository and refuses unexpected targets before modifying them. `check: has bootstrap.ps1 "https://Shehabhub@github.com/Shehabhub/ORVION.git"`
- [ ] Founder MCP selection and effective-definition diagnostics use the intended named context. `check: has .mcp.json "brplkqmbzffpxqgkkdzo"` `check: lacks .mcp.json "vrvtsxexkiiiivlkdxzp"`
- [ ] Target-selection is fail-closed before local maintenance and status discovery. `check: has scripts/assert_founder_local.ps1 "FOUNDER_LOCAL_WORKDIR_MISMATCH"` `check: has .workstation/decommission.ps1 "stop --project-id ORVION_FOUNDER --workdir"`
- [ ] Founder local database resources are independently named. `check: has supabase/config.toml "ORVION_FOUNDER"`
- [ ] The recorded Founder project is explicitly bound without altering the historical source record. `check: has reports/evidence/founder-ledger-evidence.json "brplkqmbzffpxqgkkdzo"` `check: same reports/evidence/primary-ledger-evidence.json @c362e417eca5496d4235bb0232f7fab9cfd5ac17`
- [ ] Focused positive/negative/mutation tests own the new project and Git binding behavior. `check: has scripts/test_founder_environment.ps1 "mutation killed"`
- [ ] Existing publisher, promoter, anonymous transport and structural surface remain exactly unchanged. `check: same scripts/publish_candidate.ps1 @c362e417eca5496d4235bb0232f7fab9cfd5ac17` `check: same scripts/promote_main.ps1 @c362e417eca5496d4235bb0232f7fab9cfd5ac17` `check: same scripts/github_public_read.ps1 @c362e417eca5496d4235bb0232f7fab9cfd5ac17` `check: same scripts/parity_surface.sql @c362e417eca5496d4235bb0232f7fab9cfd5ac17`
- [ ] SPEC-286 remains terminal and byte-identical. `check: same changes/SPEC-286-founder-initial-admission.md @c362e417eca5496d4235bb0232f7fab9cfd5ac17`
- [ ] The current operational sequence has one existing owning authority and preserves the product roadmap. `check: has reports/architecture-decision-records.md "ADR-0033"`
- [ ] Doctor separates commit author from authentication and cleanup/decommission preserve shared credentials; independent fresh-clone Windows configuration/recovery evidence and the limits of installed-tools versus bare-OS proof are recorded accurately.
- [ ] Every current routing consumer in scope follows the intended local/hosted/Git target; schema, RLS, function, structural and behavioral meanings remain unchanged; all final evidence is attributable to this implementation rather than a prior SPEC or prototype.

## Execution Log

None.

2026-10-17 — Owner-directed Gate 1 execution. Exact frozen Draft SHA-256 4a01717c3c139ade9e13ee6c5def1ee8dcd161d9c3a36a8e2195fa1e8ff9d27d, Git blob 1e70d95d5413536f0251c239cfe2ebede8802a4a, patch fd29e70bce884da4936213a2a1356bf2ece27962a5b0c61d96c60bc43d92cd90, all 43 baseline anchors and patch paths, remote Founder baseline, adopted parents, protected source/receipt/launcher identities and clean original checkouts revalidated. Native allocator cursor 286, next 287, not reserved. Native Draft origination Gate and real pre-commit hook passed; origin commit 6f09689b34a09d65e5393d42facee082ac02b060. Actual approval admission via timed check_agent_continuity.ps1 -Gate exited 1 after 00:00:36: MISSING_REQUIRED_CAPABILITY:github:PUBLIC_READ:TRANSPORT_UNREADABLE. Log: C:/Users/My Lab/Documents/ORVION-Owner-Review/spec-287-implementation-2026-10-17/approval-gate.log. Transport cause UNPROVEN; no authenticated fallback, guard or credential change. Per explicit owner stop condition, no approval commit, In Progress transition, patch application, hosted database read/write, Finish or publication occurred. Only this attempt's uncommitted transition/manifest/projection edits were returned byte-for-byte to their pre-transition state. Status remains Draft; exact approved frozen bytes remain in the origination commit and frozen packet. Resume: re-establish anonymous GitHub capability and retry native approval admission against the same owner-approved contract after revalidation; prior isolated admission does not substitute. Initial diagnostic allocator invocation used 287 rather than SPEC-287 and was corrected before any repository mutation; actual native allocator confirmed 287 available. Platinum and all protected originals remain unchanged.

## Verification Notes

None.

## Review Gate

- [ ] Every change matches the frozen steps and exact Write Scope; partial unexpected states were stopped.
- [ ] Current authority pins and all direct/transitive consumers agree; generated projections reproduce.
- [ ] All Acceptance Criteria hold and all mandatory profiles/Additional Verification are freshly satisfied.
- [ ] Independent Review verified original adopted history, native trust, receipts and fail-closed semantics against actual sources.
- [ ] Founder recovery/target/readiness claims name their actual evidence classes; missing external/runtime proof is not presented as PASS.
- [ ] Platinum, both hosted databases, credentials, installed owner launchers, security settings and retained original receipts remain unchanged; CTRL-19 stays OPEN.
- [ ] The exact local candidate is clean and releasable; publication and promotion await their separate owner gates.

## Notes

Baseline: c362e417eca5496d4235bb0232f7fab9cfd5ac17. Source anchors are Git blobs at that baseline; ABSENT means a creation, never overwrite unrelated work. The exact static implementation payload is `implementation.frozen.patch`, SHA-256 `fd29e70bce884da4936213a2a1356bf2ece27962a5b0c61d96c60bc43d92cd90` (209980 bytes), retained beside this frozen Draft. Verify the hash and the exhaustive path set before applying; it is data, not an executable substitute for the native lifecycle. Fresh recorded-evidence time/head/values and native CR/manifest synchronization are deterministically derived as Steps 2/4 specify. Apply static patch hunks with ai-map.json and repository-index.md excluded, preserving the already active CR pointer; regenerate those two projections under the native lifecycle instead of copying the PLAN projection. The manifest patch does not modify the active-pointer line. Generated projections are not independently authored. The preparation clone and its temporary commits are disposable, push-disabled and never certified implementation.

| Exact path | Baseline Git blob |
| --- | --- |
| .github/workflows/migration-ci.yml | 927cac7323b741b2ebcbe837b6ea4fb8da875211 |
| .github/workflows/orvion-acceptance.yml | ef99cb3d5438e667061a7c72afde52dbf7756359 |
| .github/workflows/repository-consistency.yml | e8c48a3f2f8a321ac951b5ed3bb2587e8551209f |
| .mcp.json | 392fbe2d46d7fea0a924a45093f5211e92806925 |
| .workstation/cleanup.ps1 | 301b78ce0fac74311d4f931ba88c8cf887b598f4 |
| .workstation/decommission.ps1 | 5a0e2bfe2352a7b467763676a65f67b9616120ec |
| .workstation/doctor.ps1 | 0ad69c87859646283c84e31df5732b2df1d42056 |
| .workstation/manifest.md | 02918cb45c79a5bc26f2041ee1390b25f4f95d35 |
| .workstation/prepare.ps1 | 667c14dc482e3d5c34d907e09bfca20c290fd5ed |
| ENGINEERING_METHOD.md | 6a5fdca1160d353647a01f0219db99d459a7f201 |
| GOVERNANCE.md | e6410811fdf618ab13d9654d82ab4d8af32d1c66 |
| WORKSTATION.md | 8dc0b895d2d73289eb3338249e6629d572e832c9 |
| _ORVION_CANONICAL/32_execution_roadmap.md | 2e32867e36a35b38eba7e68e33a27e2fb86e5ccb |
| _ORVION_CANONICAL/manifest.md | d6468e0937c9e0af7710dfe4be472ff7738b300f |
| ai-map.json | a768dfa3579d96f42906c3c065ebf74ba7e62eae |
| bootstrap.ps1 | 0a33f6d3544d1e72cdb62747cc1fca4d54811475 |
| reports/architecture-decision-records.md | 51a9424e22918785d4b9788a41aecf72a8735fa9 |
| reports/evidence/founder-ledger-evidence.json | ABSENT |
| reports/master/MASTER_CERTIFICATION_STATUS.md | e9c25d3e5a29a680fad1b607abfd81494666ecde |
| reports/master/MASTER_INTEGRATION_CATALOG.md | e1eb1e220916f3ea654f741b50da95f81b6cc621 |
| repository-index.md | d075792a248fc781d7012cc0296fcd8bc15a47d5 |
| scripts/assert_founder_local.ps1 | ABSENT |
| scripts/batch6_select_target.ps1 | 20e55b308088b4f5405029f02605915231246fbe |
| scripts/check_agent_continuity.ps1 | 9d46e4a37e22636cba730ae2a10a99f9d8b4fd35 |
| scripts/check_database_parity.ps1 | 9ab416c7e27532a2b9f4394871b28cc57d88f314 |
| scripts/check_database_parity_evidence.ps1 | ec3a28d1cd2990f070941e6d2501073a66225d85 |
| scripts/check_primary_ledger.ps1 | 56c09dd42e614bbef8e20b39fa8459a4f8485c36 |
| scripts/check_repository_consistency.ps1 | 3e6d2810e03bfac15b96dba3bc46d119d97ad658 |
| scripts/generate-ai-map.ps1 | 01165b8570999b79de4d6e854cae2443256e6b64 |
| scripts/generate-api-contract.ps1 | 8d7d1a7a4ec871745c2ecd2c03115496a772d030 |
| scripts/impact.ps1 | 612953ce3b11aff2b480e98cc2fb52a475311555 |
| scripts/test_agent_continuity.ps1 | f8020fb082d35617fac011779cb8a0fd4d2d01f3 |
| scripts/test_founder_environment.ps1 | ABSENT |
| scripts/test_primary_ledger_guard.ps1 | 62aa34b00760dbc79802e271c1c503365268190d |
| scripts/verify_api_end_to_end.ps1 | 27cb53aca4ef7cd34ca2d128ed1617d351dc748e |
| scripts/verify_care_journeys.ps1 | 6399cff3a41d52ab852ae8db23895c1f099ea62d |
| scripts/verify_customer_concurrency.py | 0cffcb8fceee9dc8e012236544c596a1e6613188 |
| scripts/verify_journey_branches.ps1 | 93daf45c046538c471799582380eb7d9ca6a70dd |
| scripts/verify_lifecycle_branches.ps1 | 4397047624bf0ae02f47fe3c5484891c9441c256 |
| scripts/verify_role_journeys.ps1 | 8a38474a9c752e32beca4ac3e237d204629edd08 |
| scripts/verify_storage_end_to_end.ps1 | 711e9c96712fe7d0c5526e4026f19351e5728989 |
| scripts/watch_ci.ps1 | ca87c18d3ac7fa62f70f5df681c5df18cf482699 |
| supabase/config.toml | f40d994133d50ee4f22a4e1a9578722c40fb37a4 |
