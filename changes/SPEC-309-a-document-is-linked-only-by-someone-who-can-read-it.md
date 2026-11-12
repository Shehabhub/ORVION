# Change Request — SPEC-309

## Status

[ ] Draft
[ ] Approved
[x] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Batch 6 Slice 50 makes a document link writable only by someone who can already read its document, and records every moved link, so a branch employee can no longer read another branch's passport scan or invoice by linking it onto their own booking, and no document leaves the record it belongs to unrecorded (DOC-9, DOC-10).

## Business Reason

- **Selection.** CRM's `scripts/batch6_select_target.ps1` at `789e056`, on its live local catalog, ranks `document_links` first: Exposure 6, coverage 54, NOT-RECORDED (runner-up `exchange_rates` 6/66). This repository at `d5224e3` holds the same migrations, and its disposition record's 83 surface rows carry the same statuses, so the twin takes the same surface. The manifest's Next capability names the selector, never a copy of its result.
- **The twin, adopted by identity.** CRM measured and fixed these findings in its SPEC-306 (`changes/SPEC-306-a-document-is-linked-only-by-someone-who-can-read-it.md` in CRM; this repository's `SPEC-306` is the unrelated `a-role-grant-changes-only-by-revoke-and-assign`). At `d5224e3`, `supabase/migrations` (tree `4cf167f371d5246f7a4a492d65dd40d082be87f9`) and `supabase/tests` (tree `b965dfb6be5a6bb3c0f234c513e501cd3f782db0`) equal CRM's at SPEC-306's baseline `789e056`; Founder Secondary's ten structural surfaces before the change (`_combined` `0e398aeac8e622fabeda83ac1900bf9d`/3156) equal CRM Primary's before SPEC-306; the migration and test 165 here are CRM SPEC-306's committed bytes, and canon 27 is CRM's text with this contract's id. CRM's prototype measurements, probes, mutants and causal negative therefore hold here unchanged; they are cited, not re-run. This contract re-proves the identity, reads Founder Secondary, and runs its own native lifecycle, whose Finish re-runs the DATABASE protocol on the final bytes.
- **Why it matters.** A link decides who reads a document: the `documents` policy admits a non-confidential document through any `document_links` row the caller can see, and a link is visible when its target record is (SPEC-144). `app.is_document_responsible` makes the writer of a link onto their own work responsible for a financial document (SPEC-154-B). The link's own `scope_isolation` policy checks only the target. `app.upload_document`, the one RPC that links, links only the document it has just created; the table door (`authenticated` holds INSERT and UPDATE, charged by `guard_write_capability` with `UPLOAD_DOCUMENT`, held by every branch role from `employee` up) checks nothing about the document.
- **Measured in CRM at `789e056`** on its local stack (CRM SPEC-306), probe fixtures rolled back (one tenant with Giza and Suez branches, a Giza and a Suez `employee`, an owner and a trainee; another tenant):
  - **DOC-9 (Medium).** The Giza employee inserted a link from Suez's passport scan onto their own booking, or re-pointed their own ticket link at it, and then read the document, its version and its storage path; the same insert of Suez's invoice made them read it as responsible. A confidential document stayed hidden. The only precondition is the document's id.
  - **DOC-10 (Low).** The Giza employee moved their booking's ticket link to another of their bookings; the tenant's events did not move and `app.derive_created_by` keeps the creator, so nothing showed who took the ticket off the booking.
- **The repair**, in the shape of CRM SPEC-301 (this repository's SPEC-305) (authority BEFORE, record AFTER):
  - `app.guard_document_link_readable`, BEFORE INSERT OR UPDATE (SECURITY INVOKER on purpose, empty `search_path`, executable by no client role), session writes only: the writer must already read the link's document under the `documents` policy. It runs before the row exists, so a link cannot vouch for itself. A write with no session (migrations, seeds, provisioning, `service_role`, fixtures) is exempt, as in every sibling guard.
  - `app.emit_document_link_move`, AFTER UPDATE (SECURITY DEFINER, empty `search_path`, executable by no client role), session writes only: `document_linked`, the code `app.upload_document` already records for its link, on the document, with the link id and the previous and current document and target; an update that moves neither records nothing.
  - No grant, policy, RPC, event code or the other three triggers change. DELETE has no grant.
- **No existing file moves for a test or count.** The guard calls no `app.authorize`, so test 10's MEAS-2 inventory does not move; no event code is added, so the smoke catalog count stays 626; the generated API contract is identical (both functions are trigger functions); a first full suite run passed with no other change. `_ORVION_CANONICAL/27_event_catalog.md` gains one paragraph under `document_linked` saying what it now also records.
- **Swept and found sound, pinned rather than changed:** another tenant's document is refused (now by the guard; before by the composite foreign key); re-tenanting a link and a link with no target are refused by RLS and the single-target CHECK; a trainee without `UPLOAD_DOCUMENT` and an `aal1` owner are refused by `guard_write_capability` and step-up; DELETE has no grant; `app.upload_subscription_payment_proof` writes its proof link through the same table and passes test 47 unchanged.
- **Recorded positions, not repaired:** a new link is attributed by its own derived, immutable `created_by` and records no event of its own; `created_at` is caller-supplied on INSERT and read by nothing that decides (SPEC-216's schema-wide question).
- **Latent on Founder Secondary:** `brplkqmbzffpxqgkkdzo` holds 0 tenants, 0 documents, 0 links and 0 events, ledger 259 `cfd3fcd7719bb2b519efd4bf700636ac`, the target and both functions absent (read-only through the Founder connector, 2026-11-12), so no stored row is affected and no data repair is needed.

## Risks

- **A writer who cannot read a document can no longer link it** (42501, "a document can be linked only by someone who can already read it"); every caller that links through `app.upload_document` creates the document first and reads it as its creator. Tests 28, 35, 47, 48, 50, 57, 58, 80, 82, 88 and 89, which write links, pass unchanged.
- **Trigger order.** BEFORE triggers fire in name order, so a writer refused by both guards now sees this guard's message before `guard_write_capability`'s; the capability guard still refuses a non-holder whose document is readable, and tests 57 and 58 pass unchanged.
- **Founder Secondary deployment is irreversible** and runs only under the exact-SHA Gate-2 record of Step 7. Approval of this contract does not authorize it. Primary `vrvtsxexkiiiivlkdxzp` belongs to CRM and is never contacted.
- **Gate 1 and Gate 2 of this contract are DELEGATED** under the owner's instructions (class authorization for Batch 6 releases and standing approval of proposals, 2026-11-08 ~10:20 Cairo; publish, promote and hosted deploy ~12:05; slice 8 in run mode 2, 2026-11-12 ~17:02 Cairo, whose Lane includes this ORVION twin of CRM SPEC-306), recorded outside this repository; never a human-typed digest.

## Supersedes / Depends On

None.

## Write Scope

- `changes/SPEC-309-a-document-is-linked-only-by-someone-who-can-read-it.md`
- `supabase/migrations/20261112150000_a_document_is_linked_only_by_someone_who_can_read_it.sql`
- `supabase/tests/165_a_document_is_linked_only_by_someone_who_can_read_it_test.sql`
- `_ORVION_CANONICAL/27_event_catalog.md`
- `reports/master/MASTER_GAP_REGISTER.md`
- `reports/master/MASTER_SURFACE_DISPOSITION.md`
- `reports/master/MASTER_API_CONTRACT.md`
- `reports/evidence/founder-ledger-evidence.json`
- `_ORVION_CANONICAL/manifest.md`
- `ai-map.json`
- `repository-index.md`

## Out of Scope — Files Forbidden to Modify

- `supabase/migrations/202607047900_upload_document.sql`
- `supabase/migrations/202607052300_document_read_scope.sql`
- `supabase/migrations/202607054400_document_write_integrity.sql`
- `supabase/migrations/202607054500_subscription_payment_proof_lifecycle.sql`
- `supabase/migrations/202607054700_document_links_payment_proof_branch.sql`
- `supabase/migrations/202607055000_policy_role_scope_consistency.sql`
- `supabase/migrations/202607058700_a_financial_document_follows_the_work_not_the_department.sql`
- `supabase/migrations/20260924140000_document_door_parity.sql`
- `supabase/migrations/20261111150000_a_retention_period_changes_only_with_step_up_and_a_record.sql`
- `supabase/tests/10_grant_model_test.sql`
- `supabase/tests/28_document_scope_test.sql`
- `supabase/tests/47_payment_proof_lifecycle_test.sql`
- `supabase/tests/48_document_storage_test.sql`
- `supabase/tests/57_write_capability_map_test.sql`
- `supabase/tests/58_write_grants_and_config_capability_test.sql`
- `supabase/tests/82_financial_document_responsibility_test.sql`
- `scripts/verify_database.sql`
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
- `supabase/migrations/202607052300_document_read_scope.sql` (the documents and links policies, the one-directional chain) and `202607058700_a_financial_document_follows_the_work_not_the_department.sql` (`app.is_document_responsible`)
- `supabase/tests/28_document_scope_test.sql` and `82_financial_document_responsibility_test.sql`
- `changes/SPEC-144-document-read-scope.md`; `reports/master/MASTER_GAP_REGISTER.md` (DOC-1…DOC-8); `reports/master/MASTER_SURFACE_DISPOSITION.md`; `reports/master/MASTER_EXECUTION_PLAN.md`, Batch 6 method, EC-1…EC-11
- `changes/SPEC-305-a-department-stays-in-its-branch-and-changes-only-with-authority-and-a-record.md` (the guard and emitter shape, the twin of CRM SPEC-301)
- `changes/SPEC-308-a-retention-period-changes-only-with-step-up-and-a-record.md` (the last Founder-deploying slice, the twin of CRM SPEC-305)
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

Pass 1 Design: one BEFORE INSERT OR UPDATE guard on `document_links`, session writes only, requires the writer's own read of the link's document; one AFTER UPDATE emitter records every moved link as `document_linked` with both values; test 165 pins each refused link and re-point beside the reads they would have opened, the RPC's own link, a link of a readable document, the creator attribution, the move's single record, a no-op update, another tenant's owner, the tenant-wide owner and the session-less exemption; the register and disposition record DOC-9, DOC-10 and the surface; canon 27 says what `document_linked` now also records.

Pass 2 Adversarial Review: CRM SPEC-306's, adopted with its bytes (the SPEC numbers below are CRM's, except SPEC-144, SPEC-154, SPEC-216, SPEC-270 and SPEC-278, which this repository shares); there the design was challenged on the prototype. A WITH CHECK clause on the links policy was rejected: the `documents` policy reads `document_links`, and the one-directional chain (SPEC-144) forbids the reverse read. A SECURITY DEFINER guard re-stating the read rule was rejected: it would copy the `documents` policy and drift from it; the invoker reads the policy itself, and mutant M2 shows the definer form admits every document. Revoking INSERT and UPDATE from `authenticated` behind a new RPC was rejected: a new client surface for a door whose only flaw is the missing read precondition. Refusing every move was rejected: moving a misfiled link between records the writer reads is legitimate; it is now checked and recorded. Recording every new link was rejected: `app.upload_document` already records its link, and a direct link is attributed by its derived, immutable `created_by`. A new event code was rejected: `document_linked` already describes a link, at `info` like the RPC's. Refusing session-less writes was rejected: every sibling guard exempts them, and provisioning and the fixtures of eleven tests write links without a session. Attacks run on the final bytes: tests 28, 35, 47, 48, 50, 57, 58, 80, 82, 88 and 89 pass unchanged; the full suite passed first run with no other file moving; the generated API contract is identical; the confidential clause, the composite foreign key, the single-target CHECK, RLS on re-tenanting, the capability guard and step-up were each probed and hold. Copying the selector's next target into the manifest was rejected (SPEC-270; SPEC-278's cancellation).

Pass 3 Evidence Refresh: 2026-11-12. The identity re-proven at `d5224e3`: the migrations and tests trees equal CRM's at `789e056`; the migration and test 165 written here are CRM SPEC-306's committed blobs, and canon 27 equals CRM's blob `609c2a90947eb29b7e56ca7aa5ceecfd2832ae98` with this contract's id in place of CRM's; the disposition's 83 surface rows carry the same statuses; the register and disposition were written by the same script with this contract's id, the identity measurement and Founder Secondary in place of Primary; the API contract is the same blob as CRM's (`ee763c1958b6363d36cc812506f69871531e4368`). Founder Secondary was read read-only for its project URL, ledger, target absence, all ten structural surfaces (equal to CRM Primary's before SPEC-306), the triggers of `document_links` and its counts. CRM SPEC-306's measurements on these bytes (the clean reset, test 165 and tests 28, 82 and 48 alone, pgTAP Pass A and B, the HTTP suites, smoke, the probes, all four mutants, the causal negative, the structural fingerprints before and after, the API-contract generator, the map generator and consistency) are adopted by reference.

Selected Version: SPEC-309; selected: the twin of CRM SPEC-306: the smallest repair that closes DOC-9 and DOC-10 on every session path (one invoker guard that requires the writer's own read of the linked document, one emitter that records a moved link with the existing code; no grant, policy, RPC or event code changed), the migration and test 165 byte-identical to CRM and canon 27 CRM's text with this contract's id, its prototype proof adopted by identity (the same migrations and tests trees and the same pre-change Founder structure)

### Consumer Closure

Applicability: APPLICABLE

| Changed fact or surface | Relevant consumer | Disposition | Evidence / preserved behavior |
| --- | --- | --- | --- |
| Every session link and re-point requires the writer's read of the document | the table door (RLS insert and update) of every `UPLOAD_DOCUMENT` holder; `app.upload_document`; `app.upload_subscription_payment_proof` | WRITE | Migration SHA-256 `5bfb8e52155d367b5aab3e516e7b295d2ea30b3f0589df935396cbd0a37af9f3`, md5 `149882262bc6f900927121fcc13005b4`, 4684 bytes, LF, ASCII. A clean reset gives 260 migrations, latest `20261112150000`, ledger `5f6e412ee282edaf1e16346c3d5b5805`; guard `md5(prosrc)` `692eee1f6c5a0944a5d06e18f5a3a655`, SECURITY INVOKER, ACL `{postgres=X/postgres}`; trigger `document_links_guard_document_readable` BEFORE INSERT OR UPDATE. Both RPCs create the document first and pass tests 28, 47 and 48 unchanged. |
| Every moved link is recorded once | readers of `public.events`; canon 27 | WRITE | Emitter `md5(prosrc)` `57bdf4c9574caf29f59c651b32dc7888`, SECURITY DEFINER, ACL `{postgres=X/postgres}`; trigger `document_links_emit_move` AFTER UPDATE; the existing code `document_linked`, catalog 71/626 unchanged. |
| The readers of links | the `documents` and `document_versions` policies; `app.is_document_responsible`; `app.financial_documents` | VERIFY | No body changes; tests 28 and 82 pass unchanged; the probes after the repair find no document opened by a refused link. |
| Test 165 | `supabase/tests` | WRITE | SHA-256 `0d20b1d701ed1e351b6613cbdecc371cb2a26a7f786e6ab1def8a92aa3b7612e`, md5 `a27697b8d7f1ad5f5812e7605f6f78e7`, 12594 bytes, LF, ASCII, `plan(16)`: 16/16. |
| Other tests and the suite | the full pgTAP suite; the HTTP suites; smoke | VERIFY | In CRM on these bytes: Pass A `Files=165, Tests=3117`, PASS; HTTP 35/0, 85/0, 122/0; Pass B 165/3117, PASS; smoke `ALL CHECKS PASSED` (78 tables, 71/626 catalog). 165 files whose literal `plan(N)` values sum to 3117. Test 10 and `scripts/verify_database.sql` do not move. |
| Structural surface on Founder Secondary | `scripts/parity_surface.sql`; `founder-ledger-evidence.json`; `scripts/check_database_parity_evidence.ps1` | WRITE | Before (259): functions `e11c0124eec937fa08c1f7fe567b1249`/339, triggers `b5c21e213844e603ed5e1a6f9b0be455`/326, `_combined` `0e398aeac8e622fabeda83ac1900bf9d`/3156, equal to the recorded Founder evidence and to CRM Primary's before SPEC-306. After (260, local): functions `73b0bbffade0a788aff53c10266a97dc`/341 (+2), triggers `8f39469bf723f0ea53cccb3c96fb65fd`/328 (+2), `_combined` `4a7b00b15007fbdb9072203d1f46ad19`/3160; policies, constraints, grants, columns, views, indexes, status transitions and RLS unchanged, as on CRM Primary after SPEC-306. Step 9 writes Founder values only from fresh post-deploy readings. |
| Client API | `MASTER_API_CONTRACT.md` (Check L3) | VERIFY | No RPC is added, removed or changed; the two functions are trigger functions executable by no client role. In CRM the canonical generator, run on the final bytes, reproduced the committed contract exactly (no line differs); this repository's contract is the same blob (`ee763c1958b6363d36cc812506f69871531e4368`), and the generator here must reproduce it. It is in Write Scope only because Check L3 regenerates it; Step 9 regenerates it and it must not change. |
| Measured state that moves | manifest `Live state` and suite figure; `founder-ledger-evidence.json`; `ai-map.json` and `repository-index.md` | WRITE | 259 → 260 migrations, latest `20261112150000`, ledger fingerprint `5f6e412ee282edaf1e16346c3d5b5805`; 164 → 165 files and 3101 → 3117 assertions; coverage 50 → 51 of 78. Tables 78 and client RPCs 80 do not move. `Next capability` and `Current Module` stay unchanged (selector form). |
| The pinned manifest lines `Current Module`, `Next capability` and `Batch 6 surface coverage` | native Boot; `scripts/batch6_select_target.ps1` and `MASTER_SURFACE_DISPOSITION.md`, which own their values (GOVERNANCE.md §6 rule 10) | UNAFFECTED | Step 10 names `Current Module` and `Next capability` only to leave them unchanged; each line keeps its ratified text and pin. |
| DOC-9 and DOC-10 fixed; the surface recorded; canon 27 | `MASTER_GAP_REGISTER.md`; `MASTER_SURFACE_DISPOSITION.md`; `27_event_catalog.md`; Checks 21, 22, 24, 25, 29 | WRITE | No `DOC-9` or `DOC-10` row exists at `d5224e3`; the DOC rows, the disposition row and the canon paragraph are CRM's with this contract's id, the identity measurement and Founder Secondary in place of Primary. Test 165's `-- ATTACK-CLASSES:` line declares ten classes with STATE, CONCURRENCY and REPLAY `=N/A` and carries negative assertions, so Check 24 admits `ADVERSARIAL`. Each DOC row has Owner `—` and is settled. Coverage 51: 27 `AUDITED`, 21 `AUDITED-OPEN`, 3 `PARTIAL`, 0 `EXEMPT`, 27 `NOT-RECORDED`; all 51 `ADVERSARIAL`. |
| Repository consistency | `scripts/check_repository_consistency.ps1` | VERIFY | With Steps 1–5 applied and the contract present, consistency reports exactly the six measured-state items (259 vs 260 migrations, latest, ledger fingerprint, 164 vs 165 files, 3101 vs 3117 assertions, the Founder-evidence record) and Checks 21–29 pass. Step 9 makes them true; the one implementation commit is made only after it. |
| The four CI-only guard self-tests | `scripts/test_*_guard.ps1`; `orvion-acceptance` | VERIFY | Unchanged scripts, run by `orvion-acceptance` on the exact candidate SHA before `main` may move to it; their controls require the measured state of Step 9, so they are not run locally (CRM timed them once in slice 47: 618 s locally, 84 s in hosted CI). |

Unresolved Material Consumers: None

### Execution-Boundary Satisfiability

Applicability: APPLICABLE

Irreversible Action Step: Step 8 (Founder Secondary deployment)

| Invariant | Required At | Red Opens After Step | Restored By Step | Mandatory Gate Before Step |
| --- | --- | --- | --- | --- |
| The applied files equal CRM SPEC-306's verified bytes and the identity holds | BEFORE_IRREVERSIBLE_ACTION | NONE | NONE | Step 6 |
| Founder Secondary lacks the target migration and its ledger and structure equal the recorded evidence | BEFORE_IRREVERSIBLE_ACTION | NONE | NONE | Step 8 |
| Manifest, recorded Founder evidence and Founder ledger agree | AFTER_IRREVERSIBLE_ACTION | Step 1 | Step 9 | Step 10 |
| Manifest suite and coverage figures equal the files and the disposition record | BEFORE_COMPLETION | Step 2 | Step 9 | Step 10 |
| The map matches its generators | BEFORE_COMPLETION | NONE | NONE | Step 10 |

### Permanent-Control Admission

Applicability: APPLICABLE

Existing Mechanism Reusable: NO

Existing Mechanism: the links policy checks the target's visibility only; `guard_write_capability` charges `UPLOAD_DOCUMENT`, not the document; the `documents` policy reads links but cannot be read back by the links policy (SPEC-144's one-directional chain); `app.derive_created_by` fixes `created_by` at creation only; `app.upload_document` records its own link only. Nothing ties a link to its writer's read of the document, or records a move.

Added Property: For every session, a document link is created or re-pointed only by a writer who can already read its document, and every link moved to another document or target is recorded once with its actor and both values.

Causal Negative: Measured in CRM on these bytes and adopted by identity: on the stack with both triggers removed, test 165 fails assertions 1, 4–7, 12 and 13; on the `789e056` schema (equal to `d5224e3`'s) it stops at assertion 1. The probes there return: the Giza employee links Suez's passport scan or invoice onto their own booking, or re-points their own link at the scan, and reads the document, its version and its storage path; a moved ticket link leaves the events unchanged.

Positive Test Design: One tenant with Giza and Suez branches, a Giza and a Suez `employee` and an owner, Suez documents including a passport scan and an invoice, Giza bookings; another tenant with an owner. Positive controls: `app.upload_document` links the document it creates; the Giza employee links a document they read onto another of their bookings, attributed to them; the tenant-wide owner at `aal2` links Suez's scan; a session-less write lands without a check.

Negative Test Design:
- **Auth:** the owner's write passes only at `aal2` (`guard_write_capability`, unchanged).
- **Tenant:** another tenant's owner is refused 42501.
- **Door:** the table door is charged on INSERT and UPDATE; DELETE has no grant; both RPCs keep linking their own documents.
- **Input:** a re-point to an unreadable document is refused like a new link.
- **Privilege:** the Giza employee, holding `UPLOAD_DOCUMENT` without tenant-wide read, is refused both Suez documents and the re-point, and afterwards still reads neither.
- **Business:** a link is a read grant, so it requires the read it would grant.
- **Observability:** a moved link is recorded once as `document_linked` with the link id and both values; a no-op update and a session-less write record nothing.

Non-Empty Population Obligation: The fixture holds two tenants, two branches, four users, three bookings, three documents and three links before the first assertion. Each refusal is asserted by SQLSTATE 42501 and, for the link guard, its exact message; each record by its exact field list.

Mutation Obligation: Adopted by identity from CRM SPEC-306, whose prototype ran it on these bytes: each mutant is installed inside test 165's own rolled-back transaction, proven installed by a diag line (the guard's `md5(pg_get_functiondef)`, its definer flag and the table's trigger count), run, and rolled back; the restored shape (guard `dcb651faf92a8aacf8a67bf3e5b5649d`, invoker, emitter `910d0cfbbde2108e0555b88b6facff2d`, 5 triggers) is read after the last. A mutant not proven installed is a harness error, never a kill.

| Mutant | Change | Killed on CRM's prototype by |
| --- | --- | --- |
| M1 | the guard trigger dropped | 165 assertions 1, 4–7, 12 and 13 |
| M2 | the guard runs as SECURITY DEFINER (reads every document) | 165 assertions 2, 4–7, 12 and 13 |
| M3 | the emitter trigger dropped | 165 assertions 1, 12 and 13 |
| M4 | the emitter records an update that moves nothing | 165 assertion 13 |

Post-Implementation Proof Obligation: All of the following on the final bytes, through canonical `-Finish` from the main checkout with the project-local CLI: the clean reset, pgTAP Pass A, the declared HTTP suites, pgTAP Pass B and smoke; the generated artifacts, repository consistency and the recorded Founder evidence with its parity. Before Step 8: the identity proof and the fresh Founder Secondary baseline of Step 6; the focused tests, probes, mutants and causal negative are CRM SPEC-306's on the same bytes.

## Implementation Steps

1. Check whether `supabase/migrations/20261112150000_a_document_is_linked_only_by_someone_who_can_read_it.sql` contains `Batch 6 slice 50 (DOC-9, DOC-10)`; if so record Already Applied when its Git blob is f61e88618e7092a2eb13d78fb42f08820b2c80f0, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (the migration, byte-identical to CRM SPEC-306: the link guard and the move emitter), and change nothing else:

   ```text
   -- Batch 6 slice 50 (DOC-9, DOC-10) -- a document is linked only by someone who can read it, and a
   -- moved link is recorded.
   --
   -- =================================================================================================
   -- THE MEASURED DEFECTS (2026-11-12 at 789e056 on the local stack, probe fixtures rolled back)
   --
   -- DOC-9  A link decides who reads a document: the `documents` policy admits a non-confidential
   --        document through any `document_links` row the caller can see, and a link is visible when
   --        its target record is. The link's own policy checks only the TARGET, so an `employee` of one
   --        branch who holds `UPLOAD_DOCUMENT` inserted a link from another branch's passport scan onto
   --        their own booking, or re-pointed their own link at it, and then read the document, its
   --        version and its storage path -- the boundary DOC-1 (SPEC-144) closed. The same insert of
   --        another branch's invoice made the employee "responsible" for it through
   --        `app.is_document_responsible` and read it past SPEC-154-B. The only precondition is the
   --        document's id. `app.upload_document`, the one door that links, links only the document it
   --        has just created.
   -- DOC-10 Re-pointing a link by UPDATE moved a document off the record it belonged to (a ticket off
   --        its booking) and recorded nothing: `derive_created_by` keeps the creator, and no event is
   --        written. A new link is attributed by its own row (`created_by` is derived and immutable).
   --
   -- =================================================================================================
   -- THE REPAIR, IN THE SPEC-301 SHAPE: authority is a precondition and runs BEFORE; the record is a
   -- fact and runs AFTER.
   --
   -- 1. `app.guard_document_link_readable`, BEFORE INSERT OR UPDATE, session writes only: the caller
   --    must already read the link's document. SECURITY INVOKER on purpose: the check IS the caller's
   --    own read of `documents` under its policy (creator, tenant-wide read, the financial and
   --    confidential clauses, an existing visible link). It runs BEFORE the row exists, so a link
   --    cannot vouch for itself. A policy clause cannot do this: `documents` reads `document_links`,
   --    and the one-directional chain (SPEC-144) forbids the reverse. No session (migrations, seeds,
   --    provisioning, service_role, the tests' fixtures): no check, as in every sibling guard.
   -- 2. `app.emit_document_link_move`, AFTER UPDATE, session writes only: `document_linked` (the code
   --    `app.upload_document` already records for its link) on the document, with the link id and the
   --    previous and current document and target. An UPDATE that moves neither records nothing.
   --
   -- DELETE is not included: `authenticated` holds no DELETE on this table.
   -- NOT CHANGED: every grant and policy, the other three triggers, both RPCs, the documents policy.
   -- =================================================================================================

   create or replace function app.guard_document_link_readable()
   returns trigger
   language plpgsql
   set search_path = ''
   as $fn$
   begin
       if (select auth.uid()) is null then
           return new;
       end if;
       if not exists (select 1 from public.documents d where d.id = new.document_id) then
           raise exception 'a document can be linked only by someone who can already read it'
               using errcode = 'insufficient_privilege';
       end if;
       return new;
   end;
   $fn$;

   revoke execute on function app.guard_document_link_readable() from public;

   create trigger document_links_guard_document_readable
       before insert or update on public.document_links
       for each row execute function app.guard_document_link_readable();

   create or replace function app.emit_document_link_move()
   returns trigger
   language plpgsql
   security definer
   set search_path = ''
   as $fn$
   declare
       v_prev jsonb := jsonb_strip_nulls(to_jsonb(old) - array['id', 'tenant_id', 'created_by', 'created_at']);
       v_next jsonb := jsonb_strip_nulls(to_jsonb(new) - array['id', 'tenant_id', 'created_by', 'created_at']);
   begin
       if (select auth.uid()) is null or v_prev = v_next then
           return null;
       end if;

       perform app.record_event(
           new.tenant_id, 'document_linked', 'document', new.document_id, null,
           null, null, null,
           jsonb_build_object('link_id', new.id, 'previous', v_prev, 'current', v_next),
           'info');
       return null;
   end;
   $fn$;

   revoke execute on function app.emit_document_link_move() from public;

   create trigger document_links_emit_move
       after update on public.document_links
       for each row execute function app.emit_document_link_move();
   ```

   The resulting file's Git blob is f61e88618e7092a2eb13d78fb42f08820b2c80f0.

2. Check whether `supabase/tests/165_a_document_is_linked_only_by_someone_who_can_read_it_test.sql` contains `plan(16)`; if so record Already Applied when its Git blob is 3628685dd2c90e7aa0e8f2979fd36ccc9327177d, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 165, 16 assertions, byte-identical to CRM SPEC-306), and change nothing else:

   ```text
   -- pgTAP: Batch 6 slice 50 (DOC-9, DOC-10) --
   -- a document is linked only by someone who can already read it, and a moved link is recorded
   -- (`20261112150000`).
   -- ATTACK-CLASSES: AUTH TENANT DOOR STATE=N/A INPUT CONCURRENCY=N/A REPLAY=N/A PRIVILEGE BUSINESS OBSERVABILITY
   --   STATE=N/A -- a link has no lifecycle; its only change is a move, which is checked and recorded here.
   --   CONCURRENCY=N/A -- the check reads committed visibility of one document; no counter or claim.
   --   REPLAY=N/A -- no token, nonce or idempotency key on this surface.
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(16);

   insert into auth.users (id, email) values
     ('16500000-0000-0000-0000-0000000000a1','giza@c165.test'),
     ('16500000-0000-0000-0000-0000000000a2','suez@c165.test'),
     ('16500000-0000-0000-0000-0000000000a3','owner@c165.test'),
     ('16500000-0000-0000-0000-0000000000a9','other@c165.test');
   insert into public.tenants (id, name, slug, status) values
     ('16500000-0000-0000-0000-000000000001','Link Travel','link-travel-165','active'),
     ('16500000-0000-0000-0000-000000000002','Other Travel','other-travel-165','active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select t.id, sp.id, 'active' from public.subscription_plans sp cross join (values ('16500000-0000-0000-0000-000000000001'::uuid), ('16500000-0000-0000-0000-000000000002'::uuid)) t(id) where sp.plan_code = 'enterprise';
   insert into public.branches (id, tenant_id, name, slug) values
     ('16500000-0000-0000-0000-00000000000a','16500000-0000-0000-0000-000000000001','Giza','giza-165'),
     ('16500000-0000-0000-0000-00000000000b','16500000-0000-0000-0000-000000000001','Suez','suez-165');
   insert into public.departments (id, tenant_id, branch_id, department_type_code, name) values
     ('16500000-0000-0000-0000-0000000000c1','16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-00000000000a','sales','Giza Sales'),
     ('16500000-0000-0000-0000-0000000000c2','16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-00000000000b','sales','Suez Sales');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
     ('16500000-0000-0000-0000-000000000011','16500000-0000-0000-0000-000000000001','Giza','giza@c165.test',true,'16500000-0000-0000-0000-0000000000a1'),
     ('16500000-0000-0000-0000-000000000012','16500000-0000-0000-0000-000000000001','Suez','suez@c165.test',true,'16500000-0000-0000-0000-0000000000a2'),
     ('16500000-0000-0000-0000-000000000013','16500000-0000-0000-0000-000000000001','Owner','owner@c165.test',true,'16500000-0000-0000-0000-0000000000a3'),
     ('16500000-0000-0000-0000-000000000019','16500000-0000-0000-0000-000000000002','Other','other@c165.test',true,'16500000-0000-0000-0000-0000000000a9');
   insert into public.user_branch_assignments (tenant_id, user_id, branch_id, department_id, is_primary) values
     ('16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-000000000011','16500000-0000-0000-0000-00000000000a','16500000-0000-0000-0000-0000000000c1',true),
     ('16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-000000000012','16500000-0000-0000-0000-00000000000b','16500000-0000-0000-0000-0000000000c2',true);
   insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type)
   select v.tid, v.uid, r.id, 'tenant'
   from (values ('16500000-0000-0000-0000-000000000001'::uuid,'16500000-0000-0000-0000-000000000011'::uuid,'employee'),
                ('16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-000000000012','employee'),
                ('16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-000000000013','owner'),
                ('16500000-0000-0000-0000-000000000002','16500000-0000-0000-0000-000000000019','owner')) v(tid, uid, role_code)
   join public.roles r on r.code = v.role_code;
   insert into public.customers (id, tenant_id, customer_type_code, full_name) values
     ('16500000-0000-0000-0000-0000000000d1','16500000-0000-0000-0000-000000000001','person','Link Customer');
   insert into public.bookings (id, tenant_id, branch_id, department_id, customer_id, owner_user_id,
                                owner_branch_id, owner_department_id, booking_status_code, title, booking_reference) values
     ('16500000-0000-0000-0000-0000000000f1','16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-00000000000a','16500000-0000-0000-0000-0000000000c1','16500000-0000-0000-0000-0000000000d1','16500000-0000-0000-0000-000000000011','16500000-0000-0000-0000-00000000000a','16500000-0000-0000-0000-0000000000c1','draft','Giza booking','BK-165-1'),
     ('16500000-0000-0000-0000-0000000000f2','16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-00000000000a','16500000-0000-0000-0000-0000000000c1','16500000-0000-0000-0000-0000000000d1','16500000-0000-0000-0000-000000000011','16500000-0000-0000-0000-00000000000a','16500000-0000-0000-0000-0000000000c1','draft','Giza booking 2','BK-165-2'),
     ('16500000-0000-0000-0000-0000000000f3','16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-00000000000b','16500000-0000-0000-0000-0000000000c2','16500000-0000-0000-0000-0000000000d1','16500000-0000-0000-0000-000000000012','16500000-0000-0000-0000-00000000000b','16500000-0000-0000-0000-0000000000c2','draft','Suez booking','BK-165-3');
   -- Dg: Giza's ticket on Giza's booking. Ds and Di: Suez's passport scan and invoice on Suez's booking.
   insert into public.documents (id, tenant_id, document_type_code, title, lifecycle_status_code, is_confidential, created_by) values
     ('16500000-0000-0000-0000-0000000000e1','16500000-0000-0000-0000-000000000001','ticket','Dg','active',false,'16500000-0000-0000-0000-000000000011'),
     ('16500000-0000-0000-0000-0000000000e2','16500000-0000-0000-0000-000000000001','passport','Ds','active',false,'16500000-0000-0000-0000-000000000012'),
     ('16500000-0000-0000-0000-0000000000e3','16500000-0000-0000-0000-000000000001','invoice','Di','active',false,'16500000-0000-0000-0000-000000000012');
   insert into public.document_links (id, tenant_id, document_id, booking_id) values
     ('16500000-0000-0000-0000-0000000000b1','16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-0000000000e1','16500000-0000-0000-0000-0000000000f1'),
     ('16500000-0000-0000-0000-0000000000b2','16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-0000000000e2','16500000-0000-0000-0000-0000000000f3'),
     ('16500000-0000-0000-0000-0000000000b3','16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-0000000000e3','16500000-0000-0000-0000-0000000000f3');

   select is(
     (select count(*)::int from pg_trigger
      where tgrelid = 'public.document_links'::regclass and not tgisinternal
        and tgname in ('document_links_guard_document_readable', 'document_links_emit_move')),
     2, 'both triggers are installed on document_links');

   select is(
     (select prosecdef from pg_proc where oid = 'app.guard_document_link_readable'::regproc),
     false, 'the guard is SECURITY INVOKER: the check is the caller''s own read of the document');

   set local role authenticated;
   select set_config('request.jwt.claims', '{"sub":"16500000-0000-0000-0000-0000000000a1","aal":"aal1"}', true);

   select is((select count(*)::int from public.documents where title in ('Ds','Di')), 0,
     'the Giza employee reads neither Suez document -- the anchor for what follows');

   -- DOC-9: a link may not carry a document its writer cannot read.
   select throws_ok(
     $$insert into public.document_links (tenant_id, document_id, booking_id) values
       ('16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-0000000000e2','16500000-0000-0000-0000-0000000000f1')$$,
     '42501', 'a document can be linked only by someone who can already read it',
     'DOC-9: the Giza employee cannot link the Suez passport scan onto their own booking');

   select throws_ok(
     $$insert into public.document_links (tenant_id, document_id, booking_id) values
       ('16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-0000000000e3','16500000-0000-0000-0000-0000000000f1')$$,
     '42501', 'a document can be linked only by someone who can already read it',
     'DOC-9: ...nor the Suez invoice, which would make them "responsible" for it (SPEC-154-B)');

   select throws_ok(
     $$update public.document_links set document_id = '16500000-0000-0000-0000-0000000000e2'
       where id = '16500000-0000-0000-0000-0000000000b1'$$,
     '42501', 'a document can be linked only by someone who can already read it',
     'DOC-9: ...nor re-point their own link at the Suez passport scan');

   select is((select count(*)::int from public.documents where title in ('Ds','Di')), 0,
     'and still reads neither Suez document');

   -- The legitimate door and the legitimate direct link still work.
   select lives_ok(
     $$select app.upload_document('other','Giza upload','g.pdf','pdf','booking','16500000-0000-0000-0000-0000000000f1')$$,
     'app.upload_document still links the document it has just created');

   select lives_ok(
     $$insert into public.document_links (tenant_id, document_id, booking_id) values
       ('16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-0000000000e1','16500000-0000-0000-0000-0000000000f2')$$,
     'a document the writer reads may be linked onto another record the writer reads');

   select is(
     (select count(*)::int from public.document_links l join public.users u on u.id = l.created_by
      where l.document_id = '16500000-0000-0000-0000-0000000000e1' and l.booking_id = '16500000-0000-0000-0000-0000000000f2'
        and u.full_name = 'Giza'),
     1, 'a new link is attributed by its own row: created_by is the writer');

   -- DOC-10: a moved link is recorded, with the previous and the current target.
   select lives_ok(
     $$update public.document_links set booking_id = '16500000-0000-0000-0000-0000000000f2'
       where id = '16500000-0000-0000-0000-0000000000b1'$$,
     'the Giza employee may move their own ticket link between two Giza bookings');

   reset role;

   select is(
     (select count(*)::int from public.events e join public.users u on u.id = e.actor_user_id
      where e.tenant_id = '16500000-0000-0000-0000-000000000001' and e.event_type_code = 'document_linked'
        and e.entity_id = '16500000-0000-0000-0000-0000000000e1' and u.full_name = 'Giza'
        and e.payload -> 'previous' ->> 'booking_id' = '16500000-0000-0000-0000-0000000000f1'
        and e.payload -> 'current' ->> 'booking_id' = '16500000-0000-0000-0000-0000000000f2'
        and e.payload ->> 'link_id' = '16500000-0000-0000-0000-0000000000b1'),
     1, 'DOC-10: the move is recorded once, as document_linked by the mover, with both targets');

   set local role authenticated;
   select set_config('request.jwt.claims', '{"sub":"16500000-0000-0000-0000-0000000000a1","aal":"aal1"}', true);
   update public.document_links set booking_id = '16500000-0000-0000-0000-0000000000f2'
    where id = '16500000-0000-0000-0000-0000000000b1';
   reset role;

   select is(
     (select count(*)::int from public.events
      where tenant_id = '16500000-0000-0000-0000-000000000001' and event_type_code = 'document_linked'
        and payload ? 'previous'),
     1, 'an update that moves nothing records nothing');

   -- TENANT: another tenant's owner sees none of this tenant's documents, so links none of them.
   set local role authenticated;
   select set_config('request.jwt.claims', '{"sub":"16500000-0000-0000-0000-0000000000a9","aal":"aal2"}', true);
   select throws_ok(
     $$insert into public.document_links (tenant_id, document_id, booking_id) values
       ('16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-0000000000e2','16500000-0000-0000-0000-0000000000f3')$$,
     '42501', null,
     'TENANT: another tenant''s owner cannot link this tenant''s document');

   -- The owner reads every document of the tenant (tenant-wide read), so may link any of them.
   select set_config('request.jwt.claims', '{"sub":"16500000-0000-0000-0000-0000000000a3","aal":"aal2"}', true);
   select lives_ok(
     $$insert into public.document_links (tenant_id, document_id, booking_id) values
       ('16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-0000000000e2','16500000-0000-0000-0000-0000000000f1')$$,
     'the owner, who reads every document of the tenant, may link the Suez passport scan anywhere');
   reset role;

   -- The platform path (no session) is not checked, as in every sibling guard.
   select lives_ok(
     $$insert into public.document_links (tenant_id, document_id, booking_id) values
       ('16500000-0000-0000-0000-000000000001','16500000-0000-0000-0000-0000000000e3','16500000-0000-0000-0000-0000000000f2')$$,
     'a session-less platform write is not checked');

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is 3628685dd2c90e7aa0e8f2979fd36ccc9327177d.

3. Check whether `_ORVION_CANONICAL/27_event_catalog.md` contains `and when a link is moved by UPDATE to another document or target`; if so record Already Applied when its Git blob is 5e1ff1d37136f58d97e80a029dee3babce07437a, and otherwise stop and report. Otherwise make exactly this one edit (the document_linked entry, CRM SPEC-306's text with this contract's id), each matched once, and change nothing else:

   a) immediately after the lines
   ```text
   ## document_linked

   Severity: info

   ```
   insert
   ```text
   Created when `app.upload_document` links the document it has just created, and when a link is moved by UPDATE to another document or target, with the link id and the previous and current document and target; an update that moves neither records nothing (DOC-10, SPEC-309). A new link is attributed by its own `created_by`.

   ```

   The resulting file's Git blob is 5e1ff1d37136f58d97e80a029dee3babce07437a.

4. Check whether `reports/master/MASTER_GAP_REGISTER.md` contains `| DOC-9 |`; if so record Already Applied when its Git blob is 5a5ac4775899d33b81af8559914f16a64c024875, and otherwise stop and report. Otherwise make exactly these 2 edits (the Slice 50 freshness entry and the DOC-9 and DOC-10 rows), each matched once, and change nothing else:

   a) replace the line
   ```text
   Last updated: 2026-11-11 (**Slice 49 — `document_retention_policies` selected live at Exposure 6, coverage 36; runner-up `document_links` at 6/54.** **RET-3** (Medium) and **RET-4** (Medium) are new and fixed. The table is its own only writer and its RLS charged `MANAGE_TENANT_SETTINGS` without step-up, so an `owner` at `aal1` set a 1-day period and a `ceo` at `aal1` shortened a ten-year one to 1 day, and after each the storage scan made a superseded version a `delete_object` claim, while the legal hold that overrides retention refuses the same session; no change was recorded and the ceo's change still named the owner. SPEC-308 (the twin of CRM SPEC-305) charges the step-up and records every change. STEPUP-1 loses its `document_retention_policies` member. No other row changed.)
   ```
   with
   ```text
   Last updated: 2026-11-12 (**Slice 50 — `document_links` selected live at Exposure 6, coverage 54; runner-up `exchange_rates` at 6/66.** **DOC-9** (Medium) and **DOC-10** (Low) are new and fixed. A link decides who reads a non-confidential document, and the link's policy checked only its target, so a branch `employee` linked another branch's passport scan or invoice onto their own booking, or re-pointed their own link at it, and read the document and its storage path; a link moved by UPDATE was recorded nowhere. SPEC-309 (the twin of CRM SPEC-306) refuses a link whose document its writer cannot already read and records every move. No other row changed.)

   Previously: 2026-11-11 (**Slice 49 — `document_retention_policies` selected live at Exposure 6, coverage 36; runner-up `document_links` at 6/54.** **RET-3** (Medium) and **RET-4** (Medium) are new and fixed. The table is its own only writer and its RLS charged `MANAGE_TENANT_SETTINGS` without step-up, so an `owner` at `aal1` set a 1-day period and a `ceo` at `aal1` shortened a ten-year one to 1 day, and after each the storage scan made a superseded version a `delete_object` claim, while the legal hold that overrides retention refuses the same session; no change was recorded and the ceo's change still named the owner. SPEC-308 (the twin of CRM SPEC-305) charges the step-up and records every change. STEPUP-1 loses its `document_retention_policies` member. No other row changed.)
   ```

   b) immediately after the line
   ```text
   | RET-4 | **No change to a document retention policy was recorded, and an UPDATE kept the creator's name, so a file deletion could not be traced to whoever set its period** | audit completeness · observability | Medium | R | 6 | M | ✅ | **✅ FIXED 2026-11-11 (SPEC-308, `20261111150000`), DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-308; the fresh Founder ledger, functions and structure equal local.** **MEASURED** in CRM at `53146b3` (CRM SPEC-305), and identical at `4246545` here (the same migrations and tests blob for blob, and the same pre-change structure): no trigger or function recorded a policy's creation, shortening, re-type or deactivation (tenant events unchanged across all of them), and `app.derive_created_by` keeps `created_by` on UPDATE, so after the ceo's shortening the row still named the owner. The legal hold, the other retention lever, records every transition as critical (canon 27). **Repaired:** `app.guard_document_retention_policy_write` (BEFORE INSERT OR UPDATE, SECURITY DEFINER, session writes only) charges `app.authorize('MANAGE_TENANT_SETTINGS')`, the legal hold's own charge, on every column; `app.emit_document_retention_policy_change` (AFTER INSERT OR UPDATE) records the new code `document_retention_policy_changed` (critical) with the actor and the previous and current type, period, active flag and reason. `164_a_retention_period_changes_only_with_step_up_and_a_record_test.sql` pins both. A no-change update and a session-less write record nothing. | — | SPEC-308-a-retention-period-changes-only-with-step-up-and-a-record | 11-11 | 11-11 |
   ```
   insert
   ```text
   | DOC-9 | **A link decides who reads a document, and its writer needed to read only the link's target, so a branch employee linked another branch's passport scan or invoice onto their own booking and read it** | security · privacy scope · authorization | Medium | R | 6 | M | 🛡 | **FIXED 2026-11-12 locally (SPEC-309, `20261112150000`); Founder Secondary deployment pending.** **MEASURED** in CRM at `789e056` (CRM SPEC-306), and identical at `d5224e3` here (the same migrations and tests blob for blob, and the same pre-change structure): the `documents` policy admits a non-confidential document through any `document_links` row the caller can see, and a link is visible when its target record is; the link's own `scope_isolation` policy checks only the target. An `employee` of Giza (`UPLOAD_DOCUMENT`, no tenant-wide read) inserted a link from Suez's passport scan onto their own booking, or re-pointed their own ticket link at it, and then read the document, its version and its storage path, the boundary DOC-1 (SPEC-144) closed; the same insert of Suez's invoice made them responsible for it through `app.is_document_responsible` and read it past SPEC-154-B. A confidential document stayed hidden. The only precondition is the document's id. `app.upload_document`, the one door that links, links only the document it has just created. **Repaired:** `app.guard_document_link_readable` (BEFORE INSERT OR UPDATE, SECURITY INVOKER, session writes only) refuses a link whose document the writer cannot already read under the `documents` policy; `app.emit_document_link_move` (AFTER UPDATE, SECURITY DEFINER) records a moved link as `document_linked` with the link id and the previous and current document and target. `165_a_document_is_linked_only_by_someone_who_can_read_it_test.sql` pins both. | — | SPEC-309-a-document-is-linked-only-by-someone-who-can-read-it | 11-12 | 11-12 |
   | DOC-10 | **A link moved by UPDATE took a document off the record it belonged to and was recorded nowhere** | audit completeness · observability | Low | R | 6 | M | 🛡 | **FIXED 2026-11-12 locally (SPEC-309, `20261112150000`); Founder Secondary deployment pending.** **MEASURED** in CRM at `789e056` (CRM SPEC-306), and identical at `d5224e3` here (the same migrations and tests blob for blob, and the same pre-change structure): an `employee` moved the ticket link of their booking to another of their bookings; the tenant's events did not move and `app.derive_created_by` keeps the creator, so nothing showed who took the ticket off the booking. A new link is attributed by its own row (`created_by` derived and immutable); `app.upload_document` records `document_linked` for its link. **Repaired:** `app.guard_document_link_readable` (BEFORE INSERT OR UPDATE, SECURITY INVOKER, session writes only) refuses a link whose document the writer cannot already read under the `documents` policy; `app.emit_document_link_move` (AFTER UPDATE, SECURITY DEFINER) records a moved link as `document_linked` with the link id and the previous and current document and target. `165_a_document_is_linked_only_by_someone_who_can_read_it_test.sql` pins both. An update that moves nothing and a session-less write record nothing. | — | SPEC-309-a-document-is-linked-only-by-someone-who-can-read-it | 11-12 | 11-12 |
   ```

   The resulting file's Git blob is 5a5ac4775899d33b81af8559914f16a64c024875.

5. Check whether `reports/master/MASTER_SURFACE_DISPOSITION.md` contains `**51 of 78 recorded · 27 `; if so record Already Applied when its Git blob is f7ca78f912d6fb54835e4009bf73527e6ba859e7, and otherwise stop and report. Otherwise make exactly these 4 edits (the freshness entry, coverage 51 of 78 and the document_links row), each matched once, and change nothing else:

   a) replace the line
   ```text
   Last updated: 2026-11-11 (**slice 49 — `document_retention_policies` selected by Exposure 6, coverage 36; runner-up `document_links` at 6/54.** Coverage **49 → 50 of 78**. RET-3: an `owner` or `ceo` at `aal1` set or shortened a retention period at the table, and a superseded version became a `delete_object` claim, while the legal hold refuses the same session. RET-4: no policy change was recorded. SPEC-308 (the twin of CRM SPEC-305) closes both here, so the row is `AUDITED`.)
   ```
   with
   ```text
   Last updated: 2026-11-12 (**slice 50 — `document_links` selected by Exposure 6, coverage 54; runner-up `exchange_rates` at 6/66.** Coverage **50 → 51 of 78**. DOC-9: a branch employee linked another branch's document onto their own booking and read it. DOC-10: a moved link was recorded nowhere. SPEC-309 (the twin of CRM SPEC-306) closes both here, so the row is `AUDITED`.)

   Previously: 2026-11-11 (**slice 49 — `document_retention_policies` selected by Exposure 6, coverage 36; runner-up `document_links` at 6/54.** Coverage **49 → 50 of 78**. RET-3: an `owner` or `ceo` at `aal1` set or shortened a retention period at the table, and a superseded version became a `delete_object` claim, while the legal hold refuses the same session. RET-4: no policy change was recorded. SPEC-308 (the twin of CRM SPEC-305) closes both here, so the row is `AUDITED`.)
   ```

   b) replace the line
   ```text
   **50 of 78 recorded · 26 `AUDITED` · 21 `AUDITED-OPEN` · 3 `PARTIAL` · 0 `EXEMPT` · 28 `NOT-RECORDED`.**
   ```
   with
   ```text
   **51 of 78 recorded · 27 `AUDITED` · 21 `AUDITED-OPEN` · 3 `PARTIAL` · 0 `EXEMPT` · 27 `NOT-RECORDED`.**
   ```

   c) replace the line
   ```text
   **All 50 recorded surfaces stand at `ADVERSARIAL`, and Check 24 (ADV-1) is what makes that word cost something**: a surface may not carry it unless a pgTAP file names it, declares which attack classes it aimed at (`-- ATTACK-CLASSES:`, closed vocabulary), and carries at least one negative assertion. A file of positive controls earns `TESTED` and no more.
   ```
   with
   ```text
   **All 51 recorded surfaces stand at `ADVERSARIAL`, and Check 24 (ADV-1) is what makes that word cost something**: a surface may not carry it unless a pgTAP file names it, declares which attack classes it aimed at (`-- ATTACK-CLASSES:`, closed vocabulary), and carries at least one negative assertion. A file of positive controls earns `TESTED` and no more.
   ```

   d) replace the line
   ```text
   | `document_links` | NOT-RECORDED | — | — | — | — |
   ```
   with
   ```text
   | `document_links` | **AUDITED** | ADVERSARIAL | `SPEC-309-a-document-is-linked-only-by-someone-who-can-read-it` | DOC-9, DOC-10 | `165_a_document_is_linked_only_by_someone_who_can_read_it_test.sql` (16 assertions, ten attack classes declared, STATE, CONCURRENCY and REPLAY N/A) proves that a branch employee can neither link another branch's passport scan or invoice onto their own booking nor re-point their own link at it, and still reads neither; that `app.upload_document` still links the document it creates, a document the writer reads may be linked onto another record the writer reads, and a new link names its writer; that a moved link is recorded once as `document_linked` with both targets and a no-change update records nothing; that another tenant's owner is refused, the tenant-wide owner may link any document of the tenant, and a session-less write is not checked. Tests 28, 35, 47, 48, 50, 57, 58, 80, 82, 88 and 89 pass unchanged. **Swept and classified as non-defects:** a confidential document stays hidden through a link (its own clause); another tenant's document (refused by the composite foreign key); re-tenanting a link and a link with no target (refused by RLS and the single-target CHECK); a trainee without `UPLOAD_DOCUMENT` and an `aal1` owner (refused by `guard_write_capability` and step-up); no DELETE grant; caller-supplied `created_at` on INSERT is read by nothing that decides (SPEC-216's schema-wide question). 0 hosted links and documents. |
   ```

   The resulting file's Git blob is f7ca78f912d6fb54835e4009bf73527e6ba859e7.

6. **Check** for a `Pre-deploy readiness gate` Execution Log entry. If absent, with Steps 1–5 applied and uncommitted in the main checkout, record, with actual values:
   - the SHA-256, md5 and byte counts of the migration and test 165, which must equal Consumer Closure, and their Git blobs, which must equal CRM SPEC-306's (`f61e88618e7092a2eb13d78fb42f08820b2c80f0`, `3628685dd2c90e7aa0e8f2979fd36ccc9327177d`); canon 27 must equal CRM's blob `609c2a90947eb29b7e56ca7aa5ceecfd2832ae98` with `SPEC-306` read as this contract's id;
   - the identity: `supabase/migrations` and `supabase/tests` at the baseline equal CRM's at `789e056` (trees `4cf167f371d5246f7a4a492d65dd40d082be87f9` and `b965dfb6be5a6bb3c0f234c513e501cd3f782db0`), and the paths changed equal those CRM SPEC-306 changed, so CRM SPEC-306's prototype results (both functions' shape, test 165 and tests 28, 82 and 48 alone, the probes, mutants M1–M4, the causal negative and the structural fingerprints before and after) hold here; they are cited, not re-run;
   - the API-contract generator on a local stack holding the migration, whose output must equal `MASTER_API_CONTRACT.md` (blob `ee763c1958b6363d36cc812506f69871531e4368`, CRM SPEC-306's); the map generator, the scope check and `git diff --check`.

   Treat as expected at this boundary only: an undeployed Founder Secondary and the six measured-state items of Consumer Closure.

   Read a fresh Founder Secondary baseline through the Founder connector, read-only: the project URL, the full ordered ledger and the absence of the target migration; the function and structural surfaces, which must equal CRM Primary's before SPEC-306 (`_combined` `0e398aeac8e622fabeda83ac1900bf9d`/3156); the triggers of `document_links` and the absence of both functions; the tenant, document and link counts. Record the predicted delta. If any reading differs, stop.
7. **Check** that an exact-SHA Gate-2 record for the migration is in the Execution Log: the owner's own, or one marked DELEGATED naming this contract, the migration's SHA-256, Founder Secondary `brplkqmbzffpxqgkkdzo` and the owner's instructions under which it is taken. If absent, write it only when Step 6 passed and those instructions cover a migration that drops no table or column and deletes or rewrites no business row; otherwise stop after Step 6 and present the Gate-2 package.
8. **Check** that Founder Secondary `brplkqmbzffpxqgkkdzo` lacks `20261112150000_a_document_is_linked_only_by_someone_who_can_read_it`. If it is absent and Step 7 is recorded:
   - Immediately re-read HEAD, the hashes, the project URL, the full ordered ledger, target absence, the business counts and the triggers of `document_links`.
   - On an exact match, prove the transmitted text's md5 server-side, then apply only the authorized migration through the Founder write connector `supabase-secondary-write`, after its `get_project_url` names `brplkqmbzffpxqgkkdzo`.
   - If the connector assigns a temporary version, rename only that one newly inserted ledger row. The rename requires exactly one new row, its stored statement md5 equal to the file's, and no existing target version.
   - Read fresh through the Founder connector: the ledger, the function surface and all ten structural surfaces, with the exact `read_query` recorded in `reports/evidence/founder-ledger-evidence.json`; the triggers of `document_links`; both functions' `md5(prosrc)`, security mode and ACL; the business counts.

   Never contact Primary `vrvtsxexkiiiivlkdxzp`.
9. **Check** that fresh Founder evidence contains the new migration exactly once. If so:
   - Update `reports/evidence/founder-ledger-evidence.json` (schema 3) from those readings only: `read_at`, `read_via`, the unchanged `read_query`, `repository_head` (the HEAD at the read), the full ledger, its count and fingerprint, both surface hashes and counts, and `surface_rows`. `scripts/check_primary_ledger.ps1` and `scripts/check_database_parity_evidence.ps1` must then pass.
   - In `_ORVION_CANONICAL/manifest.md`, set `Live state` from the same readings in its existing form (migration count, latest, ledger, and the two surface hashes and counts), with **80 client RPCs** unchanged.
   - Confirm that `supabase/tests` holds 165 files whose literal `plan(N)` values sum to 3117, then set `Suite **165 files / 3117 assertions**`. If either differs, stop.
   - In each of the two rows DOC-9 and DOC-10 of the register, replace the text `` | 🛡 | **FIXED 2026-11-12 locally (SPEC-309, `20261112150000`); Founder Secondary deployment pending.** `` with `` | ✅ | **✅ FIXED 2026-11-12 (SPEC-309, `20261112150000`), DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-309; the fresh Founder ledger, functions and structure equal local.** `` (each span's one leading and one trailing space are delimiters, not text). Change nothing else in the register.
   - Regenerate `MASTER_API_CONTRACT.md`, which must not change, and `ai-map.json` and `repository-index.md` (stored LF) with the canonical generators.
   - Set the Runtime Checkpoint to DONE, append the Execution Log, and commit the implementation once; the pre-commit Gate must admit it.

   If Founder Secondary is unproven, stop.
10. **Check** for a `Post-deploy local certification` Execution Log entry. If absent:
   - Run canonical `-Finish` through `scripts/run_timed.ps1`, watched by `scripts/watch_run.ps1`, and require `LOCAL_CERTIFY: READY`.
   - Independently Review the committed implementation against every Acceptance Criterion. After `Verdict: Confirmed Complete`, in the Complete commit: transition to Complete, tick the Acceptance Criteria and the Review Gate, clear `Active Change Request`, set `Last Completed` from Notes, leave `Next capability` and `Current Module` unchanged, and regenerate `ai-map.json` and `repository-index.md` LF.
   - Bind the exact candidate with `-Gate -BindCandidate`. Publication and promotion follow the native release path separately.

## Acceptance Criteria

- [ ] The migration is the frozen bytes; `check: blob supabase/migrations/20261112150000_a_document_is_linked_only_by_someone_who_can_read_it.sql f61e88618e7092a2eb13d78fb42f08820b2c80f0`
- [ ] Test 165 is the frozen bytes; `check: blob supabase/tests/165_a_document_is_linked_only_by_someone_who_can_read_it_test.sql 3628685dd2c90e7aa0e8f2979fd36ccc9327177d`
- [ ] Canon 27 says what `document_linked` now also records; `check: has _ORVION_CANONICAL/27_event_catalog.md "and when a link is moved by UPDATE to another document or target"`
- [ ] The disposition record carries `document_links` AUDITED / ADVERSARIAL and coverage 51 of 78; `check: blob reports/master/MASTER_SURFACE_DISPOSITION.md f7ca78f912d6fb54835e4009bf73527e6ba859e7`
- [ ] DOC-9 and DOC-10 are fixed and deployed in the register; `check: has reports/master/MASTER_GAP_REGISTER.md "DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-309"`
- [ ] The manifest suite figure equals the files; `check: has _ORVION_CANONICAL/manifest.md "Suite **165 files / 3117 assertions**"`
- [ ] Native evaluator remains exact; `check: same scripts/check_agent_continuity.ps1 @d5224e3eb4d0daeb6a43bfbe2a65c7e81d87890a`
- [ ] The document read scope migration remains exact; `check: same supabase/migrations/202607052300_document_read_scope.sql @d5224e3eb4d0daeb6a43bfbe2a65c7e81d87890a`
- [ ] The generated API contract remains exact; `check: same reports/master/MASTER_API_CONTRACT.md @d5224e3eb4d0daeb6a43bfbe2a65c7e81d87890a`
- [ ] Founder Secondary `brplkqmbzffpxqgkkdzo` received only the authorized migration and at most the one guarded ledger rename, with no business-data write, after a recorded Step 6 readiness gate and Step 7 Gate-2 record; Primary `vrvtsxexkiiiivlkdxzp` was never contacted.
- [ ] The identity with CRM SPEC-306 is proven (payload blobs, migrations and tests trees, Founder Secondary's pre-change structure), so its mutants M1–M4, each killed with installation proven and the restored shape read, and its causal negative hold here.

## Execution Log

### 2026-11-12 — Steps 1–5 applied

- **Lifecycle:** allocate `8fd80fe`, Approve `210bcfd` (APPROVAL_EVIDENCE PASS; 9 of 11 criteria Gate-checked), DELEGATED Gate 1 recorded in Verification Notes.
- **Steps 1–5** by the literal-step replay, each result at its pinned blob: migration `f61e88618e7092a2eb13d78fb42f08820b2c80f0` and test 165 `3628685dd2c90e7aa0e8f2979fd36ccc9327177d` (both equal to CRM SPEC-306's committed blobs), canon 27 `5e1ff1d37136f58d97e80a029dee3babce07437a` (CRM's `609c2a90947eb29b7e56ca7aa5ceecfd2832ae98` with this contract's id), register `5a5ac4775899d33b81af8559914f16a64c024875`, disposition `f7ca78f912d6fb54835e4009bf73527e6ba859e7`; 0 mismatches. Uncommitted until Step 9: the pre-commit guard refuses the measured-state items before the deploy.

### 2026-11-12 — Pre-deploy readiness gate (Step 6)

From the main checkout at HEAD `210bcfd`, Steps 1–5 applied and uncommitted, one logged script (18:08–18:09 Cairo); the identity proof in place of a local re-proof:
- **Bytes.** Migration SHA-256 `5bfb8e52155d367b5aab3e516e7b295d2ea30b3f0589df935396cbd0a37af9f3`, md5 `149882262bc6f900927121fcc13005b4`, 4684 bytes; test 165 SHA-256 `0d20b1d701ed1e351b6613cbdecc371cb2a26a7f786e6ab1def8a92aa3b7612e`, md5 `a27697b8d7f1ad5f5812e7605f6f78e7`, 12594 bytes; both LF (0 CR) and ASCII. Equal to Consumer Closure.
- **Identity.** The Git blobs of the migration and test 165 equal CRM SPEC-306's at its implementation commit `f96318fbea22213d84ef726e410a63e29b023c45`; canon 27 equals CRM's bytes (LF) with `(DOC-10, SPEC-306)` read as `(DOC-10, SPEC-309)`; `supabase/migrations` (tree `4cf167f371d5246f7a4a492d65dd40d082be87f9`) and `supabase/tests` (tree `b965dfb6be5a6bb3c0f234c513e501cd3f782db0`) at the baseline equal CRM's at `789e056`, and the same two `supabase` paths changed here as there; the disposition's 78 surface statuses equal CRM's. CRM SPEC-306's Step 6 results therefore hold here and are cited, not re-run: guard `692eee1f…` SECURITY INVOKER and emitter `57bdf4c9…` SECURITY DEFINER, test 165 16/16 and tests 28, 82 and 48 alone, the probes, mutants M1–M4 killed with the restored shape equal, the causal negative (165 fails 1, 4–7, 12 and 13), and parity 259 `0e398aea…`/3156 → 260 `4a7b00b1…`/3160.
- **The local Founder stack** after a clean reset with the project-local CLI 3.0.0: 260 migrations, latest `20261112150000`; guard `md5(prosrc)` `692eee1f6c5a0944a5d06e18f5a3a655`, SECURITY INVOKER, and emitter `57bdf4c9574caf29f59c651b32dc7888`, SECURITY DEFINER, each ACL `{postgres=X/postgres}`; the five triggers of `document_links`; `parity_surface.sql` functions `73b0bbffade0a788aff53c10266a97dc`/341, triggers `8f39469bf723f0ea53cccb3c96fb65fd`/328, `_combined` `4a7b00b15007fbdb9072203d1f46ad19`/3160, each equal to CRM's.
- **Generators, scope and diff.** The API-contract generator's output equals CRM SPEC-306's committed contract and this repository's (blob `ee763c1958b6363d36cc812506f69871531e4368`), as Consumer Closure states; `generate-ai-map.ps1 -Check` exit 0. Only the five Step 1–5 paths changed; `git diff --check` clean. (A first run of the readiness script, 6 s after the reset, saw the generator's psql refuse once; the generator then ran clean by itself and in the rerun; the first log is kept.)
- **Consistency:** exactly the six expected pre-deploy items, the same as the sandbox: 259 vs 260 migrations, latest, ledger fingerprint, 164 vs 165 files, 3101 vs 3117 assertions, RECOVER-1 (Founder evidence).
- **Fresh Founder Secondary baseline**, read-only through `supabase-secondary` (15:57 UTC by the server clock; the project URL and the grants surface through `supabase-secondary-write` inside `BEGIN TRANSACTION READ ONLY`, 16:04 UTC): URL `https://brplkqmbzffpxqgkkdzo.supabase.co`; ledger 259 `cfd3fcd7719bb2b519efd4bf700636ac`, latest `20261111150000`, target absent by version and by name; both functions absent; `document_links` triggers `document_links_derive_created_by`, `document_links_enforce_document_subscription_gate`, `document_links_guard_write_capability`; 0 tenants, 0 documents, 0 links, 0 events. `parity_surface.sql`: functions `e11c0124eec937fa08c1f7fe567b1249`/339, triggers `b5c21e213844e603ed5e1a6f9b0be455`/326, `_combined` `0e398aeac8e622fabeda83ac1900bf9d`/3156, each of the ten surfaces equal to the recorded Founder evidence and to CRM Primary's before SPEC-306.
- **Predicted delta:** ledger 260 `5f6e412e…`; functions `73b0bbff…`/341; triggers `8f39469b…`/328; `_combined` `4a7b00b1…`/3160; guard `692eee1f…`; emitter `57bdf4c9…`; the two new triggers; catalog unchanged; business counts unchanged.

### 2026-11-12 — Gate 2 (Step 7), DELEGATED

DELEGATED exact-SHA Gate-2 record for SPEC-309: migration `supabase/migrations/20261112150000_a_document_is_linked_only_by_someone_who_can_read_it.sql`, SHA-256 `5bfb8e52155d367b5aab3e516e7b295d2ea30b3f0589df935396cbd0a37af9f3`, md5 `149882262bc6f900927121fcc13005b4`, 4684 bytes, to Founder Secondary `brplkqmbzffpxqgkkdzo` only, under the owner's instructions of 2026-11-08 (class authorization for Batch 6 releases and standing approval of proposals ~10:20 Cairo; publish, promote and hosted deploy ~12:05 Cairo), 2026-11-11 (Batch 6 decisions 1-9 ~19:50 Cairo; decision 8, the twin lane) and 2026-11-12 (priority order waiving no gate ~12:20 Cairo; slice 8 in run mode 2 ~17:02 Cairo, whose Lane includes this twin), recorded outside this repository. Step 6 passed. The migration's top-level statements are two `create or replace function`, each with its `revoke`, and two `create trigger`: it drops no table or column and deletes or rewrites no business row. Not a human-typed digest. Primary `vrvtsxexkiiiivlkdxzp` is not a target.

### 2026-11-12 — Founder Secondary deployment (Step 8)

Through the Founder write connector `supabase-secondary-write` from this VS Code session, after its `get_project_url` named `https://brplkqmbzffpxqgkkdzo.supabase.co`, 16:10–16:11 UTC by the server clock; Primary `vrvtsxexkiiiivlkdxzp` not contacted:
- **Immediate re-read, exact match** (inside `BEGIN TRANSACTION READ ONLY`, 16:10:32 UTC). HEAD `210bcfd02a236b74240163249fd2d38fe48b10aa`; migration SHA-256 `5bfb8e52155d367b5aab3e516e7b295d2ea30b3f0589df935396cbd0a37af9f3`, md5 `149882262bc6f900927121fcc13005b4`, 4684 bytes, LF, ASCII; ledger 259 `cfd3fcd7719bb2b519efd4bf700636ac`, latest `20261111150000`, target absent by version and by name; both functions absent; triggers of `document_links` as in Step 6; `document_linked` at 56; catalog 71/626; 0 tenants, 0 documents, 0 links, 0 events.
- **Transmitted text** proven server-side in the same read: `md5` `149882262bc6f900927121fcc13005b4`, equal to the file. Applied once with `apply_migration` (`a_document_is_linked_only_by_someone_who_can_read_it`).
- **Guarded rename.** The connector stored version `20261112161046`: exactly one new row, one stored statement with md5 `14988226…` and 4684 bytes, no existing target. One guarded `UPDATE` (row count required 1) renamed it to `20261112150000`.
- **Fresh reads** (16:11:20 and 16:11:28 UTC). Ledger 260 `5f6e412ee282edaf1e16346c3d5b5805`, latest `20261112150000`, equal to the migration files; `parity_surface.sql`: functions `73b0bbffade0a788aff53c10266a97dc`/341, triggers `8f39469bf723f0ea53cccb3c96fb65fd`/328, the other eight surfaces unchanged, `_combined` `4a7b00b15007fbdb9072203d1f46ad19`/3160, each equal to the local stack after a clean reset and to CRM Primary's after SPEC-306; guard `md5(prosrc)` `692eee1f6c5a0944a5d06e18f5a3a655`, SECURITY INVOKER, and emitter `57bdf4c9574caf29f59c651b32dc7888`, SECURITY DEFINER, each ACL `{postgres=X/postgres}`; triggers `document_links_guard_document_readable` (BEFORE INSERT OR UPDATE) and `document_links_emit_move` (AFTER UPDATE) added to the three; catalog 71/626 with `document_linked` at 56; 0 tenants, 0 documents, 0 links, 0 events. No business row was written.

### 2026-11-12 — Post-deploy records (Step 9)

- `reports/evidence/founder-ledger-evidence.json` (schema 3) from the Step 8 readings only (read 2026-11-12 16:11:28 UTC, `repository_head` `210bcfd`): 260 entries whose fingerprint recomputes to `5f6e412e…`, functions `73b0bbff…`/341, structure `4a7b00b1…`/3160, the triggers and `_combined` surface rows; `read_query` unchanged. `scripts/check_primary_ledger.ps1` (RECOVER-1 CLEAN) and `scripts/check_database_parity_evidence.ps1` (FOUNDER PARITY EVIDENCE CLEAN) pass.
- Manifest `Live state` set from the same readings in its existing form; **80 client RPCs** unchanged. `supabase/tests` holds 165 files whose literal `plan(N)` sum to 3117; `Suite **165 files / 3117 assertions**`.
- DOC-9 and DOC-10 register rows replaced with the DEPLOYED text, nothing else changed.
- `MASTER_API_CONTRACT.md` regenerated byte-identical (80 RPC endpoints, blob `ee763c1958b6363d36cc812506f69871531e4368`, equal to CRM SPEC-306's), as Consumer Closure states; `ai-map.json` and `repository-index.md` regenerate byte-identical, LF. `scripts/check_repository_consistency.ps1`: CLEAN.
- Runtime Checkpoint DONE; Status Approved → In Progress; one implementation commit.

## Verification Notes

None.


### 2026-11-12 — Gate 1 approval recorded

DELEGATED exact Gate1 under the owner's instructions of 2026-11-08 (class authorization for Batch 6 releases and standing approval of proposals ~10:20 Cairo; publish, promote and hosted deploy ~12:05 Cairo), 2026-11-11 (Batch 6 decisions 1-9 ~19:50 Cairo, whose decision 8 is the twin lane) and 2026-11-12 (priority order waiving no gate ~12:20 Cairo; slice 8 in run mode 2 ~17:02 Cairo, whose Lane includes this ORVION twin of CRM SPEC-306); Draft SHA-256 0AB8D9C0CDFE4C54360B6E0D910D3D4A7163CAF75D4C5943E9BD89695F170282, decision SHA-256 96DADB85B6A88316ADDEDC5756E671195FCE742369E57E605A2142FD9CB3D549. No fabricated human future-digest approval. Gate 2 (Founder Secondary deploy) is a separate exact-SHA record in Step 7. Immediately before allocation the hash, the Draft blob 6188f6a5b7cd20635cb46f2664d003f003202e12, all 3 source anchors, the baseline HEAD d5224e3eb4d0daeb6a43bfbe2a65c7e81d87890a against refreshed origin/main d5224e3eb4d0daeb6a43bfbe2a65c7e81d87890a and a clean checkout were revalidated, and the pre-commit allocator admitted the identity; Draft allocated as 8fd80fe. No implementation performed before this transition.


Verdict: Confirmed Complete

Independent current Git evidence: selected Draft 0AB8D9C0CDFE4C54360B6E0D910D3D4A7163CAF75D4C5943E9BD89695F170282, allocated blob 6188f6a5b7cd20635cb46f2664d003f003202e12, the five literal outputs (migration and test 165 byte-identical to CRM SPEC-306; canon 27 CRM's text with this contract's id; register and disposition as frozen), the recorded Step 6 readiness gate with the identity proof, the DELEGATED exact-SHA Gate-2 record, the Founder Secondary deploy of only 20261112150000 to brplkqmbzffpxqgkkdzo with the fresh post-deploy ledger, functions and structure equal to local, the Step 9 records (Founder ledger evidence, manifest Live state and suite 165/3117, DOC-9 and DOC-10 DEPLOYED, API contract identical), regenerated discovery, unchanged native evaluator, document read scope migration and API contract, and declared scope verified; Primary vrvtsxexkiiiivlkdxzp was never contacted. This original root owns fresh receipt d017d7d9ed6810aadc6fc82ba057dc90be122d1eadc99f399bc9a7b7921ccaf0, finishHead 986b45fbb776cc54bc749f8f9538adcf0f52f2ea, profiles DATABASE,REPOSITORY, in a native timed/watched Finish observed READY/END0. Native Complete/range/binder still own full receipt/criterion validation. No publication or hosted result asserted.

## Review Gate

- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [ ] No file outside Write Scope was modified, created, or deleted.
- [ ] No section was added, removed, or restructured outside the approved steps.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] Any step that could not be resolved deterministically was reported, not guessed.
- [ ] If this Change Request's Supersedes / Depends On section names another file, that file's Status has been updated accordingly.
- [ ] The repository is in a clean, releasable state.

## Notes

After actual native Finish and truthful Review, synchronize only this contract and the declared manifest/discovery paths to Complete. Set `Last Completed: **SPEC-309: Batch 6 Slice 50 — a document is linked only by someone who can read it, and a moved link is recorded (DOC-9, DOC-10), the twin of CRM SPEC-306, deployed to Founder Secondary; native verification and Review complete. Publication/promotion remain separately governed.**` and regenerate discovery. `Next capability` and `Current Module` stay unchanged: the selector names the next slice. Candidate binding follows Complete and is never a pre-Complete criterion.

Exact baseline d5224e3eb4d0daeb6a43bfbe2a65c7e81d87890a and source anchors:

| Path | Baseline Git blob |
| --- | --- |
| `_ORVION_CANONICAL/27_event_catalog.md` | `433cb885bcad27ad194dac6533eaaf9e68574646` |
| `reports/master/MASTER_GAP_REGISTER.md` | `7984ad0befd3f8892250a8e531fe7f9ce0ab5328` |
| `reports/master/MASTER_SURFACE_DISPOSITION.md` | `1eedb908b17a8ca18809e6be7566c6efade32618` |

Selection sources: native AGENTS.md, CR_LIFECYCLE.md, ENGINEERING_METHOD.md, GOVERNANCE.md, SPEC-144, SPEC-287, SPEC-305 and SPEC-308 at d5224e3eb4d0daeb6a43bfbe2a65c7e81d87890a; CRM SPEC-306 (the twin's origin and its adopted proof); the owner's instructions of 2026-11-08 and 2026-11-12 (recorded outside this repository). This is the one Draft for this surface, finalized after the adversarial review and the evidence refresh its Draft Assurance records; correctness remains native and independent.
