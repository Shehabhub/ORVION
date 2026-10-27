# Change Request — SPEC-299

## Status

[ ] Draft
[x] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Record ADR-0035 (recovery proof without a Windows reinstall), repoint the pinned `Next capability` line and its GOVERNANCE pin to it, and make the owner Publish and Promote interfaces save their operation evidence by default in the `ORVION-Owner-Tools` folder beside this product's checkout instead of `Documents\ORVION-Owner-Review`, while an explicit `-EvidenceDirectory` keeps choosing any destination.

## Business Reason

The supplied owner decision of 2026-10-27 cancels the Windows reinstall and keeps the recovery proof as C1 (owner-reported passed) plus one isolated run of the released WS-023 restore launcher against a fresh package. Bare-Windows tool installation stays UNPROVEN, and the hold stays ON until one recorded owner lift citing criteria 1–5. ADR-0034 and the pinned routing still name the reinstall, which would mislead a cold-start agent. ADR-0035 replaces that recovery requirement; ADR-0034 keeps its body and gains only a supersession status note.

The interfaces currently default to `Documents\ORVION-Owner-Review\owner-operations\Shehabhub_ORVION`. V1 proposes consolidating these records under the sibling `ORVION-Owner-Tools` folder. This Draft retains that destination and each explicit override. It moves the default for new records only: it neither migrates old evidence nor proves that any destination is backed up. The owner's three-folder decision and Step 2/delegation record are reported by V1, not independently supplied in the no-reinstall excerpt; their applicability must be confirmed from the retained owner record before original approval.

## Risks

A wrong pinned line would misroute cold-start agents; the exact SHA-256 pin, generated projections and unchanged native pin evaluator must agree. The external criterion 5 is ADR-0034's recovery condition (4), not its CTRL-19 condition (5); no other closure condition is waived. C1 is owner-reported evidence, the released WS-023 launcher run is a pending proof obligation, bare-Windows tool installation is UNPROVEN, CTRL-19 stays OPEN, and Batch6/Phase8 stay ON HOLD until the owner's recorded lift citing criteria 1–5. This contract performs no restore, Workbench edit or hold lift.

The evidence fallback is derived from the running interface's own `$PSScriptRoot`, never Publish's candidate `-Root` or the current directory. It is a layout convention, not Owner-Tools discovery, containment, installation or backup validation. An arbitrary/nested clone can create a different same-named sibling directory; use an explicit `-EvidenceDirectory` when that layout is unsuitable. A drive-root checkout has the same concern. An override still chooses any destination; no new restriction is imposed. Evidence format, naming, refusal behavior, interactive confirmation and native release judgments remain unchanged.

The prior contract establishes exceptional delegation for SPEC-298, but does not itself establish its extension to SPEC-299 or authorization of the new default. V1 reports a 2026-10-27 Step 2 approval under the 2026-10-26 delegation. That external applicability is UNPROVEN in this pass; confirm it before recording Gate 1 as DELEGATED, and never label it a human-typed digest. This Draft and extracted admission confer no approval. CONTROL/REPOSITORY certification and the original receipt/Review remain mandatory later; this author was explicitly forbidden to run `test_agent_continuity.ps1`, any Finish, commits or release operations. Publication and promotion remain separately governed; Platinum is untouched.

## Supersedes / Depends On

None. ADR-0035 supersedes part of ADR-0034 inside `reports/architecture-decision-records.md`; no Change Request is superseded.

## Write Scope

- `scripts/owner_publish.ps1`
- `scripts/owner_promote.ps1`
- `scripts/test_owner_interfaces.ps1`
- `reports/architecture-decision-records.md`
- `GOVERNANCE.md`
- `_ORVION_CANONICAL/manifest.md`
- `ai-map.json`
- `repository-index.md`

## Out of Scope — Files Forbidden to Modify

- `AGENTS.md`
- `CR_LIFECYCLE.md`
- `ENGINEERING_METHOD.md`
- `scripts/check_agent_continuity.ps1`
- `scripts/check_repository_consistency.ps1`
- `scripts/generate-ai-map.ps1`
- `scripts/batch6_select_target.ps1`
- `scripts/publish_candidate.ps1`
- `scripts/promote_main.ps1`
- `reports/master/MASTER_EXECUTION_PLAN.md`
- `_ORVION_CANONICAL/32_execution_roadmap.md`

## Required Reading

- `AGENTS.md`
- `CR_LIFECYCLE.md`
- `ENGINEERING_METHOD.md`
- `GOVERNANCE.md`
- `changes/TEMPLATE.md`
- `changes/SPEC-298-batch6-routing-after-recovery.md`
- `reports/architecture-decision-records.md`
- `_ORVION_CANONICAL/manifest.md`
- `scripts/owner_publish.ps1`
- `scripts/owner_promote.ps1`
- `scripts/test_owner_interfaces.ps1`

## Runtime Checkpoint

Resume Step: 1
Blocker: None
Recovery Attempt: 0

## Required Capabilities

None

## Additional Verification

- pwsh -NoProfile -File scripts/test_owner_interfaces.ps1

## Pre-Approval Evidence

Change Class: Owner-Decision

### Draft Assurance

Pass 1 Design: SPEC-299-V1, by the orchestrator, proposes an append-only ADR-0035 with an ADR-0034 status note, one repointed Boot line and governance pin/version/changelog, and one fallback per owner interface with actual-child default-path regression cases. V2 keeps those choices where evidence supports them.

Pass 2 Adversarial Review: SPEC-299-V2 author found PROVEN literal execution failures: four V1 source anchors have zero ordinal matches, their inserted punctuation is also corrupted, and the six-step sequence omits projection regeneration. The test insertion anchor is unique, so that concern was disproved. V2 regenerates all literal steps from UTF-8 source, adds Step 7 and the projection red window, corrects the ADR's remaining "both are recorded" overclaim, distinguishes external criterion 5 from ADR condition (4), requires the recorded lift citing criteria 1–5, names released WS-023, preserves the deferred-launcher revisit trigger, and bounds clean-machine assertions to this evidence. V2 also strengthens the default-path cases to require REFUSED and correct record binding; seven targeted V2 mutants were killed, while V1 accepted four false-DONE/wrong-candidate records with the correct classification. The two fallback expressions and explicit overrides remain unchanged. The three-folder and SPEC-299 delegation claims inherited from V1 are UNPROVEN by the supplied owner excerpt.

Pass 3 Evidence Refresh: 2026-10-27. SPEC-299-V3, by the orchestrator in a separate refresh after the Codex xhigh V2: independently confirmed V2's main finding in the V1 bytes (five mojibake U+00B7 sequences, zero correct ones; a Workbench draft-generator decoding defect, recorded for repair), confirmed the step applier executes only the six file steps while the stage tool regenerates and checks projections (so Step 7 is compatible), re-checked the ADR supersession against common ADR practice (a new record supersedes; the old keeps its body and gets only a forward status pointer; numbers never reused) and the release-evidence default against NIST SSDF PS.3.1 (retain each release's supporting data in a protected, separate archive) without claiming signing or access control, and keeps V2's source bytes unchanged; exact sandbox native lifecycle must pass before the original delegated approval.

Selected Version: SPEC-299-V3; selected: V2's executable UTF-8 steps, evidence-bounded ADR-0035 and strengthened default-path cases, confirmed by an independent refresh and standards alignment

### Consumer Closure

Applicability: APPLICABLE

| Changed fact or surface | Relevant consumer | Disposition | Evidence / preserved behavior |
| --- | --- | --- | --- |
| Default evidence directory of `scripts/owner_publish.ps1` | Owner invoking Publish without `-EvidenceDirectory` | WRITE | Source checkout parent anchors Owner-Tools; explicit override, record format and refusal semantics preserved |
| Default evidence directory of `scripts/owner_promote.ps1` | Owner invoking Promote without `-EvidenceDirectory` | WRITE | Same source-relative fallback; promotion judgment preserved |
| Default-path regression | `scripts/test_owner_interfaces.ps1` | WRITE | Actual children require one correctly bound REFUSED record each; Publish candidate has a different parent; classification alone is insufficient |
| Owner interface documentation | `AGENTS.md` adapter paragraph | VERIFY | Metadata remains outside checkout; explicit destination remains supported |
| Recovery proof and supersession | `reports/architecture-decision-records.md` ADR-0034 and ADR-0035 readers | WRITE | Status note only on ADR-0034; new ADR owns recovery condition (4), preserves other closure conditions and deferred-launcher trigger; external criteria 1–5 lift still required; CTRL-19 OPEN |
| Pinned line `Next capability` (`_ORVION_CANONICAL/manifest.md`) | Native Boot NEXT_CAPABILITY and future agents | WRITE | Names ADR-0034 and ADR-0035; selector retains target ranking |
| Pinned line integrity | `GOVERNANCE.md` §6 rule 10 and native Gate | WRITE | Exact line SHA-256 and v1.23 changelog/version change together |
| Generated discovery | `ai-map.json`, `repository-index.md` through `scripts/generate-ai-map.ps1` | WRITE | Unchanged generator regenerates projections; Check proves reproducibility |
| Complete-time manifest rule | `CR_LIFECYCLE.md` | VERIFY | Owner-pointing Next capability stays pinned; only legal active pointer and Last Completed synchronization |
| Boot and consistency parsing | `scripts/check_agent_continuity.ps1`, `scripts/check_repository_consistency.ps1` | VERIFY | Key-based consumers remain valid; evaluator unchanged |
| Next executable task | `reports/master/MASTER_EXECUTION_PLAN.md` | UNAFFECTED | Manifest routes; first ranked Batch 6 row still defines task after lift |
| Historical incident descriptions | `reports/master/MASTER_GAP_REGISTER.md`, `reports/master/MASTER_REPOSITORY_HEALTH.md` | UNAFFECTED | Historical findings and detector descriptions do not assert current routing value |
| Fixture manifests | `scripts/test_agent_continuity.ps1`, `scripts/test_certification_receipts.ps1` | UNAFFECTED | Own fixture text; no changed repository routing dependency |
| Recovery procedure | `WORKSTATION.md` | UNAFFECTED | Generic new-machine/reinstall recovery instructions do not require this owner to reinstall; no procedure or installer changes |
| Historical old defaults and routing | Terminal `changes/` and dated `reports/history/` | UNAFFECTED | Immutable historical evidence |
| Native release engines, CI, databases and Platinum | `scripts/publish_candidate.ps1`, `scripts/promote_main.ps1` and their owning authorities | UNAFFECTED | No engine, workflow, credentials, database or Platinum change |

Unresolved Material Consumers: None

### Execution-Boundary Satisfiability

Applicability: APPLICABLE

Irreversible Action Step: NONE

| Invariant | Required At | Red Opens After Step | Restored By Step | Mandatory Gate Before Step |
| --- | --- | --- | --- | --- |
| Selected bytes and baseline anchors | BEFORE_IMPLEMENTATION | NONE | NONE | 1 |
| Pinned line equals its pin | BEFORE_COMPLETION | 5 | 6 | NONE |
| Generated discovery matches manifest | BEFORE_COMPLETION | 6 | 7 | NONE |
| Own native verification and source/receipt/Review independence | BEFORE_COMPLETION | NONE | NONE | NONE |

### Permanent-Control Admission

Applicability: APPLICABLE

Existing Mechanism Reusable: YES

Existing Mechanism: `scripts/test_owner_interfaces.ps1` actual-child fixtures and existing explicit `-EvidenceDirectory` cases.

Added Property: omitted `-EvidenceDirectory` resolves to `ORVION-Owner-Tools\records\owner-operations\Shehabhub_ORVION` beside the interface's own checkout, independent of Publish's candidate `-Root`.

Causal Negative: baseline defaults target retired `Documents\ORVION-Owner-Review`; a candidate-derived Publish default is indistinguishable if candidate and source share a parent, so this fixture separates their parents.

Positive Test Design: both actual children with no override and `-NonInteractive` save exactly one correctly bound REFUSED / INTERACTIVE_CONFIRMATION_REQUIRED record at the source-derived destination; existing explicit-directory cases remain green.

Negative Test Design: wrong-depth default in either interface and candidate-derived Publish default must fail their corresponding default-path cases; a correct classification with a false DONE result or wrong candidate must also fail, one interface at a time.

Non-Empty Population Obligation: both default-path cases execute, each observing one JSON record; fixtures stay under their temporary root and perform no real release.

Mutation Obligation: kill each interface's wrong-depth anchor, Publish's candidate-derived anchor, each interface's false-DONE refusal record, and each interface's wrong-candidate record independently; inspect the failing case and restore exact selected source bytes. Mutants and all possible sibling destinations stay inside owned scratch; never run a real retired-Documents default as a negative.

Post-Implementation Proof Obligation: original timed/watched native Finish runs derived CONTROL and REPOSITORY profiles plus the owning suite as Additional Verification; original receipt, truthful independent Review, Complete and exact candidate binding remain mandatory. Fixture evidence proves no publication, promotion or remote certification.

## Implementation Steps

Before Step 1, check the six baseline Git blobs in Notes, allowing only the native Approve change to the manifest's active pointer. Already Applied is allowed only by the resulting blob named below; stop on any other state. Read literal blocks as UTF-8, preserve all other bytes, and match each anchor exactly once. Do not run a mandatory Gate between Steps 5 and 7; the pin mismatch ends at Step 6 and projection freshness is restored by Step 7. These are implementation instructions for a future approved contract, not authority to execute this Draft.

1. Check whether `scripts/owner_publish.ps1` contains `'ORVION-Owner-Tools\records\owner-operations\Shehabhub_ORVION'`; if so record Already Applied when its Git blob is b3744e9430f25d2cff5830bacc3d0ba87006bf05, and otherwise stop and report. Otherwise make exactly this one edit (recovery proof without reinstall and owner evidence default), each matched once, and change nothing else:

   a) replace the line
   ```text
       $logs = if ($EvidenceDirectory) { [IO.Path]::GetFullPath($EvidenceDirectory) } else { Join-Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments)) 'ORVION-Owner-Review\owner-operations\Shehabhub_ORVION' }
   ```
   with
   ```text
       $logs = if ($EvidenceDirectory) { [IO.Path]::GetFullPath($EvidenceDirectory) } else { Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools\records\owner-operations\Shehabhub_ORVION' }
   ```

   The resulting file's Git blob is b3744e9430f25d2cff5830bacc3d0ba87006bf05.

2. Check whether `scripts/owner_promote.ps1` contains `'ORVION-Owner-Tools\records\owner-operations\Shehabhub_ORVION'`; if so record Already Applied when its Git blob is ebc7761a2085bb61f08a1fcca2ac1b703c3e4d06, and otherwise stop and report. Otherwise make exactly this one edit (recovery proof without reinstall and owner evidence default), each matched once, and change nothing else:

   a) replace the line
   ```text
       $logs = if ($EvidenceDirectory) { [IO.Path]::GetFullPath($EvidenceDirectory) } else { Join-Path ([Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments)) 'ORVION-Owner-Review\owner-operations\Shehabhub_ORVION' }
   ```
   with
   ```text
       $logs = if ($EvidenceDirectory) { [IO.Path]::GetFullPath($EvidenceDirectory) } else { Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'ORVION-Owner-Tools\records\owner-operations\Shehabhub_ORVION' }
   ```

   The resulting file's Git blob is ebc7761a2085bb61f08a1fcca2ac1b703c3e4d06.

3. Check whether `scripts/test_owner_interfaces.ps1` contains `default-evidence-directory`; if so record Already Applied when its Git blob is 11623d48eab0e4d9efa0306f31160bd133f7cf19, and otherwise stop and report. Otherwise make exactly this one edit (recovery proof without reinstall and owner evidence default), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
       }
   }
   ```
   insert
   ```text
   # Without -EvidenceDirectory, evidence goes to the ORVION-Owner-Tools folder beside the interface's own checkout.
   foreach ($fileName in @('owner_publish.ps1','owner_promote.ps1')) {
       $parent = Join-Path $work ('default-'+$fileName)
       $copy = Join-Path $parent "checkout\scripts\$fileName"
       Write-FixtureText $copy ([IO.File]::ReadAllText((Join-Path $Root "scripts\$fileName")))
       $childArguments = @('-NoProfile','-File',$copy,'-Candidate',('a'*40),'-NonInteractive')
       if ($fileName -eq 'owner_publish.ps1') { $childArguments += @('-Root',(Join-Path $parent 'candidate-area\checkout')) }
       $lines = @(& pwsh @childArguments 2>&1); $code = $LASTEXITCODE
       $saved = @(Get-ChildItem -LiteralPath (Join-Path $parent 'ORVION-Owner-Tools\records\owner-operations\Shehabhub_ORVION') -Filter '*.json' -File -ErrorAction SilentlyContinue)
       $record = if ($saved.Count -eq 1) { Get-Content -Raw -LiteralPath $saved[0].FullName | ConvertFrom-Json } else { $null }
       $expectedOperation = if ($fileName -eq 'owner_publish.ps1') { 'PUBLISH' } else { 'PROMOTE' }
       $expectedCheckout = if ($expectedOperation -eq 'PUBLISH') { Join-Path $parent 'candidate-area\checkout' } else { Join-Path $parent 'checkout' }
       $expectedRef = if ($expectedOperation -eq 'PUBLISH') { 'refs/heads/orvion-preflight' } else { 'refs/heads/main' }
       $ok = $code -eq 1 -and $null -ne $record -and $record.classification -ceq 'INTERACTIVE_CONFIRMATION_REQUIRED' -and
           $record.result -ceq 'REFUSED' -and $record.exitCode -eq 1 -and $record.operation -ceq $expectedOperation -and
           $record.candidate -ceq ('a'*40) -and $record.checkout -ieq $expectedCheckout -and $record.targetRef -ceq $expectedRef -and
           $record.repository -ceq 'Shehabhub/ORVION'
       $records.Add([pscustomobject]@{Product='self';Operation=$fileName;Case='default-evidence-directory';Passed=[bool]$ok;Exit=$code;Result=$record.result;Classification=$record.classification;NativeCalled=$false;Reason=$(if($ok){''}else{($lines|ForEach-Object{"$_"})-join"`n"})})
       Write-Host ("{0} self/{1}/default-evidence-directory: exit{2} saved={3}" -f $(if($ok){'PASS'}else{'FAIL'}),$fileName,$code,$saved.Count)
   }
   ```

   The resulting file's Git blob is 11623d48eab0e4d9efa0306f31160bd133f7cf19.

4. Check whether `reports/architecture-decision-records.md` contains `## ADR-0035 — Recovery proof without a Windows reinstall`; if so record Already Applied when its Git blob is ddf4d2ba5a4dc7a5247d2a3656763260746c1fb0, and otherwise stop and report. Otherwise make exactly these 2 edits (recovery proof without reinstall and owner evidence default), each matched once, and change nothing else:

   a) replace the line
   ```text
   - **Date:** 2026-10-26 · **Status:** accepted owner direction (exceptional owner delegation of 2026-10-26; Gate 1 of its CR is recorded as DELEGATED, not as a human-typed digest) · **Class:** owner-ratified programme decision · **Basis:** owner-ratified
   ```
   with
   ```text
   - **Date:** 2026-10-26 · **Status:** accepted owner direction (exceptional owner delegation of 2026-10-26; Gate 1 of its CR is recorded as DELEGATED, not as a human-typed digest; its recovery-proof requirement and related hold-lift prerequisite superseded by ADR-0035 (2026-10-27), the rest stands) · **Class:** owner-ratified programme decision · **Basis:** owner-ratified
   ```

   b) immediately after the line
   ```text
   - **Revisit trigger:** C2 fails, a recovery gap is found after the reinstall, or a measured incident shows a deferred launcher/coordinator is needed.
   ```
   insert
   ```text

   ## ADR-0035 — Recovery proof without a Windows reinstall

   - **Date:** 2026-10-27 · **Status:** accepted owner direction (owner decision of 2026-10-27 under the exceptional owner delegation of 2026-10-26; Gate 1 of its CR is recorded as DELEGATED, not as a human-typed digest) · **Class:** owner-ratified programme decision · **Basis:** owner-ratified
   - **Supersedes:** in ADR-0034, condition (4)'s recovery-proof requirement (C1 plus reinstall-based C2), its Decision's requirement that the recorded hold lift follow C2, the reinstall-specific reasoning in Why and Alternatives, and the C2-specific evidence and revisit wording. The replacement recovery prerequisite is the proof below. Everything else in ADR-0034 stands, including the other closure conditions and the deferred-launcher/coordinator revisit trigger.
   - **Decision:** the owner cancelled the Windows reinstallation; no ORVION folders are deleted. The final recovery proof is C1 (owner-reported complete: the same-machine isolated restore of package `orvion-backup-20261026T201821Z.7z`) plus one isolated run of the released WS-023 Workbench restore launcher (`Restore-ORVION.cmd`) against a fresh package. The launcher run remains a proof obligation until its result is recorded; this ADR performs neither restore. This is criterion 5 in the owner's external closure record, replacing the recovery component in ADR-0034 condition (4), not that ADR's separate CTRL-19 condition (5). Installing tools on bare Windows stays UNPROVEN; the owner accepts it as residual risk. The programme hold of 2026-10-21 stays ON until the owner records one lift decision citing criteria 1–5 after that proof; this ADR is not the lift. CTRL-19 stays OPEN.
   - **Why:** follow the owner's no-reinstall decision while distinguishing the remaining same-machine launcher proof from clean-machine tool installation, which C1 does not prove.
   - **Alternatives rejected:** retaining reinstall as a prerequisite (cancelled by the owner); Windows Sandbox (ADR-0034's prohibition stands); treating C1 alone as final proof (omits the required released-launcher run).
   - **Constraints on future work:** neither C1 nor the same-machine launcher run proves clean-machine tool installation; no clean-machine recovery claim follows from this evidence. Workbench `HANDOFF.md` §12 belongs to WS-023, outside this repository and this CR. CTRL-19 is not closed by this record.
   - **Evidence basis:** the supplied owner decision reports C1 complete; the actual restore record is outside this repository and is not independently re-proven here. The isolated released-launcher run remains a required proof obligation until its result is recorded. Clean-machine tool installation — UNPROVEN.
   - **Revisit trigger:** the launcher run fails, a recovery gap is found in a real restore, or the machine is actually replaced; ADR-0034's trigger for a measured need for deferred launchers/coordinators remains.
   ```

   The resulting file's Git blob is ddf4d2ba5a4dc7a5247d2a3656763260746c1fb0.

5. Check whether `GOVERNANCE.md` contains `- v1.23 (2026-10-27) — SPEC-299, Founder CR under`; if so record Already Applied when its Git blob is 0f92849d6bd769b88ad0eb959cce4f7c147eb525, and otherwise stop and report. Otherwise make exactly these 3 edits (recovery proof without reinstall and owner evidence default), each matched once, and change nothing else:

   a) replace the line
   ```text
   Version 1.22 · 2026-10-26 · Governs every future human, Claude, Codex, and AI/MCP session.
   ```
   with
   ```text
   Version 1.23 · 2026-10-27 · Governs every future human, Claude, Codex, and AI/MCP session.
   ```

   b) immediately after the line
   ```text
   **Governance changelog** (governance governs itself — §15):
   ```
   insert
   ```text
   - v1.23 (2026-10-27) — SPEC-299, Founder CR under the owner's exceptional delegation (DELEGATED Gate 1). Repoint the `Next capability` pin to ADR-0034 with ADR-0035: Batch 6 resumes after the owner's recorded hold lift tied to the recovery proof, without a Windows reinstall. MINOR: one pinned line and its pin change together; no authority moved, no lifecycle or certification change.
   ```

   c) replace the line
   ```text
       | `_ORVION_CANONICAL/manifest.md` | `Next capability` | `reports/architecture-decision-records.md` | `dda8567b75496c1c532a3bbdd342fa343080d02694938e49c8561322e5c35369` |
   ```
   with
   ```text
       | `_ORVION_CANONICAL/manifest.md` | `Next capability` | `reports/architecture-decision-records.md` | `6b00b57fceb9617cf21d74bf991e05302b48182ad556a3844863f77eb3bd2159` |
   ```

   The resulting file's Git blob is 0f92849d6bd769b88ad0eb959cce4f7c147eb525.

6. Check whether `_ORVION_CANONICAL/manifest.md` contains `lift that ADR-0034 and ADR-0035`; if so record Already Applied when its Git blob is f4620d3fc0c325d27cdd895fc226775ca55a627c, and otherwise stop and report. Otherwise make exactly this one edit (recovery proof without reinstall and owner evidence default), each matched once, and change nothing else:

   a) replace the line
   ```text
   Next capability: **Foundation Completion Programme — Batch 6** resumes when the owner records the programme hold lift that ADR-0034 (`reports/architecture-decision-records.md`) ties to the clean-machine recovery; the next slice is then the first row of `scripts/batch6_select_target.ps1` (local stack), never a copy of it here. Batch 6 runs until EC-1…EC-11 hold, then the readiness gate (`MASTER_EXECUTION_PLAN.md`); then the Phase-8 order in `32` resumes.
   ```
   with
   ```text
   Next capability: **Foundation Completion Programme — Batch 6** resumes when the owner records the programme hold lift that ADR-0034 and ADR-0035 (`reports/architecture-decision-records.md`) tie to the recovery proof; the next slice is then the first row of `scripts/batch6_select_target.ps1` (local stack), never a copy of it here. Batch 6 runs until EC-1…EC-11 hold, then the readiness gate (`MASTER_EXECUTION_PLAN.md`); then the Phase-8 order in `32` resumes.
   ```

   The resulting file's Git blob is f4620d3fc0c325d27cdd895fc226775ca55a627c.

7. Regenerate both declared projections with `pwsh -NoProfile -File scripts/generate-ai-map.ps1`, then require `pwsh -NoProfile -File scripts/generate-ai-map.ps1 -Check` to exit 0. Do not hand-edit projections. Verify the exact UTF-8 `Next capability` line without CR/LF hashes to its GOVERNANCE §6 pin; all other pins stay unchanged. Run the declared owning suite and derived native verification only under the authorized original lifecycle, with required timing/watching. Record actual results; do not substitute this prototype's evidence or an extracted evaluator for original Finish, Review, a receipt or Complete. Regenerate discovery again whenever legal lifecycle synchronization changes the manifest.

## Acceptance Criteria

- [ ] Publish default is exactly approved; `check: blob scripts/owner_publish.ps1 b3744e9430f25d2cff5830bacc3d0ba87006bf05`
- [ ] Promote default is exactly approved; `check: blob scripts/owner_promote.ps1 ebc7761a2085bb61f08a1fcca2ac1b703c3e4d06`
- [ ] Owning regression cases are exactly approved; `check: blob scripts/test_owner_interfaces.ps1 11623d48eab0e4d9efa0306f31160bd133f7cf19`
- [ ] ADR supersession and replacement proof are exactly approved; `check: blob reports/architecture-decision-records.md ddf4d2ba5a4dc7a5247d2a3656763260746c1fb0`
- [ ] Governance version, changelog and pin are exactly approved; `check: blob GOVERNANCE.md 0f92849d6bd769b88ad0eb959cce4f7c147eb525`
- [ ] Routing names both decision authorities; `check: has _ORVION_CANONICAL/manifest.md "lift that ADR-0034 and ADR-0035"`
- [ ] Native evaluator remains unchanged; `check: same scripts/check_agent_continuity.ps1 @0529a0d0c3422f1dd8ddf2d246e3e7d77adebfb7`
- [ ] Owning suite proves both defaults, explicit overrides and existing refusal/release-adapter behavior; independently observed mutations kill the new cases.
- [ ] Projections reproduce through the existing generator and exact Next capability line hashes to its governance pin.
- [ ] Review confirms owner-reported C1 only, no completed launcher proof without external evidence, no clean-machine install proof from this evidence, one recorded owner lift citing external criteria 1–5 still required, no CTRL-19 closure and no real release assertion; retained owner authority for this SPEC-299 default/delegation is verified before original approval.

## Execution Log

None.

## Verification Notes

None.


### 2026-10-27 — Gate 1 approval recorded

DELEGATED exact Gate1 under the owner's exceptional delegation of 2026-10-26 and Step 2 approval of 2026-10-27; Draft SHA-256 90228502DFC0C01777277C2419BD11139F850B69C8C0B1C58AB560F401A85C0C, decision SHA-256 A0A05749F73F104B940B915064A6D9D7FB0A4161FC811DA16FA7FF0D82260223. No fabricated human future-digest approval. Own fresh original native verification/Review/Complete/binding required; sandbox receipt certifies no original. Immediately before allocation the hash, the Draft blob cab3404c69dced49a3d45d72b80598c63c9d6e2a, all 6 source anchors, the baseline HEAD 0529a0d0c3422f1dd8ddf2d246e3e7d77adebfb7 against refreshed origin/main 0529a0d0c3422f1dd8ddf2d246e3e7d77adebfb7 and a clean checkout were revalidated, and the pre-commit allocator admitted the identity; Draft allocated as 589c25d. No implementation performed before this transition. Batch 6 remains ON HOLD; CTRL-19 remains OPEN.

## Review Gate

- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [ ] No file outside Write Scope was modified, created, or deleted.
- [ ] No section was added, removed, or restructured outside the approved steps.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] Any step that could not be resolved deterministically was reported, not guessed.
- [ ] If this Change Request's Supersedes / Depends On section names another file, that file's Status has been updated accordingly.
- [ ] The repository is in a clean, releasable state.

## Notes

After actual native Finish and truthful Review, synchronize only this contract and the declared manifest/discovery paths to Complete. Set `Last Completed: **SPEC-299: owner evidence defaults moved beside the checkout; ADR-0035 records no-reinstall recovery proof and pinned routing; native verification and Review complete. Publication/promotion remain separately governed. Batch6/Phase8 remain ON HOLD until the owner's recorded lift; CTRL-19 remains OPEN.**` and regenerate discovery. Candidate binding follows Complete and is never a pre-Complete criterion. Publication and promotion follow the native release path separately.

Exact baseline 0529a0d0c3422f1dd8ddf2d246e3e7d77adebfb7 and source anchors:

| Path | Baseline Git blob |
| --- | --- |
| `scripts/owner_publish.ps1` | `0cf549a148f6ce0c2bd0300967aaeaae0e7ae8a1` |
| `scripts/owner_promote.ps1` | `68f220ffea3963b1847f29a9b2f956f280b117a3` |
| `scripts/test_owner_interfaces.ps1` | `87ab4b3b169b1cb2c0b35f1a59d05882b12c45fb` |
| `reports/architecture-decision-records.md` | `4c3faa2f72228042a46de292f03e4599f6379ac5` |
| `GOVERNANCE.md` | `ac286e08aeedb50f9e2791b0f48673b3855f3827` |
| `_ORVION_CANONICAL/manifest.md` | `2384d0e81c0a463af39d3b5aa5418232c9cb6a9b` |

Selection sources: native AGENTS.md, CR_LIFECYCLE.md, GOVERNANCE.md §6 rule 10 and §15, the ADR convention, SPEC-298, `scripts/generate-ai-map.ps1`, the owner interfaces and their owning suite at 0529a0d0c3422f1dd8ddf2d246e3e7d77adebfb7; the supplied no-reinstall excerpt of 2026-10-27 and V1's reported external owner decisions (with the evidence limits above). V1 and V2 are supplied/retained author snapshots; no unseen V3 or completed third-party lifecycle run is attested. The owner no-reinstall excerpt is supplied; the three-folder decision and SPEC-299 Step 2/delegation record are inherited V1 claims requiring confirmation before original approval. Correctness remains native and independent.

V2 author evidence is retained outside this checkout in `scratch/fd299-v2/author-pass2/`: `v1-literal-audit.json`, `literal-replay.json`, `interfaces.log`, `mutations.log`, `consistency.log`, `map.log`, `admission.log` and `consumer-search.txt`. Read their actual verdicts before relying on them. These are planning/prototype evidence only. `test_agent_continuity.ps1`, Finish, lifecycle commits, candidate binding and remote certification were not run in this pass and remain UNPROVEN. The full original lifecycle and any later assurance/selection remain separately required; a parser PASS cannot establish author truth, owner authority or implementation certification.

| V2 prototype observation | Result | Proof limit |
| --- | --- | --- |
| Owning suite, `interfaces.log` | PROVEN: `B4_INTERFACES: 51 passed, 0 failed`; exit 0 | Local fixture history and adapter seams; no real release or original certification |
| Targeted actual-child probes, `mutations.log` | PROVEN: positive pair passed; seven V2 mutants killed; four V1 classification-only blind spots reproduced; exit 0 | Default-path refusal records only; every expected failing case inspected |
| Extracted native evaluator, `admission.log` | PROVEN: CONTROL,REPOSITORY; seven steps; `APPROVAL_EVIDENCE: PASS`; seven working criterion checks and working pins pass; both missing-section/consumer counterchecks refuse | Native predicate extraction, not Approve, full Gate, Finish or owner authorization |
| Repository consistency, `consistency.log` | PROVEN: `REPOSITORY CONSISTENCY: CLEAN`; exit 0 | Repository/recorded evidence only; no live database or remote read |
| Generator check, `map.log` | PROVEN: both projections reproduce; exit 0 | Generated artifact freshness only |
| Independent Markdown replay, `literal-replay.json` | PROVEN: all six source steps have unique anchors, exact resulting bytes and matching Git blobs, including the post-Approve manifest pointer | Projections and lifecycle bookkeeping are regenerated, not pinned by this replay |
| Git checks | PROVEN: source diff reverse-applies exactly; `git diff --check` exits 0; HEAD remains 0529a0d | Prototype is deliberately uncommitted; no candidate or release is implied |

Fixture recovery: the first two owning-suite runs stopped at local `upload-pack: not our ref`; the retained object was readable with process-local long-path support and the longest pack index path measured 260 characters. The 8.3 TEMP alias expanded back to the long physical path. A physically shorter, newly owned scratch TEMP (`scratch/fd299-v2/p2`) plus process-local `core.longpaths=true` allowed the unchanged suite to finish. Path sensitivity is observed; the precise Git subprocess cause remains HYPOTHESIS. Failed logs/fixtures are retained. All timings were measured alongside other work and are not performance baselines. No persistent Git configuration or global TEMP was changed.

Snapshot identities: V1 E785ED3CC34A3FFA2B789BDDA5B3924667A6C06E2D630E2C472B06F323D158B5 (orchestrator); V2 94DC31BB67726CEC5AAD7666E319805BD786EA10D687E2578111809C9DFE14D5 (Codex xhigh). V3 adds the refresh and the final selection; its own SHA-256 is external.
