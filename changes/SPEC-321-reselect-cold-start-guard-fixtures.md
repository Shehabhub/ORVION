# Change Request — SPEC-321

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Re-select the two cold-start guard fixtures that SPEC-319 made stale, so the guard-of-the-guard suite passes again at c59910e52757ca799ae23137a63fb0324fc42ae7 with its full strength: C1 and C2 select their register row by shape, and F3 plants its own overdue witness instead of borrowing a live obligation.

## Business Reason

SPEC-319 is Complete and bound at c59910e52757ca799ae23137a63fb0324fc42ae7 but cannot be released. Its hosted preflight failed in the step "Attack the guards themselves" for Repository Consistency (run 45614967770) and ORVION Acceptance (run 45614967786). A local reproduction at c59910e52757ca799ae23137a63fb0324fc42ae7 proved the cause: in `scripts/test_cold_start_state_guard.ps1`, fixture C1 was pinned to the ARCH-2 register row, which SPEC-319 closed by adopting CRM SPEC-324, and fixture F3 expected an OVERDUE ENTRY-1 at B6-EXIT, while after SPEC-319 adopted CRM's action registry no open item is due at that boundary. The suite reported 40 passed and 2 failed; the hosted step stopped there, so `readiness_selftest.ps1` never ran hosted. Releasing this repair carries SPEC-319 to main and aligns ORVION main with Founder Secondary, which already holds the seven SPEC-319 migrations.

## Risks

A fixture repair could weaken the guard it attacks. Every mutation keeps its exact assertion: C1 still requires the UNSURFACED DECISION refusal for the selected row and C2 still requires its absence once the row leads with VERIFIED; F3 still requires a non-zero exit with an OVERDUE line at the probed REACHED B6-EXIT boundary, now naming PAY-9. A precondition fails the suite if no register row has the required shape, so the mutation can never pass vacuously. No product code, guard, workflow, record or database changes.

## Supersedes / Depends On

None.

## Write Scope

- `changes/SPEC-321-reselect-cold-start-guard-fixtures.md`
- `scripts/test_cold_start_state_guard.ps1`
- `_ORVION_CANONICAL/manifest.md`
- `ai-map.json`
- `repository-index.md`

## Out of Scope — Files Forbidden to Modify

- `scripts/check_repository_consistency.ps1`
- `scripts/check_agent_continuity.ps1`
- `scripts/readiness_population.ps1`
- `scripts/readiness_selftest.ps1`
- `scripts/test_future_date_guard.ps1`
- `scripts/test_status_contradiction_guard.ps1`
- `scripts/test_primary_ledger_guard.ps1`
- `.github/workflows/repository-consistency.yml`
- `.github/workflows/orvion-acceptance.yml`
- `reports/master/MASTER_GAP_REGISTER.md`
- `reports/master/MASTER_EXECUTION_PLAN.md`

Other product code, schema, tests, records, roles, CI and all external writes are outside the exact Write Scope.

## Required Reading

- `CR_LIFECYCLE.md` §§4–9 and `ENGINEERING_METHOD.md` §2.
- `scripts/test_cold_start_state_guard.ps1` sections C and F.
- `scripts/check_repository_consistency.ps1` Checks 25 and 29.
- `.github/workflows/repository-consistency.yml` step "Attack the guards themselves".

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Required Capabilities

None

## Additional Verification

- pwsh -NoProfile -File scripts/test_future_date_guard.ps1
- pwsh -NoProfile -File scripts/test_status_contradiction_guard.ps1
- pwsh -NoProfile -File scripts/test_primary_ledger_guard.ps1
- pwsh -NoProfile -File scripts/test_cold_start_state_guard.ps1
- pwsh -NoProfile -File scripts/readiness_selftest.ps1

## Pre-Approval Evidence

Change Class: Significant

### Draft Assurance

Pass 1 Design: Adopt the CRM SPEC-325 and SPEC-339 fixture shape. C1 and C2 take the first register row whose status cell opens with OPEN, still says NOT fixed and has no decider; F3 moves the open PAY-9 row to the B6-EXIT boundary inside the mutation, probes that boundary as REACHED and requires the OVERDUE refusal to name PAY-9. A precondition check proves the selected row exists.

Pass 2 Adversarial Review: The precondition reads the status cell, not the whole row, so a row whose history merely mentions OPEN cannot satisfy it. The F3 witness is planted inside the mutated copy, so it cannot vanish when a live obligation closes. The assertions of C1, C2 and F3 are unchanged in strength. The five hosted guard suites are named in Additional Verification so the native Finish runs them locally, closing the gap that let SPEC-319 reach hosted preflight with a failing suite.

Pass 3 Evidence Refresh: 2026-11-25. At c59910e52757ca799ae23137a63fb0324fc42ae7 in an isolated full-history clone carrying the repair, all five hosted guard suites passed from native PowerShell, including the cold-start suite with 42 passed and 0 failed. The unrepaired suite at the same baseline reported 40 passed and 2 failed.

Selected Version: SPEC-321; selected: the byte-identical adoption of CRM SPEC-325 and SPEC-339 shape-selected C fixtures, with the ORVION F3 witness planted (PAY-9 moved to B6-EXIT and the boundary probed REACHED inside the mutation), so the guard keeps its full strength and stops depending on one row staying open

### Consumer Closure

Applicability: APPLICABLE

| Changed fact or surface | Relevant consumer | Disposition | Evidence / preserved behavior |
| --- | --- | --- | --- |
| C1, C2 and F3 fixture selection | Hosted step "Attack the guards themselves" in Repository Consistency and ORVION Acceptance | WRITE | The same suite command passes with the same assertions. |
| Check 25 and Check 29 behavior | `scripts/check_repository_consistency.ps1` | UNAFFECTED | The guard is unchanged; only the probe input rows change. |
| Register and plan records | `MASTER_GAP_REGISTER.md` and `MASTER_EXECUTION_PLAN.md` | UNAFFECTED | The suite mutates copies only; the records are unchanged. |
| Native lifecycle metadata | Active Change Request, Last Completed and discovery projections | WRITE | Native lifecycle synchronization only. |

Unresolved Material Consumers: None

### Execution-Boundary Satisfiability

Applicability: APPLICABLE

Irreversible Action Step: NONE

| Invariant | Required At | Red Opens After Step | Restored By Step | Mandatory Gate Before Step |
| --- | --- | --- | --- | --- |
| Approved source anchor and exact suite payload | BEFORE_IMPLEMENTATION | NONE | NONE | NONE |
| All five hosted guard suites pass | BEFORE_COMPLETION | NONE | NONE | 2 |
| Matching native verification evidence | BEFORE_COMPLETION | NONE | NONE | NONE |

### Permanent-Control Admission

Applicability: APPLICABLE

Existing Mechanism Reusable: YES

Existing Mechanism: `scripts/test_cold_start_state_guard.ps1` already attacks Check 25 (unsurfaced decision) and Check 29 (overdue boundary) of `scripts/check_repository_consistency.ps1` by mutating copies of the register and plan; this change adds no new control and reuses the suite, the guard and the hosted step unchanged.

Added Property: The C1 and C2 fixtures are selected by shape from the live register, with a precondition that fails the suite when no row has the required shape, and the F3 witness is planted inside the mutation, so neither attack can pass vacuously or depend on one named row staying open.

Causal Negative: At `c59910e52757ca799ae23137a63fb0324fc42ae7` the unrepaired suite reported 40 passed and 2 failed (C1 pinned to ARCH-2, F3 expecting ENTRY-1), reproduced locally and in hosted preflight runs 45614967770 (Repository Consistency) and 45614967786 (ORVION Acceptance).

Positive Test Design: C2 still requires the UNSURFACED DECISION refusal for the selected row to disappear once its status leads with VERIFIED, and the unmutated records still pass the guard after each restore.

Negative Test Design: C1 still requires a non-zero guard exit with the UNSURFACED DECISION refusal for the selected no-decider OPEN row once it gains a decider; F3 still requires a non-zero exit with an OVERDUE line naming PAY-9 at the probed REACHED B6-EXIT boundary.

Non-Empty Population Obligation: C-precondition proves at least one register row whose status cell opens with OPEN, contains NOT fixed and has no decider; F3 requires the planted PAY-9 item to be OVERDUE at the probed boundary.

Mutation Obligation: Removing the required shape from every register row must turn C-precondition red; restoring the old pinned ARCH-2 and ENTRY-1 literals must reproduce the 40 passed and 2 failed result at `c59910e52757ca799ae23137a63fb0324fc42ae7`.

Post-Implementation Proof Obligation: The native Finish runs all five hosted guard suites through Additional Verification with zero failures, and the hosted Repository Consistency and ORVION Acceptance preflight succeeds on the release candidate before any Promote.

## Implementation Steps

1. Check whether `scripts/test_cold_start_state_guard.ps1` contains `ARCH-2 itself closed at CRM SPEC-324`; if so record Already Applied when its Git blob is e39939894bd246d1c7b2b26d579ee99226f12644, and otherwise stop and report. Otherwise make exactly these 6 edits (the shape-selected cold-start guard fixtures and the planted F3 witness), each matched once, and change nothing else:

   a) replace the line
   ```text
       # ARCH-2's row is the exact live false-negative: its status OPENS with `**OPEN - engineering,
   ```
   with
   ```text
       # The exact live false-negative was ARCH-2's row: its status OPENED with `**OPEN - engineering,
   ```

   b) replace the lines
   ```text
       # FIXED as a settled verdict. Its Owner-Decision cell is currently `-` (no decider), so it sits
       # outside Check 25's population; giving it one puts it in.
       $archRow = (($registerOriginal -split "`r?`n") | Where-Object { $_ -match '^\|\s*ARCH-2\s*\|' } | Select-Object -First 1)
       Check 'C-precondition: ARCH-2 opens OPEN and contains the word FIXED inside its status' `
           ($archRow -and $archRow -match 'OPEN' -and $archRow -match 'NOT fixed')
   ```
   with
   ```text
       # FIXED as a settled verdict. ARCH-2 itself closed at CRM SPEC-324, so the site is now SELECTED:
       # the first register row whose status cell itself OPENS with **OPEN, still says NOT fixed, and has
       # no decider (Owner-Decision `-`), so it sits outside Check 25's population until given one. The
       # precondition reads the status CELL, not the whole row, so a row whose history merely mentions
       # OPEN can never satisfy it vacuously again.
       $archRow = (($registerOriginal -split "`r?`n") | Where-Object {
           $c = $_ -split '\|'
           $_ -match '^\|\s*[A-Z][A-Z0-9]*-\d+[a-z]?\s*\|' -and $c.Count -gt 10 -and
           $c[9] -match '^\s*\*\*OPEN' -and $c[9] -match 'NOT fixed' -and $c[10].Trim() -in @('-', [string][char]0x2014)
       } | Select-Object -First 1)
       $archId = if ($archRow) { ($archRow -split '\|')[1].Trim() } else { '' }
       Check "C-precondition: a no-decider register row ($archId) whose status cell opens OPEN and contains the word FIXED" `
           ($archRow -and ($archRow -split '\|')[9] -match '^\s*\*\*OPEN' -and ($archRow -split '\|')[9] -match 'NOT fixed')
   ```

   c) replace the line
   ```text
           ($r.Exit -ne 0 -and $r.Text -match "UNSURFACED DECISION: register entry 'ARCH-2'") $r.Exit
   ```
   with
   ```text
           ($r.Exit -ne 0 -and $r.Text -match "UNSURFACED DECISION: register entry '$([regex]::Escape($archId))'") $r.Exit
   ```

   d) replace the line
   ```text
           ($r.Exit -eq 0 -and $r.Text -notmatch "UNSURFACED DECISION: register entry 'ARCH-2'") $r.Exit
   ```
   with
   ```text
           ($r.Exit -eq 0 -and $r.Text -notmatch "UNSURFACED DECISION: register entry '$([regex]::Escape($archId))'") $r.Exit
   ```

   e) replace the line
   ```text
       Write-S $PLAN $planOriginal.Replace('| Batch 6, this plan | NEXT |', '| Batch 6, this plan | REACHED 2026-10-12 probe |')
   ```
   with
   ```text
       # The witness is planted, not borrowed: once no live member is due at B6-EXIT (CRM SPEC-330 resolved RPC-1, the
       # last; adopted here at SPEC-319), F3 must still prove the guard, so PAY-9's open row is moved to that boundary
       # inside the mutation, and the boundary is probed as REACHED. The refusal must name PAY-9.
       Write-S $PLAN $planOriginal.Replace($payRow, $payRow.Replace('| `FIRST-BOOKING` |', '| `B6-EXIT` |')).Replace('| Batch 6, this plan | NEXT |', '| Batch 6, this plan | REACHED 2026-10-12 probe |')
   ```

   f) replace the line
   ```text
           ($r.Exit -ne 0 -and $r.Text -match 'OVERDUE: ENTRY-1 -- boundary B6-EXIT') $r.Exit
   ```
   with
   ```text
           ($r.Exit -ne 0 -and $r.Text -match 'OVERDUE: PAY-9 -- boundary B6-EXIT is REACHED 2026-10-12 probe') $r.Exit
   ```

   The resulting file's Git blob is e39939894bd246d1c7b2b26d579ee99226f12644.

2. **Verify and synchronize.** Run the five hosted guard suites named in Additional Verification and the native repository guard. Confirm the exact scope and `git diff --check`. Synchronize the contract and native discovery artifacts. Native timed Finish, Review, Complete and release follow under their own authority. At native completion set `Last Completed: **SPEC-321: ORVION cold-start guard fixtures re-selected after SPEC-319.**` via the normal lifecycle.

## Acceptance Criteria

- [ ] The cold-start guard suite selects its C fixtures by shape, proves the selected row exists and plants its F3 witness. `check: blob scripts/test_cold_start_state_guard.ps1 e39939894bd246d1c7b2b26d579ee99226f12644`
- [ ] The repository guard is preserved. `check: same scripts/check_repository_consistency.ps1 @c59910e52757ca799ae23137a63fb0324fc42ae7`
- [ ] The native evaluator is preserved. `check: same scripts/check_agent_continuity.ps1 @c59910e52757ca799ae23137a63fb0324fc42ae7`
- [ ] The other hosted guard suites are preserved. `check: same scripts/readiness_selftest.ps1 @c59910e52757ca799ae23137a63fb0324fc42ae7`
- [ ] The hosted guard workflow is preserved. `check: same .github/workflows/repository-consistency.yml @c59910e52757ca799ae23137a63fb0324fc42ae7`
- [ ] All five hosted guard suites pass in the native Finish.

## Execution Log

None.


### 2026-11-25 — Implementation checkpoint (governed automation)

Outcome: Complete (implementation steps; final verification pending)

- Step 1 Applied: native recorded Gate 1 evidence names this exact Draft's SHA-256; the baseline HEAD was c59910e52757ca799ae23137a63fb0324fc42ae7 and every source anchor matched there; Draft allocated as 8c5bdfb and approved as 05f6998 with APPROVAL_EVIDENCE: PASS.
- Step 2 Applied: `scripts/test_cold_start_state_guard.ps1` edited exactly as the step states; blob e39939894bd246d1c7b2b26d579ee99226f12644 (21 insertions, 10 deletions).
- Step 3 Applied: generator rerun, `generate-ai-map.ps1 -Check` exit 0, the staged change names only Write Scope paths. Every edit was applied literally from this contract's steps and its Git blob checked before commit. Fresh timed and watched Finish, independent Review, Complete and candidate binding remain.

## Verification Notes

None.


### 2026-11-25 — Gate 1 approval recorded

DELEGATED Gate 1 for ORVION SPEC-321 under DEC-02 and DEC-25, in the owner's AFK Mode with the constitution deciding in the owner's absence (owner words of 2026-11-21, 2026-11-22 OD-9, 2026-11-23 and 2026-11-24 "continue ... to finish all plan"). Gate 1 record SHA-256 BCFEE3DA1B866F0AA95D0C8E22040AC4BB27191B64E6F8332063DBCA33076548, Draft 982C221E8FAD2C4B7365F379135599F4F3926AA10CE771928D9425AD086EC115, sandbox ccc13a9 and Complete 89fc7011f3bc162b33c63bc3cb1247967cc03bd6. Immediately before allocation the hash, the Draft blob 2e949e8533bdd092ba1a80f1c55efdb88d4bbbcb, all 1 source anchors, the baseline HEAD c59910e52757ca799ae23137a63fb0324fc42ae7 against refreshed origin/main 367cdf3da293745a573c6c7df0bbc3fd962322a5 and a clean checkout were revalidated, and the pre-commit allocator admitted the identity; Draft allocated as 8c5bdfb. No implementation performed before this transition.


Verdict: Confirmed Complete

Independent current Git evidence: selected Draft 982C221E8FAD2C4B7365F379135599F4F3926AA10CE771928D9425AD086EC115, allocated blob 2e949e8533bdd092ba1a80f1c55efdb88d4bbbcb, the one literal output (scripts/test_cold_start_state_guard.ps1 equal to its frozen blob: C1 and C2 select their register row by shape behind a precondition, F3 plants PAY-9 at the probed REACHED B6-EXIT boundary, every assertion kept), the repository guard, native evaluator, readiness self-test and the three workflows unchanged from the baseline, regenerated discovery only, and the declared scope verified; the Finish ran the five hosted guard suites as Additional Verification. This original root owns fresh receipt ce9accd95392372923b556fb04901c195203f32f1c0e6e1e487573225535d6d9, finishHead 983be60cc135e33fb777d91155b2dbe83caeef9d, profiles REPOSITORY, in a native timed/watched Finish observed READY/END0. Native Complete/range/binder still own full receipt/criterion validation. No publication or hosted result asserted.

## Review Gate

- [ ] Every change matches the accepted implementation steps.
- [ ] All changed paths are within Write Scope.
- [ ] Every acceptance criterion is confirmed by local evidence.
- [ ] Native Finish evidence and independent Review are present.

## Notes

Baseline: c59910e52757ca799ae23137a63fb0324fc42ae7 (SPEC-319 Complete and bound, not yet released; main is 367cdf3).

Authority: DELEGATED under the Workbench WS-049 AFK record and the constitution deciding in the owner's absence; never typed by the owner. The SPEC-319 hosted preflight evidence is Workbench `data/records/batch6/exit-bundle-m/orvion-twin/release/`.

| Path | Baseline Git blob |
| --- | --- |
| `scripts/test_cold_start_state_guard.ps1` | `b849aa7839291ef2187a000dcbdd67d6806f9e76` |
