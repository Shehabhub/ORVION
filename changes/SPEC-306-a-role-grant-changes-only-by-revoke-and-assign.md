# Change Request — SPEC-306

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

## Objective

Batch 6 Slice 47 fixes a role grant's holder, role, scope and start once it is written, so a session changes a grant only by ending or starting it, which is step-up charged and recorded (URA-1, URA-2, URA-3; ADMIN-2's protection restored on every session path).

## Business Reason

- **Selection.** CRM's `scripts/batch6_select_target.ps1` at `03009ec`, on its live local catalog, ranks `user_role_assignments` first: Exposure 7, coverage 684, NOT-RECORDED (runner-up `customer_consents` 6/18). This repository at `12496f8` holds the same migrations, and its disposition record's 86 surface rows carry the same statuses, so the twin takes the same surface. The manifest's Next capability names the selector, never a copy of its result.
- **The twin, adopted by identity.** CRM measured and fixed these findings in its SPEC-302 (`changes/SPEC-302-a-role-grant-changes-only-by-revoke-and-assign.md` in CRM; this repository's `SPEC-302` is the unrelated `a-due-retry-is-opened-once`). At `12496f8`, `supabase/migrations` (tree `d3e3a44178a2666b7489c4e8dfb742675c6a3b83`) and `supabase/tests` (tree `516143fb34471f0fb82c46ba2e71a25c575cb606`) equal CRM's at `03009ec`; Founder Secondary's ten structural surfaces before the change (`_combined` `acaa0b419371eb704cc531ad84769485`/3150) equal CRM Primary's before SPEC-302; and the migration, test 162 and test 99 here are CRM SPEC-302's committed bytes. CRM's prototype measurements, probes, mutants and causal negative therefore hold here unchanged; they are cited, not re-run. This contract re-proves the identity, reads Founder Secondary, and runs its own native lifecycle, whose Finish re-runs the DATABASE protocol on the final bytes.
- **Why it matters.** This is the authority table: `app.has_permission`, `app.requires_mfa`, `app.effective_permissions` and the scope readers (`app.visible_branch_ids`, `app.visible_department_ids`) all read it. `app.assign_user_role` and `app.revoke_user_role` charge `app.authorize('MANAGE_USERS')`, permission AND step-up. The table door charges RLS `app.has_permission('MANAGE_USERS')` only, and the AFTER trigger `app.emit_role_change` (RBAC-1) charges `app.authorize` and records `role_assigned` / `role_removed` only when a row's liveness (`is_active`, `ends_at`) changes; it returns early for an UPDATE that keeps a row live and never reads `starts_at`.
- **Measured in CRM at `03009ec`** on its local stack (CRM SPEC-302), committed probe fixtures (owner, ceo, three employee actors and a second tenant with a lone owner):
  - **URA-1 (High).** A `ceo` at `aal1`, refused by the RPC ("multi-factor authentication required"), by direct UPDATE of live rows re-pointed an employee's grant to `owner` (the employee gained MANAGE_USERS), moved the owner's grant to another user (the owner lost every permission), moved a branch-scoped grant to another branch and widened it to tenant scope, and pushed the owner grant's `starts_at` a year ahead (suspending it) and back.
  - **URA-2 (High).** Every one of those re-points recorded 0 events, and at `aal2` a trainee grant re-pointed to `ceo` recorded 0 too; the security stream showed no privilege change.
  - **URA-3 (Medium).** A tenant's lone owner was refused their own revoke (ADMIN-2: the AFTER emitter re-charges MANAGE_USERS once the grant is gone), but changed their own grant's role to `employee` by direct UPDATE at `aal2`, leaving the tenant with 0 MANAGE_USERS holders.
- **The repair**, in the shape of the sibling guards: `app.guard_role_assignment_change`, BEFORE UPDATE (SECURITY DEFINER, empty `search_path`, executable by no client role), session writes only. A grant's id, tenant, holder, role, scope, branch, department, start and creation time are fixed (23514): a change is a revoke and a new assignment, each charged and recorded by the RPCs and the emitter. While a grant stays live, its `ends_at` is fixed too (23514); the end moves only when the change ends the grant. What a session can still change is `is_active` and `ends_at` across liveness, which `app.emit_role_change` already charges and records; with the grant's identity fixed, ADMIN-2's AFTER re-charge refuses the lone owner's self-demotion on every path again. A write with no session (migrations, seeds, provisioning, `service_role`) is exempt, as in every sibling guard.
  - No grant, policy, RPC, event code, `app.emit_role_change` or `app.derive_role_assignment_actor` changes.
- **The one existing file that moves, for a stated reason.** `99_role_assignment_temporal_test.sql` assertions 8–10 backdate a grant's `starts_at` as a fixture step while the actor's `request.jwt.claims` were still set, so the guard sees a session; the backdate is now a session-less fixture step (claims cleared and restored), and the assertions are unchanged. Test 10 (MEAS-2) does not move: the guard charges no permission. No catalog value, smoke count or canon entry moves.
- **Swept and found sound, pinned rather than changed:** an employee's direct INSERT is refused by RLS and their UPDATE touches no row; DELETE has no grant; a tenant move is refused by RLS; another tenant's user is refused by the FK; a live INSERT or an end at `aal1` is refused by the emitter.
- **Recorded positions, not repaired:** a grant inserted with a future `starts_at` records `role_assigned` when it is issued (the grant decision), and nothing records the moment it starts; a `platform` scope is accepted from a tenant session and read by nothing.
- **Latent on Founder Secondary:** `brplkqmbzffpxqgkkdzo` holds 0 tenants, 0 role assignments and 0 events, ledger 257 `ed3211eac78a43cdcf04f44235d5516d` and the target absent (read-only through the Founder connector, 2026-11-11), so no stored row meets the new guard and no data repair is needed.

## Risks

- **A session can no longer re-point a grant** (23514). No RPC, client or script re-points one; tests 22, 31, 51 and 103, which UPDATE the table, pass unchanged. A change of role, holder, scope or start is a revoke and a new assignment.
- **A fixture that edits a grant while a session's claims are set now fails.** Test 99 was the one such fixture and moves here; every other pgTAP file passes.
- **Founder Secondary deployment is irreversible** and runs only under the exact-SHA Gate-2 record of Step 7. Approval of this contract does not authorize it. Primary `vrvtsxexkiiiivlkdxzp` belongs to CRM and is never contacted.
- **Gate 1 and Gate 2 of this contract are DELEGATED** under the owner's instructions (class authorization for Batch 6 releases and standing approval of proposals, 2026-11-08 ~10:20 Cairo; publish, promote and hosted deploy ~12:05; run mode 2, "run through" to both products' publish, promote and remote Certify, for slice 5, 2026-11-11 ~14:48 Cairo, whose P7 is this ORVION twin of CRM SPEC-302), recorded outside this repository; never a human-typed digest.

## Supersedes / Depends On

None.

## Write Scope

- `changes/SPEC-306-a-role-grant-changes-only-by-revoke-and-assign.md`
- `supabase/migrations/20261111140000_a_role_grant_changes_only_by_revoke_and_assign.sql`
- `supabase/tests/162_a_role_grant_changes_only_by_revoke_and_assign_test.sql`
- `supabase/tests/99_role_assignment_temporal_test.sql`
- `reports/master/MASTER_GAP_REGISTER.md`
- `reports/master/MASTER_SURFACE_DISPOSITION.md`
- `reports/master/MASTER_API_CONTRACT.md`
- `reports/evidence/founder-ledger-evidence.json`
- `_ORVION_CANONICAL/manifest.md`
- `ai-map.json`
- `repository-index.md`

## Out of Scope — Files Forbidden to Modify

- `supabase/migrations/202607041700_create_identity_and_access_tables.sql`
- `supabase/migrations/202607043800_user_management_rpcs.sql`
- `supabase/migrations/202607044100_mfa_requirement_enforcement.sql`
- `supabase/migrations/202607049600_identity_event_emission.sql`
- `supabase/migrations/202607055100_role_change_audit_and_cursor_authority.sql`
- `supabase/migrations/202607058900_who_did_this_is_derived_never_accepted.sql`
- `supabase/migrations/202607060700_a_role_assignment_that_has_not_started_grants_nothing.sql`
- `supabase/migrations/20261111130000_a_department_stays_in_its_branch_and_changes_only_with_authority_and_a_record.sql`
- `supabase/tests/10_grant_model_test.sql`
- `supabase/tests/22_write_authority_test.sql`
- `supabase/tests/31_access_revocation_test.sql`
- `supabase/tests/51_role_change_audit_test.sql`
- `supabase/tests/76_tenant_administration_test.sql`
- `supabase/tests/103_company_asset_and_numeric_integrity_surface_test.sql`
- `scripts/verify_database.sql`
- `_ORVION_CANONICAL/27_event_catalog.md`
- `scripts/batch6_select_target.ps1`
- `scripts/check_agent_continuity.ps1`
- `scripts/check_repository_consistency.ps1`
- `scripts/readiness_population.ps1`
- `scripts/parity_surface.sql`
- `scripts/check_database_parity.ps1`
- `scripts/check_primary_ledger.ps1`
- `scripts/check_database_parity_evidence.ps1`
- `ENGINEERING_METHOD.md`
- `CR_LIFECYCLE.md`
- `changes/TEMPLATE.md`
- `reports/architecture-decision-records.md`
- `reports/future-backlog.md`
- `reports/master/MASTER_EXECUTION_PLAN.md`

## Required Reading

- `AGENTS.md`; `CR_LIFECYCLE.md`; `ENGINEERING_METHOD.md` §§1–5
- `supabase/migrations/202607055100_role_change_audit_and_cursor_authority.sql` (`app.emit_role_change`, `app.revoke_user_role`, RBAC-1) and `202607058900_who_did_this_is_derived_never_accepted.sql` (`app.derive_role_assignment_actor`)
- `supabase/migrations/202607060700_a_role_assignment_that_has_not_started_grants_nothing.sql` (the readers of `starts_at`, AUTH-2) and `supabase/tests/99_role_assignment_temporal_test.sql`
- `reports/master/MASTER_GAP_REGISTER.md` (RBAC-1, ADMIN-2, AUTH-2, STEPUP-1); `reports/master/MASTER_SURFACE_DISPOSITION.md`; `reports/master/MASTER_EXECUTION_PLAN.md`, Batch 6 method, EC-1…EC-11
- `changes/SPEC-305-a-department-stays-in-its-branch-and-changes-only-with-authority-and-a-record.md` (the last Founder-deploying slice, the twin of CRM SPEC-301)
- `changes/SPEC-287-founder-operational-independence.md` (the Founder evidence record and its read)
- `GOVERNANCE.md` (the recorded reading of the Founder hosted database)

## Runtime Checkpoint

Resume Step: DONE
Blocker: None
Recovery Attempt: 0

## Required Capabilities

- docker
- supabase-local
- supabase-secondary
- github

## Additional Verification

- `pwsh -NoProfile -File scripts/verify_api_end_to_end.ps1`
- `pwsh -NoProfile -File scripts/verify_journey_branches.ps1`
- `pwsh -NoProfile -File scripts/verify_lifecycle_branches.ps1`

## Pre-Approval Evidence

Change Class: Significant

### Draft Assurance

Pass 1 Design: one BEFORE UPDATE guard on `user_role_assignments`, session writes only, fixes a grant's identity (id, tenant, holder, role, scope, branch, department, start, creation) and a live grant's end while it stays live, so every change a session can still make is a liveness change that `app.emit_role_change` already charges and records; test 162 pins each re-point on the `aal1` and `aal2` doors, the lone owner's self-demotion, the RPC and door changes that still work and their single records, a no-op update and the session-less exemption; test 99's backdate moves to a session-less fixture step; the register and disposition record URA-1, URA-2, URA-3, the ADMIN-2 note and the surface.

Pass 2 Adversarial Review: CRM SPEC-302's, adopted with its bytes; there the design was challenged on the prototype. Extending `app.emit_role_change` to charge and record every UPDATE with a new `role_changed` code was rejected: a new event code, canon entry and smoke count, a payload that rewrites the meaning of the grant an earlier `role_assigned` recorded, and no RPC that re-points a grant for it to serve; a revoke and a new assignment already say the same thing in the existing record. Revoking UPDATE from `authenticated` was rejected: the door's expiry and reactivation are charged and recorded RBAC-1 flows that test 51 pins. Charging the step-up in the RLS policy was rejected: a policy filters rows instead of raising, so a refused UPDATE would touch 0 rows and look like success (the SPEC-203 shape). Fixing `ends_at` outright was rejected: an expiry is a recorded liveness change. Checking session-less writes too was rejected: every sibling guard exempts them, and provisioning and fixtures write without a session. Refusing future starts on INSERT and the `platform` scope were kept as recorded positions with no consumer. Attacks run on the final bytes: a fixture that edits a grant with stale `request.jwt.claims` counts as a session, which the full suite found in test 99 and nowhere else; no client, script or journey seed updates the table, and tests 22, 31, 51 and 103, which do, pass; the guard calls no `authorize` or `has_permission`, so test 10's MEAS-2 inventory, the API contract and the catalog do not move. Copying the selector's next target into the manifest was rejected (SPEC-270; SPEC-278's cancellation).

Pass 3 Evidence Refresh: 2026-11-11. The identity re-proven at `12496f8`: the migrations and tests trees equal CRM's at `03009ec`; the migration, test 162 and test 99 written here are CRM SPEC-302's committed blobs; the disposition's 86 surface rows carry the same statuses; the register and disposition were written by the same script with this contract's id, the identity measurement and Founder Secondary in place of Primary. Founder Secondary was read read-only for its project URL, ledger, target absence, all ten structural surfaces (equal to CRM Primary's before SPEC-302), the triggers and functions of `user_role_assignments` and its counts. CRM SPEC-302's measurements on these bytes (the clean reset, test 162 and tests 99, 51 and 76 alone, pgTAP Pass A and B, the HTTP suites, smoke, the probes, all three mutants, the causal negative, the structural fingerprints before and after, the generators and consistency) are adopted by reference.

Selected Version: SPEC-306; selected: the twin of CRM SPEC-302: the smallest repair that closes URA-1, URA-2 and URA-3 on every session path (one BEFORE UPDATE guard that fixes a grant's identity and a live grant's end; no grant, policy, RPC or event code changed), the migration, test 162 and test 99 byte-identical to CRM, its prototype proof adopted by identity (the same migrations and tests trees and the same pre-change Founder structure)

### Consumer Closure

Applicability: APPLICABLE

| Changed fact or surface | Relevant consumer | Disposition | Evidence / preserved behavior |
| --- | --- | --- | --- |
| A grant's identity is fixed for every session, and a live grant's end moves only by ending it | the administrator's table door (RLS update); `app.revoke_user_role`; any platform writer | WRITE | Migration SHA-256 `af0e95392ea4b77b482d7524b5b81e02a141cb88bbf9bae3933c3f4d967fa7a0`, md5 `b134eea648d20ff63c4014683cf326c5`, 4483 bytes, LF, ASCII. A clean reset gives 258 migrations, latest `20261111140000`, guard `md5(prosrc)` `10f82654759c36635b6d3a20edad5db6`, SECURITY DEFINER, ACL `{postgres=X/postgres}`; trigger `user_role_assignments_guard_change` BEFORE UPDATE. |
| Every change a session can still make is recorded once | `app.emit_role_change` (RBAC-1); readers of `public.events` | VERIFY | The emitter is unchanged (`md5(prosrc)` `5b53fafd89abc36d83825cb1c94fec79` before and after on the stored LF bytes, as read on Founder Secondary; CRM's Draft recorded `5e9af7ee7b8244da3a31326021c005b2` from a prototype checkout with CRLF line ends); test 162 assertion 15 pins one record per revoke, expiry and reactivation, with the actor, and none for the refused and no-op updates; test 51 passes. |
| The readers of grants | `app.has_permission`; `app.requires_mfa`; `app.effective_permissions`; `app.visible_branch_ids`; `app.visible_department_ids`; ADMIN-2 | VERIFY | No body changes; every pgTAP file passes; test 162 assertions 16–18 pin ADMIN-2 for the lone owner on both paths. |
| Test 162 | `supabase/tests` | WRITE | SHA-256 `1b62e1f1f7aa93fd5145addfb2d10a64d95732ca2c5c4135e4798847a997fa58`, md5 `ee930285654a4693abfd5c9ee1832ad3`, 9788 bytes, LF, ASCII, `plan(19)`: 19/19. |
| Test 99 | AUTH-2 | WRITE | The backdate runs without a session, for the reason in Business Reason; 11/11 alone, every assertion's text unchanged. |
| Other tests and the suite | the full pgTAP suite; the HTTP suites; smoke | VERIFY | In CRM on these bytes: Pass A `Files=162, Tests=3077`, PASS; HTTP 35/0, 85/0, 122/0; Pass B 162/3077, PASS; smoke `ALL CHECKS PASSED` (78 tables, 71/625 catalog). 162 files whose literal `plan(N)` values sum to 3077. |
| Structural surface on Founder Secondary | `scripts/parity_surface.sql`; `founder-ledger-evidence.json`; `scripts/check_database_parity_evidence.ps1` | WRITE | Before (257): functions `5d50b5ba57ec83e66c6ad492a22ff050`/336, `_combined` `acaa0b419371eb704cc531ad84769485`/3150, equal to the recorded Founder evidence and to CRM Primary's before SPEC-302. After (258): functions `1273cd1b48c879d51aedce0e9818f89b`/337 (+1), triggers `c83a7f55085f143723054abb9653d0d5`/324 (+1), `_combined` `48183b9ce5d79728a1a952f38cbfbbc3`/3152; policies, constraints, grants, columns, views, indexes, status transitions and RLS unchanged, as on CRM Primary after SPEC-302. Step 9 writes Founder values only from fresh post-deploy readings. |
| Client API | `MASTER_API_CONTRACT.md` (Check L3) | VERIFY | No RPC is added, removed or changed; the guard is a trigger function executable by no client role; the generator's output is identical to the stored file. It is in Write Scope because mandatory Check L3 regenerates it; Step 9 confirms it unchanged. |
| Measured state that moves | manifest `Live state` and suite figure; `founder-ledger-evidence.json`; `ai-map.json` and `repository-index.md` | WRITE | 257 → 258 migrations, latest `20261111140000`, ledger fingerprint `dec3a3dbe82e0568e8d98e5418f23436`; 161 → 162 files and 3058 → 3077 assertions; coverage 47 → 48 of 78. Tables 78 and client RPCs 80 do not move. `Next capability` and `Current Module` stay unchanged (selector form). |
| The pinned manifest lines `Current Module`, `Next capability` and `Batch 6 surface coverage` | native Boot; `scripts/batch6_select_target.ps1` and `MASTER_SURFACE_DISPOSITION.md`, which own their values (GOVERNANCE.md §6 rule 10) | UNAFFECTED | Step 10 names `Current Module` and `Next capability` only to leave them unchanged; each line keeps its ratified text and pin. |
| URA-1, URA-2 and URA-3 fixed; ADMIN-2 noted; the surface recorded | `MASTER_GAP_REGISTER.md`; `MASTER_SURFACE_DISPOSITION.md`; Checks 21, 22, 24, 25, 29 | WRITE | No `URA-` row exists at `12496f8`; the URA rows, the ADMIN-2 note and the disposition row are CRM's with this contract's id, the identity measurement and Founder Secondary in place of Primary. Test 162's `-- ATTACK-CLASSES:` line declares ten classes with CONCURRENCY and REPLAY `=N/A` and carries negative assertions, so Check 24 admits `ADVERSARIAL`. Each URA row has Owner `—` and is settled. Coverage 48: 24 `AUDITED`, 21 `AUDITED-OPEN`, 3 `PARTIAL`, 0 `EXEMPT`, 30 `NOT-RECORDED`; all 48 `ADVERSARIAL`. |
| Repository consistency | `scripts/check_repository_consistency.ps1` | VERIFY | With Steps 1–5 applied and the contract present, consistency reports exactly the six measured-state items (257 vs 258 migrations, latest, ledger fingerprint, 161 vs 162 files, 3058 vs 3077 assertions, the Founder-evidence record) and Checks 21–29 pass. Step 9 makes them true; the one implementation commit is made only after it. |
| The four CI-only guard self-tests | `scripts/test_*_guard.ps1`; `orvion-acceptance` | VERIFY | Unchanged scripts, run by `orvion-acceptance` on the exact candidate SHA before `main` may move to it. Their controls require the measured state of Step 9, so they are not run locally (CRM timed its four once: 618 s on this workstation; its workflow records 84 s for the step in hosted CI). |

Unresolved Material Consumers: None

### Execution-Boundary Satisfiability

Applicability: APPLICABLE

Irreversible Action Step: Step 8 (Founder Secondary deployment)

| Invariant | Required At | Red Opens After Step | Restored By Step | Mandatory Gate Before Step |
| --- | --- | --- | --- | --- |
| The applied files equal CRM SPEC-302's verified bytes and the identity holds | BEFORE_IRREVERSIBLE_ACTION | NONE | NONE | Step 6 |
| Founder Secondary lacks the target migration and its ledger and structure equal the recorded evidence | BEFORE_IRREVERSIBLE_ACTION | NONE | NONE | Step 8 |
| Manifest, recorded Founder evidence and Founder ledger agree | AFTER_IRREVERSIBLE_ACTION | Step 1 | Step 9 | Step 10 |
| Manifest suite and coverage figures equal the files and the disposition record | BEFORE_COMPLETION | Step 2 | Step 9 | Step 10 |
| The map matches its generators | BEFORE_COMPLETION | Step 1 | Step 9 | Step 10 |

### Permanent-Control Admission

Applicability: APPLICABLE

Existing Mechanism Reusable: NO

Existing Mechanism: `app.emit_role_change` (RBAC-1) charges `app.authorize('MANAGE_USERS')` and records only liveness changes; the RLS update policy charges `app.has_permission('MANAGE_USERS')` with no step-up; `app.derive_role_assignment_actor` fixes `assigned_by` only. Nothing fixes a grant's holder, role, scope or start.

Added Property: For every session, a role grant's holder, role, scope and start never change once written, and a live grant's end moves only by ending it, so every change a session can make to a grant is step-up charged and recorded once, and a lone owner cannot leave a tenant without an administrator on any session path.

Causal Negative: Measured in CRM on these bytes and adopted by identity: on the stack with the guard's trigger and function removed (the `03009ec` schema, equal to `12496f8`'s), test 162 fails assertions 1, 3–7, 9–10, 16 and 18, and the probes return: the `aal1` re-points of role, holder, scope and start land with 0 events, the `aal2` trainee becomes `ceo` with 0 events, and the lone owner's self-demotion leaves the tenant with 0 MANAGE_USERS holders.

Positive Test Design: One tenant with a `ceo`, an owner and two employees, two branches and seven grants; a second tenant with a lone owner. Positive controls: the stepped-up `ceo` revokes through the RPC, expires a grant and reactivates another through the door; an UPDATE that changes nothing lands; the lone owner keeps MANAGE_USERS; a session-less platform write lands.

Negative Test Design:
- **Auth:** at `aal1` the RPC is refused 42501, an end is refused 42501 by the emitter, and each re-point is refused 23514.
- **Business:** at `aal2` a re-point of a trainee grant to `ceo` is refused 23514 and the grant is unchanged.
- **State:** a live grant's end cannot move while it stays live (23514); a start cannot be pushed ahead.
- **Tenant:** a grant's tenant and holder are in the fixed row value; moving the owner's grant to another user is refused 23514.
- **Door:** a branch scope cannot be moved (23514).
- **Input:** each fixed column is checked as one row value, so no column is skipped.
- **Privilege:** the lone owner cannot demote their own grant (23514), and ADMIN-2 refuses their revoke (42501).
- **Observability:** the revoke, the expiry and the reactivation are each recorded once with the actor; the refused and no-op updates record nothing.

Non-Empty Population Obligation: The fixture holds two tenants, five users, two branches and eight grants before the first assertion. Each refusal is asserted by exact SQLSTATE and each record by its exact list.

Mutation Obligation: Adopted by identity from CRM SPEC-302, whose prototype ran it on these bytes: each mutant is installed on the prototype stack, proven installed by a changed fingerprint (the trigger's presence or the guard's `md5(prosrc)`), run against test 162, then restored by re-applying the migration and proven equal (`fn=10f82654`) with 19/19 before the next. A mutant not proven installed is a harness error, never a kill.

| Mutant | Change | Killed on CRM's prototype by |
| --- | --- | --- |
| M1 | the guard trigger dropped | 162 assertions 1, 3–7, 9–10, 16 and 18 |
| M2 | the live-end check removed | 162 assertion 7 |
| M3 | `starts_at` left movable | 162 assertion 6 |

Post-Implementation Proof Obligation: All of the following on the final bytes, through canonical `-Finish` from the main checkout with the project-local CLI: the clean reset, pgTAP Pass A, the declared HTTP suites, pgTAP Pass B and smoke; the generated artifacts, repository consistency and the recorded Founder evidence with its parity. Before Step 8: the identity proof and the fresh Founder Secondary baseline of Step 6; the focused tests, probes, mutants and causal negative are CRM SPEC-302's on the same bytes.

## Implementation Steps

1. Check whether `supabase/migrations/20261111140000_a_role_grant_changes_only_by_revoke_and_assign.sql` contains `Batch 6 slice 5 (URA-1, URA-2, URA-3)`; if so record Already Applied when its Git blob is a8bf49fc65755692579727419b4baa191f7933c6, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (the migration, byte-identical to CRM SPEC-302: the role-grant change guard and its trigger), and change nothing else:

   ```text
   -- Batch 6 slice 5 (URA-1, URA-2, URA-3) -- a role grant's holder, role, scope and start are fixed
   -- once written; a session changes a grant only by ending it or starting it, which is charged and
   -- recorded.
   --
   -- =================================================================================================
   -- THE MEASURED DEFECTS (2026-11-11 at 03009ec on the local stack, committed probe fixtures)
   --
   -- `app.emit_role_change` (RBAC-1) charges `app.authorize('MANAGE_USERS')` and records
   -- `role_assigned` / `role_removed` only when a row's liveness (`is_active`, `ends_at`) changes. An
   -- UPDATE that keeps a row live returns before the charge and the record, and the table's RLS charges
   -- `app.has_permission('MANAGE_USERS')` only, so:
   -- URA-1 A `ceo` at `aal1`, refused by `app.assign_user_role`, re-pointed an employee's live grant to
   --      `owner`, moved the owner's grant to another user, moved and widened a branch scope, and
   --      pushed a live owner grant's `starts_at` a year ahead (suspending it) and back, all by direct
   --      UPDATE.
   -- URA-2 None of those changes was recorded, and at `aal2` neither was a trainee grant re-pointed to
   --      `ceo`: the security stream showed no privilege change.
   -- URA-3 ADMIN-2's zero-owner protection held only for revocation: a tenant's lone owner re-pointed
   --      their own grant to `employee` and left the tenant with no MANAGE_USERS holder at all.
   --
   -- =================================================================================================
   -- THE REPAIR: `app.guard_role_assignment_change`, BEFORE UPDATE, session writes only (no session --
   -- migrations, seeds, provisioning, service_role -- no check, as in every sibling guard):
   --   - a grant's tenant, holder, role, scope, branch, department, start, id and creation time are
   --     fixed (23514). Changing any of them is a revoke (`app.revoke_user_role`) and a new assignment
   --     (`app.assign_user_role`), each step-up charged and recorded by `app.emit_role_change`.
   --   - while a grant stays live, its `ends_at` is fixed too (23514): the end moves only when the change
   --     ends the grant (or the grant is not live after it).
   -- What a session can still change is `is_active` and `ends_at` across liveness, which
   -- `app.emit_role_change` already charges and records; with the grant's identity fixed, ADMIN-2's
   -- AFTER re-charge refuses a lone owner's self-demotion on every path again. `assigned_by` stays
   -- fixed by `app.derive_role_assignment_actor`.
   -- POSITION, not changed here: a grant issued with a future `starts_at` records `role_assigned` when
   -- it is issued (the grant decision); nothing records the moment it starts. A `platform` scope is
   -- accepted from a tenant session and read by nothing.
   -- NOT CHANGED: every grant, policy and RPC, `app.emit_role_change` and
   -- `app.derive_role_assignment_actor`.
   -- Hosted rows at the time of writing (read-only, ledger 257): 0 assignments on Primary and on
   -- Founder Secondary.
   -- =================================================================================================

   -- `old` and `new` are both read: the trigger is UPDATE only.
   create or replace function app.guard_role_assignment_change()
   returns trigger
   language plpgsql
   security definer
   set search_path = ''
   as $fn$
   begin
       if (select auth.uid()) is null then
           return new;
       end if;
       if (new.id, new.tenant_id, new.user_id, new.role_id, new.scope_type, new.branch_id,
           new.department_id, new.starts_at, new.created_at)
          is distinct from
          (old.id, old.tenant_id, old.user_id, old.role_id, old.scope_type, old.branch_id,
           old.department_id, old.starts_at, old.created_at) then
           raise exception 'a role grant''s holder, role, scope and start are fixed; revoke it and assign a new one'
               using errcode = '23514';
       end if;
       if new.ends_at is distinct from old.ends_at
          and old.is_active and (old.ends_at is null or old.ends_at > now())
          and new.is_active and (new.ends_at is null or new.ends_at > now()) then
           raise exception 'a live role grant''s end moves only by ending it; revoke it and assign a new one'
               using errcode = '23514';
       end if;
       return new;
   end;
   $fn$;

   revoke execute on function app.guard_role_assignment_change() from public;

   create trigger user_role_assignments_guard_change
       before update on public.user_role_assignments
       for each row execute function app.guard_role_assignment_change();
   ```

   The resulting file's Git blob is a8bf49fc65755692579727419b4baa191f7933c6.

2. Check whether `supabase/tests/162_a_role_grant_changes_only_by_revoke_and_assign_test.sql` contains `plan(19)`; if so record Already Applied when its Git blob is eac192dd08669d6c79ef2fed2190a7b4962e3984, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 162, 19 assertions, byte-identical to CRM SPEC-302), and change nothing else:

   ```text
   -- pgTAP: Batch 6 slice 5 (URA-1, URA-2, URA-3) --
   -- a role grant's holder, role, scope and start are fixed once written; a session changes a grant only
   -- by ending it or starting it, which is charged and recorded (`20261111140000`).
   -- ATTACK-CLASSES: AUTH TENANT DOOR STATE INPUT CONCURRENCY=N/A REPLAY=N/A PRIVILEGE BUSINESS OBSERVABILITY
   --   CONCURRENCY=N/A -- the guard reads only the row's own OLD and NEW images; no ordering is relied on.
   --   REPLAY=N/A -- no token, nonce or idempotency key on this surface.
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(19);

   insert into auth.users (id, email) values
     ('16200000-0000-0000-0000-0000000000a1','ceo@c162.test'),
     ('16200000-0000-0000-0000-0000000000a2','owner@c162.test'),
     ('16200000-0000-0000-0000-0000000000a3','e@c162.test'),
     ('16200000-0000-0000-0000-0000000000a4','x@c162.test'),
     ('16200000-0000-0000-0000-0000000000a5','lone@c162.test');
   insert into public.tenants (id, name, slug, status) values
     ('16200000-0000-0000-0000-000000000001','Role Travel','role-travel-162','active'),
     ('16200000-0000-0000-0000-000000000003','Lone Travel','lone-travel-162','active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select t, sp.id, 'active' from public.subscription_plans sp,
     (values ('16200000-0000-0000-0000-000000000001'::uuid), ('16200000-0000-0000-0000-000000000003'::uuid)) v(t)
   where sp.plan_code = 'enterprise';
   insert into public.branches (id, tenant_id, name, slug) values
     ('16200000-0000-0000-0000-0000000000b1','16200000-0000-0000-0000-000000000001','B1','b1-162'),
     ('16200000-0000-0000-0000-0000000000b2','16200000-0000-0000-0000-000000000001','B2','b2-162');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
     ('16200000-0000-0000-0000-000000000011','16200000-0000-0000-0000-000000000001','CEO','ceo@c162.test',true,'16200000-0000-0000-0000-0000000000a1'),
     ('16200000-0000-0000-0000-000000000012','16200000-0000-0000-0000-000000000001','Owner','owner@c162.test',true,'16200000-0000-0000-0000-0000000000a2'),
     ('16200000-0000-0000-0000-000000000013','16200000-0000-0000-0000-000000000001','E','e@c162.test',true,'16200000-0000-0000-0000-0000000000a3'),
     ('16200000-0000-0000-0000-000000000014','16200000-0000-0000-0000-000000000001','X','x@c162.test',true,'16200000-0000-0000-0000-0000000000a4'),
     ('16200000-0000-0000-0000-000000000015','16200000-0000-0000-0000-000000000003','Lone','lone@c162.test',true,'16200000-0000-0000-0000-0000000000a5');
   insert into public.user_role_assignments (id, tenant_id, user_id, role_id, scope_type, branch_id, is_active)
   select v.id, v.tid, v.uid, r.id, v.scope, v.br, v.live
   from (values
     ('16200000-0000-0000-0000-0000000000e1'::uuid,'16200000-0000-0000-0000-000000000001'::uuid,'16200000-0000-0000-0000-000000000011'::uuid,'ceo','tenant',null::uuid,true),
     ('16200000-0000-0000-0000-0000000000e2','16200000-0000-0000-0000-000000000001','16200000-0000-0000-0000-000000000012','owner','tenant',null,true),
     ('16200000-0000-0000-0000-0000000000e3','16200000-0000-0000-0000-000000000001','16200000-0000-0000-0000-000000000013','employee','tenant',null,true),
     ('16200000-0000-0000-0000-0000000000e4','16200000-0000-0000-0000-000000000001','16200000-0000-0000-0000-000000000014','employee','branch','16200000-0000-0000-0000-0000000000b1',true),
     ('16200000-0000-0000-0000-0000000000e5','16200000-0000-0000-0000-000000000001','16200000-0000-0000-0000-000000000014','trainee','tenant',null,true),
     ('16200000-0000-0000-0000-0000000000e6','16200000-0000-0000-0000-000000000003','16200000-0000-0000-0000-000000000015','owner','tenant',null,true),
     ('16200000-0000-0000-0000-0000000000e7','16200000-0000-0000-0000-000000000001','16200000-0000-0000-0000-000000000013','senior_employee','tenant',null,true),
     ('16200000-0000-0000-0000-0000000000e8','16200000-0000-0000-0000-000000000001','16200000-0000-0000-0000-000000000014','senior_employee','tenant',null,false)
   ) v(id, tid, uid, code, scope, br, live)
   join public.roles r on r.code = v.code;

   select is(
     (select count(*)::int from pg_trigger
      where tgrelid = 'public.user_role_assignments'::regclass and not tgisinternal
        and tgname = 'user_role_assignments_guard_change'
        and pg_get_triggerdef(oid) like '%BEFORE UPDATE ON public.user_role_assignments%'),
     1,
     'the guard fires BEFORE UPDATE');

   -- The ceo at aal1: the RPC refuses (control), and so does every re-point at the door.
   set local role authenticated;
   select set_config('request.jwt.claims', '{"sub":"16200000-0000-0000-0000-0000000000a1","aal":"aal1"}', true);
   select throws_ok(
     $$select app.assign_user_role('16200000-0000-0000-0000-000000000013', 'owner')$$,
     '42501', null,
     'control: the RPC refuses a password-only session');
   select throws_ok(
     $$update public.user_role_assignments set role_id = (select id from public.roles where code = 'owner')
        where id = '16200000-0000-0000-0000-0000000000e3'$$,
     '23514', null,
     'URA-1: an employee''s live grant cannot be re-pointed to owner (measured before the repair: landed at aal1, unrecorded)');
   select throws_ok(
     $$update public.user_role_assignments set user_id = '16200000-0000-0000-0000-000000000014'
        where id = '16200000-0000-0000-0000-0000000000e2'$$,
     '23514', null,
     'URA-1: the owner''s grant cannot be moved to another user (measured: the owner lost everything, unrecorded)');
   select throws_ok(
     $$update public.user_role_assignments set branch_id = '16200000-0000-0000-0000-0000000000b2'
        where id = '16200000-0000-0000-0000-0000000000e4'$$,
     '23514', null,
     'URA-1: a branch scope cannot be moved');
   select throws_ok(
     $$update public.user_role_assignments set starts_at = now() + interval '1 year'
        where id = '16200000-0000-0000-0000-0000000000e2'$$,
     '23514', null,
     'URA-1: a live grant cannot be suspended by pushing its start ahead (measured: the owner lost MANAGE_USERS, unrecorded)');
   select throws_ok(
     $$update public.user_role_assignments set ends_at = now() + interval '1 day'
        where id = '16200000-0000-0000-0000-0000000000e3'$$,
     '23514', null,
     'a live grant''s end does not move while it stays live');
   select throws_ok(
     $$update public.user_role_assignments set is_active = false where id = '16200000-0000-0000-0000-0000000000e3'$$,
     '42501', null,
     'control: ending a grant at aal1 is still refused by app.emit_role_change (RBAC-1, unchanged)');

   -- The ceo at aal2: re-points are refused as well; ending and starting grants are charged and recorded.
   select set_config('request.jwt.claims', '{"sub":"16200000-0000-0000-0000-0000000000a1","aal":"aal2"}', true);
   select throws_ok(
     $$update public.user_role_assignments set role_id = (select id from public.roles where code = 'ceo')
        where id = '16200000-0000-0000-0000-0000000000e5'$$,
     '23514', null,
     'URA-2: a stepped-up session cannot re-point a grant either (measured: a trainee became ceo with no record)');
   reset role;
   select is(
     (select r.code from public.user_role_assignments ura join public.roles r on r.id = ura.role_id
       where ura.id = '16200000-0000-0000-0000-0000000000e5'),
     'trainee',
     '...and the grant is unchanged');
   set local role authenticated;
   select lives_ok(
     $$select app.revoke_user_role('16200000-0000-0000-0000-0000000000e5')$$,
     'the RPC revoke still ends a grant');
   select lives_ok(
     $$update public.user_role_assignments set ends_at = now() - interval '1 minute'
        where id = '16200000-0000-0000-0000-0000000000e7'$$,
     'a direct expiry still ends a live grant');
   select lives_ok(
     $$update public.user_role_assignments set is_active = true where id = '16200000-0000-0000-0000-0000000000e8'$$,
     'a direct reactivation still starts an inactive grant');
   select lives_ok(
     $$update public.user_role_assignments set is_active = is_active where id = '16200000-0000-0000-0000-0000000000e3'$$,
     'an UPDATE that changes nothing still passes');
   reset role;
   select is(
     (select string_agg(event_type_code || ':' || (payload->>'assignment_id'), ',' order by payload->>'assignment_id')
        from public.events
       where tenant_id = '16200000-0000-0000-0000-000000000001'
         and actor_user_id = '16200000-0000-0000-0000-000000000011'
         and event_type_code in ('role_assigned', 'role_removed')),
     'role_removed:16200000-0000-0000-0000-0000000000e5,role_removed:16200000-0000-0000-0000-0000000000e7,role_assigned:16200000-0000-0000-0000-0000000000e8',
     'URA-2: every change a session can still make is recorded once, with its actor; the refused and no-op updates recorded nothing');

   -- URA-3: the lone owner of tenant 3 at aal2.
   set local role authenticated;
   select set_config('request.jwt.claims', '{"sub":"16200000-0000-0000-0000-0000000000a5","aal":"aal2"}', true);
   select throws_ok(
     $$update public.user_role_assignments set role_id = (select id from public.roles where code = 'employee')
        where id = '16200000-0000-0000-0000-0000000000e6'$$,
     '23514', null,
     'URA-3: the lone owner cannot demote their own grant (measured: the tenant was left with no MANAGE_USERS holder)');
   select throws_ok(
     $$select app.revoke_user_role('16200000-0000-0000-0000-0000000000e6')$$,
     '42501', null,
     'control: ADMIN-2 still refuses the lone owner''s revoke');
   select is(app.has_permission('MANAGE_USERS'), true, '...so the tenant keeps its administrator');

   -- The one exemption: a session-less platform write is not checked (provisioning, migrations, fixtures).
   reset role;
   select set_config('request.jwt.claims', null, true);
   select lives_ok(
     $$update public.user_role_assignments set starts_at = now() - interval '1 day'
        where id = '16200000-0000-0000-0000-0000000000e4'$$,
     'a session-less platform write still edits a grant');

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is eac192dd08669d6c79ef2fed2190a7b4962e3984.

3. Check whether `supabase/tests/99_role_assignment_temporal_test.sql` contains `session-less platform write (the fixture`; if so record Already Applied when its Git blob is 00a89a03ad412ae26c5dd60c6e66d2eb4d414555, and otherwise stop and report. Otherwise make exactly these 2 edits (test 99: the backdate as a session-less fixture step, byte-identical to CRM SPEC-302), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
   --       the fix would be indistinguishable from breaking role grants outright.
   -- =============================================================================================
   ```
   insert
   ```text
   -- The backdate is a session-less platform write (the fixture's own step): since Batch 6 slice 5
   -- (`20261111140000`) a signed-in session cannot move a grant's start, so the actor's claims are
   -- cleared for it and restored after.
   select set_config('request.jwt.claims', null, true);
   ```

   b) immediately after the line
   ```text
    where id = '99000000-0000-0000-0000-0000000000b2';
   ```
   insert
   ```text
   select set_config('request.jwt.claims','{"sub":"99000000-0000-0000-0000-0000000000a2","aal":"aal2"}', true);
   ```

   The resulting file's Git blob is 00a89a03ad412ae26c5dd60c6e66d2eb4d414555.

4. Check whether `reports/master/MASTER_GAP_REGISTER.md` contains `| URA-1 |`; if so record Already Applied when its Git blob is faece3d086ddb22c556026141299a7bfe31c067a, and otherwise stop and report. Otherwise make exactly these 3 edits (the Slice 47 freshness entry, the URA-1, URA-2 and URA-3 rows and the ADMIN-2 note), each matched once, and change nothing else:

   a) replace the line
   ```text
   Last updated: 2026-11-11 (**Slice 46 — `departments` selected live at Exposure 7, coverage 666; runner-up `user_role_assignments` at 7/678.** **DEP-1** (Medium), **DEP-2** (Low) and **DEP-3** (Medium) are new and fixed. A `ceo` at `aal1`, refused by `app.create_department`, created, renamed, re-typed, deactivated and moved departments by direct table writes, none of them recorded; and a moved department left its existing lead at a branch and department pair every writer refuses, outside every department queue. SPEC-305, the twin of CRM SPEC-301, charges the RPC's authority on every door, records every department change, and fixes a department's branch for life. STEPUP-1 loses its `departments` member. No other row changed.)
   ```
   with
   ```text
   Last updated: 2026-11-11 (**Slice 47 — `user_role_assignments` selected live at Exposure 7, coverage 684; runner-up `customer_consents` at 6/18.** **URA-1** (High), **URA-2** (High) and **URA-3** (Medium) are new and fixed. `app.emit_role_change` charged the step-up and wrote the record only when a grant's liveness changed, so a `ceo` at `aal1`, refused by `app.assign_user_role`, re-pointed live grants by direct UPDATE (an employee to `owner`, the owner's grant to another user, a branch scope moved and widened, a start pushed a year ahead), none recorded, and a lone owner demoted their own grant and left the tenant with no administrator. SPEC-306 (the twin of CRM SPEC-302) fixes a grant's identity for every session.)

   Previously: 2026-11-11 (**Slice 46 — `departments` selected live at Exposure 7, coverage 666; runner-up `user_role_assignments` at 7/678.** **DEP-1** (Medium), **DEP-2** (Low) and **DEP-3** (Medium) are new and fixed. A `ceo` at `aal1`, refused by `app.create_department`, created, renamed, re-typed, deactivated and moved departments by direct table writes, none of them recorded; and a moved department left its existing lead at a branch and department pair every writer refuses, outside every department queue. SPEC-305, the twin of CRM SPEC-301, charges the RPC's authority on every door, records every department change, and fixes a department's branch for life. STEPUP-1 loses its `departments` member. No other row changed.)
   ```

   b) replace the line
   ```text
   | ADMIN-2 | Tenant lockout (zero owners) is unreachable — but by ACCIDENT, and the error message is wrong | governance / resilience | Low | R | 6 | A | 📋 | **PROVEN NOT A DEFECT, and now pinned.** Established by a DISCRIMINATING EXPERIMENT rather than assumed: with **two** owner grants the first revoke SUCCEEDS and the last is REFUSED. `emit_role_change` is an `AFTER I/U/D` trigger that re-checks `app.authorize('MANAGE_USERS')`, by which point the granting row is already inactive — so the caller no longer holds the permission they just gave up. The protection is real and correct in effect, and `authenticated` holds no DELETE on the table, so zero-owner is unreachable on every path. It is also **fragile and undocumented**: moving that trigger to BEFORE, or dropping its `authorize` call, would make a tenant permanently unadministrable with nothing noticing — test 76 assertions 15-17 pin it. **RESIDUAL, unfixed:** the message is `permission denied: MANAGE_USERS` shown to someone who demonstrably holds it, so an owner attempting a handover gets an inscrutable error. Not fixed because the alternative is duplicating the rule in a second authority, which `AGENTS.md` One-Authority forbids; revisit if handover becomes a real workflow | — | api-3-admin-2026-08-30 | 08-30 | 08-30 |
   ```
   with
   ```text
   | ADMIN-2 | Tenant lockout (zero owners) is unreachable — but by ACCIDENT, and the error message is wrong | governance / resilience | Low | R | 6 | A | 📋 | **PROVEN NOT A DEFECT, and now pinned.** Established by a DISCRIMINATING EXPERIMENT rather than assumed: with **two** owner grants the first revoke SUCCEEDS and the last is REFUSED. `emit_role_change` is an `AFTER I/U/D` trigger that re-checks `app.authorize('MANAGE_USERS')`, by which point the granting row is already inactive — so the caller no longer holds the permission they just gave up. The protection is real and correct in effect, and `authenticated` holds no DELETE on the table, so zero-owner is unreachable on every path. It is also **fragile and undocumented**: moving that trigger to BEFORE, or dropping its `authorize` call, would make a tenant permanently unadministrable with nothing noticing — test 76 assertions 15-17 pin it. **RESIDUAL, unfixed:** the message is `permission denied: MANAGE_USERS` shown to someone who demonstrably holds it, so an owner attempting a handover gets an inscrutable error. Not fixed because the alternative is duplicating the rule in a second authority, which `AGENTS.md` One-Authority forbids; revisit if handover becomes a real workflow. **2026-11-11 (SPEC-306): it did not hold for a re-point: a lone owner changed their own grant's role by direct UPDATE, which the emitter never charged (URA-3); with a grant's holder, role, scope and start fixed for every session, zero owners is again unreachable on every session path.** | — | api-3-admin-2026-08-30 | 08-30 | 08-30 |
   ```

   c) immediately after the line
   ```text
   | DEP-3 | **A department could be moved to another branch, stranding the work filed under it outside every department queue** | integrity · authorization | Medium | R | 6 | M | ✅ | **✅ FIXED 2026-11-11 (SPEC-305, `20261111130000`), DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-305; the fresh Founder ledger, functions and structure equal local.** **MEASURED** in CRM at `2e05d41` (SPEC-301) and again at `906edeb` on ORVION's Founder local stack: `app.create_lead`, `app.create_booking`, `app.assign_user_branch` and `app.link_internal_supplier` each require the department to belong to the row's branch, but 17 of the 18 foreign keys into `departments` reference `(tenant_id, id)` only; only SPEC-300's placement FK pinned the branch. A `ceo` at `aal1` moved an unplaced department from one branch to another: its lead stayed at the old branch and the moved department, a pair `app.create_lead` then refused; the department's new-branch employee, placed by the RPC, did not see it; and no department reader can be placed at the old pair again. **Repaired:** `app.guard_department_write` refuses an UPDATE of `branch_id` 23514 on every path, with or without a session; a move is a new department in the other branch, and with the branch fixed the tenant is fixed too. No writer moved a department's branch. **Latent:** 0 departments and 0 mismatched lead or booking pairs on Primary and Founder Secondary. **Recorded position:** `is_active` binds nothing: `app.create_lead` and `app.assign_user_branch` accepted an inactive department, and no function reads `departments.is_active`, `name` or `department_type_code`; reopening trigger: a department lifecycle flow that must stop new work in a closed department. Pinned by `161_...` and mutant M2 (the branch fix removed), killed | — | SPEC-305-a-department-stays-in-its-branch-and-changes-only-with-authority-and-a-record | 11-11 | 11-11 |
   ```
   insert
   ```text
   | URA-1 | **An `aal1` owner or ceo re-pointed live role grants through the table that `app.assign_user_role` refuses them: an employee to owner, the owner's grant to another user, a scope moved, a start pushed ahead** | security · authorization | High | R | 6 | M | 🛡 | **FIXED 2026-11-11 locally (SPEC-306, `20261111140000`); Founder Secondary deployment pending.** **MEASURED** in CRM at `03009ec`, and identical at `12496f8` here (the same migrations and tests blob for blob, and the same pre-change structure): a `ceo` at `aal1`, refused "multi-factor authentication required" by the RPC, by direct UPDATE of live rows re-pointed an employee's grant to `owner` (the employee gained MANAGE_USERS), moved the owner's grant to another user (the owner lost every permission), moved a branch-scoped grant to another branch and widened it to tenant scope, and pushed the owner grant's `starts_at` a year ahead (suspending it) and back. Cause: `app.emit_role_change` (RBAC-1) charges `app.authorize('MANAGE_USERS')` only when `is_active` or `ends_at` changes liveness, and returns early for an UPDATE that keeps a row live; it never reads `starts_at`; the RLS update policy charges `app.has_permission('MANAGE_USERS')` only. **Repaired:** `app.guard_role_assignment_change` (BEFORE UPDATE, SECURITY DEFINER, session writes only) fixes a grant's tenant, holder, role, scope, branch, department, start and creation time (23514), and a live grant's `ends_at` while it stays live; a session changes a grant only by ending it or starting it, which `app.emit_role_change` charges and records. `162_a_role_grant_changes_only_by_revoke_and_assign_test.sql` pins it. | — | SPEC-306-a-role-grant-changes-only-by-revoke-and-assign | 11-11 | 11-11 |
   | URA-2 | **A role grant re-pointed while live was never recorded, on any door and at any assurance level** | audit completeness · observability | High | R | 6 | M | 🛡 | **FIXED 2026-11-11 locally (SPEC-306, `20261111140000`); Founder Secondary deployment pending.** **MEASURED** in CRM at `03009ec`, and identical at `12496f8` here (the same migrations and tests blob for blob, and the same pre-change structure): every re-point of URA-1 recorded 0 events, and at `aal2` a trainee grant re-pointed to `ceo` recorded 0 too; the security stream showed no privilege change. RBAC-1 audits liveness only. **Repaired:** `app.guard_role_assignment_change` (BEFORE UPDATE, SECURITY DEFINER, session writes only) fixes a grant's tenant, holder, role, scope, branch, department, start and creation time (23514), and a live grant's `ends_at` while it stays live; a session changes a grant only by ending it or starting it, which `app.emit_role_change` charges and records. `162_a_role_grant_changes_only_by_revoke_and_assign_test.sql` pins it. Every change a session can still make (revoke, expiry, reactivation) is recorded once with its actor, as before. | — | SPEC-306-a-role-grant-changes-only-by-revoke-and-assign | 11-11 | 11-11 |
   | URA-3 | **A tenant's lone owner could leave the tenant with no administrator by re-pointing their own grant (ADMIN-2's protection held for revocation only)** | governance · resilience | Medium | R | 6 | M | 🛡 | **FIXED 2026-11-11 locally (SPEC-306, `20261111140000`); Founder Secondary deployment pending.** **MEASURED** in CRM at `03009ec`, and identical at `12496f8` here (the same migrations and tests blob for blob, and the same pre-change structure): the lone owner's revoke was refused (ADMIN-2: the AFTER emitter re-charges MANAGE_USERS once the grant is gone), but the same owner changed their own grant's role to `employee` by direct UPDATE at `aal2` and the tenant was left with 0 MANAGE_USERS holders, unadministrable. **Repaired:** `app.guard_role_assignment_change` (BEFORE UPDATE, SECURITY DEFINER, session writes only) fixes a grant's tenant, holder, role, scope, branch, department, start and creation time (23514), and a live grant's `ends_at` while it stays live; a session changes a grant only by ending it or starting it, which `app.emit_role_change` charges and records. `162_a_role_grant_changes_only_by_revoke_and_assign_test.sql` pins it. The re-point is refused, so ADMIN-2 holds on every session path again. | — | SPEC-306-a-role-grant-changes-only-by-revoke-and-assign | 11-11 | 11-11 |
   ```

   The resulting file's Git blob is faece3d086ddb22c556026141299a7bfe31c067a.

5. Check whether `reports/master/MASTER_SURFACE_DISPOSITION.md` contains `**48 of 78 recorded · 24 `; if so record Already Applied when its Git blob is c33a7f92b86fed2bc8c5c745ea57b15a3f1c9a4c, and otherwise stop and report. Otherwise make exactly these 4 edits (the freshness entry, coverage 48 of 78 and the user_role_assignments row), each matched once, and change nothing else:

   a) replace the line
   ```text
   Last updated: 2026-11-11 (**slice 46 — `departments` selected by Exposure 7, coverage 666; runner-up `user_role_assignments` at 7/678.** Coverage **46 → 47 of 78**. DEP-1: a `ceo` at `aal1` created, renamed, re-typed, deactivated and moved departments by direct table writes the RPC refuses at that level. DEP-2: no door recorded any of it. DEP-3: a moved department stranded its existing lead at a branch and department pair every writer refuses, outside every department queue. SPEC-305, the twin of CRM SPEC-301, closes all three here, so the row is `AUDITED`, with its recorded position and its reopening trigger. No other row changed.)
   ```
   with
   ```text
   Last updated: 2026-11-11 (**slice 47 — `user_role_assignments` selected by Exposure 7, coverage 684; runner-up `customer_consents` at 6/18.** Coverage **47 → 48 of 78**. URA-1: a `ceo` at `aal1` re-pointed live role grants by direct UPDATE (an employee to owner, the owner's grant to another user, a scope, a start). URA-2: none of it was recorded, at `aal2` either. URA-3: a lone owner demoted their own grant and left the tenant with no administrator. SPEC-306 (the twin of CRM SPEC-302) closes all three here, so the row is `AUDITED`.)

   Previously: 2026-11-11 (**slice 46 — `departments` selected by Exposure 7, coverage 666; runner-up `user_role_assignments` at 7/678.** Coverage **46 → 47 of 78**. DEP-1: a `ceo` at `aal1` created, renamed, re-typed, deactivated and moved departments by direct table writes the RPC refuses at that level. DEP-2: no door recorded any of it. DEP-3: a moved department stranded its existing lead at a branch and department pair every writer refuses, outside every department queue. SPEC-305, the twin of CRM SPEC-301, closes all three here, so the row is `AUDITED`, with its recorded position and its reopening trigger. No other row changed.)
   ```

   b) replace the line
   ```text
   **47 of 78 recorded · 23 `AUDITED` · 21 `AUDITED-OPEN` · 3 `PARTIAL` · 0 `EXEMPT` · 31 `NOT-RECORDED`.**
   ```
   with
   ```text
   **48 of 78 recorded · 24 `AUDITED` · 21 `AUDITED-OPEN` · 3 `PARTIAL` · 0 `EXEMPT` · 30 `NOT-RECORDED`.**
   ```

   c) replace the line
   ```text
   **All 47 recorded surfaces stand at `ADVERSARIAL`, and Check 24 (ADV-1) is what makes that word cost something**: a surface may not carry it unless a pgTAP file names it, declares which attack classes it aimed at (`-- ATTACK-CLASSES:`, closed vocabulary), and carries at least one negative assertion. A file of positive controls earns `TESTED` and no more.
   ```
   with
   ```text
   **All 48 recorded surfaces stand at `ADVERSARIAL`, and Check 24 (ADV-1) is what makes that word cost something**: a surface may not carry it unless a pgTAP file names it, declares which attack classes it aimed at (`-- ATTACK-CLASSES:`, closed vocabulary), and carries at least one negative assertion. A file of positive controls earns `TESTED` and no more.
   ```

   d) replace the line
   ```text
   | `user_role_assignments` | NOT-RECORDED | — | — | — | — |
   ```
   with
   ```text
   | `user_role_assignments` | **AUDITED** | ADVERSARIAL | `SPEC-306-a-role-grant-changes-only-by-revoke-and-assign` | URA-1, URA-2, URA-3 | `162_a_role_grant_changes_only_by_revoke_and_assign_test.sql` (19 assertions, ten attack classes declared, CONCURRENCY and REPLAY N/A) proves that a password-only (`aal1`) session is refused every re-point of a live grant (role, holder, branch scope, start) and a live grant's end extension, as the RPC refuses it; that a stepped-up session is refused a re-point too and the grant is unchanged; that the RPC revoke, a direct expiry and a reactivation still work and are each recorded once with the actor while refused and no-op updates record nothing; that a lone owner cannot demote their own grant and ADMIN-2 still refuses their revoke; and that a session-less platform write is still admitted. Positions: a grant issued with a future start records `role_assigned` at issue; a `platform` scope from a tenant session is accepted and read by nothing. |
   ```

   The resulting file's Git blob is c33a7f92b86fed2bc8c5c745ea57b15a3f1c9a4c.

6. **Check** for a `Pre-deploy readiness gate` Execution Log entry. If absent, with Steps 1–5 applied and uncommitted in the main checkout, record, with actual values:
   - the SHA-256, md5 and byte counts of the migration and test 162, which must equal Consumer Closure, and the Git blobs of the migration, test 162 and test 99, which must equal CRM SPEC-302's (`a8bf49fc65755692579727419b4baa191f7933c6`, `eac192dd08669d6c79ef2fed2190a7b4962e3984`, `00a89a03ad412ae26c5dd60c6e66d2eb4d414555`);
   - the identity: `supabase/migrations` and `supabase/tests` at the baseline equal CRM's at `03009ec` (trees `d3e3a44178a2666b7489c4e8dfb742675c6a3b83` and `516143fb34471f0fb82c46ba2e71a25c575cb606`), so CRM SPEC-302's prototype results (the guard's shape, test 162 and tests 99, 51 and 76 alone, the probes, mutants M1–M3, the causal negative and the structural fingerprints before and after) hold here; they are cited, not re-run;
   - the API-contract and map generators, the scope check and `git diff --check`.

   Treat as expected at this boundary only: an undeployed Founder Secondary and the six measured-state items of Consumer Closure.

   Read a fresh Founder Secondary baseline through the Founder connector, read-only: the project URL, the full ordered ledger and the absence of the target migration; the function and structural surfaces, which must equal CRM Primary's before SPEC-302 (`_combined` `acaa0b419371eb704cc531ad84769485`/3150); the triggers of `user_role_assignments`, the absence of the guard function; the tenant and role-assignment counts. Record the predicted delta. If any reading differs, stop.
7. **Check** that an exact-SHA Gate-2 record for the migration is in the Execution Log: the owner's own, or one marked DELEGATED naming this contract, the migration's SHA-256, Founder Secondary `brplkqmbzffpxqgkkdzo` and the owner's instructions under which it is taken. If absent, write it only when Step 6 passed and those instructions cover a migration that drops no table or column and deletes or rewrites no business row; otherwise stop after Step 6 and present the Gate-2 package.
8. **Check** that Founder Secondary `brplkqmbzffpxqgkkdzo` lacks `20261111140000_a_role_grant_changes_only_by_revoke_and_assign`. If it is absent and Step 7 is recorded:
   - Immediately re-read HEAD, the hashes, the project URL, the full ordered ledger, target absence, the business counts and the triggers of `user_role_assignments`.
   - On an exact match, prove the transmitted text's md5 server-side, then apply only the authorized migration through the Founder write connector `supabase-secondary-write`, after its `get_project_url` names `brplkqmbzffpxqgkkdzo`.
   - If the connector assigns a temporary version, rename only that one newly inserted ledger row. The rename requires exactly one new row, its stored statement md5 equal to the file's, and no existing target version.
   - Read fresh through the Founder connector: the ledger, the function surface and all ten structural surfaces, with the exact `read_query` recorded in `reports/evidence/founder-ledger-evidence.json`; the triggers of `user_role_assignments`; the guard's `md5(prosrc)`, security mode and ACL, and the emitter's; the business counts.

   Never contact Primary `vrvtsxexkiiiivlkdxzp`.
9. **Check** that fresh Founder evidence contains the new migration exactly once. If so:
   - Update `reports/evidence/founder-ledger-evidence.json` (schema 3) from those readings only: `read_at`, `read_via`, the unchanged `read_query`, `repository_head` (the HEAD at the read), the full ledger, its count and fingerprint, both surface hashes and counts, and `surface_rows`. `scripts/check_primary_ledger.ps1` and `scripts/check_database_parity_evidence.ps1` must then pass.
   - In `_ORVION_CANONICAL/manifest.md`, set `Live state` from the same readings in its existing form (migration count, latest, ledger, and the two surface hashes and counts), with **80 client RPCs** unchanged.
   - Confirm that `supabase/tests` holds 162 files whose literal `plan(N)` values sum to 3077, then set `Suite **162 files / 3077 assertions**`. If either differs, stop.
   - In each of the three rows URA-1, URA-2 and URA-3 of the register, replace the text `` | 🛡 | **FIXED 2026-11-11 locally (SPEC-306, `20261111140000`); Founder Secondary deployment pending.** `` with `` | ✅ | **✅ FIXED 2026-11-11 (SPEC-306, `20261111140000`), DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-306; the fresh Founder ledger, functions and structure equal local.** `` (each span's one leading and one trailing space are delimiters, not text). Change nothing else in the register.
   - Regenerate `ai-map.json` and `repository-index.md` (stored LF) with the canonical generators, and confirm the API-contract generator's output is identical to `MASTER_API_CONTRACT.md`.
   - Set the Runtime Checkpoint to DONE, append the Execution Log, and commit the implementation once; the pre-commit Gate must admit it.

   If Founder Secondary is unproven, stop.
10. **Check** for a `Post-deploy local certification` Execution Log entry. If absent:
   - Run canonical `-Finish` through `scripts/run_timed.ps1`, watched by `scripts/watch_run.ps1`, and require `LOCAL_CERTIFY: READY`.
   - Independently Review the committed implementation against every Acceptance Criterion. After `Verdict: Confirmed Complete`, in the Complete commit: transition to Complete, tick the Acceptance Criteria and the Review Gate, clear `Active Change Request`, set `Last Completed` from Notes, leave `Next capability` and `Current Module` unchanged, and regenerate `ai-map.json` and `repository-index.md` LF.
   - Bind the exact candidate with `-Gate -BindCandidate`. Publication and promotion follow the native release path separately.

## Acceptance Criteria

- [x] The migration is the frozen bytes; `check: blob supabase/migrations/20261111140000_a_role_grant_changes_only_by_revoke_and_assign.sql a8bf49fc65755692579727419b4baa191f7933c6`
- [x] Test 162 is the frozen bytes; `check: blob supabase/tests/162_a_role_grant_changes_only_by_revoke_and_assign_test.sql eac192dd08669d6c79ef2fed2190a7b4962e3984`
- [x] Test 99's backdate is a session-less fixture step; `check: blob supabase/tests/99_role_assignment_temporal_test.sql 00a89a03ad412ae26c5dd60c6e66d2eb4d414555`
- [x] The disposition record carries `user_role_assignments` AUDITED / ADVERSARIAL and coverage 48 of 78; `check: blob reports/master/MASTER_SURFACE_DISPOSITION.md c33a7f92b86fed2bc8c5c745ea57b15a3f1c9a4c`
- [x] URA-1, URA-2 and URA-3 are fixed and deployed in the register; `check: has reports/master/MASTER_GAP_REGISTER.md "DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-306"`
- [x] The manifest suite figure equals the files; `check: has _ORVION_CANONICAL/manifest.md "Suite **162 files / 3077 assertions**"`
- [x] Native evaluator remains exact; `check: same scripts/check_agent_continuity.ps1 @12496f8dd9496da539513731084ddf8d31cfb728`
- [x] The role-change emitter's migration remains exact; `check: same supabase/migrations/202607055100_role_change_audit_and_cursor_authority.sql @12496f8dd9496da539513731084ddf8d31cfb728`
- [x] Founder Secondary `brplkqmbzffpxqgkkdzo` received only the authorized migration and at most the one guarded ledger rename, with no business-data write, after a recorded Step 6 readiness gate and Step 7 Gate-2 record; Primary `vrvtsxexkiiiivlkdxzp` was never contacted.
- [x] The identity with CRM SPEC-302 is proven (payload blobs, migrations and tests trees, Founder Secondary's pre-change structure), so its mutants M1–M3, each killed with installation and restoration proven, and its causal negative hold here.

## Execution Log

### 2026-11-11 — Steps 1–5 applied

- **Lifecycle:** allocate `318c9ec`, Approve `f82deb5` (APPROVAL_EVIDENCE PASS; 8 of 10 criteria Gate-checked), DELEGATED Gate 1 recorded in Verification Notes.
- **Steps 1–5** by the literal-step replay, every file absent or at its `12496f8` blob, each result at its pinned blob: migration `a8bf49fc65755692579727419b4baa191f7933c6`, test 162 `eac192dd08669d6c79ef2fed2190a7b4962e3984`, test 99 `00a89a03ad412ae26c5dd60c6e66d2eb4d414555` (the three equal to CRM SPEC-302's committed blobs), register `faece3d086ddb22c556026141299a7bfe31c067a`, disposition `c33a7f92b86fed2bc8c5c745ea57b15a3f1c9a4c`. Uncommitted until Step 9: the pre-commit guard refuses the measured-state items before the deploy.

### 2026-11-11 — Pre-deploy readiness gate (Step 6)

From the main checkout at HEAD `f82deb5`, Steps 1–5 applied and uncommitted, one logged script (16:02–16:05 Cairo); the identity proof in place of a local re-proof:
- **Bytes.** Migration SHA-256 `af0e95392ea4b77b482d7524b5b81e02a141cb88bbf9bae3933c3f4d967fa7a0`, md5 `b134eea648d20ff63c4014683cf326c5`, 4483 bytes; test 162 SHA-256 `1b62e1f1f7aa93fd5145addfb2d10a64d95732ca2c5c4135e4798847a997fa58`, md5 `ee930285654a4693abfd5c9ee1832ad3`, 9788 bytes; both LF (0 CR) and ASCII. Equal to Consumer Closure.
- **Identity.** The Git blobs of the migration, test 162 and test 99 equal CRM SPEC-302's at its implementation commit `b9384f991e5210fc0ba1b185d8ca5237c59b9a81`; `supabase/migrations` (tree `d3e3a44178a2666b7489c4e8dfb742675c6a3b83`) and `supabase/tests` (tree `516143fb34471f0fb82c46ba2e71a25c575cb606`) at the baseline equal CRM's at `03009ec`, and the same three `supabase` paths changed here as there. CRM SPEC-302's Step 6 results therefore hold here and are cited, not re-run: guard `10f82654…`, test 162 19/19 and tests 99, 51 and 76 alone, the probes, mutants M1–M3 killed with restoration proven, the causal negative (162 fails 1, 3–7, 9–10, 16 and 18), and parity 257 `acaa0b41…`/3150 → 258 `48183b9c…`/3152.
- **The local Founder stack** after a clean reset with the project-local CLI 3.0.0: 258 migrations, latest `20261111140000`; guard `md5(prosrc)` `10f82654759c36635b6d3a20edad5db6`; emitter `5b53fafd89abc36d83825cb1c94fec79`; `parity_surface.sql` functions `1273cd1b48c879d51aedce0e9818f89b`/337, triggers `c83a7f55085f143723054abb9653d0d5`/324, `_combined` `48183b9ce5d79728a1a952f38cbfbbc3`/3152, each equal to CRM's.
- **Generators, scope and diff.** The API-contract generator's output is identical to `MASTER_API_CONTRACT.md`; `generate-ai-map.ps1 -Check` exit 0. Only the five Step 1–5 paths changed; `git diff --check` clean.
- **Consistency:** exactly the six expected pre-deploy items, the same as the sandbox: Check 9 ×3 (count, latest, ledger fingerprint), Check 15 ×2 (files, assertions), RECOVER-1 (Founder evidence).
- **Fresh Founder Secondary baseline**, read-only through `supabase-secondary` (the project URL and the grants surface through `supabase-secondary-write` inside `BEGIN TRANSACTION READ ONLY`, 13:44–13:53 UTC): URL `https://brplkqmbzffpxqgkkdzo.supabase.co`; ledger 257 `ed3211eac78a43cdcf04f44235d5516d`, latest `20261111130000`, target absent by version and by name; the guard function absent; `user_role_assignments` triggers `user_role_assignments_derive_actor` and `user_role_assignments_emit_role_change`; emitter `5b53fafd…`; 0 tenants, 0 role assignments, 0 events. `parity_surface.sql`: functions `5d50b5ba57ec83e66c6ad492a22ff050`/336, triggers `59b4283fc37e2bd9f997b84744139f27`/323, `_combined` `acaa0b419371eb704cc531ad84769485`/3150, equal to the recorded Founder evidence and to CRM Primary's before SPEC-302.
- **Predicted delta:** ledger 258 `dec3a3db…`; functions `1273cd1b…`/337; triggers `c83a7f55…`/324; `_combined` `48183b9c…`/3152; guard `10f82654…`; the guard trigger BEFORE UPDATE; emitter unchanged; business counts unchanged.

### 2026-11-11 — Gate 2 (Step 7), DELEGATED

DELEGATED exact-SHA Gate-2 record for SPEC-306: migration `supabase/migrations/20261111140000_a_role_grant_changes_only_by_revoke_and_assign.sql`, SHA-256 `af0e95392ea4b77b482d7524b5b81e02a141cb88bbf9bae3933c3f4d967fa7a0`, md5 `b134eea648d20ff63c4014683cf326c5`, 4483 bytes, to Founder Secondary `brplkqmbzffpxqgkkdzo` only, under the owner's instructions of 2026-11-08 (class authorization for Batch 6 releases and standing approval of proposals ~10:20 Cairo; publish, promote and hosted deploy ~12:05 Cairo) and 2026-11-11 (slice 5 run mode 2, run through to both products' publish, promote and remote Certify ~14:48 Cairo), recorded outside this repository. Step 6 passed. The migration's top-level statements are one `create or replace function` with its `revoke` and one `create trigger`: it drops no table or column and deletes or rewrites no business row. Not a human-typed digest. Primary `vrvtsxexkiiiivlkdxzp` is not a target.
### 2026-11-11 — Founder Secondary deployment (Step 8)

Through the Founder write connector `supabase-secondary-write` from this VS Code session, 14:05–14:07 UTC; Primary `vrvtsxexkiiiivlkdxzp` not contacted:
- **Immediate re-read, exact match** (inside `BEGIN TRANSACTION READ ONLY`, 14:06:06 UTC). HEAD `f82deb51f1c6eefda041e9e8c4614c224c7d55e1`; migration SHA-256 `af0e95392ea4b77b482d7524b5b81e02a141cb88bbf9bae3933c3f4d967fa7a0`, md5 `b134eea648d20ff63c4014683cf326c5`, 4483 bytes, LF, ASCII; `get_project_url` `https://brplkqmbzffpxqgkkdzo.supabase.co`; ledger 257 `ed3211eac78a43cdcf04f44235d5516d`, latest `20261111130000`, target absent by version and by name; the guard absent; triggers of `user_role_assignments` as in Step 6; 0 tenants, 0 role assignments, 0 events.
- **Transmitted text** proven server-side in the same read: `md5` `b134eea648d20ff63c4014683cf326c5`, equal to the file. Applied once with `apply_migration` (`a_role_grant_changes_only_by_revoke_and_assign`).
- **Guarded rename.** The connector stored version `20261111140620`: exactly one new row, one stored statement with md5 `b134eea6…` and 4483 characters, no existing target. One guarded `UPDATE` (row count required 1) renamed it to `20261111140000`.
- **Fresh reads** (14:06:36 and 14:07:09 UTC, the second with the evidence `read_query`'s expressions). Ledger 258 `dec3a3dbe82e0568e8d98e5418f23436`, latest `20261111140000`, equal to the migration files; functions (`app`, `public`) `1273cd1b48c879d51aedce0e9818f89b`/337; `parity_surface.sql`: functions `1273cd1b48c879d51aedce0e9818f89b`/337, triggers `c83a7f55085f143723054abb9653d0d5`/324, the other eight surfaces unchanged, `_combined` `48183b9ce5d79728a1a952f38cbfbbc3`/3152, each equal to the local Founder stack after a clean reset and to CRM Primary after SPEC-302; `user_role_assignments` triggers `user_role_assignments_derive_actor`, `user_role_assignments_emit_role_change` and `user_role_assignments_guard_change` (BEFORE UPDATE); guard `md5(prosrc)` `10f82654759c36635b6d3a20edad5db6`, SECURITY DEFINER, ACL `{postgres=X/postgres}`; emitter `5b53fafd89abc36d83825cb1c94fec79`, unchanged; catalog 71/625; 0 tenants, 0 role assignments, 0 events. No business row was written.

### 2026-11-11 — Post-deploy records (Step 9)

- `reports/evidence/founder-ledger-evidence.json` (schema 3) from the Step 8 readings only (read 2026-11-11 14:07:09 UTC, `repository_head` `f82deb5`, `read_query` unchanged): 258 entries whose fingerprint recomputes to `dec3a3db…`, functions `1273cd1b…`/337, structure `48183b9c…`/3152, `surface_rows` functions, triggers and `_combined` moved. `scripts/check_primary_ledger.ps1` RECOVER-1 CLEAN; `scripts/check_database_parity_evidence.ps1` FOUNDER PARITY EVIDENCE CLEAN.
- Manifest `Live state` set from the same readings in its existing form; **80 client RPCs** unchanged. `supabase/tests` holds 162 files whose literal `plan(N)` sum to 3077; `Suite **162 files / 3077 assertions**`.
- URA-1, URA-2 and URA-3 register rows replaced with the DEPLOYED text, nothing else changed.
- `ai-map.json` and `repository-index.md` regenerate byte-identical, LF; the API-contract generator's output is identical to `MASTER_API_CONTRACT.md`.
- Repository consistency CLEAN (exit 0). The four CI-only guard self-tests are not run here: `orvion-acceptance` runs them on the exact candidate SHA before `main` may move to it (Consumer Closure).
- Runtime Checkpoint DONE; Status Approved → In Progress; one implementation commit.

## Verification Notes

None.


### 2026-11-11 — Gate 1 approval recorded

DELEGATED exact Gate1 under the owner's instructions of 2026-11-08 (class authorization for Batch 6 releases and standing approval of proposals ~10:20 Cairo; publish, promote and hosted deploy ~12:05 Cairo) and 2026-11-11 (slice 5 run mode 2, run through to both products' publish, promote and remote Certify ~14:48 Cairo; P7 is this ORVION twin of CRM SPEC-302); Draft SHA-256 2CF992EF34F74D2D4FEAAE02B22F0A4C60675DFB312388074B0CA04063E06142, decision SHA-256 08900472976C0DBF349642541D839CCC3CFE9D4F30A80F584578EF03E3841D87. No fabricated human future-digest approval. Gate 2 (Founder Secondary deploy) is a separate exact-SHA record in Step 7. Immediately before allocation the hash, the Draft blob fbd5c9d8cdb933f5ff714d883a024cae431069a9, all 3 source anchors, the baseline HEAD 12496f8dd9496da539513731084ddf8d31cfb728 against refreshed origin/main 12496f8dd9496da539513731084ddf8d31cfb728 and a clean checkout were revalidated, and the pre-commit allocator admitted the identity; Draft allocated as 318c9ec. No implementation performed before this transition.


Verdict: Confirmed Complete

Independent current Git evidence: selected Draft 2CF992EF34F74D2D4FEAAE02B22F0A4C60675DFB312388074B0CA04063E06142, allocated blob fbd5c9d8cdb933f5ff714d883a024cae431069a9, the five literal outputs (migration, test 162 and test 99 byte-identical to CRM SPEC-302; register and disposition as frozen), the recorded Step 6 readiness gate with the identity proof, the DELEGATED exact-SHA Gate-2 record, the Founder Secondary deploy of only 20261111140000 to brplkqmbzffpxqgkkdzo with the fresh post-deploy ledger, functions and structure equal to local, the Step 9 records (Founder ledger evidence, manifest Live state and suite 162/3077, URA-1, URA-2, URA-3 DEPLOYED, API contract identical), regenerated discovery, unchanged native evaluator and role-change emitter migration, and declared scope verified; Primary vrvtsxexkiiiivlkdxzp was never contacted. This original root owns fresh receipt 62afa99d1c94c9cec934402a42edac57570fc1279a9cc866a1be525fdcf76969, finishHead ce21a2f1475b713e8ba7c4f3ec04b96acb458a02, profiles DATABASE,REPOSITORY, in a native timed/watched Finish observed READY/END0. Native Complete/range/binder still own full receipt/criterion validation. No publication or hosted result asserted.


Local original native verification and truthful Review complete. Preserve this root's receipt 62afa99d1c94c9cec934402a42edac57570fc1279a9cc866a1be525fdcf76969 and selected bytes. Candidate binding follows Complete; publication/promotion remain separately governed.

## Review Gate

- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [x] No file outside Write Scope was modified, created, or deleted.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] If this Change Request's Supersedes / Depends On section names another file, that file's Status has been updated accordingly.
- [x] The repository is in a clean, releasable state.

## Notes

After actual native Finish and truthful Review, synchronize only this contract and the declared manifest/discovery paths to Complete. Set `Last Completed: **SPEC-306: Batch 6 Slice 47 — a role grant changes only by revoke and assign (URA-1, URA-2, URA-3), the twin of CRM SPEC-302, deployed to Founder Secondary; native verification and Review complete. Publication/promotion remain separately governed.**` and regenerate discovery. `Next capability` and `Current Module` stay unchanged: the selector names the next slice. Candidate binding follows Complete and is never a pre-Complete criterion.

Exact baseline 12496f8dd9496da539513731084ddf8d31cfb728 and source anchors:

| Path | Baseline Git blob |
| --- | --- |
| `supabase/tests/99_role_assignment_temporal_test.sql` | `a5d175994becbe0f80dd599ac44939d78fecb52c` |
| `reports/master/MASTER_GAP_REGISTER.md` | `dfa2182bd4194167cf86c48bab156a7e5d65a603` |
| `reports/master/MASTER_SURFACE_DISPOSITION.md` | `c541350eec08f609ca8661dfbb880b2eb0716627` |

Selection sources: native AGENTS.md, CR_LIFECYCLE.md, ENGINEERING_METHOD.md, GOVERNANCE.md, SPEC-287 and SPEC-305 at 12496f8dd9496da539513731084ddf8d31cfb728; CRM SPEC-302 (the twin's origin and its adopted proof); the owner's instructions of 2026-11-08 and 2026-11-11 (recorded outside this repository). This is the one Draft for this surface, finalized after the adversarial review and the evidence refresh its Draft Assurance records; correctness remains native and independent.
