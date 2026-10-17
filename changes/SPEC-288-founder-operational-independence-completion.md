# Change Request — SPEC-288

## Status

[x] Draft
[ ] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Certify Founder operational independence by carrying cancelled SPEC-287's implemented payload forward unchanged except for four proven consumer corrections, then completing it through one fresh native Finish and independent Review.

## Business Reason

The owner authorized SPEC-287 and, on 2026-10-17, directed its recovery after its only final Finish stopped at a stale diagnostic consumer outside its frozen Write Scope. Isolated preflight of the commands that Finish never reached found one more stale consumer inside the payload, a method instruction its own guard refuses, and a tracked Claude Code expectation carrying rules the client never consults. This contract closes exactly those four and certifies the whole implemented payload, completing stage 2 of the ADR-0033 programme so controlled synchronization and, later, Phase 8 / Batch 6 product work can resume. It adds no mechanism, engine, evidence class or control plane.

## Risks

The DATABASE protocol, the six HTTP suites and workstation idempotence have not run against these bytes; SPEC-287's prototype evidence does not certify them and a failure there stops this contract for bounded recovery. Running the Founder stack beside another local stack can exhaust host memory; no non-Founder container may be stopped without the owner. WORKSTATION verification depends on the retained isolated CODEX_HOME named in Step 7 because the owner's installed Codex profile is deliberately not adopted. Claude Code `Edit(path)` ask rules cover its built-in file tools in sessions started at the repository root only; they are not an operating-system write barrier and never replace Write Scope, the Gate or approval. The owner's machine-local `.claude/settings.json` keeps its five never-consulted `Write(...)` entries until the owner removes them, because `.workstation/claude-awareness.ps1 -Apply` only adds. The anonymous GitHub capability fails intermittently: on 2026-10-17 the .NET client the reader uses stalled in connection setup on 6 of 30 and 1 of 30 requests while curl succeeded 30 of 30; the reader correctly fails closed with `github:PUBLIC_READ:TRANSPORT_UNREADABLE` and has no retry by design, so a refused transition or Finish is re-run unchanged under bounded recovery, never worked around. CTRL-19 remains OPEN.

## Supersedes / Depends On

- `changes/SPEC-287-founder-operational-independence.md` (Cancelled; this contract is its successor and carries its implemented 43-path payload, commits 6f09689b34a09d65e5393d42facee082ac02b060 through b7eaac0f8d20c8fa37f3c22f5c45346e35933211, forward unchanged except for the corrections below)
- Depends on terminal `changes/SPEC-286-founder-initial-admission.md` and its remotely certified candidate c362e417eca5496d4235bb0232f7fab9cfd5ac17.

## Write Scope

- .claude/awareness.json
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
- scripts/test_cold_start_state_guard.ps1
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
- .claude/hooks/session-state.ps1
- .workstation/claude-awareness.ps1
- scripts/publish_candidate.ps1
- scripts/promote_main.ps1
- scripts/github_public_read.ps1
- scripts/parity_surface.sql
- scripts/verify_database.sql
- scripts/verify_workstation_idempotence.ps1
- scripts/test_certification_receipts.ps1
- scripts/test_workstation.ps1
- scripts/watch_selftest.ps1
- reports/evidence/primary-ledger-evidence.json
- reports/master/MASTER_API_CONTRACT.md
- changes/SPEC-286-founder-initial-admission.md
- changes/SPEC-287-founder-operational-independence.md

The list above is not exhaustive; every engineering artifact outside Write Scope is forbidden. Of the 43 carried paths, only `ENGINEERING_METHOD.md` and `scripts/test_founder_environment.ps1` receive engineering edits, and `_ORVION_CANONICAL/manifest.md`, `ai-map.json` and `repository-index.md` change only through native lifecycle synchronization and the existing generator; every other carried path must stay byte-identical to b7eaac0f8d20c8fa37f3c22f5c45346e35933211. No migration SQL, pgTAP test, product schema, hosted data, GitHub setting, account, credential, installed external launcher, owner profile, machine-local `.claude/settings.json` or Platinum checkout may change. No publication or promotion is authorized by approval of this contract.

## Required Reading

- AGENTS.md
- CR_LIFECYCLE.md
- ENGINEERING_METHOD.md
- WORKSTATION.md
- changes/SPEC-287-founder-operational-independence.md
- scripts/test_cold_start_state_guard.ps1
- scripts/test_founder_environment.ps1
- scripts/check_primary_ledger.ps1
- .workstation/claude-awareness.ps1
- .claude/awareness.json

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Required Capabilities

- github
- docker
- supabase-local
- supabase-secondary

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
| Check 19 failure diagnostic now names Founder | scripts/test_cold_start_state_guard.ps1 | WRITE | SPEC-287 Finish 41 passed / 1 failed at E1 (cold-start-final.log); isolated corrected run 42 / 0 |
| Check 19 failure diagnostic now names Founder | scripts/check_repository_consistency.ps1 | VERIFY | Producer unchanged at b7eaac0; line 1698 emits the Founder text |
| Check 19 failure diagnostic now names Founder | scripts/check_agent_continuity.ps1 | VERIFY | CONTROL profile still runs the corrected suite; unchanged at b7eaac0 |
| Check 19 failure diagnostic now names Founder | scripts/check_database_parity_evidence.ps1 | UNAFFECTED | Its Founder message has no test consumer (git grep at b7eaac0) |
| Target-guard adjacency is read from CRLF working files | scripts/test_founder_environment.ps1 | WRITE | 146 passed / 7 failed on this checkout's CRLF bytes; 153 / 0 after normalizing its two source reads |
| Target-guard adjacency is read from CRLF working files | scripts/check_agent_continuity.ps1 and the six scripts/verify_*.ps1 suites | VERIFY | Read-only inputs to the suite; unchanged at b7eaac0 |
| Sandbox push-disable value | ENGINEERING_METHOD.md | WRITE | The method's `none` makes check_primary_ledger.ps1 report FOUNDER_REPOSITORY_MISMATCH; `DISABLED` leaves the guard CLEAN |
| Sandbox push-disable value | scripts/check_primary_ledger.ps1 | VERIFY | Accepts exactly `DISABLED` or the Founder URL (line 109); unchanged |
| Sandbox push-disable value | scripts/test_founder_environment.ps1 | VERIFY | Its fixtures already use `DISABLED` |
| Sandbox push-disable value | scripts/test_certification_receipts.ps1 | UNAFFECTED | Its `none` fixture stubs the consistency guard (line 120); 64 passed / 0 failed with ORVION_TIMED_LOG set as run_timed.ps1 sets it |
| Tracked Claude ask expectation | .claude/awareness.json | WRITE | Claude Code 2.1.302 warns at startup that each `Write(path)` rule is not matched; a Write-only rule set let an AGENTS.md edit through; Edit-only blocked Edit and Write tools on protected files and did not prompt for an ordinary file |
| Tracked Claude ask expectation | .workstation/claude-awareness.ps1 | VERIFY | Additive union; -Verify checks expected-subset-of-present, so the reduced expectation stays satisfied by existing machines; unchanged |
| Tracked Claude ask expectation | .workstation/doctor.ps1 and .workstation/prepare.ps1 | VERIFY | Call claude-awareness.ps1 -Verify / -Apply; unchanged |
| Tracked Claude ask expectation | WORKSTATION.md and .workstation/manifest.md | VERIFY | Describe the tracked expectation without listing rules; unchanged |
| Tracked Claude ask expectation | machine-local .claude/settings.json | UNAFFECTED | Gitignored, not repository content; removing its dead entries is an owner-local action |
| Carried SPEC-287 payload | the 43 SPEC-287 Write Scope paths | VERIFY | Byte-identical to b7eaac0 except the two edited files and lifecycle-synchronized manifest/projections; enforced by `check: same` criteria |
| Active Change Request pointer | _ORVION_CANONICAL/manifest.md, ai-map.json, repository-index.md | WRITE | Native lifecycle synchronization and scripts/generate-ai-map.ps1 only |
| Current Module / Next capability pins | _ORVION_CANONICAL/manifest.md | VERIFY | Pinned lines unchanged; GOVERNANCE.md §6 hashes hold |
| Cancelled predecessor | changes/SPEC-287-founder-operational-independence.md | VERIFY | Terminal; byte-identical to its cancellation commit |
| Preserved authorities | changes/SPEC-286-founder-initial-admission.md, scripts/publish_candidate.ps1, scripts/promote_main.ps1, scripts/github_public_read.ps1, scripts/parity_surface.sql | VERIFY | Byte-identical to c362e417eca5496d4235bb0232f7fab9cfd5ac17 |

Unresolved Material Consumers: None

### Execution-Boundary Satisfiability

Applicability: APPLICABLE

Irreversible Action Step: NONE

| Invariant | Required At | Red Opens After Step | Restored By Step | Mandatory Gate Before Step |
| --- | --- | --- | --- | --- |
| Cancelled predecessor terminal, carried payload byte-identical, legal allocation | BEFORE_IMPLEMENTATION | NONE | NONE | 1 |
| Every corrected consumer agrees with its producer | BEFORE_COMPLETION | 2 | 5 | 7 |
| Generated projections and authority pins reproduce | BEFORE_COMPLETION | 2 | 6 | 7 |
| Isolated WORKSTATION profile, started Founder stack, other projects untouched | BEFORE_COMPLETION | NONE | NONE | 7 |
| Native profiles, receipt, independent Review and clean exact candidate | BEFORE_COMPLETION | NONE | NONE | 7 |
| Platinum, hosted databases, original receipts and installed launchers unchanged | BEFORE_IMPLEMENTATION,BEFORE_COMPLETION | NONE | NONE | 7 |

### Permanent-Control Admission

Applicability: APPLICABLE

Existing Mechanism Reusable: YES

Existing Mechanism: SPEC-287's implemented controls, the cold-start guard-of-the-guard, the Founder environment suite, the Founder ledger guard, and Claude Code's own `Edit(path)` evaluation. No control is added; four existing consumers are brought into agreement with their producers.

Added Property: The two suites read their producers correctly under this repository's current diagnostic and its CRLF working-tree reality; the method states the push-disable value its guard accepts; the tracked ask expectation contains only rules Claude Code consults.

Causal Negative: SPEC-287 Finish failed cold-start E1 (41/1, cold-start-final.log). At b7eaac0 the Founder environment suite fails 7 adjacency checks on CRLF working files (146/7). The method's `none` push value makes the Founder ledger guard report FOUNDER_REPOSITORY_MISMATCH. Claude Code 2.1.302 reports each `Write(path)` ask rule as not matched, and a Write-only rule set admitted an AGENTS.md edit.

Positive Test Design: Corrected cold-start suite passes 42/0 including E-CONTROL; Founder environment passes 153/0; the guard is CLEAN with `DISABLED`; Edit-only ask rules still stop Edit and Write tools on protected files and leave ordinary files unprompted.

Negative Test Design: A swallowed delegated exit fails both E1 assertions; an unconditional Founder diagnostic with exit 0 fails E-CONTROL; a statement inserted between status discovery and target refusal, and one inserted before the local override predicate, fail exactly those two adjacency checks; the `none` push value is refused.

Non-Empty Population Obligation: The cold-start sandbox copy is CLEAN before any mutation (its CONTROL, FIRST); the controller and each of the six HTTP suites contain exactly one located predicate, or the suite throws its existing MOVED error.

Mutation Obligation: The certified suites carry their own E1, E2, E-CONTROL and target-predicate mutations; the prototype mutations named in Notes are evidence for this Draft only and never replace them.

Post-Implementation Proof Obligation: One fresh timed and watched native Finish with every derived profile and every Additional Verification command, followed by independent live Review. No SPEC-287 or prototype result substitutes for either.

## Implementation Steps

1. Check that `changes/SPEC-287-founder-operational-independence.md` records Status Cancelled and that `git diff --quiet b7eaac0f8d20c8fa37f3c22f5c45346e35933211 HEAD --` over every Write Scope path except `.claude/awareness.json`, `scripts/test_cold_start_state_guard.ps1`, `ENGINEERING_METHOD.md`, `scripts/test_founder_environment.ps1`, `_ORVION_CANONICAL/manifest.md`, `ai-map.json` and `repository-index.md` exits 0. If both hold, record the carried payload Already Applied; if either fails, stop and report without any write. This step writes nothing.
2. Check whether `scripts/test_cold_start_state_guard.ps1` contains `Founder ledger evidence is ABSENT, STALE or DISAGREES` and no `Primary ledger evidence`; if so record Already Applied. If exactly one of them holds, stop. Otherwise replace exactly these two lines and nothing else (the patch `proposed-cold-start-compatibility.patch`, SHA-256 57ce24fd42138c86baa86adcc993c470cada96041a63e8e2325c921be5b1c352, is the same change):

   ```powershell
           ($code -eq 0 -and $out -notmatch 'Primary ledger evidence is ABSENT') "exit=$code"
           ($out -match 'Primary ledger evidence is ABSENT, STALE or DISAGREES')
   ```

   with

   ```powershell
           ($code -eq 0 -and $out -notmatch 'Founder ledger evidence is ABSENT') "exit=$code"
           ($out -match 'Founder ledger evidence is ABSENT, STALE or DISAGREES')
   ```

   Every exit-code, missing-guard and other assertion stays byte-identical.
3. Check whether both source reads below in `scripts/test_founder_environment.ps1` already end with the newline normalization; if both do record Already Applied, if only one does stop. Otherwise change exactly these two lines and nothing else:

   ```powershell
       $controller=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'check_agent_continuity.ps1'))
           $httpSource=[IO.File]::ReadAllText((Join-Path $PSScriptRoot $name))
   ```

   to

   ```powershell
       $controller=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'check_agent_continuity.ps1')).Replace("`r`n","`n")
           $httpSource=[IO.File]::ReadAllText((Join-Path $PSScriptRoot $name)).Replace("`r`n","`n")
   ```

   Every assertion, AST probe and mutation in the suite stays byte-identical.
4. Check whether `ENGINEERING_METHOD.md` contains `git remote set-url --push origin DISABLED` and not `git remote set-url --push origin none`; if so record Already Applied. Otherwise replace the single occurrence of `git remote set-url --push origin none` with `git remote set-url --push origin DISABLED` and change nothing else.
5. Check whether `.claude/awareness.json` contains no `Write(`; if so record Already Applied. Otherwise remove exactly the five entries `"Write(AGENTS.md)"`, `"Write(GOVERNANCE.md)"`, `"Write(README.md)"`, `"Write(CR_LIFECYCLE.md)"` and `"Write(_ORVION_CANONICAL/**)"` from `permissions.ask`, so that the array holds exactly, in this order, `"Edit(AGENTS.md)"`, `"Edit(GOVERNANCE.md)"`, `"Edit(README.md)"`, `"Edit(CR_LIFECYCLE.md)"`, `"Edit(_ORVION_CANONICAL/**)"`, with the last entry carrying no trailing comma. Keep `_comment`, `_authority`, `hooks`, `deny`, key order, indentation and line endings unchanged.
6. Check whether the Runtime Checkpoint reads `Resume Step: DONE`; if so record Already Applied. Otherwise run `pwsh -NoProfile -File scripts/generate-ai-map.ps1`, confirm `pwsh -NoProfile -File scripts/generate-ai-map.ps1 -Check` exits 0 and that `git diff --name-only` names only Write Scope paths, append the Execution Log entry, set the Runtime Checkpoint to `Resume Step: DONE`, `Blocker: None`, `Recovery Attempt: 0`, and commit the implementation and checkpoint together through the unchanged pre-commit hook.
7. Check that a fresh native final receipt matches, a `Verdict: Confirmed Complete` Verification Notes entry exists and every Acceptance Criterion and Review Gate item holds; only then record Already Applied. Otherwise, from the repository root: require `C:\Users\My Lab\Documents\ORVION-Owner-Review\spec-287-implementation-2026-10-17\isolated-codex-home\config.toml` to exist with SHA-256 eb4b119fbdc772992f16546dfab255c4f3699ca684468f13804387ab232e2e5d, else stop; snapshot the IDs, names and states of all Docker containers; if the host cannot hold the Founder stack beside containers already running, stop and ask the owner before any non-Founder container is stopped; run `. ./scripts/assert_founder_local.ps1; $founderRoot = Assert-FounderLocalTarget -Root (Get-Location).Path; node_modules/.bin/supabase.cmd start --workdir "$founderRoot"` and require exit 0 with API 57421 and DB 57422 local. Then, in one PowerShell process that has `$env:CODEX_HOME` set to that isolated directory, start `pwsh -NoProfile -File scripts/run_timed.ps1 -Log <log> -Command "pwsh -NoProfile -File scripts/check_agent_continuity.ps1 -Finish"` and, at the same time, `pwsh -NoProfile -File scripts/watch_run.ps1 -Log <log> -Run spec-288-finish -Brief`. Require `LOCAL_CERTIFY: READY`; any failed command keeps its real exit code and evidence and starts bounded recovery without weakening an assertion. After Finish, stop only the Founder stack with `. ./scripts/assert_founder_local.ps1; $founderRoot = Assert-FounderLocalTarget -Root (Get-Location).Path; node_modules/.bin/supabase.cmd stop --project-id ORVION_FOUNDER --workdir "$founderRoot"` (volumes kept, no `--all`, no `--no-backup`) and require every other container to equal the snapshot. Perform independent live Review against the repository, append its Verification Notes verdict, complete through the native lifecycle, and locally prepare the exact candidate with `pwsh -NoProfile -File scripts/check_agent_continuity.ps1 -Gate -BindCandidate -Root <original-checkout> -BaseRef <full-main-SHA> -HeadRef <full-candidate-SHA>`. Stop before publication or promotion.

## Acceptance Criteria

- [ ] The cancelled predecessor stays terminal and byte-identical to its cancellation. `check: same changes/SPEC-287-founder-operational-independence.md @ea4feb4ae1e168b31a27eca3ef694c5d1dd1987f`
- [ ] Carried workflow, workstation, bootstrap and stack-configuration paths are unchanged from the SPEC-287 implementation. `check: same .github/workflows/migration-ci.yml @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same .github/workflows/orvion-acceptance.yml @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same .github/workflows/repository-consistency.yml @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same .mcp.json @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same .workstation/cleanup.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same .workstation/decommission.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same .workstation/doctor.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same .workstation/manifest.md @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same .workstation/prepare.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same bootstrap.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same supabase/config.toml @b7eaac0f8d20c8fa37f3c22f5c45346e35933211`
- [ ] Carried authority, evidence and report paths are unchanged from the SPEC-287 implementation. `check: same GOVERNANCE.md @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same WORKSTATION.md @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same _ORVION_CANONICAL/32_execution_roadmap.md @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same reports/architecture-decision-records.md @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same reports/evidence/founder-ledger-evidence.json @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same reports/master/MASTER_CERTIFICATION_STATUS.md @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same reports/master/MASTER_INTEGRATION_CATALOG.md @b7eaac0f8d20c8fa37f3c22f5c45346e35933211`
- [ ] Carried scripts are unchanged from the SPEC-287 implementation. `check: same scripts/assert_founder_local.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/batch6_select_target.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/check_agent_continuity.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/check_database_parity.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/check_database_parity_evidence.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/check_primary_ledger.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/check_repository_consistency.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/generate-ai-map.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/generate-api-contract.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/impact.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/test_agent_continuity.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/test_primary_ledger_guard.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/verify_api_end_to_end.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/verify_care_journeys.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/verify_customer_concurrency.py @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/verify_journey_branches.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/verify_lifecycle_branches.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/verify_role_journeys.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/verify_storage_end_to_end.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211` `check: same scripts/watch_ci.ps1 @b7eaac0f8d20c8fa37f3c22f5c45346e35933211`
- [ ] The cold-start guard-of-the-guard reads the Founder diagnostic in both directions. `check: has scripts/test_cold_start_state_guard.ps1 "Founder ledger evidence is ABSENT, STALE or DISAGREES"` `check: lacks scripts/test_cold_start_state_guard.ps1 "Primary ledger evidence"`
- [ ] The Founder environment suite normalizes both adjacency sources before parsing. `check: has scripts/test_founder_environment.ps1 "'check_agent_continuity.ps1')).Replace("` `check: has scripts/test_founder_environment.ps1 "ReadAllText((Join-Path $PSScriptRoot $name)).Replace("`
- [ ] The method's sandbox instruction uses the push value the Founder guard accepts. `check: has ENGINEERING_METHOD.md "git remote set-url --push origin DISABLED"` `check: lacks ENGINEERING_METHOD.md "git remote set-url --push origin none"`
- [ ] The tracked Claude expectation keeps its Edit ask rules and deny rules and carries no never-consulted Write path rule. `check: lacks .claude/awareness.json "Write("` `check: has .claude/awareness.json "Edit(_ORVION_CANONICAL/**)"` `check: has .claude/awareness.json "mcp__claude_ai_Supabase__restore_project"`
- [ ] Preserved authorities remain byte-identical to the certified Founder baseline. `check: same changes/SPEC-286-founder-initial-admission.md @c362e417eca5496d4235bb0232f7fab9cfd5ac17` `check: same scripts/publish_candidate.ps1 @c362e417eca5496d4235bb0232f7fab9cfd5ac17` `check: same scripts/promote_main.ps1 @c362e417eca5496d4235bb0232f7fab9cfd5ac17` `check: same scripts/github_public_read.ps1 @c362e417eca5496d4235bb0232f7fab9cfd5ac17` `check: same scripts/parity_surface.sql @c362e417eca5496d4235bb0232f7fab9cfd5ac17` `check: same reports/evidence/primary-ledger-evidence.json @c362e417eca5496d4235bb0232f7fab9cfd5ac17`
- [ ] Founder target, recovery and readiness claims name their actual evidence classes; owner workstation adoption, bare Windows recovery, credential isolation, backups and external production integrations are not claimed.

## Execution Log

None.

## Verification Notes

None.

## Review Gate

- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [ ] No file outside Write Scope was modified, created, or deleted, and every carried path other than the two edited files and the synchronized projections equals b7eaac0.
- [ ] Every Acceptance Criteria item is confirmed true against the live repository.
- [ ] Every derived profile and every Additional Verification command passed in the one fresh native Finish; no prior SPEC-287 or prototype result was substituted.
- [ ] The cancelled predecessor is named in Supersedes / Depends On and remains terminal and unchanged.
- [ ] Platinum, both hosted databases, credentials, installed owner launchers, owner profiles, other projects' containers and retained original receipts remain unchanged; CTRL-19 stays OPEN.
- [ ] The exact local candidate is clean and releasable; publication and promotion await their separate owner gates.

## Notes

Baseline: SPEC-287 implementation head b7eaac0f8d20c8fa37f3c22f5c45346e35933211 on remote Founder main c362e417eca5496d4235bb0232f7fab9cfd5ac17. Git blobs at b7eaac0 of the four edited files: scripts/test_cold_start_state_guard.ps1 fe24d2775e9482c063dcf59e859f2c1fc4cd3a71, scripts/test_founder_environment.ps1 84901fb6e3d9030c189c5c5558b8484f58e601c8, ENGINEERING_METHOD.md 04e833c2ef90a6eedd30a0324aab304e356f91c5, .claude/awareness.json a1a9eacde186eaf89603a0bd426c3c42ed0b182f.

Prototype evidence, from disposable clones of b7eaac0 with push URL `DISABLED`; it informs this Draft and certifies nothing. Corrected cold-start suite 42/0; mutation that swallows the delegated exit: both E1 assertions fail (40/2); mutation printing the Founder diagnostic with exit 0: E-CONTROL fails (41/1). Founder environment 153/0 after normalization; a statement inserted at each adjacency site fails exactly those two checks. Not-reached SPEC-287 commands on the corrected clone: test_status_contradiction_guard 33/0, test_primary_ledger_guard 13/0, test_future_date_guard 18/0, check_repository_consistency CLEAN, git diff --check clean, test_workstation 13/0, watch_selftest 57/0, test_certification_receipts 64/0 (with ORVION_TIMED_LOG set). Read-only Doctor in the Founder checkout passes with the isolated CODEX_HOME and reports Codex postgres-founder mismatched in the owner's installed profile, which is not adopted. Claude Code 2.1.302 probe with Founder's real settings: no ask rule and Write-only rules both admit an AGENTS.md edit; current and Edit-only rules stop Edit on AGENTS.md and the canonical glob and stop the Write tool on AGENTS.md; an ordinary file is not prompted; a session started in `scripts/` is not protected with either bare or `/`-anchored patterns. The native lifecycle of this contract, from the cancellation commit through simulated completion, was rehearsed in disposable clones: origination, approval (APPROVAL_EVIDENCE: PASS; 9 of 10 criteria Gate-checked), In Progress and implementation commits passed the real pre-commit hook, and the range Gate read READY over c362e417eca5496d4235bb0232f7fab9cfd5ac17 to the simulated completion both locally and with GitHub Actions variables set. The same lifecycle with Supersedes / Depends On set to None was refused CANCELLED_SEGMENT_NOT_CARRIED, and a deliberately botched Step 3 edit was refused CRITERION_CHECK_FAILED at criterion 6.

Not proven before approval: the DATABASE protocol, the six HTTP suites and workstation idempotence on these bytes; they run only in Step 7's Finish. The cause of the intermittent .NET connection stall to api.github.com is UNPROVEN beyond its phase; changing the protected reader would need its own approved contract.

Rejected alternatives: widening the Approved SPEC-287 scope (forbidden by frozen authority); a scope without the carried 43 paths (Finish would derive only REPOSITORY and CONTROL and the receipt fingerprint would not bind the implemented payload); making the Founder guard accept `none` (control-code and test change where one documentation token suffices); a `.gitattributes` end-of-line policy (repository-wide churn for a two-line suite defect); `/`-anchored ask rules (no observed protection gain); a new awareness verifier rule rejecting `Write(path)` entries (Claude Code already warns at every session start); pruning the owner's machine-local settings by script (`claude-awareness.ps1` is additive by design and that file is not repository content).

Owner-local and optional after approval: delete the five `Write(...)` lines from the gitignored `.claude/settings.json` to silence the startup warnings; the `Edit(...)` rules already present keep the protection.
