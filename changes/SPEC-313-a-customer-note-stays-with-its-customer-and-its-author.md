# Change Request — SPEC-313

## Status

[ ] Draft
[ ] Approved
[ ] In Progress
[x] Complete
[ ] Cancelled

## Objective

Batch 6 Slice 54 keeps every customer note with the customer it was written about and its text with its author, keeps its `created_at`, and trims and requires its text on every door, as `app.add_customer_note` does, so the name on a note is the name of the person who wrote what it says (CUST-15, CUST-16). It records `notifications` and `holidays` with no finding and pins the holidays door.

## Business Reason

- **Selection.** CRM's `scripts/batch6_select_target.ps1` at `1a760bb` and this repository's at `f4a797c`, each on its live local catalog, rank `customer_notes` (Exposure 5, coverage 38), `notifications` (5/64) and `holidays` (4/8) next, all NOT-RECORDED. Under the owner's instructions of 2026-11-16, this slice's entry grouped the selector's next three surfaces in one contract per product. Each surface keeps its own finding rows, migration or test, and disposition row. The manifest's Next capability names that selector, never a copy of its result.
- **The twin, adopted by identity.** CRM measured and fixed these findings in its SPEC-310 (`changes/SPEC-310-a-customer-note-stays-with-its-customer-and-its-author.md` in CRM; this repository's `SPEC-310` is the unrelated `rates-grants-and-catalog-values-change-only-with-step-up-and-a-record`). At `f4a797c`, `supabase/migrations` (tree `24e1e7c8574f12ebc81d0383a940160b1770d664`), `supabase/tests` (tree `40a7df0f5cfd2efe80d272f5bc898ca936e2d446`), `scripts/verify_database.sql` and `reports/master/MASTER_API_CONTRACT.md` (`f426c1a52f8373476f061f854e44f99270dd6fad`) equal CRM's at SPEC-310's baseline `1a760bb`; Founder Secondary's ten structural surfaces before the change (`_combined` `88c35cab62c01ed7433d57402c8ee72c`/3175) equal CRM Primary's before SPEC-310; the migration and tests 173 and 174 here are CRM SPEC-310's committed bytes. There is no canon. CRM's prototype measurements, probes, mutants and causal negative therefore hold here unchanged; they are cited, not re-run. This contract re-proves the identity, reads Founder Secondary, and runs its own native lifecycle, whose Finish re-runs the DATABASE protocol on the final bytes.
- **Why it matters.**
  - `customer_notes` holds what a named person wrote about a customer. Its RPC `app.add_customer_note` (SECURITY INVOKER) requires CREATE_CUSTOMER, trims the text and refuses an empty one, and only ever inserts; `app.derive_created_by` names the author and keeps the name; the merge (SECURITY DEFINER, owned by `postgres`) re-points a merged customer's notes. No function rewrites a note's text, yet `authenticated` holds table-level INSERT and UPDATE (pin, confidential and archive are column updates the product needs), and PostgREST serves both.
  - `notifications` holds what the platform tells a user. `authenticated` holds SELECT and a column UPDATE of `is_read` and `read_at` only; its writers are SECURITY DEFINER.
  - `holidays` holds a tenant's and a branch's days off. `authenticated` holds INSERT, SELECT and UPDATE, guarded by `app.guard_write_capability` (MANAGE_BRANCHES or MANAGE_TENANT_SETTINGS, with the second factor) and the tenant policy.
- **Measured in CRM at `1a760bb`** on its local stack (CRM SPEC-310). The fixtures were one tenant with an owner, two employees holding CREATE_CUSTOMER, a branch manager, a trainee and a finance manager, plus another tenant, two customers and their notes, the users' notifications and the tenant's holidays.
  - **CUST-15 (Medium).** An employee at `aal1` rewrote the owner's note, blanked it, moved it to a second customer and back-dated its `created_at` to 2019, each by UPDATE at the table door; another employee rewrote the first one's note. Each note still named its original author, and nothing was recorded: the tenant's events did not move.
  - **CUST-16 (Low).** A note of three spaces was accepted at the table door, which the RPC refuses.
  - **Why CUST-15 is Medium.** CUST-13's precedent: an unrecorded rewrite of what a named person wrote about a customer, which the next reader trusts under that name.
  - **Why CUST-16 is Low.** CHAT-4's precedent: a blank text at a direct door; no function reads a note's text.
- **The repair: one migration, `20261116120000` (CUST-15, CUST-16).**
  - `app.guard_customer_note_integrity` (BEFORE INSERT OR UPDATE, SECURITY INVOKER, empty `search_path`, executable by no client role) is in the shape of `app.guard_quotation_integrity`: the definer paths owned by `postgres`, the merge among them, pass through.
  - The text is trimmed as the RPC trims it, so a blank note is refused by the existing NOT NULL.
  - A note keeps its customer (23514, as a quotation does), only its author may change its text (42501), and `created_at` is kept on UPDATE, as `app.derive_created_by` keeps `created_by`.
  - No grant, policy, constraint, RPC signature or event code changes. Pinning, marking one's own note confidential and archiving stay open to whoever could do them before.
- **`notifications` is recorded with no finding.** No client role inserts, retargets, retitles or deletes one, and another user's notification is invisible (tests 10, 21, 36, 58, 63, 65, 66, 88, 93, 95, 98, 100, 136 and 158).
- **`holidays` is recorded with no finding.** The door held when probed; test 174 pins it, because Check 24 needs a test that names the surface. No migration.
- **Existing files that move, each for a stated reason.**
  - `reports/master/MASTER_API_CONTRACT.md` is regenerated and stays unchanged: no RPC, signature, grant or table shape changes.
  - No existing test moves.
- **Swept and found sound, pinned rather than changed:**
  - A note's author is derived, never named; a confidential note is invisible to others and only its author may mark it; no client role deletes a note or a holiday, an owner at `aal2` included.
  - Archiving a note needs ARCHIVE_RECORD; a role without CREATE_CUSTOMER is refused on both note doors; writing a holiday needs MANAGE_BRANCHES or MANAGE_TENANT_SETTINGS with the second factor.
  - Another tenant reads no note, notification or holiday and cannot add one; anonymous REST is refused.
- **Recorded positions, not repaired:**
  - A note's and a holiday's `created_at` is caller-supplied on INSERT (SPEC-216's schema-wide question).
  - An archived note may be inserted at the door; archiving a note also needs CREATE_CUSTOMER.
  - Notes and holidays record no event on any door, the RPC's included; pinning stays open to every writer in scope.
  - A notification's `read_at` and `is_read` are free to its target and read by nothing.
  - A blank holiday name and a second holiday on the same date are accepted; nothing reads holidays.
- **Latent on Founder Secondary.** `brplkqmbzffpxqgkkdzo` holds 0 tenants, 0 customer notes, 0 notifications and 0 holidays (read-only through the Founder connector, 2026-11-16, ledger 267 `8be9389fce4d3f330674d2ed083278ca`, the target and the guard absent). No stored row is affected and no data repair is needed.

## Risks

- **Trigger order.** The new BEFORE INSERT OR UPDATE guard runs beside the existing `customer_notes` triggers, `app.derive_created_by` and the capability and archive guards among them; each decides its own column or refusal, and the existing triggers are unchanged.
- **A non-author can no longer change a note's text or move a note.** The RPC only inserts, and the merge, owned by `postgres`, passes through; test 71 (the merge) passes unchanged and catches a guard that does not pass `postgres` through. No existing test rewrites another user's note.
- **Founder Secondary deployment is irreversible.** It runs only under the exact-SHA Gate-2 record of Step 7, and approval of this contract does not authorize it. Primary `vrvtsxexkiiiivlkdxzp` belongs to CRM and is never contacted.
- **Gate 1 and Gate 2 of this contract are DELEGATED** under the owner's instructions, recorded outside this repository and never as a human-typed digest:
  - class authorization for Batch 6 releases and standing approval of proposals, 2026-11-08 ~10:20 Cairo
  - publish, promote and hosted deploy, ~12:05 Cairo
  - slice 12 in run mode 2, with the slice's own grouping decision, 2026-11-16 ~17:05 Cairo, whose Lane includes this ORVION twin of CRM SPEC-310

## Supersedes / Depends On

None.

## Write Scope

- `changes/SPEC-313-a-customer-note-stays-with-its-customer-and-its-author.md`
- `supabase/migrations/20261116120000_a_customer_note_stays_with_its_customer_and_its_author.sql`
- `supabase/tests/173_a_customer_note_stays_with_its_customer_and_its_author_test.sql`
- `supabase/tests/174_a_holiday_is_written_only_by_a_tenant_settings_holder_test.sql`
- `reports/master/MASTER_GAP_REGISTER.md`
- `reports/master/MASTER_SURFACE_DISPOSITION.md`
- `reports/master/MASTER_API_CONTRACT.md`
- `reports/evidence/founder-ledger-evidence.json`
- `_ORVION_CANONICAL/manifest.md`
- `ai-map.json`
- `repository-index.md`

## Out of Scope — Files Forbidden to Modify

- `supabase/migrations/202607041600_create_organization_tables.sql`
- `supabase/migrations/202607042100_create_crm_core_tables.sql`
- `supabase/migrations/202607042600_create_event_and_notification_tables.sql`
- `supabase/migrations/202607043300_create_rls_policies.sql`
- `supabase/migrations/202607044900_merge_customer_identity.sql`
- `supabase/migrations/202607051100_master_data_write_paths.sql`
- `supabase/migrations/202607056100_write_grants_match_the_writers.sql`
- `supabase/migrations/202607056400_created_by_is_derived_not_declared.sql`
- `supabase/migrations/20260924120000_quotation_door_parity.sql`
- `supabase/tests/10_grant_model_test.sql`
- `supabase/tests/19_master_data_write_path_test.sql`
- `supabase/tests/21_read_scope_model_test.sql`
- `supabase/tests/53_api_surface_test.sql`
- `supabase/tests/58_write_grants_and_config_capability_test.sql`
- `supabase/tests/67_care_capability_and_message_integrity_test.sql`
- `supabase/tests/71_customer_identity_merge_test.sql`
- `supabase/tests/85_write_capability_on_update_test.sql`
- `supabase/tests/100_notification_delivery_lifecycle_test.sql`
- `supabase/tests/111_customer_surface_test.sql`
- `supabase/tests/136_lead_assignment_clock_and_current_handler_test.sql`
- `supabase/tests/144_the_merge_record_is_written_only_by_the_merge_test.sql`
- `supabase/tests/158_a_due_retry_is_opened_once_test.sql`
- `scripts/verify_database.sql`
- `scripts/generate-api-contract.ps1`
- `scripts/generate-ai-map.ps1`
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
- `supabase/migrations/202607051100_master_data_write_paths.sql` (`app.add_customer_note`)
- `supabase/migrations/202607056400_created_by_is_derived_not_declared.sql` (`app.derive_created_by`)
- `supabase/migrations/202607044900_merge_customer_identity.sql` (the merge re-points notes)
- `supabase/migrations/20260924120000_quotation_door_parity.sql` (`app.guard_quotation_integrity`, the guard's shape)
- `supabase/migrations/202607056100_write_grants_match_the_writers.sql` (the grant shape)
- `changes/SPEC-134-master-data-write-paths.md` (the note RPC)
- `changes/SPEC-214-quotation-door-parity.md` (the integrity guard's form)
- `changes/SPEC-216-document-door-parity.md` (the caller-supplied `created_at` position)
- `changes/SPEC-312-a-conversation-message-is-timed-and-recorded-and-an-identity-signal-is-normalized-and-never-rewritten.md` (CUST-13 and CHAT-4, the severity precedents; the last Founder-deploying slice, the twin of CRM SPEC-309)
- `reports/master/MASTER_GAP_REGISTER.md` (CUST-13, CHAT-4)
- `reports/master/MASTER_SURFACE_DISPOSITION.md`
- `reports/master/MASTER_EXECUTION_PLAN.md`, Batch 6 method, EC-1…EC-11
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

Pass 1 Design: Three surfaces are covered in one contract.

- **`customer_notes`.** One BEFORE INSERT OR UPDATE guard in `app.guard_quotation_integrity`'s shape trims and requires the text, keeps a note with its customer and its text with its author, and keeps `created_at`; the `postgres` definer paths pass through.
- **`notifications`.** It is recorded with no change.
- **`holidays`.** It is recorded with no migration; test 174 pins the door as found.
- **Tests and records.**
  - Test 173 pins the guard, the unchanged grants, the trimmed and refused door text, the author's own correction, the refused move, rewrite and blanking of another's note, the pin that stays open, the kept `created_at` and the RPC's trimmed note.
  - Test 174 pins the holidays grants, the owner's writes at `aal2`, and the refusals of the owner at `aal1`, the employee, the branch manager and another tenant.
  - The register records two new rows and the disposition records the three surfaces.

Pass 2 Adversarial Review: CRM SPEC-310's, adopted with its bytes (every SPEC it cites is blob-identical in this repository, and its SPEC-309 precedent is this repository's SPEC-312); there the design was challenged on the prototype.

- **Rejected designs:**
  - **Revoking UPDATE on `customer_notes`.** Pin, confidential and archive are column updates the product needs, and an author must still correct their own note.
  - **Column-level UPDATE grants.** A grant cannot say "only the author"; the author's own correction would be lost or another's rewrite kept.
  - **An `auth.uid() is null` exemption beside the `postgres` pass-through.** `service_role` holds no INSERT or UPDATE here, and `postgres` is already admitted (mutant 173 M6 removes the pass-through and the merge test 71 kills it).
  - **Recording a note event on the door.** Notes record no event on any door, the RPC's included; that is a recorded position, not this repair.
  - **A holidays migration.** The door held on every probe; a test pins it instead.
  - **Copying the selector's next target into the manifest** (SPEC-270; SPEC-278's cancellation).
- **Attacks run on the final bytes.**
  - The probes, as two employees at `aal1`, an owner at `aal1` and `aal2`, a branch manager, a trainee, a finance manager, another tenant and anonymous REST, close both findings and hold every swept behavior.
  - Every existing test that touches the three surfaces passes, and so does the full suite.
  - The generated API contract is unchanged.

Pass 3 Evidence Refresh: 2026-11-16.

- **The identity, re-proven at `f4a797c`:**
  - the migrations and tests trees, `scripts/verify_database.sql` and `MASTER_API_CONTRACT.md` equal CRM's at `1a760bb`, and the selector here ranks the same three surfaces with the same figures;
  - the three `supabase/` files written here are CRM SPEC-310's committed blobs;
  - the disposition's 78 surface rows carry the same statuses, and the register and disposition were written by the same script with this contract's id, the identity measurement and Founder Secondary in place of Primary.
- **Read read-only on hosted.** Founder Secondary, through the Founder connector: its project URL, ledger, target absence, all ten structural surfaces (equal to CRM Primary's before SPEC-310), the three functions, the triggers of the three tables and its counts.
- **Adopted by reference.** CRM SPEC-310's measurements on these bytes: the clean reset, tests 173 and 174 alone, pgTAP Pass A and B, the HTTP suites and smoke, the probes before and after, all ten mutants and the causal negative, the structural fingerprints before and after, the API-contract generator (no row moves), the map generator and consistency.

Selected Version: SPEC-313; selected: the twin of CRM SPEC-310: the smallest repair that closes CUST-15 and CUST-16 (one SECURITY INVOKER BEFORE INSERT OR UPDATE guard on customer_notes that trims and requires the text as the RPC does, keeps a note with its customer, lets only its author change its text and keeps created_at, the postgres definer paths, the merge among them, passing through; no grant, policy, RPC signature or event code changed; notifications and holidays audited with no finding and the holidays door pinned by test 174), the migration and tests 173-174 byte-identical to CRM, its prototype proof adopted by identity (the same migrations and tests trees and the same pre-change Founder structure)

### Consumer Closure

Applicability: APPLICABLE

| Changed fact or surface | Relevant consumer | Disposition | Evidence / preserved behavior |
| --- | --- | --- | --- |
| A customer note stays with its customer and its text with its author, keeps its `created_at`, and has its text trimmed and required on every door | the note door of every CREATE_CUSTOMER holder; `app.add_customer_note`; `app.derive_created_by`; `app.merge_customer_identity` | WRITE | Migration SHA-256 `a04fef90c91164ac430238fb840859e079be2ee40bde80df6c70051aa141c198`, md5 `1238bbbbd4522cd5cf384689c97caefa`, 3512 bytes, LF, ASCII. The guard's `md5(prosrc)` is `e47fbc463245d57861dddd99f93e1517`, SECURITY INVOKER, ACL `{postgres=X/postgres}`. Trigger: `customer_notes_guard_note_integrity` BEFORE INSERT OR UPDATE. `app.add_customer_note` (`0b06bc5fe2da28f58b0292ab07676078`) and `app.derive_created_by` (`044c24ffbc0e51638c224a701a7cc6bb`) are unchanged, with their security mode and ACL. Tests 10, 19, 53, 58, 67, 71, 85, 111, 142 and 144 pass unchanged. |
| Notifications and holidays | `notifications`; `holidays`; their writers and readers | UNAFFECTED | No grant, policy, trigger or writer changes. Notifications: tests 10, 21, 36, 58, 63, 65, 66, 88, 93, 95, 98, 100, 136 and 158 pass unchanged. Holidays: tests 10 and 58 pass unchanged. |
| A clean reset holds the migration | the local stack; `supabase_migrations.schema_migrations` | WRITE | A clean reset gives 268 migrations, latest `20261116120000`, ledger `b19e6f48e19b3b51ccdae01d26186fef`. `customer_notes` carries 6 triggers (was 5), `notifications` 3 and `holidays` 3. Catalog 71/626. |
| Tests 173 and 174 | `supabase/tests` | WRITE | CRM SPEC-310's committed bytes, measured there. Test 173: SHA-256 `6c0abdbb4cb4387a158bd477a753a6d4b1f91f00f9d350d7725ac6bdf8ef1ac0`, md5 `628e58db9fa9d69c111fcac633d7b28b`, 6962 bytes, `plan(14)`: 14/14. Test 174: SHA-256 `82ba68e6753ad83416d33265ff36e7a61f87c38038c0593c6d0fb79884d56c85`, md5 `0c56e221262559e16b32f3142d215cef`, 7059 bytes, `plan(11)`: 11/11. Each LF, ASCII. |
| Other tests and the suite | the full pgTAP suite; the HTTP suites; smoke | VERIFY | In CRM on these bytes: Pass A `Files=174, Tests=3218`, PASS; HTTP 35/0, 85/0, 122/0; Pass B 174/3218, PASS; smoke `ALL CHECKS PASSED` (78 tables, 71/626 catalog). The 174 files' literal `plan(N)` values sum to 3218. No existing test and no line of `scripts/verify_database.sql` moves. |
| Structural surface on Founder Secondary | `scripts/parity_surface.sql`; `founder-ledger-evidence.json`; `scripts/check_database_parity_evidence.ps1` | WRITE | Before (267): functions `b13e66125d5ea63134310305faf3ee7e`/349, triggers `246b4ca76492cd46629f538f2ed1b108`/336, grants `5cfb09c3344a26c5513989ef3c358ff1`/188, `_combined` `88c35cab62c01ed7433d57402c8ee72c`/3175, equal to the recorded Founder evidence and to CRM Primary's before SPEC-310. Founder Secondary holds `public.add_customer_note` `c1212f387fbcdfe7dc4692d17a8f2452` and `app.derive_created_by` `61eb85f1adc40eff12e502fdac344969`, as CRM Primary does, and `app.add_customer_note` `d194a2e267ba147638bfd46fd77042f2`, which differs from CRM Primary's `603e16ed8a88323295a88e587352bcff` and CRM's local `0b06bc5f…` only in the comments and line endings of the text each project was sent (the normalized function surface is equal). After (268, local): functions `80f02f416e552e5ecd43d053ae6c1478`/350 (+1), triggers `764c62c6b405673cfea362c053bb9315`/337 (+1), grants unchanged `5cfb09c3344a26c5513989ef3c358ff1`/188, `_combined` `22978d051e6586ecd1772b144993b6b8`/3177. Policies, constraints, columns, views, indexes, status transitions and RLS are unchanged, as on CRM Primary after SPEC-310. Step 9 writes Founder values only from fresh post-deploy readings. |
| Client API | `MASTER_API_CONTRACT.md` (Check L3); `scripts/generate-api-contract.ps1` | VERIFY | No RPC is added or removed, and no signature, EXECUTE grant or table grant changes. On the final bytes the generator's output equals the baseline contract, 0 rows differing. Step 9 regenerates it and it must stay unchanged. |
| Measured state that moves | manifest `Live state` and suite figure; `founder-ledger-evidence.json`; `ai-map.json` and `repository-index.md` | WRITE | 267 → 268 migrations, latest `20261116120000`, ledger fingerprint `b19e6f48e19b3b51ccdae01d26186fef`; 172 → 174 files and 3193 → 3218 assertions; coverage 60 → 63 of 78. Tables (78) and client RPCs (80) do not move. `Next capability` and `Current Module` stay unchanged (selector form). |
| The pinned manifest lines `Current Module`, `Next capability` and `Batch 6 surface coverage` | native Boot; `scripts/batch6_select_target.ps1` and `MASTER_SURFACE_DISPOSITION.md`, which own their values (GOVERNANCE.md §6 rule 10) | UNAFFECTED | Step 10 names `Current Module` and `Next capability` only to leave them unchanged. Each line keeps its ratified text and pin. |
| CUST-15 and CUST-16 fixed; three surfaces recorded | `MASTER_GAP_REGISTER.md`; `MASTER_SURFACE_DISPOSITION.md`; Checks 21, 22, 24, 25, 29 | WRITE | No CUST-15 or CUST-16 row exists at `f4a797c`; the rows and the disposition rows are CRM's with this repository's ids, the identity measurement and Founder Secondary in place of Primary. Tests 173 and 174 each declare the ten classes with their N/A classes reasoned and carry negative assertions; 173 names `customer_notes`, 174 names `holidays`, and tests 136 and 158 name `notifications`, so Check 24 admits `ADVERSARIAL` for all three. Each new row has Owner `—` and is settled. Coverage 63: 39 `AUDITED`, 21 `AUDITED-OPEN`, 3 `PARTIAL`, 0 `EXEMPT`, 15 `NOT-RECORDED`; all 63 `ADVERSARIAL`. |
| Repository consistency | `scripts/check_repository_consistency.ps1` | VERIFY | With Steps 1–5 applied and the contract present, consistency reports exactly the measured-state items: 267 vs 268 migrations, the latest version, the ledger fingerprint, 172 vs 174 files, 3193 vs 3218 assertions, and the Founder-evidence record. Checks 21–29 pass. Step 9 makes the measured-state items true, and the one implementation commit is made only after it. |
| The four CI-only guard self-tests | `scripts/test_*_guard.ps1`; `orvion-acceptance` | VERIFY | The scripts are unchanged. `orvion-acceptance` runs them on the exact candidate SHA before `main` may move to it. Their controls require the measured state of Step 9, so they are not run locally (CRM timed them once in slice 47: 618 s locally, 84 s in hosted CI). |

Unresolved Material Consumers: None

### Execution-Boundary Satisfiability

Applicability: APPLICABLE

Irreversible Action Step: Step 8 (Founder Secondary deployment)

| Invariant | Required At | Red Opens After Step | Restored By Step | Mandatory Gate Before Step |
| --- | --- | --- | --- | --- |
| The applied files equal CRM SPEC-310's verified bytes and the identity holds | BEFORE_IRREVERSIBLE_ACTION | NONE | NONE | Step 6 |
| Founder Secondary lacks the target migration, and its ledger and structure equal the recorded evidence | BEFORE_IRREVERSIBLE_ACTION | NONE | NONE | Step 8 |
| Manifest, recorded Founder evidence and Founder ledger agree | AFTER_IRREVERSIBLE_ACTION | Step 1 | Step 9 | Step 10 |
| Manifest suite and coverage figures equal the files and the disposition record | BEFORE_COMPLETION | Step 2 | Step 9 | Step 10 |
| The map and the API contract match their generators | BEFORE_COMPLETION | Step 1 | Step 9 | Step 10 |

### Permanent-Control Admission

Applicability: APPLICABLE

Existing Mechanism Reusable: NO

Existing Mechanism: Nothing keeps a door note with its customer or its text with its author, keeps its `created_at`, or trims and requires its text at the door.

- `app.add_customer_note` trims and requires only its own text, and only inserts.
- `app.derive_created_by` names and keeps the author, not what the note says or whom it is about.
- `app.guard_write_capability` decides who may write a note, not whether a written note may change.
- The confidential policy limits who reads a note, not who rewrites a visible one.

Added Property: For every client writer:

- every customer note's text is trimmed, and a blank one is refused, on every door;
- a note stays with the customer it was written about;
- only its author may change its text, and its `created_at` is kept.

The `postgres` definer paths, the merge among them, pass through.

Causal Negative: Measured in CRM on these bytes and adopted by identity: on the `1a760bb` schema, equal to `f4a797c`'s (the stack reset to `20261115180100`), test 173 fails assertions 1, 5, 6, 8, 9, 10, 13 and 14, and test 174 passes 11/11: it pins a door that held, with no migration. With the guard dropped from the repaired stack, test 173 fails the same set. There, the probes store a blank door note and accept another's note rewritten, blanked, moved and back-dated by UPDATE.

Positive Test Design: One tenant with a Giza branch, a sales department, an employee and an owner, and two customers. Positive controls:

- the owner at `aal2` and the employee at `aal1` each add a note at the door, and the employee's is stored trimmed;
- the author corrects their own note;
- the employee pins the owner's note;
- the RPC adds a trimmed note.

Test 174's own tenant adds a tenant-wide and a branch holiday as the owner at `aal2`, and an employee reads both.

Negative Test Design: by attack class, as follows.
- **Door:** a note written at the table door is trimmed and required like one written through the RPC; a holiday is written only by a settings holder on every door.
- **Input:** a blank note is refused (23502); the employee's `created_at` of 2019 on the owner's note is ignored and the original kept.
- **Privilege:** the guard is SECURITY INVOKER with no client EXECUTE; an employee cannot rewrite or blank the owner's note (42501); no one moves a note to another customer (23514); no client role deletes a holiday, the owner at `aal2` included (42501); the owner at `aal1`, an employee and a branch manager cannot add a holiday (42501).
- **Auth and tenant:** another tenant's owner sees no holiday and cannot add one (42501); the notes' tenant and capability guards are unchanged (tests 58 and 85).
- **State, concurrency, replay, business and observability:** N/A, each reasoned in the tests' headers.

Non-Empty Population Obligation: Each test's fixture holds its tenant, branch, department, users, roles and rows before the first assertion: in 173 two customers, an employee and an owner, and their notes; in 174 two tenants, a branch, an employee, an owner, a branch manager and another tenant's owner. Each refusal is asserted by its SQLSTATE, and each kept value by its exact field.

Mutation Obligation: Adopted by identity from CRM SPEC-310, whose prototype ran it on these bytes: each mutant is installed inside its test's own rolled-back transaction, proven installed by a diag line (the md5 of the slice functions, the table's trigger count, its UPDATE and DELETE grants, its row level security and its policy), run, and rolled back. The restored shape is read after the last mutant. A mutant not proven installed is a harness error, never a kill.

| Mutant | Change | Killed on CRM's prototype by |
| --- | --- | --- |
| 173 M1 | the guard trigger dropped | 173 assertions 1, 5, 6, 8, 9, 10, 13 and 14 |
| 173 M2 | a blank text kept | 173 assertions 5 and 6 |
| 173 M3 | a note may move | 173 assertion 8 |
| 173 M4 | anyone may rewrite the text | 173 assertions 9, 10 and 13 |
| 173 M5 | `created_at` not kept | 173 assertion 14 |
| 173 M6 | `postgres` not passed through | the merge test 71, assertions 11, 12, 13, 14, 16 and 17 |
| 174 M1 | DELETE granted to `authenticated` | 174 assertions 1, 4, 6 and 8 |
| 174 M2 | the capability guard dropped | 174 assertions 5, 6, 7, 8 and 9 |
| 174 M3 | tenant isolation opened | 174 assertions 10 and 11 |
| 174 M4 | row level security disabled | 174 assertions 10 and 11 |

Post-Implementation Proof Obligation: All of the following on the final bytes, through canonical `-Finish` from the main checkout with the project-local CLI:

- the clean reset, pgTAP Pass A, the declared HTTP suites, pgTAP Pass B and smoke;
- the generated artifacts, repository consistency and the recorded Founder evidence with its parity.

Before Step 8: the identity proof and the fresh Founder Secondary baseline of Step 6; the focused tests, the probes, the mutants and the causal negative are CRM SPEC-310's on the same bytes.

## Implementation Steps

1. Check whether `supabase/migrations/20261116120000_a_customer_note_stays_with_its_customer_and_its_author.sql` contains `CUST-15, CUST-16 -- Batch 6 slice 54`; if so record Already Applied when its Git blob is 5e1697af620f5a7a8bdfc9aba8e297eed763e5aa, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (the note migration: one guard that trims and requires the text, keeps a note with its customer and its text with its author, and keeps created_at), and change nothing else:

   ```text
   -- CUST-15, CUST-16 -- Batch 6 slice 54 (`customer_notes`).
   --
   -- THE RULE. A customer note is what one person wrote about one customer. `app.add_customer_note`
   -- (SECURITY INVOKER) writes it: CREATE_CUSTOMER, the text trimmed and required, the customer in the
   -- tenant; `app.derive_created_by` names the author and keeps the name; `app.merge_customer_identity`
   -- (SECURITY DEFINER, owned by `postgres`) re-points a merged customer's notes to the survivor. No
   -- function rewrites a note's text. `authenticated` holds table-level INSERT and UPDATE (pin,
   -- confidential and archive are column updates the product needs), and PostgREST serves both.
   -- Measured before this migration (local stack; an `employee` holding CREATE_CUSTOMER, at aal1):
   --   CUST-15  the employee rewrote the owner's note, blanked it, moved it to another customer and
   --            back-dated its `created_at` to 2019; another employee rewrote the first one's note. Each
   --            note still named its original author, and nothing recorded the change;
   --   CUST-16  a note of three spaces was accepted at the table door, which the RPC refuses.
   --
   -- THE REPAIR, in existing shapes. One BEFORE INSERT OR UPDATE trigger in the shape of
   -- `app.guard_quotation_integrity` (SECURITY INVOKER so `current_user` names the caller; the definer
   -- paths owned by `postgres`, the merge among them, pass through; no separate `auth.uid() is null`
   -- exemption, because `service_role` holds no INSERT or UPDATE here and `postgres` is already
   -- admitted). The text is trimmed as the RPC trims it, so a blank one is refused by the existing
   -- NOT NULL; a note keeps its customer (as a quotation does, 23514); only its author may change its
   -- text (42501), so the name on a note is the name of the person who wrote what it says; and
   -- `created_at` is kept on UPDATE, as `app.derive_created_by` keeps `created_by`.
   --
   -- NOT CHANGED: every grant, policy, constraint and foreign key; every other trigger, the archive
   -- authority included; `app.add_customer_note` and the merge. Pinning, marking confidential (the
   -- policy already limits it to the author) and archiving stay open to whoever could do them before.
   -- Positions recorded, not repaired here: `created_at` on INSERT, an archived note inserted at the
   -- door, the archive capability, and notes recording no event on any door, the RPC's included.
   create or replace function app.guard_customer_note_integrity()
   returns trigger
   language plpgsql
   set search_path to ''
   as $fn$
   begin
       if current_user = 'postgres' then
           return new;
       end if;

       new.note_text := nullif(btrim(new.note_text), '');

       if tg_op = 'INSERT' then
           return new;
       end if;

       if new.customer_id is distinct from old.customer_id then
           raise exception 'a customer note stays with the customer it was written about; add a new note instead'
               using errcode = '23514';
       end if;

       if new.note_text is distinct from old.note_text
          and old.created_by is distinct from app.current_user_id() then
           raise exception 'only the author of a customer note may change its text; add a new note instead'
               using errcode = '42501';
       end if;

       new.created_at := old.created_at;
       return new;
   end;
   $fn$;

   revoke execute on function app.guard_customer_note_integrity() from public;

   create trigger customer_notes_guard_note_integrity
       before insert or update on public.customer_notes
       for each row execute function app.guard_customer_note_integrity();
   ```

   The resulting file's Git blob is 5e1697af620f5a7a8bdfc9aba8e297eed763e5aa.

2. Check whether `supabase/tests/173_a_customer_note_stays_with_its_customer_and_its_author_test.sql` contains `plan(14)`; if so record Already Applied when its Git blob is dc3de264a29203d9484d2a7cd420014e49807a97, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 173, 14 assertions), and change nothing else:

   ```text
   -- pgTAP: Batch 6 slice 54 (customer_notes, CUST-15 and CUST-16) --
   -- a customer note stays with its customer and its author (`20261116120000`).
   -- ATTACK-CLASSES: AUTH=N/A TENANT=N/A DOOR STATE=N/A INPUT CONCURRENCY=N/A REPLAY=N/A PRIVILEGE BUSINESS=N/A OBSERVABILITY=N/A
   --   AUTH=N/A -- CREATE_CUSTOMER is the unchanged capability guard (tests 58, 85).
   --   TENANT=N/A -- tenant isolation is the unchanged policy and composite foreign keys.
   --   STATE=N/A -- the archive authority is unchanged (`enforce_archive_authority`).
   --   CONCURRENCY, REPLAY=N/A -- each note is its own row; adding one twice is two notes, as through the RPC.
   --   BUSINESS=N/A -- a note carries no money.
   --   OBSERVABILITY=N/A -- notes record no event on any door, the RPC's included.
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(14);

   insert into auth.users (id, email) values
     ('17300000-0000-0000-0000-0000000000a1','employee@c173.test'),
     ('17300000-0000-0000-0000-0000000000a2','owner@c173.test');
   insert into public.tenants (id, name, slug, status) values
     ('17300000-0000-0000-0000-000000000001','Note Travel','note-travel-173','active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select '17300000-0000-0000-0000-000000000001', sp.id, 'active' from public.subscription_plans sp where sp.plan_code = 'enterprise';
   insert into public.branches (id, tenant_id, name, slug) values
     ('17300000-0000-0000-0000-00000000000a','17300000-0000-0000-0000-000000000001','Giza','giza-173');
   insert into public.departments (id, tenant_id, branch_id, department_type_code, name) values
     ('17300000-0000-0000-0000-0000000000c1','17300000-0000-0000-0000-000000000001','17300000-0000-0000-0000-00000000000a','sales','Giza Sales');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
     ('17300000-0000-0000-0000-000000000011','17300000-0000-0000-0000-000000000001','Employee','employee@c173.test',true,'17300000-0000-0000-0000-0000000000a1'),
     ('17300000-0000-0000-0000-000000000012','17300000-0000-0000-0000-000000000001','Owner','owner@c173.test',true,'17300000-0000-0000-0000-0000000000a2');
   insert into public.user_branch_assignments (tenant_id, user_id, branch_id, department_id, is_primary) values
     ('17300000-0000-0000-0000-000000000001','17300000-0000-0000-0000-000000000011','17300000-0000-0000-0000-00000000000a','17300000-0000-0000-0000-0000000000c1',true);
   insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type)
   select '17300000-0000-0000-0000-000000000001', v.u, r.id, 'tenant'
   from (values ('17300000-0000-0000-0000-000000000011'::uuid, 'employee'), ('17300000-0000-0000-0000-000000000012', 'owner')) v(u, c)
   join public.roles r on r.code = v.c;
   insert into public.customers (id, tenant_id, customer_type_code, full_name) values
     ('17300000-0000-0000-0000-0000000000d1','17300000-0000-0000-0000-000000000001','person','Note One'),
     ('17300000-0000-0000-0000-0000000000d2','17300000-0000-0000-0000-000000000001','person','Note Two');

   select is(
     (select count(*)::int from pg_trigger
      where tgrelid = 'public.customer_notes'::regclass and not tgisinternal
        and tgname = 'customer_notes_guard_note_integrity'),
     1, 'the note guard is installed on customer_notes');
   select is(
     (select string_agg(p || '=' || has_table_privilege('authenticated', 'public.customer_notes', p), ' ' order by p)
      from unnest(array['DELETE', 'INSERT', 'SELECT', 'UPDATE']) p),
     'DELETE=false INSERT=true SELECT=true UPDATE=true', 'the grants are unchanged: notes stay pinnable and archivable');

   set local role authenticated;
   select set_config('request.jwt.claims', '{"sub":"17300000-0000-0000-0000-0000000000a2","aal":"aal2"}', true);
   select lives_ok(
     $$insert into public.customer_notes (id, tenant_id, customer_id, note_text) values
       ('17300000-0000-0000-0000-0000000000e2','17300000-0000-0000-0000-000000000001','17300000-0000-0000-0000-0000000000d1','Prefers morning calls')$$,
     'the owner adds a note at the table door');

   select set_config('request.jwt.claims', '{"sub":"17300000-0000-0000-0000-0000000000a1","aal":"aal1"}', true);
   select lives_ok(
     $$insert into public.customer_notes (id, tenant_id, customer_id, note_text) values
       ('17300000-0000-0000-0000-0000000000e1','17300000-0000-0000-0000-000000000001','17300000-0000-0000-0000-0000000000d1','  Called, no answer  ')$$,
     'an employee adds a note at the table door');
   select is(
     (select note_text from public.customer_notes where id = '17300000-0000-0000-0000-0000000000e1'),
     'Called, no answer', 'CUST-16: the door trims the text as the RPC does');
   select throws_ok(
     $$insert into public.customer_notes (tenant_id, customer_id, note_text)
       values ('17300000-0000-0000-0000-000000000001','17300000-0000-0000-0000-0000000000d1','   ')$$,
     '23502', null, 'CUST-16: a blank note is refused at the door, as the RPC refuses one');
   select lives_ok(
     $$update public.customer_notes set note_text = 'Called twice, no answer'
       where id = '17300000-0000-0000-0000-0000000000e1'$$,
     'the author may still correct their own note');
   select throws_ok(
     $$update public.customer_notes set customer_id = '17300000-0000-0000-0000-0000000000d2'
       where id = '17300000-0000-0000-0000-0000000000e1'$$,
     '23514', null, 'CUST-15: a note cannot be moved to another customer, even by its author');
   select throws_ok(
     $$update public.customer_notes set note_text = 'Customer asked to be ignored'
       where id = '17300000-0000-0000-0000-0000000000e2'$$,
     '42501', null, 'CUST-15: an employee cannot rewrite the owner''s note');
   select throws_ok(
     $$update public.customer_notes set note_text = '   '
       where id = '17300000-0000-0000-0000-0000000000e2'$$,
     '42501', null, 'CUST-15: an employee cannot blank the owner''s note');
   select lives_ok(
     $$update public.customer_notes set is_pinned = true, created_at = '2019-01-01'
       where id = '17300000-0000-0000-0000-0000000000e2'$$,
     'an employee may still pin the owner''s note');

   create temp table rpc_note on commit drop as
   select app.add_customer_note('17300000-0000-0000-0000-0000000000d2', '  Visa renewed  ') as id;
   select is(
     (select note_text from public.customer_notes where id = (select id from rpc_note)),
     'Visa renewed', 'the RPC still adds its trimmed note');

   reset role;
   select is(
     (select customer_id::text || ':' || note_text || ':' || created_by::text || ':' || is_pinned::text
      from public.customer_notes where id = '17300000-0000-0000-0000-0000000000e2'),
     '17300000-0000-0000-0000-0000000000d1:Prefers morning calls:17300000-0000-0000-0000-000000000012:true',
     'CUST-15: the owner''s note keeps its customer, its text and its author; only the pin changed');
   select is(
     (select created_at = now() from public.customer_notes where id = '17300000-0000-0000-0000-0000000000e2'),
     true, 'CUST-15: a note''s created_at is kept on update');

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is dc3de264a29203d9484d2a7cd420014e49807a97.

3. Check whether `supabase/tests/174_a_holiday_is_written_only_by_a_tenant_settings_holder_test.sql` contains `plan(11)`; if so record Already Applied when its Git blob is dde6e68f92a1e1c1b90a8962669f284005e87eb9, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 174, 11 assertions), and change nothing else:

   ```text
   -- pgTAP: Batch 6 slice 54 (holidays) --
   -- a holiday is written only by a tenant settings holder, in its own tenant (no migration: the
   -- door held when probed, so this file pins it).
   -- ATTACK-CLASSES: AUTH TENANT DOOR STATE=N/A INPUT=N/A CONCURRENCY=N/A REPLAY=N/A PRIVILEGE BUSINESS=N/A OBSERVABILITY=N/A
   --   STATE=N/A -- a holiday has no lifecycle: no status and no archive.
   --   INPUT=N/A -- a blank name and a second holiday on the same date are recorded positions: no
   --     function, policy or view reads holidays, so neither changes what any reader decides.
   --   CONCURRENCY, REPLAY=N/A -- each holiday is its own row; adding one twice is two rows, and
   --     nothing reads them.
   --   BUSINESS=N/A -- a holiday carries no money.
   --   OBSERVABILITY=N/A -- holidays record no event on any door; a recorded position (tenant settings
   --     that nothing reads).
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(11);

   insert into auth.users (id, email) values
     ('17400000-0000-0000-0000-0000000000a1','employee@c174.test'),
     ('17400000-0000-0000-0000-0000000000a2','owner@c174.test'),
     ('17400000-0000-0000-0000-0000000000a3','manager@c174.test'),
     ('17400000-0000-0000-0000-0000000000a4','other@c174.test');
   insert into public.tenants (id, name, slug, status) values
     ('17400000-0000-0000-0000-000000000001','Holiday Travel','holiday-travel-174','active'),
     ('17400000-0000-0000-0000-000000000002','Other Travel','other-travel-174','active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select v.t, sp.id, 'active' from public.subscription_plans sp,
     (values ('17400000-0000-0000-0000-000000000001'::uuid), ('17400000-0000-0000-0000-000000000002')) v(t)
   where sp.plan_code = 'enterprise';
   insert into public.branches (id, tenant_id, name, slug) values
     ('17400000-0000-0000-0000-00000000000a','17400000-0000-0000-0000-000000000001','Giza','giza-174');
   insert into public.departments (id, tenant_id, branch_id, department_type_code, name) values
     ('17400000-0000-0000-0000-0000000000c1','17400000-0000-0000-0000-000000000001','17400000-0000-0000-0000-00000000000a','sales','Giza Sales');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
     ('17400000-0000-0000-0000-000000000011','17400000-0000-0000-0000-000000000001','Employee','employee@c174.test',true,'17400000-0000-0000-0000-0000000000a1'),
     ('17400000-0000-0000-0000-000000000012','17400000-0000-0000-0000-000000000001','Owner','owner@c174.test',true,'17400000-0000-0000-0000-0000000000a2'),
     ('17400000-0000-0000-0000-000000000013','17400000-0000-0000-0000-000000000001','Manager','manager@c174.test',true,'17400000-0000-0000-0000-0000000000a3'),
     ('17400000-0000-0000-0000-000000000014','17400000-0000-0000-0000-000000000002','Other','other@c174.test',true,'17400000-0000-0000-0000-0000000000a4');
   insert into public.user_branch_assignments (tenant_id, user_id, branch_id, department_id, is_primary) values
     ('17400000-0000-0000-0000-000000000001','17400000-0000-0000-0000-000000000011','17400000-0000-0000-0000-00000000000a','17400000-0000-0000-0000-0000000000c1',true),
     ('17400000-0000-0000-0000-000000000001','17400000-0000-0000-0000-000000000013','17400000-0000-0000-0000-00000000000a','17400000-0000-0000-0000-0000000000c1',true);
   insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type)
   select v.t, v.u, r.id, 'tenant'
   from (values
     ('17400000-0000-0000-0000-000000000001'::uuid, '17400000-0000-0000-0000-000000000011'::uuid, 'employee'),
     ('17400000-0000-0000-0000-000000000001', '17400000-0000-0000-0000-000000000012', 'owner'),
     ('17400000-0000-0000-0000-000000000001', '17400000-0000-0000-0000-000000000013', 'branch_manager'),
     ('17400000-0000-0000-0000-000000000002', '17400000-0000-0000-0000-000000000014', 'owner')) v(t, u, c)
   join public.roles r on r.code = v.c;

   select is(
     (select string_agg(p || '=' || has_table_privilege('authenticated', 'public.holidays', p), ' ' order by p)
      from unnest(array['DELETE', 'INSERT', 'SELECT', 'UPDATE']) p),
     'DELETE=false INSERT=true SELECT=true UPDATE=true', 'the grants are unchanged: a holiday is added and edited, never deleted');

   set local role authenticated;
   select set_config('request.jwt.claims', '{"sub":"17400000-0000-0000-0000-0000000000a2","aal":"aal2"}', true);
   select lives_ok(
     $$insert into public.holidays (id, tenant_id, name, holiday_date) values
       ('17400000-0000-0000-0000-0000000000e1','17400000-0000-0000-0000-000000000001','New Year','2026-01-01')$$,
     'the owner at aal2 adds a tenant-wide holiday');
   select lives_ok(
     $$insert into public.holidays (tenant_id, branch_id, name, holiday_date) values
       ('17400000-0000-0000-0000-000000000001','17400000-0000-0000-0000-00000000000a','Giza Day','2026-05-01')$$,
     'the owner at aal2 adds a branch holiday');
   select throws_ok(
     $$delete from public.holidays where id = '17400000-0000-0000-0000-0000000000e1'$$,
     '42501', null, 'not even the owner at aal2 deletes a holiday');

   select set_config('request.jwt.claims', '{"sub":"17400000-0000-0000-0000-0000000000a2","aal":"aal1"}', true);
   select throws_ok(
     $$insert into public.holidays (tenant_id, name, holiday_date) values
       ('17400000-0000-0000-0000-000000000001','Eid','2026-03-20')$$,
     '42501', null, 'the owner at aal1 is refused: a tenant setting needs the second factor');

   select set_config('request.jwt.claims', '{"sub":"17400000-0000-0000-0000-0000000000a1","aal":"aal1"}', true);
   select is(
     (select count(*)::int from public.holidays where tenant_id = '17400000-0000-0000-0000-000000000001'),
     2, 'an employee reads the tenant''s holidays');
   select throws_ok(
     $$insert into public.holidays (tenant_id, name, holiday_date) values
       ('17400000-0000-0000-0000-000000000001','Day off','2026-04-01')$$,
     '42501', null, 'an employee cannot add a holiday');
   select throws_ok(
     $$update public.holidays set holiday_date = '2026-01-02' where id = '17400000-0000-0000-0000-0000000000e1'$$,
     '42501', null, 'an employee cannot move a holiday');

   select set_config('request.jwt.claims', '{"sub":"17400000-0000-0000-0000-0000000000a3","aal":"aal2"}', true);
   select throws_ok(
     $$insert into public.holidays (tenant_id, branch_id, name, holiday_date) values
       ('17400000-0000-0000-0000-000000000001','17400000-0000-0000-0000-00000000000a','Branch day','2026-04-01')$$,
     '42501', null, 'a branch manager cannot add even their own branch''s holiday');

   select set_config('request.jwt.claims', '{"sub":"17400000-0000-0000-0000-0000000000a4","aal":"aal2"}', true);
   select is(
     (select count(*)::int from public.holidays where tenant_id = '17400000-0000-0000-0000-000000000001'),
     0, 'another tenant''s owner sees none of the tenant''s holidays');
   select throws_ok(
     $$insert into public.holidays (tenant_id, name, holiday_date) values
       ('17400000-0000-0000-0000-000000000001','Other day','2026-04-01')$$,
     '42501', null, 'another tenant''s owner cannot add a holiday for the tenant');

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is dde6e68f92a1e1c1b90a8962669f284005e87eb9.

4. Check whether `reports/master/MASTER_GAP_REGISTER.md` contains `| CUST-15 |`; if so record Already Applied when its Git blob is 3e2005259be268aca9ed0849c3c78a98f28e5068, and otherwise stop and report. Otherwise make exactly these 2 edits (the Slice 54 freshness entry and two new rows), each matched once, and change nothing else:

   a) replace the line
   ```text
   Last updated: 2026-11-15 (**Slice 53 — `conversation_messages`, `customer_identity_signals` and `offline_conversion_deliveries` selected live at Exposure 5, coverage 24, 24 and 34, in one contract (P1's grouping, 2026-11-15).** **CUST-13** and **CUST-14** (Medium) and **CHAT-3** and **CHAT-4** (Low) are new and fixed. A customer identity signal was rewritten, moved or retyped at the table door unrecorded, and a signal added there was stored as typed, so the duplicate check misread or missed it; a message inserted at the table door was not recorded, did not move its conversation, and kept caller-supplied times and a blank text. SPEC-312 (the twin of CRM SPEC-309) normalizes every signal on every door and makes signals un-rewritable by any client, and derives and records every signed-in message on every door. `offline_conversion_deliveries` was audited with no finding. No other row changed.)
   ```
   with
   ```text
   Last updated: 2026-11-16 (**Slice 54 — `customer_notes`, `notifications` and `holidays` selected live at Exposure 5, 5 and 4, coverage 38, 64 and 8, in one contract (P1's grouping, 2026-11-16).** **CUST-15** (Medium) and **CUST-16** (Low) are new and fixed. A customer note was rewritten, blanked, moved to another customer or back-dated at the table door by someone other than its author, unrecorded and still naming that author, and a blank note was accepted there. SPEC-313 (the twin of CRM SPEC-310) keeps every note with its customer and its text with its author, and trims and requires the text on every door. `notifications` and `holidays` were audited with no finding. No other row changed.)

   Previously: 2026-11-15 (**Slice 53 — `conversation_messages`, `customer_identity_signals` and `offline_conversion_deliveries` selected live at Exposure 5, coverage 24, 24 and 34, in one contract (P1's grouping, 2026-11-15).** **CUST-13** and **CUST-14** (Medium) and **CHAT-3** and **CHAT-4** (Low) are new and fixed. A customer identity signal was rewritten, moved or retyped at the table door unrecorded, and a signal added there was stored as typed, so the duplicate check misread or missed it; a message inserted at the table door was not recorded, did not move its conversation, and kept caller-supplied times and a blank text. SPEC-312 (the twin of CRM SPEC-309) normalizes every signal on every door and makes signals un-rewritable by any client, and derives and records every signed-in message on every door. `offline_conversion_deliveries` was audited with no finding. No other row changed.)
   ```

   b) immediately after the line
   ```text
   | CHAT-4 | **A message inserted at the table door kept caller-supplied sent and received times and a blank text** | CRM conversations · integrity | Low | R | 6 | M | ✅ | **✅ FIXED 2026-11-15 (SPEC-312, `20261115180000`), DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-312; the fresh Founder ledger, functions and structure equal local.** **MEASURED** in CRM at `d38eb19` (CRM SPEC-309), and identical at `8e544c6` here (the same migrations and tests blob for blob, and the same pre-change structure): the same employee inserted one outbound message with `sent_at` in 2019 and `received_at` in 2099, and both were kept; another kept a blank text and no time at all. The RPC derives both times from the clock by direction and stores a blank text as none. Severity is Low, re-measured in CRM at `d38eb19` (CRM SPEC-309), and identical at `8e544c6` here (the same migrations and tests blob for blob, and the same pre-change structure): no function reads `sent_at` or `received_at` (`pg_proc` and the migrations); `app.forbid_message_rewrite` only freezes them. **Repaired:** the signed-in INSERT arm of `app.derive_message_sender`, which already derives the sender (ATTR-4, `202607057000`), now derives `sent_at`, `received_at` and a blank text exactly as `app.send_conversation_message` does; a session-less insert (a provider integration replaying a message it received earlier) keeps its own times, as it keeps its own sender. `app.emit_conversation_message` (AFTER INSERT, SECURITY DEFINER, empty `search_path`, executable by no client role) is the single producer of the conversation's move and of `conversation_message_sent` or `conversation_message_received`, with the actor, the message id and its direction, on every door; the RPC no longer does either itself, so it records once. `171_a_conversation_message_is_timed_and_recorded_on_every_door_test.sql` pins both. | — | SPEC-312-a-conversation-message-is-timed-and-recorded-and-an-identity-signal-is-normalized-and-never-rewritten | 11-15 | 11-15 |
   ```
   insert
   ```text
   | CUST-15 | **A customer note was rewritten, blanked, moved to another customer or back-dated by someone other than its author, unrecorded, and still named its author** | CRM customers · integrity · attribution | Medium | R | 6 | M | 🛡 | **FIXED 2026-11-16 locally (SPEC-313, `20261116120000`); Founder Secondary deployment pending.** **MEASURED** in CRM at `1a760bb` (CRM SPEC-310), and identical at `f4a797c` here (the same migrations and tests blob for blob, and the same pre-change structure): an `employee` holding CREATE_CUSTOMER, at `aal1` as that role allows, rewrote the `owner`'s note on a customer, blanked it, moved it to a second customer and back-dated its `created_at` to 2019, each by UPDATE at the table door; another employee rewrote the first one's note. Each note still named its original author (`app.derive_created_by` keeps `created_by`), and nothing was recorded: the tenant's events did not move. `app.add_customer_note` only ever inserts a note and no function rewrites one, yet `authenticated` held table-level UPDATE (pin, confidential and archive are column updates the product needs) and the table had no rewrite guard. Severity is Medium by CUST-13's precedent: an unrecorded rewrite of what a named person wrote about a customer, which the next reader trusts under that name. **Repaired:** one BEFORE INSERT OR UPDATE trigger, `app.guard_customer_note_integrity` (SECURITY INVOKER, empty `search_path`, in `app.guard_quotation_integrity`'s shape; the definer paths owned by `postgres`, the merge among them, pass through). The text is trimmed as `app.add_customer_note` trims it, so a blank note is refused by the existing NOT NULL; a note keeps its customer (23514); only its author may change its text (42501), so the name on a note is the name of the person who wrote what it says; and `created_at` is kept on UPDATE, as `app.derive_created_by` keeps `created_by`. Every grant and policy is unchanged: pinning, marking one's own note confidential and archiving stay open to whoever could do them before. `173_a_customer_note_stays_with_its_customer_and_its_author_test.sql` pins it. | — | SPEC-313-a-customer-note-stays-with-its-customer-and-its-author | 11-16 | 11-16 |
   | CUST-16 | **A blank customer note was accepted at the table door, which the RPC refuses** | CRM customers · data integrity | Low | R | 6 | M | 🛡 | **FIXED 2026-11-16 locally (SPEC-313, `20261116120000`); Founder Secondary deployment pending.** **MEASURED** in CRM at `1a760bb` (CRM SPEC-310), and identical at `f4a797c` here (the same migrations and tests blob for blob, and the same pre-change structure): the same employee inserted a note of three spaces at the table door and it was stored, while `app.add_customer_note` trims the text and refuses an empty one. Severity is Low by CHAT-4's precedent: a blank text at a direct door; no function reads a note's text. **Repaired:** one BEFORE INSERT OR UPDATE trigger, `app.guard_customer_note_integrity` (SECURITY INVOKER, empty `search_path`, in `app.guard_quotation_integrity`'s shape; the definer paths owned by `postgres`, the merge among them, pass through). The text is trimmed as `app.add_customer_note` trims it, so a blank note is refused by the existing NOT NULL; a note keeps its customer (23514); only its author may change its text (42501), so the name on a note is the name of the person who wrote what it says; and `created_at` is kept on UPDATE, as `app.derive_created_by` keeps `created_by`. Every grant and policy is unchanged: pinning, marking one's own note confidential and archiving stay open to whoever could do them before. `173_a_customer_note_stays_with_its_customer_and_its_author_test.sql` pins it. | — | SPEC-313-a-customer-note-stays-with-its-customer-and-its-author | 11-16 | 11-16 |
   ```

   The resulting file's Git blob is 3e2005259be268aca9ed0849c3c78a98f28e5068.

5. Check whether `reports/master/MASTER_SURFACE_DISPOSITION.md` contains `**63 of 78 recorded · 39 `; if so record Already Applied when its Git blob is 6e77fb0acdcd4a4519d54b7d51b8810d91478cba, and otherwise stop and report. Otherwise make exactly these 6 edits (the freshness entry, coverage 63 of 78 and the three surface rows), each matched once, and change nothing else:

   a) replace the line
   ```text
   Last updated: 2026-11-15 (**slice 53 — `conversation_messages`, `customer_identity_signals` and `offline_conversion_deliveries` selected by Exposure 5, coverage 24, 24 and 34, in one contract.** Coverage **57 → 60 of 78**. CHAT-3 and CHAT-4: a message inserted at the table door was not recorded, did not move its conversation, and kept caller-supplied times and a blank text. CUST-13 and CUST-14: a signal was rewritten in place unrecorded, and a signal added at the door was stored as typed, so the duplicate check misread or missed it. SPEC-312 (the twin of CRM SPEC-309) closes all of them here; `offline_conversion_deliveries` holds with no finding, so the three rows are `AUDITED`.)
   ```
   with
   ```text
   Last updated: 2026-11-16 (**slice 54 — `customer_notes`, `notifications` and `holidays` selected by Exposure 5, 5 and 4, coverage 38, 64 and 8, in one contract.** Coverage **60 → 63 of 78**. CUST-15 and CUST-16: a customer note was rewritten, blanked, moved to another customer or back-dated at the table door by someone other than its author, unrecorded, and a blank note was accepted there. SPEC-313 (the twin of CRM SPEC-310) closes both here; `notifications` and `holidays` hold with no finding, so the three rows are `AUDITED`.)

   Previously: 2026-11-15 (**slice 53 — `conversation_messages`, `customer_identity_signals` and `offline_conversion_deliveries` selected by Exposure 5, coverage 24, 24 and 34, in one contract.** Coverage **57 → 60 of 78**. CHAT-3 and CHAT-4: a message inserted at the table door was not recorded, did not move its conversation, and kept caller-supplied times and a blank text. CUST-13 and CUST-14: a signal was rewritten in place unrecorded, and a signal added at the door was stored as typed, so the duplicate check misread or missed it. SPEC-312 (the twin of CRM SPEC-309) closes all of them here; `offline_conversion_deliveries` holds with no finding, so the three rows are `AUDITED`.)
   ```

   b) replace the line
   ```text
   **60 of 78 recorded · 36 `AUDITED` · 21 `AUDITED-OPEN` · 3 `PARTIAL` · 0 `EXEMPT` · 18 `NOT-RECORDED`.**
   ```
   with
   ```text
   **63 of 78 recorded · 39 `AUDITED` · 21 `AUDITED-OPEN` · 3 `PARTIAL` · 0 `EXEMPT` · 15 `NOT-RECORDED`.**
   ```

   c) replace the line
   ```text
   **All 60 recorded surfaces stand at `ADVERSARIAL`, and Check 24 (ADV-1) is what makes that word cost something**: a surface may not carry it unless a pgTAP file names it, declares which attack classes it aimed at (`-- ATTACK-CLASSES:`, closed vocabulary), and carries at least one negative assertion. A file of positive controls earns `TESTED` and no more.
   ```
   with
   ```text
   **All 63 recorded surfaces stand at `ADVERSARIAL`, and Check 24 (ADV-1) is what makes that word cost something**: a surface may not carry it unless a pgTAP file names it, declares which attack classes it aimed at (`-- ATTACK-CLASSES:`, closed vocabulary), and carries at least one negative assertion. A file of positive controls earns `TESTED` and no more.
   ```

   d) replace the line
   ```text
   | `customer_notes` | NOT-RECORDED | — | — | — | — |
   ```
   with
   ```text
   | `customer_notes` | **AUDITED** | ADVERSARIAL | `SPEC-313-a-customer-note-stays-with-its-customer-and-its-author` | CUST-15, CUST-16 | `173_a_customer_note_stays_with_its_customer_and_its_author_test.sql` (14 assertions; DOOR, INPUT and PRIVILEGE declared, the rest N/A) proves that the guard is installed and the grants are unchanged; that a note added at the table door has its text trimmed and a blank one is refused, as through the RPC; that the author may still correct their own note; that a note cannot be moved to another customer, even by its author; that an employee cannot rewrite or blank the `owner`'s note but may still pin it; that `created_at` is kept on update; and that `app.add_customer_note` still adds its trimmed note. Tests 10, 19, 53, 58, 67, 71, 85, 111, 142 and 144 pass unchanged, and test 71 (the merge) catches a guard that does not pass `postgres` through. **Swept and classified as non-defects:** the author is derived, never named; a confidential note is invisible to others and only its author may mark it (`scope_isolation`); no DELETE grant (an employee and an `owner` at `aal2`); archiving needs ARCHIVE_RECORD, so an employee is refused; a role without CREATE_CUSTOMER is refused on both doors; another tenant reads no note and cannot add one; anonymous REST is refused (401) and does not reach the RPC (404). **Recorded positions:** `created_at` is caller-supplied on INSERT (SPEC-216's schema-wide question); an archived note may be inserted at the door; archiving a note also needs CREATE_CUSTOMER, so a `finance_manager` holding ARCHIVE_RECORD is refused; notes record no event on any door, the RPC's included; pinning stays open to every writer in scope. 0 hosted notes. |
   ```

   e) replace the line
   ```text
   | `holidays` | NOT-RECORDED | — | — | — | — |
   ```
   with
   ```text
   | `holidays` | **AUDITED** | ADVERSARIAL | `SPEC-313-a-customer-note-stays-with-its-customer-and-its-author` | — | `174_a_holiday_is_written_only_by_a_tenant_settings_holder_test.sql` (11 assertions; AUTH, TENANT, DOOR and PRIVILEGE declared, the rest N/A) pins the door as found: the grants are unchanged and no one deletes a holiday, not even the `owner` at `aal2`; the `owner` at `aal2` adds a tenant-wide and a branch holiday; the `owner` at `aal1` is refused for want of the second factor; an employee reads the holidays and cannot add or move one; a `branch_manager` cannot add even their own branch's holiday; another tenant's owner sees none and cannot add one. Tests 10 and 58 pass unchanged. **Swept and classified as non-defects:** writing needs MANAGE_BRANCHES or MANAGE_TENANT_SETTINGS (`app.guard_write_capability`) with the second factor; a branch in another tenant is refused by the foreign key; anonymous REST is refused (401). **Recorded positions:** `created_at` is caller-supplied on INSERT and rewritable on UPDATE by a settings holder; a blank name and a second holiday on the same date are accepted; holidays record no event on any door; no function, policy or view reads holidays, so none of these changes what any reader decides. No defect, so no migration; the test was added because Check 24 needs one that names the surface. 0 hosted holidays. |
   ```

   f) replace the line
   ```text
   | `notifications` | NOT-RECORDED | — | — | — | — |
   ```
   with
   ```text
   | `notifications` | **AUDITED** | ADVERSARIAL | `SPEC-313-a-customer-note-stays-with-its-customer-and-its-author` | — | Tests 136 and 158 (attack classes declared) and tests 10, 21, 36, 58, 63, 65, 66, 88, 93, 95, 98 and 100 pin the producers, the read scope and the delivery path, and all pass unchanged beside this contract, which does not touch the table. **Swept and classified as non-defects** (an employee, and an `owner` at `aal2`): `authenticated` holds SELECT and a column UPDATE of `is_read` and `read_at` only, so a title rewrite or a retarget is refused (42501) and no client role inserts or deletes a notification; another user's notification and its delivery are invisible and cannot be marked; another tenant reads none; the three writers are SECURITY DEFINER and not executable by an owner, and `app.claim_notification_deliveries` only by `orvion_integration`; anonymous REST is refused (401). **Recorded position:** the target may set `read_at` to any time or none, or leave `is_read` false with `read_at` set; no function, policy or view reads either, so neither changes what any reader decides. Platform-written rows; nothing changed, so no test was added. 0 hosted notifications. | |
   ```

   The resulting file's Git blob is 6e77fb0acdcd4a4519d54b7d51b8810d91478cba.

6. **Check** for a `Pre-deploy readiness gate` Execution Log entry. If absent, with Steps 1–5 applied and uncommitted in the main checkout, record, with actual values:
   - the SHA-256, md5 and byte counts of the migration and tests 173 and 174, which must equal Consumer Closure, and the Git blobs of the three `supabase/` files, which must equal CRM SPEC-310's;
   - the identity: `supabase/migrations` and `supabase/tests` at the baseline equal CRM's at `1a760bb` (trees `24e1e7c8574f12ebc81d0383a940160b1770d664` and `40a7df0f5cfd2efe80d272f5bc898ca936e2d446`), and the `supabase/` paths changed equal those CRM SPEC-310 changed, so CRM SPEC-310's prototype results (the three functions' shape, the triggers, tests 173 and 174 alone, the probes, the ten mutants, the causal negative and the structural fingerprints before and after) hold here; they are cited, not re-run;
   - after a clean reset of the local stack by this repository's CLI, the API-contract generator, whose output must equal both the baseline contract and `MASTER_API_CONTRACT.md` (0 rows differing); the map generator, the scope check and `git diff --check`.

   Treat as expected at this boundary only: an undeployed Founder Secondary and the measured-state items of Consumer Closure.

   Then read a fresh Founder Secondary baseline through the Founder connector, read-only:
   - the project URL, the full ordered ledger and the absence of the target migration;
   - the function, grant and structural surfaces, which must equal CRM Primary's before SPEC-310 (`_combined` `88c35cab62c01ed7433d57402c8ee72c`/3175);
   - the triggers of the three tables and the three functions' `md5(prosrc)`;
   - the tenant, customer, note, notification, holiday and event counts.

   Record the predicted delta. If any reading differs, stop.
7. **Check** that an exact-SHA Gate-2 record for the migration is in the Execution Log. It is either the owner's own, or one marked DELEGATED that names this contract, the migration's SHA-256, Founder Secondary `brplkqmbzffpxqgkkdzo` and the owner's instructions under which it is taken. If it is absent, write it only when Step 6 passed and those instructions cover a migration that drops no table or column and deletes or rewrites no business row. Otherwise stop after Step 6 and present the Gate-2 package.
8. **Check** whether Founder Secondary `brplkqmbzffpxqgkkdzo` lacks `20261116120000_a_customer_note_stays_with_its_customer_and_its_author`. If it does and Step 7 is recorded, deploy it in one sitting:
   - Immediately re-read HEAD, the hashes, the project URL, the full ordered ledger, the target's absence, the business counts and the triggers of the three tables.
   - On an exact match, prove the transmitted text's md5 server-side, then apply only that migration through the Founder write connector `supabase-secondary-write`, after its `get_project_url` names `brplkqmbzffpxqgkkdzo`.
   - If the connector assigns a temporary version, rename only that one newly inserted ledger row. The rename requires exactly one new row, its stored statement md5 equal to the file's, and no existing target version.

   Then read fresh through the Founder connector: the ledger, the function surface and all ten structural surfaces, with the exact `read_query` recorded in `reports/evidence/founder-ledger-evidence.json`; the triggers of the three tables; the three functions' `md5(prosrc)`, security mode and ACL; and the business counts. Never contact Primary `vrvtsxexkiiiivlkdxzp`.
9. **Check** that fresh Founder evidence contains the new migration exactly once. If so:
   - Update `reports/evidence/founder-ledger-evidence.json` (schema 3) from those readings only: `read_at`, `read_via`, the unchanged `read_query`, `repository_head` (the HEAD at the read), the full ledger, its count and fingerprint, both surface hashes and counts, and `surface_rows`. `scripts/check_primary_ledger.ps1` and `scripts/check_database_parity_evidence.ps1` must then pass.
   - In `_ORVION_CANONICAL/manifest.md`, set `Live state` from the same readings in its existing form (migration count, latest, ledger, and the two surface hashes and counts), with **80 client RPCs** unchanged.
   - Confirm that `supabase/tests` holds 174 files whose literal `plan(N)` values sum to 3218, then set `Suite **174 files / 3218 assertions**`. If either differs, stop.
   - In the register, replace each `` | 🛡 | **FIXED 2026-11-16 locally (SPEC-313, `20261116120000`); Founder Secondary deployment pending.** `` with `` | ✅ | **✅ FIXED 2026-11-16 (SPEC-313, `20261116120000`), DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-313; the fresh Founder ledger, functions and structure equal local.** ``, for the two rows CUST-15 and CUST-16. Each span's one leading and one trailing space are delimiters, not text. Change nothing else in the register.
   - Regenerate `MASTER_API_CONTRACT.md` with the canonical generator, which must leave it unchanged, and regenerate `ai-map.json` and `repository-index.md` (stored LF) with the canonical generator.
   - Set the Runtime Checkpoint to DONE, append the Execution Log, and commit the implementation once. The pre-commit Gate must admit it.

   If Founder Secondary is unproven, stop.
10. **Check** for a `Post-deploy local certification` Execution Log entry. If absent:
    - Run canonical `-Finish` through `scripts/run_timed.ps1`, watched by `scripts/watch_run.ps1`, and require `LOCAL_CERTIFY: READY`.
    - Independently Review the committed implementation against every Acceptance Criterion. After `Verdict: Confirmed Complete`, make the Complete commit:
      - transition to Complete and tick the Acceptance Criteria and the Review Gate;
      - clear `Active Change Request` and set `Last Completed` from Notes;
      - leave `Next capability` and `Current Module` unchanged;
      - regenerate `ai-map.json` and `repository-index.md` LF.
    - Bind the exact candidate with `-Gate -BindCandidate`. Publication and promotion follow the native release path separately.

## Acceptance Criteria

- [x] The note migration is the frozen bytes; `check: blob supabase/migrations/20261116120000_a_customer_note_stays_with_its_customer_and_its_author.sql 5e1697af620f5a7a8bdfc9aba8e297eed763e5aa`
- [x] Test 173 is the frozen bytes; `check: blob supabase/tests/173_a_customer_note_stays_with_its_customer_and_its_author_test.sql dc3de264a29203d9484d2a7cd420014e49807a97`
- [x] Test 174 is the frozen bytes; `check: blob supabase/tests/174_a_holiday_is_written_only_by_a_tenant_settings_holder_test.sql dde6e68f92a1e1c1b90a8962669f284005e87eb9`
- [x] The disposition record carries the three surfaces AUDITED / ADVERSARIAL and coverage 63 of 78; `check: blob reports/master/MASTER_SURFACE_DISPOSITION.md 6e77fb0acdcd4a4519d54b7d51b8810d91478cba`
- [x] The two register rows are fixed and deployed; `check: has reports/master/MASTER_GAP_REGISTER.md "DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-313"`
- [x] The manifest suite figure equals the files; `check: has _ORVION_CANONICAL/manifest.md "Suite **174 files / 3218 assertions**"`
- [x] Native evaluator remains exact; `check: same scripts/check_agent_continuity.ps1 @f4a797c4fbb0ba62b95766984638df16d82cc2d9`
- [x] The note RPC's origin migration remains exact; `check: same supabase/migrations/202607051100_master_data_write_paths.sql @f4a797c4fbb0ba62b95766984638df16d82cc2d9`
- [x] The smoke catalog count remains exact; `check: same scripts/verify_database.sql @f4a797c4fbb0ba62b95766984638df16d82cc2d9`
- [x] Founder Secondary `brplkqmbzffpxqgkkdzo` received only the one authorized migration, with at most one guarded ledger rename and no business-data write, after a recorded Step 6 readiness gate and Step 7 Gate-2 record. Primary `vrvtsxexkiiiivlkdxzp` was never contacted.
- [x] The identity with CRM SPEC-310 is proven (payload blobs, migrations and tests trees, Founder Secondary's pre-change structure), so its ten mutants, each killed with installation proven and the restored shape read, its causal negative and its probes, before and after, hold here.

## Execution Log

### 2026-11-16 — Steps 1–5 applied

- **Lifecycle:** allocate `7380b19`, Approve `ac7581a` (APPROVAL_EVIDENCE PASS; 9 of 11 criteria Gate-checked), DELEGATED Gate 1 recorded in Verification Notes.
- **Steps 1–5** by the literal-step replay, each result at its pinned blob: migration `5e1697af620f5a7a8bdfc9aba8e297eed763e5aa`; tests 173 `dc3de264a29203d9484d2a7cd420014e49807a97` and 174 `dde6e68f92a1e1c1b90a8962669f284005e87eb9` (CRM SPEC-310's committed blobs); register `3e2005259be268aca9ed0849c3c78a98f28e5068`; disposition `6e77fb0acdcd4a4519d54b7d51b8810d91478cba`; 0 mismatches. Uncommitted until Step 9: the pre-commit guard refuses the measured-state items before the deploy.

### 2026-11-16 — Pre-deploy readiness gate (Step 6)

From the main checkout at HEAD `ac7581a`, Steps 1–5 applied and uncommitted, project-local CLI 3.0.0, the local stack recreated by the rig, one logged script (22:41–22:42 Cairo):
- **Bytes**, all LF (0 CR) and ASCII, equal to Consumer Closure: migration `20261116120000` SHA-256 `a04fef90c91164ac430238fb840859e079be2ee40bde80df6c70051aa141c198`, md5 `1238bbbbd4522cd5cf384689c97caefa`, 3512 bytes; test 173 SHA-256 `6c0abdbb4cb4387a158bd477a753a6d4b1f91f00f9d350d7725ac6bdf8ef1ac0`, md5 `628e58db9fa9d69c111fcac633d7b28b`, 6962 bytes; 174 SHA-256 `82ba68e6753ad83416d33265ff36e7a61f87c38038c0593c6d0fb79884d56c85`, md5 `0c56e221262559e16b32f3142d215cef`, 7059 bytes.
- **Identity with CRM SPEC-310** (implementation `a492b46` in CRM): the three `supabase/` files' Git blobs equal CRM's; at the baseline, `supabase/migrations` (`24e1e7c8`), `supabase/tests` (`40a7df0f`), `scripts/verify_database.sql` (`1584d5e3`) and `MASTER_API_CONTRACT.md` (`f426c1a5`) equal CRM's at `1a760bb`; the same three `supabase/` paths changed here as in CRM SPEC-310; the disposition's 78 surface statuses equal CRM's. CRM SPEC-310's Step 6 results on these bytes are therefore cited, not re-run: the guard's shape and its trigger, the two existing functions unchanged, tests 173 14/14 and 174 11/11, the probes before and after, ten mutants killed with the restored shapes equal, the causal negative, parity 267 `88c35cab…`/3175 → 268 `22978d05…`/3177.
- **Local stack** after a clean reset by this repository's CLI (exit 0, 32 s; read 20:48:10 UTC, `runtime/original-local-parity.txt`): ledger 268 `b19e6f48e19b3b51ccdae01d26186fef`, latest `20261116120000`; `md5(prosrc)` `app.guard_customer_note_integrity` `e47fbc463245d57861dddd99f93e1517` (INVOKER, `{postgres=X/postgres}`), `app.add_customer_note` `0b06bc5fe2da28f58b0292ab07676078`, `app.derive_created_by` `61eb85f1adc40eff12e502fdac344969`, `public.add_customer_note` `c1212f387fbcdfe7dc4692d17a8f2452`; the 12 triggers of the three tables with `customer_notes_guard_note_integrity`; catalog 71/626; `parity_surface.sql` functions `80f02f416e552e5ecd43d053ae6c1478`/350, triggers `764c62c6b405673cfea362c053bb9315`/337, the other eight surfaces unchanged, `_combined` `22978d051e6586ecd1772b144993b6b8`/3177, equal to CRM's local stack after SPEC-310.
- **Generators, scope and diff.** The API-contract generator's output is identical to `MASTER_API_CONTRACT.md`, to the baseline (270 lines, 0 rows differ) and to CRM SPEC-310's committed contract; `generate-ai-map.ps1 -Check` exit 0. Only the five Step 1–5 paths changed; `git diff --check` clean.
- **Consistency:** exactly the six expected pre-deploy items, the same as the sandbox: 267 vs 268 migrations, latest, ledger fingerprint, 172 vs 174 files, 3193 vs 3218 assertions, RECOVER-1 (Founder evidence).
- **Fresh Founder Secondary baseline**, read-only (20:18:34 UTC by the server clock, through the Founder write connector inside `BEGIN TRANSACTION READ ONLY`): URL `https://brplkqmbzffpxqgkkdzo.supabase.co`; ledger 267 `8be9389fce4d3f330674d2ed083278ca`, latest `20261115180100`, the target absent by version and by name; `public.add_customer_note` `c1212f387fbcdfe7dc4692d17a8f2452`, `app.add_customer_note` `d194a2e267ba147638bfd46fd77042f2` (the stored text differs from the local copy and from CRM Primary's only in comments and line endings; the whitespace-normalized function surface is equal), `app.derive_created_by` `61eb85f1adc40eff12e502fdac344969`, each with the local security mode and ACL; no guard; the 11 triggers of the three tables; catalog 71/626; 0 tenants, customers, notes, notifications, holidays and events. `parity_surface.sql`: functions `b13e66125d5ea63134310305faf3ee7e`/349, triggers `246b4ca76492cd46629f538f2ed1b108`/336, grants `5cfb09c3344a26c5513989ef3c358ff1`/188, `_combined` `88c35cab62c01ed7433d57402c8ee72c`/3175, every surface equal to CRM Primary's before SPEC-310 and to the recorded evidence.
- **Predicted delta:** ledger 268 `b19e6f48…`; functions `80f02f41…`/350; triggers `764c62c6…`/337; `_combined` `22978d05…`/3177; the guard `e47fbc46…` and its trigger; the three existing functions unchanged on Founder Secondary; catalog 71/626 unchanged; business counts unchanged.

### 2026-11-16 — Gate 2 (Step 7), DELEGATED

DELEGATED exact-SHA Gate-2 record for SPEC-313, to Founder Secondary `brplkqmbzffpxqgkkdzo` only, in one sitting: `supabase/migrations/20261116120000_a_customer_note_stays_with_its_customer_and_its_author.sql`, SHA-256 `a04fef90c91164ac430238fb840859e079be2ee40bde80df6c70051aa141c198`, md5 `1238bbbbd4522cd5cf384689c97caefa`, 3512 bytes; under the owner's instructions of 2026-11-08 (class authorization for Batch 6 releases and standing approval of proposals ~10:20 Cairo; publish, promote and hosted deploy ~12:05 Cairo), 2026-11-11 (Batch 6 decisions 1-9 ~19:50 Cairo, decision 8 the twin lane), 2026-11-12 (priority order waiving no gate ~12:20 Cairo), 2026-11-14 (one contract per product ~11:30 Cairo; no credential rotation ~12:30 Cairo; BP-32's one-sitting deploy approved in principle ~16:20 Cairo) and 2026-11-16 (slice 12 runs through in run mode 2 ~17:05 Cairo, whose Lane includes this ORVION twin of CRM SPEC-310), recorded outside this repository. Step 6 passed; Step 8 re-reads the Founder baseline, HEAD and the hashes immediately before the write. The migration's top-level statements are one `create or replace function`, one `revoke execute` and one `create trigger`: they drop no table or column and delete or rewrite no business row. Not a human-typed digest. Primary `vrvtsxexkiiiivlkdxzp` is not a target.

### 2026-11-16 — Founder Secondary deployment (Step 8)

To Founder Secondary `brplkqmbzffpxqgkkdzo` only, through the Founder write connector (`get_project_url` named `brplkqmbzffpxqgkkdzo`), in one sitting (22:48–22:49 Cairo). Immediately before the write a read-only re-read of the ledger (267, latest `20261115180100`, fingerprint `8be9389fce4d3f330674d2ed083278ca`, the target absent), functions, triggers, catalog and business counts, each equal to the Step 6 baseline, with the transmitted text's md5 equal to the file's (`1238bbbbd4522cd5cf384689c97caefa`); `apply_migration` with the exact LF file text; the ledger row read (one statement, the file's md5 and length); the guarded rename from the connector's timestamp `20261116204844` to the file version (row count 1). HEAD `ac7581a` and the migration hash equal Gate 2.

Fresh reads after the deploy (20:49:13 UTC): ledger 268, latest `20261116120000`, fingerprint `b19e6f48e19b3b51ccdae01d26186fef`; `public.add_customer_note` `c1212f387fbcdfe7dc4692d17a8f2452`, `app.add_customer_note` `d194a2e267ba147638bfd46fd77042f2` and `app.derive_created_by` `61eb85f1adc40eff12e502fdac344969` unchanged; `app.guard_customer_note_integrity` `e47fbc463245d57861dddd99f93e1517` (SECURITY INVOKER, `{postgres=X/postgres}`), as predicted; 12 triggers on the three tables, adding `customer_notes_guard_note_integrity`; catalog 71/626; every business count 0. `parity_surface.sql`: functions `80f02f416e552e5ecd43d053ae6c1478`/350, triggers `764c62c6b405673cfea362c053bb9315`/337, the other eight unchanged, `_combined` `22978d051e6586ecd1772b144993b6b8`/3177, equal to the predicted delta, to the local stack after a clean reset and to CRM Primary after SPEC-310. Evidence parts 20:51:21 UTC: function expression `80f02f416e552e5ecd43d053ae6c1478|350`, ledger 268 `b19e6f48e19b3b51ccdae01d26186fef`. Primary was not contacted.

### 2026-11-16 — Post-deploy records (Step 9)

- `reports/evidence/founder-ledger-evidence.json` from the Step 8 readings only (read 2026-11-16 20:51:21 UTC, window 20:49:13-20:51:21 UTC): 268 entries, fingerprint `b19e6f48e19b3b51ccdae01d26186fef` (the new ledger hashed to it before the write), functions `80f02f416e552e5ecd43d053ae6c1478`/350, triggers `764c62c6b405673cfea362c053bb9315`/337, structure `22978d051e6586ecd1772b144993b6b8`/3177, repository head `ac7581a`; `check_primary_ledger.ps1` and `check_database_parity_evidence.ps1` CLEAN.
- `_ORVION_CANONICAL/manifest.md` Live state at 268 migrations (latest `20261116120000`) with the same hashes; the client RPC figure unchanged at 80; suite 174 files / 3218 assertions, counted from the test files.
- `MASTER_GAP_REGISTER.md`: the two rows (CUST-15, CUST-16) now DEPLOYED; nothing else changed.
- `MASTER_API_CONTRACT.md` regenerated from the local stack and unchanged (80 RPCs); `ai-map.json` and `repository-index.md` regenerated byte-identical, `-Check` exit 0.
- Runtime Checkpoint DONE; Status Approved → In Progress; one implementation commit.

## Verification Notes

None.


### 2026-11-16 — Gate 1 approval recorded

DELEGATED exact Gate1 under the owner's instructions of 2026-11-08 (class authorization for Batch 6 releases and standing approval of proposals ~10:20 Cairo; publish, promote and hosted deploy ~12:05 Cairo), 2026-11-11 (Batch 6 decisions 1-9 ~19:50 Cairo, whose decision 8 is the twin lane), 2026-11-12 (priority order waiving no gate ~12:20 Cairo), 2026-11-14 (one contract per product ~11:30 Cairo; no credential rotation ~12:30 Cairo; BP-32 approved in principle ~16:20 Cairo) and 2026-11-16 (slice 12 runs through in run mode 2 ~17:05 Cairo, whose Lane includes this ORVION twin of CRM SPEC-310); Draft SHA-256 F792B51D6D09270D386791F63FFFC6743E347B33F027CCCAE6ACCDAC585B9422, decision SHA-256 15E72FE2DF3F41421436CBE4316533C9306F4BC976B7796922C04CED46E2A574. No fabricated human future-digest approval. Gate 2 (Founder Secondary deploy) is a separate exact-SHA record in Step 7. Immediately before allocation the hash, the Draft blob 1f95a640e5593e8e36425992bc722848c1d6bc8b, all 2 source anchors, the baseline HEAD f4a797c4fbb0ba62b95766984638df16d82cc2d9 against refreshed origin/main f4a797c4fbb0ba62b95766984638df16d82cc2d9 and a clean checkout were revalidated, and the pre-commit allocator admitted the identity; Draft allocated as 7380b19. No implementation performed before this transition.


Verdict: Confirmed Complete

Independent current Git evidence: selected Draft F792B51D6D09270D386791F63FFFC6743E347B33F027CCCAE6ACCDAC585B9422, allocated blob 1f95a640e5593e8e36425992bc722848c1d6bc8b, the five literal outputs (one migration and tests 173-174 byte-identical to CRM SPEC-310, register and disposition as frozen), the recorded Step 6 readiness gate with the identity proof, the DELEGATED exact-SHA Gate-2 record, the Founder Secondary deploy of only 20261116120000 to brplkqmbzffpxqgkkdzo in one sitting with the fresh post-deploy ledger, functions and structure equal to local, the Step 9 records (Founder ledger evidence, manifest Live state and the suite figure, the two register rows DEPLOYED), the API contract regenerated and unchanged, regenerated discovery, unchanged native evaluator, and declared scope verified; Primary vrvtsxexkiiiivlkdxzp was never contacted. This original root owns fresh receipt eb2f1576ddc78c5462c11a74d728fd0dfe2b4b3f5a8ee164e9326acf1e047d48, finishHead 31bd077a844cb36aee1535e5d9d11e756fa6c2db, profiles DATABASE,REPOSITORY, in a native timed/watched Finish observed READY/END0. Native Complete/range/binder still own full receipt/criterion validation. No publication or hosted result asserted.


Local original native verification and truthful Review complete. Preserve this root's receipt eb2f1576ddc78c5462c11a74d728fd0dfe2b4b3f5a8ee164e9326acf1e047d48 and selected bytes. Candidate binding follows Complete; publication/promotion remain separately governed.

## Review Gate

- [x] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [x] No file outside Write Scope was modified, created, or deleted.
- [x] No section was added, removed, or restructured outside the approved steps.
- [x] Every Acceptance Criteria item is confirmed true.
- [x] Any step that could not be resolved deterministically was reported, not guessed.
- [x] If this Change Request's Supersedes / Depends On section names another file, that file's Status has been updated accordingly.
- [x] The repository is in a clean, releasable state.

## Notes

After actual native Finish and truthful Review, synchronize only this contract and the declared manifest/discovery paths to Complete. Set `Last Completed: **SPEC-313: Batch 6 Slice 54 — a customer note stays with its customer and its author; a blank note is refused on every door (CUST-15, CUST-16), the twin of CRM SPEC-310; notifications and holidays audited, deployed to Founder Secondary; native verification and Review complete. Publication/promotion remain separately governed.**` and regenerate discovery. `Next capability` and `Current Module` stay unchanged: the selector names the next slice. Candidate binding follows Complete and is never a pre-Complete criterion.

Exact baseline f4a797c4fbb0ba62b95766984638df16d82cc2d9 and source anchors:

| Path | Baseline Git blob |
| --- | --- |
| `reports/master/MASTER_GAP_REGISTER.md` | `8955018718c25ef6b86d71343147f1a7b21eedc6` |
| `reports/master/MASTER_SURFACE_DISPOSITION.md` | `8d8f9110fc828b65d4168a52562a945da643a7f1` |

Selection sources: native AGENTS.md, CR_LIFECYCLE.md, ENGINEERING_METHOD.md and GOVERNANCE.md; SPEC-134, SPEC-214, SPEC-216, SPEC-287 and SPEC-312 at f4a797c4fbb0ba62b95766984638df16d82cc2d9; CRM SPEC-310 (the twin's origin and its adopted proof); the owner's instructions of 2026-11-08 and 2026-11-16 (recorded outside this repository). This is the one Draft for these surfaces, finalized after the adversarial review and the evidence refresh that its Draft Assurance records. Correctness remains native and independent.
