# Change Request — SPEC-289

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

## Objective

Certify Founder operational independence by carrying cancelled SPEC-288's implemented payload forward unchanged, repairing the native Gate's whole-file `check: same` comparison with control tests, and correcting the Founder public-reader suite that SPEC-287's watcher pin left stale, then completing through one fresh native Finish and independent Review.

## Business Reason

SPEC-288's only Finish earned LOCAL_CERTIFY: READY at a64916975725d67a4069d5bfc94c2140cca765bb, but its Complete commit was refused by the unchanged pre-commit hook: in working-tree mode a whole-file `check: same` compares `git show` text, which drops the final newline, with the working file, which keeps it, so it can never hold, and in range mode both sides lose the newline, so a changed final newline is never seen. The repair lies in `scripts/check_agent_continuity.ps1`, which SPEC-288's frozen criteria required to stay unchanged. Sandbox preflight then found that `scripts/test_github_public_read.ps1`, outside SPEC-288's scope, fails 8 of 76 cases since SPEC-287 pinned `scripts/watch_ci.ps1` to Founder, and that its live cases read the Platinum-owned sandbox. This contract closes exactly those three and certifies the whole payload, completing stage 2 of the ADR-0033 programme. It adds no mechanism, engine, evidence class or control plane.

## Risks

The DATABASE protocol, the six HTTP suites and workstation idempotence run only in this contract's Finish; sandbox evidence does not certify them. The Gate change alters how every whole-file `check: same` is judged; only cancelled SPEC-287 and SPEC-288 use that form, so no completed contract's verdict changes, and keyed `same`, `has`, `lacks` and `blob` checks keep their code path. A changed final newline or line-ending-only edit is now refused where it was silently admitted. Running the Founder stack beside another local stack can exhaust host memory; no non-Founder container may be stopped without the owner. WORKSTATION verification depends on the retained isolated CODEX_HOME named in Step 6. The anonymous GitHub capability fails intermittently with `github:PUBLIC_READ:TRANSPORT_UNREADABLE`; a refused transition or Finish is re-run unchanged under bounded recovery, never worked around. CTRL-19 remains OPEN.

## Supersedes / Depends On

- `changes/SPEC-288-founder-operational-independence-completion.md` (Cancelled; this contract is its successor and carries its implemented 45-path payload at a64916975725d67a4069d5bfc94c2140cca765bb forward unchanged except for the corrections below)
- `changes/SPEC-287-founder-operational-independence.md` (Cancelled at ea4feb4ae1e168b31a27eca3ef694c5d1dd1987f; its payload reached this contract through SPEC-288 and neither has been published)
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
- scripts/test_github_public_read.ps1
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
- .githooks/pre-commit
- .github/workflows/agent-control.yml
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
- changes/SPEC-288-founder-operational-independence-completion.md

The list above is not exhaustive; every engineering artifact outside Write Scope is forbidden. Of the 46 paths, only `scripts/check_agent_continuity.ps1`, `scripts/test_agent_continuity.ps1` and `scripts/test_github_public_read.ps1` receive engineering edits, and `_ORVION_CANONICAL/manifest.md`, `ai-map.json` and `repository-index.md` change only through native lifecycle synchronization and the existing generator; every other path must stay byte-identical to a64916975725d67a4069d5bfc94c2140cca765bb. No migration SQL, pgTAP test, product schema, hosted data, GitHub setting, account, credential, installed external launcher, owner profile, machine-local `.claude/settings.json` or Platinum checkout may change. No publication or promotion is authorized by approval of this contract.

## Required Reading

- AGENTS.md
- CR_LIFECYCLE.md
- ENGINEERING_METHOD.md
- changes/SPEC-288-founder-operational-independence-completion.md
- scripts/check_agent_continuity.ps1
- scripts/test_agent_continuity.ps1
- scripts/test_github_public_read.ps1
- scripts/watch_ci.ps1

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Required Capabilities

- github
- docker
- supabase-local
- supabase-secondary

## Additional Verification

- pwsh -NoProfile -File scripts/test_github_public_read.ps1
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
| Whole-file `check: same` is judged by Git blob | scripts/check_agent_continuity.ps1 Validate-TransitionEvidence (hook Complete) | WRITE | Unchanged Gate refuses SPEC-288's exact Complete state at criterion 1 in the sandbox real hook; patched Gate holds all 54 SPEC-288 checks on its real tree |
| Whole-file `check: same` is judged by Git blob | scripts/check_agent_continuity.ps1 range Gate (Test-CriterionCheck with a tree ref) | VERIFY | Blob against blob; unchanged files still hold, a removed final newline now fails (281-C10, 281-C11) |
| Whole-file `check: same` is judged by Git blob | scripts/check_agent_continuity.ps1 Assert-AssuranceAdmission same/same clash | WRITE | Same blob identity as the evaluator, so Approval and Complete agree |
| Working-tree blob of an unchanged tracked file | scripts/check_agent_continuity.ps1 Get-RepoBlob and its `blob` checks | WRITE | Index blob when Git reports the file unchanged; `hash-object` otherwise; a CRLF blob under core.autocrlf=true now holds (281-C13) |
| Keyed `check: same`, `has`, `lacks` | scripts/check_agent_continuity.ps1 | VERIFY | Code path unchanged; full suite passes |
| Existing whole-file `same` population | changes/SPEC-287-*.md, changes/SPEC-288-*.md | UNAFFECTED | Only users of the form (git grep at a649169); both Cancelled, never judged at Complete again |
| Gate behaviour under test | scripts/test_agent_continuity.ps1 | WRITE | Seven cases 281-C9 to 281-C13, 281-CM4, 281-CM5; the unchanged evaluator fails six, the seventh is a positive control |
| Gate behaviour under test | .github/workflows/agent-control.yml and orvion-acceptance.yml | VERIFY | Run the same suite unchanged |
| Watcher serves Founder only (SPEC-287) | scripts/test_github_public_read.ps1 | WRITE | 68 passed / 8 failed at a649169 (FOUNDER_REPOSITORY_MISMATCH and the cascade it leaves in the fixture queue); 76 / 0 with the watcher cases given the Founder identity |
| Live public-reader fixture | scripts/test_github_public_read.ps1 -Live | WRITE | Reads Founder's own public sandbox Shehabhub/orvion-sandbox; 82 / 0 live |
| Live public-reader fixture | Shehabhub/orvion-sandbox | VERIFY | Public, synthetic, no secrets; runs 39072571955 (success) and 39072554091 (failure, job 117512987802) are pinned; its ruleset protects main |
| Live public-reader fixture | scripts/github_public_read.ps1 and scripts/watch_ci.ps1 | VERIFY | Unchanged at c362e41 and a649169 |
| Carried SPEC-288 payload | the 40 other Write Scope paths | VERIFY | Byte-identical to a649169; enforced by `check: same` criteria |
| Active Change Request pointer | _ORVION_CANONICAL/manifest.md, ai-map.json, repository-index.md | WRITE | Native lifecycle synchronization and scripts/generate-ai-map.ps1 only |
| Current Module / Next capability pins | _ORVION_CANONICAL/manifest.md | VERIFY | Pinned lines unchanged; GOVERNANCE.md §6 hashes hold |
| Cancelled predecessors | changes/SPEC-287-*.md, changes/SPEC-288-*.md | VERIFY | Terminal; SPEC-287 byte-identical to ea4feb4 |
| Preserved authorities | changes/SPEC-286-founder-initial-admission.md, scripts/publish_candidate.ps1, scripts/promote_main.ps1, scripts/github_public_read.ps1, scripts/parity_surface.sql | VERIFY | Byte-identical to c362e417eca5496d4235bb0232f7fab9cfd5ac17 |

Unresolved Material Consumers: None

### Execution-Boundary Satisfiability

Applicability: APPLICABLE

Irreversible Action Step: NONE

| Invariant | Required At | Red Opens After Step | Restored By Step | Mandatory Gate Before Step |
| --- | --- | --- | --- | --- |
| Cancelled predecessors terminal, carried payload byte-identical, legal allocation | BEFORE_IMPLEMENTATION | NONE | NONE | 1 |
| The evaluator and its control tests agree | BEFORE_COMPLETION | 2 | 3 | 6 |
| The public-reader suite agrees with the Founder-only watcher | BEFORE_COMPLETION | NONE | NONE | 6 |
| Generated projections and authority pins reproduce | BEFORE_COMPLETION | 2 | 5 | 6 |
| Isolated WORKSTATION profile, started Founder stack, other projects untouched | BEFORE_COMPLETION | NONE | NONE | 6 |
| Native profiles, receipt, independent Review and clean exact candidate | BEFORE_COMPLETION | NONE | NONE | 6 |
| Platinum, hosted databases, original receipts and installed launchers unchanged | BEFORE_IMPLEMENTATION,BEFORE_COMPLETION | NONE | NONE | 6 |

### Permanent-Control Admission

Applicability: APPLICABLE

Existing Mechanism Reusable: YES

Existing Mechanism: The existing `check: same` criterion evaluator, judged with the Git blob identity its own `blob` check already uses, and the existing CHECK family of `scripts/test_agent_continuity.ps1`. No control, check kind or evidence class is added.

Added Property: A whole-file `check: same` holds exactly when the file's Git blob equals the blob at the named commit, in the hook and in the range alike; an unchanged tracked file is judged by its index blob.

Causal Negative: In the sandbox real hook the unchanged Gate refuses SPEC-288's exact Complete state with CRITERION_CHECK_FAILED at criterion 1. Against the unchanged evaluator 281-C9, 281-C11, 281-C12 and 281-C13 fail and the 281-CM4 and 281-CM5 anchors do not exist. A 134-case real-Git harness (line endings, final newline, Unicode and BOM, missing files, staged against working tree, attributes, CRLF already in the index) gave 50 unexpected results before the change.

Positive Test Design: An unchanged file holds a whole-file same in the hook (281-C9) and the range (281-C10); an unchanged CRLF blob holds under core.autocrlf=true (281-C13); all 54 SPEC-288 checks hold on its real tree.

Negative Test Design: A removed final newline fails a whole-file same in the range (281-C11) and the hook (281-C12); the same harness leaves 5 unexpected results, all one keyed-check BOM edge identical before and after, and no tracked Founder file carries a BOM.

Non-Empty Population Obligation: The CHECK family's accept, reject and mutation populations are each non-empty, asserted by the suite's existing population check.

Mutation Obligation: 281-CM4 restores text comparison for whole-file same and 281-CM5 removes the index-blob branch; each pristine run reaches the receipt prerequisite and each mutant does not.

Post-Implementation Proof Obligation: One fresh timed and watched native Finish with every derived profile and every Additional Verification command, followed by independent live Review and the native Complete commit through the unchanged hook. No SPEC-288 or sandbox result substitutes for either.

## Implementation Steps

1. Check that `changes/SPEC-288-founder-operational-independence-completion.md` and `changes/SPEC-287-founder-operational-independence.md` both record Status Cancelled and that `git diff --quiet a64916975725d67a4069d5bfc94c2140cca765bb HEAD --` over every Write Scope path except `scripts/check_agent_continuity.ps1`, `scripts/test_agent_continuity.ps1`, `scripts/test_github_public_read.ps1`, `_ORVION_CANONICAL/manifest.md`, `ai-map.json` and `repository-index.md` exits 0. If both hold, record the carried payload Already Applied; if either fails, stop and report without any write. This step writes nothing.
2. Check whether `scripts/check_agent_continuity.ps1` contains `if($Check.Kind-eq'same'-and-not$Check.Key){`; if so record Already Applied. Otherwise make exactly these three replacements and nothing else. In Get-RepoBlob replace

   ```powershell
       $b=if($Ref){git -C $Root rev-parse "${Ref}:$Path" 2>$null}else{$f=Join-Path $Root $Path;if(Test-Path -LiteralPath $f){git -C $Root hash-object -- $f 2>$null}}
   ```

   with

   ```powershell
       $b=if($Ref){git -C $Root rev-parse "${Ref}:$Path" 2>$null}else{$f=Join-Path $Root $Path;if(Test-Path -LiteralPath $f){
           # A tracked file Git sees as unchanged is its index blob: hash-object alone re-normalizes a CRLF blob that `git add` keeps.
           git -C $Root diff --quiet -- $Path 2>$null;if($LASTEXITCODE-eq0-and(git -C $Root ls-files -- $Path)){git -C $Root rev-parse ":$Path" 2>$null}else{git -C $Root hash-object -- $f 2>$null}}}
   ```

   In Test-CriterionCheck replace the line `    if($Check.Kind-eq'same'){` with

   ```powershell
       if($Check.Kind-eq'same'-and-not$Check.Key){
           # A whole file is its Git blob, as `blob` judges it: `git show` text loses the final newline
           # and the working tree's line endings, so a text comparison could never hold in the hook.
           $was=Get-RepoBlob $Check.Ref $Check.Path
           if(-not$was){return "$where does not exist at $($Check.Ref)"}
           if($was-ne(Get-RepoBlob $Ref $Check.Path)){return "$where differs from $($Check.Ref)"}
       }
       if($Check.Kind-eq'same'-and$Check.Key){
   ```

   In Assert-AssuranceAdmission replace

   ```powershell
               'same/same'{-not(Same-Text "$(Get-CheckTarget $a $a.Ref)" "$(Get-CheckTarget $b $b.Ref)")}
   ```

   with

   ```powershell
               'same/same'{if($a.Key){-not(Same-Text "$(Get-CheckTarget $a $a.Ref)" "$(Get-CheckTarget $b $b.Ref)")}else{(Get-RepoBlob $a.Ref $a.Path)-ne(Get-RepoBlob $b.Ref $b.Path)}}
   ```

   The resulting file's Git blob is e2892807371ca52d071a61a41e7ebc9706978fe6.
3. Check whether `scripts/test_agent_continuity.ps1` contains `281-CM5 CHECK MUTATION: an unchanged file is its index blob`; if so record Already Applied. Otherwise insert exactly the following lines immediately after the line `        'if($why){throw "CRITERION_CHECK_FAILED' 'if($false){throw "CRITERION_CHECK_FAILED' 'CHECK'`, and change nothing else:

   ```powershell
       # A whole-file `same` is the file's Git blob. Compared as text, `git show` lost the final newline,
       # so the hook refused every unchanged file (SPEC-288 could not complete) and neither mode saw a
       # changed final newline. Reaching the receipt prerequisite proves the criterion stage passed.
       # ChLife re-commits the unchanged base, so its returned text carries git's "nothing to commit".
       function ChWhole([string]$Rel='notes.md',[string]$Scope=$chPlain,[scriptblock]$Mid={},[switch]$Open){
           $b=ChBase;ChLife @{Scope=$Scope;Acceptance="$Rel is unchanged. ``check: same $Rel @$b``"} -NoReset -Mid $Mid -Open:$Open|Out-Null;$b
       }
       $atReceipt='CODE: COMPLETION_PREREQUISITE[\s\S]*no local certification receipt'
       ChWhole -Open|Out-Null;Put '_ORVION_CANONICAL/manifest.md' (ManifestText 'None.');$r=Run 'Gate'
       Assert '281-C9 CHECK: an unchanged file holds a whole-file same in the hook' ($r.Text-notmatch'CRITERION_CHECK_FAILED'-and$r.Text-match$atReceipt) $r.Text
       Pop 'CHECK' 'accept'
       $b=ChWhole;$r=RunRange $b
       Assert '281-C10 CHECK: the same completion is READY in the range' ($r.Code-eq0-and$r.Text-match'ORVION: READY') $r.Text
       Pop 'CHECK' 'accept'
       $newline={Put 'notes.md' 'Agents read the Release channel line before a release.';Commit 'ch-newline'}
       $b=ChWhole -Scope "notes.md;$chPlain" -Mid $newline;$r=RunRange $b
       Assert '281-C11 CHECK: a removed final newline fails a whole-file same in the range' ($r.Code-ne0-and$r.Text-match'CRITERION_CHECK_FAILED.*notes\.md differs') $r.Text
       Pop 'CHECK' 'reject'
       ChWhole -Scope "notes.md;$chPlain" -Open|Out-Null;Put 'notes.md' 'Agents read the Release channel line before a release.';Put '_ORVION_CANONICAL/manifest.md' (ManifestText 'None.');$r=Run 'Gate'
       Assert '281-C12 CHECK: the same change fails it in the hook' ($r.Code-ne0-and$r.Text-match'CODE: CRITERION_CHECK_FAILED') $r.Text
       Pop 'CHECK' 'reject'
       # An unchanged file is its index blob: under core.autocrlf=true hash-object alone re-normalizes a
       # CRLF blob that `git add` keeps, and would refuse it.
       $crlf={ChBase|Out-Null;git -C $root config core.autocrlf true;Put 'crlf.txt' "a`r`nb`r`n";git -C $root -c core.autocrlf=false add crlf.txt;git -C $root commit -m 'ch-crlf' --quiet
           $b=(git -C $root rev-parse HEAD).Trim();ChLife @{Scope=$chPlain;Acceptance="crlf.txt is unchanged. ``check: same crlf.txt @$b``"} -NoReset -Open|Out-Null;Put '_ORVION_CANONICAL/manifest.md' (ManifestText 'None.')}
       & $crlf;$r=Run 'Gate';git -C $root config --unset core.autocrlf
       Assert '281-C13 CHECK: an unchanged CRLF blob holds under core.autocrlf=true' ($r.Text-notmatch'CRITERION_CHECK_FAILED'-and$r.Text-match$atReceipt) $r.Text
       Pop 'CHECK' 'accept'
       MutationKill '281-CM4 CHECK MUTATION: a whole-file same is judged by blob, not text' {ChWhole -Open|Out-Null;Put '_ORVION_CANONICAL/manifest.md' (ManifestText 'None.')} $atReceipt `
           "if(`$Check.Kind-eq'same'-and`$Check.Key){" "if(`$Check.Kind-eq'same'){" 'CHECK'
       MutationKill '281-CM5 CHECK MUTATION: an unchanged file is its index blob' $crlf $atReceipt `
           "if(`$LASTEXITCODE-eq0-and(git -C `$Root ls-files -- `$Path)){" 'if($false){' 'CHECK'
       git -C $root config --unset core.autocrlf
   ```

   The resulting file's Git blob is 6dfef76e0b3004ee4fec27170beb1f473a00cf57.
4. Check whether `scripts/test_github_public_read.ps1` contains no `PlatPlusHub` and no `-Repo owner/repo`; if so record Already Applied; if exactly one holds, stop. Otherwise replace the whole line `    Reply (ConvertTo-Json -Depth 10 -Compress (Row))`, which occurs once, with the three lines

   ```powershell
       # The watcher serves Founder only (FOUNDER_REPOSITORY_MISMATCH otherwise), so its runs carry that identity.
       $founder='Shehabhub/ORVION'; function FRow { $r=Row; $r.repository.full_name=$founder; $r }
       Reply (ConvertTo-Json -Depth 10 -Compress (FRow))
   ```

   then replace `$r=Row;` with `$r=FRow;` in the two watcher row assignments `$r=Row;$r.conclusion=` and `$r=Row;$r.head_sha=$head;`, and every `-Repo owner/repo` with `-Repo $founder`. In the `-Live` block replace `PlatPlusHub/orvion-sandbox` with `Shehabhub/orvion-sandbox`, `PlatPlusHub/orvion-reader-missing-927debc` with `Shehabhub/orvion-reader-missing-927debc`, SHA `78acc077b69246b1506c64f37c475d0f1245a3ad` with `f954e7522f2411db6ba846395fa61847d7039af7`, run `38876025069` with `39072571955`, run `38875779719` with `39072554091` and job `116890370968` with `117512987802`. Change nothing else. The resulting file's Git blob is bf3f4805247d5addd1a2db03004cc351d2960e63.
5. Check whether the Runtime Checkpoint reads `Resume Step: DONE`; if so record Already Applied. Otherwise run `pwsh -NoProfile -File scripts/generate-ai-map.ps1`, confirm `pwsh -NoProfile -File scripts/generate-ai-map.ps1 -Check` exits 0 and that `git diff --name-only` names only Write Scope paths, append the Execution Log entry, set the Runtime Checkpoint to `Resume Step: DONE`, `Blocker: None`, `Recovery Attempt: 0`, and commit the implementation and checkpoint together through the unchanged pre-commit hook.
6. Check that a fresh native final receipt matches, a `Verdict: Confirmed Complete` Verification Notes entry exists and every Acceptance Criterion and Review Gate item holds; only then record Already Applied. Otherwise, from the repository root: require `C:\Users\My Lab\Documents\ORVION-Owner-Review\spec-287-implementation-2026-10-17\isolated-codex-home\config.toml` to exist with SHA-256 eb4b119fbdc772992f16546dfab255c4f3699ca684468f13804387ab232e2e5d, else stop; snapshot the IDs, names and states of all Docker containers; if the host cannot hold the Founder stack beside containers already running, stop and ask the owner before any non-Founder container is stopped; run `. ./scripts/assert_founder_local.ps1; $founderRoot = Assert-FounderLocalTarget -Root (Get-Location).Path; node_modules/.bin/supabase.cmd start --workdir "$founderRoot"` and require exit 0 with API 57421 and DB 57422 local. Then, in one PowerShell process that has `$env:CODEX_HOME` set to that isolated directory, start `pwsh -NoProfile -File scripts/run_timed.ps1 -Log <log> -Command "pwsh -NoProfile -File scripts/check_agent_continuity.ps1 -Finish"` and, at the same time, `pwsh -NoProfile -File scripts/watch_run.ps1 -Log <log> -Run spec-289-finish -Brief`. Require `LOCAL_CERTIFY: READY`; any failed command keeps its real exit code and evidence and starts bounded recovery without weakening an assertion. After Finish, stop only the Founder stack with `. ./scripts/assert_founder_local.ps1; $founderRoot = Assert-FounderLocalTarget -Root (Get-Location).Path; node_modules/.bin/supabase.cmd stop --project-id ORVION_FOUNDER --workdir "$founderRoot"` (volumes kept, no `--all`, no `--no-backup`) and require every other container to equal the snapshot. Perform independent live Review against the repository, append its Verification Notes verdict, complete through the native lifecycle with the unchanged pre-commit hook, and locally prepare the exact candidate with `pwsh -NoProfile -File scripts/check_agent_continuity.ps1 -Gate -BindCandidate -Root <original-checkout> -BaseRef <full-main-SHA> -HeadRef <full-candidate-SHA>`. Stop before publication or promotion.

## Acceptance Criteria

- [x] Both cancelled predecessors stay terminal. `check: same changes/SPEC-287-founder-operational-independence.md @ea4feb4ae1e168b31a27eca3ef694c5d1dd1987f` `check: has changes/SPEC-288-founder-operational-independence-completion.md "[x] Cancelled"` `check: lacks changes/SPEC-288-founder-operational-independence-completion.md "[x] In Progress"`
- [x] Carried workflow, workstation, bootstrap and stack-configuration paths are unchanged from the SPEC-288 implementation. `check: same .github/workflows/migration-ci.yml @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same .github/workflows/orvion-acceptance.yml @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same .github/workflows/repository-consistency.yml @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same .mcp.json @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same .workstation/cleanup.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same .workstation/decommission.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same .workstation/doctor.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same .workstation/manifest.md @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same .workstation/prepare.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same bootstrap.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same supabase/config.toml @a64916975725d67a4069d5bfc94c2140cca765bb`
- [x] Carried authority, method, awareness, evidence and report paths are unchanged from the SPEC-288 implementation. `check: same .claude/awareness.json @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same ENGINEERING_METHOD.md @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same GOVERNANCE.md @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same WORKSTATION.md @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same _ORVION_CANONICAL/32_execution_roadmap.md @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same reports/architecture-decision-records.md @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same reports/evidence/founder-ledger-evidence.json @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same reports/master/MASTER_CERTIFICATION_STATUS.md @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same reports/master/MASTER_INTEGRATION_CATALOG.md @a64916975725d67a4069d5bfc94c2140cca765bb`
- [x] Carried scripts are unchanged from the SPEC-288 implementation. `check: same scripts/assert_founder_local.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/batch6_select_target.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/check_database_parity.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/check_database_parity_evidence.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/check_primary_ledger.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/check_repository_consistency.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/generate-ai-map.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/generate-api-contract.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/impact.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/test_cold_start_state_guard.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/test_founder_environment.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/test_primary_ledger_guard.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/verify_api_end_to_end.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/verify_care_journeys.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/verify_customer_concurrency.py @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/verify_journey_branches.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/verify_lifecycle_branches.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/verify_role_journeys.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/verify_storage_end_to_end.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb` `check: same scripts/watch_ci.ps1 @a64916975725d67a4069d5bfc94c2140cca765bb`
- [x] The Gate judges a whole-file same by Git blob in both modes and an unchanged tracked file by its index blob. `check: has scripts/check_agent_continuity.ps1 "if($Check.Kind-eq'same'-and-not$Check.Key){"` `check: has scripts/check_agent_continuity.ps1 "$was=Get-RepoBlob $Check.Ref $Check.Path"` `check: has scripts/check_agent_continuity.ps1 "else{(Get-RepoBlob $a.Ref $a.Path)-ne(Get-RepoBlob $b.Ref $b.Path)}"` `check: has scripts/check_agent_continuity.ps1 "git -C $Root diff --quiet -- $Path 2>$null"`
- [x] The control suite proves the repair positively, negatively and by mutation. `check: has scripts/test_agent_continuity.ps1 "281-C9 CHECK: an unchanged file holds a whole-file same in the hook"` `check: has scripts/test_agent_continuity.ps1 "281-C11 CHECK: a removed final newline fails a whole-file same in the range"` `check: has scripts/test_agent_continuity.ps1 "281-C13 CHECK: an unchanged CRLF blob holds under core.autocrlf=true"` `check: has scripts/test_agent_continuity.ps1 "281-CM4 CHECK MUTATION: a whole-file same is judged by blob, not text"` `check: has scripts/test_agent_continuity.ps1 "281-CM5 CHECK MUTATION: an unchanged file is its index blob"`
- [x] The public-reader suite gives the watcher Founder's identity and reads only Founder's own public sandbox. `check: has scripts/test_github_public_read.ps1 "$founder='Shehabhub/ORVION'"` `check: lacks scripts/test_github_public_read.ps1 "-Repo owner/repo"` `check: lacks scripts/test_github_public_read.ps1 "PlatPlusHub"` `check: has scripts/test_github_public_read.ps1 "Get-OrvionPublicJobs 'Shehabhub/orvion-sandbox' 39072554091 1"`
- [x] Preserved authorities remain byte-identical to the certified Founder baseline. `check: same changes/SPEC-286-founder-initial-admission.md @c362e417eca5496d4235bb0232f7fab9cfd5ac17` `check: same scripts/publish_candidate.ps1 @c362e417eca5496d4235bb0232f7fab9cfd5ac17` `check: same scripts/promote_main.ps1 @c362e417eca5496d4235bb0232f7fab9cfd5ac17` `check: same scripts/github_public_read.ps1 @c362e417eca5496d4235bb0232f7fab9cfd5ac17` `check: same scripts/parity_surface.sql @c362e417eca5496d4235bb0232f7fab9cfd5ac17` `check: same reports/evidence/primary-ledger-evidence.json @c362e417eca5496d4235bb0232f7fab9cfd5ac17`
- [x] Founder target, recovery and readiness claims name their actual evidence classes; owner workstation adoption, bare Windows recovery, credential isolation, backups and external production integrations are not claimed.

## Execution Log

None.

2026-10-18 — Entered In Progress under the owner's Gate 1 execution authority (Master Execution Directive, Option A).

2026-10-18 — Step 1 carried payload Already Applied (unchanged from a649169); Steps 2-5 applied from the Draft text; edited blobs equal the Draft (e2892807, 6dfef76e, bf3f4805); projections regenerated and -Check clean; Runtime Checkpoint DONE requests the fresh timed Finish.

2026-10-18 — Fresh native timed Finish at 975f1aa31b05736b33971fe1e5afb628e9b6fb58: LOCAL_CERTIFY: READY in 00:52:26 (CONTROL 38:02, DATABASE 2:28, REPOSITORY 0:11, WORKSTATION 1:17, ADDITIONAL 10:07; 27 commands passed, none failed). Earlier attempts kept as evidence, none substituted: attempt 1 refused PENDING_RECEIPT_UNBOUND (cancelled SPEC-288 working receipt; resolved by the owner's one-time conditional recovery approval — receipt archived byte-identical B84C5AF5… in the owner review workspace after sandbox reproduction); attempt 2 failed scripts/test_future_date_guard.ps1 4 of 18 because the test ran 09:58:04–10:00:45 UTC across the UTC+14 day boundary of the Check 12 ceiling (standalone rerun 18/0; no assertion changed); attempt 3 refused at the intermittent public-read transport before any check.

## Verification Notes

None.

### 2026-10-18 — Independent live Review

Verdict: Confirmed Complete

- Re-verified live, not from the Execution Log: all 62 Acceptance Criteria checks hold against the working tree (whole-file same by Git blob); criterion 9 holds by reading the carried claim text, which claims Founder readiness only after remote certification and adds no workstation-adoption, bare-Windows-recovery, credential-isolation, backup or external-integration claim.
- Since a64916975725d67a4069d5bfc94c2140cca765bb only the three edited files (blobs e2892807, 6dfef76e, bf3f4805 = Draft), the manifest, ai-map.json and the two contracts changed; nothing outside the 46-path Write Scope changed since c362e417eca5496d4235bb0232f7fab9cfd5ac17; generator -Check is clean.
- Fresh receipt 39331D4B… (finishHead 975f1aa, profiles CI/CONTROL/DATABASE/REPOSITORY/WORKSTATION) came from this CR's own Finish; SPEC-288's receipt was not reused. Both predecessors stay Cancelled and SPEC-287 is unchanged since ea4feb4.
- Platinum (fd118fa, clean, equal to remote), both hosted databases, credentials, owner launchers and other containers (snapshot equal) are unchanged. Publication and promotion remain separate owner gates; CTRL-19 remains OPEN.

Recommendation to human: Set Status to Complete

## Review Gate

- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [x] No file outside Write Scope was modified, created, or deleted, and every path other than the three edited files and the synchronized projections equals a649169.
- [x] Every Acceptance Criteria item is confirmed true against the live repository.
- [x] Every derived profile and every Additional Verification command passed in the one fresh native Finish; no prior SPEC-288 or sandbox result was substituted.
- [x] Both cancelled predecessors are named in Supersedes / Depends On and remain terminal and unchanged.
- [x] Platinum, both hosted databases, credentials, installed owner launchers, owner profiles, other projects' containers and retained original receipts remain unchanged; CTRL-19 stays OPEN.
- [x] The exact local candidate is clean and releasable; publication and promotion await their separate owner gates.

## Notes

Baseline: SPEC-288 implementation head a64916975725d67a4069d5bfc94c2140cca765bb on remote Founder main c362e417eca5496d4235bb0232f7fab9cfd5ac17. Git blobs at a649169 of the three edited files: scripts/check_agent_continuity.ps1 4f0b6207d51da781f3acb828da157be43645c901, scripts/test_agent_continuity.ps1 0760d22695d4e615c9a16cbe0a8347c28a0a5277, scripts/test_github_public_read.ps1 d2321a05384659b26c9c299a010180690f0d6fb8. SPEC-288's working Finish receipt (finishHead a649169) is retained as evidence and binds nothing here.

Sandbox evidence, from the push-disabled Founder sandbox clone with its own WSL Docker engine; it informs this Draft and certifies nothing. Real hook, SPEC-288's exact Complete state: unchanged Gate CRITERION_CHECK_FAILED at criterion 1; patched Gate refused at criterion 4 only because SPEC-288 freezes the evaluator. Reduced continuity suite 69/0 patched and 63/6 unchanged (the six new negatives). Full continuity suite with the patch: recorded at rehearsal. test_github_public_read 68/8 at a649169, 76/0 corrected, 82/0 with -Live against Shehabhub/orvion-sandbox. This contract's own lifecycle, from SPEC-288's cancellation through the Complete preflight, was rehearsed through the real pre-commit hook; results are recorded with the rehearsal.

Not proven before approval: the DATABASE protocol, the six HTTP suites and workstation idempotence on these bytes; they run only in Step 6's Finish unless a sandbox Finish has been recorded. The cause of the intermittent .NET connection stall to api.github.com is UNPROVEN beyond its phase.

Rejected alternatives: a successor whose criteria avoid whole-file same so the unchanged Gate can judge them (it leaves an evaluator that can never complete the form and never sees a changed final newline, and the repair would need a second CONTROL contract with its own full Finish); normalizing text on both sides instead of comparing blobs (a second notion of file identity beside `blob`, and line-ending edits would stay invisible); `hash-object` alone for the working tree (refuses an unchanged CRLF blob under core.autocrlf=true, reproduced); pinning SPEC-288's cancellation commit in a criterion (the rehearsed Draft would then differ from the approved one by that SHA; the native lifecycle already keeps a Cancelled contract terminal); adding the reader suite to the CONTROL profile (an engine change this repair does not need; proposed separately with Sandbox First enforcement).
