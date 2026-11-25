# Change Request — SPEC-319

## Status

[x] Draft
[ ] Approved
[ ] In Progress
[ ] Complete
[ ] Cancelled

## Objective

Batch 6 exit bundle M catches ORVION up with CRM SPEC-316 to SPEC-340 by identity: seven migrations, seventeen new tests and eleven moved tests, with the plan, register, disposition and manifest records carrying their In ORVION notes, deployed serially to Founder Secondary under one exact-SHA Gate-2 record.

## Business Reason

- **The twin, adopted by identity.** This is the Founder twin of CRM SPEC-316 to SPEC-340, whose released candidate is `15bff27b445bdddb7572e4128f9388629d959b03`.
  - ORVION baseline `367cdf3` and CRM `6b2805171792d0de15171bf812ce8bc06d33dd2d` have the same migration tree `6f298c79372affd4371ae566cac3b544d6be6104`, test tree `65912a5443eb27ee849883c1a8d2fb9ec26e1363`, smoke SQL, parity SQL and committed API contract `67d91549cfc6763ad0228456f20a37f4196bb767`.
  - After Steps 1–35 the migration tree equals CRM `483ca81c845e96e4ec2a2922637117af9bdd279b` and the test tree equals CRM `d1a4fa8dfa978dd195bae6830ffbb7814468488b`, file by file.
  - CRM's focused tests, probes, mutants and causal negatives on those bytes are adopted by identity. The Founder original runs its own native Finish.
- **What the seven migrations repair, each measured and fixed in CRM.**
  - `20261119054533` (CRM SPEC-316, CUST-17): registration accepts the same communication preferences as the customers catalog trigger.
  - `20261119112137` (CRM SPEC-318, ENTRY-1): a task cannot be created completed or cancelled.
  - `20261119203357` (CRM SPEC-319, ARCH-2): archive authority applies at entry on four surfaces.
  - `20261120122927` (CRM SPEC-320, BRANCH-1): a branch table write requires the permission and MFA that `app.create_branch` requires.
  - `20261121100000` (CRM SPEC-324, ENTRY-1, STEPUP-1, ARCH-2): entry and step-up hold at the table door.
  - `20261121110000` (CRM SPEC-326, RFD-3, CHAT-2, FIN-11, PAY-5): a refund, a conversation and a settlement are recorded on every door.
  - `20261122100000` (CRM SPEC-328, JE-2 contained, PAY-4): a ledger entry balances in one currency and a payment row carries value.
- **The tests.**
  - Tests 182–185 pin the repairs.
  - Tests 186–198 carry CRM's Batch 6 exit evidence: permission enforcement and isolation basis, ceilings and mechanisms, business keys and event types, the contact-method update door, constraint and trigger refusals, the customer lock, structural control presence, open pins, the no-active-tenant refusal, and every function, prepared-state and trigger refusal reached by a call.
  - Tests 54, 58, 79, 96, 101, 106, 130, 134, 140, 145 and 155 move exactly as CRM moved them, each for the repair named in its header.
- **The records.**
  - The plan, register and disposition carry CRM's rows for SPEC-316 to SPEC-340, each with an In ORVION note. The note keeps ORVION's own CTRL-19, CTRL-11, FIN-9 and B6-EXIT rows.
  - The manifest drops OD-9 from the open owner decisions; the owner decided it AFTER on 2026-11-22.
  - CRM's governance-only changes (GOV-27 and CRM's CTRL-19 residual) are not carried; ORVION's own rows stay its own.
- **Latent on Founder Secondary.** `brplkqmbzffpxqgkkdzo` holds no tenant, invoice, payment, refund, conversation or journal entry (read-only, 2026-11-25, ledger 270). No stored row is affected and no data repair is needed.

## Risks

- **The behavior changes are CRM's.** Each is stated in its CRM contract and pinned by tests 182–198 and the eleven moved tests. No other existing test moves.
- **Founder Secondary deployment is irreversible.** It runs only under the exact-SHA Gate-2 record of Step 41, and approval of this contract does not authorize it. The seven migrations are applied serially in ledger order. Platinum Primary `vrvtsxexkiiiivlkdxzp` is never contacted.
- **A partial deploy.** If any migration of Step 42 fails, the deploy stops at that migration; the applied ones stay recorded and the contract stops before Step 43.
- **Gate 1 and Gate 2 of this contract are DELEGATED** under the owner's instructions, recorded outside this repository and never as a human-typed digest:
  - the constitution decides in the owner's absence, 2026-11-21
  - continue until the Batch 6 Finish, and finish all of the plan while away, 2026-11-24
  - Shehab kept aligned, Platinum the only live target, 2026-11-23

## Supersedes / Depends On

None.

## Write Scope

- `changes/SPEC-319-the-batch-6-exit-catch-up-is-deployed-to-founder.md`
- `supabase/migrations/20261119054533_use_customer_preference_catalog_on_registration.sql`
- `supabase/migrations/20261119112137_guard_task_terminal_status_at_entry.sql`
- `supabase/migrations/20261119203357_archive_authority_applies_at_entry.sql`
- `supabase/migrations/20261120122927_branch_write_authority_matches_the_rpc.sql`
- `supabase/migrations/20261121100000_entry_and_step_up_hold_at_the_table_door.sql`
- `supabase/migrations/20261121110000_a_refund_a_conversation_and_a_settlement_are_recorded_on_every_door.sql`
- `supabase/migrations/20261122100000_a_ledger_entry_balances_in_one_currency_and_a_payment_carries_value.sql`
- `supabase/tests/182_archive_authority_applies_at_entry_test.sql`
- `supabase/tests/183_entry_and_step_up_hold_at_the_table_door_test.sql`
- `supabase/tests/184_refund_conversation_and_settlement_are_recorded_on_every_door_test.sql`
- `supabase/tests/185_a_ledger_entry_balances_in_one_currency_and_a_payment_carries_value_test.sql`
- `supabase/tests/186_every_permission_is_enforced_and_every_table_states_its_isolation_basis_test.sql`
- `supabase/tests/187_every_ceiling_is_a_named_membership_and_no_mechanism_is_orphaned_test.sql`
- `supabase/tests/188_every_business_key_is_unique_and_every_event_type_is_registered_test.sql`
- `supabase/tests/189_a_contact_method_change_is_refused_at_the_update_door_test.sql`
- `supabase/tests/190_constraint_refusals_test.sql`
- `supabase/tests/191_trigger_enforcer_refusals_test.sql`
- `supabase/tests/192_a_customer_lock_is_taken_before_its_judgement_test.sql`
- `supabase/tests/193_structural_control_presence_test.sql`
- `supabase/tests/194_door_evidence_and_sale_dates_open_pins_test.sql`
- `supabase/tests/195_every_tenant_function_refuses_a_caller_with_no_active_tenant_test.sql`
- `supabase/tests/196_each_function_refusal_is_reached_by_a_call_test.sql`
- `supabase/tests/197_each_prepared_state_refusal_is_reached_test.sql`
- `supabase/tests/198_each_trigger_refusal_is_reached_test.sql`
- `supabase/tests/54_transition_permission_parity_test.sql`
- `supabase/tests/58_write_grants_and_config_capability_test.sql`
- `supabase/tests/79_customer_data_integrity_test.sql`
- `supabase/tests/96_invoice_void_and_eta_boundary_test.sql`
- `supabase/tests/101_marketing_metrics_and_fx_adjustment_surface_test.sql`
- `supabase/tests/106_otp_challenge_subject_authority_test.sql`
- `supabase/tests/130_branch_door_audit_test.sql`
- `supabase/tests/134_task_queue_authority_test.sql`
- `supabase/tests/140_payment_is_recorded_on_every_door_test.sql`
- `supabase/tests/145_a_journal_line_is_written_only_with_its_entry_test.sql`
- `supabase/tests/155_an_allocation_spends_its_own_payment_on_its_own_invoice_test.sql`
- `reports/master/MASTER_EXECUTION_PLAN.md`
- `reports/master/MASTER_GAP_REGISTER.md`
- `reports/master/MASTER_SURFACE_DISPOSITION.md`
- `reports/master/MASTER_API_CONTRACT.md`
- `reports/evidence/founder-ledger-evidence.json`
- `_ORVION_CANONICAL/manifest.md`
- `ai-map.json`
- `repository-index.md`

## Out of Scope — Files Forbidden to Modify

- `reports/evidence/primary-ledger-evidence.json` (historical Platinum evidence)
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
- `GOVERNANCE.md`
- `changes/TEMPLATE.md`
- `reports/architecture-decision-records.md`
- `reports/future-backlog.md`

## Required Reading

- `AGENTS.md`; `CR_LIFECYCLE.md`; `ENGINEERING_METHOD.md` §§1–5
- CRM `changes/SPEC-316` to `SPEC-340` at `15bff27` (the contracts this twin adopts by identity)
- `reports/master/MASTER_GAP_REGISTER.md`; `reports/master/MASTER_SURFACE_DISPOSITION.md`
- `reports/master/MASTER_EXECUTION_PLAN.md`, Batch 6 method and exit criteria
- `changes/SPEC-287-founder-operational-independence.md` and `GOVERNANCE.md` (Founder hosted evidence)

## Runtime Checkpoint

Resume Step: 1
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

Pass 1 Design: One contract carries the whole CRM catch-up, because its migrations, tests and records are one ordered body of bytes that CRM certified together.

- **Migrations.** The seven CRM migrations, unchanged, in their ledger order.
- **Tests.** The seventeen new tests and the eleven moved tests, unchanged.
- **Records.** CRM's plan, register and disposition rows with In ORVION notes; the manifest without OD-9. Step 43 turns the 25 pending spans to DEPLOYED and sets the measured state from fresh readings.

Pass 2 Adversarial Review: The design was challenged against smaller and different shapes.

- **Rejected designs:**
  - **One twin contract per CRM contract.** Twenty-five lifecycles for one set of bytes CRM certified together; each would deploy a partial schema CRM never ran.
  - **Re-deriving or re-wording the SQL for ORVION.** Identity is the proof; any difference loses CRM's probes and mutants.
  - **Carrying CRM's governance-only rows (GOV-27, CRM's CTRL-19 residual).** ORVION declined CTRL-19 and keeps its own rows.
  - **Applying the seven migrations as one combined statement.** The ledger would hold one version instead of seven, and parity with CRM would be lost.
- **Attacks run on the final bytes in CRM.** CRM SPEC-338's Original Finish on these SQL bytes (receipt `366e63c5d0495bcc0ad494c0c747a30e8ba0eba028c2ece87baa329816f8e274`, profiles DATABASE and REPOSITORY) passed the clean reset, the full pgTAP suite twice (198 files / 3960 assertions), the API end-to-end suite, smoke, parity evidence, consistency and the hosted guard suites. CRM exit bundle L's mutation probe killed 347 mutants and proved 13 unreachable.

Pass 3 Evidence Refresh: 2026-11-25.

- **Re-proven by identity.** The ORVION prototype at `367cdf3` has the same migration and test trees, smoke, API contract and parity query as CRM at `6b28051`. After the literal steps, every migration and test path and Git blob equals CRM `15bff27`. All 78 disposition statuses agree with CRM.
- **Read read-only on Founder Secondary.** The authenticated project URL, ledger 270 (`8e1aa53db1892b3904020e1a2f0fc1d5`), absence of all seven migrations, the surfaces and zero business counts were read anew on 2026-11-25. The baseline surfaces are required again in Step 40.
- **Adopted by reference.** CRM SPEC-316 to SPEC-340 recorded the clean resets, focused tests, pgTAP passes, HTTP suites, smoke, probes, mutants and causal negatives on the identical SQL. This product validates its own API generator and local structural surfaces in Step 40 before deploy.

Selected Version: SPEC-319; selected: the byte-identical Founder twin of CRM SPEC-316 to SPEC-340: seven migrations and seventeen new and eleven moved tests adopted by identity, the register, disposition, plan and manifest records with In ORVION notes, deployed serially to Founder Secondary under one DELEGATED exact-SHA Gate 2, the smallest catch-up that keeps ORVION's own CTRL-19, CTRL-11, FIN-9 and B6-EXIT rows

### Consumer Closure

Applicability: APPLICABLE

| Changed fact or surface | Relevant consumer | Disposition | Evidence / preserved behavior |
| --- | --- | --- | --- |
| Seven migrations, each the CRM bytes | the local stack; Founder Secondary; `supabase_migrations.schema_migrations` | WRITE | SHA-256 / md5 / bytes: `20261119054533` `5c29b9c824bd744a54e544d23c75b9a14cf3643fb8190ed74670e84128af329d` / `94cf43a4cb664343d8be39f5c7ff066d` / 4418; `20261119112137` `e75ae87f4c32ec4d6795aba68decb0e8590c6a5706aff89ddfca236b3cdb9d4b` / `5134389a8b82410ec858573982fcc247` / 633; `20261119203357` `8d781f1c9053ae82988f560abb599175579e7272731d89dea072b5d459fea09f` / `904a8f4d882705e4afa994d5b9a148aa` / 2823; `20261120122927` `4abc64f420abc6ea35ac6f59571fb4f423dbde93729a5df4193e82061344cbb5` / `4c710c23130d618cec77a5ffb3e368eb` / 15401; `20261121100000` `7183ed4a01a9af15afb24eeab8812b8f064f0f5c80a089b08d83f2d0c97e7bb0` / `954df5eb745b4f0b6ab6f06eafe314b7` / 19097; `20261121110000` `c73cf263e190d520d3b80bbe4d2d51cc861f878d068cabd991fdb330ac054d6c` / `28b4a3013130fe9337d1fe8d67d9c342` / 22430; `20261122100000` `6c9a8b488812faacba4d4eb234e66650259ae9b35c3cde5a6aafc90c7da48532` / `24b7c94f8c1c5e058f50cfb2f843e827` / 5642. A clean reset gives 277 migrations, latest `20261122100000`, ledger `7d224a770526c87f171b9525b0817701`. |
| Seventeen new and eleven moved tests | `supabase/tests`; the full pgTAP suite | WRITE | Each path and Git blob equals CRM `15bff27`. New plans: 182 (32), 183 (30), 184 (36), 185 (11), 186 (11), 187 (12), 188 (12), 189 (15), 190 (72), 191 (13), 192 (4), 193 (3), 194 (11), 195 (74), 196 (146), 197 (91), 198 (40). The 198 files' literal `plan(N)` values sum to 3960. |
| Other tests, the suite and smoke | the full pgTAP suite; the HTTP suites; `scripts/verify_database.sql` | VERIFY | In CRM SPEC-338 on these bytes: full suite 198/3960 twice, API end-to-end, smoke, all PASS. No other existing test and no line of `scripts/verify_database.sql` moves. |
| Structural surface on Founder Secondary | `scripts/parity_surface.sql`; `founder-ledger-evidence.json` | WRITE | Before (270): functions `65062ae3936dcb00559da4107eecb601`/351, triggers `cb6e44eb359ea185f84135f2fec53e69`/345, equal to the recorded Founder evidence. After (277, local, required in Step 40): functions `ca519b79e522cff13cd309456f618a14`/358 and the structural surface CRM recorded for 277. Step 43 writes Founder values only from fresh post-deploy readings. |
| Client API | `MASTER_API_CONTRACT.md` (Check L3); `scripts/generate-api-contract.ps1` | WRITE | The generator's output moves from `67d91549cfc6763ad0228456f20a37f4196bb767` to CRM's `62af74be28b058e41b6b6bcfbe43457f15acfd33`: `record_payment` no longer advances `invoices` itself (the allocation derives it), and `branches`, `campaign_daily_metrics` and `exchange_rate_adjustments` gain the write guard. No RPC is added or removed; 80 client RPCs. Step 43 regenerates it and it must equal that blob. |
| Measured state that moves | manifest `Live state` and suite figure; `founder-ledger-evidence.json`; `ai-map.json` and `repository-index.md` | WRITE | 270 → 277 migrations, latest `20261122100000`, ledger `7d224a770526c87f171b9525b0817701`; 181 → 198 files and 3333 → 3960 assertions. `Next capability` and `Current Module` stay unchanged. |
| The pinned manifest lines `Current Module`, `Next capability` and `Batch 6 surface coverage` | native Boot; `scripts/batch6_select_target.ps1` and `MASTER_SURFACE_DISPOSITION.md`, which own their values (GOVERNANCE.md §6 rule 10) | UNAFFECTED | Step 44 names `Current Module` and `Next capability` only to leave them unchanged. Each line keeps its ratified text and pin. |
| The register and disposition rows | `MASTER_GAP_REGISTER.md`; `MASTER_SURFACE_DISPOSITION.md`; Checks 21, 22, 24, 25, 29 | WRITE | CRM's rows for SPEC-316 to SPEC-340, with 11 register and 14 disposition In ORVION spans that read Founder deployment pending until Step 43 turns them to DEPLOYED. All 78 disposition statuses equal CRM `15bff27`. |
| Repository consistency | `scripts/check_repository_consistency.ps1` | VERIFY | With Steps 1–39 applied and the contract present, consistency reports exactly six measured-state items: 270 vs 277 migrations, the latest version, the ledger fingerprint, 181 vs 198 files, 3333 vs 3960 assertions, and the Founder-evidence record. Step 43 makes them true, and the one implementation commit is made only after it. |
| The four CI-only guard self-tests | `scripts/test_*_guard.ps1`; `orvion-acceptance` | VERIFY | The scripts are unchanged. `orvion-acceptance` runs them on the exact candidate SHA before `main` may move to it. |

Unresolved Material Consumers: None

### Execution-Boundary Satisfiability

Applicability: APPLICABLE

Irreversible Action Step: Step 42 (Founder Secondary deployment)

| Invariant | Required At | Red Opens After Step | Restored By Step | Mandatory Gate Before Step |
| --- | --- | --- | --- | --- |
| Identity with CRM and every migration and test blob of CRM `15bff27` holds | BEFORE_IRREVERSIBLE_ACTION | NONE | NONE | Step 40 |
| Founder Secondary lacks all seven migrations, and its ledger and structure equal the recorded evidence | BEFORE_IRREVERSIBLE_ACTION | NONE | NONE | Step 42 |
| Manifest, recorded Founder evidence and Founder ledger agree | AFTER_IRREVERSIBLE_ACTION | Step 1 | Step 43 | Step 44 |
| Manifest suite figure equals the files | BEFORE_COMPLETION | Step 8 | Step 43 | Step 44 |
| The map and the API contract match their generators | BEFORE_COMPLETION | Step 1 | Step 43 | Step 44 |

### Permanent-Control Admission

Applicability: APPLICABLE

Existing Mechanism Reusable: NO

Existing Mechanism: At `367cdf3` the controls the seven CRM migrations add are absent here: registration rejects valid communication preferences; a task can be created terminal; archive authority does not hold at entry; branch table writes skip the RPC's permission and MFA; the table door lacks the entry and step-up holds; refund, conversation and settlement writes at the table door skip their events and derived status; a journal entry can balance across currencies, and a zero-value refund payment is accepted.

Added Property: The CRM properties of SPEC-316 to SPEC-340, unchanged, for every caller and every door, as each CRM contract states them and tests 182–198 and the eleven moved tests pin them.

Causal Negative: Measured in CRM and adopted by identity: each CRM contract reproduced its gap on its own baseline schema before the repair, and its focused test fails there. ORVION at `367cdf3` has that same schema (same migration tree).

Positive Test Design: Positive controls as in CRM: each new test's fixtures write the legal path first (the RPC, the permitted role, the active value), and the moved tests keep every unchanged assertion.

Negative Test Design: by attack class, as each CRM contract states.
- **Door:** every table door refuses what its RPC refuses (tests 183, 184, 189, 196–198).
- **State:** a task is not created terminal; a settlement derives its invoice status (tests 134, 140, 155, 183, 184).
- **Input:** constraint and trigger refusals are each reached (tests 190, 191, 198); a zero-value or cross-currency write is refused (185).
- **Privilege:** branch writes require the permission and MFA (130, 186, 187); a caller with no active tenant is refused (195).
- **Business:** business keys are unique and event types registered (188); the customer lock precedes its judgement (192).
- **Auth, tenant, concurrency, replay and observability:** as each CRM test header reasons them.

Non-Empty Population Obligation: As in CRM: each new test's fixture holds its tenant, members and rows before the first assertion, and each refusal is asserted by its SQLSTATE and message.

Mutation Obligation: Adopted by identity from CRM: exit bundle L's mutation probe on these SQL bytes killed 347 mutants and proved 13 unreachable; each CRM repair contract recorded its own mutants killed by the tests carried here.

Post-Implementation Proof Obligation: All of the following on the final bytes, through canonical `-Finish` from the main checkout with the project-local CLI:

- the clean reset, pgTAP Pass A, the declared HTTP suites, pgTAP Pass B and smoke;
- the generated artifacts, repository consistency and the recorded Founder evidence.

Before Step 42: the local identity and structural checks of Step 40, which adopt the CRM proof, and the fresh Founder baseline.

## Implementation Steps

1. Check whether `supabase/migrations/20261119054533_use_customer_preference_catalog_on_registration.sql` contains `-- Canon 25: registration uses the same communication preferences as the customers catalog trigger.`; if so record Already Applied when its Git blob is 648f35f2ba93a9c69c42b989f1be6e8ddb6152eb, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (migration 1 (CRM SPEC-316): registration uses the customers communication-preference catalog), and change nothing else:

   ```text
   -- Canon 25: registration uses the same communication preferences as the customers catalog trigger.
   create or replace function app.create_customer(
       p_customer_type_code text,
       p_full_name text,
       p_first_name text default null,
       p_family_name text default null,
       p_company_name text default null,
       p_primary_phone text default null,
       p_primary_email text default null,
       p_whatsapp text default null,
       p_preferred_language_code text default null,
       p_preferred_contact_method_code text default null,
       p_marketing_opt_in boolean default false,
       p_branch_id uuid default null,
       p_allow_duplicate boolean default false
   )
   returns uuid
   language plpgsql
   security invoker
   set search_path = ''
   as $$
   declare
       v_tenant uuid := app.current_tenant_id();
       v_actor uuid;
       v_customer uuid;
       v_dupe uuid;
       v_branch uuid;
       v_phone text := app.normalize_phone(p_primary_phone);
       v_email text := app.normalize_email(p_primary_email);
       v_whatsapp text := app.normalize_phone(p_whatsapp);
       v_full_name text := nullif(btrim(p_full_name), '');
       v_first_name text := nullif(btrim(p_first_name), '');
       v_family_name text := nullif(btrim(p_family_name), '');
       v_company_name text := nullif(btrim(p_company_name), '');
   begin
       if v_tenant is null then
           raise exception 'no active tenant for caller';
       end if;
       perform app.authorize('CREATE_CUSTOMER');

       if not exists (
           select 1 from public.catalog_values
           where catalog_type_code = 'customer_type' and code = p_customer_type_code
       ) then
           raise exception 'unknown customer_type_code: %', p_customer_type_code;
       end if;

       if p_preferred_contact_method_code is not null and not exists (
           select 1 from public.catalog_values
           where catalog_type_code = 'preferred_contact_method_code' and code = p_preferred_contact_method_code
       ) then
           raise exception 'unknown preferred_contact_method_code: %', p_preferred_contact_method_code;
       end if;

       if p_branch_id is not null and not exists (
           select 1 from public.branches where id = p_branch_id and tenant_id = v_tenant
       ) then
           raise exception 'branch is not in your tenant';
       end if;

       -- Primary-phone uniqueness (05). This check survives for the error message; the partial unique
       -- index added by SPEC-142 is what makes it true under concurrency and on the direct path.
       if v_phone is not null and not p_allow_duplicate then
           select id into v_dupe from public.customers
           where tenant_id = v_tenant and is_archived = false and primary_phone = v_phone
           limit 1;
           if v_dupe is not null then
               raise exception 'duplicate primary phone for customer %; pass p_allow_duplicate to override', v_dupe
                   using errcode = 'unique_violation';
           end if;
       end if;

       select id into v_actor
       from public.users
       where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

       -- An explicit branch still wins; otherwise the customer is registered where the employee taking
       -- them on actually works. Leaving it null was how canon 03's requirement quietly went unrecorded.
       v_branch := coalesce(p_branch_id, (select cp.branch_id from app.current_placement() cp));

       insert into public.customers (
           tenant_id, customer_type_code, first_name, family_name, full_name, company_name,
           primary_phone, primary_email, preferred_language_code, preferred_contact_method_code,
           marketing_opt_in, first_registered_branch_id, first_registered_user_id, created_by,
           duplicate_phone_approved
       )
       values (
           v_tenant, p_customer_type_code, v_first_name, v_family_name, v_full_name, v_company_name,
           v_phone, v_email, p_preferred_language_code, p_preferred_contact_method_code,
           p_marketing_opt_in, v_branch, v_actor, v_actor,
           p_allow_duplicate and v_phone is not null
       )
       returning id into v_customer;

       -- Seed identity signals (only for provided values) so duplicate detection has data to match on.
       insert into public.customer_identity_signals (tenant_id, customer_id, signal_type_code, signal_value)
       select v_tenant, v_customer, t.st, t.sv
       from (values
           ('phone',    v_phone),
           ('whatsapp', v_whatsapp),
           ('email',    v_email)
       ) as t(st, sv)
       where t.sv is not null;

       return v_customer;
   end;
   $$;
   ```

   The resulting file's Git blob is 648f35f2ba93a9c69c42b989f1be6e8ddb6152eb.

2. Check whether `supabase/migrations/20261119112137_guard_task_terminal_status_at_entry.sql` contains `-- ENTRY-1: task completion and cancellation must use the existing transition path.`; if so record Already Applied when its Git blob is e4864c7bf2c4dc9c9ce07f79e9c0e4a389d98a5d, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (migration 2 (CRM SPEC-318): a task cannot be created completed or cancelled), and change nothing else:

   ```text
   -- ENTRY-1: task completion and cancellation must use the existing transition path.
   create function app.guard_task_terminal_status_at_entry()
   returns trigger
   language plpgsql
   set search_path = ''
   as $fn$
   begin
       raise exception using
           errcode = '23514',
           message = 'a task cannot be created in a terminal state';
   end;
   $fn$;

   revoke all on function app.guard_task_terminal_status_at_entry() from public;

   create trigger tasks_guard_terminal_status_at_entry
   before insert on public.tasks
   for each row
   when (new.task_status_code in ('completed', 'cancelled'))
   execute function app.guard_task_terminal_status_at_entry();
   ```

   The resulting file's Git blob is e4864c7bf2c4dc9c9ce07f79e9c0e4a389d98a5d.

3. Check whether `supabase/migrations/20261119203357_archive_authority_applies_at_entry.sql` contains `-- ARCH-2: extend the existing archive authority to creation on four CRM surfaces.`; if so record Already Applied when its Git blob is ec8e125c0b20c282cacaad51d1a05a429039aaaf, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (migration 3 (CRM SPEC-319): archive authority applies at entry), and change nothing else:

   ```text
   -- ARCH-2: extend the existing archive authority to creation on four CRM surfaces.

   create or replace function app.enforce_archive_authority()
   returns trigger language plpgsql security definer set search_path = '' as $$
   declare v_permission text; v_actor uuid;
   begin
       if (select auth.uid()) is null then return new; end if;
       if tg_op='INSERT' then
           if not new.is_archived
              and (new.archived_at is not null or new.archived_by is not null) then
               raise exception 'archive metadata is set by the server' using errcode='42501';
           end if;
           if new.is_archived or new.archive_reason is not null then
               v_permission:=case when tg_table_name='documents' then 'ARCHIVE_DOCUMENT' else 'ARCHIVE_RECORD' end;
               perform app.authorize(v_permission);
               v_actor:=app.current_user_id();
               if new.is_archived then new.archived_at:=now(); new.archived_by:=v_actor; end if;
           end if;
           return new;
       end if;
       if tg_op='UPDATE' and new.is_archived is not distinct from old.is_archived
          and (new.archived_at is distinct from old.archived_at
               or new.archived_by is distinct from old.archived_by) then
           raise exception 'archive metadata is immutable once the archive state is set' using errcode='42501';
       end if;
       -- Reason is caller-authored, unlike the server-stamped time/actor. Corrections remain
       -- possible, but cost the archive capability even when the boolean does not change.
       if new.is_archived is not distinct from old.is_archived then
           if new.archive_reason is distinct from old.archive_reason then
               perform app.authorize(case when tg_table_name='documents' then 'ARCHIVE_DOCUMENT' else 'ARCHIVE_RECORD' end);
           end if;
           return new;
       end if;
       v_permission:=case when tg_table_name='documents' then 'ARCHIVE_DOCUMENT' else 'ARCHIVE_RECORD' end;
       perform app.authorize(v_permission);
       v_actor:=app.current_user_id();
       if new.is_archived then new.archived_at:=now(); new.archived_by:=v_actor;
       else new.archived_at:=null; new.archived_by:=null; end if;
       return new;
   end; $$;

   create or replace trigger bookings_enforce_archive_authority
   before insert or update on public.bookings
   for each row execute function app.enforce_archive_authority();

   create or replace trigger passengers_enforce_archive_authority
   before insert or update on public.passengers
   for each row execute function app.enforce_archive_authority();

   create or replace trigger suppliers_enforce_archive_authority
   before insert or update on public.suppliers
   for each row execute function app.enforce_archive_authority();

   create or replace trigger tasks_enforce_archive_authority
   before insert or update on public.tasks
   for each row execute function app.enforce_archive_authority();
   ```

   The resulting file's Git blob is ec8e125c0b20c282cacaad51d1a05a429039aaaf.

4. Check whether `supabase/migrations/20261120122927_branch_write_authority_matches_the_rpc.sql` contains `-- BRANCH-1: require the same permission and MFA for branch table writes and app.create_branch.`; if so record Already Applied when its Git blob is ea92b491bf33a69377921ba84d76daf11abd8770, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (migration 4 (CRM SPEC-320): branch table writes require the RPC permission and MFA), and change nothing else:

   ```text
   -- BRANCH-1: require the same permission and MFA for branch table writes and app.create_branch.
   -- Reuse the existing capability trigger, as branch_business_hours does. The current RLS
   -- tenant fence, grants and branch event behavior remain in force. BRANCH-2 is separate.

   CREATE OR REPLACE FUNCTION app.guard_write_capability()
    RETURNS trigger
    LANGUAGE plpgsql
    SECURITY DEFINER
    SET search_path TO ''
   AS $function$
   declare
       v_perms  text[];
       v_extra  text[];
       v_perm   text;
       v_held   text;
       v_strict boolean := false;
       v_relationship_ok boolean := false;
   begin
       -- Platform/system paths (canon 35 principle 6), as in every other guard here.
       if (select auth.uid()) is null then
           return new;
       end if;

       -- 202607058500 (LIC-3 / PP-4): `documents` is resolved in its OWN statement, not inside the
       -- shared CASE below. A record field reference is resolved against the ACTUAL record type at
       -- execution, so naming `new.document_type_code` inside an expression this trigger also evaluates
       -- for `customers`, `leads` and twenty other tables fails on every one of them.
       if tg_table_name = 'documents' then
           if new.document_type_code = 'payment_proof' then
               v_perms := array['MANAGE_TENANT_SETTINGS'];
               v_strict := true;
           else
               v_perms := array['UPLOAD_DOCUMENT'];
           end if;
       else
       v_perms := case tg_table_name
                      when 'approval_requests'         then array['CREATE_BOOKING_ITEM']
                      when 'booking_item_passengers'   then array['CREATE_BOOKING_ITEM']
                      when 'booking_items'             then array['CREATE_BOOKING_ITEM']
                      when 'conversation_messages'     then array['SEND_MESSAGE']
                      when 'customer_contact_methods'  then array['CREATE_CUSTOMER']
                      when 'customer_identity_signals' then array['CREATE_CUSTOMER']
                      when 'customer_identity_merges'  then array['MERGE_CUSTOMER_IDENTITY']
                      when 'internal_supplier_links'   then array['ASSIGN_SUPPLIER']
                      when 'offline_conversions'       then array['MANAGE_MARKETING_CAMPAIGN']
                      when 'marketing_campaigns'       then array['MANAGE_MARKETING_CAMPAIGN']
                      when 'document_links'            then array['UPLOAD_DOCUMENT','MANAGE_TENANT_SETTINGS']
                      when 'lead_assignments'          then array['ASSIGN_LEAD','REASSIGN_LEAD']
                      when 'branches'                  then array['MANAGE_BRANCHES']
                      when 'branch_business_hours'     then array['MANAGE_BRANCHES']
                      when 'holidays'                  then array['MANAGE_BRANCHES','MANAGE_TENANT_SETTINGS']
                      when 'financial_accounts'        then array['CREATE_JOURNAL_ENTRY']
                      when 'company_assets'            then array['CREATE_JOURNAL_ENTRY']
                      when 'bookings'                  then array['CREATE_BOOKING']
                      when 'complaints'                then array['CREATE_COMPLAINT']
                      when 'conversations'             then array['SEND_MESSAGE']
                      when 'customer_notes'            then array['CREATE_CUSTOMER']
                      when 'customers'                 then array['CREATE_CUSTOMER']
                      when 'leads'                     then array['CREATE_LEAD']
                      when 'passengers'                then array['CREATE_BOOKING_ITEM']
                      when 'quotations'                then array['CREATE_QUOTATION']
                      when 'service_requests'          then array['CREATE_SERVICE_REQUEST']
                      when 'suppliers'                 then array['ASSIGN_SUPPLIER']
                      when 'tasks'                     then array['CREATE_TASK']
                  end;
       end if;

       -- 202607059100 (SEC-1c): on UPDATE the object-class permission is joined by the permissions canon
       -- already says may MUTATE this object.
       if tg_op = 'UPDATE' and not v_strict then
           v_extra := case tg_table_name
                          when 'approval_requests'  then array['APPROVE_FINANCE','REVIEW_APPROVAL_REQUEST','REVIEW_SUBSCRIPTION_PAYMENT']
                          -- PAX-5 (2026-09-09): the post-issue manifest authority APPENDS, exactly as
                          -- CUST-3's block below explains for MANAGE_CUSTOMER_CREDIT and NOT as the
                          -- supplier branch REPLACES. Measured containment: CORRECT_PASSENGER_MANIFEST
                          -- goes to owner/ceo/branch_manager/finance_manager and CREATE_BOOKING_ITEM to
                          -- owner/ceo/branch_manager/department_manager/employee/senior_employee, so
                          -- `finance_manager` holds the first and NOT the second. Without this line the
                          -- object-class door would refuse a finance manager's correction before
                          -- app.enforce_booking_item_passenger_lifecycle -- the enforcer that actually
                          -- owns PAX-5 -- ever ran, and a per-user grant of the capability would be
                          -- silently void. Appending widens only WHO REACHES THE ENFORCER; the freeze
                          -- itself still demands CORRECT_PASSENGER_MANIFEST specifically.
                          when 'booking_items'      then array['UPDATE_BOOKING_ITEM_STATUS','ENTER_COST','ENTER_SELLING_PRICE','APPROVE_FINANCE','EDIT_LOCKED_COST','ARCHIVE_RECORD','ASSIGN_SUPPLIER']
                          when 'bookings'           then array['APPROVE_BOOKING','CANCEL_BOOKING','ISSUE_BOOKING','REFUND_BOOKING','REISSUE_BOOKING']
                          when 'complaints'         then array['RESOLVE_COMPLAINT']
                          when 'conversations'      then array['CLOSE_CONVERSATION','ESCALATE_CONVERSATION']
                          when 'customers'          then array['MERGE_CUSTOMER_IDENTITY']
                          when 'documents'          then array['ARCHIVE_DOCUMENT','CREATE_DOCUMENT_VERSION']
                          when 'leads'              then array['ASSIGN_LEAD','CLOSE_LEAD','REASSIGN_LEAD']
                          when 'quotations'         then array['ACCEPT_QUOTATION','SEND_QUOTATION']
                          when 'service_requests'   then array['RESOLVE_SERVICE_REQUEST']
                          when 'tasks'              then array['ASSIGN_TASK','COMPLETE_TASK']
                          else null
                      end;
           if v_extra is not null then
               v_perms := v_perms || v_extra;
           end if;
       end if;

       -- CUST-3 (2026-09-04): the customer ceiling. REQUIRED, not cosmetic -- `finance_manager` does NOT
       -- hold CREATE_CUSTOMER (measured: only owner, ceo, branch_manager, department_manager,
       -- senior_employee and employee do), so without this a finance manager could not set a ceiling at
       -- all. That is SUP-3's defect one table over.
       --
       -- THIS BRANCH APPENDS; THE SUPPLIER BRANCH BELOW REPLACES, AND THE DIFFERENCE IS DELIBERATE.
       -- MANAGE_CUSTOMER_CREDIT is NOT a subset of CREATE_CUSTOMER (`finance_manager` holds the first
       -- and not the second), so replacing here would refuse an employee legitimately creating a
       -- customer that happens to carry a ceiling. On `suppliers` the containment runs the other way and
       -- replacing costs nothing -- see CUST-5's block in `202607060600`. The CONSEQUENCE of appending
       -- is that this guard is not a second enforcer of MANAGE_CUSTOMER_CREDIT the way the supplier
       -- branch is; `customers_guard_credit_authority` is the sole enforcer on this table. Recorded as
       -- CUST-6 rather than changed inside a supplier migration.
       if tg_table_name = 'customers' then
           if (tg_op = 'UPDATE'
               and (new.credit_limit_amount is distinct from old.credit_limit_amount
                    or new.credit_limit_currency_code is distinct from old.credit_limit_currency_code))
              or (tg_op = 'INSERT'
                  and (new.credit_limit_amount is not null or new.credit_limit_currency_code is not null))
           then
               -- `array[...]`, not a bare literal: `text[] || 'x'` makes PostgreSQL parse the untyped
               -- literal AS an array and fail with 22P02, which is what the suite caught first.
               v_perms := v_perms || array['MANAGE_CUSTOMER_CREDIT'];
           end if;
       end if;

       -- PAX-5 (2026-09-09). SCOPED TO THE ACT, NOT TO THE TABLE, and the first draft was wrong in a way
       -- the suite caught. Measured containment: CORRECT_PASSENGER_MANIFEST goes to
       -- owner/ceo/branch_manager/finance_manager, CREATE_BOOKING_ITEM to those three plus
       -- department_manager/employee/senior_employee -- so `finance_manager` holds the first and NOT the
       -- second, and without SOME widening a per-user grant of the correction capability would be
       -- silently void: the object-class door would refuse before
       -- app.enforce_booking_item_passenger_lifecycle -- the enforcer that owns PAX-5 -- ever ran.
       --
       -- THE FIRST DRAFT WIDENED THE WHOLE TABLE and broke PAX-2: test 104 assertions 10 and 12 failed,
       -- because a finance_manager could then swap the traveller on a DRAFT link they did not create,
       -- which is the exact reproduction 202607061400 closed. The rule is not "this table costs the
       -- correction capability"; it is "an ATTRIBUTED CORRECTION may be made by a correction holder".
       --
       -- So the alternative is offered ONLY when the statement is actually a correction: the traveller
       -- moves AND the statement authors a fresh reason for it -- the same two facts the lifecycle guard
       -- demands in the frozen period. A bare swap still costs CREATE_BOOKING_ITEM and nothing else, so
       -- PAX-2 is untouched. This APPENDS rather than REPLACES, for CUST-3's reason exactly: the two
       -- populations are not nested, and replacing would refuse an employee's ordinary attributed edit.
       if tg_op = 'UPDATE' and tg_table_name = 'booking_item_passengers' then
           -- PAX-7 (SPEC-223): correcting the TICKETED IDENTITY of the same traveller is the same
           -- attributed correction as moving the traveller, so it is offered on the same two facts.
           -- PAX-9 (SPEC-224): so is moving an entry ONTO or OFF a frozen manifest. Only a frozen
           -- endpoint qualifies: between unfrozen items a reason buys nothing here, and the object-class
           -- authority stays the only door.
           if (new.passenger_id is distinct from old.passenger_id
               or (new.manifest_first_name, new.manifest_family_name, new.manifest_full_name,
                   new.manifest_date_of_birth, new.manifest_passport_number,
                   new.manifest_passport_issuing_country_code)
                  is distinct from
                  (old.manifest_first_name, old.manifest_family_name, old.manifest_full_name,
                   old.manifest_date_of_birth, old.manifest_passport_number,
                   old.manifest_passport_issuing_country_code)
               or (new.booking_item_id is distinct from old.booking_item_id
                   and exists (select 1
                                 from public.booking_items bi
                                 join public.bookings b on b.id = bi.booking_id
                                where bi.id in (old.booking_item_id, new.booking_item_id)
                                  and bi.tenant_id = (select app.current_tenant_id())
                                  and app.manifest_is_frozen(b.booking_status_code, b.is_archived))))
              and new.passenger_correction_reason is distinct from old.passenger_correction_reason
              and coalesce(btrim(new.passenger_correction_reason), '') <> '' then
               v_perms := v_perms || array['CORRECT_PASSENGER_MANIFEST'];
           end if;
       end if;
       -- PAX-9 (SPEC-224): adding a traveller to a FROZEN manifest is an attributed correction too, and
       -- is offered on the same facts; before the freeze an insertion stays CREATE_BOOKING_ITEM work.
       if tg_op = 'INSERT' and tg_table_name = 'booking_item_passengers' then
           if coalesce(btrim(new.passenger_correction_reason), '') <> ''
              and exists (select 1
                            from public.booking_items bi
                            join public.bookings b on b.id = bi.booking_id
                           where bi.id = new.booking_item_id
                             and bi.tenant_id = (select app.current_tenant_id())
                             and app.manifest_is_frozen(b.booking_status_code, b.is_archived)) then
               v_perms := v_perms || array['CORRECT_PASSENGER_MANIFEST'];
           end if;
       end if;
       -- CUST-5 (202607060600): SUP-3's authority, widened by SUP-4a to the PAIR (amount, currency),
       -- expressed WITHOUT a row image. The ONLY change from the replaced form is that the
       -- "and nothing else changed" conjunct is GONE; the assignment it guards is untouched.
       if tg_op = 'UPDATE' and tg_table_name = 'suppliers' then
           if new.credit_limit_amount is distinct from old.credit_limit_amount
              or new.credit_limit_currency_code is distinct from old.credit_limit_currency_code
           then
               v_perms := array['MANAGE_SUPPLIER_CREDIT'];
           end if;
       end if;

       -- LEAD-1 (202607061900). The handler rule, evaluated ONLY inside its own table branch so
       -- `new.assigned_user_id` is never named while this trigger is serving `suppliers` or `customers`.
       -- TWO CHANGES FROM THE FORM THIS REPLACES, both from BOOK-5's standing question:
       --   * MOVING THE ASSIGNMENT is authority, not content, and it costs what the two RPCs that do it
       --     charge. REPLACES the permission set (the `suppliers` shape): every role holding either key
       --     also holds CREATE_LEAD, so nothing legitimate loses a door.
       --   * THE SHORTCUT READS `old`. Reading `new` let the attacking statement supply the answer to
       --     "are you the handler?" and skip the entire check for every column in the statement.
       if tg_op = 'UPDATE' and tg_table_name = 'leads' then
           if new.assigned_user_id is distinct from old.assigned_user_id
              or new.owner_user_id is distinct from old.owner_user_id then
               v_perms := array['ASSIGN_LEAD','REASSIGN_LEAD'];
           else
               v_relationship_ok := (select app.current_user_id()) is not null
                                    and (select app.current_user_id())
                                        in (old.assigned_user_id, old.owner_user_id);
           end if;
       end if;

       if v_relationship_ok then
           return new;
       end if;

       if v_perms is null then
           raise exception 'guard_write_capability has no permission mapping for %', tg_table_name
               using errcode = 'insufficient_privilege';
       end if;

       foreach v_perm in array v_perms loop
           if app.has_permission(v_perm) then
               v_held := v_perm;
               exit;
           end if;
       end loop;

       if v_held is null then
           raise exception 'permission denied: one of % is required to write %',
                           array_to_string(v_perms, ' or '), tg_table_name
               using errcode = 'insufficient_privilege';
       end if;

       perform app.authorize(v_held);
       return new;
   end;
   $function$;

   create trigger branches_guard_write_capability
       before insert or update on public.branches
       for each row execute function app.guard_write_capability();
   ```

   The resulting file's Git blob is ea92b491bf33a69377921ba84d76daf11abd8770.

5. Check whether `supabase/migrations/20261121100000_entry_and_step_up_hold_at_the_table_door.sql` contains `-- B6-EXIT bundle A: three entry and step-up holes at the table door, each reproduced at 73b02a1 in`; if so record Already Applied when its Git blob is fc317dda36df2d5540bad2ba6afcabbf9d2e8867, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (migration 5 (CRM SPEC-324): entry and step-up hold at the table door), and change nothing else:

   ```text
   -- B6-EXIT bundle A: three entry and step-up holes at the table door, each reproduced at 73b02a1 in
   -- rolled-back transactions on the local stack, each closed by reusing a mechanism already in force.
   --   * ARCH-2: an employee without ARCHIVE_RECORD inserted archived leads, quotations and booking
   --     items, and an active row naming a forged archived_by; an aal2 finance user inserted an
   --     archived invoice with archived_by forged and archived_at backdated a year. SPEC-319 already
   --     made app.enforce_archive_authority judge INSERT; these four attachments still fired on UPDATE
   --     only. They are re-attached BEFORE INSERT OR UPDATE on the unchanged function.
   --   * STEPUP-1: an aal1 owner inserted campaign_daily_metrics (spend 0, revenue 5,000,000) while the
   --     same session was refused the parent campaign update for missing MFA; an aal1 finance_manager
   --     inserted an exchange_rate_adjustment that then blocked an aal2 correction of the cited rate.
   --     Both tables gain the arm of app.guard_write_capability that CAMP-3 and BRANCH-1 use, priced at
   --     the permission each table's RLS write check already demands, so app.authorize adds only the
   --     role's MFA requirement. No RPC writes either table.
   --   * ENTRY-1 (booking_items): the employee refused by app.advance_booking_item for a finance-gated
   --     item inserted that item already in_progress with no approval, and a completed item with
   --     completed_at backdated 400 days; neither emitted a lifecycle event. app.create_booking_item,
   --     the only inserter, writes 'draft' and no lifecycle stamp. A signed-in caller is now held to
   --     the same entry, SPEC-239's bookings rule; session-less platform paths stay exempt, as
   --     app.enforce_status_transition already exempts them from the whole graph.
   -- NOT CHANGED: every grant, policy, permission, RLS check, event producer and RPC; the permission
   -- mapping of every other table; CAMP-2, JE-2 and the other STEPUP-1 candidates.

   create or replace trigger leads_enforce_archive_authority
   before insert or update on public.leads
   for each row execute function app.enforce_archive_authority();

   create or replace trigger quotations_enforce_archive_authority
   before insert or update on public.quotations
   for each row execute function app.enforce_archive_authority();

   create or replace trigger booking_items_enforce_archive_authority
   before insert or update on public.booking_items
   for each row execute function app.enforce_archive_authority();

   create or replace trigger invoices_enforce_archive_authority
   before insert or update on public.invoices
   for each row execute function app.enforce_archive_authority();

   CREATE OR REPLACE FUNCTION app.guard_write_capability()
    RETURNS trigger
    LANGUAGE plpgsql
    SECURITY DEFINER
    SET search_path TO ''
   AS $function$
   declare
       v_perms  text[];
       v_extra  text[];
       v_perm   text;
       v_held   text;
       v_strict boolean := false;
       v_relationship_ok boolean := false;
   begin
       -- Platform/system paths (canon 35 principle 6), as in every other guard here.
       if (select auth.uid()) is null then
           return new;
       end if;

       -- 202607058500 (LIC-3 / PP-4): `documents` is resolved in its OWN statement, not inside the
       -- shared CASE below. A record field reference is resolved against the ACTUAL record type at
       -- execution, so naming `new.document_type_code` inside an expression this trigger also evaluates
       -- for `customers`, `leads` and twenty other tables fails on every one of them.
       if tg_table_name = 'documents' then
           if new.document_type_code = 'payment_proof' then
               v_perms := array['MANAGE_TENANT_SETTINGS'];
               v_strict := true;
           else
               v_perms := array['UPLOAD_DOCUMENT'];
           end if;
       else
       v_perms := case tg_table_name
                      when 'approval_requests'         then array['CREATE_BOOKING_ITEM']
                      when 'booking_item_passengers'   then array['CREATE_BOOKING_ITEM']
                      when 'booking_items'             then array['CREATE_BOOKING_ITEM']
                      when 'conversation_messages'     then array['SEND_MESSAGE']
                      when 'customer_contact_methods'  then array['CREATE_CUSTOMER']
                      when 'customer_identity_signals' then array['CREATE_CUSTOMER']
                      when 'customer_identity_merges'  then array['MERGE_CUSTOMER_IDENTITY']
                      when 'internal_supplier_links'   then array['ASSIGN_SUPPLIER']
                      when 'offline_conversions'       then array['MANAGE_MARKETING_CAMPAIGN']
                      when 'marketing_campaigns'       then array['MANAGE_MARKETING_CAMPAIGN']
                      when 'campaign_daily_metrics'    then array['MANAGE_MARKETING_CAMPAIGN']
                      when 'exchange_rate_adjustments' then array['CREATE_EXCHANGE_RATE_ADJUSTMENT']
                      when 'document_links'            then array['UPLOAD_DOCUMENT','MANAGE_TENANT_SETTINGS']
                      when 'lead_assignments'          then array['ASSIGN_LEAD','REASSIGN_LEAD']
                      when 'branches'                  then array['MANAGE_BRANCHES']
                      when 'branch_business_hours'     then array['MANAGE_BRANCHES']
                      when 'holidays'                  then array['MANAGE_BRANCHES','MANAGE_TENANT_SETTINGS']
                      when 'financial_accounts'        then array['CREATE_JOURNAL_ENTRY']
                      when 'company_assets'            then array['CREATE_JOURNAL_ENTRY']
                      when 'bookings'                  then array['CREATE_BOOKING']
                      when 'complaints'                then array['CREATE_COMPLAINT']
                      when 'conversations'             then array['SEND_MESSAGE']
                      when 'customer_notes'            then array['CREATE_CUSTOMER']
                      when 'customers'                 then array['CREATE_CUSTOMER']
                      when 'leads'                     then array['CREATE_LEAD']
                      when 'passengers'                then array['CREATE_BOOKING_ITEM']
                      when 'quotations'                then array['CREATE_QUOTATION']
                      when 'service_requests'          then array['CREATE_SERVICE_REQUEST']
                      when 'suppliers'                 then array['ASSIGN_SUPPLIER']
                      when 'tasks'                     then array['CREATE_TASK']
                  end;
       end if;

       -- 202607059100 (SEC-1c): on UPDATE the object-class permission is joined by the permissions canon
       -- already says may MUTATE this object.
       if tg_op = 'UPDATE' and not v_strict then
           v_extra := case tg_table_name
                          when 'approval_requests'  then array['APPROVE_FINANCE','REVIEW_APPROVAL_REQUEST','REVIEW_SUBSCRIPTION_PAYMENT']
                          -- PAX-5 (2026-09-09): the post-issue manifest authority APPENDS, exactly as
                          -- CUST-3's block below explains for MANAGE_CUSTOMER_CREDIT and NOT as the
                          -- supplier branch REPLACES. Measured containment: CORRECT_PASSENGER_MANIFEST
                          -- goes to owner/ceo/branch_manager/finance_manager and CREATE_BOOKING_ITEM to
                          -- owner/ceo/branch_manager/department_manager/employee/senior_employee, so
                          -- `finance_manager` holds the first and NOT the second. Without this line the
                          -- object-class door would refuse a finance manager's correction before
                          -- app.enforce_booking_item_passenger_lifecycle -- the enforcer that actually
                          -- owns PAX-5 -- ever ran, and a per-user grant of the capability would be
                          -- silently void. Appending widens only WHO REACHES THE ENFORCER; the freeze
                          -- itself still demands CORRECT_PASSENGER_MANIFEST specifically.
                          when 'booking_items'      then array['UPDATE_BOOKING_ITEM_STATUS','ENTER_COST','ENTER_SELLING_PRICE','APPROVE_FINANCE','EDIT_LOCKED_COST','ARCHIVE_RECORD','ASSIGN_SUPPLIER']
                          when 'bookings'           then array['APPROVE_BOOKING','CANCEL_BOOKING','ISSUE_BOOKING','REFUND_BOOKING','REISSUE_BOOKING']
                          when 'complaints'         then array['RESOLVE_COMPLAINT']
                          when 'conversations'      then array['CLOSE_CONVERSATION','ESCALATE_CONVERSATION']
                          when 'customers'          then array['MERGE_CUSTOMER_IDENTITY']
                          when 'documents'          then array['ARCHIVE_DOCUMENT','CREATE_DOCUMENT_VERSION']
                          when 'leads'              then array['ASSIGN_LEAD','CLOSE_LEAD','REASSIGN_LEAD']
                          when 'quotations'         then array['ACCEPT_QUOTATION','SEND_QUOTATION']
                          when 'service_requests'   then array['RESOLVE_SERVICE_REQUEST']
                          when 'tasks'              then array['ASSIGN_TASK','COMPLETE_TASK']
                          else null
                      end;
           if v_extra is not null then
               v_perms := v_perms || v_extra;
           end if;
       end if;

       -- CUST-3 (2026-09-04): the customer ceiling. REQUIRED, not cosmetic -- `finance_manager` does NOT
       -- hold CREATE_CUSTOMER (measured: only owner, ceo, branch_manager, department_manager,
       -- senior_employee and employee do), so without this a finance manager could not set a ceiling at
       -- all. That is SUP-3's defect one table over.
       --
       -- THIS BRANCH APPENDS; THE SUPPLIER BRANCH BELOW REPLACES, AND THE DIFFERENCE IS DELIBERATE.
       -- MANAGE_CUSTOMER_CREDIT is NOT a subset of CREATE_CUSTOMER (`finance_manager` holds the first
       -- and not the second), so replacing here would refuse an employee legitimately creating a
       -- customer that happens to carry a ceiling. On `suppliers` the containment runs the other way and
       -- replacing costs nothing -- see CUST-5's block in `202607060600`. The CONSEQUENCE of appending
       -- is that this guard is not a second enforcer of MANAGE_CUSTOMER_CREDIT the way the supplier
       -- branch is; `customers_guard_credit_authority` is the sole enforcer on this table. Recorded as
       -- CUST-6 rather than changed inside a supplier migration.
       if tg_table_name = 'customers' then
           if (tg_op = 'UPDATE'
               and (new.credit_limit_amount is distinct from old.credit_limit_amount
                    or new.credit_limit_currency_code is distinct from old.credit_limit_currency_code))
              or (tg_op = 'INSERT'
                  and (new.credit_limit_amount is not null or new.credit_limit_currency_code is not null))
           then
               -- `array[...]`, not a bare literal: `text[] || 'x'` makes PostgreSQL parse the untyped
               -- literal AS an array and fail with 22P02, which is what the suite caught first.
               v_perms := v_perms || array['MANAGE_CUSTOMER_CREDIT'];
           end if;
       end if;

       -- PAX-5 (2026-09-09). SCOPED TO THE ACT, NOT TO THE TABLE, and the first draft was wrong in a way
       -- the suite caught. Measured containment: CORRECT_PASSENGER_MANIFEST goes to
       -- owner/ceo/branch_manager/finance_manager, CREATE_BOOKING_ITEM to those three plus
       -- department_manager/employee/senior_employee -- so `finance_manager` holds the first and NOT the
       -- second, and without SOME widening a per-user grant of the correction capability would be
       -- silently void: the object-class door would refuse before
       -- app.enforce_booking_item_passenger_lifecycle -- the enforcer that owns PAX-5 -- ever ran.
       --
       -- THE FIRST DRAFT WIDENED THE WHOLE TABLE and broke PAX-2: test 104 assertions 10 and 12 failed,
       -- because a finance_manager could then swap the traveller on a DRAFT link they did not create,
       -- which is the exact reproduction 202607061400 closed. The rule is not "this table costs the
       -- correction capability"; it is "an ATTRIBUTED CORRECTION may be made by a correction holder".
       --
       -- So the alternative is offered ONLY when the statement is actually a correction: the traveller
       -- moves AND the statement authors a fresh reason for it -- the same two facts the lifecycle guard
       -- demands in the frozen period. A bare swap still costs CREATE_BOOKING_ITEM and nothing else, so
       -- PAX-2 is untouched. This APPENDS rather than REPLACES, for CUST-3's reason exactly: the two
       -- populations are not nested, and replacing would refuse an employee's ordinary attributed edit.
       if tg_op = 'UPDATE' and tg_table_name = 'booking_item_passengers' then
           -- PAX-7 (SPEC-223): correcting the TICKETED IDENTITY of the same traveller is the same
           -- attributed correction as moving the traveller, so it is offered on the same two facts.
           -- PAX-9 (SPEC-224): so is moving an entry ONTO or OFF a frozen manifest. Only a frozen
           -- endpoint qualifies: between unfrozen items a reason buys nothing here, and the object-class
           -- authority stays the only door.
           if (new.passenger_id is distinct from old.passenger_id
               or (new.manifest_first_name, new.manifest_family_name, new.manifest_full_name,
                   new.manifest_date_of_birth, new.manifest_passport_number,
                   new.manifest_passport_issuing_country_code)
                  is distinct from
                  (old.manifest_first_name, old.manifest_family_name, old.manifest_full_name,
                   old.manifest_date_of_birth, old.manifest_passport_number,
                   old.manifest_passport_issuing_country_code)
               or (new.booking_item_id is distinct from old.booking_item_id
                   and exists (select 1
                                 from public.booking_items bi
                                 join public.bookings b on b.id = bi.booking_id
                                where bi.id in (old.booking_item_id, new.booking_item_id)
                                  and bi.tenant_id = (select app.current_tenant_id())
                                  and app.manifest_is_frozen(b.booking_status_code, b.is_archived))))
              and new.passenger_correction_reason is distinct from old.passenger_correction_reason
              and coalesce(btrim(new.passenger_correction_reason), '') <> '' then
               v_perms := v_perms || array['CORRECT_PASSENGER_MANIFEST'];
           end if;
       end if;
       -- PAX-9 (SPEC-224): adding a traveller to a FROZEN manifest is an attributed correction too, and
       -- is offered on the same facts; before the freeze an insertion stays CREATE_BOOKING_ITEM work.
       if tg_op = 'INSERT' and tg_table_name = 'booking_item_passengers' then
           if coalesce(btrim(new.passenger_correction_reason), '') <> ''
              and exists (select 1
                            from public.booking_items bi
                            join public.bookings b on b.id = bi.booking_id
                           where bi.id = new.booking_item_id
                             and bi.tenant_id = (select app.current_tenant_id())
                             and app.manifest_is_frozen(b.booking_status_code, b.is_archived)) then
               v_perms := v_perms || array['CORRECT_PASSENGER_MANIFEST'];
           end if;
       end if;
       -- CUST-5 (202607060600): SUP-3's authority, widened by SUP-4a to the PAIR (amount, currency),
       -- expressed WITHOUT a row image. The ONLY change from the replaced form is that the
       -- "and nothing else changed" conjunct is GONE; the assignment it guards is untouched.
       if tg_op = 'UPDATE' and tg_table_name = 'suppliers' then
           if new.credit_limit_amount is distinct from old.credit_limit_amount
              or new.credit_limit_currency_code is distinct from old.credit_limit_currency_code
           then
               v_perms := array['MANAGE_SUPPLIER_CREDIT'];
           end if;
       end if;

       -- LEAD-1 (202607061900). The handler rule, evaluated ONLY inside its own table branch so
       -- `new.assigned_user_id` is never named while this trigger is serving `suppliers` or `customers`.
       -- TWO CHANGES FROM THE FORM THIS REPLACES, both from BOOK-5's standing question:
       --   * MOVING THE ASSIGNMENT is authority, not content, and it costs what the two RPCs that do it
       --     charge. REPLACES the permission set (the `suppliers` shape): every role holding either key
       --     also holds CREATE_LEAD, so nothing legitimate loses a door.
       --   * THE SHORTCUT READS `old`. Reading `new` let the attacking statement supply the answer to
       --     "are you the handler?" and skip the entire check for every column in the statement.
       if tg_op = 'UPDATE' and tg_table_name = 'leads' then
           if new.assigned_user_id is distinct from old.assigned_user_id
              or new.owner_user_id is distinct from old.owner_user_id then
               v_perms := array['ASSIGN_LEAD','REASSIGN_LEAD'];
           else
               v_relationship_ok := (select app.current_user_id()) is not null
                                    and (select app.current_user_id())
                                        in (old.assigned_user_id, old.owner_user_id);
           end if;
       end if;

       if v_relationship_ok then
           return new;
       end if;

       if v_perms is null then
           raise exception 'guard_write_capability has no permission mapping for %', tg_table_name
               using errcode = 'insufficient_privilege';
       end if;

       foreach v_perm in array v_perms loop
           if app.has_permission(v_perm) then
               v_held := v_perm;
               exit;
           end if;
       end loop;

       if v_held is null then
           raise exception 'permission denied: one of % is required to write %',
                           array_to_string(v_perms, ' or '), tg_table_name
               using errcode = 'insufficient_privilege';
       end if;

       perform app.authorize(v_held);
       return new;
   end;
   $function$;

   create trigger campaign_daily_metrics_guard_write_capability
       before insert or update on public.campaign_daily_metrics
       for each row execute function app.guard_write_capability();

   create trigger exchange_rate_adjustments_guard_write_capability
       before insert or update on public.exchange_rate_adjustments
       for each row execute function app.guard_write_capability();

   create function app.guard_booking_item_entry_state()
   returns trigger
   language plpgsql
   set search_path = ''
   as $fn$
   begin
       if (select auth.uid()) is null then
           return new;
       end if;
       raise exception using
           errcode = '23514',
           message = 'a booking item is created at ''draft'' with no lifecycle stamp (canon 26); '
                     'use app.advance_booking_item to move it';
   end;
   $fn$;

   revoke all on function app.guard_booking_item_entry_state() from public;

   create trigger booking_items_guard_entry_state
   before insert on public.booking_items
   for each row
   when (new.base_status_code is distinct from 'draft'
         or new.completed_at is not null
         or new.cancelled_at is not null
         or new.cancelled_by is not null
         or new.no_show_at is not null
         or new.no_show_recorded_by is not null)
   execute function app.guard_booking_item_entry_state();
   ```

   The resulting file's Git blob is fc317dda36df2d5540bad2ba6afcabbf9d2e8867.

6. Check whether `supabase/migrations/20261121110000_a_refund_a_conversation_and_a_settlement_are_recorded_on_every_door.sql` contains `-- B6-EXIT bundle B: a refund's life, a conversation's life and an invoice's settlement are produced by`; if so record Already Applied when its Git blob is 52bb1f1577f4346b439a1c33c47b233de5d4935d, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (migration 6 (CRM SPEC-326): a refund, a conversation and a settlement are recorded on every door), and change nothing else:

   ```text
   -- B6-EXIT bundle B: a refund's life, a conversation's life and an invoice's settlement are produced by
   -- the table, so the table door records them exactly as the RPC door does.
   --
   -- `authenticated` holds table-level INSERT and UPDATE on `public.refunds`, `public.conversations` and
   -- `public.payment_allocations`, and `app.record_refund`, `app.advance_refund`,
   -- `app.advance_conversation` and `app.record_payment` are SECURITY INVOKER through those same grants,
   -- so PostgREST serves each table beside its RPC. Measured at `7c5975a` on the local stack in
   -- rolled-back transactions (Workbench data/records/batch6/exit-bundle-b/repro-7c5975a.sql):
   --   * RFD-3: an aal2 finance_manager inserted a refund `requested`, then moved it `approved` and
   --     `completed` at the table: 0 events. The RPC door recorded refund_requested, refund_approved and
   --     refund_completed (warning) with their reasons. `completed_at` is already server-stamped on both
   --     doors by `app.guard_refund_integrity`.
   --   * CHAT-2: an employee moved a conversation `open -> assigned -> closed -> open` at the table: no
   --     transition event (only conversation_started), `closed_at` left null after the close, and the
   --     reopen accepted with no reason. The RPC recorded assigned, closed and reopened, all at `info`,
   --     where canon 26 and 27 require a reopen reason and make `conversation_escalated` and
   --     `conversation_reopened` warnings. The employee's direct escalate was already refused 42501 by
   --     the per-edge transition guard: authority needs no change.
   --   * PAY-5 / FIN-11: an aal2 owner inserted a 5000 payment and a 5000 allocation against a 5000
   --     invoice: the invoice stayed `issued`, 0 invoice events, and `payment_recorded` reported
   --     `invoice_new_status` `issued`. `app.record_payment` alone derived `paid` and emitted
   --     invoice_paid, so the settlement belonged to one door instead of the table.
   --
   -- THE SHAPE is SPEC-262's (`20261011090000`): SECURITY INVOKER guard and producers; one AFTER producer
   -- per event, and its RPC loses its own `record_event`, so no act is recorded twice; the RPC's reason
   -- reaches the guard and the producer through SPEC-237's transaction-local `app.transition_reason`
   -- (`20260928160000`), which the producer consumes. The conversation guard is signed-in only (canon 35
   -- principle 6): it stamps `closed_at` as the RPC does and refuses a reopen without a reason. The
   -- settlement producer is record_payment's own derivation moved onto `payment_allocations`: under the
   -- same per-invoice advisory lock it sums the allocations, sets `paid` / `partially_paid` and emits
   -- invoice_paid / invoice_partially_paid with the same payload. Its invoice UPDATE runs as the caller,
   -- exactly as record_payment's did, so `app.enforce_status_transition` still charges RECORD_PAYMENT and
   -- `app.guard_financial_capability` still prices it. A raised allocation re-derives forward; nothing
   -- walks a settled invoice back (no such edge exists). The trigger sorts after
   -- `payment_allocations_emit_created`, so the allocation is recorded before the settlement it causes.
   --
   -- NOT CHANGED: every grant, policy, permission charge, state transition and other trigger; the
   -- reasons and payloads each event already carried; the refund severities (completed stays warning);
   -- record_payment's validations, lock, outstanding check and inserts.

   -- ===================================================================== RFD-3 refunds
   create or replace function app.emit_refund_requested()
   returns trigger
   language plpgsql
   security invoker
   set search_path = ''
   as $$
   begin
       perform app.record_event(
           new.tenant_id, 'refund_requested', 'refund', new.id,
           case when (select auth.uid()) is null then null else app.current_user_id() end,
           null, new.refund_status_code, new.refund_reason_code,
           jsonb_build_object('customer_id', new.customer_id, 'booking_id', new.booking_id,
                              'amount', new.amount, 'currency_code', new.currency_code),
           'info');
       return null;
   end;
   $$;
   revoke execute on function app.emit_refund_requested() from public;

   create trigger refunds_emit_requested
   after insert on public.refunds
   for each row execute function app.emit_refund_requested();

   create or replace function app.emit_refund_transition()
   returns trigger
   language plpgsql
   security invoker
   set search_path = ''
   as $$
   declare
       v_reason text := nullif(current_setting('app.transition_reason', true), '');
       v_event text;
   begin
       -- Consumed: a later transition in the same transaction carries only its own reason.
       perform set_config('app.transition_reason', '', true);
       v_event := case new.refund_status_code
           when 'approved' then 'refund_approved'
           when 'rejected' then 'refund_rejected'
           when 'cancelled' then 'refund_cancelled'
           when 'processing' then 'refund_processing'
           when 'completed' then 'refund_completed'
       end;
       if v_event is null then
           return null;
       end if;
       perform app.record_event(
           new.tenant_id, v_event, 'refund', new.id,
           case when (select auth.uid()) is null then null else app.current_user_id() end,
           old.refund_status_code, new.refund_status_code, v_reason,
           jsonb_build_object('customer_id', new.customer_id, 'amount', new.amount,
                              'currency_code', new.currency_code),
           case when new.refund_status_code = 'completed' then 'warning' else 'info' end);
       return null;
   end;
   $$;
   revoke execute on function app.emit_refund_transition() from public;

   create trigger refunds_emit_transition
   after update of refund_status_code on public.refunds
   for each row
   when (new.refund_status_code is distinct from old.refund_status_code)
   execute function app.emit_refund_transition();

   -- The complete current SECURITY INVOKER RPC, removing only its event call.
   create or replace function app.record_refund(
       p_customer_id uuid,
       p_amount numeric,
       p_currency_code text,
       p_refund_reason_code text,
       p_booking_id uuid default null,
       p_original_payment_id uuid default null
   )
   returns uuid
   language plpgsql
   security invoker
   set search_path = ''
   as $$
   declare
       v_tenant uuid := app.current_tenant_id();
       v_actor uuid;
       v_refund_id uuid;
   begin
       if v_tenant is null then
           raise exception 'no active tenant for caller';
       end if;
       if p_amount is null or p_amount <= 0 then
           raise exception 'refund amount must be greater than zero';
       end if;
       if not exists (
           select 1 from public.catalog_values
           where catalog_type_code = 'refund_reason_code' and code = p_refund_reason_code
       ) then
           raise exception 'unknown refund_reason: %', p_refund_reason_code;
       end if;

       perform 1 from public.customers where id = p_customer_id and tenant_id = v_tenant;
       if not found then
           raise exception 'customer is not in your tenant';
       end if;
       if p_booking_id is not null then
           perform 1 from public.bookings where id = p_booking_id and tenant_id = v_tenant;
           if not found then
               raise exception 'booking is not in your tenant';
           end if;
       end if;
       if p_original_payment_id is not null then
           perform 1 from public.payments where id = p_original_payment_id and tenant_id = v_tenant;
           if not found then
               raise exception 'original payment is not in your tenant';
           end if;
       end if;

       perform app.authorize('RECORD_REFUND');

       select id into v_actor
       from public.users
       where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

       -- RFD-3: `refund_requested` is produced by `refunds_emit_requested` on every door.
       insert into public.refunds (
           tenant_id, payment_direction_code, original_payment_id, customer_id, booking_id,
           refund_reason_code, currency_code, amount, refund_status_code, requested_at, created_by
       ) values (
           v_tenant, 'customer_refund', p_original_payment_id, p_customer_id, p_booking_id,
           p_refund_reason_code, p_currency_code, p_amount, 'requested', now(), v_actor
       ) returning id into v_refund_id;

       return v_refund_id;
   end;
   $$;

   -- The complete current SECURITY INVOKER RPC, removing only its event call; its reason reaches
   -- `refunds_emit_transition` through `app.transition_reason`.
   create or replace function app.advance_refund(
       p_refund_id uuid,
       p_to_status text,
       p_reason text default null
   )
   returns text
   language plpgsql
   security invoker
   set search_path = ''
   as $$
   declare
       v_tenant uuid := app.current_tenant_id();
       v_rf record;
       v_event text;
   begin
       if v_tenant is null then
           raise exception 'no active tenant for caller';
       end if;

       select id, refund_status_code, customer_id, amount, currency_code
         into v_rf
       from public.refunds
       where id = p_refund_id and tenant_id = v_tenant;
       if not found then
           raise exception 'refund is not in your tenant';
       end if;

       select t.ev into v_event
       from (values
           ('requested',  'approved',   'refund_approved'),
           ('requested',  'rejected',   'refund_rejected'),
           ('requested',  'cancelled',  'refund_cancelled'),
           ('approved',   'processing', 'refund_processing'),
           ('approved',   'completed',  'refund_completed'),
           ('approved',   'cancelled',  'refund_cancelled'),
           ('processing', 'completed',  'refund_completed'),
           ('processing', 'cancelled',  'refund_cancelled')
       ) as t(frm, to_s, ev)
       where t.frm = v_rf.refund_status_code and t.to_s = p_to_status;

       if v_event is null then
           raise exception 'refund transition not allowed: % -> %', v_rf.refund_status_code, p_to_status;
       end if;

       perform app.authorize('RECORD_REFUND');

       perform set_config('app.transition_reason', coalesce(p_reason, ''), true);
       update public.refunds
       set refund_status_code = p_to_status,
           completed_at = case when p_to_status = 'completed' then now() else completed_at end,
           updated_at = now()
       where id = p_refund_id;

       return p_to_status;
   end;
   $$;

   -- ===================================================================== CHAT-2 conversations
   create or replace function app.guard_conversation_transition()
   returns trigger
   language plpgsql
   security invoker
   set search_path = ''
   as $$
   declare
       v_reason text;
       v_entered boolean;
   begin
       -- Session-less platform writes keep their latitude (canon 35 principle 6).
       if (select auth.uid()) is null then
           return new;
       end if;
       v_entered := new.conversation_status_code is distinct from old.conversation_status_code;
       if v_entered and old.conversation_status_code = 'closed' and new.conversation_status_code = 'open' then
           v_reason := nullif(btrim(current_setting('app.transition_reason', true)), '');
           if v_reason is null then
               raise exception 'a closed conversation is reopened with a reason (canon 26, 27); use app.advance_conversation with p_reason'
                   using errcode = '23514';
           end if;
       end if;
       -- The server stamps closed_at, as app.advance_conversation does.
       new.closed_at := case
           when v_entered and new.conversation_status_code = 'closed' then now()
           when v_entered and new.conversation_status_code = 'open' then null
           else old.closed_at
       end;
       return new;
   end;
   $$;
   revoke execute on function app.guard_conversation_transition() from public;

   create trigger conversations_guard_transition
   before update on public.conversations
   for each row execute function app.guard_conversation_transition();

   create or replace function app.emit_conversation_transition()
   returns trigger
   language plpgsql
   security invoker
   set search_path = ''
   as $$
   declare
       v_reason text := nullif(current_setting('app.transition_reason', true), '');
       v_reopen boolean := old.conversation_status_code = 'closed'
                           and new.conversation_status_code = 'open';
       v_event text;
   begin
       -- Consumed: a later transition in the same transaction carries only its own reason.
       perform set_config('app.transition_reason', '', true);
       v_event := case
           when v_reopen then 'conversation_reopened'
           else case new.conversation_status_code
               when 'assigned' then 'conversation_assigned'
               when 'escalated' then 'conversation_escalated'
               when 'closed' then 'conversation_closed'
           end
       end;
       -- 26_state_machines.md: the pending_* moves require no event.
       if v_event is null then
           return null;
       end if;
       perform app.record_event(
           new.tenant_id, v_event, 'conversation', new.id,
           case when (select auth.uid()) is null then null else app.current_user_id() end,
           old.conversation_status_code, new.conversation_status_code, v_reason, null,
           case when v_reopen or new.conversation_status_code = 'escalated' then 'warning' else 'info' end);
       return null;
   end;
   $$;
   revoke execute on function app.emit_conversation_transition() from public;

   create trigger conversations_emit_transition
   after update of conversation_status_code on public.conversations
   for each row
   when (new.conversation_status_code is distinct from old.conversation_status_code)
   execute function app.emit_conversation_transition();

   -- The complete current SECURITY INVOKER RPC, removing only its event call; its reason reaches the
   -- guard and `conversations_emit_transition` through `app.transition_reason`.
   create or replace function app.advance_conversation(
       p_conversation_id uuid,
       p_to_status text,
       p_reason text default null
   )
   returns void
   language plpgsql
   security invoker
   set search_path = ''
   as $$
   declare
       v_tenant uuid := app.current_tenant_id();
       v_status text;
       v_event text;
       v_perm text;
       v_matched boolean := false;
   begin
       if v_tenant is null then raise exception 'no active tenant for caller'; end if;

       select conversation_status_code into v_status
       from public.conversations where id = p_conversation_id and tenant_id = v_tenant;
       if v_status is null then raise exception 'conversation not found in your tenant'; end if;

       -- 26_state_machines.md, Conversation State Machine. ev is null where canon requires no event.
       select true, t.ev, t.perm into v_matched, v_event, v_perm
       from (values
           ('open',             'assigned',         'conversation_assigned',  'SEND_MESSAGE'),
           ('assigned',         'pending_customer',  null,                    'SEND_MESSAGE'),
           ('assigned',         'pending_internal',  null,                    'SEND_MESSAGE'),
           ('pending_customer', 'assigned',         'conversation_assigned',  'SEND_MESSAGE'),
           ('pending_internal', 'assigned',         'conversation_assigned',  'SEND_MESSAGE'),
           ('assigned',         'escalated',        'conversation_escalated', 'ESCALATE_CONVERSATION'),
           ('escalated',        'assigned',         'conversation_assigned',  'ESCALATE_CONVERSATION'),
           ('assigned',         'closed',           'conversation_closed',    'CLOSE_CONVERSATION'),
           ('pending_customer', 'closed',           'conversation_closed',    'CLOSE_CONVERSATION'),
           ('escalated',        'closed',           'conversation_closed',    'CLOSE_CONVERSATION'),
           ('closed',           'open',             'conversation_reopened',  'CLOSE_CONVERSATION')
       ) as t(frm, to_s, ev, perm)
       where t.frm = v_status and t.to_s = p_to_status;

       if not v_matched then
           raise exception 'invalid conversation transition % -> %', v_status, p_to_status; end if;
       perform app.authorize(v_perm);

       perform set_config('app.transition_reason', coalesce(p_reason, ''), true);
       update public.conversations
       set conversation_status_code = p_to_status,
           closed_at = case when p_to_status = 'closed' then now()
                            when p_to_status = 'open' then null else closed_at end,
           updated_at = now()
       where id = p_conversation_id and tenant_id = v_tenant;
   end;
   $$;

   -- ===================================================================== PAY-5 / FIN-11 settlement
   create or replace function app.derive_invoice_payment_status()
   returns trigger
   language plpgsql
   security invoker
   set search_path = ''
   as $$
   declare
       v_inv record;
       v_total numeric;
       v_new text;
   begin
       -- Forward only: a raised allocation re-derives; a lowered one never walks a settlement back.
       if tg_op = 'UPDATE' and coalesce(new.allocated_amount_invoice_currency, new.allocated_amount)
                               <= coalesce(old.allocated_amount_invoice_currency, old.allocated_amount) then
           return null;
       end if;
       -- A zero allocation settles nothing: it moves no status and records no settlement.
       if tg_op = 'INSERT' and coalesce(new.allocated_amount_invoice_currency, new.allocated_amount) <= 0 then
           return null;
       end if;

       -- record_payment's own serialisation: concurrent allocations to one invoice settle in turn.
       perform pg_advisory_xact_lock(hashtextextended(new.invoice_id::text, 0));

       select id, status_code, total_amount into v_inv
       from public.invoices
       where id = new.invoice_id and tenant_id = new.tenant_id;
       if not found or v_inv.status_code not in ('issued', 'partially_paid', 'overdue') then
           return null;
       end if;

       select coalesce(sum(coalesce(pa.allocated_amount_invoice_currency, pa.allocated_amount)), 0)
         into v_total
       from public.payment_allocations pa
       where pa.invoice_id = new.invoice_id and pa.tenant_id = new.tenant_id;

       v_new := case when v_total >= v_inv.total_amount then 'paid' else 'partially_paid' end;

       update public.invoices
       set status_code = v_new,
           updated_at = now()
       where id = new.invoice_id and tenant_id = new.tenant_id;
       if not found then
           -- Fail closed: an allocation never stands beside an invoice its writer could not settle.
           raise exception 'invoice % could not be settled by this caller', new.invoice_id
               using errcode = '42501';
       end if;

       perform app.record_event(
           new.tenant_id,
           case when v_new = 'paid' then 'invoice_paid' else 'invoice_partially_paid' end,
           'invoice', new.invoice_id,
           case when (select auth.uid()) is null then null else app.current_user_id() end,
           v_inv.status_code, v_new, null,
           jsonb_build_object('payment_id', new.payment_id, 'allocated_total', v_total,
                              'total_amount', v_inv.total_amount),
           'info');
       return null;
   end;
   $$;
   revoke execute on function app.derive_invoice_payment_status() from public;

   create trigger payment_allocations_settle_invoice
   after insert or update of allocated_amount, allocated_amount_invoice_currency on public.payment_allocations
   for each row execute function app.derive_invoice_payment_status();

   -- The complete current SECURITY INVOKER RPC, removing only its settlement: the invoice status and its
   -- event are produced by `payment_allocations_settle_invoice` from the allocation below.
   create or replace function app.record_payment(
       p_invoice_id uuid,
       p_amount numeric,
       p_payment_method_code text,
       p_paid_at timestamptz default now(),
       p_reference_number text default null
   )
   returns uuid
   language plpgsql
   security invoker
   set search_path = ''
   as $$
   declare
       v_tenant uuid := app.current_tenant_id();
       v_actor uuid;
       v_inv record;
       v_already numeric;
       v_remaining numeric;
       v_payment_id uuid;
   begin
       if v_tenant is null then
           raise exception 'no active tenant for caller';
       end if;
       if p_amount is null or p_amount <= 0 then
           raise exception 'payment amount must be greater than zero';
       end if;
       if not exists (
           select 1 from public.catalog_values
           where catalog_type_code = 'payment_method' and code = p_payment_method_code
       ) then
           raise exception 'unknown payment_method: %', p_payment_method_code;
       end if;

       select id, customer_id, currency_code, total_amount, status_code, voided_at, is_archived
         into v_inv
       from public.invoices
       where id = p_invoice_id and tenant_id = v_tenant;
       if not found then
           raise exception 'invoice is not in your tenant';
       end if;
       if v_inv.is_archived or v_inv.voided_at is not null then
           raise exception 'invoice is archived or voided';
       end if;
       if v_inv.status_code not in ('issued', 'partially_paid', 'overdue') then
           raise exception 'only an issued/partially_paid/overdue invoice can be paid (is %)', v_inv.status_code;
       end if;

       perform app.authorize('RECORD_PAYMENT');

       -- Serialise allocation for this invoice so concurrent payments cannot over-allocate.
       perform pg_advisory_xact_lock(hashtextextended(p_invoice_id::text, 0));

       select coalesce(sum(coalesce(pa.allocated_amount_invoice_currency, pa.allocated_amount)), 0) into v_already
       from public.payment_allocations pa
       where pa.invoice_id = p_invoice_id and pa.tenant_id = v_tenant;

       v_remaining := v_inv.total_amount - v_already;
       if p_amount > v_remaining then
           raise exception 'payment % exceeds invoice outstanding % (total %, already allocated %)',
               p_amount, v_remaining, v_inv.total_amount, v_already;
       end if;

       select id into v_actor
       from public.users
       where auth_user_id = (select auth.uid()) and tenant_id = v_tenant;

       insert into public.payments (
           tenant_id, payment_direction_code, customer_id, currency_code,
           payment_method_code, reference_number, amount, paid_at, received_by, created_by
       ) values (
           v_tenant, 'customer_payment', v_inv.customer_id, v_inv.currency_code,
           p_payment_method_code, p_reference_number, p_amount, p_paid_at, v_actor, v_actor
       ) returning id into v_payment_id;

       -- PAY-5 / FIN-11: `payment_allocations_settle_invoice` moves the invoice to partially_paid / paid
       -- and records invoice_partially_paid / invoice_paid on every door.
       insert into public.payment_allocations (
           tenant_id, payment_id, invoice_id, allocated_amount, currency_code, created_by
       ) values (
           v_tenant, v_payment_id, p_invoice_id, p_amount, v_inv.currency_code, v_actor
       );

       -- PAY-3: `payment_recorded` is produced at commit by `payments_emit_recorded` on every door,
       -- from this payment and the allocation above.

       return v_payment_id;
   end;
   $$;
   ```

   The resulting file's Git blob is 52bb1f1577f4346b439a1c33c47b233de5d4935d.

7. Check whether `supabase/migrations/20261122100000_a_ledger_entry_balances_in_one_currency_and_a_payment_carries_value.sql` contains `-- B6-EXIT bundle C: a ledger entry balances in one currency, and a payment row carries value.`; if so record Already Applied when its Git blob is 606ce8ad8a5d8bf928cb11b920fbae0e79714a9b, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (migration 7 (CRM SPEC-328): a ledger entry balances in one currency and a payment carries value), and change nothing else:

   ```text
   -- B6-EXIT bundle C: a ledger entry balances in one currency, and a payment row carries value.
   --
   -- The CRM Action Registry makes `journal_entry_lines`, `payments` and `payment_allocations` B6-EXIT
   -- surfaces. Measured at `17ec05a` on the local stack in rolled-back transactions (Workbench
   -- data/records/batch6/finance-evidence/repro-17ec05a.sql):
   --   * JE-2: `app.create_journal_entry` accepted a 100 USD debit against a 100 EGP credit, and the
   --     deferred `app.enforce_journal_entry_balanced` committed it, because both sum debit and credit
   --     across currencies. The registry's named exit option is the fail-closed containment: refuse a
   --     mixed-currency entry until DC-11 decides the model. It lives in the deferred balance trigger,
   --     which already judges both doors (the RPC and the platform's direct DML), so one control covers
   --     both. It is a refusal in a replaceable function, NOT a structural CHECK: DC-11's translation
   --     model (a transaction-currency amount, a rate and a functional-currency amount per line, IAS 21
   --     paragraph 21) replaces this branch with a functional-currency balance and forecloses nothing.
   --   * PAY-4: an owner's direct INSERT persisted a `payments` row with amount 0 coded
   --     `customer_refund`. Every sanctioned door that writes a payment -- `app.record_payment` and
   --     `app.record_supplier_payment` -- refuses an amount that is not greater than zero, and the
   --     refund model's own door, `app.record_refund`, writes `refunds`, not `payments`, under the same
   --     rule. The entry-shape rule derived from them: a payment row carries value, `amount > 0`, on
   --     every door.
   --
   -- NOT CHANGED: every grant, policy, trigger binding, permission charge and event; the three balance
   -- rules (at least two lines, debits equal credits, non-zero total); the RPCs' bodies; the direction
   -- column (rewriting a payment's direction is PAY-2's capability charge, already in force);
   -- `payments_amount_nonneg_check`, which the new rule implies and which is kept rather than rewritten.
   -- Primary carried 0 payments and 0 journal lines when read, so the new CHECK validates on deploy.

   create or replace function app.enforce_journal_entry_balanced()
    RETURNS trigger
    LANGUAGE plpgsql
    SECURITY DEFINER
    SET search_path TO ''
   AS $function$
   declare
       v_entries uuid[];
       v_entry uuid;
       v_debit numeric;
       v_credit numeric;
       v_lines int;
       v_currencies text[];
   begin
       -- DELETE carries no NEW; the affected entry is the one the removed row pointed at. A line that
       -- moved between entries affects both (JE-4).
       -- Sorted, so two transactions moving lines between the same two entries lock them in one order.
       select array_agg(distinct x order by x) into v_entries
         from unnest(case tg_table_name
                       when 'journal_entries'      then array[coalesce((to_jsonb(new) ->> 'id')::uuid,
                                                                       (to_jsonb(old) ->> 'id')::uuid)]
                       when 'journal_entry_lines'  then array[(to_jsonb(new) ->> 'journal_entry_id')::uuid,
                                                              (to_jsonb(old) ->> 'journal_entry_id')::uuid]
                     end) x
        where x is not null;
       if v_entries is null then
           return null;
       end if;

       foreach v_entry in array v_entries
       loop
           -- The entry may have been deleted in this same transaction (lines first, then the entry,
           -- because the FK is ON DELETE RESTRICT). Removing a whole entry is legitimate; there is
           -- nothing left to balance, so skip rather than refuse. The lock serializes two transactions
           -- that change one entry's lines, so each counts the other's committed lines (JE-4).
           perform 1 from public.journal_entries je where je.id = v_entry for no key update;
           continue when not found;

           select coalesce(sum(l.debit_amount), 0), coalesce(sum(l.credit_amount), 0), count(*),
                  array_agg(distinct l.currency_code order by l.currency_code)
             into v_debit, v_credit, v_lines, v_currencies
           from public.journal_entry_lines l
           where l.journal_entry_id = v_entry;

           -- JE-2 containment (B6-EXIT bundle C). The sums below are only meaningful in one currency:
           -- until DC-11 decides the translation model, an entry whose lines carry more than one
           -- currency is refused rather than "balanced" across currencies. Judged first, so the
           -- refusal names the cause and not a misleading total.
           if cardinality(v_currencies) > 1 then
               raise exception 'journal entry % mixes currencies (%): an entry balances in one currency until DC-11 decides the translation model (JE-2)',
                   v_entry, array_to_string(v_currencies, ', ') using errcode = '23514';
           end if;

           -- The three rules below are COPIED from app.create_journal_entry, not chosen here.
           if v_lines < 2 then
               raise exception 'journal entry % has % line(s): a double-entry record requires at least two',
                   v_entry, v_lines using errcode = '23514';
           end if;
           if v_debit <> v_credit then
               raise exception 'journal entry % is not balanced: debits % <> credits %',
                   v_entry, v_debit, v_credit using errcode = '23514';
           end if;
           if v_debit = 0 then
               raise exception 'journal entry % totals zero', v_entry using errcode = '23514';
           end if;
       end loop;

       return null;
   end;
   $function$;

   alter table public.payments
       add constraint payments_amount_positive_check check (amount > 0);
   ```

   The resulting file's Git blob is 606ce8ad8a5d8bf928cb11b920fbae0e79714a9b.

8. Check whether `supabase/tests/182_archive_authority_applies_at_entry_test.sql` contains `select plan(32);`; if so record Already Applied when its Git blob is 5ffffdeb43e3ae777957cafbb35fac99fdbc2e48, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 182, 32 assertions), and change nothing else:

   ```text
   -- ARCH-2: the same archive authority must govern entry on every selected surface.
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(32);

   insert into auth.users (id, email) values
       ('18200000-0000-0000-0000-0000000000a1', 'senior@archive.test'),
       ('18200000-0000-0000-0000-0000000000a2', 'owner@archive.test');
   insert into public.tenants (id, name, slug, status)
   values ('18200000-0000-0000-0000-000000000001', 'Archive entry test', 'archive-entry-test', 'active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select '18200000-0000-0000-0000-000000000001', id, 'active'
   from public.subscription_plans
   where plan_code = 'enterprise';
   insert into public.branches (id, tenant_id, name, slug)
   values ('18200000-0000-0000-0000-00000000000a', '18200000-0000-0000-0000-000000000001', 'Cairo', 'archive-entry-cairo');
   insert into public.departments (id, tenant_id, branch_id, department_type_code, name)
   values ('18200000-0000-0000-0000-00000000000b', '18200000-0000-0000-0000-000000000001', '18200000-0000-0000-0000-00000000000a', 'sales', 'Sales');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id)
   values
       ('18200000-0000-0000-0000-000000000011', '18200000-0000-0000-0000-000000000001', 'Senior', 'senior@archive.test', true, '18200000-0000-0000-0000-0000000000a1'),
       ('18200000-0000-0000-0000-000000000012', '18200000-0000-0000-0000-000000000001', 'Owner', 'owner@archive.test', true, '18200000-0000-0000-0000-0000000000a2');
   insert into public.user_branch_assignments (tenant_id, user_id, branch_id, department_id, is_primary)
   select tenant_id, id, '18200000-0000-0000-0000-00000000000a', '18200000-0000-0000-0000-00000000000b', true
   from public.users where tenant_id = '18200000-0000-0000-0000-000000000001';
   insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type)
   select '18200000-0000-0000-0000-000000000001', v.user_id, r.id, 'tenant'
   from (values
       ('18200000-0000-0000-0000-000000000011'::uuid, 'senior_employee'),
       ('18200000-0000-0000-0000-000000000012'::uuid, 'owner')
   ) v(user_id, role_code)
   join public.roles r on r.code = v.role_code;

   insert into public.customers (id, tenant_id, customer_type_code, full_name)
   values ('18200000-0000-0000-0000-0000000000c1', '18200000-0000-0000-0000-000000000001', 'person', 'Archive Test Customer');

   -- Same archive inputs on each real entry shape. The task fixture stays in the allowed open state.
   create temporary table archive_entry_cases (surface text primary key, statement text not null);
   insert into archive_entry_cases values
       ('bookings', $sql$insert into public.bookings
           (id, tenant_id, branch_id, department_id, customer_id, owner_user_id, owner_branch_id,
            owner_department_id, booking_status_code, title, booking_reference, is_archived, archive_reason, archived_at, archived_by)
           values (%1$L, '18200000-0000-0000-0000-000000000001', '18200000-0000-0000-0000-00000000000a',
            '18200000-0000-0000-0000-00000000000b', '18200000-0000-0000-0000-0000000000c1',
            app.current_user_id(), '18200000-0000-0000-0000-00000000000a', '18200000-0000-0000-0000-00000000000b',
            'draft', 'Archive entry booking', %1$L, %2$L, %3$L, %4$L, %5$L)$sql$),
       ('customers', $sql$insert into public.customers
           (id, tenant_id, customer_type_code, full_name, is_archived, archive_reason, archived_at, archived_by)
           values (%1$L, '18200000-0000-0000-0000-000000000001', 'person', 'Archive entry customer', %2$L, %3$L, %4$L, %5$L)$sql$),
       ('passengers', $sql$insert into public.passengers
           (id, tenant_id, first_name, family_name, full_name, passenger_type_code, is_archived, archive_reason, archived_at, archived_by)
           values (%1$L, '18200000-0000-0000-0000-000000000001', 'Archive', 'Passenger', 'Archive Passenger',
            'adult', %2$L, %3$L, %4$L, %5$L)$sql$),
       ('suppliers', $sql$insert into public.suppliers
           (id, tenant_id, name, supplier_type_code, is_archived, archive_reason, archived_at, archived_by)
           values (%1$L, '18200000-0000-0000-0000-000000000001', 'Archive entry supplier ' || %1$L,
            'airline', %2$L, %3$L, %4$L, %5$L)$sql$),
       ('tasks', $sql$insert into public.tasks
           (id, tenant_id, owner_user_id, owner_department_id, owner_branch_id, task_type_code, task_status_code, title,
            is_archived, archive_reason, archived_at, archived_by)
           values (%1$L, '18200000-0000-0000-0000-000000000001', app.current_user_id(),
            '18200000-0000-0000-0000-00000000000b', '18200000-0000-0000-0000-00000000000a', 'follow_up', 'open',
            'Archive entry task', %2$L, %3$L, %4$L, %5$L)$sql$);
   grant select on archive_entry_cases to authenticated;

   select set_config('request.jwt.claims','{"sub":"18200000-0000-0000-0000-0000000000a1","aal":"aal2"}',true);
   set local role authenticated;
   select ok(app.has_permission('ASSIGN_SUPPLIER') and app.has_permission('CREATE_BOOKING')
             and app.has_permission('CREATE_BOOKING_ITEM') and app.has_permission('CREATE_TASK')
             and app.has_permission('CREATE_CUSTOMER') and not app.has_permission('ARCHIVE_RECORD'),
             'senior can create on all selected paths and has no archive authority');
   select lives_ok(format(statement, '18200000-0000-0000-0000-000000000101', false, null, null, null),
                   surface || ': ordinary creation succeeds') from archive_entry_cases order by surface;
   select throws_ok(format(statement, '18200000-0000-0000-0000-000000000102', true, 'reported', null, null),
                    '42501', 'permission denied: ARCHIVE_RECORD',
                    surface || ': creating archived requires archive authority') from archive_entry_cases order by surface;
   select throws_ok(format(statement, '18200000-0000-0000-0000-000000000103', false, 'reported', null, null),
                    '42501', 'permission denied: ARCHIVE_RECORD',
                    surface || ': an archive reason alone requires archive authority') from archive_entry_cases order by surface;
   select throws_ok(format(statement, '18200000-0000-0000-0000-000000000104', false, null, '2020-01-01',
                     '18200000-0000-0000-0000-000000000012'),
                    '42501', 'archive metadata is set by the server',
                    surface || ': an active row cannot claim archive metadata') from archive_entry_cases order by surface;

   select set_config('request.jwt.claims','{"sub":"18200000-0000-0000-0000-0000000000a2","aal":"aal2"}',true);
   select ok(app.has_permission('ARCHIVE_RECORD'), 'owner holds archive authority');
   select lives_ok(format(statement, '18200000-0000-0000-0000-000000000105', true, 'approved', '2020-01-01',
                    '18200000-0000-0000-0000-000000000011'),
                   surface || ': authorized creation may archive and supply a reason') from archive_entry_cases order by surface;
   reset role;

   select results_eq(
       format('select is_archived, archive_reason, archived_at = now(), archived_by from public.%I where id = %L',
              surface, '18200000-0000-0000-0000-000000000105'),
       $$values (true, 'approved'::text, true, '18200000-0000-0000-0000-000000000012'::uuid)$$,
       surface || ': archived actor and time come from the server'
   ) from archive_entry_cases order by surface;

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is 5ffffdeb43e3ae777957cafbb35fac99fdbc2e48.

9. Check whether `supabase/tests/183_entry_and_step_up_hold_at_the_table_door_test.sql` contains `select plan(30);`; if so record Already Applied when its Git blob is d11dea50c36e8dcc1e418251125358ad0377e87b, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 183, 30 assertions), and change nothing else:

   ```text
   -- B6-EXIT bundle A: ARCH-2 archive authority at entry on leads, quotations, booking_items and
   -- invoices; STEPUP-1 step-up on campaign_daily_metrics and exchange_rate_adjustments; ENTRY-1
   -- booking items enter at 'draft' with no lifecycle stamp. Each refused case below passed at 73b02a1.
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(30);

   insert into auth.users (id, email) values
       ('18300000-0000-0000-0000-0000000000a1', 'owner@entry183.test'),
       ('18300000-0000-0000-0000-0000000000a2', 'finance@entry183.test'),
       ('18300000-0000-0000-0000-0000000000a3', 'emp@entry183.test');
   insert into public.tenants (id, name, slug, status)
   values ('18300000-0000-0000-0000-000000000001', 'Entry 183 Travel', 'entry-183', 'active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select '18300000-0000-0000-0000-000000000001', id, 'active'
   from public.subscription_plans where plan_code = 'enterprise';
   insert into public.branches (id, tenant_id, name, slug)
   values ('18300000-0000-0000-0000-00000000000a', '18300000-0000-0000-0000-000000000001', 'HQ', 'entry-183-hq');
   insert into public.departments (id, tenant_id, branch_id, department_type_code, name)
   values ('18300000-0000-0000-0000-00000000000b', '18300000-0000-0000-0000-000000000001',
           '18300000-0000-0000-0000-00000000000a', 'management', 'Exec');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
       ('18300000-0000-0000-0000-000000000011', '18300000-0000-0000-0000-000000000001', 'Owner', 'owner@entry183.test', true, '18300000-0000-0000-0000-0000000000a1'),
       ('18300000-0000-0000-0000-000000000012', '18300000-0000-0000-0000-000000000001', 'Finance', 'finance@entry183.test', true, '18300000-0000-0000-0000-0000000000a2'),
       ('18300000-0000-0000-0000-000000000013', '18300000-0000-0000-0000-000000000001', 'Emp', 'emp@entry183.test', true, '18300000-0000-0000-0000-0000000000a3');
   insert into public.user_branch_assignments (tenant_id, user_id, branch_id, department_id, is_primary)
   select tenant_id, id, '18300000-0000-0000-0000-00000000000a', '18300000-0000-0000-0000-00000000000b', true
   from public.users where tenant_id = '18300000-0000-0000-0000-000000000001';
   insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type)
   select '18300000-0000-0000-0000-000000000001', v.u, r.id, 'tenant'
   from (values ('18300000-0000-0000-0000-000000000011'::uuid, 'owner'),
                ('18300000-0000-0000-0000-000000000012'::uuid, 'finance_manager'),
                ('18300000-0000-0000-0000-000000000013'::uuid, 'employee')) v(u, rc)
   join public.roles r on r.code = v.rc;

   insert into public.marketing_campaigns (id, tenant_id, platform_code, campaign_name, status_code)
   values ('18300000-0000-0000-0000-0000000000cc', '18300000-0000-0000-0000-000000000001', 'google_ads', 'Umrah Q3', 'active');
   insert into public.campaign_daily_metrics (id, tenant_id, marketing_campaign_id, metric_date, spend_amount, currency_code, impressions, clicks, revenue_amount)
   values ('18300000-0000-0000-0000-0000000000dd', '18300000-0000-0000-0000-000000000001',
           '18300000-0000-0000-0000-0000000000cc', date '2026-08-01', 10, 'EGP', 100, 5, 0);
   insert into public.customers (id, tenant_id, customer_type_code, full_name)
   values ('18300000-0000-0000-0000-0000000000d1', '18300000-0000-0000-0000-000000000001', 'person', 'Customer');
   insert into public.bookings (id, tenant_id, branch_id, department_id, customer_id, booking_status_code, title, booking_reference, owner_user_id) values
       ('18300000-0000-0000-0000-0000000000b1', '18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-00000000000a',
        '18300000-0000-0000-0000-00000000000b', '18300000-0000-0000-0000-0000000000d1', 'confirmed', 'Trip', 'BR-ENTRY183-1',
        '18300000-0000-0000-0000-000000000011'),
       ('18300000-0000-0000-0000-0000000000b2', '18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-00000000000a',
        '18300000-0000-0000-0000-00000000000b', '18300000-0000-0000-0000-0000000000d1', 'draft', 'EmpTrip', 'BR-ENTRY183-2',
        '18300000-0000-0000-0000-000000000013');
   insert into public.suppliers (id, tenant_id, name, supplier_type_code)
   values ('18300000-0000-0000-0000-0000000000e1', '18300000-0000-0000-0000-000000000001', 'Air', 'airline');
   insert into public.booking_items (id, tenant_id, booking_id, supplier_id, service_type_code, currency_code, cost_amount, selling_amount, base_status_code)
   values ('18300000-0000-0000-0000-0000000000f1', '18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-0000000000b1',
           '18300000-0000-0000-0000-0000000000e1', 'flight_ticket', 'USD', 400, 500, 'confirmed');
   insert into public.exchange_rates (id, tenant_id, from_currency_code, to_currency_code, rate, effective_at) values
       ('18300000-0000-0000-0000-0000000000ea', '18300000-0000-0000-0000-000000000001', 'USD', 'EGP', 48.0, now() - interval '2 days'),
       ('18300000-0000-0000-0000-0000000000eb', '18300000-0000-0000-0000-000000000001', 'USD', 'EGP', 49.5, now() - interval '1 day');

   -- One entry shape per ARCH-2 surface the employee can create: %1 id, %2 is_archived, %3 reason,
   -- %4 archived_at, %5 archived_by.
   create temporary table entry_cases (surface text primary key, statement text not null);
   insert into entry_cases values
       ('booking_items', $sql$insert into public.booking_items
           (id, tenant_id, booking_id, service_type_code, currency_code, base_status_code, owner_user_id,
            is_archived, archive_reason, archived_at, archived_by)
           values (%1$L, '18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-0000000000b2', 'flight_ticket',
            'USD', 'draft', '18300000-0000-0000-0000-000000000013', %2$L, %3$L, %4$L, %5$L)$sql$),
       ('leads', $sql$insert into public.leads
           (id, tenant_id, branch_id, department_id, lead_source_code, lead_status_code, title,
            is_archived, archive_reason, archived_at, archived_by)
           values (%1$L, '18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-00000000000a',
            '18300000-0000-0000-0000-00000000000b', 'direct_call', 'new', 'Entry lead', %2$L, %3$L, %4$L, %5$L)$sql$),
       ('quotations', $sql$insert into public.quotations
           (id, tenant_id, customer_id, owner_user_id, quotation_status_code, quotation_number, currency_code,
            is_archived, archive_reason, archived_at, archived_by)
           values (%1$L, '18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-0000000000d1',
            '18300000-0000-0000-0000-000000000013', 'draft', 'Q-' || %1$L, 'EGP', %2$L, %3$L, %4$L, %5$L)$sql$);
   grant select on entry_cases to authenticated;

   -- ENTRY-1 cases: each is an entry the RPC door never writes.
   create temporary table item_entry_cases (label text primary key, cols text not null, vals text not null);
   insert into item_entry_cases values
       ('born in_progress past a finance gate', 'base_status_code, finance_approval_required', $v$'in_progress', true$v$),
       ('born completed and backdated',         'base_status_code, completed_at',              $v$'completed', now() - interval '400 days'$v$),
       ('draft with a completion stamp',        'base_status_code, completed_at',              $v$'draft', now()$v$),
       ('draft with a cancellation stamp',      'base_status_code, cancelled_at',              $v$'draft', now()$v$),
       ('draft with a no-show stamp',           'base_status_code, no_show_at',                $v$'draft', now()$v$);
   grant select on item_entry_cases to authenticated;

   set local role authenticated;

   -- ARCH-2: the employee holds create but not archive authority.
   select set_config('request.jwt.claims', '{"sub":"18300000-0000-0000-0000-0000000000a3","aal":"aal1"}', true);
   select ok(app.has_permission('CREATE_LEAD') and app.has_permission('CREATE_QUOTATION')
             and app.has_permission('CREATE_BOOKING_ITEM') and not app.has_permission('ARCHIVE_RECORD'),
             'employee creates leads, quotations and booking items without archive authority');
   select throws_ok(format(statement, '18300000-0000-0000-0000-000000000101', true, 'x', null, null),
                    '42501', 'permission denied: ARCHIVE_RECORD',
                    surface || ': creating archived requires archive authority') from entry_cases order by surface;
   select throws_ok(format(statement, '18300000-0000-0000-0000-000000000102', false, null, now(),
                           '18300000-0000-0000-0000-000000000011'),
                    '42501', 'archive metadata is set by the server',
                    surface || ': an active row cannot claim a forged archiver') from entry_cases order by surface;
   select lives_ok(format(statement, '18300000-0000-0000-0000-000000000103', false, null, null, null),
                   surface || ': ordinary creation still succeeds') from entry_cases order by surface;

   -- ARCH-2 invoices: a finance user who holds archive authority still cannot author the stamp.
   select set_config('request.jwt.claims', '{"sub":"18300000-0000-0000-0000-0000000000a2","aal":"aal2"}', true);
   select throws_ok($$insert into public.invoices (tenant_id, customer_id, invoice_number, invoice_date, currency_code, total_amount, status_code, archived_by)
                      values ('18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-0000000000d1', 'INV-183-A', current_date, 'EGP', 10, 'draft',
                              '18300000-0000-0000-0000-000000000011')$$,
                    '42501', 'archive metadata is set by the server', 'invoices: an active row cannot claim a forged archiver');
   select lives_ok($$insert into public.invoices (id, tenant_id, customer_id, invoice_number, invoice_date, currency_code, total_amount, status_code, is_archived, archived_by, archived_at)
                     values ('18300000-0000-0000-0000-000000000201', '18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-0000000000d1', 'INV-183-B',
                             current_date, 'EGP', 10, 'draft', true, '18300000-0000-0000-0000-000000000011', now() - interval '1 year')$$,
                   'invoices: an authorized archived creation is accepted');

   select set_config('request.jwt.claims', '{"sub":"18300000-0000-0000-0000-0000000000a1","aal":"aal2"}', true);
   select lives_ok(format(statement, '18300000-0000-0000-0000-000000000104', true, 'approved', '2020-01-01',
                          '18300000-0000-0000-0000-000000000013'),
                   'leads: an archive holder may create archived with a reason')
   from entry_cases where surface = 'leads';
   reset role;

   select results_eq(
       $$select archived_by, archived_at = now() from public.invoices where id = '18300000-0000-0000-0000-000000000201'$$,
       $$values ('18300000-0000-0000-0000-000000000012'::uuid, true)$$,
       'invoices: the archiver and time come from the server, not the forged and backdated input');
   select results_eq(
       $$select is_archived, archive_reason, archived_by, archived_at = now() from public.leads where id = '18300000-0000-0000-0000-000000000104'$$,
       $$values (true, 'approved'::text, '18300000-0000-0000-0000-000000000011'::uuid, true)$$,
       'leads: the archiver and time come from the server');

   set local role authenticated;

   -- STEPUP-1: the write costs the permission the table's RLS already demands, plus the role's MFA.
   select set_config('request.jwt.claims', '{"sub":"18300000-0000-0000-0000-0000000000a1","aal":"aal1"}', true);
   select throws_ok($$insert into public.campaign_daily_metrics (tenant_id, marketing_campaign_id, metric_date, spend_amount, currency_code, impressions, clicks, revenue_amount)
                      values ('18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-0000000000cc', date '2026-08-02', 1, 'EGP', 1, 1, 999999)$$,
                    '42501', 'multi-factor authentication required for this role', 'campaign_daily_metrics: insert at aal1 needs step-up');
   select throws_ok($$update public.campaign_daily_metrics set spend_amount = 0, revenue_amount = 5000000
                      where id = '18300000-0000-0000-0000-0000000000dd'$$,
                    '42501', 'multi-factor authentication required for this role', 'campaign_daily_metrics: update at aal1 needs step-up');
   select set_config('request.jwt.claims', '{"sub":"18300000-0000-0000-0000-0000000000a1","aal":"aal2"}', true);
   select lives_ok($$insert into public.campaign_daily_metrics (tenant_id, marketing_campaign_id, metric_date, spend_amount, currency_code, impressions, clicks, revenue_amount)
                     values ('18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-0000000000cc', date '2026-08-03', 1, 'EGP', 1, 1, 2)$$,
                   'campaign_daily_metrics: insert at aal2 succeeds');
   select lives_ok($$update public.campaign_daily_metrics set clicks = 6 where id = '18300000-0000-0000-0000-0000000000dd'$$,
                   'campaign_daily_metrics: update at aal2 succeeds');
   select set_config('request.jwt.claims', '{"sub":"18300000-0000-0000-0000-0000000000a3","aal":"aal2"}', true);
   select throws_ok($$insert into public.campaign_daily_metrics (tenant_id, marketing_campaign_id, metric_date, spend_amount, currency_code, impressions, clicks, revenue_amount)
                      values ('18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-0000000000cc', date '2026-08-04', 1, 'EGP', 1, 1, 2)$$,
                    '42501', null, 'campaign_daily_metrics: a non-holder is refused');

   select set_config('request.jwt.claims', '{"sub":"18300000-0000-0000-0000-0000000000a2","aal":"aal1"}', true);
   select throws_ok($$insert into public.exchange_rate_adjustments (tenant_id, booking_item_id, original_exchange_rate_id, new_exchange_rate_id, reason_code, reason_text)
                      values ('18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-0000000000f1', '18300000-0000-0000-0000-0000000000ea',
                              '18300000-0000-0000-0000-0000000000eb', 'incorrect_rate', 'aal1 pin')$$,
                    '42501', 'multi-factor authentication required for this role', 'exchange_rate_adjustments: insert at aal1 needs step-up');
   select set_config('request.jwt.claims', '{"sub":"18300000-0000-0000-0000-0000000000a2","aal":"aal2"}', true);
   select lives_ok($$insert into public.exchange_rate_adjustments (tenant_id, booking_item_id, original_exchange_rate_id, new_exchange_rate_id, reason_code, reason_text)
                     values ('18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-0000000000f1', '18300000-0000-0000-0000-0000000000ea',
                             '18300000-0000-0000-0000-0000000000eb', 'incorrect_rate', 'stepped up')$$,
                   'exchange_rate_adjustments: insert at aal2 succeeds');

   -- ENTRY-1: a signed-in caller creates a booking item only at 'draft' with no lifecycle stamp.
   select set_config('request.jwt.claims', '{"sub":"18300000-0000-0000-0000-0000000000a3","aal":"aal1"}', true);
   select throws_ok(format($f$insert into public.booking_items (tenant_id, booking_id, service_type_code, currency_code, owner_user_id, %s)
                             values ('18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-0000000000b2', 'flight_ticket', 'USD',
                                     '18300000-0000-0000-0000-000000000013', %s)$f$, cols, vals),
                    '23514', 'a booking item is created at ''draft'' with no lifecycle stamp (canon 26); use app.advance_booking_item to move it',
                    'booking_items: ' || label || ' is refused') from item_entry_cases order by label;
   select lives_ok($$select app.create_booking_item('18300000-0000-0000-0000-0000000000b2', 'flight_ticket', 'USD', 0, 0, null, null, false)$$,
                   'booking_items: the RPC door still creates the draft item');
   reset role;

   select set_config('request.jwt.claims', '', true);
   select lives_ok($$insert into public.booking_items (tenant_id, booking_id, service_type_code, currency_code, base_status_code)
                     values ('18300000-0000-0000-0000-000000000001', '18300000-0000-0000-0000-0000000000b1', 'flight_ticket', 'USD', 'in_progress')$$,
                   'booking_items: session-less platform paths stay exempt');

   select results_eq(
       $$select c.relname::text collate "default", t.tgname::text collate "default", (t.tgtype & 4) <> 0, (t.tgtype & 16) <> 0
         from pg_trigger t join pg_class c on c.oid = t.tgrelid
         where not t.tgisinternal
           and t.tgname in ('leads_enforce_archive_authority', 'quotations_enforce_archive_authority',
                            'booking_items_enforce_archive_authority', 'invoices_enforce_archive_authority',
                            'campaign_daily_metrics_guard_write_capability',
                            'exchange_rate_adjustments_guard_write_capability', 'booking_items_guard_entry_state')
         order by 1, 2$$,
       $$values ('booking_items', 'booking_items_enforce_archive_authority', true, true),
                ('booking_items', 'booking_items_guard_entry_state', true, false),
                ('campaign_daily_metrics', 'campaign_daily_metrics_guard_write_capability', true, true),
                ('exchange_rate_adjustments', 'exchange_rate_adjustments_guard_write_capability', true, true),
                ('invoices', 'invoices_enforce_archive_authority', true, true),
                ('leads', 'leads_enforce_archive_authority', true, true),
                ('quotations', 'quotations_enforce_archive_authority', true, true)$$,
       'each door is attached at INSERT, and the archive and step-up doors also at UPDATE');

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is d11dea50c36e8dcc1e418251125358ad0377e87b.

10. Check whether `supabase/tests/184_refund_conversation_and_settlement_are_recorded_on_every_door_test.sql` contains `select plan(36);`; if so record Already Applied when its Git blob is be2fc2e45076505879939d0a8accc0fa0f28656b, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 184, 36 assertions), and change nothing else:

   ```text
   -- B6-EXIT bundle B: RFD-3 a refund's life, CHAT-2 a conversation's life and PAY-5 / FIN-11 an
   -- invoice's settlement are produced by the table, so the table door and the RPC door record the same
   -- acts once each. Each table-door case below recorded nothing (or settled nothing) at 7c5975a.
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(36);

   insert into auth.users (id, email) values
       ('18400000-0000-0000-0000-0000000000a1', 'owner@door184.test'),
       ('18400000-0000-0000-0000-0000000000a2', 'finance@door184.test'),
       ('18400000-0000-0000-0000-0000000000a3', 'emp@door184.test');
   insert into public.tenants (id, name, slug, status)
   values ('18400000-0000-0000-0000-000000000001', 'Door 184 Travel', 'door-184', 'active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select '18400000-0000-0000-0000-000000000001', id, 'active'
   from public.subscription_plans where plan_code = 'enterprise';
   insert into public.branches (id, tenant_id, name, slug)
   values ('18400000-0000-0000-0000-00000000000a', '18400000-0000-0000-0000-000000000001', 'HQ', 'door-184-hq');
   insert into public.departments (id, tenant_id, branch_id, department_type_code, name)
   values ('18400000-0000-0000-0000-00000000000b', '18400000-0000-0000-0000-000000000001',
           '18400000-0000-0000-0000-00000000000a', 'sales', 'Sales');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
       ('18400000-0000-0000-0000-000000000011', '18400000-0000-0000-0000-000000000001', 'Owner', 'owner@door184.test', true, '18400000-0000-0000-0000-0000000000a1'),
       ('18400000-0000-0000-0000-000000000012', '18400000-0000-0000-0000-000000000001', 'Finance', 'finance@door184.test', true, '18400000-0000-0000-0000-0000000000a2'),
       ('18400000-0000-0000-0000-000000000013', '18400000-0000-0000-0000-000000000001', 'Emp', 'emp@door184.test', true, '18400000-0000-0000-0000-0000000000a3');
   insert into public.user_branch_assignments (tenant_id, user_id, branch_id, department_id, is_primary)
   select tenant_id, id, '18400000-0000-0000-0000-00000000000a', '18400000-0000-0000-0000-00000000000b', true
   from public.users where tenant_id = '18400000-0000-0000-0000-000000000001';
   insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type)
   select '18400000-0000-0000-0000-000000000001', v.u, r.id, 'tenant'
   from (values ('18400000-0000-0000-0000-000000000011'::uuid, 'owner'),
                ('18400000-0000-0000-0000-000000000012'::uuid, 'finance_manager'),
                ('18400000-0000-0000-0000-000000000013'::uuid, 'employee')) v(u, rc)
   join public.roles r on r.code = v.rc;
   insert into public.customers (id, tenant_id, customer_type_code, full_name)
   values ('18400000-0000-0000-0000-0000000000d1', '18400000-0000-0000-0000-000000000001', 'person', 'Buyer');
   insert into public.bookings (id, tenant_id, branch_id, department_id, customer_id, booking_status_code, title, booking_reference, owner_user_id)
   values ('18400000-0000-0000-0000-0000000000b1', '18400000-0000-0000-0000-000000000001', '18400000-0000-0000-0000-00000000000a',
           '18400000-0000-0000-0000-00000000000b', '18400000-0000-0000-0000-0000000000d1', 'draft', 'Trip', 'BR-DOOR184-1',
           '18400000-0000-0000-0000-000000000013');
   -- Four issued invoices of 5000 (session-less fixture, test 111 pattern): e1 RPC, e2 one full door
   -- allocation, e3 two partial door allocations, e4 an allocation lowered then raised.
   insert into public.invoices (id, tenant_id, customer_id, booking_id, invoice_number, invoice_date, currency_code, total_amount, status_code)
   select ('18400000-0000-0000-0000-0000000000e' || n)::uuid, '18400000-0000-0000-0000-000000000001',
          '18400000-0000-0000-0000-0000000000d1', '18400000-0000-0000-0000-0000000000b1', 'INV-184-' || n,
          current_date, 'EGP', 5000, 'issued'
   from generate_series(1, 4) n;
   insert into public.conversations (id, tenant_id, customer_id, channel_code, conversation_status_code, owner_user_id,
       owner_branch_id, owner_department_id, current_branch_id, current_department_id, external_conversation_id)
   select ('18400000-0000-0000-0000-0000000000c' || n)::uuid, '18400000-0000-0000-0000-000000000001',
          '18400000-0000-0000-0000-0000000000d1', 'whatsapp', 'open', '18400000-0000-0000-0000-000000000013',
          '18400000-0000-0000-0000-00000000000a', '18400000-0000-0000-0000-00000000000b',
          '18400000-0000-0000-0000-00000000000a', '18400000-0000-0000-0000-00000000000b', 'door-184-cv-' || n
   from generate_series(1, 2) n;
   create temporary table r (k text primary key, v uuid);
   grant all on r to authenticated;

   -- ===== RFD-3: finance at aal2, the table door beside the RPC door.
   set local role authenticated;
   select set_config('request.jwt.claims', '{"sub":"18400000-0000-0000-0000-0000000000a2","aal":"aal2"}', true);
   select lives_ok($$insert into public.refunds (id, tenant_id, payment_direction_code, customer_id, booking_id, refund_reason_code, currency_code, amount, refund_status_code)
                     values ('18400000-0000-0000-0000-0000000000f1', '18400000-0000-0000-0000-000000000001', 'customer_refund',
                             '18400000-0000-0000-0000-0000000000d1', '18400000-0000-0000-0000-0000000000b1', 'customer_cancelled', 'EGP', 100, 'requested')$$,
                   'RFD-3: a refund is requested at the table door');
   select lives_ok($$update public.refunds set refund_status_code = 'approved' where id = '18400000-0000-0000-0000-0000000000f1'$$,
                   'RFD-3: the table door approves it');
   select lives_ok($$update public.refunds set refund_status_code = 'completed' where id = '18400000-0000-0000-0000-0000000000f1'$$,
                   'RFD-3: the table door completes it');
   insert into r values ('rf_rpc', app.record_refund('18400000-0000-0000-0000-0000000000d1', 100, 'EGP', 'customer_cancelled',
                                                     '18400000-0000-0000-0000-0000000000b1', null));
   select app.advance_refund((select v from r where k = 'rf_rpc'), 'approved', 'ok');
   select app.advance_refund((select v from r where k = 'rf_rpc'), 'completed', 'paid out');
   reset role;

   select results_eq(
       $$select event_type_code, severity_code, previous_state, new_state, reason, actor_user_id, payload->>'amount'
         from public.events where entity_id = '18400000-0000-0000-0000-0000000000f1' order by seq$$,
       $$values ('refund_requested', 'info', null::text, 'requested', 'customer_cancelled', '18400000-0000-0000-0000-000000000012'::uuid, '100.0000'),
                ('refund_approved', 'info', 'requested', 'approved', null, '18400000-0000-0000-0000-000000000012'::uuid, '100.0000'),
                ('refund_completed', 'warning', 'approved', 'completed', null, '18400000-0000-0000-0000-000000000012'::uuid, '100.0000')$$,
       'RFD-3: the table door records the request, the approval and the completion once each, under the caller');
   select results_eq(
       $$select event_type_code, severity_code, previous_state, new_state, reason
         from public.events where entity_id = (select v from r where k = 'rf_rpc') order by seq$$,
       $$values ('refund_requested', 'info', null::text, 'requested', 'customer_cancelled'),
                ('refund_approved', 'info', 'requested', 'approved', 'ok'),
                ('refund_completed', 'warning', 'approved', 'completed', 'paid out')$$,
       'RFD-3: the RPC door records the same three acts once each, with its reasons');
   select is((select count(*)::int from public.refunds
              where tenant_id = '18400000-0000-0000-0000-000000000001' and completed_at is not null), 2,
             'RFD-3: completed_at is server-stamped on both doors');

   -- ===== CHAT-2: the employee at the table door (c1) and the RPC door (c2).
   set local role authenticated;
   select set_config('request.jwt.claims', '{"sub":"18400000-0000-0000-0000-0000000000a3"}', true);
   select lives_ok($$update public.conversations set conversation_status_code = 'assigned' where id = '18400000-0000-0000-0000-0000000000c1'$$,
                   'CHAT-2: the table door assigns');
   select lives_ok($$update public.conversations set conversation_status_code = 'closed', closed_at = '2001-01-01' where id = '18400000-0000-0000-0000-0000000000c1'$$,
                   'CHAT-2: the table door closes, offering a forged closed_at');
   select ok((select closed_at > now() - interval '1 minute' from public.conversations where id = '18400000-0000-0000-0000-0000000000c1'),
             'CHAT-2: closing stamps closed_at from the server, not the forged value');
   update public.conversations set closed_at = '2001-01-01' where id = '18400000-0000-0000-0000-0000000000c1';
   select ok((select closed_at > now() - interval '1 minute' from public.conversations where id = '18400000-0000-0000-0000-0000000000c1'),
             'CHAT-2: a later update cannot rewrite closed_at');
   select throws_ok($$update public.conversations set conversation_status_code = 'open' where id = '18400000-0000-0000-0000-0000000000c1'$$,
                    '23514', 'a closed conversation is reopened with a reason (canon 26, 27); use app.advance_conversation with p_reason',
                    'CHAT-2: the table door cannot reopen without a reason');
   select lives_ok($$select set_config('app.transition_reason', 'customer replied', true);
                     update public.conversations set conversation_status_code = 'open' where id = '18400000-0000-0000-0000-0000000000c1'$$,
                   'CHAT-2: a reopen carrying a reason is accepted');
   select is((select closed_at from public.conversations where id = '18400000-0000-0000-0000-0000000000c1'), null,
             'CHAT-2: reopening clears closed_at');
   select lives_ok($$update public.conversations set conversation_status_code = 'assigned' where id = '18400000-0000-0000-0000-0000000000c1'$$,
                   'CHAT-2: the table door reassigns after the reopen');
   select throws_ok($$update public.conversations set conversation_status_code = 'escalated' where id = '18400000-0000-0000-0000-0000000000c1'$$,
                    '42501', 'permission denied: ESCALATE_CONVERSATION',
                    'CHAT-2: the employee still cannot escalate at the table');
   select lives_ok($$select app.advance_conversation('18400000-0000-0000-0000-0000000000c2', 'assigned', 'picked');
                     select app.advance_conversation('18400000-0000-0000-0000-0000000000c2', 'closed', 'done')$$,
                   'CHAT-2: the RPC door assigns and closes');
   select throws_ok($$select app.advance_conversation('18400000-0000-0000-0000-0000000000c2', 'open', null)$$,
                    '23514', 'a closed conversation is reopened with a reason (canon 26, 27); use app.advance_conversation with p_reason',
                    'CHAT-2: the RPC door cannot reopen without a reason either');
   select lives_ok($$select app.advance_conversation('18400000-0000-0000-0000-0000000000c2', 'open', 'customer replied')$$,
                   'CHAT-2: the RPC door reopens with a reason');
   select set_config('request.jwt.claims', '{"sub":"18400000-0000-0000-0000-0000000000a1","aal":"aal2"}', true);
   select lives_ok($$update public.conversations set conversation_status_code = 'escalated' where id = '18400000-0000-0000-0000-0000000000c1'$$,
                   'CHAT-2: the owner escalates at the table');
   reset role;

   select results_eq(
       $$select event_type_code, severity_code, previous_state, new_state, reason, actor_user_id
         from public.events where entity_id = '18400000-0000-0000-0000-0000000000c1' and event_type_code <> 'conversation_started' order by seq$$,
       $$values ('conversation_assigned', 'info', 'open', 'assigned', null::text, '18400000-0000-0000-0000-000000000013'::uuid),
                ('conversation_closed', 'info', 'assigned', 'closed', null, '18400000-0000-0000-0000-000000000013'::uuid),
                ('conversation_reopened', 'warning', 'closed', 'open', 'customer replied', '18400000-0000-0000-0000-000000000013'::uuid),
                ('conversation_assigned', 'info', 'open', 'assigned', null, '18400000-0000-0000-0000-000000000013'::uuid),
                ('conversation_escalated', 'warning', 'assigned', 'escalated', null, '18400000-0000-0000-0000-000000000011'::uuid)$$,
       'CHAT-2: every table-door move is recorded once, reopen and escalation as warnings, the reason consumed by its own move');
   select results_eq(
       $$select event_type_code, severity_code, reason
         from public.events where entity_id = '18400000-0000-0000-0000-0000000000c2' and event_type_code <> 'conversation_started' order by seq$$,
       $$values ('conversation_assigned', 'info', 'picked'), ('conversation_closed', 'info', 'done'),
                ('conversation_reopened', 'warning', 'customer replied')$$,
       'CHAT-2: the RPC door records the same moves once each, with its reasons');

   -- ===== PAY-5 / FIN-11: the owner at aal2.
   set local role authenticated;
   select set_config('request.jwt.claims', '{"sub":"18400000-0000-0000-0000-0000000000a1","aal":"aal2"}', true);
   insert into r values ('pay_rpc', app.record_payment('18400000-0000-0000-0000-0000000000e1', 5000, 'cash', now(), 'R-184'));
   select lives_ok($$insert into public.payments (id, tenant_id, payment_direction_code, customer_id, currency_code, payment_method_code, amount, paid_at) values
                       ('18400000-0000-0000-0000-000000000133', '18400000-0000-0000-0000-000000000001', 'customer_payment', '18400000-0000-0000-0000-0000000000d1', 'EGP', 'bank_transfer', 1000, now());
                     insert into public.payment_allocations (id, tenant_id, payment_id, invoice_id, allocated_amount, currency_code) values
                       ('18400000-0000-0000-0000-000000000233', '18400000-0000-0000-0000-000000000001', '18400000-0000-0000-0000-000000000133', '18400000-0000-0000-0000-0000000000e4', 0, 'EGP')$$,
                   'PAY-5: a zero allocation is written at the table door');
   select is((select status_code from public.invoices where id = '18400000-0000-0000-0000-0000000000e4'), 'issued',
             'PAY-5: a zero allocation settles nothing, so the invoice stays issued');
   select lives_ok($$insert into public.payments (id, tenant_id, payment_direction_code, customer_id, currency_code, payment_method_code, amount, paid_at) values
                       ('18400000-0000-0000-0000-000000000102', '18400000-0000-0000-0000-000000000001', 'customer_payment', '18400000-0000-0000-0000-0000000000d1', 'EGP', 'bank_transfer', 5000, now()),
                       ('18400000-0000-0000-0000-000000000131', '18400000-0000-0000-0000-000000000001', 'customer_payment', '18400000-0000-0000-0000-0000000000d1', 'EGP', 'bank_transfer', 2000, now()),
                       ('18400000-0000-0000-0000-000000000132', '18400000-0000-0000-0000-000000000001', 'customer_payment', '18400000-0000-0000-0000-0000000000d1', 'EGP', 'bank_transfer', 3000, now()),
                       ('18400000-0000-0000-0000-000000000104', '18400000-0000-0000-0000-000000000001', 'customer_payment', '18400000-0000-0000-0000-0000000000d1', 'EGP', 'bank_transfer', 5000, now());
                     insert into public.payment_allocations (id, tenant_id, payment_id, invoice_id, allocated_amount, currency_code) values
                       ('18400000-0000-0000-0000-000000000202', '18400000-0000-0000-0000-000000000001', '18400000-0000-0000-0000-000000000102', '18400000-0000-0000-0000-0000000000e2', 5000, 'EGP'),
                       ('18400000-0000-0000-0000-000000000231', '18400000-0000-0000-0000-000000000001', '18400000-0000-0000-0000-000000000131', '18400000-0000-0000-0000-0000000000e3', 2000, 'EGP');
                     insert into public.payment_allocations (id, tenant_id, payment_id, invoice_id, allocated_amount, currency_code) values
                       ('18400000-0000-0000-0000-000000000232', '18400000-0000-0000-0000-000000000001', '18400000-0000-0000-0000-000000000132', '18400000-0000-0000-0000-0000000000e3', 3000, 'EGP'),
                       ('18400000-0000-0000-0000-000000000204', '18400000-0000-0000-0000-000000000001', '18400000-0000-0000-0000-000000000104', '18400000-0000-0000-0000-0000000000e4', 3000, 'EGP')$$,
                   'PAY-5: payments and allocations are written at the table door');
   select is((select status_code from public.invoices where id = '18400000-0000-0000-0000-0000000000e4'), 'partially_paid',
             'PAY-5: a partial door allocation settles the invoice partially_paid');
   select lives_ok($$update public.payment_allocations set allocated_amount = 1000 where id = '18400000-0000-0000-0000-000000000204'$$,
                   'PAY-5: a door allocation is lowered');
   select is((select status_code from public.invoices where id = '18400000-0000-0000-0000-0000000000e4'), 'partially_paid',
             'PAY-5: a lowered allocation never walks the settlement back');
   select lives_ok($$update public.payment_allocations set allocated_amount = 5000 where id = '18400000-0000-0000-0000-000000000204'$$,
                   'PAY-5: the door allocation is raised to the full total');
   set constraints payments_emit_recorded immediate;
   reset role;

   select results_eq(
       $$select invoice_number, status_code from public.invoices where tenant_id = '18400000-0000-0000-0000-000000000001' order by 1$$,
       $$values ('INV-184-1', 'paid'), ('INV-184-2', 'paid'), ('INV-184-3', 'paid'), ('INV-184-4', 'paid')$$,
       'PAY-5: every invoice covered by its allocations is paid, on either door');
   select results_eq(
       $$select i.invoice_number, e.event_type_code, e.previous_state, e.new_state, e.actor_user_id, (e.payload->>'allocated_total')::numeric
         from public.events e join public.invoices i on i.id = e.entity_id
         where i.tenant_id = '18400000-0000-0000-0000-000000000001' order by i.invoice_number, e.seq$$,
       $$values ('INV-184-1', 'invoice_paid', 'issued', 'paid', '18400000-0000-0000-0000-000000000011'::uuid, 5000::numeric),
                ('INV-184-2', 'invoice_paid', 'issued', 'paid', '18400000-0000-0000-0000-000000000011'::uuid, 5000),
                ('INV-184-3', 'invoice_partially_paid', 'issued', 'partially_paid', '18400000-0000-0000-0000-000000000011'::uuid, 2000),
                ('INV-184-3', 'invoice_paid', 'partially_paid', 'paid', '18400000-0000-0000-0000-000000000011'::uuid, 5000),
                ('INV-184-4', 'invoice_partially_paid', 'issued', 'partially_paid', '18400000-0000-0000-0000-000000000011'::uuid, 3000),
                ('INV-184-4', 'invoice_paid', 'partially_paid', 'paid', '18400000-0000-0000-0000-000000000011'::uuid, 5000)$$,
       'PAY-5: each settlement is recorded once on either door, and a lowering records none');
   select is((select payload->>'payment_id' from public.events
              where entity_id = '18400000-0000-0000-0000-0000000000e2' and event_type_code = 'invoice_paid'),
             '18400000-0000-0000-0000-000000000102', 'PAY-5: the settlement names the payment that caused it');
   select ok((select max(seq) filter (where event_type_code = 'payment_allocation_created')
                   < max(seq) filter (where event_type_code = 'invoice_paid')
              from public.events where entity_id in ('18400000-0000-0000-0000-000000000202', '18400000-0000-0000-0000-0000000000e2')),
             'PAY-5: the allocation is recorded before the settlement it causes');
   select results_eq(
       $$select entity_id, payload->>'invoice_new_status' from public.events
         where event_type_code = 'payment_recorded' and entity_id in ((select v from r where k = 'pay_rpc'), '18400000-0000-0000-0000-000000000102')
         order by payload->>'invoice_id'$$,
       $$values ((select v from r where k = 'pay_rpc'), 'paid'), ('18400000-0000-0000-0000-000000000102'::uuid, 'paid')$$,
       'PAY-5: payment_recorded reports the settled invoice status on both doors');

   -- ===== Shape: invoker producers on the tables, and no RPC emits what its table now produces.
   select is((select count(*)::int from pg_proc where pronamespace = 'app'::regnamespace and not prosecdef
              and proname in ('emit_refund_requested', 'emit_refund_transition', 'guard_conversation_transition',
                              'emit_conversation_transition', 'derive_invoice_payment_status')), 5,
             'the guard and the four producers are SECURITY INVOKER');
   select results_eq(
       $$select tgname::text collate "default", (tgtype & 2) = 2 from pg_trigger
         where tgname in ('refunds_emit_requested', 'refunds_emit_transition', 'conversations_guard_transition',
                          'conversations_emit_transition', 'payment_allocations_settle_invoice') order by 1$$,
       $$values ('conversations_emit_transition', false), ('conversations_guard_transition', true),
                ('payment_allocations_settle_invoice', false), ('refunds_emit_requested', false), ('refunds_emit_transition', false)$$,
       'the conversation guard fires BEFORE, the four producers AFTER');
   select is((select count(*)::int from pg_proc where pronamespace = 'app'::regnamespace
              and proname in ('record_refund', 'advance_refund', 'advance_conversation', 'record_payment')
              and pg_get_functiondef(oid) ~ 'record_event'), 0,
             'no restated RPC records the events its table now produces');

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is be2fc2e45076505879939d0a8accc0fa0f28656b.

11. Check whether `supabase/tests/185_a_ledger_entry_balances_in_one_currency_and_a_payment_carries_value_test.sql` contains `select plan(11);`; if so record Already Applied when its Git blob is 67a626e1efa1d1f69109bd107bb8cfe3ae6141af, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 185, 11 assertions), and change nothing else:

   ```text
   -- pgTAP: Batch 6 exit -- a ledger entry balances in one currency, and a payment carries value.
   --
   -- ATTACK-CLASSES: DOOR BUSINESS INPUT STATE AUTH=N/A PRIVILEGE=N/A TENANT=N/A OBSERVABILITY=N/A REPLAY=N/A CONCURRENCY=N/A
   --   AUTH/PRIVILEGE/TENANT=N/A -- who may post or pay is unchanged and pinned by `56_...`, `140_...` and `145_...`;
   --     this file asks what an entry and a payment must BE, on every door, the platform's included.
   --   OBSERVABILITY=N/A -- no event changes; a refused write records nothing because it does not exist.
   --   REPLAY/CONCURRENCY=N/A -- both rules judge one entry or one row; the balance trigger's two-session
   --     proof is JE-4's (`145_...`).
   --
   -- JE-2: `app.create_journal_entry` accepted a 100 USD debit against a 100 EGP credit -- two amounts in
   --   different units summed as if one. No standard and no ERP balances an entry that way (IAS 21.21
   --   records a foreign transaction in the functional currency at the spot rate). Until DC-11 decides
   --   the translation model, an entry balances in ONE currency. The refusal lives in the deferred
   --   balance trigger, so it binds the RPC and the platform's direct writes alike.
   -- PAY-4: a zero-value payment coded `customer_refund` was accepted at the table door. Both sanctioned
   --   writers refuse `amount <= 0` and a refund is a `refunds` row, so a payment row carries value.
   --
   -- ON `set constraints all immediate` BELOW: the balance triggers fire at COMMIT, which pgTAP never
   -- reaches; each ledger case forces the check inside its own DO block (the `70_...` pattern).
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(11);

   insert into auth.users (id, email) values
     ('18500000-0000-0000-0000-0000000000a1','own@j185.test');
   insert into public.tenants (id, name, slug, status) values
     ('18500000-0000-0000-0000-000000000001','J185 Travel','j185-travel','active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select '18500000-0000-0000-0000-000000000001', sp.id, 'active' from public.subscription_plans sp where sp.plan_code = 'enterprise';
   insert into public.branches (id, tenant_id, name, slug) values
     ('18500000-0000-0000-0000-00000000000a','18500000-0000-0000-0000-000000000001','HQ','j185-hq');
   insert into public.departments (id, tenant_id, branch_id, department_type_code, name) values
     ('18500000-0000-0000-0000-0000000000c1','18500000-0000-0000-0000-000000000001','18500000-0000-0000-0000-00000000000a','sales','Sales');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
     ('18500000-0000-0000-0000-000000000011','18500000-0000-0000-0000-000000000001','Owner','own@j185.test',true,'18500000-0000-0000-0000-0000000000a1');
   insert into public.user_branch_assignments (tenant_id, user_id, branch_id, department_id, is_primary) values
     ('18500000-0000-0000-0000-000000000001','18500000-0000-0000-0000-000000000011','18500000-0000-0000-0000-00000000000a','18500000-0000-0000-0000-0000000000c1',true);
   insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type)
   select '18500000-0000-0000-0000-000000000001','18500000-0000-0000-0000-000000000011', r.id, 'tenant' from public.roles r where r.code = 'owner';
   insert into public.customers (id, tenant_id, customer_type_code, full_name) values
     ('18500000-0000-0000-0000-0000000000d1','18500000-0000-0000-0000-000000000001','person','Buyer');
   -- One issued invoice, session-less fixture (the `111_...` pattern), for the sanctioned RPC.
   insert into public.invoices (id, tenant_id, customer_id, invoice_number, invoice_date, currency_code, total_amount, status_code) values
     ('18500000-0000-0000-0000-0000000000e1','18500000-0000-0000-0000-000000000001','18500000-0000-0000-0000-0000000000d1','J185-INV-1',current_date,'EGP',5000,'issued');

   select set_config('request.jwt.claims','{"sub":"18500000-0000-0000-0000-0000000000a1","aal":"aal2"}',true);
   set local role authenticated;
   select app.seed_default_chart_of_accounts();
   reset role;

   -- =============================================================================================
   -- 1-5. JE-2: an entry balances in one currency, on every door.
   -- =============================================================================================
   set local role authenticated;
   select throws_ok($q$do $x$ begin
       perform app.create_journal_entry('manual_entry', current_date, 'JE-2',
         '[{"account_code":"1000","debit":100,"currency":"USD"},{"account_code":"4000","credit":100,"currency":"EGP"}]'::jsonb);
       execute 'set constraints all immediate';
     end $x$$q$,
     '23514', null,
     'JE-2: the RPC no longer balances a 100 USD debit against a 100 EGP credit');

   select throws_like($q$do $x$ begin
       perform app.create_journal_entry('manual_entry', current_date, 'JE-2b',
         '[{"account_code":"1000","debit":100,"currency":"USD"},{"account_code":"4000","credit":60,"currency":"USD"},
           {"account_code":"4100","credit":40,"currency":"EGP"}]'::jsonb);
       execute 'set constraints all immediate';
     end $x$$q$,
     '%mixes currencies (EGP, USD)%(JE-2)',
     'JE-2: an entry that would balance as numbers across USD and EGP lines is refused, and the refusal names both currencies');

   select lives_ok($q$do $x$ begin
       perform app.create_journal_entry('manual_entry', current_date, 'USD-1',
         '[{"account_code":"1000","debit":100,"currency":"USD"},{"account_code":"4000","credit":100,"currency":"USD"}]'::jsonb);
       execute 'set constraints all immediate';
     end $x$$q$,
     'POSITIVE CONTROL: a balanced entry wholly in USD still posts -- the rule is one currency per entry, not EGP only');
   reset role;
   -- The forced check above leaves the session in immediate mode; restore deferral so each platform
   -- case below is judged with all its lines written, not on its bare entry row.
   set constraints all deferred;

   select throws_like($q$do $x$ begin
       insert into public.journal_entries (id, tenant_id, source_type_code, entry_date)
       values ('18500000-0000-0000-0000-0000000000f1','18500000-0000-0000-0000-000000000001','manual_entry', current_date);
       insert into public.journal_entry_lines (tenant_id, journal_entry_id, chart_account_id, debit_amount, credit_amount, currency_code)
       select '18500000-0000-0000-0000-000000000001','18500000-0000-0000-0000-0000000000f1', id,
              case code when '1000' then 100 else 0 end, case code when '4000' then 100 else 0 end,
              case code when '1000' then 'USD' else 'EGP' end
         from public.chart_of_accounts where tenant_id = '18500000-0000-0000-0000-000000000001' and code in ('1000','4000');
       execute 'set constraints all immediate';
     end $x$$q$,
     '%mixes currencies (EGP, USD)%(JE-2)',
     'JE-2: the platform''s direct writes are judged by the same trigger and refused for the currency rule -- no session-less exemption');
   set constraints all deferred;

   select lives_ok($q$do $x$ begin
       insert into public.journal_entries (id, tenant_id, source_type_code, entry_date)
       values ('18500000-0000-0000-0000-0000000000f2','18500000-0000-0000-0000-000000000001','manual_entry', current_date);
       insert into public.journal_entry_lines (tenant_id, journal_entry_id, chart_account_id, debit_amount, credit_amount, currency_code)
       select '18500000-0000-0000-0000-000000000001','18500000-0000-0000-0000-0000000000f2', id,
              case code when '1000' then 100 else 0 end, case code when '4000' then 100 else 0 end, 'EGP'
         from public.chart_of_accounts where tenant_id = '18500000-0000-0000-0000-000000000001' and code in ('1000','4000');
       execute 'set constraints all immediate';
     end $x$$q$,
     'POSITIVE CONTROL: the same platform write in one currency passes, so the refusal above is the currency rule');

   -- =============================================================================================
   -- 6-11. PAY-4: a payment row carries value, on every door.
   -- =============================================================================================
   select is((select pg_get_constraintdef(c.oid) || ' ' || c.convalidated::text from pg_constraint c
               where c.conrelid = 'public.payments'::regclass and c.conname = 'payments_amount_positive_check'),
     'CHECK ((amount > (0)::numeric)) true',
     'STRUCTURE: payments carries a validated amount > 0 CHECK -- one control for every writer');

   select set_config('request.jwt.claims','{"sub":"18500000-0000-0000-0000-0000000000a1","aal":"aal2"}',true);
   set local role authenticated;
   select throws_ok($q$insert into public.payments (tenant_id, payment_direction_code, customer_id, payment_method_code, currency_code, amount, paid_at)
                      values ('18500000-0000-0000-0000-000000000001','customer_refund','18500000-0000-0000-0000-0000000000d1','cash','EGP',0,now())$q$,
     '23514', 'new row for relation "payments" violates check constraint "payments_amount_positive_check"',
     'PAY-4: the owner at aal2 cannot record a zero-value payment coded customer_refund at the table door');

   select lives_ok($q$select app.record_payment('18500000-0000-0000-0000-0000000000e1', 5000, 'cash', now(), 'J185-PAY')$q$,
     'POSITIVE CONTROL: the sanctioned RPC still records a positive payment');
   reset role;

   select throws_ok($q$insert into public.payments (tenant_id, payment_direction_code, customer_id, payment_method_code, currency_code, amount, paid_at)
                      values ('18500000-0000-0000-0000-000000000001','customer_payment','18500000-0000-0000-0000-0000000000d1','cash','EGP',0,now())$q$,
     '23514', 'new row for relation "payments" violates check constraint "payments_amount_positive_check"',
     'PAY-4: the platform cannot write a zero-value payment either');

   select lives_ok($q$insert into public.payments (tenant_id, payment_direction_code, customer_id, payment_method_code, currency_code, amount, paid_at)
                      values ('18500000-0000-0000-0000-000000000001','customer_payment','18500000-0000-0000-0000-0000000000d1','cash','EGP',0.0001,now())$q$,
     'BOUNDARY: the smallest positive amount the column holds is a payment');

   select throws_ok($q$update public.payments set amount = 0 where reference_number = 'J185-PAY'$q$,
     '23514', 'new row for relation "payments" violates check constraint "payments_amount_positive_check"',
     'PAY-4: a recorded payment cannot be emptied to zero afterwards');

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is 67a626e1efa1d1f69109bd107bb8cfe3ae6141af.

12. Check whether `supabase/tests/186_every_permission_is_enforced_and_every_table_states_its_isolation_basis_test.sql` contains `select plan(11);`; if so record Already Applied when its Git blob is 167a93e4abbb497b2856c323b193a449480489e3, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 186, 11 assertions), and change nothing else:

   ```text
   -- pgTAP: Batch 6 exit -- every permission is enforced or carries its reason, and every table states its isolation basis.
   --
   -- Catalog-driven, like `01_rls_coverage_test.sql`: nothing below is a fixture, every assertion reads the live catalog,
   -- so a new permission, table or policy is judged the moment it exists.
   --
   -- RPC-1 (EC-2): the programme opened with 37 permissions enforced nowhere. Measured at `790aa96` (277 migrations), and
   --   identically on Platinum Primary, every one of the 77 permissions is named by an `app`/`public` function or an RLS
   --   predicate except four, each with a recorded reason:
   --     MANAGE_ROLES          -- the role matrix (`roles`, `permissions`, `role_permissions`) grants no member a write,
   --                              so there is no writable surface to charge it on; the absent grant is stronger than a check.
   --     ACCESS_API_FULL,
   --     ACCESS_API_READ_ONLY,
   --     VIEW_ADVANCED_DASHBOARDS -- the surfaces they name do not exist yet; no role holds them, so they grant nothing.
   --   Assertion 1 is a set equality: a fifth unenforced permission fails it, and closing one of the four must remove it
   --   here, so the ceiling can only shrink.
   --
   -- EC-3: every `public` table has row-level security, and its basis is one of four, pinned by name where it is not the
   --   tenant predicate:
   --     TENANT      -- every policy on the table names `current_tenant_id()`;
   --     REFERENCE   -- platform-owned reference data: members SELECT `true`, write nothing;
   --     PLATFORM    -- closed to every member (`false` policy, no privilege); only the platform's functions touch it;
   --     IDENTITY    -- owned by the signed-in identity: every policy names `auth.uid()`.
   --   `anon` holds no privilege on any `public` table.
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(11);

   create temporary view t186_permission_use as
   with fsrc as (
     select string_agg(pg_get_functiondef(p.oid), E'\n') as src
       from pg_proc p join pg_namespace n on n.oid = p.pronamespace
      where n.nspname in ('app','public') and p.prokind in ('f','p')),
   psrc as (
     select string_agg(coalesce(qual,'') || ' ' || coalesce(with_check,''), E'\n') as src from pg_policies)
   select pe.key,
          position('''' || pe.key || '''' in fsrc.src) > 0 or position('''' || pe.key || '''' in psrc.src) > 0 as enforced
     from public.permissions pe, fsrc, psrc;

   create temporary view t186_basis as
   select c.relname::text as tbl,
          case
            when exists (select 1 from pg_policies p where p.schemaname = 'public' and p.tablename = c.relname
                           and coalesce(p.qual,'') || coalesce(p.with_check,'') like '%current_tenant_id%')
              then 'TENANT'
            when c.relname in ('catalog_types','countries','currencies','feature_entitlements','languages',
                               'nationalities','permissions','role_permissions','roles','subscription_plans')
              then 'REFERENCE'
            when c.relname in ('document_storage_findings','integration_cursors','scheduled_job_findings',
                               'tenant_license_activations')
              then 'PLATFORM'
            when c.relname in ('otp_challenges','totp_enrollments','trusted_devices')
              then 'IDENTITY'
            else 'NONE'
          end as basis
     from pg_class c join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relkind in ('r','p');

   -- 1. RPC-1 ceiling: exactly four permissions are enforced nowhere.
   select set_eq(
     $$select key from t186_permission_use where not enforced$$,
     $$values ('ACCESS_API_FULL'),('ACCESS_API_READ_ONLY'),('MANAGE_ROLES'),('VIEW_ADVANCED_DASHBOARDS')$$,
     'RPC-1: only the four reasoned permissions are enforced nowhere -- the set can only shrink');

   -- 2. The three that gate absent surfaces are held by no role.
   select is(
     (select count(*)::int from public.role_permissions rp join public.permissions pe on pe.id = rp.permission_id
       where pe.key in ('ACCESS_API_FULL','ACCESS_API_READ_ONLY','VIEW_ADVANCED_DASHBOARDS')),
     0,
     'RPC-1: no role holds a permission whose surface does not exist');

   -- 3. MANAGE_ROLES has no surface: no member may write the role matrix.
   select is(
     (select count(*)::int
        from unnest(array['roles','permissions','role_permissions']) t
        cross join unnest(array['authenticated','anon']) r
        cross join unnest(array['INSERT','UPDATE','DELETE','TRUNCATE']) pr
       where has_table_privilege(r, 'public.' || t, pr)),
     0,
     'RPC-1: no member role may write roles, permissions or role_permissions, so MANAGE_ROLES gates nothing');

   -- 4. Every public table has row-level security.
   select is(
     (select count(*)::int from pg_class c join pg_namespace n on n.oid = c.relnamespace
       where n.nspname = 'public' and c.relkind in ('r','p') and not c.relrowsecurity),
     0,
     'EC-3: every public table has row-level security enabled');

   -- 5. Every table has a stated basis, and the named bases are exactly the seventeen that are not TENANT.
   select is(
     (select string_agg(tbl, ',' order by tbl) from t186_basis where basis = 'NONE'),
     null,
     'EC-3: every public table has a stated isolation basis');

   select set_eq(
     $$select tbl from t186_basis b where basis <> 'TENANT'
         and not exists (select 1 from pg_policies p where p.schemaname = 'public' and p.tablename = b.tbl
                           and coalesce(p.qual,'') || coalesce(p.with_check,'') like '%current_tenant_id%')$$,
     $$values ('catalog_types'),('countries'),('currencies'),('feature_entitlements'),('languages'),('nationalities'),
              ('permissions'),('role_permissions'),('roles'),('subscription_plans'),
              ('document_storage_findings'),('integration_cursors'),('scheduled_job_findings'),('tenant_license_activations'),
              ('otp_challenges'),('totp_enrollments'),('trusted_devices')$$,
     'EC-3: exactly seventeen tables rest on a basis other than the tenant predicate');

   -- 6. TENANT: no policy on a tenant table omits the tenant predicate (no permissive side door).
   select is(
     (select string_agg(p.tablename || '.' || p.policyname, ',' order by 1)
        from pg_policies p join t186_basis b on b.tbl = p.tablename
       where p.schemaname = 'public' and b.basis = 'TENANT'
         and coalesce(p.qual,'') || coalesce(p.with_check,'') not like '%current_tenant_id%'),
     null,
     'EC-3 TENANT: every policy on a tenant table names current_tenant_id()');

   -- 7. REFERENCE: members read, never write; every policy is a SELECT.
   select is(
     (select string_agg(b.tbl, ',' order by 1) from t186_basis b
       where b.basis = 'REFERENCE'
         and (not has_table_privilege('authenticated', 'public.' || b.tbl, 'SELECT')
              or has_table_privilege('authenticated', 'public.' || b.tbl, 'INSERT,UPDATE,DELETE,TRUNCATE')
              or exists (select 1 from pg_policies p where p.schemaname = 'public' and p.tablename = b.tbl and p.cmd <> 'SELECT'))),
     null,
     'EC-3 REFERENCE: members read platform reference data and write none of it');

   -- 8. PLATFORM: closed to every member.
   select is(
     (select string_agg(b.tbl, ',' order by 1) from t186_basis b
       where b.basis = 'PLATFORM'
         and (has_table_privilege('authenticated', 'public.' || b.tbl, 'SELECT,INSERT,UPDATE,DELETE,TRUNCATE')
              or exists (select 1 from pg_policies p where p.schemaname = 'public' and p.tablename = b.tbl
                           and (coalesce(p.qual,'false') <> 'false' or coalesce(p.with_check,'false') <> 'false')))),
     null,
     'EC-3 PLATFORM: platform-only tables grant no member any privilege and every policy is false');

   -- 9. IDENTITY: every policy binds the row to the signed-in identity.
   select is(
     (select string_agg(p.tablename || '.' || p.policyname, ',' order by 1)
        from pg_policies p join t186_basis b on b.tbl = p.tablename
       where p.schemaname = 'public' and b.basis = 'IDENTITY'
         and (coalesce(p.qual,'') not like '%auth.uid()%'
              or (p.cmd in ('ALL','INSERT','UPDATE') and coalesce(p.with_check,'') not like '%auth.uid()%'))),
     null,
     'EC-3 IDENTITY: every policy on an identity-owned table names auth.uid() on read and write');

   -- 10. anon holds nothing on any public table.
   select is(
     (select string_agg(c.relname, ',' order by 1) from pg_class c join pg_namespace n on n.oid = c.relnamespace
       where n.nspname = 'public' and c.relkind in ('r','p')
         and has_table_privilege('anon', c.oid, 'SELECT,INSERT,UPDATE,DELETE,TRUNCATE')),
     null,
     'EC-3: anon holds no privilege on any public table');

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is 167a93e4abbb497b2856c323b193a449480489e3.

13. Check whether `supabase/tests/187_every_ceiling_is_a_named_membership_and_no_mechanism_is_orphaned_test.sql` contains `select plan(12);`; if so record Already Applied when its Git blob is 4b7acb723de2ecea6b5ea08190af4b5161566ad3, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 187, 12 assertions), and change nothing else:

   ```text
   -- pgTAP: Batch 6 exit -- every ceiling is a named membership, and no mechanism is orphaned, duplicated or switched off.
   --
   -- Catalog-driven, like `186_every_permission_is_enforced_and_every_table_states_its_isolation_basis_test.sql`: every
   -- assertion reads the live catalog, so a new event code, table, trigger, policy, index or function is judged the moment
   -- it exists.
   --
   -- EC-7: four suite ceilings were numeric bounds with slack, so a population could grow silently until it met
   --   the bound. Measured at `23be9e2` (277 migrations), and identically on Platinum Primary, each population is pinned
   --   here by name; the numeric bounds in Tests 07 and 10 stay and this test is their exact membership:
   --     Test 07 `<= 42`  -- 39 `event_type` codes named by no `app` function and no trigger (reserved vocabulary);
   --     Test 10 `<= 56`  -- 52 `public` tables `authenticated` may INSERT into;
   --     Test 10 `<= 20`  -- 5 of them with no capability-checking INSERT trigger;
   --     Test 10 `<= 3`   -- 2 of those with no capability-naming INSERT policy either (the identity tables, whose
   --                         policies name `auth.uid()` -- Test 186 basis IDENTITY).
   --   A new member fails its set equality; removing one must remove it here, so each ceiling can only shrink.
   --
   -- EC-11: the per-surface sweep for orphaned, duplicate and superseded mechanisms over `public`, `app` and `reporting`:
   --   no disabled trigger, no duplicate trigger, index or policy, no invalid index, no unvalidated constraint, no
   --   unowned sequence, and exactly one function reachable from nothing at runtime:
   --     app.document_retention_days(uuid,text) -- superseded by RET-1's `document_retention_policies`, which the scan and
   --       claim paths join directly; kept as the tested per-tenant lookup (Test 97), executable by no client role.
   --       Trigger: remove it when RET-1's owner decision retires the lookup, or a caller appears (then it leaves this set).
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(12);

   create temporary view t187_insertable as
   select c.oid, c.relname::text as tbl
     from pg_class c join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relkind = 'r' and has_table_privilege('authenticated', c.oid, 'INSERT');

   create temporary view t187_no_trigger as
   select i.* from t187_insertable i
    where not exists (select 1 from pg_trigger t join pg_proc p on p.oid = t.tgfoid
                       where t.tgrelid = i.oid and not t.tgisinternal and (t.tgtype & 4) <> 0
                         and pg_get_functiondef(p.oid) ~ '(app\.authorize|app\.has_permission|app\.require_lead_handler)');

   create temporary view t187_no_capability as
   select nt.* from t187_no_trigger nt
    where not exists (select 1 from pg_policies pp
                       where pp.schemaname = 'public' and pp.tablename = nt.tbl and pp.cmd in ('INSERT','ALL')
                         and coalesce(pp.with_check,'') ~ 'has_permission\(''(?!VIEW_|SEE_)[A-Z_]+''');

   create temporary view t187_unused_event as
   with fsrc as (
     select coalesce(string_agg(pg_get_functiondef(p.oid), E'\n'),'') as s
       from pg_proc p join pg_namespace n on n.oid = p.pronamespace where n.nspname = 'app'),
   tsrc as (
     select coalesce(string_agg(pg_get_triggerdef(t.oid), E'\n'),'') as s from pg_trigger t where not t.tgisinternal)
   select cv.code::text as code
     from public.catalog_values cv, fsrc, tsrc
    where cv.catalog_type_code = 'event_type' and position(cv.code in fsrc.s) = 0 and position(cv.code in tsrc.s) = 0;

   create temporary view t187_scope as
   select c.oid, c.relname, n.nspname
     from pg_class c join pg_namespace n on n.oid = c.relnamespace
    where n.nspname in ('public','app','reporting');

   -- 1. Test 07 ceiling as membership: the reserved event vocabulary.
   select set_eq(
     'select code from t187_unused_event',
     $$values ('account_locked'),('approval_resubmitted'),('booking_item_cost_entered'),('booking_item_cost_locked'),
              ('booking_item_locked_cost_edited'),('booking_item_sub_status_changed'),('booking_item_supplier_assigned'),
              ('company_asset_created'),('customer_cross_branch_activity_detected'),('customer_identity_match_found'),
              ('document_expiry_warning'),('exchange_rate_adjustment_created'),('finance_approval_resubmitted'),
              ('financial_account_created'),('lead_reopened'),('login_attempt'),('login_failure'),('login_success'),
              ('notification_created'),('notification_failed'),('notification_read'),('notification_sent'),
              ('offline_conversion_retried'),('offline_conversion_send_attempted'),('otp_expired'),('otp_failed'),
              ('otp_requested'),('otp_verified'),('passenger_document_added'),('passenger_passport_expiry_warning'),
              ('password_changed'),('password_reset'),('supplier_assigned_to_booking_item'),('task_overdue'),
              ('totp_challenge_failure'),('totp_challenge_success'),('totp_enrolled'),('trusted_device_expired'),
              ('user_branch_transfer_started')$$,
     'EC-7: the 39 event codes no function or trigger emits are exactly the reserved vocabulary (Test 07 <= 42)'
   );

   -- 2. Test 10 ceiling as membership: the tables a member may INSERT into.
   select set_eq(
     'select tbl from t187_insertable',
     $$values ('approval_requests'),('booking_item_passengers'),('booking_items'),('bookings'),('branch_business_hours'),
              ('branches'),('campaign_daily_metrics'),('catalog_values'),('chart_of_accounts'),('company_assets'),
              ('complaints'),('conversation_messages'),('conversations'),('customer_contact_methods'),
              ('customer_identity_signals'),('customer_notes'),('customers'),('departments'),('document_links'),
              ('document_retention_policies'),('document_versions'),('documents'),('exchange_rate_adjustments'),
              ('exchange_rates'),('financial_accounts'),('holidays'),('internal_supplier_links'),('invoices'),
              ('lead_assignments'),('lead_interactions'),('leads'),('marketing_campaigns'),('offline_conversions'),
              ('passengers'),('payment_allocations'),('payments'),('quotation_items'),('quotations'),('receipts'),
              ('refunds'),('service_requests'),('subscription_payment_proofs'),('subscriptions'),('suppliers'),('tasks'),
              ('tenants'),('totp_enrollments'),('trusted_devices'),('user_branch_assignments'),('user_permission_grants'),
              ('user_role_assignments'),('users')$$,
     'EC-7: the 52 member-insertable tables are named (Test 10 <= 56)'
   );

   -- 3. Test 10 ceiling as membership: insertable with no capability-checking INSERT trigger.
   select set_eq(
     'select tbl from t187_no_trigger',
     $$values ('subscription_payment_proofs'),('subscriptions'),('tenants'),('totp_enrollments'),('trusted_devices')$$,
     'EC-7: the 5 insertable tables without a capability trigger are named (Test 10 <= 20)'
   );

   -- 4. Test 10 ceiling as membership: no capability trigger and no capability policy.
   select set_eq(
     'select tbl from t187_no_capability',
     $$values ('totp_enrollments'),('trusted_devices')$$,
     'EC-7: only the 2 identity tables carry no INSERT capability of any kind (Test 10 <= 3)'
   );

   -- 5. No trigger is switched off.
   select is_empty(
     $$select t.tgname from pg_trigger t join t187_scope s on s.oid = t.tgrelid
        where not t.tgisinternal and t.tgenabled = 'D'$$,
     'EC-11: no trigger in public, app or reporting is disabled'
   );

   -- 6. No trigger is defined twice (same table, function, timing/events, arguments and condition).
   select is_empty(
     $$select t.tgrelid::regclass::text
         from pg_trigger t join t187_scope s on s.oid = t.tgrelid
        where not t.tgisinternal
        group by t.tgrelid, regexp_replace(pg_get_triggerdef(t.oid), '^CREATE (CONSTRAINT )?TRIGGER \S+ ', '')
       having count(*) > 1$$,
     'EC-11: no duplicate trigger'
   );

   -- 7. No index is defined twice.
   select is_empty(
     $$select i.indrelid::regclass::text
         from pg_index i join t187_scope s on s.oid = i.indrelid
        group by i.indrelid, i.indkey::text, i.indclass::text, i.indisunique,
                 coalesce(pg_get_expr(i.indexprs, i.indrelid),''), coalesce(pg_get_expr(i.indpred, i.indrelid),'')
       having count(*) > 1$$,
     'EC-11: no duplicate index'
   );

   -- 8. No policy is defined twice.
   select is_empty(
     $$select tablename::text from pg_policies
        where schemaname in ('public','app','reporting')
        group by schemaname, tablename, permissive, cmd, roles::text, coalesce(qual,''), coalesce(with_check,'')
       having count(*) > 1$$,
     'EC-11: no duplicate policy'
   );

   -- 9. No index is left invalid and no constraint unvalidated.
   select is_empty(
     $$select i.indexrelid::regclass::text from pg_index i join t187_scope s on s.oid = i.indrelid where not i.indisvalid$$,
     'EC-11: no invalid index'
   );

   select is_empty(
     $$select c.conname::text from pg_constraint c join pg_namespace n on n.oid = c.connamespace
        where not c.convalidated and n.nspname in ('public','app','reporting')$$,
     'EC-11: no unvalidated constraint'
   );

   -- 10. No sequence outlives its column.
   select is_empty(
     $$select s.relname::text from t187_scope s join pg_class c on c.oid = s.oid
        where c.relkind = 'S' and not exists (select 1 from pg_depend d where d.objid = s.oid and d.deptype in ('a','i'))$$,
     'EC-11: no unowned sequence'
   );

   -- 11. Exactly one function is reachable from nothing at runtime: no trigger, function, policy, view or cron job names
   --     it, and no client role may execute it.
   select set_eq(
     $$select p.oid::regprocedure::text
         from pg_proc p join pg_namespace n on n.oid = p.pronamespace
        where n.nspname in ('public','app','reporting')
          and not exists (select 1 from pg_depend d where d.objid = p.oid and d.deptype = 'e')
          and not exists (select 1 from pg_trigger t where t.tgfoid = p.oid)
          and not exists (select 1 from pg_proc q where q.oid <> p.oid and q.prosrc ilike '%' || p.proname || '%')
          and not exists (select 1 from pg_policies pp
                           where coalesce(pp.qual,'') || coalesce(pp.with_check,'') ilike '%' || p.proname || '%')
          and not exists (select 1 from pg_views v where v.definition ilike '%' || p.proname || '%')
          and not exists (select 1 from cron.job j where j.command ilike '%' || p.proname || '%')
          and not has_function_privilege('anon', p.oid, 'EXECUTE')
          and not has_function_privilege('authenticated', p.oid, 'EXECUTE')
          and not has_function_privilege('service_role', p.oid, 'EXECUTE')
          and not has_function_privilege('orvion_integration', p.oid, 'EXECUTE')$$,
     $$values ('app.document_retention_days(uuid,text)')$$,
     'EC-11: the only runtime-unreachable function is the superseded RET-1 lookup'
   );

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is 4b7acb723de2ecea6b5ea08190af4b5161566ad3.

14. Check whether `supabase/tests/188_every_business_key_is_unique_and_every_event_type_is_registered_test.sql` contains `select plan(12);`; if so record Already Applied when its Git blob is fb389022d81120ed9578fcd721447ed146f6023d, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 188, 12 assertions), and change nothing else:

   ```text
   -- pgTAP: Batch 6 exit -- every business key is unique per its owner, and every event type is registered before it is written.
   --
   -- EC-8: the registry row "N1, DC-5, RC-4, R8, B3, RC-1 | TERMINAL IN SUBSTANCE" left six findings to the gate evaluation,
   --   to be re-verified against their migrations. Measured at `5bed4ed` (277 migrations), DC-5 (`202607054600`), RC-4
   --   (`202607048900`) and RC-1 already have behavioural tests (DC-5: 48, 49, 97, 116, 175; RC-4: 23, 45, 53; RC-1: 42,
   --   66, 148). Two had none, and this test is theirs:
   --     R8/B3 (`202607048800_group2_integrity_constraints.sql`) -- five business-key UNIQUE constraints, all validated:
   --       bookings (tenant_id, booking_reference), quotations (tenant_id, quotation_number), subscription_plans
   --       (plan_code), feature_entitlements (subscription_plan_id, feature_code) and usage_counters (tenant_id,
   --       usage_metric_code, period_start, period_end). No test named any of them.
   --     N1 (`202607049100_event_type_registry_enforcement.sql`, current body `20261114160000`) -- app.record_event refuses
   --       an event_type_code, and a severity_code, that the catalog does not register. No test pinned the refusal.
   --   Assertion 1 pins the exact five keys; assertions 2-9 prove each key refuses a duplicate inside its owner and, where
   --   the owner is a tenant, admits the same value in another tenant (the key is not wider than its owner); assertions
   --   10-12 prove the event registry refuses an unknown type and an unknown severity and admits a registered type.
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(12);

   insert into auth.users (id, email, email_confirmed_at) values
     ('c1880000-0000-0000-0000-0000000000a1','owner@a188.test', now()),
     ('c1880000-0000-0000-0000-0000000000a2','owner@b188.test', now());
   insert into public.tenants (id, name, slug, status) values
     ('c1880000-0000-0000-0000-000000000001','A188 Travel','a188','active'),
     ('c1880000-0000-0000-0000-000000000002','B188 Travel','b188','active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select t.id, sp.id, 'active' from public.tenants t cross join public.subscription_plans sp
   where sp.plan_code = 'enterprise'
     and t.id in ('c1880000-0000-0000-0000-000000000001','c1880000-0000-0000-0000-000000000002');
   insert into public.branches (id, tenant_id, name, slug) values
     ('c1880000-0000-0000-0000-00000000000a','c1880000-0000-0000-0000-000000000001','HQ','a188-hq'),
     ('c1880000-0000-0000-0000-00000000000b','c1880000-0000-0000-0000-000000000002','HQ','b188-hq');
   insert into public.departments (id, tenant_id, branch_id, department_type_code, name) values
     ('c1880000-0000-0000-0000-0000000000c1','c1880000-0000-0000-0000-000000000001','c1880000-0000-0000-0000-00000000000a','management','Exec'),
     ('c1880000-0000-0000-0000-0000000000c2','c1880000-0000-0000-0000-000000000002','c1880000-0000-0000-0000-00000000000b','management','Exec');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
     ('c1880000-0000-0000-0000-000000000011','c1880000-0000-0000-0000-000000000001','Owner A','owner@a188.test',true,'c1880000-0000-0000-0000-0000000000a1'),
     ('c1880000-0000-0000-0000-000000000012','c1880000-0000-0000-0000-000000000002','Owner B','owner@b188.test',true,'c1880000-0000-0000-0000-0000000000a2');
   insert into public.customers (id, tenant_id, customer_type_code, full_name) values
     ('c1880000-0000-0000-0000-0000000000d1','c1880000-0000-0000-0000-000000000001','person','Customer A'),
     ('c1880000-0000-0000-0000-0000000000d2','c1880000-0000-0000-0000-000000000002','person','Customer B');
   insert into public.bookings (id, tenant_id, branch_id, department_id, customer_id, booking_status_code, title, booking_reference, owner_user_id) values
     ('c1880000-0000-0000-0000-0000000000b1','c1880000-0000-0000-0000-000000000001','c1880000-0000-0000-0000-00000000000a','c1880000-0000-0000-0000-0000000000c1','c1880000-0000-0000-0000-0000000000d1','confirmed','Trip','BK-188-1','c1880000-0000-0000-0000-000000000011');
   insert into public.quotations (id, tenant_id, customer_id, quotation_status_code, quotation_number, currency_code) values
     ('c1880000-0000-0000-0000-0000000000e1','c1880000-0000-0000-0000-000000000001','c1880000-0000-0000-0000-0000000000d1','sent','QT-188-1','EGP');
   insert into public.usage_counters (id, tenant_id, usage_metric_code, period_start, period_end) values
     ('c1880000-0000-0000-0000-0000000000f1','c1880000-0000-0000-0000-000000000001','t188_metric','2026-10-01','2026-10-31');

   -- 1. R8/B3: exactly the five business keys, each UNIQUE over its exact columns and validated.
   select set_eq(
     $$select c.conrelid::regclass::text || ' ' || c.conname::text || ' ' || pg_get_constraintdef(c.oid)
         from pg_constraint c
        where c.contype = 'u' and c.convalidated
          and c.conname in ('bookings_tenant_reference_key','quotations_tenant_number_key','subscription_plans_code_key',
                            'feature_entitlements_plan_feature_key','usage_counters_tenant_metric_period_key')$$,
     $$values ('bookings bookings_tenant_reference_key UNIQUE (tenant_id, booking_reference)'),
              ('quotations quotations_tenant_number_key UNIQUE (tenant_id, quotation_number)'),
              ('subscription_plans subscription_plans_code_key UNIQUE (plan_code)'),
              ('feature_entitlements feature_entitlements_plan_feature_key UNIQUE (subscription_plan_id, feature_code)'),
              ('usage_counters usage_counters_tenant_metric_period_key UNIQUE (tenant_id, usage_metric_code, period_start, period_end)')$$,
     'R8/B3: the five business keys exist, are UNIQUE over their exact columns and are validated'
   );

   -- 2-3. A booking reference is unique inside its tenant, and only there.
   select throws_ok(
     $$insert into public.bookings (id, tenant_id, branch_id, department_id, customer_id, booking_status_code, title, booking_reference, owner_user_id)
       values ('c1880000-0000-0000-0000-0000000000b2','c1880000-0000-0000-0000-000000000001','c1880000-0000-0000-0000-00000000000a','c1880000-0000-0000-0000-0000000000c1','c1880000-0000-0000-0000-0000000000d1','confirmed','Trip 2','BK-188-1','c1880000-0000-0000-0000-000000000011')$$,
     '23505', null,
     'R8/B3: a second booking with the same reference in the same tenant is refused'
   );
   select lives_ok(
     $$insert into public.bookings (id, tenant_id, branch_id, department_id, customer_id, booking_status_code, title, booking_reference, owner_user_id)
       values ('c1880000-0000-0000-0000-0000000000b3','c1880000-0000-0000-0000-000000000002','c1880000-0000-0000-0000-00000000000b','c1880000-0000-0000-0000-0000000000c2','c1880000-0000-0000-0000-0000000000d2','confirmed','Trip B','BK-188-1','c1880000-0000-0000-0000-000000000012')$$,
     'R8/B3: another tenant may use the same booking reference'
   );

   -- 4-5. A quotation number is unique inside its tenant, and only there.
   select throws_ok(
     $$insert into public.quotations (id, tenant_id, customer_id, quotation_status_code, quotation_number, currency_code)
       values ('c1880000-0000-0000-0000-0000000000e2','c1880000-0000-0000-0000-000000000001','c1880000-0000-0000-0000-0000000000d1','sent','QT-188-1','EGP')$$,
     '23505', null,
     'R8/B3: a second quotation with the same number in the same tenant is refused'
   );
   select lives_ok(
     $$insert into public.quotations (id, tenant_id, customer_id, quotation_status_code, quotation_number, currency_code)
       values ('c1880000-0000-0000-0000-0000000000e3','c1880000-0000-0000-0000-000000000002','c1880000-0000-0000-0000-0000000000d2','sent','QT-188-1','EGP')$$,
     'R8/B3: another tenant may use the same quotation number'
   );

   -- 6. A plan code is unique across the platform.
   select throws_ok(
     $$insert into public.subscription_plans (plan_code, name) values ('enterprise', 'Enterprise copy')$$,
     '23505', null,
     'R8/B3: a second subscription plan with an existing plan code is refused'
   );

   -- 7. A plan grants a feature at most once.
   select throws_ok(
     $$insert into public.feature_entitlements (subscription_plan_id, feature_code)
       select fe.subscription_plan_id, fe.feature_code from public.feature_entitlements fe
        order by fe.subscription_plan_id, fe.feature_code limit 1$$,
     '23505', null,
     'R8/B3: a second entitlement of the same feature on the same plan is refused'
   );

   -- 8-9. A usage counter is unique per tenant, metric and period, and only per tenant.
   select throws_ok(
     $$insert into public.usage_counters (id, tenant_id, usage_metric_code, period_start, period_end)
       values ('c1880000-0000-0000-0000-0000000000f2','c1880000-0000-0000-0000-000000000001','t188_metric','2026-10-01','2026-10-31')$$,
     '23505', null,
     'R8/B3: a second usage counter for the same tenant, metric and period is refused'
   );
   select lives_ok(
     $$insert into public.usage_counters (id, tenant_id, usage_metric_code, period_start, period_end)
       values ('c1880000-0000-0000-0000-0000000000f3','c1880000-0000-0000-0000-000000000002','t188_metric','2026-10-01','2026-10-31')$$,
     'R8/B3: another tenant may count the same metric over the same period'
   );

   -- 10-12. N1: the event registry is enforced at the write path.
   select throws_matching(
     $$select app.record_event('c1880000-0000-0000-0000-000000000001'::uuid, 't188_not_a_registered_code', 'branch',
                               'c1880000-0000-0000-0000-00000000000a'::uuid)$$,
     '^unknown event_type_code: t188_not_a_registered_code',
     'N1: record_event refuses an event type the catalog does not register'
   );
   select throws_matching(
     $$select app.record_event('c1880000-0000-0000-0000-000000000001'::uuid, 'branch_created', 'branch',
                               'c1880000-0000-0000-0000-00000000000a'::uuid, null, null, null, null, null, 't188_not_a_severity')$$,
     '^unknown severity_code: t188_not_a_severity',
     'N1: record_event refuses a severity the catalog does not register'
   );
   select lives_ok(
     $$select app.record_event('c1880000-0000-0000-0000-000000000001'::uuid, 'branch_created', 'branch',
                               'c1880000-0000-0000-0000-00000000000a'::uuid)$$,
     'N1: record_event admits a registered event type (positive control)'
   );

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is fb389022d81120ed9578fcd721447ed146f6023d.

15. Check whether `supabase/tests/189_a_contact_method_change_is_refused_at_the_update_door_test.sql` contains `select plan(15);`; if so record Already Applied when its Git blob is 85f9d02296a20357411b5df659b9eeab9bb3d36e, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 189, 15 assertions), and change nothing else:

   ```text
   -- pgTAP: Batch 6 exit -- a contact method change is refused at the UPDATE door for every rule its INSERT door keeps.
   --
   -- EC-6: every sensitive path needs a targeted negative test. Swept at `2f8c19a` (CRM SPEC-332), the only
   --   member-writable table door with no test aimed at it is UPDATE on public.customer_contact_methods: authenticated
   --   holds UPDATE, the tenant_isolation policy covers it, and seven controls stand on it (the RLS
   --   WITH CHECK, the tenant-bound customer key, the value_normalized check, the one-primary-per-type index, the
   --   enforce_catalog_codes trigger, the guard_write_capability trigger and the subscription write gate), yet every
   --   existing contact test (124 and the customer door tests) writes through INSERT only.
   --   Assertions 1-2 are the positive control: an employee changes a value and its verification. Assertions 3-12
   --   attack the same door as that employee and as a trainee: a move to another tenant, a move to another tenant's
   --   customer, a value that is not normalized (email and phone), a second primary, and a type code that is unknown,
   --   inactive in its own tenant or active only in another tenant; a trainee without CREATE_CUSTOMER is refused and
   --   the row stays as it was. Assertions 13-14 prove another tenant neither sees nor changes the row. Assertion 15
   --   proves a lapsed subscription refuses the change. No migration: each control already holds (PROVEN on the local
   --   stack before this test was written); this test pins them so a later change cannot drop one unseen.
   -- ATTACK-CLASSES: AUTH TENANT DOOR INPUT PRIVILEGE BUSINESS STATE CONCURRENCY=N/A REPLAY=N/A OBSERVABILITY=N/A
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(15);

   insert into auth.users (id, email, email_confirmed_at) values
     ('c1890000-0000-0000-0000-0000000000a1','employee@a189.test', now()),
     ('c1890000-0000-0000-0000-0000000000a2','trainee@a189.test', now()),
     ('c1890000-0000-0000-0000-0000000000b1','employee@b189.test', now());
   insert into public.tenants (id, name, slug, status) values
     ('c1890000-0000-0000-0000-000000000001','A189 Travel','a189-travel','active'),
     ('c1890000-0000-0000-0000-000000000002','B189 Travel','b189-travel','active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select t.id, sp.id, 'active'
     from (values ('c1890000-0000-0000-0000-000000000001'::uuid), ('c1890000-0000-0000-0000-000000000002'::uuid)) t(id)
    cross join public.subscription_plans sp where sp.plan_code = 'enterprise';
   insert into public.branches (id, tenant_id, name, slug) values
     ('c1890000-0000-0000-0000-00000000000a','c1890000-0000-0000-0000-000000000001','Main A','a189-main'),
     ('c1890000-0000-0000-0000-00000000000b','c1890000-0000-0000-0000-000000000002','Main B','b189-main');
   insert into public.departments (id, tenant_id, branch_id, department_type_code, name) values
     ('c1890000-0000-0000-0000-0000000000da','c1890000-0000-0000-0000-000000000001','c1890000-0000-0000-0000-00000000000a','sales','Sales'),
     ('c1890000-0000-0000-0000-0000000000db','c1890000-0000-0000-0000-000000000002','c1890000-0000-0000-0000-00000000000b','sales','Sales');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
     ('c1890000-0000-0000-0000-000000000011','c1890000-0000-0000-0000-000000000001','Employee A','employee@a189.test',true,'c1890000-0000-0000-0000-0000000000a1'),
     ('c1890000-0000-0000-0000-000000000012','c1890000-0000-0000-0000-000000000001','Trainee A','trainee@a189.test',true,'c1890000-0000-0000-0000-0000000000a2'),
     ('c1890000-0000-0000-0000-000000000021','c1890000-0000-0000-0000-000000000002','Employee B','employee@b189.test',true,'c1890000-0000-0000-0000-0000000000b1');
   insert into public.user_branch_assignments (tenant_id, user_id, branch_id, department_id, is_primary) values
     ('c1890000-0000-0000-0000-000000000001','c1890000-0000-0000-0000-000000000011','c1890000-0000-0000-0000-00000000000a','c1890000-0000-0000-0000-0000000000da',true),
     ('c1890000-0000-0000-0000-000000000001','c1890000-0000-0000-0000-000000000012','c1890000-0000-0000-0000-00000000000a','c1890000-0000-0000-0000-0000000000da',true),
     ('c1890000-0000-0000-0000-000000000002','c1890000-0000-0000-0000-000000000021','c1890000-0000-0000-0000-00000000000b','c1890000-0000-0000-0000-0000000000db',true);
   insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type)
   select v.t, v.u, r.id, 'tenant'
     from (values ('c1890000-0000-0000-0000-000000000001'::uuid,'c1890000-0000-0000-0000-000000000011'::uuid,'employee'),
                  ('c1890000-0000-0000-0000-000000000001'::uuid,'c1890000-0000-0000-0000-000000000012'::uuid,'trainee'),
                  ('c1890000-0000-0000-0000-000000000002'::uuid,'c1890000-0000-0000-0000-000000000021'::uuid,'employee')) v(t, u, code)
     join public.roles r on r.code = v.code;
   insert into public.customers (id, tenant_id, customer_type_code, full_name, primary_phone) values
     ('c1890000-0000-0000-0000-0000000000c1','c1890000-0000-0000-0000-000000000001','person','A189 Customer','+201000018901'),
     ('c1890000-0000-0000-0000-0000000000c2','c1890000-0000-0000-0000-000000000002','person','B189 Customer','+201000018902');
   insert into public.catalog_values (tenant_id, catalog_type_code, code, label, is_active) values
     ('c1890000-0000-0000-0000-000000000001','contact_method_type','a189_retired','A189 retired channel',false),
     ('c1890000-0000-0000-0000-000000000002','contact_method_type','b189_only','B189 own channel',true);
   insert into public.customer_contact_methods (id, tenant_id, customer_id, contact_method_type_code, value, is_primary) values
     ('c1890000-0000-0000-0000-0000000000e1','c1890000-0000-0000-0000-000000000001','c1890000-0000-0000-0000-0000000000c1','primary_phone','+201000018911',true),
     ('c1890000-0000-0000-0000-0000000000e2','c1890000-0000-0000-0000-000000000001','c1890000-0000-0000-0000-0000000000c1','primary_phone','+201000018912',false),
     ('c1890000-0000-0000-0000-0000000000e3','c1890000-0000-0000-0000-000000000001','c1890000-0000-0000-0000-0000000000c1','email','a189@example.com',false);

   -- The employee of tenant A works through the authenticated door.
   select set_config('request.jwt.claims', '{"sub":"c1890000-0000-0000-0000-0000000000a1"}', true);
   set local role authenticated;

   -- 1-2. Positive control: an employee changes a contact value and its verification, and the change is kept.
   select lives_ok(
     $$update public.customer_contact_methods set value = '+201000018921', is_verified = true
        where id = 'c1890000-0000-0000-0000-0000000000e2'$$,
     'an employee changes a contact value and its verification through the UPDATE door (positive control)'
   );
   select is(
     (select value || ' ' || is_verified::text from public.customer_contact_methods where id = 'c1890000-0000-0000-0000-0000000000e2'),
     '+201000018921 true',
     'the changed value and verification are kept'
   );

   -- 3. TENANT: a contact method cannot be moved into another tenant.
   select throws_ok(
     $$update public.customer_contact_methods set tenant_id = 'c1890000-0000-0000-0000-000000000002'
        where id = 'c1890000-0000-0000-0000-0000000000e3'$$,
     '42501', 'new row violates row-level security policy for table "customer_contact_methods"',
     'TENANT: a contact method cannot be moved into another tenant'
   );

   -- 4. TENANT: a contact method cannot be moved onto another tenant's customer.
   select throws_ok(
     $$update public.customer_contact_methods set customer_id = 'c1890000-0000-0000-0000-0000000000c2'
        where id = 'c1890000-0000-0000-0000-0000000000e3'$$,
     '23503', null,
     'TENANT: a contact method cannot be moved onto another tenant''s customer'
   );

   -- 5-6. INPUT: a changed value must stay in normal form.
   select throws_ok(
     $$update public.customer_contact_methods set value = 'A189@Example.COM'
        where id = 'c1890000-0000-0000-0000-0000000000e3'$$,
     '23514', null,
     'INPUT: an email changed to a value that is not normalized is refused'
   );
   select throws_ok(
     $$update public.customer_contact_methods set value = '+20 100 001 8931'
        where id = 'c1890000-0000-0000-0000-0000000000e2'$$,
     '23514', null,
     'INPUT: a phone changed to a value that is not normalized is refused'
   );

   -- 7. BUSINESS: a change cannot make a second primary of the same type.
   select throws_ok(
     $$update public.customer_contact_methods set is_primary = true
        where id = 'c1890000-0000-0000-0000-0000000000e2'$$,
     '23505', null,
     'BUSINESS: a change that makes a second primary phone for the customer is refused'
   );

   -- 8-10. INPUT and TENANT: a changed type code must be active in the row's own tenant catalog.
   select throws_matching(
     $$update public.customer_contact_methods set contact_method_type_code = 'telegram'
        where id = 'c1890000-0000-0000-0000-0000000000e3'$$,
     '"telegram" is not an active value of catalog family "contact_method_type"',
     'INPUT: a type code the catalog does not hold is refused'
   );
   select throws_matching(
     $$update public.customer_contact_methods set contact_method_type_code = 'a189_retired'
        where id = 'c1890000-0000-0000-0000-0000000000e3'$$,
     '"a189_retired" is not an active value of catalog family "contact_method_type"',
     'INPUT: a type code that is inactive in the own tenant catalog is refused'
   );
   select throws_matching(
     $$update public.customer_contact_methods set contact_method_type_code = 'b189_only'
        where id = 'c1890000-0000-0000-0000-0000000000e3'$$,
     '"b189_only" is not an active value of catalog family "contact_method_type"',
     'TENANT: a type code active only in another tenant catalog is refused'
   );

   -- 11-12. AUTH and PRIVILEGE: a trainee without CREATE_CUSTOMER cannot change a contact, and the row stays.
   select set_config('request.jwt.claims', '{"sub":"c1890000-0000-0000-0000-0000000000a2"}', true);
   select throws_ok(
     $$update public.customer_contact_methods set value = '+201000018941'
        where id = 'c1890000-0000-0000-0000-0000000000e2'$$,
     '42501', 'permission denied: one of CREATE_CUSTOMER is required to write customer_contact_methods',
     'PRIVILEGE: a trainee without CREATE_CUSTOMER cannot change a contact method'
   );
   reset role;
   select is(
     (select value from public.customer_contact_methods where id = 'c1890000-0000-0000-0000-0000000000e2'),
     '+201000018921',
     'AUTH: the refused trainee change left the contact value as it was'
   );

   -- 13-14. TENANT: another tenant's employee neither sees nor changes the row.
   select set_config('request.jwt.claims', '{"sub":"c1890000-0000-0000-0000-0000000000b1"}', true);
   set local role authenticated;
   select is(
     (select count(*)::int from public.customer_contact_methods where tenant_id = 'c1890000-0000-0000-0000-000000000001'),
     0,
     'TENANT: another tenant''s employee sees no contact method of tenant A'
   );
   update public.customer_contact_methods set value = '+201000018951' where id = 'c1890000-0000-0000-0000-0000000000e2';
   reset role;
   select is(
     (select value from public.customer_contact_methods where id = 'c1890000-0000-0000-0000-0000000000e2'),
     '+201000018921',
     'TENANT: another tenant''s employee changes no contact method of tenant A'
   );

   -- 15. STATE: a lapsed subscription refuses the change and keeps reads.
   update public.subscriptions set subscription_status_code = 'expired' where tenant_id = 'c1890000-0000-0000-0000-000000000001';
   select set_config('request.jwt.claims', '{"sub":"c1890000-0000-0000-0000-0000000000a1"}', true);
   set local role authenticated;
   select throws_ok(
     $$update public.customer_contact_methods set value = '+201000018961'
        where id = 'c1890000-0000-0000-0000-0000000000e2'$$,
     '42501', 'subscription state "expired" does not permit writes on public.customer_contact_methods (reads remain available so the tenant can inspect and export its own data)',
     'STATE: a lapsed subscription refuses a contact method change'
   );
   reset role;

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is 85f9d02296a20357411b5df659b9eeab9bb3d36e.

16. Check whether `supabase/tests/190_constraint_refusals_test.sql` contains `select plan(72);`; if so record Already Applied when its Git blob is 8ae13da46d8ced91c652dfcaec13dba2f7546f3f, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 190, 72 assertions), and change nothing else:

   ```text
   -- pgTAP: Batch 6 exit -- seventy-two check and unique constraints that no test broke are proven to refuse, each by name.
   --
   -- EC-5: an invariant held in a database control must be proven by a test that fails when the control is removed. The
   --   EC-5 mutation probe at CRM 8a43a53 dropped each CHECK constraint and each UNIQUE constraint or index in turn and ran
   --   the pgTAP files that name its table; these seventy-two survived. A partial full-suite rerun killed seven of them
   --   only through Test 103, a sweep that reads constraint text, or Tests 91 and 107, which name none of their tables (an
   --   unattributed failure, not a proof). Each control already refuses (PROVEN on the local stack before this test was
   --   written); no test attempted a row that breaks it.
   --   Every assertion names the exact SQLSTATE (23514 for a check, 23505 for a unique key) and the exact constraint, so
   --   a refusal by any other control fails the assertion. The transaction runs with session_replication_role = replica,
   --   which disables triggers and foreign keys and leaves CHECK, UNIQUE and NOT NULL enforced, so each row isolates the
   --   one constraint it breaks: its other required columns carry placeholder values that no trigger or foreign key reads.
   --   The sixteen fixture rows below hold the first key of each unique constraint the assertions then repeat.
   --   No migration: this test pins the controls so a later change cannot drop one unseen.
   -- ATTACK-CLASSES: INPUT BUSINESS STATE AUTH=N/A PRIVILEGE=N/A TENANT=N/A DOOR=N/A CONCURRENCY=N/A REPLAY=N/A OBSERVABILITY=N/A
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(72);
   set local session_replication_role = replica;

   insert into public.tenants (name, slug, status) values ('x190_9', 'dup-slug-190', 'active');
   insert into public.roles (code, name) values ('dup_role_190', 'x190_19');
   insert into public.permissions (key, name) values ('DUP_KEY_190', 'x190_25');
   insert into public.role_permissions (role_id, permission_id) values ('c1900000-0000-0000-0000-000000000001', 'c1900000-0000-0000-0000-000000000002');
   insert into public.users (tenant_id, full_name, email, auth_user_id) values ('c1900000-0000-0000-0000-000000000003', 'x190_35', 'x190_36', 'c1900000-0000-0000-0000-000000000004');
   insert into public.users (tenant_id, full_name, email) values ('c1900000-0000-0000-0000-000000000003', 'x190_41', 'dup@a190.test');
   insert into public.document_versions (tenant_id, document_id, version_number, file_name, file_type_code, storage_path, is_current) values (gen_random_uuid(), 'c1900000-0000-0000-0000-000000000005', 1, 'x190_81', 'x190_82', 'x190_83', true);
   insert into public.invoices (tenant_id, customer_id, invoice_number, invoice_date, currency_code, status_code) values ('c1900000-0000-0000-0000-000000000003', gen_random_uuid(), 'INV-DUP-190', current_date, 'x190_151', 'x190_152');
   insert into public.receipts (tenant_id, payment_id, receipt_number) values ('c1900000-0000-0000-0000-000000000003', gen_random_uuid(), 'RCT-DUP-190');
   insert into public.events (event_type_code, severity_code, entity_type, entity_id, seq) overriding system value values ('x190_202', 'x190_203', 'x190_204', gen_random_uuid(), 990001901);
   insert into public.security_events (security_event_type_code, seq) overriding system value values ('x190_210', 990001902);
   insert into public.attribution_clicks (tenant_id, attribution_source_code, gbraid) values ('c1900000-0000-0000-0000-000000000003', 'x190_245', 'GB-DUP-190');
   insert into public.attribution_clicks (tenant_id, attribution_source_code, wbraid) values ('c1900000-0000-0000-0000-000000000003', 'x190_249', 'WB-DUP-190');
   insert into public.tenant_license_activations (tenant_id, token_hash, plan_code, billing_period_code, expires_at) values (gen_random_uuid(), 'dup-hash-190', 'x190_265', 'x190_266', now());
   insert into public.user_permission_grants (tenant_id, user_id, permission_id, effect) values ('c1900000-0000-0000-0000-000000000003', 'c1900000-0000-0000-0000-000000000007', 'c1900000-0000-0000-0000-000000000002', 'deny');
   insert into public.customer_consents (tenant_id, customer_id, purpose_code, consent_status_code, channel_code, seq) overriding system value values (gen_random_uuid(), gen_random_uuid(), 'ad_user_data', 'granted', 'x190_305', 990001903);

   select throws_ok($s$insert into public.catalog_types (code, name) values ('Bad-Code', 'x190_2')$s$, '23514', 'new row for relation "catalog_types" violates check constraint "catalog_types_code_format_chk"', 'catalog_types_code_format_chk refuses a row that breaks it');
   select throws_ok($s$insert into public.currencies (code, name) values ('egx', 'x190_4')$s$, '23514', 'new row for relation "currencies" violates check constraint "currencies_code_format_chk"', 'currencies_code_format_chk refuses a row that breaks it');
   select throws_ok($s$insert into public.languages (code, name) values ('EN', 'x190_6')$s$, '23514', 'new row for relation "languages" violates check constraint "languages_code_format_chk"', 'languages_code_format_chk refuses a row that breaks it');
   select throws_ok($s$insert into public.nationalities (code, name) values ('eg', 'x190_8')$s$, '23514', 'new row for relation "nationalities" violates check constraint "nationalities_code_format_chk"', 'nationalities_code_format_chk refuses a row that breaks it');
   select throws_ok($s$insert into public.tenants (name, slug, status) values ('x190_12', 'dup-slug-190', 'active')$s$, '23505', 'duplicate key value violates unique constraint "tenants_slug_key"', 'tenants_slug_key refuses a second equal key');
   select throws_ok($s$insert into public.tenants (name, slug, status, trial_started_at) values ('x190_15', 'x190_16', 'active', now())$s$, '23514', 'new row for relation "tenants" violates check constraint "tenants_trial_dates_paired"', 'tenants_trial_dates_paired refuses a row that breaks it');
   select throws_ok($s$insert into public.roles (code, name) values ('dup_role_190', 'x190_21')$s$, '23505', 'duplicate key value violates unique constraint "roles_code_key"', 'roles_code_key refuses a second equal key');
   select throws_ok($s$insert into public.permissions (key, name, action_kind) values ('x190_22', 'x190_23', 'edit')$s$, '23514', 'new row for relation "permissions" violates check constraint "permissions_action_kind_check"', 'permissions_action_kind_check refuses a row that breaks it');
   select throws_ok($s$insert into public.permissions (key, name) values ('DUP_KEY_190', 'x190_27')$s$, '23505', 'duplicate key value violates unique constraint "permissions_key_key"', 'permissions_key_key refuses a second equal key');
   select throws_ok($s$insert into public.permissions (key, name, required_feature_code) values ('x190_28', 'x190_29', 'unknown_feature')$s$, '23514', 'new row for relation "permissions" violates check constraint "permissions_required_feature_code_check"', 'permissions_required_feature_code_check refuses a row that breaks it');
   select throws_ok($s$insert into public.role_permissions (role_id, permission_id) values ('c1900000-0000-0000-0000-000000000001', 'c1900000-0000-0000-0000-000000000002')$s$, '23505', 'duplicate key value violates unique constraint "role_permissions_role_permission_key"', 'role_permissions_role_permission_key refuses a second equal key');
   select throws_ok($s$insert into public.users (tenant_id, full_name, email, auth_user_id) values ('c1900000-0000-0000-0000-000000000003', 'x190_38', 'x190_39', 'c1900000-0000-0000-0000-000000000004')$s$, '23505', 'duplicate key value violates unique constraint "users_tenant_auth_key"', 'users_tenant_auth_key refuses a second equal key');
   select throws_ok($s$insert into public.users (tenant_id, full_name, email) values ('c1900000-0000-0000-0000-000000000003', 'x190_44', 'dup@a190.test')$s$, '23505', 'duplicate key value violates unique constraint "users_tenant_email_key"', 'users_tenant_email_key refuses a second equal key');
   select throws_ok($s$insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type) values (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'branch')$s$, '23514', 'new row for relation "user_role_assignments" violates check constraint "user_role_assignments_scope_qualifier_check"', 'user_role_assignments_scope_qualifier_check refuses a row that breaks it');
   select throws_ok($s$insert into public.customer_identity_signals (tenant_id, customer_id, signal_type_code, signal_value) values (gen_random_uuid(), gen_random_uuid(), 'x190_52', ' padded ')$s$, '23514', 'new row for relation "customer_identity_signals" violates check constraint "customer_identity_signals_value_normalized_chk"', 'customer_identity_signals_value_normalized_chk refuses a row that breaks it');
   select throws_ok($s$insert into public.leads (tenant_id, branch_id, department_id, lead_source_code, lead_status_code, title, expected_value) values (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'x190_57', 'x190_58', 'x190_59', 'NaN')$s$, '23514', 'new row for relation "leads" violates check constraint "leads_no_nan_check"', 'leads_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.suppliers (tenant_id, supplier_type_code, name, credit_limit_amount, credit_limit_currency_code) values (gen_random_uuid(), 'x190_61', 'x190_62', 'NaN', 'EGP')$s$, '23514', 'new row for relation "suppliers" violates check constraint "suppliers_no_nan_check"', 'suppliers_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.passengers (tenant_id, first_name, family_name, full_name, passenger_type_code, passport_issue_date, passport_expiry_date) values (gen_random_uuid(), 'x190_64', 'x190_65', 'x190_66', 'x190_67', '2020-01-02', '2020-01-01')$s$, '23514', 'new row for relation "passengers" violates check constraint "passengers_passport_dates_check"', 'passengers_passport_dates_check refuses a row that breaks it');
   select throws_ok($s$insert into public.documents (tenant_id, document_type_code, title, lifecycle_status_code, legal_hold_active) values (gen_random_uuid(), 'x190_69', 'x190_70', 'x190_71', true)$s$, '23514', 'new row for relation "documents" violates check constraint "documents_legal_hold_evidence_check"', 'documents_legal_hold_evidence_check refuses a row that breaks it');
   select throws_ok($s$insert into public.document_links (tenant_id, document_id, passenger_id, booking_id) values (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), gen_random_uuid())$s$, '23514', 'new row for relation "document_links" violates check constraint "document_links_single_target_check"', 'document_links_single_target_check refuses a row that breaks it');
   select throws_ok($s$insert into public.document_storage_findings (tenant_id, finding_type_code) values (gen_random_uuid(), 'orphan_object')$s$, '23514', 'new row for relation "document_storage_findings" violates check constraint "document_storage_findings_path_present"', 'document_storage_findings_path_present refuses a row that breaks it');
   select throws_ok($s$insert into public.document_storage_findings (tenant_id, finding_type_code, resolved_at) values (gen_random_uuid(), 'tenant_scan_failed', now())$s$, '23514', 'new row for relation "document_storage_findings" violates check constraint "document_storage_findings_resolution_complete"', 'document_storage_findings_resolution_complete refuses a row that breaks it');
   select throws_ok($s$insert into public.document_versions (tenant_id, document_id, version_number, file_name, file_type_code, storage_path, is_current) values (gen_random_uuid(), 'c1900000-0000-0000-0000-000000000005', 1, 'x190_87', 'x190_88', 'x190_89', true)$s$, '23505', 'duplicate key value violates unique constraint "document_versions_one_current_idx"', 'document_versions_one_current_idx refuses a second equal key');
   select throws_ok($s$insert into public.quotations (tenant_id, customer_id, quotation_status_code, quotation_number, currency_code, total_amount) values (gen_random_uuid(), gen_random_uuid(), 'x190_92', 'x190_93', 'x190_94', 'NaN')$s$, '23514', 'new row for relation "quotations" violates check constraint "quotations_no_nan_check"', 'quotations_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.quotation_items (tenant_id, quotation_id, service_type_code, currency_code, quantity) values (gen_random_uuid(), gen_random_uuid(), 'x190_97', 'x190_98', 'NaN')$s$, '23514', 'new row for relation "quotation_items" violates check constraint "quotation_items_no_nan_check"', 'quotation_items_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.quotation_items (tenant_id, quotation_id, service_type_code, currency_code, unit_price) values (gen_random_uuid(), gen_random_uuid(), 'x190_101', 'x190_102', -1)$s$, '23514', 'new row for relation "quotation_items" violates check constraint "quotation_items_unit_price_nonneg_check"', 'quotation_items_unit_price_nonneg_check refuses a row that breaks it');
   select throws_ok($s$insert into public.booking_items (tenant_id, booking_id, service_type_code, base_status_code, currency_code, cost_amount) values (gen_random_uuid(), gen_random_uuid(), 'x190_105', 'x190_106', 'x190_107', -1)$s$, '23514', 'new row for relation "booking_items" violates check constraint "booking_items_amounts_nonneg_check"', 'booking_items_amounts_nonneg_check refuses a row that breaks it');
   select throws_ok($s$insert into public.booking_items (tenant_id, booking_id, service_type_code, base_status_code, currency_code, selling_amount) values (gen_random_uuid(), gen_random_uuid(), 'x190_110', 'x190_111', 'x190_112', 'NaN')$s$, '23514', 'new row for relation "booking_items" violates check constraint "booking_items_no_nan_check"', 'booking_items_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.booking_item_passengers (tenant_id, booking_item_id, passenger_id, cost_amount_override) values (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'NaN')$s$, '23514', 'new row for relation "booking_item_passengers" violates check constraint "booking_item_passengers_no_nan_check"', 'booking_item_passengers_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.exchange_rates (tenant_id, from_currency_code, to_currency_code, rate, effective_at) values (gen_random_uuid(), 'x190_117', 'x190_118', 'NaN', now())$s$, '23514', 'new row for relation "exchange_rates" violates check constraint "exchange_rates_no_nan_check"', 'exchange_rates_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.journal_entry_lines (tenant_id, journal_entry_id, chart_account_id, currency_code, debit_amount, credit_amount) values (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'x190_124', 5, 5)$s$, '23514', 'new row for relation "journal_entry_lines" violates check constraint "journal_entry_lines_debit_xor_credit_check"', 'journal_entry_lines_debit_xor_credit_check refuses a row that breaks it');
   select throws_ok($s$insert into public.journal_entry_lines (tenant_id, journal_entry_id, chart_account_id, currency_code, debit_amount, credit_amount) values (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'x190_128', 'NaN', 0)$s$, '23514', 'new row for relation "journal_entry_lines" violates check constraint "journal_entry_lines_no_nan_check"', 'journal_entry_lines_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.invoices (tenant_id, customer_id, invoice_number, invoice_date, currency_code, status_code, id, corrects_invoice_id) values (gen_random_uuid(), gen_random_uuid(), 'x190_131', current_date, 'x190_133', 'x190_134', 'c1900000-0000-0000-0000-000000000006', 'c1900000-0000-0000-0000-000000000006')$s$, '23514', 'new row for relation "invoices" violates check constraint "invoices_corrects_not_self_check"', 'invoices_corrects_not_self_check refuses a row that breaks it');
   select throws_ok($s$insert into public.invoices (tenant_id, customer_id, invoice_number, invoice_date, currency_code, status_code, total_amount) values (gen_random_uuid(), gen_random_uuid(), 'x190_137', current_date, 'x190_139', 'x190_140', 'NaN')$s$, '23514', 'new row for relation "invoices" violates check constraint "invoices_no_nan_check"', 'invoices_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.invoices (tenant_id, customer_id, invoice_number, invoice_date, currency_code, status_code, total_amount) values (gen_random_uuid(), gen_random_uuid(), 'x190_143', current_date, 'x190_145', 'x190_146', -1)$s$, '23514', 'new row for relation "invoices" violates check constraint "invoices_total_amount_nonneg_check"', 'invoices_total_amount_nonneg_check refuses a row that breaks it');
   select throws_ok($s$insert into public.invoices (tenant_id, customer_id, invoice_number, invoice_date, currency_code, status_code) values ('c1900000-0000-0000-0000-000000000003', gen_random_uuid(), 'INV-DUP-190', current_date, 'x190_157', 'x190_158')$s$, '23505', 'duplicate key value violates unique constraint "invoices_tenant_number_key"', 'invoices_tenant_number_key refuses a second equal key');
   select throws_ok($s$insert into public.payments (tenant_id, payment_direction_code, payment_method_code, currency_code, amount) values (gen_random_uuid(), 'x190_160', 'x190_161', 'x190_162', -1)$s$, '23514', 'new row for relation "payments" violates check constraint "payments_amount_nonneg_check"', 'payments_amount_nonneg_check refuses a row that breaks it');
   select throws_ok($s$insert into public.payments (tenant_id, payment_direction_code, payment_method_code, currency_code, amount) values (gen_random_uuid(), 'x190_164', 'x190_165', 'x190_166', 'NaN')$s$, '23514', 'new row for relation "payments" violates check constraint "payments_no_nan_check"', 'payments_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.payments (tenant_id, payment_direction_code, payment_method_code, currency_code, account_amount) values (gen_random_uuid(), 'x190_168', 'x190_169', 'x190_170', -1)$s$, '23514', 'new row for relation "payments" violates check constraint "payments_account_amount_nonneg_check"', 'payments_account_amount_nonneg_check refuses a row that breaks it');
   select throws_ok($s$insert into public.payments (tenant_id, payment_direction_code, payment_method_code, currency_code, account_amount) values (gen_random_uuid(), 'x190_172', 'x190_173', 'x190_174', 'NaN')$s$, '23514', 'new row for relation "payments" violates check constraint "payments_account_amount_no_nan_check"', 'payments_account_amount_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.payment_allocations (tenant_id, payment_id, invoice_id, currency_code, allocated_amount) values (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'x190_178', -1)$s$, '23514', 'new row for relation "payment_allocations" violates check constraint "payment_allocations_amount_nonneg_check"', 'payment_allocations_amount_nonneg_check refuses a row that breaks it');
   select throws_ok($s$insert into public.payment_allocations (tenant_id, payment_id, invoice_id, currency_code, allocated_amount) values (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'x190_182', 'NaN')$s$, '23514', 'new row for relation "payment_allocations" violates check constraint "payment_allocations_no_nan_check"', 'payment_allocations_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.receipts (tenant_id, payment_id, receipt_number) values ('c1900000-0000-0000-0000-000000000003', gen_random_uuid(), 'RCT-DUP-190')$s$, '23505', 'duplicate key value violates unique constraint "receipts_tenant_number_key"', 'receipts_tenant_number_key refuses a second equal key');
   select throws_ok($s$insert into public.refunds (tenant_id, payment_direction_code, currency_code, refund_status_code, amount) values (gen_random_uuid(), 'x190_190', 'x190_191', 'x190_192', -1)$s$, '23514', 'new row for relation "refunds" violates check constraint "refunds_amount_nonneg_check"', 'refunds_amount_nonneg_check refuses a row that breaks it');
   select throws_ok($s$insert into public.refunds (tenant_id, payment_direction_code, currency_code, refund_status_code, amount) values (gen_random_uuid(), 'x190_194', 'x190_195', 'x190_196', 'NaN')$s$, '23514', 'new row for relation "refunds" violates check constraint "refunds_no_nan_check"', 'refunds_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.approval_requests (tenant_id, approval_type_code, approval_status_code, related_entity_type, related_entity_id, booking_item_id, document_id) values (gen_random_uuid(), 'x190_198', 'x190_199', 'x190_200', gen_random_uuid(), gen_random_uuid(), gen_random_uuid())$s$, '23514', 'new row for relation "approval_requests" violates check constraint "approval_requests_single_typed_subject_chk"', 'approval_requests_single_typed_subject_chk refuses a row that breaks it');
   select throws_ok($s$insert into public.events (event_type_code, severity_code, entity_type, entity_id, seq) overriding system value values ('x190_206', 'x190_207', 'x190_208', gen_random_uuid(), 990001901)$s$, '23505', 'duplicate key value violates unique constraint "events_seq_idx"', 'events_seq_idx refuses a second equal key');
   select throws_ok($s$insert into public.security_events (security_event_type_code, seq) overriding system value values ('x190_211', 990001902)$s$, '23505', 'duplicate key value violates unique constraint "security_events_seq_idx"', 'security_events_seq_idx refuses a second equal key');
   select throws_ok($s$insert into public.notification_deliveries (tenant_id, notification_id, channel_code, delivery_status_code, attempt_number) values (gen_random_uuid(), gen_random_uuid(), 'x190_214', 'x190_215', 0)$s$, '23514', 'new row for relation "notification_deliveries" violates check constraint "notification_deliveries_attempt_number_positive"', 'notification_deliveries_attempt_number_positive refuses a row that breaks it');
   select throws_ok($s$insert into public.feature_entitlements (subscription_plan_id, feature_code, limit_value) values (gen_random_uuid(), 'crm', 'NaN')$s$, '23514', 'new row for relation "feature_entitlements" violates check constraint "feature_entitlements_no_nan_check"', 'feature_entitlements_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.usage_counters (tenant_id, usage_metric_code, period_start, period_end, used_value) values (gen_random_uuid(), 'x190_219', current_date, current_date, 'NaN')$s$, '23514', 'new row for relation "usage_counters" violates check constraint "usage_counters_no_nan_check"', 'usage_counters_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.campaign_daily_metrics (tenant_id, marketing_campaign_id, metric_date, spend_amount) values (gen_random_uuid(), gen_random_uuid(), current_date, 1)$s$, '23514', 'new row for relation "campaign_daily_metrics" violates check constraint "campaign_daily_metrics_amount_currency_pairing"', 'campaign_daily_metrics_amount_currency_pairing refuses a row that breaks it');
   select throws_ok($s$insert into public.campaign_daily_metrics (tenant_id, marketing_campaign_id, metric_date, bookings_count) values (gen_random_uuid(), gen_random_uuid(), current_date, -1)$s$, '23514', 'new row for relation "campaign_daily_metrics" violates check constraint "campaign_daily_metrics_bookings_non_negative"', 'campaign_daily_metrics_bookings_non_negative refuses a row that breaks it');
   select throws_ok($s$insert into public.campaign_daily_metrics (tenant_id, marketing_campaign_id, metric_date, clicks) values (gen_random_uuid(), gen_random_uuid(), current_date, -1)$s$, '23514', 'new row for relation "campaign_daily_metrics" violates check constraint "campaign_daily_metrics_clicks_non_negative"', 'campaign_daily_metrics_clicks_non_negative refuses a row that breaks it');
   select throws_ok($s$insert into public.campaign_daily_metrics (tenant_id, marketing_campaign_id, metric_date, leads_count) values (gen_random_uuid(), gen_random_uuid(), current_date, -1)$s$, '23514', 'new row for relation "campaign_daily_metrics" violates check constraint "campaign_daily_metrics_leads_non_negative"', 'campaign_daily_metrics_leads_non_negative refuses a row that breaks it');
   select throws_ok($s$insert into public.campaign_daily_metrics (tenant_id, marketing_campaign_id, metric_date, impressions) values (gen_random_uuid(), gen_random_uuid(), current_date, 'NaN')$s$, '23514', 'new row for relation "campaign_daily_metrics" violates check constraint "campaign_daily_metrics_no_nan_check"', 'campaign_daily_metrics_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.campaign_daily_metrics (tenant_id, marketing_campaign_id, metric_date, revenue_amount, currency_code) values (gen_random_uuid(), gen_random_uuid(), current_date, -1, 'EGP')$s$, '23514', 'new row for relation "campaign_daily_metrics" violates check constraint "campaign_daily_metrics_revenue_non_negative"', 'campaign_daily_metrics_revenue_non_negative refuses a row that breaks it');
   select throws_ok($s$insert into public.attribution_clicks (tenant_id, attribution_source_code, consent_ad_personalization) values (gen_random_uuid(), 'x190_241', 'yes')$s$, '23514', 'new row for relation "attribution_clicks" violates check constraint "attribution_clicks_consent_ad_personalization_check"', 'attribution_clicks_consent_ad_personalization_check refuses a row that breaks it');
   select throws_ok($s$insert into public.attribution_clicks (tenant_id, attribution_source_code, consent_ad_user_data) values (gen_random_uuid(), 'x190_243', 'yes')$s$, '23514', 'new row for relation "attribution_clicks" violates check constraint "attribution_clicks_consent_ad_user_data_check"', 'attribution_clicks_consent_ad_user_data_check refuses a row that breaks it');
   select throws_ok($s$insert into public.attribution_clicks (tenant_id, attribution_source_code, gbraid) values ('c1900000-0000-0000-0000-000000000003', 'x190_247', 'GB-DUP-190')$s$, '23505', 'duplicate key value violates unique constraint "attribution_clicks_unique_gbraid_idx"', 'attribution_clicks_unique_gbraid_idx refuses a second equal key');
   select throws_ok($s$insert into public.attribution_clicks (tenant_id, attribution_source_code, wbraid) values ('c1900000-0000-0000-0000-000000000003', 'x190_251', 'WB-DUP-190')$s$, '23505', 'duplicate key value violates unique constraint "attribution_clicks_unique_wbraid_idx"', 'attribution_clicks_unique_wbraid_idx refuses a second equal key');
   select throws_ok($s$insert into public.offline_conversions (tenant_id, conversion_event_type_code, conversion_value) values (gen_random_uuid(), 'x190_253', 'NaN')$s$, '23514', 'new row for relation "offline_conversions" violates check constraint "offline_conversions_no_nan_check"', 'offline_conversions_no_nan_check refuses a row that breaks it');
   select throws_ok($s$insert into public.offline_conversion_deliveries (tenant_id, offline_conversion_id, platform_code, delivery_status_code, provider_status_code) values (gen_random_uuid(), gen_random_uuid(), 'x190_256', 'x190_257', 'SUCCESS')$s$, '23514', 'new row for relation "offline_conversion_deliveries" violates check constraint "offline_conversion_deliveries_provider_status_vocabulary"', 'offline_conversion_deliveries_provider_status_vocabulary refuses a row that breaks it');
   select throws_ok($s$insert into public.tenant_license_activations (tenant_id, token_hash, plan_code, billing_period_code, expires_at, consumed_at, revoked_at) values (gen_random_uuid(), 'x190_259', 'x190_260', 'x190_261', now(), now(), now())$s$, '23514', 'new row for relation "tenant_license_activations" violates check constraint "tenant_license_activations_not_both_consumed_and_revoked"', 'tenant_license_activations_not_both_consumed_and_revoked refuses a row that breaks it');
   select throws_ok($s$insert into public.tenant_license_activations (tenant_id, token_hash, plan_code, billing_period_code, expires_at) values (gen_random_uuid(), 'dup-hash-190', 'x190_270', 'x190_271', now())$s$, '23505', 'duplicate key value violates unique constraint "tenant_license_activations_token_hash_key"', 'tenant_license_activations_token_hash_key refuses a second equal key');
   select throws_ok($s$insert into public.scheduled_job_findings (job_name, finding_type_code) values ('x190_273', 'item_lost')$s$, '23514', 'new row for relation "scheduled_job_findings" violates check constraint "scheduled_job_findings_finding_type_code_check"', 'scheduled_job_findings_finding_type_code_check refuses a row that breaks it');
   select throws_ok($s$insert into public.user_permission_grants (tenant_id, user_id, permission_id, effect) values (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'allow')$s$, '23514', 'new row for relation "user_permission_grants" violates check constraint "user_permission_grants_effect_check"', 'user_permission_grants_effect_check refuses a row that breaks it');
   select throws_ok($s$insert into public.user_permission_grants (tenant_id, user_id, permission_id, effect, starts_at, ends_at) values (gen_random_uuid(), gen_random_uuid(), gen_random_uuid(), 'grant', '2020-01-02', '2020-01-01')$s$, '23514', 'new row for relation "user_permission_grants" violates check constraint "user_permission_grants_period"', 'user_permission_grants_period refuses a row that breaks it');
   select throws_ok($s$insert into public.user_permission_grants (tenant_id, user_id, permission_id, effect) values ('c1900000-0000-0000-0000-000000000003', 'c1900000-0000-0000-0000-000000000007', 'c1900000-0000-0000-0000-000000000002', 'deny')$s$, '23505', 'duplicate key value violates unique constraint "user_permission_grants_unique"', 'user_permission_grants_unique refuses a second equal key');
   select throws_ok($s$insert into public.customer_consents (tenant_id, customer_id, purpose_code, consent_status_code, channel_code, evidence) values (gen_random_uuid(), gen_random_uuid(), 'ad_user_data', 'granted', 'x190_295', '   ')$s$, '23514', 'new row for relation "customer_consents" violates check constraint "customer_consents_evidence_check"', 'customer_consents_evidence_check refuses a row that breaks it');
   select throws_ok($s$insert into public.customer_consents (tenant_id, customer_id, purpose_code, consent_status_code, channel_code) values (gen_random_uuid(), gen_random_uuid(), 'marketing', 'granted', 'x190_300')$s$, '23514', 'new row for relation "customer_consents" violates check constraint "customer_consents_purpose_code_check"', 'customer_consents_purpose_code_check refuses a row that breaks it');
   select throws_ok($s$insert into public.customer_consents (tenant_id, customer_id, purpose_code, consent_status_code, channel_code, seq) overriding system value values (gen_random_uuid(), gen_random_uuid(), 'ad_user_data', 'granted', 'x190_310', 990001903)$s$, '23505', 'duplicate key value violates unique constraint "customer_consents_seq_key"', 'customer_consents_seq_key refuses a second equal key');

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is 8ae13da46d8ced91c652dfcaec13dba2f7546f3f.

17. Check whether `supabase/tests/191_trigger_enforcer_refusals_test.sql` contains `select plan(13);`; if so record Already Applied when its Git blob is e75f8c0425431f68ddb85e1e17f03611b07c3008, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 191, 13 assertions), and change nothing else:

   ```text
   -- pgTAP: Batch 6 exit -- thirteen row triggers that no test removed are proven to refuse, each by its own message.
   --
   -- EC-5: an invariant held in a database control must be proven by a test that fails when the control is removed. The
   --   EC-5 mutation probe at CRM 8a43a53 disabled each of the RAISE-bearing row triggers in turn and ran the pgTAP suite;
   --   thirteen survived: the subscription write gate on customer_identity_merges, journal_entries, journal_entry_lines,
   --   notifications and attribution_clicks; the write-capability guard on customer_identity_merges; the catalog-code
   --   check on journal_entries, notifications, notification_deliveries, attribution_clicks,
   --   offline_conversion_deliveries and customer_consents; and the entity-reference check on notifications. Each
   --   control already refuses (PROVEN on the local stack before this test was written); no test named its refusal.
   --   Every assertion names the exact SQLSTATE and message its trigger raises, so a refusal by any other control (a
   --   later trigger, a NOT NULL, a foreign key) fails the assertion. A BEFORE row trigger raises before NOT NULL,
   --   CHECK and foreign key checks run, so the refused rows carry only the columns their trigger reads.
   --   Assertions 1-5: a tenant whose latest subscription is expired is refused on each gated table, reads unaffected.
   --   Assertion 6: a trainee of an active tenant, without MERGE_CUSTOMER_IDENTITY, is refused a merge record.
   --   Assertions 7-12: a code that is not an active value of its catalog family is refused on each table.
   --   Assertion 13: a notification naming a customer that does not exist in its tenant is refused.
   --   No migration: this test pins the controls so a later change cannot drop one unseen.
   -- ATTACK-CLASSES: AUTH PRIVILEGE STATE INPUT TENANT BUSINESS DOOR=N/A CONCURRENCY=N/A REPLAY=N/A OBSERVABILITY=N/A
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(13);

   insert into auth.users (id, email, email_confirmed_at) values
     ('c1910000-0000-0000-0000-0000000000a2','trainee@a191.test', now());
   insert into public.tenants (id, name, slug, status) values
     ('c1910000-0000-0000-0000-000000000001','A191 Travel','a191-travel','active'),
     ('c1910000-0000-0000-0000-000000000002','L191 Travel','l191-travel','active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select t.id, sp.id, t.status
     from (values ('c1910000-0000-0000-0000-000000000001'::uuid,'active'),
                  ('c1910000-0000-0000-0000-000000000002'::uuid,'expired')) t(id, status)
    cross join public.subscription_plans sp where sp.plan_code = 'enterprise';
   insert into public.branches (id, tenant_id, name, slug) values
     ('c1910000-0000-0000-0000-00000000000a','c1910000-0000-0000-0000-000000000001','Main A','a191-main');
   insert into public.departments (id, tenant_id, branch_id, department_type_code, name) values
     ('c1910000-0000-0000-0000-0000000000da','c1910000-0000-0000-0000-000000000001','c1910000-0000-0000-0000-00000000000a','sales','Sales');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
     ('c1910000-0000-0000-0000-000000000012','c1910000-0000-0000-0000-000000000001','Trainee A','trainee@a191.test',true,'c1910000-0000-0000-0000-0000000000a2');
   insert into public.user_branch_assignments (tenant_id, user_id, branch_id, department_id, is_primary) values
     ('c1910000-0000-0000-0000-000000000001','c1910000-0000-0000-0000-000000000012','c1910000-0000-0000-0000-00000000000a','c1910000-0000-0000-0000-0000000000da',true);
   insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type)
   select 'c1910000-0000-0000-0000-000000000001', 'c1910000-0000-0000-0000-000000000012', r.id, 'tenant'
     from public.roles r where r.code = 'trainee';

   -- 1-5. STATE: the subscription write gate refuses a tenant whose latest subscription is expired.
   select throws_ok(
     $$insert into public.customer_identity_merges (tenant_id) values ('c1910000-0000-0000-0000-000000000002')$$,
     '42501',
     'subscription state "expired" does not permit writes on public.customer_identity_merges (reads remain available so the tenant can inspect and export its own data)',
     'an expired tenant is refused a customer identity merge by the subscription write gate'
   );
   select throws_ok(
     $$insert into public.journal_entries (tenant_id, source_type_code) values ('c1910000-0000-0000-0000-000000000002', 'manual_entry')$$,
     '42501',
     'subscription state "expired" does not permit writes on public.journal_entries (reads remain available so the tenant can inspect and export its own data)',
     'an expired tenant is refused a journal entry by the subscription write gate'
   );
   select throws_ok(
     $$insert into public.journal_entry_lines (tenant_id) values ('c1910000-0000-0000-0000-000000000002')$$,
     '42501',
     'subscription state "expired" does not permit writes on public.journal_entry_lines (reads remain available so the tenant can inspect and export its own data)',
     'an expired tenant is refused a journal entry line by the subscription write gate'
   );
   select throws_ok(
     $$insert into public.notifications (tenant_id, notification_type_code) values ('c1910000-0000-0000-0000-000000000002', 'security_alert')$$,
     '42501',
     'subscription state "expired" does not permit writes on public.notifications (reads remain available so the tenant can inspect and export its own data)',
     'an expired tenant is refused a notification by the subscription write gate'
   );
   select throws_ok(
     $$insert into public.attribution_clicks (tenant_id, attribution_source_code) values ('c1910000-0000-0000-0000-000000000002', 'manual')$$,
     '42501',
     'subscription state "expired" does not permit writes on public.attribution_clicks (reads remain available so the tenant can inspect and export its own data)',
     'an expired tenant is refused an attribution click by the subscription write gate'
   );

   -- 6. PRIVILEGE: a trainee of an active tenant does not hold MERGE_CUSTOMER_IDENTITY and is refused a merge record.
   select set_config('request.jwt.claims', '{"sub":"c1910000-0000-0000-0000-0000000000a2"}', true);
   select throws_ok(
     $$insert into public.customer_identity_merges (tenant_id) values ('c1910000-0000-0000-0000-000000000001')$$,
     '42501',
     'permission denied: one of MERGE_CUSTOMER_IDENTITY is required to write customer_identity_merges',
     'a trainee without MERGE_CUSTOMER_IDENTITY is refused a customer identity merge by the write-capability guard'
   );
   select set_config('request.jwt.claims', '', true);

   -- 7-12. INPUT: a code that is not an active value of its catalog family is refused.
   select throws_ok(
     $$insert into public.journal_entries (tenant_id, source_type_code) values ('c1910000-0000-0000-0000-000000000001', 'x191_source')$$,
     '23514',
     'journal_entries .source_type_code : "x191_source" is not an active value of catalog family "journal_entry_source_type"',
     'an unknown journal entry source type is refused by the catalog-code check'
   );
   select throws_ok(
     $$insert into public.notifications (tenant_id, notification_type_code) values ('c1910000-0000-0000-0000-000000000001', 'x191_type')$$,
     '23514',
     'notifications .notification_type_code : "x191_type" is not an active value of catalog family "notification_type"',
     'an unknown notification type is refused by the catalog-code check'
   );
   select throws_ok(
     $$insert into public.notification_deliveries (tenant_id, channel_code) values ('c1910000-0000-0000-0000-000000000001', 'x191_channel')$$,
     '23514',
     'notification_deliveries .channel_code : "x191_channel" is not an active value of catalog family "notification_channel"',
     'an unknown notification delivery channel is refused by the catalog-code check'
   );
   select throws_ok(
     $$insert into public.attribution_clicks (tenant_id, attribution_source_code) values ('c1910000-0000-0000-0000-000000000001', 'x191_source')$$,
     '23514',
     'attribution_clicks .attribution_source_code : "x191_source" is not an active value of catalog family "attribution_source"',
     'an unknown attribution source is refused by the catalog-code check'
   );
   select throws_ok(
     $$insert into public.offline_conversion_deliveries (tenant_id, platform_code) values ('c1910000-0000-0000-0000-000000000001', 'x191_platform')$$,
     '23514',
     'offline_conversion_deliveries .platform_code : "x191_platform" is not an active value of catalog family "platform_code"',
     'an unknown offline conversion delivery platform is refused by the catalog-code check'
   );
   select throws_ok(
     $$insert into public.customer_consents (tenant_id, channel_code) values ('c1910000-0000-0000-0000-000000000001', 'x191_channel')$$,
     '23514',
     'customer_consents .channel_code : "x191_channel" is not an active value of catalog family "channel_code"',
     'an unknown consent channel is refused by the catalog-code check'
   );

   -- 13. TENANT: a notification cannot name a customer that does not exist in its own tenant.
   select throws_ok(
     $$insert into public.notifications (tenant_id, notification_type_code, related_entity_type, related_entity_id)
       values ('c1910000-0000-0000-0000-000000000001', 'security_alert', 'customer', 'c1910000-0000-0000-0000-0000000000c9')$$,
     '23503',
     'notifications: related_entity_id "c1910000-0000-0000-0000-0000000000c9" does not identify a customer in this tenant',
     'a notification naming a customer outside its tenant is refused by the entity-reference check'
   );

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is e75f8c0425431f68ddb85e1e17f03611b07c3008.

18. Check whether `supabase/tests/192_a_customer_lock_is_taken_before_its_judgement_test.sql` contains `select plan(4);`; if so record Already Applied when its Git blob is 00d4d776f17ad411f4499ad454d446e0ac772623, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 192, 4 assertions), and change nothing else:

   ```text
   -- pgTAP: a customer row is locked before the decision that reads it (CUST-10, CUST-12).
   --
   -- EC-7: every repaired finding keeps a permanent guard. CUST-10 (migration 20260909060754) and CUST-12
   --   (20260909114354) fixed two races by a row lock, and only scripts/verify_customer_concurrency.py proves
   --   them; no workflow, Finish profile or script runs it, and pgTAP has one session, so no test noticed a
   --   lost lock. As Tests 148 (SUB-4, SUB-5) and 153 (SPP-6) do, this file pins in every CI run the shape
   --   the race proof depends on:
   --   * app.merge_customer_identity locks both identities in id order before it reads either lifecycle
   --     state, so opposite merges cannot each validate a stale row version and archive both survivors;
   --   * app.evaluate_customer_credit_threshold locks the customer before it aggregates the exposure and
   --     reads the last threshold event, so two concurrent evaluations cannot both record a crossing.
   --   Each function exists exactly once; a missing or overloaded function fails its assertions.
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(4);

   create temporary table customer_lock_src on commit drop as
   select p.proname::text as fn, p.prosrc as src
   from pg_proc p join pg_namespace n on n.oid = p.pronamespace
   where n.nspname = 'app'
     and p.proname in ('merge_customer_identity', 'evaluate_customer_credit_threshold');

   select ok((select count(*) = 1 and bool_and(src
                 ~ 'perform 1 from public\.customers\s+where tenant_id = v_tenant and id in \(p_source_customer_id, p_target_customer_id\)\s+order by id for update;')
              from customer_lock_src where fn = 'merge_customer_identity'),
     'CUST-12: app.merge_customer_identity locks both identities in id order');

   select ok((select count(*) = 1 and bool_and(strpos(src, 'order by id for update;') > 0
                 and strpos(src, 'order by id for update;') < strpos(src, 'select is_archived into v_src_archived')
                 and strpos(src, 'order by id for update;') < strpos(src, 'select is_archived into v_target_archived'))
              from customer_lock_src where fn = 'merge_customer_identity'),
     'CUST-12: the merge takes its lock before it reads either lifecycle state');

   select ok((select count(*) = 1 and bool_and(src
                 ~ 'from public\.customers c\s+where c\.id=p_customer_id and c\.tenant_id=p_tenant_id for update;')
              from customer_lock_src where fn = 'evaluate_customer_credit_threshold'),
     'CUST-10: app.evaluate_customer_credit_threshold locks the customer it judges');

   select ok((select count(*) = 1 and bool_and(strpos(src, 'c.tenant_id=p_tenant_id for update;') > 0
                 and strpos(src, 'c.tenant_id=p_tenant_id for update;') < strpos(src, 'app.customer_exposure_in_limit_currency(')
                 and strpos(src, 'c.tenant_id=p_tenant_id for update;') < strpos(src, 'from public.events e'))
              from customer_lock_src where fn = 'evaluate_customer_credit_threshold'),
     'CUST-10: the evaluation takes its lock before the exposure and the last threshold event');

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is 00d4d776f17ad411f4499ad454d446e0ac772623.

19. Check whether `supabase/tests/193_structural_control_presence_test.sql` contains `select plan(3);`; if so record Already Applied when its Git blob is 472b404c67b1656b5c0013bbbb86f1b7a2e33b4a, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 193, 3 assertions), and change nothing else:

   ```text
   -- pgTAP: Batch 6 exit -- the structural controls that no test removed are pinned present, each with its definition.
   --
   -- EC-5: an invariant held in a database control must be proven by a test that fails when the control is removed. The
   --   EC-5 extension probe at CRM 676df3e dropped each foreign key, row-level security policy, row-level security switch
   --   and RAISE-free trigger in turn and ran the pgTAP files that name its table, then reran each survivor against the
   --   catalog-wide files. These 302 survived both (244 foreign keys, 22 policies, 0 switches, 36 triggers).
   --   This file pins their PRESENCE and DEFINITION, not their behaviour: a change that drops or rewrites one fails here
   --   and must update this file in the same change, which makes the removal a reviewed decision instead of a silent one.
   --   Behaviour stays the evidence of the files that name each table. Definitions are compared as deparsed text (foreign
   --   keys) or as an md5 of the deparsed text (policy expressions, triggers) under the search_path set below.
   --   No migration.
   create extension if not exists pgtap with schema extensions;

   begin;
   set local search_path = public, extensions;
   select plan(3);

   select set_has(
     $a$select conrelid::regclass::text || '.' || conname || ' ' || pg_get_constraintdef(oid) from pg_constraint where contype = 'f' and connamespace = 'public'::regnamespace$a$,
     $e$values
       ('approval_requests.approval_requests_booking_item_id_fkey FOREIGN KEY (tenant_id, booking_item_id) REFERENCES booking_items(tenant_id, id) ON DELETE RESTRICT'),
       ('approval_requests.approval_requests_document_id_fkey FOREIGN KEY (tenant_id, document_id) REFERENCES documents(tenant_id, id) ON DELETE RESTRICT'),
       ('approval_requests.approval_requests_requested_by_fkey FOREIGN KEY (tenant_id, requested_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('approval_requests.approval_requests_reviewed_by_fkey FOREIGN KEY (tenant_id, reviewed_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('approval_requests.approval_requests_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('attribution_clicks.attribution_clicks_lead_id_fkey FOREIGN KEY (tenant_id, lead_id) REFERENCES leads(tenant_id, id) ON DELETE RESTRICT'),
       ('attribution_clicks.attribution_clicks_marketing_campaign_id_fkey FOREIGN KEY (tenant_id, marketing_campaign_id) REFERENCES marketing_campaigns(tenant_id, id) ON DELETE RESTRICT'),
       ('attribution_clicks.attribution_clicks_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('booking_item_passengers.booking_item_passengers_booking_item_id_fkey FOREIGN KEY (tenant_id, booking_item_id) REFERENCES booking_items(tenant_id, id) ON DELETE RESTRICT'),
       ('booking_item_passengers.booking_item_passengers_corrected_by_fkey FOREIGN KEY (tenant_id, passenger_corrected_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('booking_item_passengers.booking_item_passengers_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('booking_items.booking_items_archived_by_fkey FOREIGN KEY (tenant_id, archived_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('booking_items.booking_items_cancelled_by_fkey FOREIGN KEY (tenant_id, cancelled_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('booking_items.booking_items_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('booking_items.booking_items_currency_code_fkey FOREIGN KEY (currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('booking_items.booking_items_exchange_rate_id_fkey FOREIGN KEY (tenant_id, exchange_rate_id) REFERENCES exchange_rates(tenant_id, id) ON DELETE RESTRICT'),
       ('booking_items.booking_items_finance_withdrawn_by_fkey FOREIGN KEY (tenant_id, finance_approval_withdrawn_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('booking_items.booking_items_no_show_recorded_by_fkey FOREIGN KEY (tenant_id, no_show_recorded_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('booking_items.booking_items_owner_branch_id_fkey FOREIGN KEY (tenant_id, owner_branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('booking_items.booking_items_owner_department_id_fkey FOREIGN KEY (tenant_id, owner_department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('booking_items.booking_items_reassigned_by_fkey FOREIGN KEY (tenant_id, reassigned_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('booking_items.booking_items_sales_owner_branch_id_fkey FOREIGN KEY (tenant_id, sales_owner_branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('booking_items.booking_items_sales_owner_department_id_fkey FOREIGN KEY (tenant_id, sales_owner_department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('booking_items.booking_items_supplier_id_fkey FOREIGN KEY (tenant_id, supplier_id) REFERENCES suppliers(tenant_id, id) ON DELETE RESTRICT'),
       ('booking_items.booking_items_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('bookings.bookings_archived_by_fkey FOREIGN KEY (tenant_id, archived_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('bookings.bookings_branch_id_fkey FOREIGN KEY (tenant_id, branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('bookings.bookings_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('bookings.bookings_department_id_fkey FOREIGN KEY (tenant_id, department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('bookings.bookings_owner_department_id_fkey FOREIGN KEY (tenant_id, owner_department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('bookings.bookings_quotation_id_fkey FOREIGN KEY (tenant_id, quotation_id) REFERENCES quotations(tenant_id, id) ON DELETE RESTRICT'),
       ('bookings.bookings_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('branch_business_hours.branch_business_hours_branch_id_fkey FOREIGN KEY (tenant_id, branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('branch_business_hours.branch_business_hours_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('branches.branches_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('campaign_daily_metrics.campaign_daily_metrics_currency_code_fkey FOREIGN KEY (currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('campaign_daily_metrics.campaign_daily_metrics_marketing_campaign_id_fkey FOREIGN KEY (tenant_id, marketing_campaign_id) REFERENCES marketing_campaigns(tenant_id, id) ON DELETE RESTRICT'),
       ('campaign_daily_metrics.campaign_daily_metrics_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('catalog_values.catalog_values_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('catalog_values.catalog_values_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('chart_of_accounts.chart_of_accounts_parent_account_id_fkey FOREIGN KEY (tenant_id, parent_account_id) REFERENCES chart_of_accounts(tenant_id, id) ON DELETE RESTRICT'),
       ('chart_of_accounts.chart_of_accounts_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('company_assets.company_assets_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('complaints.complaints_archived_by_fkey FOREIGN KEY (tenant_id, archived_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('complaints.complaints_booking_id_fkey FOREIGN KEY (tenant_id, booking_id) REFERENCES bookings(tenant_id, id) ON DELETE RESTRICT'),
       ('complaints.complaints_booking_item_id_fkey FOREIGN KEY (tenant_id, booking_item_id) REFERENCES booking_items(tenant_id, id) ON DELETE RESTRICT'),
       ('complaints.complaints_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('complaints.complaints_owner_branch_id_fkey FOREIGN KEY (tenant_id, owner_branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('complaints.complaints_owner_department_id_fkey FOREIGN KEY (tenant_id, owner_department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('complaints.complaints_owner_user_id_fkey FOREIGN KEY (tenant_id, owner_user_id) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('complaints.complaints_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('conversation_messages.conversation_messages_conversation_id_fkey FOREIGN KEY (tenant_id, conversation_id) REFERENCES conversations(tenant_id, id) ON DELETE RESTRICT'),
       ('conversation_messages.conversation_messages_sender_user_id_fkey FOREIGN KEY (tenant_id, sender_user_id) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('conversation_messages.conversation_messages_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('conversations.conversations_booking_id_fkey FOREIGN KEY (tenant_id, booking_id) REFERENCES bookings(tenant_id, id) ON DELETE RESTRICT'),
       ('conversations.conversations_booking_item_id_fkey FOREIGN KEY (tenant_id, booking_item_id) REFERENCES booking_items(tenant_id, id) ON DELETE RESTRICT'),
       ('conversations.conversations_current_branch_id_fkey FOREIGN KEY (tenant_id, current_branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('conversations.conversations_current_department_id_fkey FOREIGN KEY (tenant_id, current_department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('conversations.conversations_lead_id_fkey FOREIGN KEY (tenant_id, lead_id) REFERENCES leads(tenant_id, id) ON DELETE RESTRICT'),
       ('conversations.conversations_owner_branch_id_fkey FOREIGN KEY (tenant_id, owner_branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('conversations.conversations_owner_department_id_fkey FOREIGN KEY (tenant_id, owner_department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('conversations.conversations_owner_user_id_fkey FOREIGN KEY (tenant_id, owner_user_id) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('conversations.conversations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('customer_consents.customer_consents_tenant_id_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('customer_consents.customer_consents_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('customer_contact_methods.customer_contact_methods_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('customer_identity_merges.customer_identity_merges_merged_by_fkey FOREIGN KEY (tenant_id, merged_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('customer_identity_merges.customer_identity_merges_source_customer_id_fkey FOREIGN KEY (tenant_id, source_customer_id) REFERENCES customers(tenant_id, id) ON DELETE RESTRICT'),
       ('customer_identity_merges.customer_identity_merges_target_customer_id_fkey FOREIGN KEY (tenant_id, target_customer_id) REFERENCES customers(tenant_id, id) ON DELETE RESTRICT'),
       ('customer_identity_merges.customer_identity_merges_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('customer_identity_signals.customer_identity_signals_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('customer_notes.customer_notes_archived_by_fkey FOREIGN KEY (tenant_id, archived_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('customer_notes.customer_notes_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('customer_notes.customer_notes_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('customers.customers_archived_by_fkey FOREIGN KEY (tenant_id, archived_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('customers.customers_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('customers.customers_first_registered_branch_id_fkey FOREIGN KEY (tenant_id, first_registered_branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('customers.customers_first_registered_user_id_fkey FOREIGN KEY (tenant_id, first_registered_user_id) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('customers.customers_last_interaction_branch_id_fkey FOREIGN KEY (tenant_id, last_interaction_branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('customers.customers_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('departments.departments_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('document_links.document_links_booking_id_fkey FOREIGN KEY (tenant_id, booking_id) REFERENCES bookings(tenant_id, id) ON DELETE RESTRICT'),
       ('document_links.document_links_booking_item_id_fkey FOREIGN KEY (tenant_id, booking_item_id) REFERENCES booking_items(tenant_id, id) ON DELETE RESTRICT'),
       ('document_links.document_links_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('document_links.document_links_document_id_fkey FOREIGN KEY (tenant_id, document_id) REFERENCES documents(tenant_id, id) ON DELETE RESTRICT'),
       ('document_links.document_links_invoice_id_fkey FOREIGN KEY (tenant_id, invoice_id) REFERENCES invoices(tenant_id, id) ON DELETE RESTRICT'),
       ('document_links.document_links_passenger_id_fkey FOREIGN KEY (tenant_id, passenger_id) REFERENCES passengers(tenant_id, id) ON DELETE RESTRICT'),
       ('document_links.document_links_quotation_id_fkey FOREIGN KEY (tenant_id, quotation_id) REFERENCES quotations(tenant_id, id) ON DELETE RESTRICT'),
       ('document_links.document_links_receipt_id_fkey FOREIGN KEY (tenant_id, receipt_id) REFERENCES receipts(tenant_id, id) ON DELETE RESTRICT'),
       ('document_links.document_links_supplier_id_fkey FOREIGN KEY (tenant_id, supplier_id) REFERENCES suppliers(tenant_id, id) ON DELETE RESTRICT'),
       ('document_links.document_links_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('document_retention_policies.document_retention_policies_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('document_retention_policies.document_retention_policies_tenant_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('document_storage_findings.document_storage_findings_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('document_storage_findings.document_storage_findings_version_fkey FOREIGN KEY (tenant_id, document_version_id) REFERENCES document_versions(tenant_id, id) ON DELETE RESTRICT'),
       ('document_versions.document_versions_document_id_fkey FOREIGN KEY (tenant_id, document_id) REFERENCES documents(tenant_id, id) ON DELETE RESTRICT'),
       ('document_versions.document_versions_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('document_versions.document_versions_uploaded_by_fkey FOREIGN KEY (tenant_id, uploaded_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('documents.documents_archived_by_fkey FOREIGN KEY (tenant_id, archived_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('documents.documents_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('documents.documents_legal_hold_changed_by_fkey FOREIGN KEY (tenant_id, legal_hold_changed_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('documents.documents_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('events.events_actor_user_id_fkey FOREIGN KEY (tenant_id, actor_user_id) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('events.events_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('exchange_rate_adjustments.exchange_rate_adjustments_booking_item_id_fkey FOREIGN KEY (tenant_id, booking_item_id) REFERENCES booking_items(tenant_id, id) ON DELETE RESTRICT'),
       ('exchange_rate_adjustments.exchange_rate_adjustments_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('exchange_rate_adjustments.exchange_rate_adjustments_new_exchange_rate_id_fkey FOREIGN KEY (tenant_id, new_exchange_rate_id) REFERENCES exchange_rates(tenant_id, id) ON DELETE RESTRICT'),
       ('exchange_rate_adjustments.exchange_rate_adjustments_original_exchange_rate_id_fkey FOREIGN KEY (tenant_id, original_exchange_rate_id) REFERENCES exchange_rates(tenant_id, id) ON DELETE RESTRICT'),
       ('exchange_rate_adjustments.exchange_rate_adjustments_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('exchange_rates.exchange_rates_from_currency_code_fkey FOREIGN KEY (from_currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('exchange_rates.exchange_rates_set_by_fkey FOREIGN KEY (tenant_id, set_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('exchange_rates.exchange_rates_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('exchange_rates.exchange_rates_to_currency_code_fkey FOREIGN KEY (to_currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('feature_entitlements.feature_entitlements_subscription_plan_id_fkey FOREIGN KEY (subscription_plan_id) REFERENCES subscription_plans(id) ON DELETE RESTRICT'),
       ('financial_accounts.financial_accounts_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('holidays.holidays_branch_id_fkey FOREIGN KEY (tenant_id, branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('holidays.holidays_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('internal_supplier_links.internal_supplier_links_booking_item_id_fkey FOREIGN KEY (tenant_id, booking_item_id) REFERENCES booking_items(tenant_id, id) ON DELETE RESTRICT'),
       ('internal_supplier_links.internal_supplier_links_provider_branch_id_fkey FOREIGN KEY (tenant_id, provider_branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('internal_supplier_links.internal_supplier_links_provider_department_id_fkey FOREIGN KEY (tenant_id, provider_department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('internal_supplier_links.internal_supplier_links_requester_branch_id_fkey FOREIGN KEY (tenant_id, requester_branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('internal_supplier_links.internal_supplier_links_requester_department_id_fkey FOREIGN KEY (tenant_id, requester_department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('internal_supplier_links.internal_supplier_links_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('invoices.invoices_archived_by_fkey FOREIGN KEY (tenant_id, archived_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('invoices.invoices_booking_id_fkey FOREIGN KEY (tenant_id, booking_id) REFERENCES bookings(tenant_id, id) ON DELETE RESTRICT'),
       ('invoices.invoices_booking_item_id_fkey FOREIGN KEY (tenant_id, booking_item_id) REFERENCES booking_items(tenant_id, id) ON DELETE RESTRICT'),
       ('invoices.invoices_corrects_invoice_fkey FOREIGN KEY (tenant_id, corrects_invoice_id) REFERENCES invoices(tenant_id, id) ON DELETE RESTRICT'),
       ('invoices.invoices_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('invoices.invoices_currency_code_fkey FOREIGN KEY (currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('invoices.invoices_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('invoices.invoices_voided_by_fkey FOREIGN KEY (tenant_id, voided_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('journal_entries.journal_entries_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('journal_entries.journal_entries_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('journal_entries.journal_entries_voided_by_fkey FOREIGN KEY (tenant_id, voided_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('journal_entry_lines.journal_entry_lines_chart_account_id_fkey FOREIGN KEY (tenant_id, chart_account_id) REFERENCES chart_of_accounts(tenant_id, id) ON DELETE RESTRICT'),
       ('journal_entry_lines.journal_entry_lines_currency_code_fkey FOREIGN KEY (currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('journal_entry_lines.journal_entry_lines_journal_entry_id_fkey FOREIGN KEY (tenant_id, journal_entry_id) REFERENCES journal_entries(tenant_id, id) ON DELETE RESTRICT'),
       ('journal_entry_lines.journal_entry_lines_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('lead_assignments.lead_assignments_assigned_by_fkey FOREIGN KEY (tenant_id, assigned_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('lead_assignments.lead_assignments_lead_id_fkey FOREIGN KEY (tenant_id, lead_id) REFERENCES leads(tenant_id, id) ON DELETE RESTRICT'),
       ('lead_assignments.lead_assignments_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('lead_interactions.lead_interactions_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('lead_interactions.lead_interactions_user_id_fkey FOREIGN KEY (tenant_id, user_id) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('leads.leads_archived_by_fkey FOREIGN KEY (tenant_id, archived_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('leads.leads_attribution_click_id_fkey FOREIGN KEY (tenant_id, attribution_click_id) REFERENCES attribution_clicks(tenant_id, id) ON DELETE RESTRICT'),
       ('leads.leads_branch_id_fkey FOREIGN KEY (tenant_id, branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('leads.leads_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('leads.leads_department_id_fkey FOREIGN KEY (tenant_id, department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('leads.leads_owner_branch_id_fkey FOREIGN KEY (tenant_id, owner_branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('leads.leads_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('marketing_campaigns.marketing_campaigns_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('notification_deliveries.notification_deliveries_notification_id_fkey FOREIGN KEY (tenant_id, notification_id) REFERENCES notifications(tenant_id, id) ON DELETE RESTRICT'),
       ('notification_deliveries.notification_deliveries_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('notifications.notifications_target_user_id_fkey FOREIGN KEY (tenant_id, target_user_id) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('notifications.notifications_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('offline_conversion_deliveries.offline_conversion_deliveries_offline_conversion_id_fkey FOREIGN KEY (tenant_id, offline_conversion_id) REFERENCES offline_conversions(tenant_id, id) ON DELETE RESTRICT'),
       ('offline_conversion_deliveries.offline_conversion_deliveries_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('offline_conversions.offline_conversions_attribution_click_id_fkey FOREIGN KEY (tenant_id, attribution_click_id) REFERENCES attribution_clicks(tenant_id, id) ON DELETE RESTRICT'),
       ('offline_conversions.offline_conversions_booking_id_fkey FOREIGN KEY (tenant_id, booking_id) REFERENCES bookings(tenant_id, id) ON DELETE RESTRICT'),
       ('offline_conversions.offline_conversions_booking_item_id_fkey FOREIGN KEY (tenant_id, booking_item_id) REFERENCES booking_items(tenant_id, id) ON DELETE RESTRICT'),
       ('offline_conversions.offline_conversions_currency_code_fkey FOREIGN KEY (currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('offline_conversions.offline_conversions_marketing_campaign_id_fkey FOREIGN KEY (tenant_id, marketing_campaign_id) REFERENCES marketing_campaigns(tenant_id, id) ON DELETE RESTRICT'),
       ('offline_conversions.offline_conversions_payment_id_fkey FOREIGN KEY (tenant_id, payment_id) REFERENCES payments(tenant_id, id) ON DELETE RESTRICT'),
       ('offline_conversions.offline_conversions_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('otp_challenges.otp_challenges_auth_user_id_fkey FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE CASCADE'),
       ('passengers.passengers_archived_by_fkey FOREIGN KEY (tenant_id, archived_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('passengers.passengers_passport_issuing_country_code_fkey FOREIGN KEY (passport_issuing_country_code) REFERENCES countries(code) ON DELETE RESTRICT'),
       ('passengers.passengers_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('payment_allocations.payment_allocations_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('payment_allocations.payment_allocations_currency_code_fkey FOREIGN KEY (currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('payment_allocations.payment_allocations_exchange_rate_id_fkey FOREIGN KEY (tenant_id, exchange_rate_id) REFERENCES exchange_rates(tenant_id, id) ON DELETE RESTRICT'),
       ('payment_allocations.payment_allocations_invoice_id_fkey FOREIGN KEY (tenant_id, invoice_id) REFERENCES invoices(tenant_id, id) ON DELETE RESTRICT'),
       ('payment_allocations.payment_allocations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('payments.payments_account_currency_code_fkey FOREIGN KEY (account_currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('payments.payments_booking_id_fkey FOREIGN KEY (tenant_id, booking_id) REFERENCES bookings(tenant_id, id) ON DELETE RESTRICT'),
       ('payments.payments_booking_item_id_fkey FOREIGN KEY (tenant_id, booking_item_id) REFERENCES booking_items(tenant_id, id) ON DELETE RESTRICT'),
       ('payments.payments_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('payments.payments_currency_code_fkey FOREIGN KEY (currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('payments.payments_exchange_rate_id_fkey FOREIGN KEY (tenant_id, exchange_rate_id) REFERENCES exchange_rates(tenant_id, id) ON DELETE RESTRICT'),
       ('payments.payments_financial_account_id_fkey FOREIGN KEY (tenant_id, financial_account_id) REFERENCES financial_accounts(tenant_id, id) ON DELETE RESTRICT'),
       ('payments.payments_received_by_fkey FOREIGN KEY (tenant_id, received_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('payments.payments_supplier_id_fkey FOREIGN KEY (tenant_id, supplier_id) REFERENCES suppliers(tenant_id, id) ON DELETE RESTRICT'),
       ('payments.payments_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('quotation_items.quotation_items_currency_code_fkey FOREIGN KEY (currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('quotation_items.quotation_items_quotation_id_fkey FOREIGN KEY (tenant_id, quotation_id) REFERENCES quotations(tenant_id, id) ON DELETE RESTRICT'),
       ('quotation_items.quotation_items_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('quotations.quotations_archived_by_fkey FOREIGN KEY (tenant_id, archived_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('quotations.quotations_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('quotations.quotations_currency_code_fkey FOREIGN KEY (currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('quotations.quotations_lead_id_fkey FOREIGN KEY (tenant_id, lead_id) REFERENCES leads(tenant_id, id) ON DELETE RESTRICT'),
       ('quotations.quotations_owner_branch_id_fkey FOREIGN KEY (tenant_id, owner_branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('quotations.quotations_owner_department_id_fkey FOREIGN KEY (tenant_id, owner_department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('quotations.quotations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('receipts.receipts_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('receipts.receipts_payment_id_fkey FOREIGN KEY (tenant_id, payment_id) REFERENCES payments(tenant_id, id) ON DELETE RESTRICT'),
       ('receipts.receipts_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('refunds.refunds_booking_id_fkey FOREIGN KEY (tenant_id, booking_id) REFERENCES bookings(tenant_id, id) ON DELETE RESTRICT'),
       ('refunds.refunds_booking_item_id_fkey FOREIGN KEY (tenant_id, booking_item_id) REFERENCES booking_items(tenant_id, id) ON DELETE RESTRICT'),
       ('refunds.refunds_currency_code_fkey FOREIGN KEY (currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('refunds.refunds_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('role_permissions.role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE RESTRICT'),
       ('role_permissions.role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE RESTRICT'),
       ('scheduled_job_findings.scheduled_job_findings_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('security_events.security_events_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('security_events.security_events_user_id_fkey FOREIGN KEY (tenant_id, user_id) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('service_requests.service_requests_archived_by_fkey FOREIGN KEY (tenant_id, archived_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('service_requests.service_requests_booking_id_fkey FOREIGN KEY (tenant_id, booking_id) REFERENCES bookings(tenant_id, id) ON DELETE RESTRICT'),
       ('service_requests.service_requests_booking_item_id_fkey FOREIGN KEY (tenant_id, booking_item_id) REFERENCES booking_items(tenant_id, id) ON DELETE RESTRICT'),
       ('service_requests.service_requests_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('service_requests.service_requests_owner_branch_id_fkey FOREIGN KEY (tenant_id, owner_branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('service_requests.service_requests_owner_department_id_fkey FOREIGN KEY (tenant_id, owner_department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('service_requests.service_requests_owner_user_id_fkey FOREIGN KEY (tenant_id, owner_user_id) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('service_requests.service_requests_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('subscription_payment_proofs.subscription_payment_proofs_reviewed_by_fkey FOREIGN KEY (tenant_id, reviewed_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('subscription_payment_proofs.subscription_payment_proofs_subscription_id_fkey FOREIGN KEY (tenant_id, subscription_id) REFERENCES subscriptions(tenant_id, id) ON DELETE RESTRICT'),
       ('subscription_payment_proofs.subscription_payment_proofs_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('subscription_payment_proofs.subscription_payment_proofs_uploaded_by_fkey FOREIGN KEY (tenant_id, uploaded_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('subscriptions.subscriptions_subscription_plan_id_fkey FOREIGN KEY (subscription_plan_id) REFERENCES subscription_plans(id) ON DELETE RESTRICT'),
       ('subscriptions.subscriptions_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('suppliers.suppliers_archived_by_fkey FOREIGN KEY (tenant_id, archived_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('suppliers.suppliers_credit_limit_currency_code_fkey FOREIGN KEY (credit_limit_currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('suppliers.suppliers_internal_branch_id_fkey FOREIGN KEY (tenant_id, internal_branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('suppliers.suppliers_internal_department_id_fkey FOREIGN KEY (tenant_id, internal_department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('suppliers.suppliers_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('tasks.tasks_archived_by_fkey FOREIGN KEY (tenant_id, archived_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('tasks.tasks_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('tasks.tasks_owner_branch_id_fkey FOREIGN KEY (tenant_id, owner_branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('tasks.tasks_owner_department_id_fkey FOREIGN KEY (tenant_id, owner_department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('tasks.tasks_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('tenant_license_activations.tenant_license_activations_consumed_by_fkey FOREIGN KEY (tenant_id, consumed_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('tenant_license_activations.tenant_license_activations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('tenants.tenants_default_currency_code_fkey FOREIGN KEY (default_currency_code) REFERENCES currencies(code) ON DELETE RESTRICT'),
       ('usage_counters.usage_counters_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('user_branch_assignments.user_branch_assignments_created_by_fkey FOREIGN KEY (tenant_id, created_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('user_branch_assignments.user_branch_assignments_department_id_fkey FOREIGN KEY (tenant_id, department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('user_branch_assignments.user_branch_assignments_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('user_permission_grants.user_permission_grants_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE RESTRICT'),
       ('user_permission_grants.user_permission_grants_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('user_role_assignments.user_role_assignments_assigned_by_fkey FOREIGN KEY (tenant_id, assigned_by) REFERENCES users(tenant_id, id) ON DELETE RESTRICT'),
       ('user_role_assignments.user_role_assignments_branch_id_fkey FOREIGN KEY (tenant_id, branch_id) REFERENCES branches(tenant_id, id) ON DELETE RESTRICT'),
       ('user_role_assignments.user_role_assignments_department_id_fkey FOREIGN KEY (tenant_id, department_id) REFERENCES departments(tenant_id, id) ON DELETE RESTRICT'),
       ('user_role_assignments.user_role_assignments_role_id_fkey FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE RESTRICT'),
       ('user_role_assignments.user_role_assignments_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT'),
       ('users.users_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE RESTRICT')$e$,
     'each of the 244 pinned foreign keys is present with its recorded definition');

   select set_has(
     $a$select tablename || '.' || policyname || ' ' || permissive || ' ' || array_to_string(roles, ',') || ' ' || cmd || ' ' || md5(coalesce(qual, '') || '|' || coalesce(with_check, '')) from pg_policies where schemaname = 'public'$a$,
     $e$values
       ('branches.scope_delete PERMISSIVE authenticated DELETE faf0d4906aca9ad5f8b59f2afa297fb4'),
       ('catalog_values.catalog_tenant_delete PERMISSIVE authenticated DELETE b1461c0372818a6d78f25d9c9f6d197c'),
       ('chart_of_accounts.scope_delete PERMISSIVE authenticated DELETE 76ad84862b563ac7cf1ffd4d7d06a3e7'),
       ('departments.scope_delete PERMISSIVE authenticated DELETE d2d961a3fef22abda8590e3c3fbb0f9a'),
       ('events.audit_insert PERMISSIVE authenticated INSERT 6ff708dfd78c4394ef6440a1cf1aa6a3'),
       ('exchange_rates.scope_delete PERMISSIVE authenticated DELETE e4db04bc4708e7af563e6103ee501a8a'),
       ('journal_entries.scope_delete PERMISSIVE authenticated DELETE 76ad84862b563ac7cf1ffd4d7d06a3e7'),
       ('journal_entries.scope_insert PERMISSIVE authenticated INSERT 1d014b22847bb2764dd4538ec7d36c81'),
       ('journal_entries.scope_read PERMISSIVE authenticated SELECT e4fcf4f527f2d05d88d0bb2e75492f4f'),
       ('journal_entries.scope_update PERMISSIVE authenticated UPDATE 2a156b0d8ef8c8e2689ecc3926c0c2d9'),
       ('journal_entry_lines.scope_delete PERMISSIVE authenticated DELETE 76ad84862b563ac7cf1ffd4d7d06a3e7'),
       ('journal_entry_lines.scope_insert PERMISSIVE authenticated INSERT 1d014b22847bb2764dd4538ec7d36c81'),
       ('journal_entry_lines.scope_update PERMISSIVE authenticated UPDATE 2a156b0d8ef8c8e2689ecc3926c0c2d9'),
       ('scheduled_job_findings.platform_only PERMISSIVE authenticated ALL 18b6c82111707e214f8aaa30c5b6e717'),
       ('security_events.audit_insert PERMISSIVE authenticated INSERT 6ff708dfd78c4394ef6440a1cf1aa6a3'),
       ('subscription_payment_proofs.scope_update PERMISSIVE authenticated UPDATE cf13f1261e4cee095021a2ec7d18bc89'),
       ('subscriptions.scope_delete PERMISSIVE authenticated DELETE 3c10d7f5f74ebcb211dc0e3456897954'),
       ('subscriptions.scope_update PERMISSIVE authenticated UPDATE 4d7d4188d4084ff6515cedb156d9dfc8'),
       ('tenants.scope_delete PERMISSIVE authenticated DELETE 3097a43453b68a82af36118adf211481'),
       ('user_branch_assignments.scope_delete PERMISSIVE authenticated DELETE da74996cfccb795bf15a8f028988fc91'),
       ('user_role_assignments.scope_delete PERMISSIVE authenticated DELETE da74996cfccb795bf15a8f028988fc91'),
       ('users.scope_delete PERMISSIVE authenticated DELETE da74996cfccb795bf15a8f028988fc91')$e$,
     'each of the 22 pinned row-level security policies is present with its recorded definition');

   select set_has(
     $a$select tgrelid::regclass::text || '.' || tgname || ' ' || tgenabled::text || ' ' || md5(pg_get_triggerdef(oid)) from pg_trigger where not tgisinternal and tgrelid::regclass::text not like '%.%'$a$,
     $e$values
       ('booking_items.booking_items_set_updated_at O b1ea83c60dc267e8fcb8bf59ced75c5e'),
       ('bookings.bookings_set_updated_at O 3319cc14a14fadc148591d85d45fbcbe'),
       ('branch_business_hours.branch_business_hours_set_updated_at O dbcb83038e2aa651860f2186b613c03e'),
       ('branches.branches_set_updated_at O 03fa1e058ceaf5239ae94e7b4620c688'),
       ('campaign_daily_metrics.campaign_daily_metrics_set_updated_at O 5cb8c841d649c469a990e48fb908b3e8'),
       ('catalog_values.catalog_values_set_updated_at O 6b904a0c412eab884237069832eac397'),
       ('chart_of_accounts.chart_of_accounts_set_updated_at O 5975e65bc1cd6e0c70e19afc3c51502d'),
       ('company_assets.company_assets_set_updated_at O 42577ae754286556994c743776469ae2'),
       ('complaints.complaints_set_updated_at O a42cbcfc1036379c73cc3823b158eb5a'),
       ('conversations.conversations_set_updated_at O 92f3b312696e8b1ee3ec6d99bf75d05a'),
       ('countries.countries_set_updated_at O 1421fb695e1f97c8648e72a8a012330e'),
       ('currencies.currencies_set_updated_at O 2c174b602b9a4860e97d88421c935457'),
       ('customer_contact_methods.customer_contact_methods_set_updated_at O be0dcf1a24be48859622651a57d66bef'),
       ('customer_notes.customer_notes_set_updated_at O 53f32ebbdfb7de83ff39ea4e9546541e'),
       ('customers.customers_set_updated_at O ccfad2eb150d623c66c1a895877fe5b3'),
       ('departments.departments_set_updated_at O d082b4ea570541fb0a69229ee8403910'),
       ('document_retention_policies.document_retention_policies_set_updated_at O 7d021f1d74e5e5551fc4ca5725b199b6'),
       ('documents.documents_set_updated_at O 688a142b5f7156a844cbd57ffbe42aac'),
       ('financial_accounts.financial_accounts_set_updated_at O 70607e19acaa7500c212178a3fb245fb'),
       ('holidays.holidays_set_updated_at O 712427ed711cb379408f5568c3f58657'),
       ('integration_cursors.integration_cursors_set_updated_at O cb1d99e7a647c036b98ae23c11636b56'),
       ('invoices.invoices_set_updated_at O 0e9059cccfed37bfa0faa4446964af87'),
       ('languages.languages_set_updated_at O 1566d1f8d2f9ce84a2af7ca049d9d830'),
       ('leads.leads_set_updated_at O 55bc1b09f49454cbbc0716cffd1b92c3'),
       ('marketing_campaigns.marketing_campaigns_set_updated_at O 5654e18ca1aaddbea97fbb9ef1ed773f'),
       ('nationalities.nationalities_set_updated_at O 34cbde1b6cc754b4c317774285e41073'),
       ('passengers.passengers_set_updated_at O f4a44b04c9270bc0b0b2a0697b6920c5'),
       ('quotations.quotations_set_updated_at O 577989c945901b4064d56b1e70b29d20'),
       ('refunds.refunds_set_updated_at O 55fc4b1a32bef8150851aa43a853a0d9'),
       ('service_requests.service_requests_set_updated_at O 7dc87d862316be9ac313f2f96fcb5a34'),
       ('subscriptions.subscriptions_set_updated_at O f2bbf2c0599a47eb8c1639fa6697368b'),
       ('suppliers.suppliers_set_updated_at O 65079ebaf30b34d2f72c244ba7f008e0'),
       ('tasks.tasks_set_updated_at O 205616144138d0a973633a15257605e4'),
       ('tenants.tenants_set_updated_at O 63e80e160a8f3f38771ce10b294f1a54'),
       ('user_permission_grants.user_permission_grants_set_updated_at O b80172eb7effbed26f4c46751d253af4'),
       ('users.users_set_updated_at O 24f756d48b64a13b65962916c6dcee9b')$e$,
     'each of the 36 pinned triggers is present with its recorded definition');

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is 472b404c67b1656b5c0013bbbb86f1b7a2e33b4a.

20. Check whether `supabase/tests/194_door_evidence_and_sale_dates_open_pins_test.sql` contains `select plan(11);`; if so record Already Applied when its Git blob is 0390d2a92ead6a69ff20e2276332adfc9a036c4c, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 194, 11 assertions), and change nothing else:

   ```text
   -- pgTAP: the open table-door findings of the documents/quotations re-sweep and the backdated sale (DOC-11, QUO-11,
   -- QUO-12, BOOK-13), pinned as OPEN.
   --
   -- EC-8 / gate re-sweep: SPEC-335 measured each finding at 676df3e and registered it with its class and boundary.
   --   Each OPEN assertion below records the defect as it stands; it is NOT desired behaviour. As Test 130 pins
   --   BRANCH-2, each one FAILS when its finding is repaired, so the repair must update this file and the register
   --   in the same change. A repair that refuses the door write fails the lives_ok step instead.
   --   * DOC-11: a document created at the table door records no document_uploaded, while app.upload_document does.
   --   * QUO-11: a quotation created at the table door records no quotation_created, and door transitions to sent and
   --     accepted record nothing and leave sent_at and accepted_at null.
   --   * QUO-12: the assigned member renumbers and re-leads a quotation, and a manager reassigns its owner, at the
   --     table door with no event; no RPC offers these changes.
   --   * BOOK-13: a member chooses or rewrites the creation date of their own booking and booking item, and
   --     reporting.sales_activity and reporting.my_sales_performance report the chosen date.
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(11);

   insert into auth.users (id, email) values
     ('19400000-0000-0000-0000-0000000000a1','emp@t194.test'),
     ('19400000-0000-0000-0000-0000000000a2','mgr@t194.test');
   insert into public.tenants (id, name, slug, status) values
     ('19400000-0000-0000-0000-000000000001','T194 Travel','t194-travel','active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select '19400000-0000-0000-0000-000000000001', sp.id, 'active' from public.subscription_plans sp
   where sp.plan_code = 'enterprise';
   insert into public.branches (id, tenant_id, name, slug) values
     ('19400000-0000-0000-0000-00000000000a','19400000-0000-0000-0000-000000000001','Cairo','t194-cairo');
   insert into public.departments (id, tenant_id, branch_id, department_type_code, name) values
     ('19400000-0000-0000-0000-0000000000c1','19400000-0000-0000-0000-000000000001','19400000-0000-0000-0000-00000000000a','sales','Sales');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
     ('19400000-0000-0000-0000-000000000011','19400000-0000-0000-0000-000000000001','Emp','emp@t194.test',true,'19400000-0000-0000-0000-0000000000a1'),
     ('19400000-0000-0000-0000-000000000021','19400000-0000-0000-0000-000000000001','Mgr','mgr@t194.test',true,'19400000-0000-0000-0000-0000000000a2');
   insert into public.user_branch_assignments (tenant_id, user_id, branch_id, department_id, is_primary)
   select '19400000-0000-0000-0000-000000000001', u, '19400000-0000-0000-0000-00000000000a', '19400000-0000-0000-0000-0000000000c1', true
   from unnest(array['19400000-0000-0000-0000-000000000011'::uuid,'19400000-0000-0000-0000-000000000021']) u;
   insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type)
   select '19400000-0000-0000-0000-000000000001', v.u, r.id, 'tenant'
   from (values ('19400000-0000-0000-0000-000000000011'::uuid,'employee'),
                ('19400000-0000-0000-0000-000000000021'::uuid,'branch_manager')) v(u, rc)
   join public.roles r on r.code = v.rc;
   insert into public.customers (id, tenant_id, customer_type_code, full_name, first_registered_branch_id) values
     ('19400000-0000-0000-0000-0000000000d1','19400000-0000-0000-0000-000000000001','person','Buyer','19400000-0000-0000-0000-00000000000a');
   insert into public.suppliers (id, tenant_id, name, supplier_type_code) values
     ('19400000-0000-0000-0000-0000000000e1','19400000-0000-0000-0000-000000000001','Nile Air','airline');
   insert into public.leads (id, tenant_id, branch_id, department_id, customer_id, lead_source_code, title, lead_status_code) values
     ('19400000-0000-0000-0000-0000000000f1','19400000-0000-0000-0000-000000000001','19400000-0000-0000-0000-00000000000a','19400000-0000-0000-0000-0000000000c1','19400000-0000-0000-0000-0000000000d1','direct_call','Lead A','new'),
     ('19400000-0000-0000-0000-0000000000f2','19400000-0000-0000-0000-000000000001','19400000-0000-0000-0000-00000000000a','19400000-0000-0000-0000-0000000000c1','19400000-0000-0000-0000-0000000000d1','direct_call','Lead B','new');
   -- Written as `postgres`: emp's booking and the item emp sold.
   insert into public.bookings (id, tenant_id, branch_id, department_id, customer_id, owner_user_id,
       owner_branch_id, owner_department_id, booking_status_code, title, booking_reference) values
     ('19400000-0000-0000-0000-0000000000b1','19400000-0000-0000-0000-000000000001','19400000-0000-0000-0000-00000000000a','19400000-0000-0000-0000-0000000000c1','19400000-0000-0000-0000-0000000000d1','19400000-0000-0000-0000-000000000011','19400000-0000-0000-0000-00000000000a','19400000-0000-0000-0000-0000000000c1','draft','Trip','T194-B1');
   insert into public.booking_items (id, tenant_id, booking_id, service_type_code, base_status_code,
       currency_code, cost_amount, selling_amount, owner_user_id, owner_branch_id, owner_department_id,
       sales_owner_user_id, sales_owner_branch_id, sales_owner_department_id) values
     ('19400000-0000-0000-0000-0000000000b2','19400000-0000-0000-0000-000000000001','19400000-0000-0000-0000-0000000000b1','hotel','draft','EGP',100,150,'19400000-0000-0000-0000-000000000011','19400000-0000-0000-0000-00000000000a','19400000-0000-0000-0000-0000000000c1','19400000-0000-0000-0000-000000000011','19400000-0000-0000-0000-00000000000a','19400000-0000-0000-0000-0000000000c1');

   -- Events recorded on the quotation or document with this number or title, other than the excluded type.
   create function pg_temp.t194_q(p_number text, p_not text default '') returns int language sql as $$
     select count(e.id)::int from public.quotations q join public.events e on e.entity_id = q.id
     where q.tenant_id = '19400000-0000-0000-0000-000000000001' and q.quotation_number = p_number
       and e.event_type_code <> p_not
   $$;
   create function pg_temp.t194_d(p_title text) returns int language sql as $$
     select count(e.id)::int from public.documents d join public.events e on e.entity_id = d.id
     where d.tenant_id = '19400000-0000-0000-0000-000000000001' and d.title = p_title
   $$;
   grant execute on function pg_temp.t194_q(text, text) to authenticated;
   grant execute on function pg_temp.t194_d(text) to authenticated;

   -- ================================================================================================
   -- emp: the RPC doors (positive controls) and the table doors (OPEN pins)
   -- ================================================================================================
   select set_config('request.jwt.claims','{"sub":"19400000-0000-0000-0000-0000000000a1","aal":"aal2"}',true);
   set local role authenticated;

   select app.create_quotation('19400000-0000-0000-0000-0000000000d1','EGP','19400000-0000-0000-0000-0000000000f1',null,'T194-RPC');
   select is(pg_temp.t194_q('T194-RPC'), 1,
     'POSITIVE CONTROL: app.create_quotation records exactly one quotation_created');

   select lives_ok(
     $$insert into public.quotations (tenant_id, customer_id, owner_user_id, owner_branch_id, owner_department_id,
         quotation_status_code, quotation_number, currency_code, total_amount)
       values ('19400000-0000-0000-0000-000000000001','19400000-0000-0000-0000-0000000000d1',
         '19400000-0000-0000-0000-000000000011','19400000-0000-0000-0000-00000000000a',
         '19400000-0000-0000-0000-0000000000c1','draft','T194-DOOR','EGP',0)$$,
     'the assigned member creates a quotation at the table door');
   select is(pg_temp.t194_q('T194-DOOR'), 0,
     'QUO-11 is OPEN: a quotation created at the table door records no event (FAILS when QUO-11 is repaired)');

   select lives_ok(
     $$update public.quotations set quotation_number = 'T194-RENUMBERED', lead_id = '19400000-0000-0000-0000-0000000000f2'
        where tenant_id = '19400000-0000-0000-0000-000000000001' and quotation_number = 'T194-RPC'$$,
     'QUO-12 is OPEN: the assigned member renumbers and re-leads a quotation at the table door (FAILS when the door refuses it)');
   select is(pg_temp.t194_q('T194-RENUMBERED', 'quotation_created'), 0,
     'QUO-12 is OPEN: the renumbering and re-leading record no event (FAILS when QUO-12 is repaired)');

   select app.upload_document('contract','T194 rpc doc','a.pdf','pdf','supplier','19400000-0000-0000-0000-0000000000e1',100,null,false);
   select ok(pg_temp.t194_d('T194 rpc doc') > 0,
     'POSITIVE CONTROL: app.upload_document records its events');

   insert into public.documents (tenant_id, document_type_code, title, lifecycle_status_code, is_confidential)
     values ('19400000-0000-0000-0000-000000000001','contract','T194 door doc','active',false);
   select is(pg_temp.t194_d('T194 door doc'), 0,
     'DOC-11 is OPEN: a document created at the table door records no event (FAILS when DOC-11 is repaired)');

   insert into public.bookings (tenant_id, branch_id, department_id, customer_id, owner_user_id, booking_status_code,
       title, booking_reference, created_at)
     values ('19400000-0000-0000-0000-000000000001','19400000-0000-0000-0000-00000000000a',
       '19400000-0000-0000-0000-0000000000c1','19400000-0000-0000-0000-0000000000d1',
       '19400000-0000-0000-0000-000000000011','draft','Backdated','T194-B2','2001-01-01');
   select is((select string_agg(activity_date::text || ':' || bookings_created, ',' order by activity_date)
                from public.sales_activity where owner_user_id = '19400000-0000-0000-0000-000000000011'),
     '2001-01-01:1,' || current_date::text || ':1',
     'BOOK-13 is OPEN: a booking created at the table door keeps the creation date its member chose, and the sales activity report counts it on that date (FAILS when BOOK-13 is repaired)');

   update public.booking_items set created_at = '2001-01-01' where id = '19400000-0000-0000-0000-0000000000b2';
   select is((select sold_at::date from public.my_sales_performance
               where booking_item_id = '19400000-0000-0000-0000-0000000000b2'), '2001-01-01'::date,
     'BOOK-13 is OPEN: the sales owner rewrites a sold item''s creation date and the performance report shows it as sold then (FAILS when BOOK-13 is repaired)');

   -- ================================================================================================
   -- mgr: door transitions and reassignment (OPEN pins)
   -- ================================================================================================
   reset role;
   select set_config('request.jwt.claims','{"sub":"19400000-0000-0000-0000-0000000000a2","aal":"aal2"}',true);
   set local role authenticated;

   select app.add_quotation_item((select id from public.quotations where quotation_number = 'T194-RENUMBERED'),'hotel',100,1,'x');
   update public.quotations set quotation_status_code = 'sent' where quotation_number = 'T194-RENUMBERED';
   update public.quotations set quotation_status_code = 'accepted' where quotation_number = 'T194-RENUMBERED';
   select is((select quotation_status_code || '/' || coalesce(sent_at::text, 'null') || '/' || coalesce(accepted_at::text, 'null')
                     || '/' || pg_temp.t194_q('T194-RENUMBERED', 'quotation_created')
                from public.quotations where quotation_number = 'T194-RENUMBERED'),
     'accepted/null/null/0',
     'QUO-11 is OPEN: door transitions to sent and accepted record no event and leave sent_at and accepted_at null (FAILS when QUO-11 is repaired)');

   update public.quotations set owner_user_id = '19400000-0000-0000-0000-000000000021' where quotation_number = 'T194-RENUMBERED';
   select is((select owner_user_id::text || '/' || pg_temp.t194_q('T194-RENUMBERED', 'quotation_created')
                from public.quotations where quotation_number = 'T194-RENUMBERED'),
     '19400000-0000-0000-0000-000000000021/0',
     'QUO-12 is OPEN: a manager reassigns the quotation''s owner at the table door with no event (FAILS when QUO-12 is repaired)');

   reset role;
   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is 0390d2a92ead6a69ff20e2276332adfc9a036c4c.

21. Check whether `supabase/tests/195_every_tenant_function_refuses_a_caller_with_no_active_tenant_test.sql` contains `select plan(74);`; if so record Already Applied when its Git blob is e18dadc093b8ec000e75242f92bc204a58c289fd, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 195, 74 assertions), and change nothing else:

   ```text
   -- pgTAP: every tenant-scoped app function refuses a caller with no active tenant (EC-5, SPEC-338).
   -- ATTACK-CLASSES: AUTH TENANT
   -- The caller is a real, authenticated member whose user row is deactivated: app.current_tenant_id() is NULL for
   -- them, so each function must stop at its own first refusal with its exact message, before any authority check,
   -- read or write. Every call passes typed NULL arguments: the tenant refusal precedes every argument check.
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(74);

   insert into auth.users (id, email, email_confirmed_at) values
     ('c3380000-0000-0000-0000-0000000000a1','former@spec338.test', now());
   insert into public.tenants (id, name, slug, status) values
     ('c3380000-0000-0000-0000-000000000001','Spec338 Travel','spec338','active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select 'c3380000-0000-0000-0000-000000000001', sp.id, 'active' from public.subscription_plans sp where sp.plan_code='enterprise';
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
     ('c3380000-0000-0000-0000-000000000011','c3380000-0000-0000-0000-000000000001','Former','former@spec338.test',false,'c3380000-0000-0000-0000-0000000000a1');
   insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type)
   select 'c3380000-0000-0000-0000-000000000001','c3380000-0000-0000-0000-000000000011', r.id, 'tenant' from public.roles r where r.code='owner';

   -- END FIXTURE

   select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000a1","aal":"aal2"}',true);
   set local role authenticated;
   select is(current_user::text,'authenticated','the probe really runs as authenticated');
   select is(auth.uid(),'c3380000-0000-0000-0000-0000000000a1'::uuid,'the JWT is the deactivated member');
   select is(app.current_tenant_id(),null::uuid,'a deactivated member has no active tenant');

   select throws_ok($q$select app.add_customer_contact_method(null::uuid, null::text, null::text, null::boolean)$q$,'P0001','no active tenant for caller','app.add_customer_contact_method refuses a caller with no active tenant');
   select throws_ok($q$select app.add_customer_note(null::uuid, null::text, null::boolean, null::boolean)$q$,'P0001','no active tenant for caller','app.add_customer_note refuses a caller with no active tenant');
   select throws_ok($q$select app.add_document_version(null::uuid, null::text, null::text, null::bigint)$q$,'P0001','no active tenant for caller','app.add_document_version refuses a caller with no active tenant');
   select throws_ok($q$select app.add_quotation_item(null::uuid, null::text, null::numeric, null::numeric, null::text)$q$,'P0001','no active tenant for caller','app.add_quotation_item refuses a caller with no active tenant');
   select throws_ok($q$select app.advance_booking(null::uuid, null::text, null::text)$q$,'P0001','no active tenant for caller','app.advance_booking refuses a caller with no active tenant');
   select throws_ok($q$select app.advance_booking_item(null::uuid, null::text, null::text, null::text, null::text)$q$,'P0001','no active tenant for caller','app.advance_booking_item refuses a caller with no active tenant');
   select throws_ok($q$select app.advance_complaint(null::uuid, null::text, null::text)$q$,'P0001','no active tenant for caller','app.advance_complaint refuses a caller with no active tenant');
   select throws_ok($q$select app.advance_conversation(null::uuid, null::text, null::text)$q$,'P0001','no active tenant for caller','app.advance_conversation refuses a caller with no active tenant');
   select throws_ok($q$select app.advance_lead(null::uuid, null::text, null::text, null::text)$q$,'P0001','no active tenant for caller','app.advance_lead refuses a caller with no active tenant');
   select throws_ok($q$select app.advance_marketing_campaign(null::uuid, null::text, null::text)$q$,'P0001','no active tenant for caller','app.advance_marketing_campaign refuses a caller with no active tenant');
   select throws_ok($q$select app.advance_quotation(null::uuid, null::text, null::text)$q$,'P0001','no active tenant for caller','app.advance_quotation refuses a caller with no active tenant');
   select throws_ok($q$select app.advance_refund(null::uuid, null::text, null::text)$q$,'P0001','no active tenant for caller','app.advance_refund refuses a caller with no active tenant');
   select throws_ok($q$select app.advance_service_request(null::uuid, null::text, null::text)$q$,'P0001','no active tenant for caller','app.advance_service_request refuses a caller with no active tenant');
   select throws_ok($q$select app.advance_task(null::uuid, null::text, null::text)$q$,'P0001','no active tenant for caller','app.advance_task refuses a caller with no active tenant');
   select throws_ok($q$select app.archive_document(null::uuid, null::text)$q$,'P0001','no active tenant for caller','app.archive_document refuses a caller with no active tenant');
   select throws_ok($q$select app.assign_lead(null::uuid, null::uuid, null::text)$q$,'P0001','no active tenant for caller','app.assign_lead refuses a caller with no active tenant');
   select throws_ok($q$select app.assign_lead_round_robin(null::uuid, null::text)$q$,'P0001','no active tenant for caller','app.assign_lead_round_robin refuses a caller with no active tenant');
   select throws_ok($q$select app.assign_task(null::uuid, null::uuid, null::uuid, null::uuid, null::text)$q$,'P0001','no active tenant for caller','app.assign_task refuses a caller with no active tenant');
   select throws_ok($q$select app.assign_user_branch(null::uuid, null::uuid, null::uuid, null::boolean, null::text)$q$,'P0001','no active tenant for caller','app.assign_user_branch refuses a caller with no active tenant');
   select throws_ok($q$select app.assign_user_role(null::uuid, null::text, null::text, null::uuid, null::uuid)$q$,'P0001','no active tenant for caller','app.assign_user_role refuses a caller with no active tenant');
   select throws_ok($q$select * from app.booking_item_profit(null::uuid, null::uuid)$q$,'P0001','no active tenant for caller','app.booking_item_profit refuses a caller with no active tenant');
   select throws_ok($q$select app.convert_lead(null::uuid, null::uuid, null::text)$q$,'P0001','no active tenant for caller','app.convert_lead refuses a caller with no active tenant');
   select throws_ok($q$select app.correct_passenger_manifest(null::uuid, null::uuid, null::text)$q$,'P0001','no active tenant for caller','app.correct_passenger_manifest refuses a caller with no active tenant');
   select throws_ok($q$select app.create_booking(null::uuid, null::uuid, null::text, null::uuid, null::uuid, null::date, null::date, null::text, null::text, null::text, null::uuid)$q$,'P0001','no active tenant for caller','app.create_booking refuses a caller with no active tenant');
   select throws_ok($q$select app.create_booking_item(null::uuid, null::text, null::text, null::numeric, null::numeric, null::uuid, null::text, null::boolean)$q$,'P0001','no active tenant for caller','app.create_booking_item refuses a caller with no active tenant');
   select throws_ok($q$select app.create_branch(null::text, null::text, null::text, null::text, null::text)$q$,'P0001','no active tenant for caller','app.create_branch refuses a caller with no active tenant');
   select throws_ok($q$select app.create_complaint(null::uuid, null::text, null::text, null::text, null::text, null::uuid, null::uuid)$q$,'P0001','no active tenant for caller','app.create_complaint refuses a caller with no active tenant');
   select throws_ok($q$select app.create_customer(null::text, null::text, null::text, null::text, null::text, null::text, null::text, null::text, null::text, null::text, null::boolean, null::uuid, null::boolean)$q$,'P0001','no active tenant for caller','app.create_customer refuses a caller with no active tenant');
   select throws_ok($q$select app.create_department(null::uuid, null::text, null::text)$q$,'P0001','no active tenant for caller','app.create_department refuses a caller with no active tenant');
   select throws_ok($q$select app.create_invoice(null::uuid, null::text, null::numeric, null::uuid, null::uuid, null::date, null::date)$q$,'P0001','no active tenant for caller','app.create_invoice refuses a caller with no active tenant');
   select throws_ok($q$select app.create_journal_entry(null::text, null::date, null::text, null::jsonb, null::uuid)$q$,'P0001','no active tenant for caller','app.create_journal_entry refuses a caller with no active tenant');
   select throws_ok($q$select app.create_lead(null::uuid, null::uuid, null::text, null::text, null::text, null::text, null::uuid, null::text, null::text, null::numeric, null::jsonb)$q$,'P0001','no active tenant for caller','app.create_lead refuses a caller with no active tenant');
   select throws_ok($q$select app.create_marketing_campaign(null::text, null::text, null::text, null::timestamp with time zone)$q$,'P0001','no active tenant for caller','app.create_marketing_campaign refuses a caller with no active tenant');
   select throws_ok($q$select app.create_passenger(null::text, null::text, null::text, null::text, null::uuid, null::text, null::date, null::text, null::text, null::date, null::date, null::text)$q$,'P0001','no active tenant for caller','app.create_passenger refuses a caller with no active tenant');
   select throws_ok($q$select app.create_quotation(null::uuid, null::text, null::uuid, null::timestamp with time zone, null::text)$q$,'P0001','no active tenant for caller','app.create_quotation refuses a caller with no active tenant');
   select throws_ok($q$select app.create_service_request(null::uuid, null::text, null::text, null::text, null::text, null::uuid, null::uuid)$q$,'P0001','no active tenant for caller','app.create_service_request refuses a caller with no active tenant');
   select throws_ok($q$select app.create_supplier(null::text, null::text, null::text, null::text, null::text, null::numeric, null::text)$q$,'P0001','no active tenant for caller','app.create_supplier refuses a caller with no active tenant');
   select throws_ok($q$select app.create_task(null::text, null::text, null::uuid, null::uuid, null::uuid, null::text, null::text, null::timestamp with time zone, null::text, null::uuid)$q$,'P0001','no active tenant for caller','app.create_task refuses a caller with no active tenant');
   select throws_ok($q$select app.create_tenant_user(null::text, null::text, null::text, null::uuid)$q$,'P0001','no active tenant for caller','app.create_tenant_user refuses a caller with no active tenant');
   select throws_ok($q$select * from app.customer_balance(null::uuid, null::uuid)$q$,'P0001','no active tenant for caller','app.customer_balance refuses a caller with no active tenant');
   select throws_ok($q$select * from app.customer_credit(null::uuid)$q$,'P0001','no active tenant for caller','app.customer_credit refuses a caller with no active tenant');
   select throws_ok($q$select * from app.expiring_documents(null::integer)$q$,'P0001','no active tenant for caller','app.expiring_documents refuses a caller with no active tenant');
   select throws_ok($q$select * from app.financial_documents()$q$,'P0001','no active tenant for caller','app.financial_documents refuses a caller with no active tenant');
   select throws_ok($q$select app.issue_invoice(null::uuid, null::text)$q$,'P0001','no active tenant for caller','app.issue_invoice refuses a caller with no active tenant');
   select throws_ok($q$select app.issue_receipt(null::uuid)$q$,'P0001','no active tenant for caller','app.issue_receipt refuses a caller with no active tenant');
   select throws_ok($q$select * from app.lead_booking_readiness(null::uuid)$q$,'P0001','no active tenant for caller','app.lead_booking_readiness refuses a caller with no active tenant');
   select throws_ok($q$select app.link_internal_supplier(null::uuid, null::uuid, null::uuid, null::text)$q$,'P0001','no active tenant for caller','app.link_internal_supplier refuses a caller with no active tenant');
   select throws_ok($q$select app.link_passenger_to_booking_item(null::uuid, null::uuid, null::numeric, null::numeric)$q$,'P0001','no active tenant for caller','app.link_passenger_to_booking_item refuses a caller with no active tenant');
   select throws_ok($q$select app.merge_customer_identity(null::uuid, null::uuid, null::text)$q$,'P0001','no active tenant for caller','app.merge_customer_identity refuses a caller with no active tenant');
   select throws_ok($q$select app.reassign_booking_item(null::uuid, null::text, null::uuid, null::uuid, null::uuid)$q$,'P0001','no active tenant for caller','app.reassign_booking_item refuses a caller with no active tenant');
   select throws_ok($q$select app.reassign_lead(null::uuid, null::uuid, null::text)$q$,'P0001','no active tenant for caller','app.reassign_lead refuses a caller with no active tenant');
   select throws_ok($q$select app.record_customer_consent(null::uuid, null::text, null::text, null::text, null::text)$q$,'P0001','no active tenant for caller','app.record_customer_consent refuses a caller with no active tenant');
   select throws_ok($q$select app.record_lead_interaction(null::uuid, null::text, null::text, null::jsonb)$q$,'P0001','no active tenant for caller','app.record_lead_interaction refuses a caller with no active tenant');
   select throws_ok($q$select app.record_offline_conversion(null::text, null::uuid, null::uuid, null::uuid, null::uuid, null::uuid, null::uuid, null::numeric, null::text, null::timestamp with time zone)$q$,'P0001','no active tenant for caller','app.record_offline_conversion refuses a caller with no active tenant');
   select throws_ok($q$select app.record_payment(null::uuid, null::numeric, null::text, null::timestamp with time zone, null::text)$q$,'P0001','no active tenant for caller','app.record_payment refuses a caller with no active tenant');
   select throws_ok($q$select app.record_refund(null::uuid, null::numeric, null::text, null::text, null::uuid, null::uuid)$q$,'P0001','no active tenant for caller','app.record_refund refuses a caller with no active tenant');
   select throws_ok($q$select app.record_supplier_payment(null::uuid, null::numeric, null::text, null::text, null::uuid, null::timestamp with time zone, null::text)$q$,'P0001','no active tenant for caller','app.record_supplier_payment refuses a caller with no active tenant');
   select throws_ok($q$select app.redeem_license_token(null::text)$q$,'P0001','no active tenant for caller','app.redeem_license_token refuses a caller with no active tenant');
   select throws_ok($q$select app.request_finance_approval(null::uuid, null::text)$q$,'P0001','no active tenant for caller','app.request_finance_approval refuses a caller with no active tenant');
   select throws_ok($q$select app.review_finance_approval(null::uuid, null::text, null::text)$q$,'P0001','no active tenant for caller','app.review_finance_approval refuses a caller with no active tenant');
   select throws_ok($q$select app.revoke_user_role(null::uuid)$q$,'P0001','no active tenant for caller','app.revoke_user_role refuses a caller with no active tenant');
   select throws_ok($q$select app.seed_default_chart_of_accounts()$q$,'P0001','no active tenant for caller','app.seed_default_chart_of_accounts refuses a caller with no active tenant');
   select throws_ok($q$select app.send_conversation_message(null::uuid, null::text, null::text, null::text)$q$,'P0001','no active tenant for caller','app.send_conversation_message refuses a caller with no active tenant');
   select throws_ok($q$select app.set_document_legal_hold(null::uuid, null::boolean, null::text)$q$,'P0001','no active tenant for caller','app.set_document_legal_hold refuses a caller with no active tenant');
   select throws_ok($q$select app.start_conversation(null::text, null::uuid, null::uuid, null::uuid, null::uuid)$q$,'P0001','no active tenant for caller','app.start_conversation refuses a caller with no active tenant');
   select throws_ok($q$select * from app.supplier_balance(null::uuid, null::uuid)$q$,'P0001','no active tenant for caller','app.supplier_balance refuses a caller with no active tenant');
   select throws_ok($q$select * from app.supplier_credit(null::uuid)$q$,'P0001','no active tenant for caller','app.supplier_credit refuses a caller with no active tenant');
   select throws_ok($q$select app.upload_document(null::text, null::text, null::text, null::text, null::text, null::uuid, null::bigint, null::timestamp with time zone, null::boolean)$q$,'P0001','no active tenant for caller','app.upload_document refuses a caller with no active tenant');
   select throws_ok($q$select app.upload_subscription_payment_proof(null::text, null::text, null::bigint, null::text)$q$,'P0001','no active tenant for caller','app.upload_subscription_payment_proof refuses a caller with no active tenant');
   select throws_ok($q$select app.void_invoice(null::uuid, null::text)$q$,'P0001','no active tenant for caller','app.void_invoice refuses a caller with no active tenant');
   select throws_ok($q$select app.withdraw_finance_approval(null::uuid, null::text)$q$,'P0001','no active tenant for caller','app.withdraw_finance_approval refuses a caller with no active tenant');

   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is e18dadc093b8ec000e75242f92bc204a58c289fd.

22. Check whether `supabase/tests/196_each_function_refusal_is_reached_by_a_call_test.sql` contains `select plan(146);`; if so record Already Applied when its Git blob is ed6542eebeee21869968c6a113ad22430f504450, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 196, 146 assertions), and change nothing else:

   ```text
   -- pgTAP: each function refusal the EC-5 probe found unseen is reached by a direct call (EC-5, SPEC-338).
   -- ATTACK-CLASSES: AUTH TENANT STATE INPUT BUSINESS
   -- EC-5: an invariant held in a database control must be proven by a test that fails when the control is removed. At CRM
   --   5f9c2f8 the bundle K probe removed each refusing RAISE in an app function body and 360 removals passed every test.
   --   Each assertion below reaches one of 145 of them with an argument vector on one fixture tenant and asserts its exact
   --   sqlstate and message; removing that RAISE fails this file (the bundle L mutation probe, 145 of 145 killed).
   -- CHAT-5 is pinned OPEN at the end of the conversation block: it records the defect as it stands, NOT desired behaviour.
   --   No migration.
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(146);
   insert into auth.users (id, email, email_confirmed_at) values
     ('c3380000-0000-0000-0000-0000000000b1','owner@spec338.test',now()),
     ('c3380000-0000-0000-0000-0000000000b2','emp@spec338.test',now());
   insert into public.tenants (id, name, slug, status) values ('c3380000-0000-0000-0000-000000000002','Spec338 Live','spec338-live','active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select 'c3380000-0000-0000-0000-000000000002', sp.id, 'active' from public.subscription_plans sp where sp.plan_code='enterprise';
   insert into public.branches (id, tenant_id, name, slug) values
     ('c3380000-0000-0000-0000-0000000000e1','c3380000-0000-0000-0000-000000000002','HQ','spec338-hq');
   insert into public.departments (id, tenant_id, branch_id, department_type_code, name) values
     ('c3380000-0000-0000-0000-0000000000f1','c3380000-0000-0000-0000-000000000002','c3380000-0000-0000-0000-0000000000e1','sales','Sales');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
     ('c3380000-0000-0000-0000-000000000021','c3380000-0000-0000-0000-000000000002','Owner','owner@spec338.test',true,'c3380000-0000-0000-0000-0000000000b1'),
     ('c3380000-0000-0000-0000-000000000022','c3380000-0000-0000-0000-000000000002','Emp','emp@spec338.test',true,'c3380000-0000-0000-0000-0000000000b2');
   insert into public.user_branch_assignments (tenant_id, user_id, branch_id, department_id, is_primary)
   select 'c3380000-0000-0000-0000-000000000002', u, 'c3380000-0000-0000-0000-0000000000e1','c3380000-0000-0000-0000-0000000000f1', true
   from unnest(array['c3380000-0000-0000-0000-000000000021'::uuid,'c3380000-0000-0000-0000-000000000022'::uuid]) u;
   insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type)
   select 'c3380000-0000-0000-0000-000000000002', v.u, r.id, 'tenant'
   from (values ('c3380000-0000-0000-0000-000000000021'::uuid,'owner'),('c3380000-0000-0000-0000-000000000022'::uuid,'employee')) v(u,c)
   join public.roles r on r.code=v.c;
   select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b1","aal":"aal2"}',true);
   set local role authenticated;
   select set_config('l.c', app.create_customer('person','Spec338 Customer', p_primary_phone=>'+20100000338')::text, true);
   select set_config('l.c2', app.create_customer('person','Spec338 Second', p_primary_phone=>'+20100000339')::text, true);
   select set_config('l.ld', app.create_lead('c3380000-0000-0000-0000-0000000000e1','c3380000-0000-0000-0000-0000000000f1','manual_entry','Spec338 lead')::text, true);
   select set_config('l.q', app.create_quotation(current_setting('l.c')::uuid,'EGP')::text, true);
   select set_config('l.b', app.create_booking(p_customer_id=>current_setting('l.c')::uuid, p_title=>'Spec338 trip', p_branch_id=>'c3380000-0000-0000-0000-0000000000e1', p_department_id=>'c3380000-0000-0000-0000-0000000000f1')::text, true);
   select set_config('l.i', app.create_booking_item(current_setting('l.b')::uuid,'umrah','EGP',100,200)::text, true);
   select set_config('l.s', app.create_supplier('Spec338 Air','airline')::text, true);
   select set_config('l.p', app.create_passenger('Spec','Three')::text, true);
   select set_config('l.bp', app.link_passenger_to_booking_item(current_setting('l.i')::uuid, current_setting('l.p')::uuid)::text, true);
   select set_config('l.v', app.create_invoice(current_setting('l.c')::uuid,'EGP',500)::text, true);
   select set_config('l.v2', app.create_invoice(current_setting('l.c')::uuid,'EGP',300)::text, true);
   select app.issue_invoice(current_setting('l.v2')::uuid);
   select set_config('l.pay', app.record_payment(current_setting('l.v2')::uuid,100,'cash')::text, true);
   select set_config('l.d', app.upload_document('ticket','Spec338 doc','v.pdf','pdf','booking_item',current_setting('l.i')::uuid,1000)::text, true);
   select set_config('l.cv', app.start_conversation('whatsapp', current_setting('l.c')::uuid)::text, true);
   select set_config('l.t', app.create_task('Spec338 task','follow_up')::text, true);
   select set_config('l.cp', app.create_complaint(current_setting('l.c')::uuid,'Spec338 complaint','service_quality')::text, true);
   select set_config('l.sr', app.create_service_request(current_setting('l.c')::uuid,'Spec338 request','other')::text, true);
   select set_config('l.mc', app.create_marketing_campaign('Spec338 campaign','google_ads')::text, true);
   select set_config('l.r', app.record_refund(current_setting('l.c')::uuid,50,'EGP','customer_cancelled')::text, true);
   -- END FIXTURE
   select throws_ok($q$select app.add_customer_contact_method(p_customer_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_contact_method_type_code => 'email', p_value => null, p_is_primary => null)$q$, 'P0001', $m$customer is not in your tenant$m$, $d$app.add_customer_contact_method#2 refuses$d$);
   select throws_ok($q$select app.add_customer_contact_method(p_customer_id => current_setting('l.c')::uuid, p_contact_method_type_code => 'email', p_value => null, p_is_primary => null)$q$, 'P0001', $m$contact value is required$m$, $d$app.add_customer_contact_method#3 refuses$d$);
   select throws_ok($q$select app.add_customer_note(p_customer_id => current_setting('l.c')::uuid, p_note_text => null, p_is_pinned => null, p_is_confidential => null)$q$, 'P0001', $m$note_text is required$m$, $d$app.add_customer_note#2 refuses$d$);
   select throws_ok($q$select app.add_customer_note(p_customer_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_note_text => 'zz_unknown', p_is_pinned => null, p_is_confidential => null)$q$, 'P0001', $m$customer is not in your tenant$m$, $d$app.add_customer_note#3 refuses$d$);
   select throws_ok($q$select app.add_document_version(p_document_id => current_setting('l.d')::uuid, p_file_name => 'f.pdf', p_file_type_code => null::text, p_file_size => 1000)$q$, 'P0001', $m$file type <NULL> is not allowed (MVP: pdf, jpg, jpeg, png, webp)$m$, $d$app.add_document_version#2 refuses$d$);
   select throws_ok($q$select app.add_document_version(p_document_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_file_name => 'f.pdf', p_file_type_code => 'pdf', p_file_size => 1000)$q$, 'P0001', $m$document is not in your tenant$m$, $d$app.add_document_version#3 refuses$d$);
   select throws_ok($q$select app.add_quotation_item(p_quotation_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_service_type_code => 'umrah', p_unit_price => null, p_quantity => null, p_description => null)$q$, 'P0001', $m$quotation is not in your tenant$m$, $d$app.add_quotation_item#2 refuses$d$);
   select throws_ok($q$select app.add_quotation_item(p_quotation_id => current_setting('l.q')::uuid, p_service_type_code => null::text, p_unit_price => null, p_quantity => null, p_description => null)$q$, 'P0001', $m$unknown service_type_code: <NULL>$m$, $d$app.add_quotation_item#4 refuses$d$);
   select throws_ok($q$select app.add_quotation_item(p_quotation_id => current_setting('l.q')::uuid, p_service_type_code => 'umrah', p_unit_price => -1, p_quantity => null, p_description => null)$q$, 'P0001', $m$unit_price must be >= 0 and quantity > 0$m$, $d$app.add_quotation_item#5 refuses$d$);
   select throws_ok($q$select app.advance_booking(p_booking_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_to_status => null, p_reason => 'spec338 reason')$q$, 'P0001', $m$booking is not in your tenant$m$, $d$app.advance_booking#2 refuses$d$);
   select throws_ok($q$select app.advance_booking(p_booking_id => current_setting('l.b')::uuid, p_to_status => null, p_reason => 'spec338 reason')$q$, 'P0001', $m$transition not allowed: draft -> <NULL>$m$, $d$app.advance_booking#3 refuses$d$);
   select throws_ok($q$select app.advance_booking(p_booking_id => current_setting('l.b')::uuid, p_to_status => 'cancelled', p_reason => null::text)$q$, 'P0001', $m$cancellation requires a reason$m$, $d$app.advance_booking#4 refuses$d$);
   select throws_ok($q$select app.advance_booking_item(p_booking_item_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_to_status => null, p_reason => 'spec338 reason', p_sub_status_code => null, p_cancellation_reason_code => 'customer_cancelled')$q$, 'P0001', $m$booking item is not in your tenant$m$, $d$app.advance_booking_item#2 refuses$d$);
   select throws_ok($q$select app.advance_booking_item(p_booking_item_id => current_setting('l.i')::uuid, p_to_status => null, p_reason => 'spec338 reason', p_sub_status_code => null, p_cancellation_reason_code => 'customer_cancelled')$q$, 'P0001', $m$transition not allowed: draft -> <NULL>$m$, $d$app.advance_booking_item#4 refuses$d$);
   select throws_ok($q$select app.advance_booking_item(p_booking_item_id => current_setting('l.i')::uuid, p_to_status => 'cancelled', p_reason => 'spec338 reason', p_sub_status_code => null, p_cancellation_reason_code => null::text)$q$, 'P0001', $m$cancellation requires a cancellation_reason_code$m$, $d$app.advance_booking_item#6 refuses$d$);
   select throws_ok($q$select app.advance_booking_item(p_booking_item_id => current_setting('l.i')::uuid, p_to_status => 'cancelled', p_reason => 'spec338 reason', p_sub_status_code => null, p_cancellation_reason_code => '')$q$, 'P0001', $m$unknown booking_cancellation_reason_code: $m$, $d$app.advance_booking_item#7 refuses$d$);
   select throws_ok($q$select app.advance_booking_item(p_booking_item_id => current_setting('l.i')::uuid, p_to_status => 'cancelled', p_reason => 'spec338 reason', p_sub_status_code => 'new', p_cancellation_reason_code => 'customer_cancelled')$q$, 'P0001', $m$service_type umrah does not support a sub_status$m$, $d$app.advance_booking_item#8 refuses$d$);
   select throws_ok($q$select app.advance_complaint(p_complaint_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_to_status => null, p_reason => 'spec338 reason')$q$, 'P0001', $m$complaint not found in your tenant$m$, $d$app.advance_complaint#2 refuses$d$);
   select throws_ok($q$select app.advance_conversation(p_conversation_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_to_status => null, p_reason => 'spec338 reason')$q$, 'P0001', $m$conversation not found in your tenant$m$, $d$app.advance_conversation#2 refuses$d$);
   select throws_ok($q$select app.advance_conversation(current_setting('l.cv')::uuid, 'closed', 'spec338 reason')$q$, '42501', $m$permission denied: <NULL>$m$, $d$CHAT-5 pinned OPEN: an invalid open -> closed move is refused as permission denied: <NULL>, not as its own transition message$d$);
   select throws_ok($q$select app.advance_lead(p_lead_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_to_status => null, p_reason => 'spec338 reason', p_closure_reason_code => 'spam')$q$, 'P0001', $m$lead is not in your tenant$m$, $d$app.advance_lead#2 refuses$d$);
   select throws_ok($q$select app.advance_lead(p_lead_id => current_setting('l.ld')::uuid, p_to_status => null, p_reason => 'spec338 reason', p_closure_reason_code => 'spam')$q$, 'P0001', $m$transition not allowed: new -> <NULL>$m$, $d$app.advance_lead#3 refuses$d$);
   select throws_ok($q$select app.advance_marketing_campaign(p_campaign_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_to_status => null, p_reason => 'spec338 reason')$q$, 'P0001', $m$campaign not found in your tenant$m$, $d$app.advance_marketing_campaign#2 refuses$d$);
   select throws_ok($q$select app.advance_quotation(p_quotation_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_to_status => null, p_reason => 'spec338 reason')$q$, 'P0001', $m$quotation is not in your tenant$m$, $d$app.advance_quotation#2 refuses$d$);
   select throws_ok($q$select app.advance_quotation(p_quotation_id => current_setting('l.q')::uuid, p_to_status => null, p_reason => 'spec338 reason')$q$, 'P0001', $m$transition not allowed: draft -> <NULL>$m$, $d$app.advance_quotation#3 refuses$d$);
   select throws_ok($q$select app.advance_refund(p_refund_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_to_status => null, p_reason => 'spec338 reason')$q$, 'P0001', $m$refund is not in your tenant$m$, $d$app.advance_refund#2 refuses$d$);
   select throws_ok($q$select app.advance_refund(p_refund_id => current_setting('l.r')::uuid, p_to_status => null, p_reason => 'spec338 reason')$q$, 'P0001', $m$refund transition not allowed: requested -> <NULL>$m$, $d$app.advance_refund#3 refuses$d$);
   select throws_ok($q$select app.advance_service_request(p_service_request_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_to_status => null, p_reason => 'spec338 reason')$q$, 'P0001', $m$service request not found in your tenant$m$, $d$app.advance_service_request#2 refuses$d$);
   select throws_ok($q$select app.advance_service_request(p_service_request_id => current_setting('l.sr')::uuid, p_to_status => null, p_reason => 'spec338 reason')$q$, 'P0001', $m$invalid service request transition requested -> <NULL>$m$, $d$app.advance_service_request#3 refuses$d$);
   select throws_ok($q$select app.advance_task(p_task_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_to_status => null, p_reason => 'spec338 reason')$q$, 'P0001', $m$task not found in your tenant$m$, $d$app.advance_task#2 refuses$d$);
   select throws_ok($q$select app.archive_document(p_document_id => current_setting('l.d')::uuid, p_reason => null::text)$q$, 'P0001', $m$archiving a document requires a reason$m$, $d$app.archive_document#2 refuses$d$);
   select throws_ok($q$select app.archive_document(p_document_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$document is not in your tenant$m$, $d$app.archive_document#3 refuses$d$);
   select throws_ok($q$select app.assign_lead(p_lead_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_assignee_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$lead is not in your tenant$m$, $d$app.assign_lead#2 refuses$d$);
   select throws_ok($q$select app.assign_lead(p_lead_id => current_setting('l.ld')::uuid, p_assignee_user_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$assignee is not an active user in your tenant$m$, $d$app.assign_lead#4 refuses$d$);
   select throws_ok($q$select app.assign_lead_round_robin(p_lead_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$lead is not in your tenant$m$, $d$app.assign_lead_round_robin#2 refuses$d$);
   select throws_ok($q$select app.assign_task(p_task_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_owner_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_owner_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_owner_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$task not found in your tenant$m$, $d$app.assign_task#2 refuses$d$);
   select throws_ok($q$select app.assign_task(p_task_id => current_setting('l.t')::uuid, p_owner_user_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_owner_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_owner_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$owner user is not in your tenant$m$, $d$app.assign_task#4 refuses$d$);
   select throws_ok($q$select app.assign_user_branch(p_user_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_is_primary => null, p_transfer_type_code => null)$q$, 'P0001', $m$target user is not in your tenant$m$, $d$app.assign_user_branch#2 refuses$d$);
   select throws_ok($q$select app.assign_user_branch(p_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_branch_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_is_primary => null, p_transfer_type_code => null)$q$, 'P0001', $m$branch is not in your tenant$m$, $d$app.assign_user_branch#3 refuses$d$);
   select throws_ok($q$select app.assign_user_branch(p_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_department_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_is_primary => null, p_transfer_type_code => null)$q$, 'P0001', $m$department does not belong to branch$m$, $d$app.assign_user_branch#4 refuses$d$);
   select throws_ok($q$select app.convert_lead(p_lead_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_customer_id => current_setting('l.c')::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$lead is not in your tenant$m$, $d$app.convert_lead#2 refuses$d$);
   select throws_ok($q$select app.convert_lead(p_lead_id => current_setting('l.ld')::uuid, p_customer_id => current_setting('l.c')::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$transition not allowed: new -> converted (lead must be won)$m$, $d$app.convert_lead#3 refuses$d$);
   select throws_ok($q$select app.correct_passenger_manifest(p_booking_item_passenger_id => current_setting('l.bp')::uuid, p_new_passenger_id => current_setting('l.p')::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$the manifest entry already names this passenger$m$, $d$app.correct_passenger_manifest#4 refuses$d$);
   select throws_ok($q$select app.correct_passenger_manifest(p_booking_item_passenger_id => current_setting('l.bp')::uuid, p_new_passenger_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$passenger is not in your tenant$m$, $d$app.correct_passenger_manifest#5 refuses$d$);
   select throws_ok($q$select app.create_booking(p_customer_id => current_setting('l.c')::uuid, p_lead_id => current_setting('l.ld')::uuid, p_title => 'Spec338', p_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_travel_start_date => null, p_travel_end_date => null, p_destination_country_code => null, p_destination_city => null, p_booking_reference => null, p_quotation_id => 'c3380000-0000-0000-0000-00000000dead'::uuid)$q$, 'P0001', $m$quotation is not in your tenant$m$, $d$app.create_booking#2 refuses$d$);
   select throws_ok($q$select app.create_booking(p_customer_id => current_setting('l.c')::uuid, p_lead_id => current_setting('l.ld')::uuid, p_title => 'Spec338', p_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_travel_start_date => null, p_travel_end_date => null, p_destination_country_code => null, p_destination_city => null, p_booking_reference => null, p_quotation_id => null::uuid)$q$, 'P0001', $m$lead is not booking-ready: no_customer_linked$m$, $d$app.create_booking#4 refuses$d$);
   select throws_ok($q$select app.create_booking_item(p_booking_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_service_type_code => 'umrah', p_currency_code => 'EGP', p_cost_amount => 100, p_selling_amount => 200, p_supplier_id => current_setting('l.s')::uuid, p_sub_status_code => null, p_finance_approval_required => null)$q$, 'P0001', $m$booking is not in your tenant$m$, $d$app.create_booking_item#2 refuses$d$);
   select throws_ok($q$select app.create_booking_item(p_booking_id => current_setting('l.b')::uuid, p_service_type_code => null::text, p_currency_code => 'EGP', p_cost_amount => 100, p_selling_amount => 200, p_supplier_id => current_setting('l.s')::uuid, p_sub_status_code => null, p_finance_approval_required => null)$q$, 'P0001', $m$unknown service_type_code: <NULL>$m$, $d$app.create_booking_item#4 refuses$d$);
   select throws_ok($q$select app.create_booking_item(p_booking_id => current_setting('l.b')::uuid, p_service_type_code => 'umrah', p_currency_code => null::text, p_cost_amount => 100, p_selling_amount => 200, p_supplier_id => current_setting('l.s')::uuid, p_sub_status_code => null, p_finance_approval_required => null)$q$, 'P0001', $m$unknown currency_code: <NULL>$m$, $d$app.create_booking_item#5 refuses$d$);
   select throws_ok($q$select app.create_booking_item(p_booking_id => current_setting('l.b')::uuid, p_service_type_code => 'umrah', p_currency_code => 'EGP', p_cost_amount => 100, p_selling_amount => 200, p_supplier_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_sub_status_code => null, p_finance_approval_required => null)$q$, 'P0001', $m$supplier is not in your tenant$m$, $d$app.create_booking_item#6 refuses$d$);
   select throws_ok($q$select app.create_booking_item(p_booking_id => current_setting('l.b')::uuid, p_service_type_code => 'umrah', p_currency_code => 'EGP', p_cost_amount => 100, p_selling_amount => 200, p_supplier_id => current_setting('l.s')::uuid, p_sub_status_code => 'new', p_finance_approval_required => null)$q$, 'P0001', $m$service_type umrah does not support a sub_status$m$, $d$app.create_booking_item#7 refuses$d$);
   select throws_ok($q$select app.create_booking_item(p_booking_id => current_setting('l.b')::uuid, p_service_type_code => 'umrah', p_currency_code => 'EGP', p_cost_amount => -1, p_selling_amount => 200, p_supplier_id => current_setting('l.s')::uuid, p_sub_status_code => null, p_finance_approval_required => null)$q$, 'P0001', $m$cost and selling amounts must be non-negative$m$, $d$app.create_booking_item#9 refuses$d$);
   select throws_ok($q$select app.create_complaint(p_customer_id => current_setting('l.c')::uuid, p_title => null::text, p_complaint_category_code => 'service_quality', p_complaint_severity_code => null, p_description => null, p_booking_id => current_setting('l.b')::uuid, p_booking_item_id => current_setting('l.i')::uuid)$q$, 'P0001', $m$title is required$m$, $d$app.create_complaint#2 refuses$d$);
   select throws_ok($q$select app.create_complaint(p_customer_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_title => 'Spec338', p_complaint_category_code => 'service_quality', p_complaint_severity_code => null, p_description => null, p_booking_id => current_setting('l.b')::uuid, p_booking_item_id => current_setting('l.i')::uuid)$q$, 'P0001', $m$customer is not in your tenant$m$, $d$app.create_complaint#3 refuses$d$);
   select throws_ok($q$select app.create_complaint(p_customer_id => current_setting('l.c')::uuid, p_title => 'Spec338', p_complaint_category_code => 'service_quality', p_complaint_severity_code => null, p_description => null, p_booking_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_booking_item_id => current_setting('l.i')::uuid)$q$, 'P0001', $m$booking is not in your tenant$m$, $d$app.create_complaint#4 refuses$d$);
   select throws_ok($q$select app.create_complaint(p_customer_id => current_setting('l.c')::uuid, p_title => 'Spec338', p_complaint_category_code => 'service_quality', p_complaint_severity_code => null, p_description => null, p_booking_id => current_setting('l.b')::uuid, p_booking_item_id => 'c3380000-0000-0000-0000-00000000dead'::uuid)$q$, 'P0001', $m$booking item is not in your tenant$m$, $d$app.create_complaint#5 refuses$d$);
   select throws_ok($q$select app.create_customer(p_customer_type_code => null::text, p_full_name => 'Spec Three', p_first_name => 'Spec', p_family_name => 'Three', p_company_name => null, p_primary_phone => null, p_primary_email => null, p_whatsapp => null, p_preferred_language_code => null, p_preferred_contact_method_code => null, p_marketing_opt_in => null, p_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_allow_duplicate => null)$q$, 'P0001', $m$unknown customer_type_code: <NULL>$m$, $d$app.create_customer#2 refuses$d$);
   select throws_ok($q$select app.create_customer(p_customer_type_code => 'person', p_full_name => 'Spec Three', p_first_name => 'Spec', p_family_name => 'Three', p_company_name => null, p_primary_phone => null, p_primary_email => null, p_whatsapp => null, p_preferred_language_code => null, p_preferred_contact_method_code => '', p_marketing_opt_in => null, p_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_allow_duplicate => null)$q$, 'P0001', $m$unknown preferred_contact_method_code: $m$, $d$app.create_customer#3 refuses$d$);
   select throws_ok($q$select app.create_customer(p_customer_type_code => 'person', p_full_name => 'Spec Three', p_first_name => 'Spec', p_family_name => 'Three', p_company_name => null, p_primary_phone => null, p_primary_email => null, p_whatsapp => null, p_preferred_language_code => null, p_preferred_contact_method_code => null, p_marketing_opt_in => null, p_branch_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_allow_duplicate => null)$q$, 'P0001', $m$branch is not in your tenant$m$, $d$app.create_customer#4 refuses$d$);
   select throws_ok($q$select app.create_department(p_branch_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_department_type_code => null, p_name => 'Spec338')$q$, 'P0001', $m$branch is not in your tenant$m$, $d$app.create_department#2 refuses$d$);
   select throws_ok($q$select app.create_department(p_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_department_type_code => null, p_name => 'Spec338')$q$, 'P0001', $m$unknown department_type_code: <NULL>$m$, $d$app.create_department#3 refuses$d$);
   select throws_ok($q$select app.create_invoice(p_customer_id => current_setting('l.c')::uuid, p_currency_code => 'EGP', p_total_amount => null::numeric, p_booking_id => current_setting('l.b')::uuid, p_booking_item_id => current_setting('l.i')::uuid, p_invoice_date => null, p_due_date => null)$q$, 'P0001', $m$invoice total_amount must be greater than zero$m$, $d$app.create_invoice#2 refuses$d$);
   select throws_ok($q$select app.create_invoice(p_customer_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_currency_code => 'EGP', p_total_amount => 100, p_booking_id => current_setting('l.b')::uuid, p_booking_item_id => current_setting('l.i')::uuid, p_invoice_date => null, p_due_date => null)$q$, 'P0001', $m$customer is not in your tenant$m$, $d$app.create_invoice#3 refuses$d$);
   select throws_ok($q$select app.create_invoice(p_customer_id => current_setting('l.c')::uuid, p_currency_code => 'EGP', p_total_amount => 100, p_booking_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_booking_item_id => current_setting('l.i')::uuid, p_invoice_date => null, p_due_date => null)$q$, 'P0001', $m$booking is not in your tenant$m$, $d$app.create_invoice#4 refuses$d$);
   select throws_ok($q$select app.create_invoice(p_customer_id => current_setting('l.c')::uuid, p_currency_code => 'EGP', p_total_amount => 100, p_booking_id => current_setting('l.b')::uuid, p_booking_item_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_invoice_date => null, p_due_date => null)$q$, 'P0001', $m$booking item is not in your tenant$m$, $d$app.create_invoice#5 refuses$d$);
   select throws_ok($q$select app.create_journal_entry(p_source_type_code => null, p_entry_date => null, p_description => null, p_lines => null, p_source_entity_id => null)$q$, 'P0001', $m$a journal entry requires at least two lines (a jsonb array)$m$, $d$app.create_journal_entry#2 refuses$d$);
   select throws_ok($q$select app.create_lead(p_branch_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_lead_source_code => 'manual_entry', p_title => 'Spec338', p_priority_code => 'normal', p_requested_service_type_code => 'umrah', p_customer_id => current_setting('l.c')::uuid, p_customer_phone => null, p_customer_name => null, p_expected_value => null, p_source_payload => null)$q$, 'P0001', $m$department does not belong to branch$m$, $d$app.create_lead#2 refuses$d$);
   select throws_ok($q$select app.create_lead(p_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_lead_source_code => null::text, p_title => 'Spec338', p_priority_code => 'normal', p_requested_service_type_code => 'umrah', p_customer_id => current_setting('l.c')::uuid, p_customer_phone => null, p_customer_name => null, p_expected_value => null, p_source_payload => null)$q$, 'P0001', $m$unknown lead_source_code: <NULL>$m$, $d$app.create_lead#3 refuses$d$);
   select throws_ok($q$select app.create_lead(p_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_lead_source_code => 'manual_entry', p_title => 'Spec338', p_priority_code => 'normal', p_requested_service_type_code => '', p_customer_id => current_setting('l.c')::uuid, p_customer_phone => null, p_customer_name => null, p_expected_value => null, p_source_payload => null)$q$, 'P0001', $m$unknown requested_service_type_code: $m$, $d$app.create_lead#4 refuses$d$);
   select throws_ok($q$select app.create_lead(p_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_lead_source_code => 'manual_entry', p_title => 'Spec338', p_priority_code => '', p_requested_service_type_code => 'umrah', p_customer_id => current_setting('l.c')::uuid, p_customer_phone => null, p_customer_name => null, p_expected_value => null, p_source_payload => null)$q$, 'P0001', $m$unknown priority_code: $m$, $d$app.create_lead#5 refuses$d$);
   select throws_ok($q$select app.create_lead(p_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_lead_source_code => 'manual_entry', p_title => 'Spec338', p_priority_code => 'normal', p_requested_service_type_code => 'umrah', p_customer_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_customer_phone => null, p_customer_name => null, p_expected_value => null, p_source_payload => null)$q$, 'P0001', $m$customer is not in your tenant$m$, $d$app.create_lead#6 refuses$d$);
   select throws_ok($q$select app.create_marketing_campaign(p_campaign_name => null, p_platform_code => 'google_ads', p_external_campaign_id => null, p_started_at => null)$q$, 'P0001', $m$campaign_name is required$m$, $d$app.create_marketing_campaign#2 refuses$d$);
   select throws_ok($q$select app.create_passenger(p_first_name => null::text, p_family_name => 'Three', p_full_name => 'Spec Three', p_passenger_type_code => 'adult', p_customer_id => current_setting('l.c')::uuid, p_relationship_to_customer_code => null, p_date_of_birth => null, p_nationality_code => null, p_passport_number => null, p_passport_issue_date => null, p_passport_expiry_date => null, p_passport_issuing_country_code => null)$q$, 'P0001', $m$first_name and family_name are required$m$, $d$app.create_passenger#2 refuses$d$);
   select throws_ok($q$select app.create_passenger(p_first_name => 'Spec', p_family_name => 'Three', p_full_name => 'Spec Three', p_passenger_type_code => null::text, p_customer_id => current_setting('l.c')::uuid, p_relationship_to_customer_code => null, p_date_of_birth => null, p_nationality_code => null, p_passport_number => null, p_passport_issue_date => null, p_passport_expiry_date => null, p_passport_issuing_country_code => null)$q$, 'P0001', $m$unknown passenger_type_code: <NULL>$m$, $d$app.create_passenger#3 refuses$d$);
   select throws_ok($q$select app.create_passenger(p_first_name => 'Spec', p_family_name => 'Three', p_full_name => 'Spec Three', p_passenger_type_code => 'adult', p_customer_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_relationship_to_customer_code => null, p_date_of_birth => null, p_nationality_code => null, p_passport_number => null, p_passport_issue_date => null, p_passport_expiry_date => null, p_passport_issuing_country_code => null)$q$, 'P0001', $m$customer is not in your tenant$m$, $d$app.create_passenger#4 refuses$d$);
   select throws_ok($q$select app.create_passenger(p_first_name => 'Spec', p_family_name => 'Three', p_full_name => 'Spec Three', p_passenger_type_code => 'adult', p_customer_id => current_setting('l.c')::uuid, p_relationship_to_customer_code => null, p_date_of_birth => null, p_nationality_code => '', p_passport_number => null, p_passport_issue_date => null, p_passport_expiry_date => null, p_passport_issuing_country_code => null)$q$, 'P0001', $m$unknown nationality_code: $m$, $d$app.create_passenger#5 refuses$d$);
   select throws_ok($q$select app.create_passenger(p_first_name => 'Spec', p_family_name => 'Three', p_full_name => 'Spec Three', p_passenger_type_code => 'adult', p_customer_id => current_setting('l.c')::uuid, p_relationship_to_customer_code => null, p_date_of_birth => null, p_nationality_code => null, p_passport_number => null, p_passport_issue_date => null, p_passport_expiry_date => null, p_passport_issuing_country_code => '')$q$, 'P0001', $m$unknown passport_issuing_country_code: $m$, $d$app.create_passenger#6 refuses$d$);
   select throws_ok($q$select app.create_passenger(p_first_name => 'Spec', p_family_name => 'Three', p_full_name => 'Spec Three', p_passenger_type_code => 'adult', p_customer_id => current_setting('l.c')::uuid, p_relationship_to_customer_code => null, p_date_of_birth => null, p_nationality_code => null, p_passport_number => null, p_passport_issue_date => current_date-400, p_passport_expiry_date => current_date-400, p_passport_issuing_country_code => null)$q$, 'P0001', $m$passport issue date must be before expiry date$m$, $d$app.create_passenger#7 refuses$d$);
   select throws_ok($q$select app.create_quotation(p_customer_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_currency_code => 'EGP', p_lead_id => current_setting('l.ld')::uuid, p_valid_until => null, p_quotation_number => null)$q$, 'P0001', $m$customer is not in your tenant$m$, $d$app.create_quotation#2 refuses$d$);
   select throws_ok($q$select app.create_quotation(p_customer_id => current_setting('l.c')::uuid, p_currency_code => null::text, p_lead_id => current_setting('l.ld')::uuid, p_valid_until => null, p_quotation_number => null)$q$, 'P0001', $m$unknown currency_code: <NULL>$m$, $d$app.create_quotation#3 refuses$d$);
   select throws_ok($q$select app.create_quotation(p_customer_id => current_setting('l.c')::uuid, p_currency_code => 'EGP', p_lead_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_valid_until => null, p_quotation_number => null)$q$, 'P0001', $m$lead is not in your tenant$m$, $d$app.create_quotation#4 refuses$d$);
   select throws_ok($q$select app.create_service_request(p_customer_id => current_setting('l.c')::uuid, p_title => null::text, p_service_request_type_code => 'other', p_service_request_severity_code => null, p_description => null, p_booking_id => current_setting('l.b')::uuid, p_booking_item_id => current_setting('l.i')::uuid)$q$, 'P0001', $m$title is required$m$, $d$app.create_service_request#2 refuses$d$);
   select throws_ok($q$select app.create_service_request(p_customer_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_title => 'Spec338', p_service_request_type_code => 'other', p_service_request_severity_code => null, p_description => null, p_booking_id => current_setting('l.b')::uuid, p_booking_item_id => current_setting('l.i')::uuid)$q$, 'P0001', $m$customer is not in your tenant$m$, $d$app.create_service_request#3 refuses$d$);
   select throws_ok($q$select app.create_service_request(p_customer_id => current_setting('l.c')::uuid, p_title => 'Spec338', p_service_request_type_code => 'other', p_service_request_severity_code => null, p_description => null, p_booking_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_booking_item_id => current_setting('l.i')::uuid)$q$, 'P0001', $m$booking is not in your tenant$m$, $d$app.create_service_request#4 refuses$d$);
   select throws_ok($q$select app.create_service_request(p_customer_id => current_setting('l.c')::uuid, p_title => 'Spec338', p_service_request_type_code => 'other', p_service_request_severity_code => null, p_description => null, p_booking_id => current_setting('l.b')::uuid, p_booking_item_id => 'c3380000-0000-0000-0000-00000000dead'::uuid)$q$, 'P0001', $m$booking item is not in your tenant$m$, $d$app.create_service_request#5 refuses$d$);
   select throws_ok($q$select app.create_supplier(p_name => null::text, p_supplier_type_code => 'airline', p_phone => null, p_email => null, p_payment_term_code => null, p_credit_limit_amount => null, p_credit_limit_currency_code => 'EGP')$q$, 'P0001', $m$name is required$m$, $d$app.create_supplier#2 refuses$d$);
   select throws_ok($q$select app.create_supplier(p_name => 'Spec338', p_supplier_type_code => 'airline', p_phone => null, p_email => null, p_payment_term_code => null, p_credit_limit_amount => -1, p_credit_limit_currency_code => 'EGP')$q$, 'P0001', $m$credit_limit_amount must be non-negative$m$, $d$app.create_supplier#3 refuses$d$);
   select throws_ok($q$select app.create_task(p_title => null::text, p_task_type_code => 'follow_up', p_owner_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_owner_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_owner_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_priority_code => 'normal', p_description => null, p_due_at => null, p_related_entity_type => null, p_related_entity_id => null)$q$, 'P0001', $m$title is required$m$, $d$app.create_task#2 refuses$d$);
   select throws_ok($q$select app.create_task(p_title => 'Spec338', p_task_type_code => 'follow_up', p_owner_user_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_owner_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_owner_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_priority_code => 'normal', p_description => null, p_due_at => null, p_related_entity_type => null, p_related_entity_id => null)$q$, 'P0001', $m$owner user is not in your tenant$m$, $d$app.create_task#4 refuses$d$);
   select throws_ok($q$select app.create_task(p_title => 'Spec338', p_task_type_code => 'follow_up', p_owner_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_owner_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_owner_branch_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_priority_code => 'normal', p_description => null, p_due_at => null, p_related_entity_type => null, p_related_entity_id => null)$q$, 'P0001', $m$branch is not in your tenant$m$, $d$app.create_task#6 refuses$d$);
   select throws_ok($q$select app.create_task(p_title => 'Spec338', p_task_type_code => 'follow_up', p_owner_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_owner_department_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_owner_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_priority_code => 'normal', p_description => null, p_due_at => null, p_related_entity_type => null, p_related_entity_id => null)$q$, 'P0001', $m$department is not in your tenant$m$, $d$app.create_task#7 refuses$d$);
   select throws_ok($q$select app.customer_balance(p_customer_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_booking_id => current_setting('l.b')::uuid)$q$, 'P0001', $m$customer is not in your tenant$m$, $d$app.customer_balance#2 refuses$d$);
   select throws_ok($q$select app.expiring_documents(p_within_days => null)$q$, 'P0001', $m$p_within_days must be zero or positive$m$, $d$app.expiring_documents#2 refuses$d$);
   select throws_ok($q$select app.issue_invoice(p_invoice_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$invoice is not in your tenant$m$, $d$app.issue_invoice#2 refuses$d$);
   select throws_ok($q$select app.issue_invoice(p_invoice_id => current_setting('l.v2')::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$only a draft invoice can be issued (is partially_paid)$m$, $d$app.issue_invoice#4 refuses$d$);
   select throws_ok($q$select app.issue_receipt(p_payment_id => 'c3380000-0000-0000-0000-00000000dead'::uuid)$q$, 'P0001', $m$payment is not in your tenant$m$, $d$app.issue_receipt#2 refuses$d$);
   select throws_ok($q$select app.lead_booking_readiness(p_lead_id => 'c3380000-0000-0000-0000-00000000dead'::uuid)$q$, 'P0001', $m$lead is not in your tenant$m$, $d$app.lead_booking_readiness#2 refuses$d$);
   select throws_ok($q$select app.link_internal_supplier(p_booking_item_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_provider_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_provider_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$booking item is not in your tenant$m$, $d$app.link_internal_supplier#2 refuses$d$);
   select throws_ok($q$select app.link_internal_supplier(p_booking_item_id => current_setting('l.i')::uuid, p_provider_branch_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_provider_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$provider department does not belong to provider branch in your tenant$m$, $d$app.link_internal_supplier#5 refuses$d$);
   select throws_ok($q$select app.link_passenger_to_booking_item(p_booking_item_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_passenger_id => current_setting('l.p')::uuid, p_selling_amount_override => null, p_cost_amount_override => null)$q$, 'P0001', $m$booking item is not in your tenant$m$, $d$app.link_passenger_to_booking_item#2 refuses$d$);
   select throws_ok($q$select app.link_passenger_to_booking_item(p_booking_item_id => current_setting('l.i')::uuid, p_passenger_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_selling_amount_override => null, p_cost_amount_override => null)$q$, 'P0001', $m$passenger is not in your tenant$m$, $d$app.link_passenger_to_booking_item#5 refuses$d$);
   select throws_ok($q$select app.link_passenger_to_booking_item(p_booking_item_id => current_setting('l.i')::uuid, p_passenger_id => current_setting('l.p')::uuid, p_selling_amount_override => -1, p_cost_amount_override => null)$q$, 'P0001', $m$amount overrides must be non-negative$m$, $d$app.link_passenger_to_booking_item#6 refuses$d$);
   select throws_ok($q$select app.link_passenger_to_booking_item(p_booking_item_id => current_setting('l.i')::uuid, p_passenger_id => current_setting('l.p')::uuid, p_selling_amount_override => null, p_cost_amount_override => null)$q$, 'P0001', $m$passenger is already linked to this booking item$m$, $d$app.link_passenger_to_booking_item#7 refuses$d$);
   select throws_ok($q$select app.reassign_booking_item(p_booking_item_id => current_setting('l.i')::uuid, p_reason => null::text, p_owner_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_sales_owner_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_operational_owner_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid)$q$, 'P0001', $m$reassigning a booked service requires a reason$m$, $d$app.reassign_booking_item#2 refuses$d$);
   select throws_ok($q$select app.reassign_booking_item(p_booking_item_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_reason => 'spec338 reason', p_owner_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_sales_owner_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_operational_owner_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid)$q$, 'P0001', $m$booking item is not in your tenant$m$, $d$app.reassign_booking_item#4 refuses$d$);
   select throws_ok($q$select app.reassign_booking_item(p_booking_item_id => current_setting('l.i')::uuid, p_reason => 'spec338 reason', p_owner_user_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_sales_owner_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_operational_owner_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid)$q$, 'P0001', $m$a named owner is not a user in your tenant$m$, $d$app.reassign_booking_item#5 refuses$d$);
   select throws_ok($q$select app.reassign_lead(p_lead_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_assignee_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$lead is not in your tenant$m$, $d$app.reassign_lead#2 refuses$d$);
   select throws_ok($q$select app.reassign_lead(p_lead_id => current_setting('l.ld')::uuid, p_assignee_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$lead has no current assignee (use app.assign_lead)$m$, $d$app.reassign_lead#4 refuses$d$);
   select throws_ok($q$select app.record_lead_interaction(p_lead_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_interaction_type_code => 'note', p_summary => null, p_metadata => null)$q$, 'P0001', $m$lead is not in your tenant$m$, $d$app.record_lead_interaction#2 refuses$d$);
   select throws_ok($q$select app.record_lead_interaction(p_lead_id => current_setting('l.ld')::uuid, p_interaction_type_code => null::text, p_summary => null, p_metadata => null)$q$, 'P0001', $m$unknown lead_interaction_type: <NULL>$m$, $d$app.record_lead_interaction#5 refuses$d$);
   select throws_ok($q$select app.record_offline_conversion(p_conversion_event_type_code => null, p_lead_id => current_setting('l.ld')::uuid, p_booking_id => current_setting('l.b')::uuid, p_booking_item_id => current_setting('l.i')::uuid, p_payment_id => current_setting('l.pay')::uuid, p_attribution_click_id => null, p_marketing_campaign_id => current_setting('l.mc')::uuid, p_conversion_value => null, p_currency_code => 'EGP', p_conversion_at => null)$q$, 'P0001', $m$unknown conversion_event_type_code: <NULL>$m$, $d$app.record_offline_conversion#2 refuses$d$);
   select throws_ok($q$select app.record_payment(p_invoice_id => current_setting('l.v')::uuid, p_amount => null::numeric, p_payment_method_code => 'cash', p_paid_at => null, p_reference_number => null)$q$, 'P0001', $m$payment amount must be greater than zero$m$, $d$app.record_payment#2 refuses$d$);
   select throws_ok($q$select app.record_payment(p_invoice_id => current_setting('l.v')::uuid, p_amount => 10, p_payment_method_code => null::text, p_paid_at => null, p_reference_number => null)$q$, 'P0001', $m$unknown payment_method: <NULL>$m$, $d$app.record_payment#3 refuses$d$);
   select throws_ok($q$select app.record_payment(p_invoice_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_amount => 10, p_payment_method_code => 'cash', p_paid_at => null, p_reference_number => null)$q$, 'P0001', $m$invoice is not in your tenant$m$, $d$app.record_payment#4 refuses$d$);
   select throws_ok($q$select app.record_refund(p_customer_id => current_setting('l.c')::uuid, p_amount => null::numeric, p_currency_code => 'EGP', p_refund_reason_code => 'customer_cancelled', p_booking_id => current_setting('l.b')::uuid, p_original_payment_id => current_setting('l.pay')::uuid)$q$, 'P0001', $m$refund amount must be greater than zero$m$, $d$app.record_refund#2 refuses$d$);
   select throws_ok($q$select app.record_refund(p_customer_id => current_setting('l.c')::uuid, p_amount => 10, p_currency_code => 'EGP', p_refund_reason_code => null::text, p_booking_id => current_setting('l.b')::uuid, p_original_payment_id => current_setting('l.pay')::uuid)$q$, 'P0001', $m$unknown refund_reason: <NULL>$m$, $d$app.record_refund#3 refuses$d$);
   select throws_ok($q$select app.record_refund(p_customer_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_amount => 10, p_currency_code => 'EGP', p_refund_reason_code => 'customer_cancelled', p_booking_id => current_setting('l.b')::uuid, p_original_payment_id => current_setting('l.pay')::uuid)$q$, 'P0001', $m$customer is not in your tenant$m$, $d$app.record_refund#4 refuses$d$);
   select throws_ok($q$select app.record_refund(p_customer_id => current_setting('l.c')::uuid, p_amount => 10, p_currency_code => 'EGP', p_refund_reason_code => 'customer_cancelled', p_booking_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_original_payment_id => current_setting('l.pay')::uuid)$q$, 'P0001', $m$booking is not in your tenant$m$, $d$app.record_refund#5 refuses$d$);
   select throws_ok($q$select app.record_refund(p_customer_id => current_setting('l.c')::uuid, p_amount => 10, p_currency_code => 'EGP', p_refund_reason_code => 'customer_cancelled', p_booking_id => current_setting('l.b')::uuid, p_original_payment_id => 'c3380000-0000-0000-0000-00000000dead'::uuid)$q$, 'P0001', $m$original payment is not in your tenant$m$, $d$app.record_refund#6 refuses$d$);
   select throws_ok($q$select app.record_supplier_payment(p_supplier_id => current_setting('l.s')::uuid, p_amount => null::numeric, p_currency_code => 'EGP', p_payment_method_code => 'cash', p_booking_id => current_setting('l.b')::uuid, p_paid_at => null, p_reference_number => null)$q$, 'P0001', $m$payment amount must be greater than zero$m$, $d$app.record_supplier_payment#2 refuses$d$);
   select throws_ok($q$select app.record_supplier_payment(p_supplier_id => current_setting('l.s')::uuid, p_amount => 10, p_currency_code => 'EGP', p_payment_method_code => null::text, p_booking_id => current_setting('l.b')::uuid, p_paid_at => null, p_reference_number => null)$q$, 'P0001', $m$unknown payment_method: <NULL>$m$, $d$app.record_supplier_payment#3 refuses$d$);
   select throws_ok($q$select app.record_supplier_payment(p_supplier_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_amount => 10, p_currency_code => 'EGP', p_payment_method_code => 'cash', p_booking_id => current_setting('l.b')::uuid, p_paid_at => null, p_reference_number => null)$q$, 'P0001', $m$supplier is not in your tenant$m$, $d$app.record_supplier_payment#4 refuses$d$);
   select throws_ok($q$select app.record_supplier_payment(p_supplier_id => current_setting('l.s')::uuid, p_amount => 10, p_currency_code => 'EGP', p_payment_method_code => 'cash', p_booking_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_paid_at => null, p_reference_number => null)$q$, 'P0001', $m$booking is not in your tenant$m$, $d$app.record_supplier_payment#5 refuses$d$);
   select throws_ok($q$select app.request_finance_approval(p_booking_item_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$booking item is not in your tenant$m$, $d$app.request_finance_approval#2 refuses$d$);
   select throws_ok($q$select app.review_finance_approval(p_approval_request_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_decision => '', p_reason => 'spec338 reason')$q$, 'P0001', $m$decision must be approved, rejected, or cancelled (got )$m$, $d$app.review_finance_approval#2 refuses$d$);
   select throws_ok($q$select app.review_finance_approval(p_approval_request_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_decision => null, p_reason => 'spec338 reason')$q$, 'P0001', $m$finance approval request is not in your tenant$m$, $d$app.review_finance_approval#3 refuses$d$);
   select throws_ok($q$select app.revoke_user_role(p_assignment_id => 'c3380000-0000-0000-0000-00000000dead'::uuid)$q$, 'P0001', $m$role assignment is not in your tenant$m$, $d$app.revoke_user_role#2 refuses$d$);
   select throws_ok($q$select app.send_conversation_message(p_conversation_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_message_direction_code => 'outbound', p_sender_type_code => 'user', p_body => 'hello')$q$, 'P0001', $m$conversation not found in your tenant$m$, $d$app.send_conversation_message#2 refuses$d$);
   select throws_ok($q$select app.set_document_legal_hold(p_document_id => current_setting('l.d')::uuid, p_active => null, p_reason => 'spec338 reason')$q$, 'P0001', $m$legal hold state is required$m$, $d$app.set_document_legal_hold#2 refuses$d$);
   select throws_ok($q$select app.set_document_legal_hold(p_document_id => current_setting('l.d')::uuid, p_active => true, p_reason => null::text)$q$, 'P0001', $m$placing or releasing a document legal hold requires a reason$m$, $d$app.set_document_legal_hold#3 refuses$d$);
   select throws_ok($q$select app.set_document_legal_hold(p_document_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_active => true, p_reason => 'spec338 reason')$q$, 'P0001', $m$document is not in your tenant$m$, $d$app.set_document_legal_hold#4 refuses$d$);
   select throws_ok($q$select app.set_document_legal_hold(p_document_id => current_setting('l.d')::uuid, p_active => false, p_reason => 'spec338 reason')$q$, 'P0001', $m$document legal hold is already released$m$, $d$app.set_document_legal_hold#5 refuses$d$);
   select throws_ok($q$select app.start_conversation(p_channel_code => 'whatsapp', p_customer_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_lead_id => current_setting('l.ld')::uuid, p_booking_id => current_setting('l.b')::uuid, p_booking_item_id => current_setting('l.i')::uuid)$q$, 'P0001', $m$customer is not in your tenant$m$, $d$app.start_conversation#2 refuses$d$);
   select throws_ok($q$select app.start_conversation(p_channel_code => 'whatsapp', p_customer_id => current_setting('l.c')::uuid, p_lead_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_booking_id => current_setting('l.b')::uuid, p_booking_item_id => current_setting('l.i')::uuid)$q$, 'P0001', $m$lead is not in your tenant$m$, $d$app.start_conversation#3 refuses$d$);
   select throws_ok($q$select app.start_conversation(p_channel_code => 'whatsapp', p_customer_id => current_setting('l.c')::uuid, p_lead_id => current_setting('l.ld')::uuid, p_booking_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_booking_item_id => current_setting('l.i')::uuid)$q$, 'P0001', $m$booking is not in your tenant$m$, $d$app.start_conversation#4 refuses$d$);
   select throws_ok($q$select app.supplier_balance(p_supplier_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_booking_id => current_setting('l.b')::uuid)$q$, 'P0001', $m$supplier is not in your tenant$m$, $d$app.supplier_balance#3 refuses$d$);
   select throws_ok($q$select app.upload_document(p_document_type_code => null::text, p_title => 'Spec338', p_file_name => 'f.pdf', p_file_type_code => 'pdf', p_link_target_type => 'booking_item', p_link_target_id => current_setting('l.i')::uuid, p_file_size => 1000, p_expires_at => null, p_is_confidential => null)$q$, 'P0001', $m$unknown document_type: <NULL>$m$, $d$app.upload_document#2 refuses$d$);
   select throws_ok($q$select app.upload_document(p_document_type_code => 'ticket', p_title => 'Spec338', p_file_name => 'f.pdf', p_file_type_code => null::text, p_link_target_type => 'booking_item', p_link_target_id => current_setting('l.i')::uuid, p_file_size => 1000, p_expires_at => null, p_is_confidential => null)$q$, 'P0001', $m$file type <NULL> is not allowed (MVP: pdf, jpg, jpeg, png, webp)$m$, $d$app.upload_document#3 refuses$d$);
   select throws_ok($q$select app.upload_document(p_document_type_code => 'ticket', p_title => 'Spec338', p_file_name => 'f.pdf', p_file_type_code => 'pdf', p_link_target_type => 'booking_item', p_link_target_id => current_setting('l.i')::uuid, p_file_size => 0, p_expires_at => null, p_is_confidential => null)$q$, 'P0001', $m$file_size must be greater than zero$m$, $d$app.upload_document#4 refuses$d$);
   select throws_ok($q$select app.upload_document(p_document_type_code => 'ticket', p_title => 'Spec338', p_file_name => 'f.pdf', p_file_type_code => 'pdf', p_link_target_type => null::text, p_link_target_id => current_setting('l.i')::uuid, p_file_size => 1000, p_expires_at => null, p_is_confidential => null)$q$, 'P0001', $m$unknown document_link_target_type: <NULL>$m$, $d$app.upload_document#5 refuses$d$);
   select throws_ok($q$select app.upload_document(p_document_type_code => 'ticket', p_title => 'Spec338', p_file_name => 'f.pdf', p_file_type_code => 'pdf', p_link_target_type => 'booking_item', p_link_target_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_file_size => 1000, p_expires_at => null, p_is_confidential => null)$q$, 'P0001', $m$booking_item target c3380000-0000-0000-0000-00000000dead is not in your tenant (or that target type is not yet supported)$m$, $d$app.upload_document#8 refuses$d$);
   select throws_ok($q$select app.upload_subscription_payment_proof(p_file_name => 'f.pdf', p_file_type_code => 'pdf', p_file_size => 0, p_note => 'n')$q$, 'P0001', $m$file_size must be greater than zero$m$, $d$app.upload_subscription_payment_proof#3 refuses$d$);
   select throws_ok($q$select app.void_invoice(p_invoice_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$invoice is not in your tenant$m$, $d$app.void_invoice#2 refuses$d$);
   select throws_ok($q$select app.withdraw_finance_approval(p_booking_item_id => current_setting('l.i')::uuid, p_reason => null::text)$q$, 'P0001', $m$withdrawing a finance approval requirement requires a reason$m$, $d$app.withdraw_finance_approval#2 refuses$d$);
   select throws_ok($q$select app.withdraw_finance_approval(p_booking_item_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$booking item is not in your tenant$m$, $d$app.withdraw_finance_approval#3 refuses$d$);
   select throws_ok($q$select app.withdraw_finance_approval(p_booking_item_id => current_setting('l.i')::uuid, p_reason => 'spec338 reason')$q$, 'P0001', $m$this booking item carries no finance approval requirement to withdraw$m$, $d$app.withdraw_finance_approval#4 refuses$d$);
   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is ed6542eebeee21869968c6a113ad22430f504450.

23. Check whether `supabase/tests/197_each_prepared_state_refusal_is_reached_test.sql` contains `select plan(91);`; if so record Already Applied when its Git blob is 05dc8925972f07f939a2520a8213615b6e7b5ac5, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 197, 91 assertions), and change nothing else:

   ```text
   -- pgTAP: each function refusal that needs a prepared state, another actor or the system caller is reached (EC-5, SPEC-338).
   -- ATTACK-CLASSES: AUTH TENANT STATE BUSINESS CONCURRENCY PRIVILEGE
   -- EC-5: 91 of the 360 refusals the bundle K probe removed unseen need a staged row, a role, a claim or an injected fault
   --   before the call. pg_temp.t338 runs the preparation and the call in one subtransaction that is always undone, so no
   --   prepared fact survives into the next assertion; pg_temp.t338o also names the function whose RAISE refused, for a
   --   refusal another layer repeats. Removing each RAISE fails this file (the bundle L mutation probe, 91 of 91 killed).
   --   Six further sites are unreachable and left unasserted with their reason in the Workbench probe record. No migration.
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(91);
   -- t338 runs a prepared state and a call in one subtransaction and returns the call's sqlstate|message; the block's
   -- exception handler undoes the preparation either way, so no prepared row, role or claim survives into the next assertion.
   create function pg_temp.t338(p_prep text, p_call text) returns text language plpgsql as $t$
   declare v text;
   begin
     begin
       execute p_prep; execute p_call;
       raise exception using errcode = 'OK338', message = 'SUCCESS';
     exception when others then v := sqlstate || '|' || sqlerrm;
     end;
     return v;
   end $t$;
   -- t338o is t338 plus the function whose RAISE refused (the innermost context frame), for a refusal another layer repeats.
   create function pg_temp.t338o(p_prep text, p_call text) returns text language plpgsql as $t$
   declare v text; c text;
   begin
     begin
       execute p_prep; execute p_call;
       raise exception using errcode = 'OK338', message = 'SUCCESS';
     exception when others then
       get stacked diagnostics c = pg_exception_context;
       v := sqlstate || '|' || sqlerrm || '|' || coalesce(substring(split_part(c, E'\n', 1) from 'function ([a-z_]+[.][a-z_]+)[(]'), '');
     end;
     return v;
   end $t$;
   insert into auth.users (id, email, email_confirmed_at) values
     ('c3380000-0000-0000-0000-0000000000b1','owner@spec338.test',now()),
     ('c3380000-0000-0000-0000-0000000000b2','emp@spec338.test',now());
   insert into public.tenants (id, name, slug, status) values ('c3380000-0000-0000-0000-000000000002','Spec338 Live','spec338-live','active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select 'c3380000-0000-0000-0000-000000000002', sp.id, 'active' from public.subscription_plans sp where sp.plan_code='enterprise';
   insert into public.branches (id, tenant_id, name, slug) values
     ('c3380000-0000-0000-0000-0000000000e1','c3380000-0000-0000-0000-000000000002','HQ','spec338-hq');
   insert into public.departments (id, tenant_id, branch_id, department_type_code, name) values
     ('c3380000-0000-0000-0000-0000000000f1','c3380000-0000-0000-0000-000000000002','c3380000-0000-0000-0000-0000000000e1','sales','Sales');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
     ('c3380000-0000-0000-0000-000000000021','c3380000-0000-0000-0000-000000000002','Owner','owner@spec338.test',true,'c3380000-0000-0000-0000-0000000000b1'),
     ('c3380000-0000-0000-0000-000000000022','c3380000-0000-0000-0000-000000000002','Emp','emp@spec338.test',true,'c3380000-0000-0000-0000-0000000000b2');
   insert into public.user_branch_assignments (tenant_id, user_id, branch_id, department_id, is_primary)
   select 'c3380000-0000-0000-0000-000000000002', u, 'c3380000-0000-0000-0000-0000000000e1','c3380000-0000-0000-0000-0000000000f1', true
   from unnest(array['c3380000-0000-0000-0000-000000000021'::uuid,'c3380000-0000-0000-0000-000000000022'::uuid]) u;
   insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type)
   select 'c3380000-0000-0000-0000-000000000002', v.u, r.id, 'tenant'
   from (values ('c3380000-0000-0000-0000-000000000021'::uuid,'owner'),('c3380000-0000-0000-0000-000000000022'::uuid,'employee')) v(u,c)
   join public.roles r on r.code=v.c;
   select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b1","aal":"aal2"}',true);
   set local role authenticated;
   select set_config('l.c', app.create_customer('person','Spec338 Customer', p_primary_phone=>'+20100000338')::text, true);
   select set_config('l.c2', app.create_customer('person','Spec338 Second', p_primary_phone=>'+20100000339')::text, true);
   select set_config('l.ld', app.create_lead('c3380000-0000-0000-0000-0000000000e1','c3380000-0000-0000-0000-0000000000f1','manual_entry','Spec338 lead')::text, true);
   select set_config('l.q', app.create_quotation(current_setting('l.c')::uuid,'EGP')::text, true);
   select set_config('l.b', app.create_booking(p_customer_id=>current_setting('l.c')::uuid, p_title=>'Spec338 trip', p_branch_id=>'c3380000-0000-0000-0000-0000000000e1', p_department_id=>'c3380000-0000-0000-0000-0000000000f1')::text, true);
   select set_config('l.i', app.create_booking_item(current_setting('l.b')::uuid,'umrah','EGP',100,200)::text, true);
   select set_config('l.s', app.create_supplier('Spec338 Air','airline')::text, true);
   select set_config('l.p', app.create_passenger('Spec','Three')::text, true);
   select set_config('l.bp', app.link_passenger_to_booking_item(current_setting('l.i')::uuid, current_setting('l.p')::uuid)::text, true);
   select set_config('l.v', app.create_invoice(current_setting('l.c')::uuid,'EGP',500)::text, true);
   select set_config('l.v2', app.create_invoice(current_setting('l.c')::uuid,'EGP',300)::text, true);
   select app.issue_invoice(current_setting('l.v2')::uuid);
   select set_config('l.pay', app.record_payment(current_setting('l.v2')::uuid,100,'cash')::text, true);
   select set_config('l.d', app.upload_document('ticket','Spec338 doc','v.pdf','pdf','booking_item',current_setting('l.i')::uuid,1000)::text, true);
   select set_config('l.cv', app.start_conversation('whatsapp', current_setting('l.c')::uuid)::text, true);
   select set_config('l.t', app.create_task('Spec338 task','follow_up')::text, true);
   select set_config('l.cp', app.create_complaint(current_setting('l.c')::uuid,'Spec338 complaint','service_quality')::text, true);
   select set_config('l.sr', app.create_service_request(current_setting('l.c')::uuid,'Spec338 request','other')::text, true);
   select set_config('l.mc', app.create_marketing_campaign('Spec338 campaign','google_ads')::text, true);
   select set_config('l.r', app.record_refund(current_setting('l.c')::uuid,50,'EGP','customer_cancelled')::text, true);
   -- END FIXTURE
   select is(pg_temp.t338($p$select set_config('request.jwt.claims','{}',true);$p$, $q$select app.activate_membership()$q$), $m$P0001|not authenticated$m$, $d$app.activate_membership#1 refuses$d$);
   select is(pg_temp.t338($p$select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-00000000beef","aal":"aal2"}',true);$p$, $q$select app.activate_membership()$q$), $m$P0001|no verified email for caller$m$, $d$app.activate_membership#2 refuses$d$);
   select is(pg_temp.t338($p$select app.add_customer_contact_method(current_setting('l.c')::uuid,'email','dup@spec338.test');$p$, $q$select app.add_customer_contact_method(p_customer_id => current_setting('l.c')::uuid, p_contact_method_type_code => 'email', p_value => 'dup@spec338.test')$q$), $m$23505|this email is already recorded for the customer$m$, $d$app.add_customer_contact_method#4 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.booking_items set is_archived=true where id=current_setting('l.i')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.advance_booking_item(p_booking_item_id => current_setting('l.i')::uuid, p_to_status => null, p_reason => 'spec338 reason', p_cancellation_reason_code => 'customer_cancelled')$q$), $m$P0001|booking item is archived$m$, $d$app.advance_booking_item#3 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.booking_items set base_status_code='confirmed', finance_approval_required=true where id=current_setting('l.i')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.advance_booking_item(p_booking_item_id => current_setting('l.i')::uuid, p_to_status => 'in_progress', p_reason => 'spec338 reason', p_cancellation_reason_code => 'customer_cancelled')$q$), $m$P0001|execution blocked: finance approval is required and not approved for this booking item$m$, $d$app.advance_booking_item#5 refuses$d$);
   select throws_ok($q$select app.advance_lead(p_lead_id => current_setting('l.ld')::uuid, p_to_status => 'spam', p_reason => 'spec338 reason', p_closure_reason_code => null::text)$q$, 'P0001', $m$closure requires a closure_reason_code$m$, $d$app.advance_lead#4 refuses$d$);
   select throws_ok($q$select app.advance_lead(p_lead_id => current_setting('l.ld')::uuid, p_to_status => 'spam', p_reason => 'spec338 reason', p_closure_reason_code => '')$q$, 'P0001', $m$unknown lead_closure_reason: $m$, $d$app.advance_lead#5 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.lead_assignments(tenant_id, lead_id, assigned_user_id, assignment_reason) values ('c3380000-0000-0000-0000-000000000002', current_setting('l.ld')::uuid, 'c3380000-0000-0000-0000-000000000021'::uuid, 'spec338'); update public.leads set assigned_user_id='c3380000-0000-0000-0000-000000000021'::uuid, lead_status_code='assigned', owner_user_id='c3380000-0000-0000-0000-000000000021'::uuid where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.leads set lead_status_code='contacted' where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b2","aal":"aal2"}',true);$p$, $q$select app.advance_lead(p_lead_id => current_setting('l.ld')::uuid, p_to_status => 'qualified', p_reason => 'spec338 reason', p_closure_reason_code => 'spam')$q$), $m$42501|permission denied: not the assigned handler and lacks ASSIGN_LEAD|app.advance_lead$m$, $d$app.advance_lead#6 refuses$d$);
   select is(pg_temp.t338($p$reset role; update public.documents set is_archived=true where id=current_setting('l.d')::uuid; set local role authenticated;$p$, $q$select app.archive_document(p_document_id => current_setting('l.d')::uuid, p_reason => 'spec338 reason')$q$), $m$P0001|document is already archived$m$, $d$app.archive_document#4 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.leads set lead_status_code='contacted' where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.assign_lead(p_lead_id => current_setting('l.ld')::uuid, p_assignee_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_reason => 'spec338 reason')$q$), $m$P0001|lead is not in new status (use app.reassign_lead): contacted$m$, $d$app.assign_lead#3 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.leads set lead_status_code='contacted' where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.assign_lead_round_robin(p_lead_id => current_setting('l.ld')::uuid, p_reason => 'spec338 reason')$q$), $m$P0001|lead is not in new status (use reassignment): contacted$m$, $d$app.assign_lead_round_robin#3 refuses$d$);
   select is(pg_temp.t338($p$reset role; update public.tasks set task_status_code='completed' where id=current_setting('l.t')::uuid; set local role authenticated;$p$, $q$select app.assign_task(p_task_id => current_setting('l.t')::uuid, p_owner_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_owner_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_owner_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_reason => 'spec338 reason')$q$), $m$P0001|task is completed and cannot be reassigned$m$, $d$app.assign_task#3 refuses$d$);
   select throws_ok($q$select app.assign_user_role(p_user_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_role_code => 'employee', p_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid)$q$, 'P0001', $m$target user is not in your tenant$m$, $d$app.assign_user_role#3 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.capture_attribution_click(p_tenant_id => null::uuid, p_attribution_source_code => null, p_marketing_campaign_id => current_setting('l.mc')::uuid, p_lead_id => current_setting('l.ld')::uuid)$q$), $m$P0001|tenant_id is required$m$, $d$app.capture_attribution_click#1 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.capture_attribution_click(p_tenant_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_attribution_source_code => null, p_marketing_campaign_id => current_setting('l.mc')::uuid, p_lead_id => current_setting('l.ld')::uuid)$q$), $m$P0001|unknown tenant: c3380000-0000-0000-0000-00000000dead$m$, $d$app.capture_attribution_click#2 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.capture_attribution_click(p_tenant_id => 'c3380000-0000-0000-0000-000000000002'::uuid, p_attribution_source_code => null, p_marketing_campaign_id => current_setting('l.mc')::uuid, p_lead_id => current_setting('l.ld')::uuid)$q$), $m$P0001|unknown attribution_source_code: <NULL>$m$, $d$app.capture_attribution_click#3 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.capture_attribution_click(p_tenant_id => 'c3380000-0000-0000-0000-000000000002'::uuid, p_attribution_source_code => 'google_ads', p_consent_ad_user_data => 'zz', p_marketing_campaign_id => current_setting('l.mc')::uuid, p_lead_id => current_setting('l.ld')::uuid)$q$), $m$P0001|consent values must be granted|denied|unspecified$m$, $d$app.capture_attribution_click#4 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.capture_attribution_click(p_tenant_id => 'c3380000-0000-0000-0000-000000000002'::uuid, p_attribution_source_code => 'google_ads', p_marketing_campaign_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_lead_id => current_setting('l.ld')::uuid)$q$), $m$P0001|marketing campaign is not in this tenant$m$, $d$app.capture_attribution_click#5 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.capture_attribution_click(p_tenant_id => 'c3380000-0000-0000-0000-000000000002'::uuid, p_attribution_source_code => 'google_ads', p_marketing_campaign_id => current_setting('l.mc')::uuid, p_lead_id => 'c3380000-0000-0000-0000-00000000dead'::uuid)$q$), $m$P0001|lead is not in this tenant$m$, $d$app.capture_attribution_click#6 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.claim_notification_deliveries(p_channel_code => null::text)$q$), $m$P0001|p_channel_code is required$m$, $d$app.claim_notification_deliveries#1 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.claim_notification_deliveries(p_channel_code => 'whatsapp', p_batch => null::integer)$q$), $m$P0001|p_batch must be at least 1$m$, $d$app.claim_notification_deliveries#2 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.leads set lead_status_code='won', customer_id=null where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.convert_lead(p_lead_id => current_setting('l.ld')::uuid, p_customer_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_reason => 'spec338 reason')$q$), $m$P0001|customer is not in your tenant$m$, $d$app.convert_lead#5 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.lead_assignments(tenant_id, lead_id, assigned_user_id, assignment_reason) values ('c3380000-0000-0000-0000-000000000002', current_setting('l.ld')::uuid, 'c3380000-0000-0000-0000-000000000021'::uuid, 'spec338'); update public.leads set lead_status_code='won', assigned_user_id='c3380000-0000-0000-0000-000000000021'::uuid, owner_user_id='c3380000-0000-0000-0000-000000000021'::uuid where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b2","aal":"aal2"}',true);$p$, $q$select app.convert_lead(p_lead_id => current_setting('l.ld')::uuid, p_customer_id => current_setting('l.c')::uuid, p_reason => 'spec338 reason')$q$), $m$42501|permission denied: not the assigned handler and lacks ASSIGN_LEAD|app.convert_lead$m$, $d$app.convert_lead#6 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.quotations set quotation_status_code='accepted' where id=current_setting('l.q')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.create_booking(p_customer_id => current_setting('l.c')::uuid, p_lead_id => null::uuid, p_title => 'Spec338', p_branch_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_quotation_id => current_setting('l.q')::uuid)$q$), $m$P0001|department does not belong to branch in your tenant$m$, $d$app.create_booking#10 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.quotations set quotation_status_code='accepted' where id=current_setting('l.q')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.create_booking(p_customer_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_lead_id => null::uuid, p_title => 'Spec338', p_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_quotation_id => current_setting('l.q')::uuid)$q$), $m$P0001|customer does not match the quotation customer$m$, $d$app.create_booking#6 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.quotations set quotation_status_code='accepted' where id=current_setting('l.q')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.create_booking(p_customer_id => current_setting('l.c')::uuid, p_lead_id => null::uuid, p_title => 'Spec338', p_branch_id => null::uuid, p_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_quotation_id => current_setting('l.q')::uuid)$q$), $m$P0001|branch and department are required$m$, $d$app.create_booking#7 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.quotations set quotation_status_code='accepted' where id=current_setting('l.q')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.create_booking(p_customer_id => current_setting('l.c')::uuid, p_lead_id => null::uuid, p_title => null::text, p_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_quotation_id => current_setting('l.q')::uuid)$q$), $m$P0001|a booking title is required$m$, $d$app.create_booking#8 refuses$d$);
   select is(pg_temp.t338($p$reset role; update public.bookings set booking_status_code='cancelled' where id=current_setting('l.b')::uuid; set local role authenticated;$p$, $q$select app.create_booking_item(p_booking_id => current_setting('l.b')::uuid, p_service_type_code => 'umrah', p_currency_code => 'EGP', p_cost_amount => 100, p_selling_amount => 200, p_supplier_id => current_setting('l.s')::uuid)$q$), $m$P0001|cannot add items to a cancelled booking$m$, $d$app.create_booking_item#3 refuses$d$);
   select throws_ok($q$select app.create_supplier(p_name => 'Spec338', p_supplier_type_code => 'airline', p_credit_limit_currency_code => 'EGP')$q$, '23514', $m$a credit limit needs both an amount and a currency (canon 30 money standard)$m$, $d$app.create_supplier#4 refuses$d$);
   select is(pg_temp.t338($p$reset role; delete from public.user_branch_assignments where tenant_id='c3380000-0000-0000-0000-000000000002'; set local role authenticated;$p$, $q$select app.create_task(p_title => 'Spec338', p_task_type_code => 'follow_up', p_owner_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_owner_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_owner_branch_id => null, p_priority_code => 'normal')$q$), $m$P0001|owner branch and department are required (the owner has no primary branch assignment to default from)$m$, $d$app.create_task#5 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.invoices set voided_at=now() where id=current_setting('l.v')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.issue_invoice(p_invoice_id => current_setting('l.v')::uuid, p_reason => 'spec338 reason')$q$), $m$P0001|invoice is archived or voided$m$, $d$app.issue_invoice#3 refuses$d$);
   select is(pg_temp.t338($p$reset role; update public.booking_items set base_status_code='cancelled' where id=current_setting('l.i')::uuid; set local role authenticated;$p$, $q$select app.link_internal_supplier(p_booking_item_id => current_setting('l.i')::uuid, p_provider_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_provider_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_reason => 'spec338 reason')$q$), $m$P0001|cannot link a supplier to a cancelled booking item$m$, $d$app.link_internal_supplier#3 refuses$d$);
   select is(pg_temp.t338($p$reset role; update public.bookings set booking_status_code='cancelled' where id=current_setting('l.b')::uuid; set local role authenticated;$p$, $q$select app.link_internal_supplier(p_booking_item_id => current_setting('l.i')::uuid, p_provider_branch_id => 'c3380000-0000-0000-0000-0000000000e1'::uuid, p_provider_department_id => 'c3380000-0000-0000-0000-0000000000f1'::uuid, p_reason => 'spec338 reason')$q$), $m$P0001|cannot link a supplier to an item on a cancelled booking$m$, $d$app.link_internal_supplier#4 refuses$d$);
   select is(pg_temp.t338($p$reset role; update public.booking_items set base_status_code='cancelled' where id=current_setting('l.i')::uuid; set local role authenticated;$p$, $q$select app.link_passenger_to_booking_item(p_booking_item_id => current_setting('l.i')::uuid, p_passenger_id => current_setting('l.p')::uuid)$q$), $m$P0001|cannot add a passenger to a cancelled booking item$m$, $d$app.link_passenger_to_booking_item#3 refuses$d$);
   select is(pg_temp.t338($p$reset role; update public.bookings set booking_status_code='cancelled' where id=current_setting('l.b')::uuid; set local role authenticated;$p$, $q$select app.link_passenger_to_booking_item(p_booking_item_id => current_setting('l.i')::uuid, p_passenger_id => current_setting('l.p')::uuid)$q$), $m$P0001|cannot add a passenger to an item on a cancelled booking$m$, $d$app.link_passenger_to_booking_item#4 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.platform_activate_subscription(p_tenant_id => 'c3380000-0000-0000-0000-000000000002'::uuid, p_plan_code => 'enterprise', p_billing_period_code => 'zz_unknown')$q$), $m$P0001|unknown subscription_period: zz_unknown$m$, $d$app.platform_activate_subscription#2 refuses$d$);
   select is(pg_temp.t338($p$reset role; delete from public.subscriptions where tenant_id='c3380000-0000-0000-0000-000000000002'; set local role authenticated; reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.platform_activate_subscription(p_tenant_id => 'c3380000-0000-0000-0000-000000000002'::uuid, p_plan_code => 'enterprise', p_billing_period_code => 'monthly')$q$), $m$P0001|tenant c3380000-0000-0000-0000-000000000002 has no subscription to activate$m$, $d$app.platform_activate_subscription#3 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.platform_issue_license_token(p_tenant_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_plan_code => null, p_billing_period_code => null, p_note => 'n')$q$), $m$P0001|unknown tenant c3380000-0000-0000-0000-00000000dead$m$, $d$app.platform_issue_license_token#1 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.platform_issue_license_token(p_tenant_id => 'c3380000-0000-0000-0000-000000000002'::uuid, p_plan_code => 'enterprise', p_billing_period_code => 'zz_unknown', p_note => 'n')$q$), $m$P0001|unknown subscription_period: zz_unknown$m$, $d$app.platform_issue_license_token#3 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.platform_issue_license_token(p_tenant_id => 'c3380000-0000-0000-0000-000000000002'::uuid, p_plan_code => 'enterprise', p_billing_period_code => 'monthly', p_valid_for_days => 0, p_note => 'n')$q$), $m$P0001|p_valid_for_days must be at least 1$m$, $d$app.platform_issue_license_token#4 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.platform_resolve_storage_finding(p_finding_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_resolution_code => null, p_note => 'n')$q$), $m$P0001|unknown finding c3380000-0000-0000-0000-00000000dead$m$, $d$app.platform_resolve_storage_finding#1 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.platform_review_payment_proof(p_proof_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_approve => null, p_notes => 'n')$q$), $m$P0001|unknown payment proof c3380000-0000-0000-0000-00000000dead$m$, $d$app.platform_review_payment_proof#1 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.platform_transition_subscription(p_tenant_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_new_state => null, p_reason => 'spec338 reason')$q$), $m$P0001|tenant c3380000-0000-0000-0000-00000000dead has no subscription$m$, $d$app.platform_transition_subscription#1 refuses$d$);
   select throws_ok($q$select app.reassign_booking_item(p_booking_item_id => current_setting('l.i')::uuid, p_reason => 'spec338 reason', p_owner_user_id => null, p_sales_owner_user_id => null, p_operational_owner_user_id => null)$q$, 'P0001', $m$name at least one new owner to reassign$m$, $d$app.reassign_booking_item#3 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.lead_assignments(tenant_id, lead_id, assigned_user_id, assignment_reason) values ('c3380000-0000-0000-0000-000000000002', current_setting('l.ld')::uuid, 'c3380000-0000-0000-0000-000000000021'::uuid, 'spec338'); update public.leads set lead_status_code='won', assigned_user_id='c3380000-0000-0000-0000-000000000021'::uuid, owner_user_id='c3380000-0000-0000-0000-000000000021'::uuid where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.reassign_lead(p_lead_id => current_setting('l.ld')::uuid, p_assignee_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_reason => 'spec338 reason')$q$), $m$P0001|a lead in terminal status won cannot be reassigned$m$, $d$app.reassign_lead#3 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.lead_assignments(tenant_id, lead_id, assigned_user_id, assignment_reason) values ('c3380000-0000-0000-0000-000000000002', current_setting('l.ld')::uuid, 'c3380000-0000-0000-0000-000000000021'::uuid, 'spec338'); update public.leads set lead_status_code='assigned', assigned_user_id='c3380000-0000-0000-0000-000000000021'::uuid, owner_user_id='c3380000-0000-0000-0000-000000000021'::uuid where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.users set is_active=false where id='c3380000-0000-0000-0000-000000000022'::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.reassign_lead(p_lead_id => current_setting('l.ld')::uuid, p_assignee_user_id => 'c3380000-0000-0000-0000-000000000022'::uuid, p_reason => 'spec338 reason')$q$), $m$P0001|assignee is not an active user in your tenant$m$, $d$app.reassign_lead#6 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.record_conversion_ingestion(p_delivery_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_request_id => null, p_error => '')$q$), $m$22023|record_conversion_ingestion: p_error must say why$m$, $d$app.record_conversion_ingestion#2 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.record_conversion_ingestion(p_delivery_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_request_id => '')$q$), $m$P0001|unknown delivery id: c3380000-0000-0000-0000-00000000dead$m$, $d$app.record_conversion_ingestion#3 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.record_event(p_tenant_id => null, p_event_type_code => 'lead_created', p_entity_type => 'lead', p_entity_id => current_setting('l.ld')::uuid, p_reason => 'spec338 reason')$q$), $m$42501|record_event: no active tenant and no tenant supplied$m$, $d$app.record_event#2 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.record_event(p_tenant_id => 'c3380000-0000-0000-0000-000000000002'::uuid, p_event_type_code => 'lead_created', p_entity_type => 'lead', p_entity_id => current_setting('l.ld')::uuid, p_actor_user_id => 'c3380000-0000-0000-0000-000000000021'::uuid, p_reason => 'spec338 reason')$q$), $m$42501|record_event: a system-context event may not name an actor$m$, $d$app.record_event#3 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.lead_assignments(tenant_id, lead_id, assigned_user_id, assignment_reason) values ('c3380000-0000-0000-0000-000000000002', current_setting('l.ld')::uuid, 'c3380000-0000-0000-0000-000000000021'::uuid, 'spec338'); update public.leads set assigned_user_id='c3380000-0000-0000-0000-000000000021'::uuid, owner_user_id='c3380000-0000-0000-0000-000000000021'::uuid where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b2","aal":"aal2"}',true);$p$, $q$select app.record_lead_interaction(p_lead_id => current_setting('l.ld')::uuid, p_interaction_type_code => 'note')$q$), $m$42501|permission denied: not the assigned handler and lacks ASSIGN_LEAD|app.record_lead_interaction$m$, $d$app.record_lead_interaction#3 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.record_notification_delivery_result(p_delivery_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_success => null)$q$), $m$P0001|p_success is required -- an unknown outcome must not be recorded as either$m$, $d$app.record_notification_delivery_result#1 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.record_notification_delivery_result(p_delivery_id => 'c3380000-0000-0000-0000-00000000dead'::uuid, p_success => true)$q$), $m$P0001|unknown delivery id: c3380000-0000-0000-0000-00000000dead$m$, $d$app.record_notification_delivery_result#2 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.invoices set voided_at=now() where id=current_setting('l.v2')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.record_payment(p_invoice_id => current_setting('l.v2')::uuid, p_amount => 10, p_payment_method_code => 'cash')$q$), $m$P0001|invoice is archived or voided$m$, $d$app.record_payment#5 refuses$d$);
   select is(pg_temp.t338($p$select set_config('request.jwt.claims','{}',true);$p$, $q$select app.record_trusted_device(p_device_identifier => null)$q$), $m$P0001|not authenticated$m$, $d$app.record_trusted_device#1 refuses$d$);
   select is(pg_temp.t338($p$reset role; update public.bookings set booking_status_code='cancelled' where id=current_setting('l.b')::uuid; set local role authenticated;$p$, $q$select app.request_finance_approval(p_booking_item_id => current_setting('l.i')::uuid, p_reason => 'spec338 reason')$q$), $m$P0001|cannot request finance approval on a completed/cancelled/archived booking$m$, $d$app.request_finance_approval#4 refuses$d$);
   select is(pg_temp.t338($p$reset role; update public.booking_items set finance_approval_required=true where id=current_setting('l.i')::uuid; set local role authenticated;select set_config('l.ar', app.request_finance_approval(current_setting('l.i')::uuid,'spec338')::text, true);$p$, $q$select app.request_finance_approval(p_booking_item_id => current_setting('l.i')::uuid, p_reason => 'spec338 reason')$q$), $m$P0001|a finance approval request is already pending for this booking item$m$, $d$app.request_finance_approval#5 refuses$d$);
   select is(pg_temp.t338($p$select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b2","aal":"aal2"}',true);$p$, $q$select app.require_lead_handler(p_assigned_user_id => 'c3380000-0000-0000-0000-000000000021'::uuid)$q$), $m$42501|permission denied: not the assigned handler and lacks ASSIGN_LEAD$m$, $d$app.require_lead_handler#1 refuses$d$);
   select is(pg_temp.t338($p$reset role; update public.booking_items set finance_approval_required=true where id=current_setting('l.i')::uuid; set local role authenticated;select set_config('l.ar', app.request_finance_approval(current_setting('l.i')::uuid,'spec338')::text, true);reset role; update public.approval_requests set approval_type_code='refund_approval' where id=current_setting('l.ar')::uuid; set local role authenticated;$p$, $q$select app.review_finance_approval(p_approval_request_id => current_setting('l.ar')::uuid, p_decision => 'approved', p_reason => 'spec338 reason')$q$), $m$P0001|this RPC only reviews finance_execution_approval requests$m$, $d$app.review_finance_approval#4 refuses$d$);
   select is(pg_temp.t338($p$reset role; update public.booking_items set finance_approval_required=true where id=current_setting('l.i')::uuid; set local role authenticated;select set_config('l.ar', app.request_finance_approval(current_setting('l.i')::uuid,'spec338')::text, true);reset role; update public.approval_requests set approval_status_code='approved' where id=current_setting('l.ar')::uuid; set local role authenticated;$p$, $q$select app.review_finance_approval(p_approval_request_id => current_setting('l.ar')::uuid, p_decision => 'approved', p_reason => 'spec338 reason')$q$), $m$P0001|only a pending finance approval can be reviewed (is approved)$m$, $d$app.review_finance_approval#5 refuses$d$);
   select is(pg_temp.t338($p$reset role; update public.booking_items set finance_approval_required=true where id=current_setting('l.i')::uuid; set local role authenticated;select set_config('l.ar', app.request_finance_approval(current_setting('l.i')::uuid,'spec338')::text, true);reset role; update public.booking_items set base_status_code='cancelled' where id=current_setting('l.i')::uuid; set local role authenticated;$p$, $q$select app.review_finance_approval(p_approval_request_id => current_setting('l.ar')::uuid, p_decision => 'approved', p_reason => 'spec338 reason')$q$), $m$P0001|cannot approve finance for a terminal/archived booking item or booking$m$, $d$app.review_finance_approval#6 refuses$d$);
   select is(pg_temp.t338($p$select set_config('request.jwt.claims','{}',true);$p$, $q$select app.revoke_trusted_device(p_device_id => 'c3380000-0000-0000-0000-00000000dead'::uuid)$q$), $m$P0001|not authenticated$m$, $d$app.revoke_trusted_device#1 refuses$d$);
   select is(pg_temp.t338($p$select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b2","aal":"aal2"}',true);$p$, $q$select app.supplier_balance(p_supplier_id => current_setting('l.s')::uuid, p_booking_id => current_setting('l.b')::uuid)$q$), $m$42501|permission denied: VIEW_FINANCIAL_DOCUMENTS is required to read supplier balances$m$, $d$app.supplier_balance#2 refuses$d$);
   select throws_ok($q$select app.upload_document(p_document_type_code => 'passport', p_title => 'Spec338', p_file_name => 'f.pdf', p_file_type_code => 'pdf', p_link_target_type => 'booking_item', p_link_target_id => current_setting('l.i')::uuid, p_file_size => 1000)$q$, 'P0001', $m$passport documents are stored at passenger level$m$, $d$app.upload_document#6 refuses$d$);
   select throws_ok($q$select app.upload_document(p_document_type_code => 'ticket', p_title => 'Spec338', p_file_name => 'f.pdf', p_file_type_code => 'pdf', p_link_target_type => 'passenger', p_link_target_id => current_setting('l.i')::uuid, p_file_size => 1000)$q$, 'P0001', $m$ticket documents are stored at booking item level$m$, $d$app.upload_document#7 refuses$d$);
   select is(pg_temp.t338($p$reset role; delete from public.subscriptions where tenant_id='c3380000-0000-0000-0000-000000000002'; set local role authenticated;$p$, $q$select app.upload_subscription_payment_proof(p_file_name => 'f.pdf', p_file_type_code => 'pdf', p_file_size => 1000, p_note => 'n')$q$), $m$P0001|this tenant has no subscription to pay for$m$, $d$app.upload_subscription_payment_proof#4 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.invoices set is_archived=true where id=current_setting('l.v2')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.void_invoice(p_invoice_id => current_setting('l.v2')::uuid, p_reason => 'spec338 reason')$q$), $m$P0001|invoice is archived$m$, $d$app.void_invoice#3 refuses$d$);
   select matches(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.invoices set voided_at=now() where id=current_setting('l.v2')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.void_invoice(p_invoice_id => current_setting('l.v2')::uuid, p_reason => 'spec338 reason')$q$), $m$^P0001\|invoice\ $m$, $d$app.void_invoice#4 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select set_config('l.tok', app.platform_issue_license_token('c3380000-0000-0000-0000-000000000002','enterprise','monthly'), true); create function public.spec338_lost_race() returns trigger language plpgsql as $r$ begin return null; end $r$; create trigger spec338_lost_race before update on public.tenant_license_activations for each row execute function public.spec338_lost_race(); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.redeem_license_token(current_setting('l.tok'))$q$), $m$42501|activation code is not valid$m$, $d$app.redeem_license_token#3 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.chart_of_accounts (tenant_id, code, name, account_type) values ('c3380000-0000-0000-0000-000000000002','1000','Cash','asset'),('c3380000-0000-0000-0000-000000000002','4000','Rev','revenue'); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.create_journal_entry('manual_entry',current_date,'d','[{"account_code":"1000","debit":-1},{"account_code":"4000","credit":5}]'::jsonb)$q$), $m$P0001|debit/credit amounts must be non-negative$m$, $d$app.create_journal_entry#3 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.chart_of_accounts (tenant_id, code, name, account_type) values ('c3380000-0000-0000-0000-000000000002','1000','Cash','asset'),('c3380000-0000-0000-0000-000000000002','4000','Rev','revenue'); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.create_journal_entry('manual_entry',current_date,'d','[{"account_code":"1000","debit":5,"credit":5},{"account_code":"4000","credit":5}]'::jsonb)$q$), $m$P0001|each line must have exactly one of debit or credit greater than zero$m$, $d$app.create_journal_entry#4 refuses$d$);
   select matches(pg_temp.t338($p$select 1$p$, $q$select app.create_customer('person','Dup', p_primary_phone=>'+20100000338')$q$), $m$^23505\|duplicate\ primary\ phone\ for\ customer\ $m$, $d$app.create_customer#5 refuses$d$);
   select throws_ok($q$select app.create_marketing_campaign('A','google_ads','ext1'), app.create_marketing_campaign('B','google_ads','ext1')$q$, '23505', $m$campaign ext1 is already recorded for platform google_ads$m$, $d$app.create_marketing_campaign#3 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; delete from public.user_branch_assignments where tenant_id='c3380000-0000-0000-0000-000000000002'; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.create_complaint(current_setting('l.c')::uuid,'t','service_quality')$q$), $m$P0001|you have no primary branch assignment; a complaint must be filed under a branch$m$, $d$app.create_complaint#6 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; delete from public.user_branch_assignments where tenant_id='c3380000-0000-0000-0000-000000000002'; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.start_conversation('whatsapp',current_setting('l.c')::uuid)$q$), $m$P0001|you have no primary branch assignment; a conversation must be filed under a branch$m$, $d$app.start_conversation#5 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; delete from public.user_branch_assignments where tenant_id='c3380000-0000-0000-0000-000000000002'; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.create_quotation(current_setting('l.c')::uuid,'EGP')$q$), $m$P0001|you have no primary branch assignment; a quotation must be filed under a branch$m$, $d$app.create_quotation#5 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; delete from public.user_branch_assignments where tenant_id='c3380000-0000-0000-0000-000000000002'; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.create_service_request(current_setting('l.c')::uuid,'t','other')$q$), $m$P0001|you have no primary branch assignment; a service request must be filed under a branch$m$, $d$app.create_service_request#6 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.quotations set quotation_status_code='accepted' where id=current_setting('l.q')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.create_booking(p_customer_id=>null,p_title=>'t',p_branch_id=>'c3380000-0000-0000-0000-0000000000e1',p_department_id=>'c3380000-0000-0000-0000-0000000000f1')$q$), $m$P0001|a customer is required to create a booking$m$, $d$app.create_booking#5 refuses$d$);
   select throws_ok($q$select app.create_booking(p_customer_id=>'c3380000-0000-0000-0000-00000000dead',p_title=>'t',p_branch_id=>'c3380000-0000-0000-0000-0000000000e1',p_department_id=>'c3380000-0000-0000-0000-0000000000f1')$q$, 'P0001', $m$customer is not in your tenant$m$, $d$app.create_booking#9 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.booking_items set service_type_code='visa' where id=current_setting('l.i')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.advance_booking_item(current_setting('l.i')::uuid,'pending',null,'zz_unknown')$q$), $m$P0001|unknown visa_sub_status value: zz_unknown$m$, $d$app.advance_booking_item#9 refuses$d$);
   select throws_ok($q$select app.create_booking_item(current_setting('l.b')::uuid,'visa','EGP',p_sub_status_code=>'zz_unknown')$q$, 'P0001', $m$unknown visa_sub_status value: zz_unknown$m$, $d$app.create_booking_item#8 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.leads set lead_status_code='won', customer_id=null where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.convert_lead(current_setting('l.ld')::uuid)$q$), $m$P0001|no customer to convert to; link or create a customer first$m$, $d$app.convert_lead#4 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.lead_assignments(tenant_id, lead_id, assigned_user_id, assignment_reason) values ('c3380000-0000-0000-0000-000000000002', current_setting('l.ld')::uuid, 'c3380000-0000-0000-0000-000000000021'::uuid, 'spec338'); update public.leads set assigned_user_id='c3380000-0000-0000-0000-000000000021'::uuid, lead_status_code='contacted', owner_user_id='c3380000-0000-0000-0000-000000000021'::uuid where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b1","aal":"aal1"}',true);$p$, $q$select app.advance_lead(current_setting('l.ld')::uuid,'qualified')$q$), $m$42501|multi-factor authentication required for this role|app.advance_lead$m$, $d$app.advance_lead#7 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.lead_assignments(tenant_id, lead_id, assigned_user_id, assignment_reason) values ('c3380000-0000-0000-0000-000000000002', current_setting('l.ld')::uuid, 'c3380000-0000-0000-0000-000000000021'::uuid, 'spec338'); update public.leads set assigned_user_id='c3380000-0000-0000-0000-000000000021'::uuid, lead_status_code='won', customer_id=current_setting('l.c')::uuid, owner_user_id='c3380000-0000-0000-0000-000000000021'::uuid where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b1","aal":"aal1"}',true);$p$, $q$select app.convert_lead(current_setting('l.ld')::uuid)$q$), $m$42501|multi-factor authentication required for this role|app.convert_lead$m$, $d$app.convert_lead#7 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.lead_assignments(tenant_id, lead_id, assigned_user_id, assignment_reason) values ('c3380000-0000-0000-0000-000000000002', current_setting('l.ld')::uuid, 'c3380000-0000-0000-0000-000000000021'::uuid, 'spec338'); update public.leads set assigned_user_id='c3380000-0000-0000-0000-000000000021'::uuid, lead_status_code='assigned', owner_user_id='c3380000-0000-0000-0000-000000000021'::uuid where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b1","aal":"aal1"}',true);$p$, $q$select app.record_lead_interaction(current_setting('l.ld')::uuid,'note','n')$q$), $m$42501|multi-factor authentication required for this role|app.record_lead_interaction$m$, $d$app.record_lead_interaction#4 refuses$d$);
   select is(pg_temp.t338($p$select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b1","aal":"aal1"}',true);$p$, $q$select app.require_lead_handler('c3380000-0000-0000-0000-000000000021'::uuid)$q$), $m$42501|multi-factor authentication required for this role$m$, $d$app.require_lead_handler#2 refuses$d$);
   select throws_ok($q$select app.record_offline_conversion('qualified_lead', p_attribution_click_id=>'c3380000-0000-0000-0000-00000000dead')$q$, 'P0001', $m$attribution click is not in your tenant$m$, $d$app.record_offline_conversion#5 refuses$d$);
   select throws_ok($q$select app.record_offline_conversion('qualified_lead', p_lead_id=>'c3380000-0000-0000-0000-00000000dead')$q$, 'P0001', $m$lead is not in your tenant$m$, $d$app.record_offline_conversion#6 refuses$d$);
   select is(pg_temp.t338($p$reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.record_conversion_provider_status('c3380000-0000-0000-0000-00000000dead','r','SUCCESS')$q$), $m$P0001|unknown delivery id: c3380000-0000-0000-0000-00000000dead$m$, $d$app.record_conversion_provider_status#2 refuses$d$);
   select matches(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.document_storage_findings(id, tenant_id, finding_type_code, document_version_id, storage_path) select 'c3380000-0000-0000-0000-0000000f1d01', d.tenant_id, 'retention_expired', d.current_version_id, 'spec338/v.pdf' from public.documents d where d.id=current_setting('l.d')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.platform_resolve_storage_finding('c3380000-0000-0000-0000-0000000f1d01'::uuid,'object_deleted')$q$), $m$^P0001\|version\ $m$, $d$app.platform_resolve_storage_finding#6 refuses$d$);
   select is(pg_temp.t338($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.document_storage_findings(id, tenant_id, finding_type_code, document_version_id, storage_path) select 'c3380000-0000-0000-0000-0000000f1d01', d.tenant_id, 'retention_expired', d.current_version_id, 'spec338/v.pdf' from public.documents d where d.id=current_setting('l.d')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.subscriptions set subscription_status_code='suspended' where tenant_id='c3380000-0000-0000-0000-000000000002'; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;reset role; select set_config('request.jwt.claims', null, true);$p$, $q$select app.platform_resolve_storage_finding('c3380000-0000-0000-0000-0000000f1d01'::uuid,'object_deleted')$q$), $m$42501|tenant c3380000-0000-0000-0000-000000000002 is in a restricted subscription state; its stored data is frozen for reading and export only, so this version will not be destroyed$m$, $d$app.platform_resolve_storage_finding#5 refuses$d$);
   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is 05dc8925972f07f939a2520a8213615b6e7b5ac5.

24. Check whether `supabase/tests/198_each_trigger_refusal_is_reached_test.sql` contains `select plan(40);`; if so record Already Applied when its Git blob is 4865e7f8d5d7859d333965f83af04e07f2c5fa3f, and otherwise stop and report. Otherwise create this file with exactly the following UTF-8 content and one final newline (test 198, 40 assertions), and change nothing else:

   ```text
   -- pgTAP: each trigger refusal the EC-5 probe found unseen is reached and named (EC-5, SPEC-338).
   -- ATTACK-CLASSES: TENANT STATE INPUT BUSINESS
   -- EC-5: 47 of the 360 refusals the bundle K probe removed unseen are RAISEs in trigger functions. 40 are reached through
   --   pg_temp.t338o, each asserting the trigger function that refused (the innermost context frame); preparations stage
   --   rows, clone a saved row with one changed fact, inject a fault or disable one sibling trigger, all inside a
   --   subtransaction that is always undone. Removing each RAISE fails this file (the bundle L mutation probe, 40 of 40
   --   killed). Seven further sites are unreachable and left unasserted with their reason in the Workbench probe record.
   --   No migration.
   create extension if not exists pgtap with schema extensions;

   begin;
   select plan(40);
   -- t338 runs a prepared state and a call in one subtransaction and returns the call's sqlstate|message; the block's
   -- exception handler undoes the preparation either way, so no prepared row, role or claim survives into the next assertion.
   create function pg_temp.t338(p_prep text, p_call text) returns text language plpgsql as $t$
   declare v text;
   begin
     begin
       execute p_prep; execute p_call;
       raise exception using errcode = 'OK338', message = 'SUCCESS';
     exception when others then v := sqlstate || '|' || sqlerrm;
     end;
     return v;
   end $t$;
   -- t338o is t338 plus the function whose RAISE refused (the innermost context frame), for a refusal another layer repeats.
   create function pg_temp.t338o(p_prep text, p_call text) returns text language plpgsql as $t$
   declare v text; c text;
   begin
     begin
       execute p_prep; execute p_call;
       raise exception using errcode = 'OK338', message = 'SUCCESS';
     exception when others then
       get stacked diagnostics c = pg_exception_context;
       v := sqlstate || '|' || sqlerrm || '|' || coalesce(substring(split_part(c, E'\n', 1) from 'function ([a-z_]+[.][a-z_]+)[(]'), '');
     end;
     return v;
   end $t$;
   -- clone inserts a copy of the row saved in l.row with the given columns replaced, so a trigger sees one changed fact.
   create function pg_temp.clone(t regclass, ov jsonb) returns void language plpgsql as $c$
   declare cols text;
   begin
     select string_agg(quote_ident(attname), ',' order by attnum) into cols from pg_attribute
      where attrelid = t and attnum > 0 and not attisdropped and attgenerated = '' and attidentity = '';
     execute format('insert into %s (%s) select %s from jsonb_populate_record(null::%s, $1)', t, cols, cols, t)
       using current_setting('l.row')::jsonb || ov;
   end $c$;
   insert into auth.users (id, email, email_confirmed_at) values
     ('c3380000-0000-0000-0000-0000000000b1','owner@spec338.test',now()),
     ('c3380000-0000-0000-0000-0000000000b2','emp@spec338.test',now());
   insert into public.tenants (id, name, slug, status) values ('c3380000-0000-0000-0000-000000000002','Spec338 Live','spec338-live','active');
   insert into public.subscriptions (tenant_id, subscription_plan_id, subscription_status_code)
   select 'c3380000-0000-0000-0000-000000000002', sp.id, 'active' from public.subscription_plans sp where sp.plan_code='enterprise';
   insert into public.branches (id, tenant_id, name, slug) values
     ('c3380000-0000-0000-0000-0000000000e1','c3380000-0000-0000-0000-000000000002','HQ','spec338-hq');
   insert into public.departments (id, tenant_id, branch_id, department_type_code, name) values
     ('c3380000-0000-0000-0000-0000000000f1','c3380000-0000-0000-0000-000000000002','c3380000-0000-0000-0000-0000000000e1','sales','Sales');
   insert into public.users (id, tenant_id, full_name, email, is_active, auth_user_id) values
     ('c3380000-0000-0000-0000-000000000021','c3380000-0000-0000-0000-000000000002','Owner','owner@spec338.test',true,'c3380000-0000-0000-0000-0000000000b1'),
     ('c3380000-0000-0000-0000-000000000022','c3380000-0000-0000-0000-000000000002','Emp','emp@spec338.test',true,'c3380000-0000-0000-0000-0000000000b2');
   insert into public.user_branch_assignments (tenant_id, user_id, branch_id, department_id, is_primary)
   select 'c3380000-0000-0000-0000-000000000002', u, 'c3380000-0000-0000-0000-0000000000e1','c3380000-0000-0000-0000-0000000000f1', true
   from unnest(array['c3380000-0000-0000-0000-000000000021'::uuid,'c3380000-0000-0000-0000-000000000022'::uuid]) u;
   insert into public.user_role_assignments (tenant_id, user_id, role_id, scope_type)
   select 'c3380000-0000-0000-0000-000000000002', v.u, r.id, 'tenant'
   from (values ('c3380000-0000-0000-0000-000000000021'::uuid,'owner'),('c3380000-0000-0000-0000-000000000022'::uuid,'employee')) v(u,c)
   join public.roles r on r.code=v.c;
   select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b1","aal":"aal2"}',true);
   set local role authenticated;
   select set_config('l.c', app.create_customer('person','Spec338 Customer', p_primary_phone=>'+20100000338')::text, true);
   select set_config('l.c2', app.create_customer('person','Spec338 Second', p_primary_phone=>'+20100000339')::text, true);
   select set_config('l.ld', app.create_lead('c3380000-0000-0000-0000-0000000000e1','c3380000-0000-0000-0000-0000000000f1','manual_entry','Spec338 lead')::text, true);
   select set_config('l.q', app.create_quotation(current_setting('l.c')::uuid,'EGP')::text, true);
   select set_config('l.b', app.create_booking(p_customer_id=>current_setting('l.c')::uuid, p_title=>'Spec338 trip', p_branch_id=>'c3380000-0000-0000-0000-0000000000e1', p_department_id=>'c3380000-0000-0000-0000-0000000000f1')::text, true);
   select set_config('l.i', app.create_booking_item(current_setting('l.b')::uuid,'umrah','EGP',100,200)::text, true);
   select set_config('l.s', app.create_supplier('Spec338 Air','airline')::text, true);
   select set_config('l.p', app.create_passenger('Spec','Three')::text, true);
   select set_config('l.bp', app.link_passenger_to_booking_item(current_setting('l.i')::uuid, current_setting('l.p')::uuid)::text, true);
   select set_config('l.v', app.create_invoice(current_setting('l.c')::uuid,'EGP',500)::text, true);
   select set_config('l.v2', app.create_invoice(current_setting('l.c')::uuid,'EGP',300)::text, true);
   select app.issue_invoice(current_setting('l.v2')::uuid);
   select set_config('l.pay', app.record_payment(current_setting('l.v2')::uuid,100,'cash')::text, true);
   select set_config('l.d', app.upload_document('ticket','Spec338 doc','v.pdf','pdf','booking_item',current_setting('l.i')::uuid,1000)::text, true);
   select set_config('l.cv', app.start_conversation('whatsapp', current_setting('l.c')::uuid)::text, true);
   select set_config('l.t', app.create_task('Spec338 task','follow_up')::text, true);
   select set_config('l.cp', app.create_complaint(current_setting('l.c')::uuid,'Spec338 complaint','service_quality')::text, true);
   select set_config('l.sr', app.create_service_request(current_setting('l.c')::uuid,'Spec338 request','other')::text, true);
   select set_config('l.mc', app.create_marketing_campaign('Spec338 campaign','google_ads')::text, true);
   select set_config('l.r', app.record_refund(current_setting('l.c')::uuid,50,'EGP','customer_cancelled')::text, true);
   -- END FIXTURE
   select matches(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; create function public.spec338_noinv() returns trigger language plpgsql as $f$ begin return null; end $f$; create trigger spec338_noinv before update on public.invoices for each row execute function public.spec338_noinv(); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select app.record_payment(p_invoice_id => current_setting('l.v2')::uuid, p_amount => 10, p_payment_method_code => 'cash')$q$), $m$^42501\|invoice\ [0-9a-f-]{36}\ could\ not\ be\ settled\ by\ this\ caller\|app\.derive_invoice_payment_status$$m$, $d$app.derive_invoice_payment_status#1 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.bookings set is_archived=true where id=current_setting('l.b')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select set_config('l.row', (select to_jsonb(x)::text from public.booking_items x where id=current_setting('l.i')::uuid limit 1), true); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select pg_temp.clone('public.booking_items', '{"id": "c3380000-0000-0000-0000-0000000a0001"}'::jsonb); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|cannot attach a booking item to an archived booking|app.enforce_booking_item_lifecycle$m$, $d$app.enforce_booking_item_lifecycle#2 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.i2', app.create_booking_item(p_booking_id => current_setting('l.b')::uuid, p_service_type_code => 'umrah', p_currency_code => 'EGP')::text, true);select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; alter table public.booking_item_passengers disable trigger booking_item_passengers_enforce_lifecycle; update public.booking_item_passengers set passenger_correction_reason='r' where id=current_setting('l.bp')::uuid; alter table public.booking_item_passengers enable trigger booking_item_passengers_enforce_lifecycle; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.bookings set booking_status_code='issued' where id=current_setting('l.b')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$update public.booking_item_passengers set booking_item_id=current_setting('l.i2')::uuid where id=current_setting('l.bp')::uuid$q$), $m$23514|joining or leaving a frozen passenger manifest requires its own reason|app.enforce_booking_item_passenger_lifecycle$m$, $d$app.enforce_booking_item_passenger_lifecycle#9 refuses$d$);
   select is(pg_temp.t338o($p$select 1$p$, $q$update public.tasks set related_entity_type='zz', related_entity_id=gen_random_uuid() where id=current_setting('l.t')::uuid$q$), $m$23514|tasks.related_entity_type: "zz" is not an active related_entity_type|app.enforce_entity_reference$m$, $d$app.enforce_entity_reference#2 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.catalog_values (tenant_id, catalog_type_code, code, label, sort_order, is_active, is_system) values (null, 'related_entity_type', 'zzq', 'zzq', 999, true, false); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$update public.tasks set related_entity_type='zzq', related_entity_id=gen_random_uuid() where id=current_setting('l.t')::uuid$q$), $m$23514|tasks.related_entity_type: related_entity_type "zzq" resolves to table public.zzqs which does not exist|app.enforce_entity_reference$m$, $d$app.enforce_entity_reference#3 refuses$d$);
   select matches(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.chart_of_accounts (tenant_id, code, name, account_type) values ('c3380000-0000-0000-0000-000000000002','1000','Cash','asset'),('c3380000-0000-0000-0000-000000000002','4000','Rev','revenue'); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('l.je', app.create_journal_entry(p_source_type_code => 'manual_entry', p_entry_date => current_date, p_description => 'd', p_lines => '[{"account_code":"1000","debit":5,"currency":"EGP"},{"account_code":"4000","credit":5,"currency":"EGP"}]'::jsonb)::text, true);select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; delete from public.journal_entry_lines where id=(select id from public.journal_entry_lines where journal_entry_id=current_setting('l.je')::uuid limit 1); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$set constraints all immediate$q$), $m$^23514\|journal\ entry\ [0-9a-f-]{36}\ has\ 1\ line\(s\):\ a\ double\-entry\ record\ requires\ at\ least\ two\|app\.enforce_journal_entry_balanced$$m$, $d$app.enforce_journal_entry_balanced#2 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into auth.users (id) values ('c3380000-0000-0000-0000-0000000a0002'); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.users set auth_user_id='c3380000-0000-0000-0000-0000000a0002' where id='c3380000-0000-0000-0000-000000000022'::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|membership emp@spec338.test cannot be bound to an identity that has no email address|app.enforce_membership_identity_binding$m$, $d$app.enforce_membership_identity_binding#1 refuses$d$);
   select is(pg_temp.t338o($p$select 1$p$, $q$update public.booking_items set sub_status_code='zz' where id=current_setting('l.i')::uuid$q$), $m$23514|service_type umrah does not support a sub_status (canon 26 Sub-Status Rule)|app.enforce_sub_status_code$m$, $d$app.enforce_sub_status_code#1 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.tenants set trial_started_at=now()-interval '1 day', trial_ends_at=now()+interval '13 days' where id='c3380000-0000-0000-0000-000000000002'::uuid and trial_started_at is null; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.tenants set trial_started_at=trial_started_at-interval '1 hour', trial_ends_at=trial_ends_at-interval '1 hour' where id='c3380000-0000-0000-0000-000000000002'::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|trial_started_at is set once per tenant and cannot be changed|app.enforce_trial_stamp_immutable$m$, $d$app.enforce_trial_stamp_immutable#1 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.customers set first_registered_branch_id='c3380000-0000-0000-0000-0000000000e1'::uuid where id=current_setting('l.c')::uuid and first_registered_branch_id is null; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.customers set first_registered_branch_id=null where id=current_setting('l.c')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$42501|first_registered_branch_id records where this customer was first registered and cannot be changed|app.freeze_first_registration$m$, $d$app.freeze_first_registration#2 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.lead_assignments(tenant_id, lead_id, assigned_user_id, assignment_reason) values ('c3380000-0000-0000-0000-000000000002', current_setting('l.ld')::uuid, 'c3380000-0000-0000-0000-000000000022'::uuid, 'spec338'); update public.leads set assigned_user_id='c3380000-0000-0000-0000-000000000022'::uuid, lead_status_code='assigned', owner_user_id='c3380000-0000-0000-0000-000000000022'::uuid where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; delete from public.lead_assignments where lead_id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$42501|lead assignment history may not be deleted (canon 04: "No assignment history may be deleted")|app.forbid_assignment_history_rewrite$m$, $d$app.forbid_assignment_history_rewrite#1 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.conversation_messages (tenant_id, conversation_id, sender_type_code, message_direction_code, message_text) values ('c3380000-0000-0000-0000-000000000002'::uuid, current_setting('l.cv')::uuid, 'user', 'outbound', 'spec338'); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; delete from public.conversation_messages where conversation_id=current_setting('l.cv')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$42501|a conversation message may not be deleted; it is the record of what was said to the customer|app.forbid_message_rewrite$m$, $d$app.forbid_message_rewrite#1 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select set_config('l.row', (select to_jsonb(x)::text from public.booking_items x where id=current_setting('l.i')::uuid limit 1), true); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b2","aal":"aal2"}',true); reset role; select pg_temp.clone('public.booking_items', '{"id": "c3380000-0000-0000-0000-0000000a0001", "cost_amount": null, "selling_amount": 200, "owner_user_id": "c3380000-0000-0000-0000-000000000021", "sales_owner_user_id": "c3380000-0000-0000-0000-000000000021", "operational_owner_user_id": "c3380000-0000-0000-0000-000000000021"}'::jsonb)$q$), $m$42501|ENTER_SELLING_PRICE is scoped to items assigned to you (canon 28: assigned)|app.guard_booking_item_financials$m$, $d$app.guard_booking_item_financials#2 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select set_config('l.row', (select to_jsonb(x)::text from public.booking_items x where id=current_setting('l.i')::uuid limit 1), true); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b2","aal":"aal2"}',true); reset role; select pg_temp.clone('public.booking_items', '{"id": "c3380000-0000-0000-0000-0000000a0001", "cost_amount": null, "selling_amount": null, "finance_approval_status_code": "pending", "owner_user_id": "c3380000-0000-0000-0000-000000000021", "sales_owner_user_id": "c3380000-0000-0000-0000-000000000021", "operational_owner_user_id": "c3380000-0000-0000-0000-000000000021"}'::jsonb)$q$), $m$42501|a finance approval request is scoped to items assigned to you (canon 28: assigned)|app.guard_booking_item_financials$m$, $d$app.guard_booking_item_financials#3 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.booking_items set owner_user_id='c3380000-0000-0000-0000-000000000021'::uuid, sales_owner_user_id='c3380000-0000-0000-0000-000000000021'::uuid, operational_owner_user_id='c3380000-0000-0000-0000-000000000021'::uuid where id=current_setting('l.i')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('request.jwt.claims','{"sub":"c3380000-0000-0000-0000-0000000000b2","aal":"aal2"}',true); reset role; update public.booking_items set finance_approval_status_code='pending' where id=current_setting('l.i')::uuid$q$), $m$42501|a finance approval request is scoped to items assigned to you (canon 28: assigned)|app.guard_booking_item_financials$m$, $d$app.guard_booking_item_financials#6 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.booking_items set finance_approval_required=true, finance_approval_status_code='approved' where id=current_setting('l.i')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$update public.booking_items set finance_approval_required=false, finance_approval_withdrawal_reason='r' where id=current_setting('l.i')::uuid$q$), $m$23514|the finance approval was already granted: withdrawing the requirement now would rewrite that decision|app.guard_booking_item_financials$m$, $d$app.guard_booking_item_financials#7 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.booking_items set finance_approval_required=true, cost_locked_at=now() where id=current_setting('l.i')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$update public.booking_items set finance_approval_required=false, finance_approval_withdrawal_reason='r' where id=current_setting('l.i')::uuid$q$), $m$23514|the cost is locked: execution has crossed the financial gate, so a reversal is a new auditable action rather than a withdrawal|app.guard_booking_item_financials$m$, $d$app.guard_booking_item_financials#8 refuses$d$);
   select is(pg_temp.t338o($p$select 1$p$, $q$update public.booking_items set finance_approval_withdrawal_reason='zz' where id=current_setting('l.i')::uuid$q$), $m$23514|finance approval withdrawal evidence is not editable on its own|app.guard_booking_item_financials$m$, $d$app.guard_booking_item_financials#10 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.booking_items set owner_user_id='c3380000-0000-0000-0000-000000000021'::uuid where id=current_setting('l.i')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$update public.booking_items set owner_user_id='c3380000-0000-0000-0000-000000000022'::uuid where id=current_setting('l.i')::uuid$q$), $m$23514|reassigning a booked service requires its own reason|app.guard_booking_item_reassignment$m$, $d$app.guard_booking_item_reassignment#1 refuses$d$);
   select is(pg_temp.t338o($p$select 1$p$, $q$update public.booking_items set reassignment_reason='zz' where id=current_setting('l.i')::uuid$q$), $m$23514|reassignment evidence is not editable on its own|app.guard_booking_item_reassignment$m$, $d$app.guard_booking_item_reassignment#2 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; delete from public.user_branch_assignments where tenant_id='c3380000-0000-0000-0000-000000000002'; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select set_config('l.row', (select to_jsonb(x)::text from public.conversations x where id=current_setting('l.cv')::uuid limit 1), true); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select pg_temp.clone('public.conversations', '{"id": "c3380000-0000-0000-0000-0000000a0001", "conversation_status_code": "open", "closed_at": null}'::jsonb)$q$), $m$42501|conversation creator needs an active user and primary branch assignment|app.guard_conversation_creation$m$, $d$app.guard_conversation_creation#2 refuses$d$);
   select is(pg_temp.t338o($p$select 1$p$, $q$update public.documents set legal_hold_active=not coalesce(legal_hold_active,false) where id=current_setting('l.d')::uuid$q$), $m$23514|placing or releasing a document legal hold requires its own reason|app.guard_document_legal_hold$m$, $d$app.guard_document_legal_hold#1 refuses$d$);
   select is(pg_temp.t338o($p$select 1$p$, $q$update public.documents set legal_hold_reason='zz' where id=current_setting('l.d')::uuid$q$), $m$23514|legal-hold evidence is not editable without a hold transition|app.guard_document_legal_hold$m$, $d$app.guard_document_legal_hold#2 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.booking_items set base_status_code='cancelled' where id=current_setting('l.i')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.internal_supplier_links (tenant_id, booking_item_id, provider_branch_id, provider_department_id, requester_branch_id, requester_department_id) values ('c3380000-0000-0000-0000-000000000002'::uuid, current_setting('l.i')::uuid, 'c3380000-0000-0000-0000-0000000000e1'::uuid, 'c3380000-0000-0000-0000-0000000000f1'::uuid, 'c3380000-0000-0000-0000-0000000000e1'::uuid, 'c3380000-0000-0000-0000-0000000000f1'::uuid); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|cannot link a supplier to a cancelled booking item|app.guard_internal_supplier_link$m$, $d$app.guard_internal_supplier_link#2 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.bookings set booking_status_code='cancelled' where id=current_setting('l.b')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.internal_supplier_links (tenant_id, booking_item_id, provider_branch_id, provider_department_id, requester_branch_id, requester_department_id) values ('c3380000-0000-0000-0000-000000000002'::uuid, current_setting('l.i')::uuid, 'c3380000-0000-0000-0000-0000000000e1'::uuid, 'c3380000-0000-0000-0000-0000000000f1'::uuid, 'c3380000-0000-0000-0000-0000000000e1'::uuid, 'c3380000-0000-0000-0000-0000000000f1'::uuid); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|cannot link a supplier to an item on a cancelled booking|app.guard_internal_supplier_link$m$, $d$app.guard_internal_supplier_link#3 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select set_config('l.row', (select to_jsonb(x)::text from public.invoices x where id=current_setting('l.v')::uuid limit 1), true); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select pg_temp.clone('public.invoices', '{"id": "c3380000-0000-0000-0000-0000000a0001", "status_code": "issued", "invoice_number": "SPEC338-Z"}'::jsonb)$q$), $m$23514|an invoice is raised as a draft and issued by app.issue_invoice; it cannot be created already issued (canon 26 state machine)|app.guard_invoice_integrity$m$, $d$app.guard_invoice_integrity#1 refuses$d$);
   select matches(pg_temp.t338o($p$select 1$p$, $q$update public.invoices set total_amount=999 where id=current_setting('l.v2')::uuid$q$), $m$^23514\|invoice\ INV-[0-9-]+\ is\ partially_paid\ and\ its\ total\ can\ no\ longer\ change;\ issue\ a\ correcting\ document\ instead\ \(canon\ 07:\ corrections\ after\ approval\ go\ through\ a\ new\ event,\ adjustment\ or\ reversal\)\|app\.guard_invoice_integrity$$m$, $d$app.guard_invoice_integrity#3 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; set constraints all immediate; alter table public.invoices disable trigger invoices_enforce_status_transition; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.invoices set status_code='voided' where id=current_setting('l.v2')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$update public.invoices set status_code='issued' where id=current_setting('l.v2')::uuid$q$), $m$23514|a voided invoice is terminal and cannot be un-voided; issue a correcting document instead|app.guard_invoice_void$m$, $d$app.guard_invoice_void#1 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.invoices set status_code='issued' where id=current_setting('l.v')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$update public.invoices set status_code='voided', external_submission_id='zz', void_reason='r' where id=current_setting('l.v')::uuid$q$), $m$23514|voiding an invoice may not change its external submission state -- the internal void asserts nothing about the tax authority|app.guard_invoice_void$m$, $d$app.guard_invoice_void#5 refuses$d$);
   select is(pg_temp.t338o($p$select 1$p$, $q$insert into public.lead_interactions (tenant_id, lead_id, interaction_type_code) values ('c3380000-0000-0000-0000-000000000002'::uuid, 'c3380000-0000-0000-0000-00000000dead'::uuid, 'note')$q$), $m$42501|lead is not in your tenant|app.guard_lead_interaction_authority$m$, $d$app.guard_lead_interaction_authority#1 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select set_config('l.row', (select to_jsonb(x)::text from public.bookings x where id=current_setting('l.b')::uuid limit 1), true); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select pg_temp.clone('public.bookings', '{"id": "c3380000-0000-0000-0000-0000000a0001", "quotation_id": "c3380000-0000-0000-0000-00000000dead"}'::jsonb); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|quotation is not in your tenant|app.guard_parent_state_allows_write$m$, $d$app.guard_parent_state_allows_write#1 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.booking_items set finance_approval_required=true where id=current_setting('l.i')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('l.ar', app.request_finance_approval(current_setting('l.i')::uuid,'spec338')::text, true);select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select set_config('l.row', (select to_jsonb(x)::text from public.approval_requests x where id=current_setting('l.ar')::uuid limit 1), true); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select pg_temp.clone('public.approval_requests', '{"id": "c3380000-0000-0000-0000-0000000a0001", "booking_item_id": "c3380000-0000-0000-0000-00000000dead"}'::jsonb); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|booking item is not in your tenant|app.guard_parent_state_allows_write$m$, $d$app.guard_parent_state_allows_write#3 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.booking_items set finance_approval_required=true where id=current_setting('l.i')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('l.ar', app.request_finance_approval(current_setting('l.i')::uuid,'spec338')::text, true);select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select set_config('l.row', (select to_jsonb(x)::text from public.approval_requests x where id=current_setting('l.ar')::uuid limit 1), true); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.bookings set booking_status_code='completed' where id=current_setting('l.b')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select pg_temp.clone('public.approval_requests', '{"id": "c3380000-0000-0000-0000-0000000a0001"}'::jsonb); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|cannot request finance approval on a completed/cancelled/archived booking|app.guard_parent_state_allows_write$m$, $d$app.guard_parent_state_allows_write#5 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select set_config('l.row', (select to_jsonb(x)::text from public.document_versions x where document_id=current_setting('l.d')::uuid limit 1), true); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select pg_temp.clone('public.document_versions', '{"id": "c3380000-0000-0000-0000-0000000a0001", "document_id": "c3380000-0000-0000-0000-00000000dead"}'::jsonb); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|document is not in your tenant|app.guard_parent_state_allows_write$m$, $d$app.guard_parent_state_allows_write#6 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.conversation_messages (tenant_id, conversation_id, sender_type_code, message_direction_code, message_text) values ('c3380000-0000-0000-0000-000000000002'::uuid, current_setting('l.cv')::uuid, 'user', 'outbound', 'spec338'); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select set_config('l.row', (select to_jsonb(x)::text from public.conversation_messages x where conversation_id=current_setting('l.cv')::uuid limit 1), true); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select pg_temp.clone('public.conversation_messages', '{"id": "c3380000-0000-0000-0000-0000000a0001", "conversation_id": "c3380000-0000-0000-0000-00000000dead"}'::jsonb); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|conversation not found in your tenant|app.guard_parent_state_allows_write$m$, $d$app.guard_parent_state_allows_write#8 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select set_config('l.row', (select to_jsonb(x)::text from public.payment_allocations x where payment_id=current_setting('l.pay')::uuid limit 1), true); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select pg_temp.clone('public.payment_allocations', '{"id": "c3380000-0000-0000-0000-0000000a0001", "invoice_id": "c3380000-0000-0000-0000-00000000dead"}'::jsonb); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|invoice is not in your tenant|app.guard_parent_state_allows_write$m$, $d$app.guard_parent_state_allows_write#10 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; insert into public.chart_of_accounts (tenant_id, code, name, account_type) values ('c3380000-0000-0000-0000-000000000002','1000','Cash','asset'),('c3380000-0000-0000-0000-000000000002','4000','Rev','revenue'); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;select set_config('l.je', app.create_journal_entry(p_source_type_code => 'manual_entry', p_entry_date => current_date, p_description => 'd', p_lines => '[{"account_code":"1000","debit":5,"currency":"EGP"},{"account_code":"4000","credit":5,"currency":"EGP"}]'::jsonb)::text, true);select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select set_config('l.row', (select to_jsonb(x)::text from public.journal_entry_lines x where journal_entry_id=current_setting('l.je')::uuid limit 1), true); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; select pg_temp.clone('public.journal_entry_lines', '{"id": "c3380000-0000-0000-0000-0000000a0001", "chart_account_id": "c3380000-0000-0000-0000-00000000dead"}'::jsonb); select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|unknown or inactive chart account code: c3380000-0000-0000-0000-00000000dead|app.guard_parent_state_allows_write$m$, $d$app.guard_parent_state_allows_write#13 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; with x as (insert into public.financial_accounts (tenant_id, financial_account_type_code, name, currency_code) values ('c3380000-0000-0000-0000-000000000002'::uuid, 'bank', 'fa usd', 'USD') returning id) select set_config('l.fa', id::text, true) from x; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.payments set financial_account_id=current_setting('l.fa')::uuid where id=current_setting('l.pay')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|cross-currency posting refused: a EGP payment into a USD account requires an explicit exchange_rate_id (FA-2)|app.guard_payment_currency_conversion$m$, $d$app.guard_payment_currency_conversion#4 refuses$d$);
   select is(pg_temp.t338o($p$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; with x as (insert into public.financial_accounts (tenant_id, financial_account_type_code, name, currency_code) values ('c3380000-0000-0000-0000-000000000002'::uuid, 'bank', 'fa usd', 'USD') returning id) select set_config('l.fa', id::text, true) from x; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.payments set financial_account_id=current_setting('l.fa')::uuid, exchange_rate_id='c3380000-0000-0000-0000-00000000dead'::uuid where id=current_setting('l.pay')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|exchange rate is not in your tenant|app.guard_payment_currency_conversion$m$, $d$app.guard_payment_currency_conversion#5 refuses$d$);
   select is(pg_temp.t338o($p$select 1$p$, $q$select set_config('l.cl', current_setting('request.jwt.claims', true), true); select set_config('request.jwt.claims', '', true); reset role; update public.leads set assigned_user_id='c3380000-0000-0000-0000-000000000022'::uuid, owner_user_id='c3380000-0000-0000-0000-000000000022'::uuid where id=current_setting('l.ld')::uuid; select set_config('request.jwt.claims', current_setting('l.cl'), true); set local role authenticated;$q$), $m$23514|a lead assignee may not change without a current lead_assignments row (canon 04: every assignment must remain visible in the lead timeline); use app.assign_lead or app.reassign_lead|app.require_assignment_history$m$, $d$app.require_assignment_history#1 refuses$d$);
   select * from finish();
   rollback;
   ```

   The resulting file's Git blob is 4865e7f8d5d7859d333965f83af04e07f2c5fa3f.

25. Check whether `supabase/tests/54_transition_permission_parity_test.sql` contains `('invoices','issued',        'partially_paid','app.derive_invoice_payment_status'),`; if so record Already Applied when its Git blob is c4b1b3e8549fd8820ae39eeda99c3e9edcb1dda7, and otherwise stop and report. Otherwise make exactly these 2 edits (test 54 moved by CRM SPEC-326 (the derived invoice settlement transition)), each matched once, and change nothing else:

   a) replace the lines
   ```text
     -- into `issued`; `app.record_payment` performs every move into `partially_paid`/`paid` and DERIVES
     -- which one from the amount rather than choosing it.
   ```
   with
   ```text
     -- into `issued`; every move into `partially_paid`/`paid` is DERIVED from the allocated amount by
     -- `app.derive_invoice_payment_status` on payment_allocations (B6-EXIT PAY-5 / FIN-11), so the
     -- table door and `app.record_payment` settle the invoice through one producer.
   ```

   b) replace the lines
   ```text
     ('invoices','issued',        'partially_paid','app.record_payment'),
     ('invoices','issued',        'paid',          'app.record_payment'),
     ('invoices','partially_paid','paid',          'app.record_payment'),
     ('invoices','overdue',       'partially_paid','app.record_payment'),
     ('invoices','overdue',       'paid',          'app.record_payment'),
   ```
   with
   ```text
     ('invoices','issued',        'partially_paid','app.derive_invoice_payment_status'),
     ('invoices','issued',        'paid',          'app.derive_invoice_payment_status'),
     ('invoices','partially_paid','paid',          'app.derive_invoice_payment_status'),
     ('invoices','overdue',       'partially_paid','app.derive_invoice_payment_status'),
     ('invoices','overdue',       'paid',          'app.derive_invoice_payment_status'),
   ```

   The resulting file's Git blob is c4b1b3e8549fd8820ae39eeda99c3e9edcb1dda7.

26. Check whether `supabase/tests/58_write_grants_and_config_capability_test.sql` contains `thirty-one tables now carry the write-capability guard`; if so record Already Applied when its Git blob is 68f4e874e55af952e5e2e8034dd334e347ea935c, and otherwise stop and report. Otherwise make exactly these 2 edits (test 58 moved by CRM SPEC-320 and SPEC-324 (the write-capability guard count)), each matched once, and change nothing else:

   a) replace the lines
   ```text
     28,
     'twenty-eight tables now carry the write-capability guard (13 + SEC-1b''s twelve, 202607057000 + booking_item_passengers, PAX-1, 202607061400 + booking_items, BOOK-3, 202607061500 + marketing_campaigns, CAMP-3, SPEC-222)');
   ```
   with
   ```text
     31,
     'thirty-one tables now carry the write-capability guard (13 + SEC-1b''s twelve, 202607057000 + booking_item_passengers, PAX-1, 202607061400 + booking_items, BOOK-3, 202607061500 + marketing_campaigns, CAMP-3, SPEC-222 + branches, BRANCH-1 + campaign_daily_metrics and exchange_rate_adjustments, STEPUP-1, 20261121100000)');
   ```

   b) replace the line
   ```text
                               'marketing_campaigns')),
   ```
   with
   ```text
                               'marketing_campaigns','branches',
                               -- STEPUP-1 (20261121100000): RLS charged the permission but not the step-up.
                               'campaign_daily_metrics','exchange_rate_adjustments')),
   ```

   The resulting file's Git blob is 68f4e874e55af952e5e2e8034dd334e347ea935c.

27. Check whether `supabase/tests/79_customer_data_integrity_test.sql` contains `select plan(33);`; if so record Already Applied when its Git blob is efe552ad654dbfcfa1d7921b564799e9bc271f7d, and otherwise stop and report. Otherwise make exactly these 2 edits (test 79 moved by CRM SPEC-316 (registration communication preferences)), each matched once, and change nothing else:

   a) replace the line
   ```text
   select plan(19);
   ```
   with
   ```text
   select plan(33);
   ```

   b) immediately after the lines
   ```text
     'TENANT ISOLATION: the RIVAL tenant customer holding the SAME phone number is not returned -- find_customer_duplicates is SECURITY INVOKER, so RLS bounds it');

   ```
   insert
   ```text
   -- Customer communication preference uses the same catalog at registration and on edit (canon 25).
   create temp table preference_creates (test_case text primary key, customer_id uuid not null);

   select lives_ok(
     $$insert into preference_creates
       select 'email', public.create_customer('person', 'Prefers email', p_preferred_contact_method_code => 'email')$$,
     'registration accepts email');
   select lives_ok(
     $$insert into preference_creates
       select 'whatsapp', public.create_customer('person', 'Prefers WhatsApp', p_preferred_contact_method_code => 'whatsapp')$$,
     'registration accepts whatsapp');
   select lives_ok(
     $$insert into preference_creates
       select 'phone', public.create_customer('person', 'Prefers phone', p_preferred_contact_method_code => 'phone')$$,
     'registration accepts phone');
   select lives_ok(
     $$insert into preference_creates
       select 'social', public.create_customer('person', 'Prefers social', p_preferred_contact_method_code => 'social')$$,
     'registration accepts social');
   select lives_ok(
     $$insert into preference_creates
       select 'unset', public.create_customer('person', 'Preference unset')$$,
     'registration permits an unspecified preference');
   select results_eq(
     $$select p.test_case, c.preferred_contact_method_code
       from preference_creates p join public.customers c on c.id = p.customer_id
       order by p.test_case$$,
     $$values ('email'::text, 'email'::text), ('phone', 'phone'), ('social', 'social'),
              ('unset', null), ('whatsapp', 'whatsapp')$$,
     'registration persisted all four preferences and the nullable case');

   with changed as (
     update public.customers set preferred_contact_method_code = 'phone'
     where id = (select id from cust)
     returning preferred_contact_method_code
   )
   select is((select preferred_contact_method_code from changed), 'phone', 'edit stores phone');

   with changed as (
     update public.customers set preferred_contact_method_code = 'social'
     where id = (select id from cust)
     returning preferred_contact_method_code
   )
   select is((select preferred_contact_method_code from changed), 'social', 'edit stores social');

   with changed as (
     update public.customers set preferred_contact_method_code = 'email'
     where id = (select id from cust)
     returning preferred_contact_method_code
   )
   select is((select preferred_contact_method_code from changed), 'email', 'edit stores email');

   with changed as (
     update public.customers set preferred_contact_method_code = 'whatsapp'
     where id = (select id from cust)
     returning preferred_contact_method_code
   )
   select is((select preferred_contact_method_code from changed), 'whatsapp', 'edit stores whatsapp');

   with changed as (
     update public.customers set preferred_contact_method_code = null
     where id = (select id from cust)
     returning preferred_contact_method_code
   )
   select ok((select count(*) = 1 and bool_and(preferred_contact_method_code is null) from changed),
     'edit can clear an existing preference');

   select throws_matching(
     $$select public.create_customer('person', 'Wrong family', p_preferred_contact_method_code => 'primary_phone')$$,
     'preferred_contact_method_code',
     'registration rejects a code from the contact-detail catalog');
   select throws_ok(
     $$update public.customers set preferred_contact_method_code = 'primary_phone'
       where id = (select id from cust)$$,
     '23514', null,
     'edit rejects a code from the contact-detail catalog');
   select throws_matching(
     $$select public.create_customer('person', 'Unknown preference', p_preferred_contact_method_code => 'unknown')$$,
     'preferred_contact_method_code',
     'registration rejects an unknown code');

   ```

   The resulting file's Git blob is efe552ad654dbfcfa1d7921b564799e9bc271f7d.

28. Check whether `supabase/tests/96_invoice_void_and_eta_boundary_test.sql` contains `-- Since SPEC-326 an allocation derives partially_paid itself (PAY-5), which the transition table alone`; if so record Already Applied when its Git blob is 72e2107b07178f352a634606fcbd7173bdf39a23, and otherwise stop and report. Otherwise make exactly these 3 edits (test 96 moved by CRM SPEC-326 (derived partially_paid)), each matched once, and change nothing else:

   a) immediately after the line
   ```text
   -- the platform path, so the fixtures themselves are not what is under test.
   ```
   insert
   ```text
   -- Since SPEC-326 an allocation derives partially_paid itself (PAY-5), which the transition table alone
   -- would then refuse to void. f3 keeps the state this test exists for -- money allocated while the
   -- status word still says `issued`, as every door allocation before SPEC-326 left it -- by writing its
   -- allocation with only the settlement trigger off, so the void guard, not the status, is what refuses.
   ```

   b) immediately after the line
   ```text
     ('96000000-0000-0000-0000-0000000000e1','96000000-0000-0000-0000-000000000001','96000000-0000-0000-0000-0000000000d1','customer_payment','bank_transfer','EGP', 400, now());
   ```
   insert
   ```text
   alter table public.payment_allocations disable trigger payment_allocations_settle_invoice;
   ```

   c) immediately after the line
   ```text
     ('96000000-0000-0000-0000-000000000001','96000000-0000-0000-0000-0000000000e1','96000000-0000-0000-0000-0000000000f3', 400, 'EGP');
   ```
   insert
   ```text
   -- Its two deferred ceilings run now (the table cannot be altered with them pending) and defer again.
   set constraints payment_allocations_within_invoice_total, payment_allocations_within_payment_amount immediate;
   alter table public.payment_allocations enable trigger payment_allocations_settle_invoice;
   set constraints payment_allocations_within_invoice_total, payment_allocations_within_payment_amount deferred;
   ```

   The resulting file's Git blob is 72e2107b07178f352a634606fcbd7173bdf39a23.

29. Check whether `supabase/tests/101_marketing_metrics_and_fx_adjustment_surface_test.sql` contains `-- table door's own step-up guard, charging the permission the RLS write check already names plus`; if so record Already Applied when its Git blob is 2b86d7be04a4a337d387ff60da68789caa9c9ca6, and otherwise stop and report. Otherwise make exactly this one edit (test 101 moved by CRM SPEC-324 (the table door step-up guard)), each matched once, and change nothing else:

   a) replace the line
   ```text
         and p.oid <> 'app.guard_exchange_rate_write'::regproc),
   ```
   with
   ```text
         and p.oid <> 'app.guard_exchange_rate_write'::regproc
         -- Re-reasoned at B6-EXIT bundle A (`20261121100000`, STEPUP-1): `app.guard_write_capability` is the
         -- table door's own step-up guard, charging the permission the RLS write check already names plus
         -- the role's MFA. It writes nothing and opens no other door to either table.
         and p.oid <> 'app.guard_write_capability'::regproc),
   ```

   The resulting file's Git blob is 2b86d7be04a4a337d387ff60da68789caa9c9ca6.

30. Check whether `supabase/tests/106_otp_challenge_subject_authority_test.sql` contains `select plan(14);`; if so record Already Applied when its Git blob is 02adabd5182f9515a5c1ff17bbaf6431fb083519, and otherwise stop and report. Otherwise make exactly these 3 edits (test 106 moved with CRM SPEC-316 to SPEC-340), each matched once, and change nothing else:

   a) replace the lines
   ```text
   -- 15-16 are the PAX-4 correction, made executable. `202607061400` recorded that 20 tables "have no
   --       trigger that calls app.authorize or app.has_permission at all" and read that as 20
   --       ungoverned writes. Re-measured: 15 of the 20 carry the capability check inside the RLS
   --       POLICY instead of a trigger, so the count was of ENFORCEMENT SITES OF ONE KIND and the
   --       inference drawn from it was about GOVERNANCE. These two assertions exist so the corrected
   --       number cannot quietly drift back to the proxy: if a future change moves a capability check
   --       from a policy into a trigger, or removes one, the numbers move and this file fails.
   ```
   with
   ```text
   -- INSERT authorization coverage is owned by Test 67 (SEC-1b). Test 106 keeps the independent OTP assertions.

   ```

   b) replace the line
   ```text
   select plan(16);
   ```
   with
   ```text
   select plan(14);
   ```

   c) replace the lines
   ```text

   -- =============================================================================================
   -- 15-16. THE PAX-4 CORRECTION, MADE EXECUTABLE.
   -- =============================================================================================
   select is(
     (with named(t) as (values
        ('branches'),('catalog_values'),('chart_of_accounts'),('departments'),('exchange_rates'),
        ('journal_entries'),('journal_entry_lines'),('lead_interactions'),('subscriptions'),('tenants'),
        ('users'),('user_branch_assignments'),('user_permission_grants'),('otp_challenges'),
        ('totp_enrollments'),('trusted_devices'),('campaign_daily_metrics'),('document_retention_policies'),
        ('exchange_rate_adjustments'),('subscription_payment_proofs'))
      select count(*)::int from named n
       where coalesce((select bool_or(coalesce(pg_get_expr(p.polqual, p.polrelid),'') ||
                                      coalesce(pg_get_expr(p.polwithcheck, p.polrelid),'') ~* '(has_permission|authorize)')
                         from pg_policy p
                        where p.polrelid = ('public.' || n.t)::regclass and p.polcmd in ('a','w')), false)),
     15,
     'PAX-4 CORRECTED: 15 of the 20 tables it counted as having "no capability trigger" carry the capability check inside the RLS POLICY -- the count measured enforcement sites of one kind and was read as governance');

   select is(
     (with named(t) as (values
        ('branches'),('catalog_values'),('chart_of_accounts'),('departments'),('exchange_rates'),
        ('journal_entries'),('journal_entry_lines'),('lead_interactions'),('subscriptions'),('tenants'),
        ('users'),('user_branch_assignments'),('user_permission_grants'),('otp_challenges'),
        ('totp_enrollments'),('trusted_devices'),('campaign_daily_metrics'),('document_retention_policies'),
        ('exchange_rate_adjustments'),('subscription_payment_proofs'))
      select coalesce(string_agg(n.t, ',' order by n.t), '') from named n
       where not coalesce((select bool_or(coalesce(pg_get_expr(p.polqual, p.polrelid),'') ||
                                          coalesce(pg_get_expr(p.polwithcheck, p.polrelid),'') ~* '(has_permission|authorize)')
                             from pg_policy p
                            where p.polrelid = ('public.' || n.t)::regclass and p.polcmd in ('a','w')), false)),
     'campaign_daily_metrics,lead_interactions,otp_challenges,totp_enrollments,trusted_devices',
     '...and PAX-4''s genuinely uncovered set is these FIVE, each already dispositioned or registered -- named rather than counted, so a new member cannot hide inside a number that still reads 5');

   ```
   with
   ```text

   ```

   The resulting file's Git blob is 02adabd5182f9515a5c1ff17bbaf6431fb083519.

31. Check whether `supabase/tests/130_branch_door_audit_test.sql` contains `-- SPEC-226 / Batch 6 Slice 24 records the branch audit. BRANCH-1 now requires the same`; if so record Already Applied when its Git blob is 1100910b9540ce32e32d691bb215f11fa74bdecd, and otherwise stop and report. Otherwise make exactly these 11 edits (test 130 moved by CRM SPEC-320 (BRANCH-1)), each matched once, and change nothing else:

   a) replace the lines
   ```text
   -- SPEC-226 / Batch 6 Slice 24. `branches` is audited, not repaired. What holds is pinned to the
   -- control that holds it: tenant placement, tenant relocation and the non-holder are refused by the
   -- `scope_insert` / `scope_update` policies, which is proven by removing each conjunct of the INSERT
   -- policy separately inside a savepoint and watching the matching attack land; DELETE has no grant;
   -- the slug is unique per tenant. What does NOT hold is pinned as OPEN so this file can never be read
   -- as having fixed it: BRANCH-1 (an aal1 owner writes the table the RPC refuses it) and BRANCH-2 (a
   -- direct INSERT records no `branch_created`). Those four assertions (6-8, 19) record a DEFECT that
   -- is still OPEN, NOT a desired invariant: they pass today only because the defect exists, and they
   -- are written to FAIL when their finding is repaired.
   ```
   with
   ```text
   -- SPEC-226 / Batch 6 Slice 24 records the branch audit. BRANCH-1 now requires the same
   -- step-up for table writes, the branch RPC and branch business hours. The capability guard
   -- enforces permission on INSERT independently of RLS. RLS still owns the tenant fence and
   -- UPDATE visibility. DELETE has no grant, and the slug remains unique per tenant.
   -- BRANCH-2 remains open. Assertion 19 records the direct creation event gap at its own gate.
   ```

   b) replace the lines
   ```text
   -- 4-8. AUTH / DOOR. The RPC and the child table charge step-up (desired, held). The table door does
   --      not: 6-8 pin the OPEN defect BRANCH-1, which is NOT desired behaviour.
   ```
   with
   ```text
   -- 4-8. AUTH / DOOR. The branch table, RPC and child table all require step-up.
   --      BRANCH-1 closes only the branch table's authority gap.
   ```

   c) replace the lines
   ```text
     'the child table door refuses the aal1 owner the same capability');
   select lives_ok(
   ```
   with
   ```text
     'the child table door refuses the aal1 owner the same capability');
   select throws_ok(
   ```

   d) replace the lines
   ```text
     'BRANCH-1 is OPEN: the aal1 owner creates a branch through the table (FAILS when BRANCH-1 is repaired)');
   select lives_ok(
   ```
   with
   ```text
     '42501','multi-factor authentication required for this role',
     'the branch table refuses creation without step-up');
   select throws_ok(
   ```

   e) replace the line
   ```text
     'BRANCH-1 is OPEN: the aal1 owner renames, re-slugs and deactivates a branch through the table (FAILS when repaired)');
   ```
   with
   ```text
     '42501','multi-factor authentication required for this role',
     'the branch table refuses edits without step-up');
   ```

   f) replace the lines
   ```text
     array['Hijacked','br130-hijacked','false'],
     '...and the aal1 rewrite persisted');
   update public.branches set name='Main', slug='br130-main', is_active=true where id='13000000-0000-0000-0000-00000000000a';
   ```
   with
   ```text
     array['Main','br130-main','true'],
     'the refused edit preserves the branch row');
   ```

   g) replace the line
   ```text
   -- 20-23. PRIVILEGE: a non-holder at aal2 has its INSERT refused by the policy, and its UPDATE matches
   ```
   with
   ```text
   -- 20-23. PRIVILEGE: the guard refuses INSERT by a non-holder at aal2, and UPDATE matches
   ```

   h) replace the lines
   ```text
       values ('13000000-0000-0000-0000-000000000001','Employee','br130-employee')$$,
     '42501','new row violates row-level security policy for table "branches"',
   ```
   with
   ```text
       values ('13000000-0000-0000-0000-000000000001','Employee','br130-employee')$$,
     '42501','permission denied: one of MANAGE_BRANCHES is required to write branches',
   ```

   i) replace the lines
   ```text
   -- 24-29. Mutation: each conjunct of `scope_insert` is load-bearing. Remove one at a time inside a
   --        savepoint, prove the installed expression changed, prove the attack that conjunct refuses
   --        now lands, then roll back and prove the original expression is back byte for byte.
   ```
   with
   ```text
   -- 24-29. Remove each INSERT policy conjunct in its own savepoint. The capability guard still
   --        refuses an actor without permission. The tenant restriction remains load-bearing.
   --        Roll the changes back and check restoration.
   ```

   j) replace the lines
   ```text
   select set_config('request.jwt.claims','{"sub":"13000000-0000-0000-0000-0000000000a2","aal":"aal2"}',true);
   select lives_ok(
   ```
   with
   ```text
   select set_config('request.jwt.claims','{"sub":"13000000-0000-0000-0000-0000000000a2","aal":"aal2"}',true);
   select throws_ok(
   ```

   k) replace the line
   ```text
     'MUTANT 1: the employee''s insert lands, so the permission conjunct is what refused it');
   ```
   with
   ```text
     '42501','permission denied: one of MANAGE_BRANCHES is required to write branches',
     'MUTANT 1: the capability guard still refuses a non-holder');
   ```

   The resulting file's Git blob is 1100910b9540ce32e32d691bb215f11fa74bdecd.

32. Check whether `supabase/tests/134_task_queue_authority_test.sql` contains `select plan(32);`; if so record Already Applied when its Git blob is a8c0ef7d4a916bfbcef68668691b4028a0d8c27a, and otherwise stop and report. Otherwise make exactly these 9 edits (test 134 moved by CRM SPEC-318 and SPEC-319 (task entry and archive authority)), each matched once, and change nothing else:

   a) replace the lines
   ```text
   -- It also pins two OPEN defects as they stand, not as desired behaviour; each assertion fails when its
   -- finding is repaired: ENTRY-1 (a user DENIED COMPLETE_TASK creates a task born `completed`) and
   -- ARCH-2 (a user without ARCHIVE_RECORD creates a task born archived under another user's name).
   ```
   with
   ```text
   -- The ENTRY-1 assertions cover rejected terminal-state creation and allowed open creation.
   -- The ARCH-2 assertions cover refused archive-at-entry and absence of the rejected task.
   ```

   b) replace the line
   ```text
   select plan(30);
   ```
   with
   ```text
   select plan(32);
   ```

   c) replace the line
   ```text
   -- 22-25. OPEN defects, pinned as they stand. Each assertion fails when its finding is repaired.
   ```
   with
   ```text
   -- 22-27. ENTRY-1 terminal-state guard and the existing ARCH-2 evidence.
   ```

   d) replace the line
   ```text
   select lives_ok($$insert into public.tasks (id,tenant_id,owner_user_id,owner_department_id,owner_branch_id,task_type_code,task_status_code,title)
   ```
   with
   ```text
   select throws_ok($$insert into public.tasks (id,tenant_id,owner_user_id,owner_department_id,owner_branch_id,task_type_code,task_status_code,title)
   ```

   e) replace the line
   ```text
     'OPEN ENTRY-1: the employee denied COMPLETE_TASK still creates a task born completed');
   ```
   with
   ```text
     '23514','a task cannot be created in a terminal state',
     'ENTRY-1: an employee cannot create a completed task');
   select throws_ok($$insert into public.tasks (id,tenant_id,owner_user_id,owner_department_id,owner_branch_id,task_type_code,task_status_code,title)
                     values ('13400000-0000-0000-0000-0000000000f3','13400000-0000-0000-0000-000000000001','13400000-0000-0000-0000-000000000014',
                             '13400000-0000-0000-0000-0000000000d1','13400000-0000-0000-0000-0000000000b1','follow_up','cancelled','born cancelled')$$,
     '23514','a task cannot be created in a terminal state',
     'ENTRY-1: an employee cannot create a cancelled task');
   select lives_ok($$insert into public.tasks (id,tenant_id,owner_user_id,owner_department_id,owner_branch_id,task_type_code,task_status_code,title)
                     values ('13400000-0000-0000-0000-0000000000f4','13400000-0000-0000-0000-000000000001','13400000-0000-0000-0000-000000000014',
                             '13400000-0000-0000-0000-0000000000d1','13400000-0000-0000-0000-0000000000b1','follow_up','open','open task')$$,
     'ENTRY-1: an employee with CREATE_TASK can create an open task');
   ```

   f) replace the line
   ```text
   select lives_ok($$insert into public.tasks (id,tenant_id,owner_user_id,owner_department_id,owner_branch_id,task_type_code,task_status_code,title,
   ```
   with
   ```text
   select throws_ok($$insert into public.tasks (id,tenant_id,owner_user_id,owner_department_id,owner_branch_id,task_type_code,task_status_code,title,
   ```

   g) replace the line
   ```text
     'OPEN ARCH-2: the employee without ARCHIVE_RECORD still creates a task born archived');
   ```
   with
   ```text
     '42501','permission denied: ARCHIVE_RECORD',
     'ARCH-2: an employee without ARCHIVE_RECORD cannot create an archived task');
   ```

   h) replace the lines
   ```text
   select is((select task_status_code || ':' || coalesce(completed_at::text,'-') from public.tasks where id = '13400000-0000-0000-0000-0000000000f1'),
     'completed:-',
     'OPEN ENTRY-1: it is terminal, with no completion time and no RPC having completed it');
   select is((select archived_by::text || ':' || archived_at::date::text from public.tasks where id = '13400000-0000-0000-0000-0000000000f2'),
     '13400000-0000-0000-0000-000000000011:2020-01-01',
     'OPEN ARCH-2: it names the owner as archiver at a caller-authored time');
   ```
   with
   ```text
   select is((select count(*)::int from public.tasks where id in ('13400000-0000-0000-0000-0000000000f1','13400000-0000-0000-0000-0000000000f3')), 0,
     'ENTRY-1: neither rejected terminal-state task was stored');
   select is((select count(*)::int from public.tasks where id = '13400000-0000-0000-0000-0000000000f2'), 0,
     'ARCH-2: the rejected archived task was not stored');
   ```

   i) replace the line
   ```text
   -- 26-30. Mutation: the pre-repair guard (owner only) is installed in a savepoint, the move lands,
   ```
   with
   ```text
   -- 28-32. Mutation: the pre-repair guard (owner only) is installed in a savepoint, the move lands,
   ```

   The resulting file's Git blob is a8c0ef7d4a916bfbcef68668691b4028a0d8c27a.

33. Check whether `supabase/tests/140_payment_is_recorded_on_every_door_test.sql` contains `which its allocation settled (PAY-5)`; if so record Already Applied when its Git blob is d132e48e82f068588148df658d9eeedc4d2b15d7, and otherwise stop and report. Otherwise make exactly this one edit (test 140 moved by CRM SPEC-326 (PAY-5)), each matched once, and change nothing else:

   a) replace the lines
   ```text
     '1/14000000-0000-0000-0000-000000000011/payment_recorded/-/{"amount": 5000.0000, "invoice_id": "' || (select v from s140 where k='inv2') || '", "currency_code": "EGP", "invoice_new_status": "issued"}',
     'PAY-3: a door payment allocated to an invoice in the same transaction records ONE payment_recorded naming its writer and that invoice -- before the PAY-3 migration it had zero events');
   ```
   with
   ```text
     '1/14000000-0000-0000-0000-000000000011/payment_recorded/-/{"amount": 5000.0000, "invoice_id": "' || (select v from s140 where k='inv2') || '", "currency_code": "EGP", "invoice_new_status": "paid"}',
     'PAY-3: a door payment allocated to an invoice in the same transaction records ONE payment_recorded naming its writer and that invoice, which its allocation settled (PAY-5) -- before the PAY-3 migration it had zero events');
   ```

   The resulting file's Git blob is d132e48e82f068588148df658d9eeedc4d2b15d7.

34. Check whether `supabase/tests/145_a_journal_line_is_written_only_with_its_entry_test.sql` contains `-- JE-2 is CONTAINED (20261122100000): an entry balances in one currency until DC-11 decides the`; if so record Already Applied when its Git blob is 926f2eac4f1c96b5a5814a9c134115d34343e253, and otherwise stop and report. Otherwise make exactly these 3 edits (test 145 moved by CRM SPEC-328 (JE-2 contained)), each matched once, and change nothing else:

   a) replace the lines
   ```text
   -- JE-2 stays OPEN and is pinned as OPEN, not as desired behaviour: this fails when DC-11 decides
   -- whether an entry is one currency or is translated to a base currency.
   ```
   with
   ```text
   -- JE-2 is CONTAINED (20261122100000): an entry balances in one currency until DC-11 decides the
   -- translation model, so a 100 USD debit no longer balances a 100 EGP credit. The refusal is the
   -- deferred balance trigger's, so the check is fired inside the call; `185_...` pins both doors.
   ```

   b) replace the lines
   ```text
   select lives_ok($q$select app.create_journal_entry('manual_entry', current_date, 'JE-2',
       '[{"account_code":"1000","debit":100,"currency":"USD"},{"account_code":"4000","credit":100,"currency":"EGP"}]'::jsonb)$q$,
     'JE-2 OPEN: a 100 USD debit still balances a 100 EGP credit through the RPC -- the accounting-model decision DC-11 owns');
   ```
   with
   ```text
   select throws_ok($q$do $x$ begin
       perform app.create_journal_entry('manual_entry', current_date, 'JE-2',
         '[{"account_code":"1000","debit":100,"currency":"USD"},{"account_code":"4000","credit":100,"currency":"EGP"}]'::jsonb);
       execute 'set constraints all immediate';
     end $x$$q$,
     '23514', null,
     'JE-2 CONTAINED: a 100 USD debit against a 100 EGP credit is refused through the RPC');
   ```

   c) replace the lines
   ```text
     4,
     'OBSERVABILITY: every entry in the tenant has at least two lines and balances');
   ```
   with
   ```text
     3,
     'OBSERVABILITY: every entry in the tenant has at least two lines and balances -- E1, E2 and E4; the refused JE-2 entry left nothing');
   ```

   The resulting file's Git blob is 926f2eac4f1c96b5a5814a9c134115d34343e253.

35. Check whether `supabase/tests/155_an_allocation_spends_its_own_payment_on_its_own_invoice_test.sql` contains `Since SPEC-326 a door allocation derives the invoice's partially_paid or paid status itself`; if so record Already Applied when its Git blob is f85481f019a59ea756ba93a056140cc3576fc423, and otherwise stop and report. Otherwise make exactly these 12 edits (test 155 moved by CRM SPEC-326 (the derived settlement)), each matched once, and change nothing else:

   a) replace the line
   ```text
   --   A door allocation still leaves the invoice status where it was (PAY-5, not this contract's).
   ```
   with
   ```text
   --   Since SPEC-326 a door allocation derives the invoice's partially_paid or paid status itself (PAY-5, Test 184),
   --   so every correction below happens where the invoice's recorded status still allows it.
   ```

   b) replace the line
   ```text
               '15500000-0000-0000-0000-0000000000e1',8,'USD','15500000-0000-0000-0000-00000000ee01');
   ```
   with
   ```text
               '15500000-0000-0000-0000-0000000000e1',4,'USD','15500000-0000-0000-0000-00000000ee01');
   ```

   c) replace the line
   ```text
     '30. FA-2 permits a cross-currency allocation with its rate: 8 USD to C1''s EGP invoice');
   ```
   with
   ```text
     '30. FA-2 permits a cross-currency allocation with its rate: 4 USD to C1''s EGP invoice');
   ```

   d) replace the lines
   ```text
     '8.0000/400.0000', '31. the invoice-currency amount is derived from the rate: 8 USD at 50 is 400 EGP');
   select throws_ok($$select app.record_payment('15500000-0000-0000-0000-0000000000e1',0.0001,'cash')$$,
     'P0001','payment 0.0001 exceeds invoice outstanding 0.0000 (total 1000.0000, already allocated 1000.0000)',
     '32. app.record_payment reads the invoice in its own currency: 600 EGP + 8 USD fill it (face value would leave 392)');
   ```
   with
   ```text
     '4.0000/200.0000', '31. the invoice-currency amount is derived from the rate: 4 USD at 50 is 200 EGP');
   select throws_ok($$select app.record_payment('15500000-0000-0000-0000-0000000000e1',200.0001,'cash')$$,
     'P0001','payment 200.0001 exceeds invoice outstanding 200.0000 (total 1000.0000, already allocated 800.0000)',
     '32. app.record_payment reads the invoice in its own currency: 600 EGP + 4 USD leave 200 (face value would leave 396)');
   ```

   e) replace the line
   ```text
       update public.payment_allocations set allocated_amount=0 where id='15500000-0000-0000-0000-00000000aa02';
   ```
   with
   ```text
       update public.payment_allocations set allocated_amount=2 where id='15500000-0000-0000-0000-00000000aa02';
   ```

   f) replace the line
   ```text
     '35. RECORD_PAYMENT still corrects an amount');
   ```
   with
   ```text
     '35. RECORD_PAYMENT still corrects an amount, while the invoice it part-paid stays part-paid (4 -> 2 USD)');
   ```

   g) replace the line
   ```text
     '0.0000/0.0000', '36. ...and the invoice-currency amount follows it');
   ```
   with
   ```text
     '2.0000/100.0000', '36. ...and the invoice-currency amount follows it');
   ```

   h) replace the line
   ```text
     '37. the correction a misplaced allocation needs, where no recorded status rests on it: zero it, allocate again');
   ```
   with
   ```text
     '37. the correction a misplaced allocation needs, while the invoice stays part-paid on what remains: zero it, allocate again');
   ```

   i) replace the line
   ```text
     '0.0000/600.0000', '38. ...moving C1''s 600 from IA to IC, both rows kept as history');
   ```
   with
   ```text
     '100.0000/600.0000', '38. ...moving C1''s 600 from IA to IC, both rows kept as history');
   ```

   j) replace the line
   ```text
     'payment_allocation_created:info:->8.0000:->400.0000:true | payment_allocation_amount_changed:warning:8.0000>0.0000:400.0000>0.0000:true',
   ```
   with
   ```text
     'payment_allocation_created:info:->4.0000:->200.0000:true | payment_allocation_amount_changed:warning:4.0000>2.0000:200.0000>100.0000:true',
   ```

   k) replace the lines
   ```text
     'PA155-IA:issued:0.0000 | PA155-IB:paid:1000.0000 | PA155-ID:partially_paid:100.0000',
     '60. the floor refuses and moves no status: the door''s IA stays issued (PAY-5), IB paid, ID partially_paid');
   ```
   with
   ```text
     'PA155-IA:partially_paid:100.0000 | PA155-IB:paid:1000.0000 | PA155-ID:partially_paid:100.0000',
     '60. the floor refuses and moves no status: the door''s IA stays part-paid on what remains (PAY-5), IB paid, ID partially_paid');
   ```

   l) replace the line
   ```text
     '62. a session-less correction on an issued invoice passes every check');
   ```
   with
   ```text
     '62. a session-less correction on a part-paid invoice that stays part-paid passes every check');
   ```

   The resulting file's Git blob is f85481f019a59ea756ba93a056140cc3576fc423.

36. Check whether `reports/master/MASTER_EXECUTION_PLAN.md` contains `SPEC-319 catches ORVION up with CRM SPEC-316 to SPEC-340 by identity`; if so record Already Applied when its Git blob is 9daac0e7c21aa73445b3e0c99412621177e5db05, and otherwise stop and report. Otherwise make exactly these 12 edits (the plan rows of CRM SPEC-316 to SPEC-340 with In ORVION notes), each matched once, and change nothing else:

   a) replace the line
   ```text
   Last updated: 2026-10-14 (**CTRL-19 joins the Action registry (SPEC-281).** SPEC-281 fixed CTRL-17 and CTRL-18, and proved that a candidate can certify itself through the required check it defines. The repair is GitHub configuration only the owner can make, so CTRL-19 waits on the owner at `GATE-EVAL`.)
   ```
   with
   ```text
   Last updated: 2026-11-25 (**SPEC-319 catches ORVION up with CRM SPEC-316 to SPEC-340 by identity.** The seven CRM migrations `20261119054533` to `20261122100000` and Tests 182 to 198 are adopted byte-identical, the gap register and the surface disposition adopt CRM's rows with an In ORVION note, and this Action registry adopts CRM's classifications, naming CRM SPEC numbers and CRM's Platinum Primary as CRM evidence. ORVION keeps its own `B6-EXIT` (NEXT), CTRL-11, CTRL-19 and FIN-9 rows: they record ORVION's own boundary, its own target's reads and the owner's GitHub decision for this repository.)

   Previously: 2026-10-14 (**CTRL-19 joins the Action registry (SPEC-281).** SPEC-281 fixed CTRL-17 and CTRL-18, and proved that a candidate can certify itself through the required check it defines. The repair is GitHub configuration only the owner can make, so CTRL-19 waits on the owner at `GATE-EVAL`.)
   ```

   b) replace the line
   ```text
   | `ENABLE-CLIENT-WRITES` | a client application first writes | frontend, OD-9 | NOT REACHED |
   ```
   with
   ```text
   | `ENABLE-CLIENT-WRITES` | a client application first writes | frontend (FE-0, after `B6-EXIT`) | NOT REACHED |
   ```

   c) replace the lines
   ```text
   |---|---|---|---|---|---|
   | USR-3 | VERIFIED DEFECT | engineering | `FIRST-TENANT` | — | High. An `aal1` `ceo` self-granted a permission and self-assigned a branch at the table door. Fixed by the Batch 6 slice of `user_permission_grants` or `user_branch_assignments`, whichever the selector reaches first; it is the strongest candidate for the next justified exception |
   ```
   with
   ```text
   |---|---|---|---|---|---|
   ```

   d) immediately after the line
   ```text
   | BOOK-11, BOOK-12 | VERIFIED DEFECT | engineering | `FIRST-BOOKING` | BOOK-12: the rule for when a booking's customer freezes, derived from canon and escalated to the owner only if not derivable | Medium. Door cancellation leaves no reason, stamp or event; the customer can be rebound before issuance |
   ```
   insert
   ```text
   | BOOK-13 | VERIFIED DEFECT | engineering | `FIRST-BOOKING` | — | Low. A member chooses or rewrites the creation date of their own booking and booking item, and `reporting.sales_activity` and `reporting.my_sales_performance` report that date. The platform owns both stamps before the first production booking (CRM SPEC-335, Test 194) |
   ```

   e) replace the lines
   ```text
   | PAY-5, FIN-11 | VERIFIED DEFECT | engineering | `ENABLE-INVOICING` | — | Low. A door allocation leaves the invoice's status unchanged and records no event. One unit: a single authority derives invoice status and its event on both doors, as `app.record_payment` does |
   | RFD-3 | VERIFIED DEFECT | engineering | `ENABLE-REFUNDS` | — | Medium. Legal direct refund writes move customer balance with no refund events. Refund event authority on both doors, without duplicating the RPC's emission |
   | PAY-4 | VERIFIED DEFECT | engineering | `FIRST-PAYMENT` | — | Low. The table accepts a zero-value payment coded as a customer refund. A payment entry-shape rule derived from the sanctioned RPCs |
   | JE-2, DC-11 | VERIFIED DEFECT | engineering | `FIRST-JOURNAL-ENTRY` | the finance model (OD-1) | Medium. An entry can balance across two currencies. Decide DC-11, or contain the gap fail-closed by refusing a mixed-currency entry until the model is decided; launch never presents a false balance |
   | ARCH-2, ENTRY-1, CAMP-2, STEPUP-1, PAX-4 | VERIFIED DEFECT | engineering | `B6-EXIT` | each listed table's slice | Medium for ARCH-2 and ENTRY-1; CAMP-2 is ENTRY-1's question and is answered with it. STEPUP-1 and PAX-4 are UNPROVEN class candidates held here until each table's slice proves or dismisses its member; they never count as proven (EC-1) |
   ```
   with
   ```text
   | JE-2, DC-11 | VERIFIED DEFECT | engineering | `FIRST-JOURNAL-ENTRY` | the finance model (OD-1) | Medium. CRM SPEC-327 and Test 185 contain JE-2 fail-closed on CRM's Platinum Primary: the deferred balance trigger refuses an entry whose lines carry more than one currency, on every door. DC-11 still decides the translation model; launch never presents a false balance. |
   | CAMP-2 | VERIFIED DEFECT | engineering | `OWN-TRIGGER` | a programme-wide initial-state pass, or the first reproduced harm | UNPROVEN as a material campaign defect. Test 127 confirms entry behavior and the gap register reports no reproduced harm. CRM SPEC-324 assessed campaign entry under ENTRY-1 without material consequence. |
   ```

   f) replace the lines
   ```text
   | CHAT-2, CAMP-4, BRANCH-1, BRANCH-2, PAX-8 | VERIFIED DEFECT | engineering | `ENABLE-SURFACE-WORKFLOW` | — | Low. Audit and timeline evidence is missing at a table door, and each finding's measured bound is that nothing reads it. At the gate the bound is re-measured: if it holds, the item becomes an explicit accepted residual; otherwise it is repaired. Never deferred silently |
   | APP-1 | REQUIRED CAPABILITY | engineering | `FIRST-TENANT` | OD-9 (whether it runs beside Batch 6), OD-5 (staff login) | No client application exists, while ADR-0014 chose a server-rendered web app as ORVION's client. Treatment: FE-0, the web foundation and the first read-only journey (`delivery-assessment-2026-10-11.md` §7) |
   ```
   with
   ```text
   | QUO-12 | VERIFIED DEFECT | engineering | `ENABLE-CRM` | BOOK-9's rule: a reassignment needs a permission, a reason and an event | Low. The assigned member renumbers and re-leads a quotation, and a manager reassigns its owner, at the table door with no event; no RPC offers these changes (CRM SPEC-335, Test 194) |
   | CHAT-5 | VERIFIED DEFECT | engineering | `ENABLE-CRM` | — | Low, fail-closed. An invalid conversation transition is refused as `permission denied: <NULL>` instead of its own message, so staff see a permission error for a move that does not exist (CRM SPEC-338, Test 196) |
   | CAMP-4, BRANCH-2, PAX-8, DOC-11, QUO-11 | VERIFIED DEFECT | engineering | `ENABLE-SURFACE-WORKFLOW` | — | Low. Audit and timeline evidence is missing at a table door, and each finding's measured bound is that nothing reads it. At the gate the bound is re-measured: if it holds, the item becomes an explicit accepted residual; otherwise it is repaired. Never deferred silently. CRM SPEC-326 and Test 184 close CHAT-2 on CRM's Platinum Primary: the conversation guard stamps `closed_at` and requires a reopen reason, and the table records each transition once on both doors. CRM SPEC-335 adds DOC-11 and QUO-11 (Test 194), whose missing events only the customer and lead timelines would read; their bound is re-measured the same way. |
   | APP-1 | REQUIRED CAPABILITY | engineering | `FIRST-TENANT` | `B6-EXIT` (OD-9, decided AFTER by the owner 2026-11-22), OD-5 (staff login) | No client application exists, while ADR-0014 chose a server-rendered web app as ORVION's client. Treatment: FE-0, the web foundation and the first read-only journey (`delivery-assessment-2026-10-11.md` §7) |
   ```

   g) replace the lines
   ```text
   | OD-1, OD-2, OD-3, OD-5, OD-8 | BUSINESS POLICY | owner | `FIRST-TENANT` | the owner | Launch scope, revenue policy, reporting currency, staff login without email, and salary visibility. Each register row carries the proposed default; `delivery-assessment-2026-10-11.md` carries the analysis. On answers: FIN-0 (the profitability model) and the canon 01/20 amendments |
   | OD-9 | BUSINESS POLICY | owner | `B6-EXIT` | the owner | Whether frontend, finance design, Google access and counsel work run in parallel with Batch 6, and the app's check profile. On approval: FE-0 (the web foundation) as a Draft |
   ```
   with
   ```text
   | OD-1, OD-2, OD-3, OD-5, OD-8 | BUSINESS POLICY | owner | `FIRST-TENANT` | the owner | Launch scope, revenue policy, reporting currency, staff login without email, and salary visibility. Each register row carries the proposed default; `delivery-assessment-2026-10-11.md` carries the analysis. On answers: FIN-0 (the profitability model) and the canon 01/20 amendments |
   ```

   h) immediately after the line
   ```text
   | JE-6 | ACCEPTED RESIDUAL | engineering | `OWN-TRIGGER` | — | Reopened by the first reader of `source_entity_id` |
   ```
   insert
   ```text
   | STAMP-1 | ACCEPTED RESIDUAL | engineering | `OWN-TRIGGER` | — | Reopened by the first function, view, policy or report that decides or reports by a caller-writable creation stamp |
   ```

   i) replace the lines
   ```text
   | GOV-9, GOV-15, GOV-20, GUARD-1, SYNC-1, PAR-7, CTRL-3, DC-27, CTRL-5, CI-2, TEST-4, PERF-2, CTRL-6 | ACCEPTED RESIDUAL | engineering | `OWN-TRIGGER` | — | Control plane and governance, none a Day-1 business function. The control-plane chapter is closed, and each reopens only on its own trigger |
   | OPS-2, RLS-1, API-2, TAX-1, FIN-DOC-1 | TERMINAL IN SUBSTANCE | engineering | `GATE-EVAL` | — | Each carries a terminal verdict outside the settled vocabulary: implemented, merged, delivered, retracted, closed. Re-worded to settled at the first evaluation |
   | N1, DC-5, RC-4, R8, B3, RC-1 | TERMINAL IN SUBSTANCE | engineering | `GATE-EVAL` | — | Still `DESIGN-READY` although shipped migrations implement them in whole or part: `202607049100`, `202607054600`, `202607048900`, `202607048800`, and the subscription lifecycle. Re-verified and settled at the first evaluation |
   ```
   with
   ```text
   | GOV-9, GOV-15, GOV-20, GUARD-1, SYNC-1, PAR-7, CTRL-3, DC-27, CTRL-5, CI-2, TEST-4, PERF-2, CTRL-6 | ACCEPTED RESIDUAL | engineering | `OWN-TRIGGER` | — | Control plane and governance, none a Day-1 business function. The control-plane chapter is closed, and each reopens only on its own trigger |
   ```

   j) replace the lines
   ```text
   | DC-3 | FUTURE-ONLY | engineering | `ENABLE-INVENTORY` | — | Concurrency control before inventory ships |
   | RPC-1 | FUTURE-ONLY | engineering | `B6-EXIT` | EC-2 | Its remaining permissions are re-measured under EC-2 |
   | `booking_item_passengers`, `booking_items`, `financial_accounts` | SURFACE | engineering | `GATE-EVAL` | — | Still `AUDITED-OPEN` for decisions the register has since settled (PAX-5, PAX-6, BOOK-8, BOOK-9, FA-2); re-dispositioned at the first evaluation (EC-8) |
   ```
   with
   ```text
   | DC-3 | FUTURE-ONLY | engineering | `ENABLE-INVENTORY` | — | Concurrency control before inventory ships |
   ```

   k) replace the line
   ```text
   | `documents`, `quotations` | SURFACE | engineering | `GATE-EVAL` | — | `PARTIAL`: door-created event parity (the family of CHAT-2's row) and a caller-writable `created_at` read only by `app.financial_documents`' listing are re-swept at the first evaluation |
   ```
   with
   ```text
   | `documents` | SURFACE | engineering | `ENABLE-SURFACE-WORKFLOW` | DOC-11 | `AUDITED-OPEN` (CRM SPEC-335): the re-sweep registers door event parity as DOC-11; the caller-writable `created_at` is STAMP-1 |
   | `quotations` | SURFACE | engineering | `ENABLE-CRM` | QUO-11 and QUO-12 | `AUDITED-OPEN` (CRM SPEC-335): door event parity and the transition stamps are QUO-11 (`ENABLE-SURFACE-WORKFLOW`), the unrecorded reassignment is QUO-12, and the caller-writable stamps are STAMP-1 |
   | `conversations` | SURFACE | engineering | `ENABLE-CRM` | CHAT-5 | `AUDITED-OPEN` (CRM SPEC-338): both doors keep their recorded transitions; `app.advance_conversation` refuses an invalid move with the wrong message, CHAT-5 |
   ```

   l) replace the line
   ```text
   | `bookings`, `branches`, `conversations`, `journal_entries`, `journal_entry_lines`, `lead_interactions`, `marketing_campaigns`, `otp_challenges`, `passengers`, `payment_allocations`, `payments`, `refunds`, `subscription_payment_proofs`, `suppliers`, `tasks`, `totp_enrollments`, `users` | SURFACE | engineering | `B6-EXIT` | their open findings above | `AUDITED-OPEN`; each closes when its open findings do, and carries no separate class |
   ```
   with
   ```text
   | `bookings`, `booking_items` | SURFACE | engineering | `FIRST-BOOKING` | BOOK-11, BOOK-12 and BOOK-13 | CRM SPEC-319 and Test 182 verify ARCH-2 at entry on CRM's Platinum Primary. SPEC-239 fixes booking entry and issuance, and SPEC-224 fixes PAX-9. BOOK-11 and BOOK-12 remain open at FIRST-BOOKING. CRM SPEC-335 registers BOOK-13 on both tables, so `booking_items` is `AUDITED-OPEN` again. |
   | `branches` | SURFACE | engineering | `ENABLE-SURFACE-WORKFLOW` | STEPUP-1 branch member | CRM SPEC-320 and Tests 58/130 verify the BRANCH-1 repair on CRM's Platinum Primary. BRANCH-2 retains its workflow-enablement gate. |
   | `lead_interactions` | SURFACE | engineering | `ENABLE-CRM` | LI-3 and the existing FIN-9/FIN-11 side-effect decision | Test 108 proves the actor-bound write authority, closure of LI-1/LI-2, and the existing LI-3 behavior. PAX-4's measurement is reconciled. Preserve AUDITED-OPEN until the lifecycle side-effect authority and LI-3 evidence are resolved. |
   | `marketing_campaigns` | SURFACE | engineering | `OWN-TRIGGER` | CAMP-2 | SPEC-222 and test 127 close CAMP-3 and record current entry behavior. CRM SPEC-324 assessed campaign entry under ENTRY-1 without material consequence; CAMP-2 reopens on its own trigger. Recheck CAMP-4 under its existing workflow gate. |
   | `passengers` | SURFACE | engineering | `ENABLE-SURFACE-WORKFLOW` | PAX-8 | CRM SPEC-319 and Test 182 verify ARCH-2 at entry on CRM's Platinum Primary. SPEC-223 and Test 128 close PAX-7. PAX-8 remains open at ENABLE-SURFACE-WORKFLOW. |
   | `journal_entries` | SURFACE | engineering | `OWN-TRIGGER` | JE-6 | SPEC-246 and test 146 close JE-5 and the STEPUP-1 member. JE-2 stays with the line invariant. JE-6 reopens on the first reader of `source_entity_id`. |
   | `otp_challenges`, `totp_enrollments` | SURFACE | engineering | `OWN-TRIGGER` | AUTH-1 | OTP-1's repair and OTP-2's derivation are recorded. Test 106 and SPEC-259/test 151 cover the present boundary. Retire before the first client-facing authentication build or first reference. |
   | `subscription_payment_proofs` | SURFACE | engineering | `OWN-TRIGGER` | SPP-3 | SPEC-260/261 and tests 152/153 settle the current integrity and concurrency work. A trusted reviewer identity is still owed before the second platform operator or an authenticated platform console. |
   | `users` | SURFACE | engineering | `OWN-TRIGGER` | USR-4 | SPEC-206 and test 118 cover membership authority and tenant isolation. USR-4 reopens when a policy, function or application first reads the flag. |
   ```

   The resulting file's Git blob is 9daac0e7c21aa73445b3e0c99412621177e5db05.

37. Check whether `reports/master/MASTER_GAP_REGISTER.md` contains `ORVION SPEC-319, the Founder twin of CRM SPEC-316 to SPEC-340`; if so record Already Applied when its Git blob is dd98cac1e8f387c3638373745d53ddcfc65d6c02, and otherwise stop and report. Otherwise make exactly these 26 edits (the register entries of CRM SPEC-316 to SPEC-340, Founder deployment pending), each matched once, and change nothing else:

   a) replace the line
   ```text
   Last updated: 2026-11-18 (**Slice 59 — `nationalities`, `countries` and `currencies` selected live at Exposure 0, coverage 4, 10 and 22, in one contract (P1's grouping, 2026-11-18), with `languages` by the owner's policy of 2026-11-18.** **REF-2** (Low) is new and fixed. A deactivated nationality, country, currency or language was accepted on new business and on a change of that field, because the foreign keys check existence only. ORVION SPEC-318, the twin of CRM SPEC-315, refuses a deactivated value on a create or a change of that field while every row already holding it keeps it and stays editable. No other row changed.)
   ```
   with
   ```text
   Last updated: 2026-11-25 (**ORVION SPEC-319, the Founder twin of CRM SPEC-316 to SPEC-340, the Batch 6 exit catch-up.** It adopts by identity the seven CRM migrations `20261119054533` to `20261122100000` and Tests 182–198 (CRM `dd19c80` equals ORVION `367cdf3` on the migrations, tests and functions trees), and with them CRM's register changes to R8/B3, N1, DC-5, RC-1, RC-4, RPC-1, FIN-9, FIN-11, CHAT-2, FIN-DOC-1, PAY-4, PAY-5, DOC-11, CHAT-5, CUST-17, APP-1, OD-9, JE-2, BOOK-13, PAX-4, ARCH-2, ENTRY-1, QUO-11, QUO-12, RFD-3, BRANCH-1, BRANCH-2, STEPUP-1, STAMP-1, and the CRM SPEC-331 re-wordings of OPS-2, RLS-1, API-2 and TAX-1; each row says what changed and cites its CRM contract, and every commit it names is CRM's. The rows whose CRM fix carries one of the seven migrations name their Founder Secondary state under SPEC-319. GOV-27 and CRM's accepted CTRL-19 residual are CRM records and are not twinned; ORVION's CTRL-19 stays as it was. No other row changed.)

   Previously: 2026-11-18 (**Slice 59 — `nationalities`, `countries` and `currencies` selected live at Exposure 0, coverage 4, 10 and 22, in one contract (P1's grouping, 2026-11-18), with `languages` by the owner's policy of 2026-11-18.** **REF-2** (Low) is new and fixed. A deactivated nationality, country, currency or language was accepted on new business and on a change of that field, because the foreign keys check existence only. ORVION SPEC-318, the twin of CRM SPEC-315, refuses a deactivated value on a create or a change of that field while every row already holding it keeps it and stays editable. No other row changed.)
   ```

   b) replace the line
   ```text
   | R8/B3 | business-key UNIQUE constraints (5 keys) | integrity | High | R | 0 | M | 🔒 | DESIGN-READY | audit B3 | 07-09 | 07-11 |
   ```
   with
   ```text
   | R8/B3 | business-key UNIQUE constraints (5 keys) | integrity | High | R | 0 | M | 🔒 | ✅RESOLVED 2026-11-23 (CRM SPEC-332, Test 188: migration `202607048800`; the five keys are validated, each refuses a duplicate inside its owner and admits it in another tenant; superseded: DESIGN-READY) | audit B3 | 07-09 | 07-11 |
   ```

   c) replace the lines
   ```text
   | N1 | event_type registry validated by record_event (amend ADR-0006) | event-contract | High | R | 1 | A | 🔒 | DESIGN-READY | synthesis | 07-09 | 07-11 |
   | INV-1..4 | derived-primitive invariants (amend ADR-0021) | finance | High | R | 0 | A | 🔒 | DESIGN-READY | synthesis | 07-09 | 07-11 |
   | DC-5 | document binary storage + Storage RLS | security | High | R | 2 | A | 🛡 | DESIGN-READY | cert-2026-07 | 07-10 | 07-11 |
   ```
   with
   ```text
   | N1 | event_type registry validated by record_event (amend ADR-0006) | event-contract | High | R | 1 | A | 🔒 | ✅RESOLVED 2026-11-23 (CRM SPEC-332, Test 188: migration `202607049100`, current body `20261114160000`; `app.record_event` refuses an unregistered event type and severity; superseded: DESIGN-READY) | synthesis | 07-09 | 07-11 |
   | INV-1..4 | derived-primitive invariants (amend ADR-0021) | finance | High | R | 0 | A | 🔒 | DESIGN-READY | synthesis | 07-09 | 07-11 |
   | DC-5 | document binary storage + Storage RLS | security | High | R | 2 | A | 🛡 | ✅IMPLEMENTED (migration `202607054600`; Tests 48, 49, 97, 116, 175; settled 2026-11-23 by CRM SPEC-332; superseded: DESIGN-READY) | cert-2026-07 | 07-10 | 07-11 |
   ```

   d) replace the lines
   ```text
   | RC-1 | Subscription/billing lifecycle + entitlement enforcement | saas | Medium | R | 5 | A | ➕ | DESIGN-READY | design-evolution/audit D | 07-09 | 07-11 |
   | RC-2 | Notification engine (templates/preferences/routing) | engagement | Medium | R | 5 | A | ➕ | DESIGN-READY | design-evolution | 07-09 | 07-11 |
   | RC-4 | Reporting/Dashboards read-model layer (0 views today) | reporting | Medium | R | 5 | A | ➕ | DESIGN-READY | design-evolution/ARB | 07-09 | 07-11 |
   ```
   with
   ```text
   | RC-1 | Subscription/billing lifecycle + entitlement enforcement | saas | Medium | R | 5 | A | ➕ | ✅IMPLEMENTED (Tests 42, 66, 148; settled 2026-11-23 by CRM SPEC-332; superseded: DESIGN-READY) | design-evolution/audit D | 07-09 | 07-11 |
   | RC-2 | Notification engine (templates/preferences/routing) | engagement | Medium | R | 5 | A | ➕ | DESIGN-READY | design-evolution | 07-09 | 07-11 |
   | RC-4 | Reporting/Dashboards read-model layer (0 views today) | reporting | Medium | R | 5 | A | ➕ | ✅IMPLEMENTED Tier A (migration `202607048900`, the `reporting` security-invoker views; Tests 23, 45, 53; Tier B aggregates only where measured cost earns them, ADR-0022; settled 2026-11-23 by CRM SPEC-332; superseded: DESIGN-READY) | design-evolution/ARB | 07-09 | 07-11 |
   ```

   e) replace the line
   ```text
   | RPC-1 | **35 of 72 tables had no RPC write path.** For those, a direct PostgREST write was the ONLY path - no app.authorize(), no state-machine validation, no event. **Decisive evidence this is an implementation gap, not a design choice: 37 of 69 seeded permissions were enforced NOWHERE**, mapping exactly onto the entities missing RPCs. **No business decision blocks it** - canon 26 already defines every affected lifecycle | architecture | High | R | 5+ | A | + | **OPEN - programme underway, 10 of 37 permissions closed (37 to 27).** SPEC-131 delivered Tasks; SPEC-132 delivered the customer-service domain (SEND_MESSAGE, CLOSE_CONVERSATION, ESCALATE_CONVERSATION, CREATE_COMPLAINT, RESOLVE_COMPLAINT, CREATE_SERVICE_REQUEST, RESOLVE_SERVICE_REQUEST) plus the end-to-end employee walkthrough test. **Remaining 27, all determinable from canon except those in RPC-2:** exchange rates, subscriptions, approval review, lead reassignment, booking-item costing, platform admin, the API-scope pair, the system-set task_overdue sweep, and 14 VIEW_* read-scope permissions which belong to AUDIT-3 rather than to a write path | engineering: continue entity by entity, following SPEC-131/132 | health-gate-2-2026-08-21 | 08-21 | 08-21 |
   ```
   with
   ```text
   | RPC-1 | **35 of 72 tables had no RPC write path.** For those, a direct PostgREST write was the ONLY path - no app.authorize(), no state-machine validation, no event. **Decisive evidence this is an implementation gap, not a design choice: 37 of 69 seeded permissions were enforced NOWHERE**, mapping exactly onto the entities missing RPCs. **No business decision blocks it** - canon 26 already defines every affected lifecycle | architecture | High | R | 5+ | A | + | **RESOLVED 2026-11-22 (CRM SPEC-330, Test 186).** Re-measured at `790aa96` (277 migrations) and identically on CRM's Platinum Primary: 73 of the 77 permissions are named by an `app`/`public` function or an RLS predicate. The four that are not carry their reason: MANAGE_ROLES gates nothing because no member role may write `roles`, `permissions` or `role_permissions`; ACCESS_API_FULL, ACCESS_API_READ_ONLY and VIEW_ADVANCED_DASHBOARDS name surfaces that do not exist and no role holds them. Test 186 pins the four as a set equality, so a fifth unenforced permission fails it and closing one must remove it. **Superseded text:** OPEN - programme underway, 10 of 37 permissions closed (37 to 27). SPEC-131 delivered Tasks; SPEC-132 delivered the customer-service domain (SEND_MESSAGE, CLOSE_CONVERSATION, ESCALATE_CONVERSATION, CREATE_COMPLAINT, RESOLVE_COMPLAINT, CREATE_SERVICE_REQUEST, RESOLVE_SERVICE_REQUEST) plus the end-to-end employee walkthrough test. **Remaining 27, all determinable from canon except those in RPC-2:** exchange rates, subscriptions, approval review, lead reassignment, booking-item costing, platform admin, the API-scope pair, the system-set task_overdue sweep, and 14 VIEW_* read-scope permissions which belong to AUDIT-3 rather than to a write path | resolved; a new unenforced permission fails Test 186 | health-gate-2-2026-08-21 | 08-21 | 11-22 |
   ```

   f) replace the line
   ```text
   | FIN-9 | A **transaction-capable** direct-DML client (psql, `service_role`) can still create a VALID balanced journal entry with **no `journal_entry_created` event**, because the event is emitted by the RPC and not by the table | audit completeness | Low | R | 6 | A | 📋 | **OPEN — recorded, not papered over.** Post-FIN-8 the entry must at least be *correct*, and the PostgREST table path can no longer create one at all (one request, one transaction, cannot hold an entry plus two balanced lines), so the residue is a transactional client only. **Not fixed by adding an event trigger**: it would double-emit for every RPC-created entry, and a duplicated audit record is its own defect. The honest fix is either an idempotent emitter or moving emission to the table — both are wider than this package. Same class as **EVT-2**. **2026-10-08 (SPEC-245):** re-measured. No signed-in door writes journal lines at all now, so the residue is exactly the platform writer (`postgres`, and `service_role` through Primary's default privileges), which owns every table; still not papered over with a second emitter | engineering: where journal event emission belongs | api-3-2026-08-29 | 08-29 | 08-29 |
   ```
   with
   ```text
   | FIN-9 | A **transaction-capable** direct-DML client (psql, `service_role`) can still create a VALID balanced journal entry with **no `journal_entry_created` event**, because the event is emitted by the RPC and not by the table | audit completeness | Low | R | 6 | A | 📋 | **OPEN — recorded, not papered over.** Post-FIN-8 the entry must at least be *correct*, and the PostgREST table path can no longer create one at all (one request, one transaction, cannot hold an entry plus two balanced lines), so the residue is a transactional client only. **Not fixed by adding an event trigger**: it would double-emit for every RPC-created entry, and a duplicated audit record is its own defect. The honest fix is either an idempotent emitter or moving emission to the table — both are wider than this package. Same class as **EVT-2**. **2026-10-08 (SPEC-245):** re-measured. No signed-in door writes journal lines at all now, so the residue is exactly the platform writer (`postgres`, and `service_role` through Primary's default privileges), which owns every table; still not papered over with a second emitter. **2026-11-21 (CRM SPEC-326):** FIN-11's half of the shared question is answered (invoice status and its event now belong to the allocation table); the journal-event half stays OPEN with JE-2 and DC-11 | engineering: where journal event emission belongs | api-3-2026-08-29; CRM SPEC-326-a-refund-a-conversation-and-a-settlement-are-recorded-on-every-door | 08-29 | 11-21 |
   ```

   g) replace the line
   ```text
   | FIN-11 | Direct-DML allocation leaves `invoices.status_code` unchanged (the RPC advances it to `partially_paid`/`paid`) and emits no event | audit / side-effect completeness | Low | R | 6 | A | 📋 | **OPEN — recorded, not assumed away.** Same shape as **FIN-9** one table over. Post-FIN-10 the resulting state must at least be *correct* (allocations can no longer exceed the total), so the residue is a missing side effect rather than a wrong number. Deliberately not fixed with a status trigger here: `record_payment` already sets the status, so a trigger would have to be idempotent with it — and FIN-9 asks the identical question about journal events. The two want ONE answer about where side effects belong, not two bolted-on producers | engineering: where invoice status and event emission belong | api-3-sec1-2026-08-29 | 08-29 | 08-29 |
   ```
   with
   ```text
   | FIN-11 | Direct-DML allocation leaves `invoices.status_code` unchanged (the RPC advances it to `partially_paid`/`paid`) and emits no event | audit / side-effect completeness | Low | R | 6 | A | ✅ | **FIXED 2026-11-21 (CRM SPEC-326, `20261121110000`).** Answered by moving the side effect to the table, as this row asked for ONE answer: the invoice status and its event now come from `payment_allocations_settle_invoice` (`app.derive_invoice_payment_status`) on every allocation, and `app.record_payment` no longer sets the status itself, so the two producers are one and nothing is recorded twice (PAY-5). Both pgTAP runs, including Test 184, verified the derivation on both doors. FIN-9's journal-event half is not part of this answer. CRM's Platinum Primary readback confirmed the exact migration, the enabled bindings and ten-surface parity. History: **OPEN — recorded, not assumed away.** Same shape as **FIN-9** one table over. Post-FIN-10 the resulting state must at least be *correct* (allocations can no longer exceed the total), so the residue is a missing side effect rather than a wrong number. Deliberately not fixed with a status trigger here: `record_payment` already sets the status, so a trigger would have to be idempotent with it — and FIN-9 asks the identical question about journal events. The two want ONE answer about where side effects belong, not two bolted-on producers **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. | engineering: where invoice status and event emission belong | api-3-sec1-2026-08-29; CRM SPEC-326-a-refund-a-conversation-and-a-settlement-are-recorded-on-every-door | 08-29 | 11-21 |
   ```

   h) replace the line
   ```text
   | CHAT-2 | **Authorized direct conversation lifecycle UPDATE can omit transition evidence and retain stale closure time** | CRM lifecycle / observability | Low | R | 6 | — | 📋 | **OPEN — independently reproduced during Slice 19, not absorbed by SPEC-220.** A SEND_MESSAGE employee used the RPC to start, assign and close a conversation: three events and server-stamped `closed_at`. A legal direct UPDATE then reopened `closed → open` with no reason and no transition event, leaving `closed_at` nonnull; the customer timeline contained no reopen, and a new message could be sent. The status-transition guard accepted the legal edge but does not own event/reason/time parity. Trigger: a separate conversation lifecycle authority design that preserves `app.advance_conversation(p_reason)` semantics on both doors. No owner decision is pending. | — | SPEC-220-conversation-creation-parity | 09-24 | 09-24 |
   ```
   with
   ```text
   | CHAT-2 | **Authorized direct conversation lifecycle UPDATE can omit transition evidence and retain stale closure time** | CRM lifecycle / observability | Low | R | 6 | — | ✅ | **FIXED 2026-11-21 (CRM SPEC-326, `20261121110000`).** A conversation move is now governed and recorded on both doors: `conversations_guard_transition` (`app.guard_conversation_transition`, BEFORE, signed-in callers) stamps `closed_at` from the server as `app.advance_conversation` does, clears it on a reopen and refuses a reopen without a reason (canon 26, 27), and `conversations_emit_transition` (`app.emit_conversation_transition`) records each move once with the reason passed through `app.transition_reason`; `app.advance_conversation` dropped its own `record_event`. Both pgTAP runs, including Test 184, verified the server-stamped and unforgeable `closed_at`, the refused reasonless reopen on both doors, and each move recorded once, reopen and escalation as warnings. CRM's Platinum Primary readback confirmed the exact migration, the enabled bindings and ten-surface parity. History: **OPEN — independently reproduced during Slice 19, not absorbed by SPEC-220.** A SEND_MESSAGE employee used the RPC to start, assign and close a conversation: three events and server-stamped `closed_at`. A legal direct UPDATE then reopened `closed → open` with no reason and no transition event, leaving `closed_at` nonnull; the customer timeline contained no reopen, and a new message could be sent. The status-transition guard accepted the legal edge but does not own event/reason/time parity. Trigger: a separate conversation lifecycle authority design that preserves `app.advance_conversation(p_reason)` semantics on both doors. No owner decision is pending. **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. | — | SPEC-220-conversation-creation-parity; CRM SPEC-326-a-refund-a-conversation-and-a-settlement-are-recorded-on-every-door | 09-24 | 11-21 |
   ```

   i) replace the line
   ```text
   | FIN-DOC-1 | New evidence sharpening **SPEC-154-B**, not a new decision | privacy scope | — | — | 6 | — | 📋 | **EVIDENCE ONLY — attaches to the existing SPEC-154-B owner decision and creates no new one.** Measured with a discriminating control: a `finance_manager` holding VIEW_FINANCIAL_DOCUMENTS reads the tenant's financial documents through `app.financial_documents()`; an `employee` is refused **42501** by that endpoint. Through the TABLE, that same employee reads a **NON-confidential** invoice document (RLS branch: not confidential AND has links AND the caller lacks VIEW_FINANCIAL_DOCUMENTS) while a **CONFIDENTIAL** one is correctly invisible. So the confidentiality boundary IS enforced and the endpoint's guard is not a privacy boundary for non-confidential financial documents. **What this adds to SPEC-154-B:** the decision is not only "who may hold the permission" but "should the RLS branch exclude financial TYPES regardless of the confidential flag" — and canon 28 states BOTH *"assigned employee may view financial documents directly related to their lead/booking"* AND *"financial documents require stricter visibility"*, which the binary permission cannot express. Deliberately NOT fixed: forcing `is_confidential` on financial types would satisfy the second rule by destroying the first. Pinned by assertion 20 of `81_task_supplier_financial_test.sql` so the boundary cannot move silently. **Also recorded:** `202607048200`'s header claims *"RLS on documents is tenant-wide"* — measurably false since the SPEC-139/DOC packages tightened it; the endpoint is stricter than its own comment says, so the staleness is harmless but noted (a comment is a claim) | **CLOSED by SPEC-154-B, 2026-08-31** | api-3-closure-2026-08-30 | 08-30 | 08-31 |
   ```
   with
   ```text
   | FIN-DOC-1 | New evidence sharpening **SPEC-154-B**, not a new decision | privacy scope | — | — | 6 | — | 📋 | **CLOSED 2026-11-22 (CRM SPEC-331 re-wording): the evidence attached to SPEC-154-B, which the owner decided and engineering fixed on 2026-08-31.** Superseded text: **EVIDENCE ONLY — attaches to the existing SPEC-154-B owner decision and creates no new one.** Measured with a discriminating control: a `finance_manager` holding VIEW_FINANCIAL_DOCUMENTS reads the tenant's financial documents through `app.financial_documents()`; an `employee` is refused **42501** by that endpoint. Through the TABLE, that same employee reads a **NON-confidential** invoice document (RLS branch: not confidential AND has links AND the caller lacks VIEW_FINANCIAL_DOCUMENTS) while a **CONFIDENTIAL** one is correctly invisible. So the confidentiality boundary IS enforced and the endpoint's guard is not a privacy boundary for non-confidential financial documents. **What this adds to SPEC-154-B:** the decision is not only "who may hold the permission" but "should the RLS branch exclude financial TYPES regardless of the confidential flag" — and canon 28 states BOTH *"assigned employee may view financial documents directly related to their lead/booking"* AND *"financial documents require stricter visibility"*, which the binary permission cannot express. Deliberately NOT fixed: forcing `is_confidential` on financial types would satisfy the second rule by destroying the first. Pinned by assertion 20 of `81_task_supplier_financial_test.sql` so the boundary cannot move silently. **Also recorded:** `202607048200`'s header claims *"RLS on documents is tenant-wide"* — measurably false since the SPEC-139/DOC packages tightened it; the endpoint is stricter than its own comment says, so the staleness is harmless but noted (a comment is a claim) | **CLOSED by SPEC-154-B, 2026-08-31** | api-3-closure-2026-08-30 | 08-30 | 08-31 |
   ```

   j) replace the lines
   ```text
   | PAY-4 | **The payments table accepts a zero-value row coded as a customer refund** | financial integrity / input | Low | R | 6 | — | 📋 | **OPEN — independently reproduced during Slice 20; not absorbed by SPEC-221.** A direct INSERT persisted a `payments` row with amount 0 and `payment_direction_code` `customer_refund`. Row-shape and direction-catalog integrity are a different authority from PAY-2's capability charging and are not changed by it. Reopening trigger: a payment entry-shape rule derived from the sanctioned RPCs and the refund model. No owner decision is pending. | — | SPEC-221-payment-write-capability-parity | 09-25 | 09-25 |
   | PAY-5 | **A payment allocated at the table door leaves its invoice's status where it was** | financial state / two doors | Low | R | 6 | — | 📋 | **OPEN — reproduced with SPEC-238, deliberately not repaired.** MEASURED on the local stack at `73e571c`, in a rolled-back transaction: an owner holding RECORD_PAYMENT paid an issued 5000 EGP invoice in full by a direct `payments` INSERT and a 5000 `payment_allocations` INSERT; the invoice stayed `issued`, and no `invoice_paid` event was recorded, while `app.record_payment` on a sibling invoice moved it to `paid` and recorded it. Cause: `app.record_payment` **derives** `paid` / `partially_paid` from the allocated total, and nothing does so for an allocation made at the door. Consequence: balances are right (they derive from allocations, FIN-10), but anything that reads `invoices.status_code` -- an overdue or collections view, the invoice timeline -- reports a paid invoice as unpaid. Not the conversion pipeline: `payment_received` comes from the payment (PAY-3). Not FIN-7, which is which status MOVES are legal on the direct door, nor PAY-1, which is the invoice state an allocation may target. **Latent:** Primary holds 0 invoices. Reopening trigger: the invoice-status enforcement package FIN-7 schedules, which must derive the status on both doors as the RPC does. No owner decision is pending. | — | SPEC-238-payment-is-recorded-on-every-door | 09-28 | 09-28 |
   ```
   with
   ```text
   | PAY-4 | **The payments table accepts a zero-value row coded as a customer refund** | financial integrity / input | Low | R | 6 | — | ✅ | **FIXED 2026-11-22 (CRM SPEC-327, `20261122100000`).** A payment row now carries value on every door: `payments_amount_positive_check` (`amount > 0`) refuses a zero or negative amount at the table door exactly as `app.record_payment` and `app.record_supplier_payment` already did, and a refund remains a `refunds` row written by `app.record_refund`. `payments_amount_nonneg_check` is kept. Both pgTAP runs, including Test 185, verified the zero `customer_refund` INSERT refused with 23514 and a positive payment accepted. CRM's Platinum Primary readback confirmed the exact migration, the validated constraint, zero payment rows and ten-surface parity. History: **OPEN — independently reproduced during Slice 20; not absorbed by SPEC-221.** A direct INSERT persisted a `payments` row with amount 0 and `payment_direction_code` `customer_refund`. Row-shape and direction-catalog integrity are a different authority from PAY-2's capability charging and are not changed by it. Reopening trigger: a payment entry-shape rule derived from the sanctioned RPCs and the refund model. No owner decision is pending. **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. | — | SPEC-221-payment-write-capability-parity; CRM SPEC-327-a-ledger-entry-balances-in-one-currency-and-a-payment-carries-value | 09-25 | 11-22 |
   | PAY-5 | **A payment allocated at the table door leaves its invoice's status where it was** | financial state / two doors | Low | R | 6 | — | ✅ | **FIXED 2026-11-21 (CRM SPEC-326, `20261121110000`).** An allocation now settles its invoice on both doors: `payment_allocations_settle_invoice` (`app.derive_invoice_payment_status`, sorted after `payment_allocations_emit_created`) sums the invoice's allocations under the per-invoice advisory lock, sets `paid` or `partially_paid` and records `invoice_paid` or `invoice_partially_paid` once, naming the payment; nothing walks a settlement back and a zero allocation settles nothing. `app.record_payment` dropped its own derivation and event, so it settles through the same trigger. Both pgTAP runs, including Test 184, verified the partial and full settlement at the table door, the lowered allocation that never walks back, the single settlement event on either door and its order after the allocation. CRM's Platinum Primary readback confirmed the exact migration, the enabled bindings and ten-surface parity. History: **OPEN — reproduced with SPEC-238, deliberately not repaired.** MEASURED on the local stack at `73e571c`, in a rolled-back transaction: an owner holding RECORD_PAYMENT paid an issued 5000 EGP invoice in full by a direct `payments` INSERT and a 5000 `payment_allocations` INSERT; the invoice stayed `issued`, and no `invoice_paid` event was recorded, while `app.record_payment` on a sibling invoice moved it to `paid` and recorded it. Cause: `app.record_payment` **derives** `paid` / `partially_paid` from the allocated total, and nothing does so for an allocation made at the door. Consequence: balances are right (they derive from allocations, FIN-10), but anything that reads `invoices.status_code` -- an overdue or collections view, the invoice timeline -- reports a paid invoice as unpaid. Not the conversion pipeline: `payment_received` comes from the payment (PAY-3). Not FIN-7, which is which status MOVES are legal on the direct door, nor PAY-1, which is the invoice state an allocation may target. **Latent:** Primary holds 0 invoices. Reopening trigger: the invoice-status enforcement package FIN-7 schedules, which must derive the status on both doors as the RPC does. No owner decision is pending. **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. | — | SPEC-238-payment-is-recorded-on-every-door; CRM SPEC-326-a-refund-a-conversation-and-a-settlement-are-recorded-on-every-door | 09-28 | 11-21 |
   ```

   k) immediately after the line
   ```text
   | DOC-10 | **A link moved by UPDATE took a document off the record it belonged to and was recorded nowhere** | audit completeness · observability | Low | R | 6 | M | ✅ | **✅ FIXED 2026-11-12 (SPEC-309, `20261112150000`), DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-309; the fresh Founder ledger, functions and structure equal local.** **MEASURED** in CRM at `789e056` (CRM SPEC-306), and identical at `d5224e3` here (the same migrations and tests blob for blob, and the same pre-change structure): an `employee` moved the ticket link of their booking to another of their bookings; the tenant's events did not move and `app.derive_created_by` keeps the creator, so nothing showed who took the ticket off the booking. A new link is attributed by its own row (`created_by` derived and immutable); `app.upload_document` records `document_linked` for its link. **Repaired:** `app.guard_document_link_readable` (BEFORE INSERT OR UPDATE, SECURITY INVOKER, session writes only) refuses a link whose document the writer cannot already read under the `documents` policy; `app.emit_document_link_move` (AFTER UPDATE, SECURITY DEFINER) records a moved link as `document_linked` with the link id and the previous and current document and target. `165_a_document_is_linked_only_by_someone_who_can_read_it_test.sql` pins both. An update that moves nothing and a session-less write record nothing. | — | SPEC-309-a-document-is-linked-only-by-someone-who-can-read-it | 11-12 | 11-12 |
   ```
   insert
   ```text
   | DOC-11 | **A document created at the table door records no `document_uploaded`, while `app.upload_document` records the same act** | audit completeness · observability | Low | R | 6 | — | 📋 | **OPEN — found by the CRM SPEC-335 re-sweep of `documents` and `quotations` (the gate's `GATE-EVAL` row), deliberately not repaired.** MEASURED at `676df3e`, rolled back: an `employee` at aal2 uploaded a document through `app.upload_document`, which recorded `document_uploaded` and `document_linked`, and inserted another at the table door, which recorded no event. Its creator is server-derived and it carries no file until a recorded version is added. **Low, and the bound is measured:** the only readers of these events are `app.customer_timeline` and `app.lead_timeline`, so the loss is timeline completeness. CAMP-4's and BRANCH-2's shape; it joins their registry row at `ENABLE-SURFACE-WORKFLOW`. The door's caller-writable `created_at` is STAMP-1. `194_door_evidence_and_sale_dates_open_pins_test.sql` pins it OPEN and fails when it is repaired. | — | CRM SPEC-335-the-exit-evidence-gaps-are-pinned-and-the-re-sweep-registered | 11-23 | 11-23 |
   ```

   l) replace the lines
   ```text
   | CUST-15 | **A customer note was rewritten, blanked, moved to another customer or back-dated by someone other than its author, unrecorded, and still named its author** | CRM customers · integrity · attribution | Medium | R | 6 | M | ✅ | **✅ FIXED 2026-11-16 (SPEC-313, `20261116120000`), DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-313; the fresh Founder ledger, functions and structure equal local.** **MEASURED** in CRM at `1a760bb` (CRM SPEC-310), and identical at `f4a797c` here (the same migrations and tests blob for blob, and the same pre-change structure): an `employee` holding CREATE_CUSTOMER, at `aal1` as that role allows, rewrote the `owner`'s note on a customer, blanked it, moved it to a second customer and back-dated its `created_at` to 2019, each by UPDATE at the table door; another employee rewrote the first one's note. Each note still named its original author (`app.derive_created_by` keeps `created_by`), and nothing was recorded: the tenant's events did not move. `app.add_customer_note` only ever inserts a note and no function rewrites one, yet `authenticated` held table-level UPDATE (pin, confidential and archive are column updates the product needs) and the table had no rewrite guard. Severity is Medium by CUST-13's precedent: an unrecorded rewrite of what a named person wrote about a customer, which the next reader trusts under that name. **Repaired:** one BEFORE INSERT OR UPDATE trigger, `app.guard_customer_note_integrity` (SECURITY INVOKER, empty `search_path`, in `app.guard_quotation_integrity`'s shape; the definer paths owned by `postgres`, the merge among them, pass through). The text is trimmed as `app.add_customer_note` trims it, so a blank note is refused by the existing NOT NULL; a note keeps its customer (23514); only its author may change its text (42501), so the name on a note is the name of the person who wrote what it says; and `created_at` is kept on UPDATE, as `app.derive_created_by` keeps `created_by`. Every grant and policy is unchanged: pinning, marking one's own note confidential and archiving stay open to whoever could do them before. `173_a_customer_note_stays_with_its_customer_and_its_author_test.sql` pins it. | — | SPEC-313-a-customer-note-stays-with-its-customer-and-its-author | 11-16 | 11-16 |
   | CUST-16 | **A blank customer note was accepted at the table door, which the RPC refuses** | CRM customers · data integrity | Low | R | 6 | M | ✅ | **✅ FIXED 2026-11-16 (SPEC-313, `20261116120000`), DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-313; the fresh Founder ledger, functions and structure equal local.** **MEASURED** in CRM at `1a760bb` (CRM SPEC-310), and identical at `f4a797c` here (the same migrations and tests blob for blob, and the same pre-change structure): the same employee inserted a note of three spaces at the table door and it was stored, while `app.add_customer_note` trims the text and refuses an empty one. Severity is Low by CHAT-4's precedent: a blank text at a direct door; no function reads a note's text. **Repaired:** one BEFORE INSERT OR UPDATE trigger, `app.guard_customer_note_integrity` (SECURITY INVOKER, empty `search_path`, in `app.guard_quotation_integrity`'s shape; the definer paths owned by `postgres`, the merge among them, pass through). The text is trimmed as `app.add_customer_note` trims it, so a blank note is refused by the existing NOT NULL; a note keeps its customer (23514); only its author may change its text (42501), so the name on a note is the name of the person who wrote what it says; and `created_at` is kept on UPDATE, as `app.derive_created_by` keeps `created_by`. Every grant and policy is unchanged: pinning, marking one's own note confidential and archiving stay open to whoever could do them before. `173_a_customer_note_stays_with_its_customer_and_its_author_test.sql` pins it. | — | SPEC-313-a-customer-note-stays-with-its-customer-and-its-author | 11-16 | 11-16 |
   ```
   with
   ```text
   | CHAT-5 | **An invalid conversation transition is refused as `permission denied: <NULL>` instead of its own message** | CRM conversations · observability | Low | R | 6 | — | 📋 | **OPEN — found by the CRM SPEC-338 refusal probe, deliberately not repaired (no migration in CRM SPEC-338).** MEASURED at `b4562e7` on the local stack (277 migrations): `app.advance_conversation` on an `open` conversation with `p_to_status = 'closed'` raises 42501 `permission denied: <NULL>` from `app.authorize`, and its own `invalid conversation transition open -> closed` is never raised. Cause: the transition lookup is a `select ... into v_matched` over the allowed moves, and with no matching row it leaves `v_matched` NULL, so `if not v_matched` is skipped and `app.authorize(NULL)` refuses. **Low**, fail-closed: no invalid move succeeds; staff see a permission error for a move that does not exist. `196_each_function_refusal_is_reached_by_a_call_test.sql` pins it OPEN; the repair (`if v_matched is not true`) fails that assertion and updates it with this row. | — | CRM SPEC-338-every-unseen-refusal-is-reached-by-a-test | 11-24 | 11-24 |
   | CUST-15 | **A customer note was rewritten, blanked, moved to another customer or back-dated by someone other than its author, unrecorded, and still named its author** | CRM customers · integrity · attribution | Medium | R | 6 | M | ✅ | **✅ FIXED 2026-11-16 (SPEC-313, `20261116120000`), DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-313; the fresh Founder ledger, functions and structure equal local.** **MEASURED** in CRM at `1a760bb` (CRM SPEC-310), and identical at `f4a797c` here (the same migrations and tests blob for blob, and the same pre-change structure): an `employee` holding CREATE_CUSTOMER, at `aal1` as that role allows, rewrote the `owner`'s note on a customer, blanked it, moved it to a second customer and back-dated its `created_at` to 2019, each by UPDATE at the table door; another employee rewrote the first one's note. Each note still named its original author (`app.derive_created_by` keeps `created_by`), and nothing was recorded: the tenant's events did not move. `app.add_customer_note` only ever inserts a note and no function rewrites one, yet `authenticated` held table-level UPDATE (pin, confidential and archive are column updates the product needs) and the table had no rewrite guard. Severity is Medium by CUST-13's precedent: an unrecorded rewrite of what a named person wrote about a customer, which the next reader trusts under that name. **Repaired:** one BEFORE INSERT OR UPDATE trigger, `app.guard_customer_note_integrity` (SECURITY INVOKER, empty `search_path`, in `app.guard_quotation_integrity`'s shape; the definer paths owned by `postgres`, the merge among them, pass through). The text is trimmed as `app.add_customer_note` trims it, so a blank note is refused by the existing NOT NULL; a note keeps its customer (23514); only its author may change its text (42501), so the name on a note is the name of the person who wrote what it says; and `created_at` is kept on UPDATE, as `app.derive_created_by` keeps `created_by`. Every grant and policy is unchanged: pinning, marking one's own note confidential and archiving stay open to whoever could do them before. `173_a_customer_note_stays_with_its_customer_and_its_author_test.sql` pins it. | — | SPEC-313-a-customer-note-stays-with-its-customer-and-its-author | 11-16 | 11-16 |
   | CUST-16 | **A blank customer note was accepted at the table door, which the RPC refuses** | CRM customers · data integrity | Low | R | 6 | M | ✅ | **✅ FIXED 2026-11-16 (SPEC-313, `20261116120000`), DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-313; the fresh Founder ledger, functions and structure equal local.** **MEASURED** in CRM at `1a760bb` (CRM SPEC-310), and identical at `f4a797c` here (the same migrations and tests blob for blob, and the same pre-change structure): the same employee inserted a note of three spaces at the table door and it was stored, while `app.add_customer_note` trims the text and refuses an empty one. Severity is Low by CHAT-4's precedent: a blank text at a direct door; no function reads a note's text. **Repaired:** one BEFORE INSERT OR UPDATE trigger, `app.guard_customer_note_integrity` (SECURITY INVOKER, empty `search_path`, in `app.guard_quotation_integrity`'s shape; the definer paths owned by `postgres`, the merge among them, pass through). The text is trimmed as `app.add_customer_note` trims it, so a blank note is refused by the existing NOT NULL; a note keeps its customer (23514); only its author may change its text (42501), so the name on a note is the name of the person who wrote what it says; and `created_at` is kept on UPDATE, as `app.derive_created_by` keeps `created_by`. Every grant and policy is unchanged: pinning, marking one's own note confidential and archiving stay open to whoever could do them before. `173_a_customer_note_stays_with_its_customer_and_its_author_test.sql` pins it. | — | SPEC-313-a-customer-note-stays-with-its-customer-and-its-author | 11-16 | 11-16 |
   | CUST-17 | **Registration rejected valid phone and social communication preferences** | CRM customers · data integrity | Low | R | 6 | M | ✅ | **✅ FIXED 2026-11-19 (CRM SPEC-316, `20261119054533`), DEPLOYED in CRM to Platinum Primary under the exact-SHA owner Gate 2.** Registration checked the contact-detail catalog and refused valid preferences. The registration RPC now uses Canon 25's `preferred_contact_method_code` catalog. The existing customer table guard continues to enforce that family on edits. Test 79 confirms email, phone, social, WhatsApp and clearing the preference, and rejection of invalid detail and unknown codes. CRM's Platinum Primary readback matched local, with unchanged function permissions and customer rows. **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. | — | CRM SPEC-316-use-customer-preference-catalog-on-registration | 11-19 | 11-19 |
   ```

   m) replace the line
   ```text
   | APP-1 | **No client application exists, so no employee can use ORVION** | product delivery / frontend | High | R | — | — | 📋 | **OPEN — a required capability, not a defect.** ADR-0014 chose a server-rendered web app as ORVION's client, and every Day-1 journey in canon 01 needs one; the repository holds no application code. Measured 2026-10-11 (`delivery-assessment-2026-10-11.md` §1). Recorded by SPEC-269 so the missing build has a home, a boundary (`FIRST-TENANT`) and a treatment (FE-0). Its sequencing waits on OD-9, and its login on OD-5. | — | delivery-assessment-2026-10-11 | 10-12 | 10-12 |
   ```
   with
   ```text
   | APP-1 | **No client application exists, so no employee can use ORVION** | product delivery / frontend | High | R | — | — | 📋 | **OPEN — a required capability, not a defect.** ADR-0014 chose a server-rendered web app as ORVION's client, and every Day-1 journey in canon 01 needs one; the repository holds no application code. Measured 2026-10-11 (`delivery-assessment-2026-10-11.md` §1). Recorded by SPEC-269 so the missing build has a home, a boundary (`FIRST-TENANT`) and a treatment (FE-0). Its sequencing follows OD-9, decided AFTER by the owner on 2026-11-22: FE-0 begins only after `B6-EXIT`. Its login waits on OD-5. | — | delivery-assessment-2026-10-11 | 10-12 | 10-12 |
   ```

   n) replace the line
   ```text
   | OD-9 | **Work in parallel with Batch 6, and the app's check profile** | sequencing / governance | High | R | — | — | 📋 | **OPEN — PROPOSED 2026-10-11, not decided.** The owner's order runs Batch 6 first; Batch 6 still has 37 of 78 surfaces without a recorded disposition. The proposal is that the frontend foundation and read-only journeys against the local stack, the finance design, and counsel and policy work run beside it, since none needs a migration. The UI holds no authority, so it would get end-to-end, accessibility and not-permitted tests instead of the per-table adversarial process. The n8n workflow stays after Batch 6, as the owner ordered. Google access is now SPEC-265's script route (D4, owner-decided). Analysis: `delivery-assessment-2026-10-11.md` §5–§7, D9. Recorded by SPEC-269. | owner: proposed default — approve the parallel streams and the proportionate app profile; on approval FE-0 is drafted | delivery-assessment-2026-10-11 | 10-12 | 10-12 |
   ```
   with
   ```text
   | OD-9 | **Work in parallel with Batch 6, and the app's check profile** | sequencing / governance | High | R | — | — | 📋 | **✅ DECIDED BY THE OWNER 2026-11-22: AFTER.** Frontend work, FE-0 included, begins only after Batch 6 meets its exit criteria (`B6-EXIT`, EC-1..EC-11). The app's check profile is carried to FE-0's own Draft as an engineering recommendation for that Draft's Gate 1. Recorded by CRM SPEC-329 from the owner's words of 2026-11-22. **Superseded text:** OPEN — PROPOSED 2026-10-11, not decided. The owner's order runs Batch 6 first; Batch 6 still has 37 of 78 surfaces without a recorded disposition. The proposal is that the frontend foundation and read-only journeys against the local stack, the finance design, and counsel and policy work run beside it, since none needs a migration. The UI holds no authority, so it would get end-to-end, accessibility and not-permitted tests instead of the per-table adversarial process. The n8n workflow stays after Batch 6, as the owner ordered. Google access is now SPEC-265's script route (D4, owner-decided). Analysis: `delivery-assessment-2026-10-11.md` §5–§7, D9. Recorded by SPEC-269. | owner: sequencing of frontend work against Batch 6 | delivery-assessment-2026-10-11 | 10-12 | 11-22 |
   ```

   o) replace the line
   ```text
   | JE-2 | **A journal entry can "balance" across two different currencies** | financial integrity | Medium | R | 6 | — | 📋 | **RECORDED, DELIBERATELY NOT FIXED — it is not derivable and fixing it would foreclose a Batch-4 decision.** REPRODUCED: a 100 **USD** debit and a 100 **EGP** credit, two lines, survived the deferred `enforce_journal_entry_balanced` and committed — the trigger sums `debit_amount` and `credit_amount` across currencies and compares the totals. **Both doors behave identically**, so this is NOT an ADR-0024 two-door gap: `app.create_journal_entry` sums the same way and validates no currency at all. **Why it is not fixed here:** canon 31 lists `currency_code` on the line and states only the debit/credit exclusivity rule; canon defines no single-currency-per-entry rule, and **DC-10 (opening balances) and DC-11 (realized FX) are deferred to Batch 4**. The two standard answers — one currency per entry, or transaction-currency plus a base-currency translation column — are an accounting-model choice, and adding a same-currency CHECK now would foreclose the second, which is the model DC-11 anticipates. `AGENTS.md §6`: never invent business policy to make an implementation convenient. **Trigger:** Batch 4's finance-depth package, where DC-11 is decided | engineering: decide with DC-11 | session-2026-09-01-finance-periphery | 09-01 | 09-01 |
   ```
   with
   ```text
   | JE-2 | **A journal entry can "balance" across two different currencies** | financial integrity | Medium | R | 6 | — | 🛡 | **CONTAINED FAIL-CLOSED 2026-11-22 (CRM SPEC-327, `20261122100000`); DC-11 still decides the translation model.** The deferred `app.enforce_journal_entry_balanced` now refuses, with 23514 and before the balance rules, an entry whose lines carry more than one currency, so the RPC and the direct DML door both refuse the 100 USD / 100 EGP entry. It is a branch in a replaceable function, not a structural CHECK, so the transaction-currency plus functional-currency model (IAS 21 paragraph 21) stays open: DC-11 replaces the branch with a functional-currency balance. Both pgTAP runs, including Test 185 and the updated Test 145, verified the refusal on both doors and a single-currency entry still accepted. CRM's Platinum Primary readback confirmed the exact function body (prosrc md5 `809c5bbc84937777d9160a173d741e77`), zero journal rows and ten-surface parity. **Remaining trigger:** DC-11 in the finance-depth package. History: **RECORDED, DELIBERATELY NOT FIXED — it is not derivable and fixing it would foreclose a Batch-4 decision.** REPRODUCED: a 100 **USD** debit and a 100 **EGP** credit, two lines, survived the deferred `enforce_journal_entry_balanced` and committed — the trigger sums `debit_amount` and `credit_amount` across currencies and compares the totals. **Both doors behave identically**, so this is NOT an ADR-0024 two-door gap: `app.create_journal_entry` sums the same way and validates no currency at all. **Why it is not fixed here:** canon 31 lists `currency_code` on the line and states only the debit/credit exclusivity rule; canon defines no single-currency-per-entry rule, and **DC-10 (opening balances) and DC-11 (realized FX) are deferred to Batch 4**. The two standard answers — one currency per entry, or transaction-currency plus a base-currency translation column — are an accounting-model choice, and adding a same-currency CHECK now would foreclose the second, which is the model DC-11 anticipates. `AGENTS.md §6`: never invent business policy to make an implementation convenient. **Trigger:** Batch 4's finance-depth package, where DC-11 is decided **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. | engineering: decide with DC-11 | session-2026-09-01-finance-periphery; CRM SPEC-327-a-ledger-entry-balances-in-one-currency-and-a-payment-carries-value | 09-01 | 11-22 |
   ```

   p) immediately after the line
   ```text
   | BOOK-12 | **A booking's customer can be rebound before issuance, so the negative-balance override judges a customer who owes nothing** | authorization · financial risk | Medium | R | 6 | — | 📋 | **OPEN — found by SPEC-239's adversarial pass, on the sanctioned path as well; deliberately not repaired.** MEASURED at `2496591`, rolled back: a `branch_manager` holding ISSUE_BOOKING with a per-user deny on ALLOW_ISSUE_WITH_NEGATIVE_BALANCE, refused issuing a booking whose customer owed 5000 EGP, rebound the booking to another customer of the tenant by direct UPDATE of `customer_id` (1 row) and then issued it through `app.advance_booking` with no refusal and no risk flag. Cause: `app.customer_balance(customer, booking)` counts the invoices of that customer on that booking, the invoice stays with the first customer, and nothing freezes a booking's customer once it is invoiced. SPEC-239 closes the one-statement form (the trigger judges the booking as it stood), not this two-statement one. Not BOOK-10: this is not door parity -- the RPC is equally exposed. Repair needs a business rule on when a booking's customer may change. **Latent:** Primary holds 0 bookings and 0 per-user denies. Reopening trigger: before the first production booking. | — | SPEC-239-issuance-holds-on-every-door | 09-29 | 09-29 |
   ```
   insert
   ```text
   | BOOK-13 | **A member chooses or rewrites the creation date of their own booking and booking item, and the sales reports date the sale by it** | reporting integrity · audit | Low | R | 6 | — | 📋 | **OPEN — found by CRM SPEC-335's measurement of the caller-writable creation stamps, deliberately not repaired.** MEASURED at `676df3e`, rolled back: an `employee` inserted a booking at the table door with `created_at = 2001-01-01`, rewrote it to 2002-02-02, and `public.sales_activity` (`reporting.sales_activity`, `activity_date` = `bookings.created_at::date`) reported the booking on 2002-02-02; the sales owner rewrote a booking item's `created_at` and `public.my_sales_performance` (`sold_at` = `booking_items.created_at`) reported it sold on 2001-01-01. Both views are security-invoker and granted to `authenticated`. **Low:** no money moves and no commission payout exists, but once production bookings exist the reports misstate when a sale happened. **Latent:** Founder Secondary holds 0 bookings. Fix unit: the platform owns both stamps (no caller value at INSERT, frozen at UPDATE). `194_door_evidence_and_sale_dates_open_pins_test.sql` pins it OPEN. Reopening trigger: before the first production booking. | — | CRM SPEC-335-the-exit-evidence-gaps-are-pinned-and-the-re-sweep-registered | 11-23 | 11-23 |
   ```

   q) replace the line
   ```text
   | PAX-4 | **The "twenty ungoverned tables" count measured trigger sites, not governance — the real number is five** | security / authorization · measurement | Medium | O | 6 | — | 📋 | **OPEN — engineering, but SMALLER AND DIFFERENT THAN RECORDED. The count was never wrong; the inference drawn from it was.** As recorded in slice 4: of the tables `authenticated` may INSERT, **20 have no trigger calling `app.authorize` or `app.has_permission` on INSERT**. Slice 6 re-measured what that implies and found **15 of the 20 carry the capability check inside the RLS POLICY instead of a trigger** — `user_permission_grants` is the clearest case, with three triggers (`derive_created_by`, `moddatetime`, `emit_permission_change`) of which **not one authorizes**, while `scope_insert` and `scope_update` both require `app.has_permission('MANAGE_PERMISSIONS')`. PAX-4 counted **enforcement sites of one kind and reported it as governance**: the same MEAS-1 shape as GUARD-CRLF-1 and Check 12, this time in a register row rather than a guard. **The genuinely uncovered set is FIVE, and every one already has a disposition or a registered reason:** `otp_challenges` (**CLOSED by OTP-1**, slice 6), `totp_enrollments` (**OTP-2**, open decision), `trusted_devices` (canon 34 — ownership IS the model, and `58_...` tests that boundary rather than asserting it), `lead_interactions` (already registered BLOCKED/business in `202607056100`) and `campaign_daily_metrics` (already `AUDITED`, slice 1). **The old row also carried a claim slice 6 DISPROVED and which had reached the manifest:** that `otp_challenges` "is a pre-authentication surface and a capability check there would be a category error". The category-error half is right; the pre-authentication half is false — `anon` holds no grant and matches no policy on that table, so an unauthenticated caller could never reach it, and the surface is INTRA-authentication (canon 34 § 7 makes OTP a second factor, presented at `aal1`). **Stays OPEN** because the five-table question is real, and PAX-4 keeps its ID rather than being closed and reopened so the correction stays attached to what it corrects. **Trigger:** each remaining table's own Batch 6 slice. Ceiling pinned at `<= 20` by `10_grant_model_test` assertion 7 and the membership now NAMED by `67_...` assertion 7 and `106_...` assertions 15-16 — a bare count cannot see one table leaving as another joins | — | session-2026-09-07-batch6-slice4-booking-item-passengers | 09-07 | 09-07 |
   ```
   with
   ```text
   | PAX-4 | **The "twenty ungoverned tables" count measured trigger sites, not governance — the real number is five** | security / authorization · measurement | Medium | O | 6 | — | 📋 | **FIXED — authorization measurement reconciled.** Test 106 assertions 15–16 used a historical policy-site sample and excluded FOR ALL policies. The actual INSERT-path proof remains Test 67 SEC-1b. Test 101 establishes the campaign metric write policy, and Test 108 establishes the assigned-handler or permission-plus-MFA guard for lead interactions. OTP-1 removed member writes. The two remaining no-capability surfaces use Canon 34 ownership, with SPEC-259 proving TOTP records do not decide MFA and Test 106 preserving trusted-device coverage. AUTH-1, LI-3 and STEPUP-1 keep their own boundaries. Historical evidence follows: **OPEN — engineering, but SMALLER AND DIFFERENT THAN RECORDED. The count was never wrong; the inference drawn from it was.** As recorded in slice 4: of the tables `authenticated` may INSERT, **20 have no trigger calling `app.authorize` or `app.has_permission` on INSERT**. Slice 6 re-measured what that implies and found **15 of the 20 carry the capability check inside the RLS POLICY instead of a trigger** — `user_permission_grants` is the clearest case, with three triggers (`derive_created_by`, `moddatetime`, `emit_permission_change`) of which **not one authorizes**, while `scope_insert` and `scope_update` both require `app.has_permission('MANAGE_PERMISSIONS')`. PAX-4 counted **enforcement sites of one kind and reported it as governance**: the same MEAS-1 shape as GUARD-CRLF-1 and Check 12, this time in a register row rather than a guard. **The genuinely uncovered set is FIVE, and every one already has a disposition or a registered reason:** `otp_challenges` (**CLOSED by OTP-1**, slice 6), `totp_enrollments` (**OTP-2**, open decision), `trusted_devices` (canon 34 — ownership IS the model, and `58_...` tests that boundary rather than asserting it), `lead_interactions` (already registered BLOCKED/business in `202607056100`) and `campaign_daily_metrics` (already `AUDITED`, slice 1). **The old row also carried a claim slice 6 DISPROVED and which had reached the manifest:** that `otp_challenges` "is a pre-authentication surface and a capability check there would be a category error". The category-error half is right; the pre-authentication half is false — `anon` holds no grant and matches no policy on that table, so an unauthenticated caller could never reach it, and the surface is INTRA-authentication (canon 34 § 7 makes OTP a second factor, presented at `aal1`). **Stays OPEN** because the five-table question is real, and PAX-4 keeps its ID rather than being closed and reopened so the correction stays attached to what it corrects. **Trigger:** each remaining table's own Batch 6 slice. Ceiling pinned at `<= 20` by `10_grant_model_test` assertion 7 and the membership now NAMED by `67_...` assertion 7 and `106_...` assertions 15-16 — a bare count cannot see one table leaving as another joins **2026-11-19 (CRM exit reconciliation):** OTP-2 is resolved by derivation and SPEC-259 shows that TOTP enrollments do not govern MFA. AUTH-1 retirement is trigger-bound. Test 106 assertions 15–16 prove enforcement location. Class closure still requires each remaining authority rationale. | — | session-2026-09-07-batch6-slice4-booking-item-passengers | 09-07 | 11-20 |
   ```

   r) replace the lines
   ```text
   | ARCH-2 | **INVOICE-6 closed the UPDATE door on all thirteen archivable tables; the INSERT door is still open on twelve of them** | authorization / audit integrity | Medium | R | 6 | — | 📋 | **OPEN — engineering, PROVEN 2026-09-09, deliberately NOT fixed in a Slice-11 closure.** `202607052800` created every archive trigger as `before update`, so `app.enforce_archive_authority` — which INVOICE-6 correctly repaired in the ONE function all thirteen tables route through — **never fires on INSERT** for twelve of them. Only `customers` carries `before insert or update`, added by `20260909060754`. REPRODUCED against a clean local reset: an `authenticated` employee proven to hold **no** `ARCHIVE_RECORD` ran a plain `insert into public.customer_notes(... is_archived=true, archive_reason='forged narrative', archived_by=<self>)` and it **succeeded**, producing a row born archived, carrying a narrative nobody was authorized to write and an archiver value the server never stamped. This is **BOOK-1's "test both doors" against an archive guard**: INVOICE-6 measured, repaired and guarded the UPDATE path on thirteen tables, and the INSERT path was never the subject of the measurement, so a `coalesce` that no longer wins on UPDATE is simply not consulted on INSERT. **Not repaired here on purpose** — the one-line fix (widen the twelve triggers to `before insert or update`) changes archive-creation semantics on `bookings`, `invoices`, `documents`, `suppliers`, `passengers`, `leads`, `quotations`, `tasks`, `complaints`, `service_requests`, `booking_items` and `customer_notes`, every one of them a surface outside slice 11, and `AGENTS.md §5b` requires each affected execution path be classified and proven separately rather than by one generic answer. Each table's own Batch 6 slice is where that proof belongs; the finding is recorded so no slice can reach it without an existing row **2026-09-24 (SPEC-216): `documents` closed — refused at entry rather than authorized, because no RPC creates a document archived; eleven tables remain.** **2026-10-10 (SPEC-257): `service_requests` closed the same way — refused at entry for every caller, because no RPC creates a service request archived; the count falls to ten.** **2026-10-11 (SPEC-262): `complaints` closed the same way — refused at entry for every caller, because no RPC creates a complaint archived; the count falls to nine.** | — | session-2026-09-09-slice11-closure | 09-09 | 10-11 |
   | INVOICE-7 | **One text column could stop an agency raising invoices for the rest of the year** | availability / input validation | Medium | R | 6 | `202607062000` | ✅ | **✅ FIXED 2026-09-08 — `202607062000`, Batch 6 slice 10.** `app.create_invoice` allocates the next number with `max(split_part(invoice_number, '-', 3)::integer)` over `invoice_number like 'INV-<year>-%'`. `like` admits anything after the second dash. MEASURED: one invoice renamed `INV-2026-abcd` made **every subsequent `app.create_invoice` call in that tenant and year** fail with `invalid input syntax for type integer: "abcd"` — a tenant-wide denial of service reachable by any actor who could see a single invoice. Check-then-act over attacker-controlled text. INVOICE-2 closes the door the attack came through; the parser is made TOTAL separately, by matching the shape the generator actually produces (`~ '^INV-<year>-[0-9]+$'`), so a malformed number arriving by direct INSERT or a future data import is skipped rather than cast. **A CHECK constraint on the column was considered and rejected:** it would also outlaw the `INV-ALLOC-1` / `INV-V96-3` numbers nine existing fixtures use and no production path produces, turning a one-line repair into a nine-file rewrite for no behaviour the regex does not already give. Guard: `110_...` 19-20, which plants the malformed row and then requires the sequence to carry on correctly past it | — | session-2026-09-08-batch6-slice10-invoices | 09-08 | 09-08 |
   | ENTRY-1 | **The state machine governs every move except the first, on ten more tables** | business invariant / state | Medium | R | 6 | — | 📋 | **OPEN — ENGINEERING, not an owner decision, and recorded because the SECOND instance made it a class rather than a coincidence.** `app.enforce_status_transition` is `before update` and has no entry arm, so on every table it guards a row can be INSERTed directly into any status the catalog accepts, including a terminal one. LEAD-2 was the first instance (`202607061900`: a lead born `won`), INVOICE-4 the second (`202607062000`: an invoice born `paid`, or `voided` with no reason and no timestamp). MEASURED 2026-09-08, not estimated: the trigger is attached to **twelve** tables — `booking_items`, `bookings`, `complaints`, `conversations`, `documents`, `invoices`, `leads`, `marketing_campaigns`, `quotations`, `refunds`, `service_requests`, `tasks` — and exactly **two** of them carry an entry-state guard, both added by the Batch-6 slice that reached them. **Ten tables have a governed transition machine and an ungoverned entry.** **Deliberately not fixed generically here.** The legal entry state is not expressible in `app.status_transitions` as it stands — the table records `from_status -> to_status` and has no notion of a first state — and each table's entry state has to be read off its own creating RPC, which is what a slice does. Inventing a shared entry rule from two samples would be inventing policy for ten tables nobody has read yet. **Trigger:** closed per surface as Batch 6 reaches each table (the LEAD-2 / INVOICE-4 shape, one guard each); OR, if a third or fourth slice finds itself writing the same guard, promote it by giving `app.status_transitions` an entry-state representation and letting the shared trigger enforce it on INSERT — at which point the per-table guards collapse into it. Whichever way it goes, **the class is now recorded and cannot be rediscovered as if new** **2026-09-24 (SPEC-214): `quotations` closed by QUO-5, the third instance; nine tables remain. Promotion into `app.status_transitions` was weighed and declined — it would change INSERT behaviour on nine surfaces no slice has read, and here the entry rule is one arm of a guard three other findings needed.** **2026-09-24 (SPEC-216): `documents` closed, the fourth instance, by one arm of a door-parity guard; eight tables remain. Promotion still declined for SPEC-214's reason.** **2026-09-24 (SPEC-217): `refunds` closed, the fifth instance, by the refund-local entry guard; seven tables remain. No generic entry rule was introduced.** **2026-09-24 (SPEC-220): `conversations` closed, the sixth instance, by a conversation-local guard requiring `open` and null `closed_at` for both signed-in and session-less creation; six tables remain. CHAT-1 owns the accompanying creator and event discrepancy. No generic entry rule was introduced.** **2026-09-29 (SPEC-239): `bookings` closed, the seventh instance, by the entry arm of `app.enforce_booking_lifecycle`, which requires `draft` for signed-in creation, LEAD-2's session-less exemption; five tables remain. No generic entry rule was introduced.** **2026-10-10 (SPEC-257): `service_requests` closed, the eighth instance, by a service-request-local guard requiring `requested` and no resolution time for every caller; four tables remain. No generic entry rule was introduced.** **2026-10-11 (SPEC-262): `complaints` closed, the ninth instance, by a complaint-local guard requiring `new` and no resolution time, closure time or resolution note for every caller; three tables remain. No generic entry rule was introduced.** | — | session-2026-09-08-batch6-slice10-invoices | 09-08 | 10-11 |
   ```
   with
   ```text
   | ARCH-2 | **INVOICE-6 closed the UPDATE path on thirteen tables; this finding tracks the remaining archive-at-entry gaps** | authorization / audit integrity | Medium | R | 6 | — | ✅ | **FIXED 2026-11-21 (CRM SPEC-324, `20261121100000`).** Archive-at-entry authority now holds on every member: `leads`, `invoices`, `quotations` and `booking_items` fire `before insert or update` on the unchanged `app.enforce_archive_authority`. Both pgTAP runs, including Test 183, verified the refusals, the server-stamped archiver and time, and the authorized path. CRM's Platinum Primary readback confirmed the exact migration, the enabled bindings and ten-surface parity. History: **OPEN — engineering, PROVEN 2026-09-09, deliberately NOT fixed in a Slice-11 closure.** `202607052800` created every archive trigger as `before update`, so `app.enforce_archive_authority` — which INVOICE-6 correctly repaired in the ONE function all thirteen tables route through — **never fires on INSERT** for twelve of them. Only `customers` carries `before insert or update`, added by `20260909060754`. REPRODUCED against a clean local reset: an `authenticated` employee proven to hold **no** `ARCHIVE_RECORD` ran a plain `insert into public.customer_notes(... is_archived=true, archive_reason='forged narrative', archived_by=<self>)` and it **succeeded**, producing a row born archived, carrying a narrative nobody was authorized to write and an archiver value the server never stamped. This is **BOOK-1's "test both doors" against an archive guard**: INVOICE-6 measured, repaired and guarded the UPDATE path on thirteen tables, and the INSERT path was never the subject of the measurement, so a `coalesce` that no longer wins on UPDATE is simply not consulted on INSERT. **Not repaired here on purpose** — the one-line fix (widen the twelve triggers to `before insert or update`) changes archive-creation semantics on `bookings`, `invoices`, `documents`, `suppliers`, `passengers`, `leads`, `quotations`, `tasks`, `complaints`, `service_requests`, `booking_items` and `customer_notes`, every one of them a surface outside slice 11, and `AGENTS.md §5b` requires each affected execution path be classified and proven separately rather than by one generic answer. Each table's own Batch 6 slice is where that proof belongs; the finding is recorded so no slice can reach it without an existing row **2026-09-24 (SPEC-216): `documents` closed — refused at entry rather than authorized, because no RPC creates a document archived; eleven tables remain.** **2026-10-10 (SPEC-257): `service_requests` closed the same way — refused at entry for every caller, because no RPC creates a service request archived; the count falls to ten.** **2026-10-11 (SPEC-262): `complaints` closed the same way — refused at entry for every caller, because no RPC creates a complaint archived; the count falls to nine.** **2026-11-19 (CRM exit reconciliation):** SPEC-310 records archived-at-entry customer notes as an explicit position. SPEC-215 keeps the supplier evidence open and SPEC-230 test 134 documents the open task member. The older counts are historical snapshots pending current member-level confirmation. **2026-11-19 (CRM SPEC-319):** Test 182 and migration `20261119203357` close archive-at-entry authority and actor/time attribution on `bookings`, `passengers`, `suppliers` and `tasks`, and reject caller-stamped metadata on an active `customers` insert. CRM's Platinum Primary and local ledger and ten-surface parity were verified. The finding remains OPEN for the unresolved `leads`, `invoices`, `quotations` and `booking_items` members. Prior member decisions stand. **2026-11-21 (CRM SPEC-324):** Test 183 proves an employee without ARCHIVE_RECORD cannot create any of the four members archived, an active invoice cannot claim a forged archiver, an archive holder may create an archived lead or invoice with a reason, and the archiver and time come from the server, not the forged and backdated input. No member remains open. **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. | — | session-2026-09-09-slice11-closure, CRM SPEC-324-entry-and-step-up-hold-at-the-table-door | 09-09 | 11-21 |
   | INVOICE-7 | **One text column could stop an agency raising invoices for the rest of the year** | availability / input validation | Medium | R | 6 | `202607062000` | ✅ | **✅ FIXED 2026-09-08 — `202607062000`, Batch 6 slice 10.** `app.create_invoice` allocates the next number with `max(split_part(invoice_number, '-', 3)::integer)` over `invoice_number like 'INV-<year>-%'`. `like` admits anything after the second dash. MEASURED: one invoice renamed `INV-2026-abcd` made **every subsequent `app.create_invoice` call in that tenant and year** fail with `invalid input syntax for type integer: "abcd"` — a tenant-wide denial of service reachable by any actor who could see a single invoice. Check-then-act over attacker-controlled text. INVOICE-2 closes the door the attack came through; the parser is made TOTAL separately, by matching the shape the generator actually produces (`~ '^INV-<year>-[0-9]+$'`), so a malformed number arriving by direct INSERT or a future data import is skipped rather than cast. **A CHECK constraint on the column was considered and rejected:** it would also outlaw the `INV-ALLOC-1` / `INV-V96-3` numbers nine existing fixtures use and no production path produces, turning a one-line repair into a nine-file rewrite for no behaviour the regex does not already give. Guard: `110_...` 19-20, which plants the malformed row and then requires the sequence to carry on correctly past it | — | session-2026-09-08-batch6-slice10-invoices | 09-08 | 09-08 |
   | ENTRY-1 | **The state machine governs every move except the first, on ten more tables** | business invariant / state | Medium | R | 6 | — | ✅ | **FIXED 2026-11-21 (CRM SPEC-324, `20261121100000`) for its last member; every recorded member is now closed or assessed.** History: **OPEN — ENGINEERING, not an owner decision, and recorded because the SECOND instance made it a class rather than a coincidence.** `app.enforce_status_transition` is `before update` and has no entry arm, so on every table it guards a row can be INSERTed directly into any status the catalog accepts, including a terminal one. LEAD-2 was the first instance (`202607061900`: a lead born `won`), INVOICE-4 the second (`202607062000`: an invoice born `paid`, or `voided` with no reason and no timestamp). MEASURED 2026-09-08, not estimated: the trigger is attached to **twelve** tables — `booking_items`, `bookings`, `complaints`, `conversations`, `documents`, `invoices`, `leads`, `marketing_campaigns`, `quotations`, `refunds`, `service_requests`, `tasks` — and exactly **two** of them carry an entry-state guard, both added by the Batch-6 slice that reached them. **Ten tables have a governed transition machine and an ungoverned entry.** **Deliberately not fixed generically here.** The legal entry state is not expressible in `app.status_transitions` as it stands — the table records `from_status -> to_status` and has no notion of a first state — and each table's entry state has to be read off its own creating RPC, which is what a slice does. Inventing a shared entry rule from two samples would be inventing policy for ten tables nobody has read yet. **Trigger:** closed per surface as Batch 6 reaches each table (the LEAD-2 / INVOICE-4 shape, one guard each); OR, if a third or fourth slice finds itself writing the same guard, promote it by giving `app.status_transitions` an entry-state representation and letting the shared trigger enforce it on INSERT — at which point the per-table guards collapse into it. Whichever way it goes, **the class is now recorded and cannot be rediscovered as if new** **2026-09-24 (SPEC-214): `quotations` closed by QUO-5, the third instance; nine tables remain. Promotion into `app.status_transitions` was weighed and declined — it would change INSERT behaviour on nine surfaces no slice has read, and here the entry rule is one arm of a guard three other findings needed.** **2026-09-24 (SPEC-216): `documents` closed, the fourth instance, by one arm of a door-parity guard; eight tables remain. Promotion still declined for SPEC-214's reason.** **2026-09-24 (SPEC-217): `refunds` closed, the fifth instance, by the refund-local entry guard; seven tables remain. No generic entry rule was introduced.** **2026-09-24 (SPEC-220): `conversations` closed, the sixth instance, by a conversation-local guard requiring `open` and null `closed_at` for both signed-in and session-less creation; six tables remain. CHAT-1 owns the accompanying creator and event discrepancy. No generic entry rule was introduced.** **2026-09-29 (SPEC-239): `bookings` closed, the seventh instance, by the entry arm of `app.enforce_booking_lifecycle`, which requires `draft` for signed-in creation, LEAD-2's session-less exemption; five tables remain. No generic entry rule was introduced.** **2026-10-10 (SPEC-257): `service_requests` closed, the eighth instance, by a service-request-local guard requiring `requested` and no resolution time for every caller; four tables remain. No generic entry rule was introduced.** **2026-10-11 (SPEC-262): `complaints` closed, the ninth instance, by a complaint-local guard requiring `new` and no resolution time, closure time or resolution note for every caller; three tables remain. No generic entry rule was introduced.** **2026-11-19 (CRM exit reconciliation):** The three unmatched names in the recorded series are booking items, marketing campaigns and tasks. SPEC-222 test 127 and SPEC-230 test 134 preserve the latter two observations. Review booking-item creation and tests 74/105 for its expected initial state and consequence. The approved per-surface method still governs. **2026-11-19 (CRM SPEC-318):** The task creation member is fixed on CRM's Platinum Primary by the INSERT guard in migration `20261119112137`. Test 134 proves refusal of both terminal entry states, ordinary open creation and absence of rejected rows. The ENTRY-1 class remains open for its other members. **2026-11-21 (CRM SPEC-324):** The booking-item member is fixed by `app.guard_booking_item_entry_state` (trigger `booking_items_guard_entry_state`, `before insert`): a signed-in creation opens at `draft` with no lifecycle stamp, as `app.create_booking_item` does, and session-less platform paths stay exempt as SPEC-239 rules for bookings. Test 183 proves the refused entry states and stamps, the RPC door still creating the draft item and the session-less exemption. The campaign member was assessed without material consequence and follows CAMP-2 to its own trigger. No residual entry assessment is due at B6-EXIT. **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. | — | session-2026-09-08-batch6-slice10-invoices, CRM SPEC-324-entry-and-step-up-hold-at-the-table-door | 09-08 | 11-21 |
   ```

   s) immediately after the line
   ```text
   | QUO-10 | **A line could leave a SENT quotation, or reach one while it was being sent, and the emptied quotation was accepted at 0** | financial integrity · state · concurrency | Medium | R | 6 | M | ✅ | **✅ FIXED 2026-10-10 (SPEC-258, `20261010140000`), DEPLOYED to Primary under separate exact-byte owner authorization; the fresh Primary ledger, function surface and all ten structural surfaces match local.** **The rule** is QUO-2's: a sent quotation's lines are the customer's offer; `app.add_quotation_item` locks the quotation `for update` before refusing any status but `draft`, and no sanctioned writer moves a line. **MEASURED** at `44c09d8`: after a quotation was sent through `app.advance_quotation` with its one 1,000 line, a direct UPDATE of the line's `quotation_id` moved it to a draft; the sent quotation held 0 lines and 0 against its `quotation_sent` of 1,000, and was then accepted at 0. The editable-parent guard judged only the line's NEW quotation, and the denied employee of QUO-9 moved a line the same way. In two concurrent sessions a direct INSERT read the quotation as `draft` while a send held its lock, waited, and committed onto the sent quotation (1,300 against 1,000); the RPC under the same timing re-read `sent` and refused. **Found while attacking the repair:** the guard runs as its definer before RLS's WITH CHECK, and answered an employee naming another tenant's SENT quotation with that quotation's state (23514) where RLS would have refused. **REPAIRED** in the same guard, for every caller: `quotation_id` cannot change (23514), and the quotation is read `for update`, for a signed-in caller only within its own tenant, so the race waits and is refused and a foreign quotation is refused by RLS (42501). Test 150 pins it (assertions 19–29 and 31); mutants M1, M5 and M6 are killed, M5 also in two sessions. | — | SPEC-258-a-quotation-line-stays-on-its-quotation-at-its-own-price | 10-10 | 10-10 |
   ```
   insert
   ```text
   | QUO-11 | **A quotation created or moved to `sent` or `accepted` at the table door records no event and leaves the transition stamps empty** | audit completeness · observability | Low | R | 6 | — | 📋 | **OPEN — found by the CRM SPEC-335 re-sweep of `documents` and `quotations` (the gate's `GATE-EVAL` row), deliberately not repaired.** MEASURED at `676df3e`, rolled back: `app.create_quotation` recorded one `quotation_created` and a table-door create by the same member recorded none; a `branch_manager`'s door transitions to `sent` and then `accepted` recorded no event and left `sent_at` and `accepted_at` null. SPEC-214's axes (1) and (4). **Low, and the bound is measured:** the only readers of these events are `app.customer_timeline` and `app.lead_timeline`, and nothing reads `sent_at`, `accepted_at` or `rejected_at`; the caller-writable stamps are STAMP-1. It joins CAMP-4's registry row at `ENABLE-SURFACE-WORKFLOW`. `194_door_evidence_and_sale_dates_open_pins_test.sql` pins it OPEN. | — | CRM SPEC-335-the-exit-evidence-gaps-are-pinned-and-the-re-sweep-registered | 11-23 | 11-23 |
   | QUO-12 | **A quotation's number, lead and owner can be reassigned at the table door with no event, and no RPC offers the change** | authorization · audit completeness | Low | R | 6 | — | 📋 | **OPEN — found by the CRM SPEC-335 re-sweep of `documents` and `quotations` (the gate's `GATE-EVAL` row), deliberately not repaired.** MEASURED at `676df3e`, rolled back: the assigned `employee` renumbered a quotation created through the RPC and moved it to another lead, and a `branch_manager` reassigned its `owner_user_id`, each at the table door with no event. SPEC-214's axis (2). The reassignment moves timeline attribution, visibility, `app.is_document_responsible`, the displayed key and the event payload's `lead_id`; no money moves and the conversions do not read it. **Low.** BOOK-9's rule applies: a reassignment needs a permission, a reason and an event. `194_door_evidence_and_sale_dates_open_pins_test.sql` pins it OPEN; a repair that refuses the door write fails its `lives_ok` step instead. | engineering: which fields may change after creation and under which permission, by BOOK-9's rule, escalating to the owner only if canon cannot answer | CRM SPEC-335-the-exit-evidence-gaps-are-pinned-and-the-re-sweep-registered | 11-23 | 11-23 |
   ```

   t) replace the lines
   ```text
   | RFD-3 | **Legal direct refund lifecycle writes still change customer balance without emitting the refund events the RPC emits** | financial audit / observability | Medium | R | 6 | — | 📋 | **OPEN — independently reproduced during Slice 17; not absorbed by SPEC-217.** Finance at `aal2` created a requested refund by direct INSERT, advanced requested → approved → completed by legal direct UPDATEs, and `app.customer_balance` rose 11 EGP while `public.events` contained zero events for the refund; the RPC path emitted three. After SPEC-217, the direct path is authorized and server-stamped, but remains silent. An event trigger plus removal of RPC emissions would need to preserve `app.advance_refund(p_reason)` and avoid duplicates; that is a distinct event-authority design, not needed to close RFD-1, RFD-2 or ENTRY-1. Reopening trigger: the next refund event-authority work or a consumer that requires direct-door refund event parity. No owner decision is pending. |  | SPEC-217-refund-door-integrity | 09-24 | 09-24 |
   | BRANCH-1 | **An `aal1` owner or ceo creates, renames, re-slugs and deactivates branches through the table that `app.create_branch` refuses them** | security · authorization | Low | R | 6 | — | 📋 | **OPEN — reproduced in Batch 6 Slice 24 and recorded, deliberately not repaired (SPEC-226 is record-only).** MEASURED in rolled-back local transactions: an `owner` with `app.has_permission('MANAGE_BRANCHES')` true and `app.mfa_satisfied()` false was refused `42501 multi-factor authentication required for this role` by `app.create_branch` and, through the existing `app.guard_write_capability`, by the child `branch_business_hours`; the same actor then directly INSERTed a branch (1 row) and set the tenant's Main branch to `name = 'Hijacked'`, a new `slug` and `is_active = false` (1 row, persisted). Cause: the RPC charges `app.authorize` (permission AND step-up), while `scope_insert` and `scope_update` call `app.has_permission` (permission only) and no trigger on `branches` charges step-up. MANAGE_BRANCHES is held only by `owner` and `ceo`, both step-up-bound by `app.requires_mfa`. **Low, and the bound is measured:** no function, view or policy reads `branches.name`, `slug`, `is_active`, `branch_type`, `primary_phone`, `address` or `created_at`; a branch is consumed only by its id, as the target of 22 composite `(tenant_id, id)` foreign keys, in `app.visible_branch_ids` and in `events.audit_read`'s existence test; and a new branch confers nothing, because every write that would place work in it is guarded on its own table. The existing mechanism, if this is repaired, is CAMP-3's: one `guard_write_capability` map arm and a BEFORE INSERT OR UPDATE attachment. **Priority rises when** a function, view, policy or application path first reads a branch attribute other than its id and tenant, or treats a branch's existence as a ceiling or an authority. A member of STEPUP-1. `130_branch_door_audit_test.sql` assertions 6-8 pin it OPEN and fail when it is repaired. | — | SPEC-226-branch-door-audit-record | 09-27 | 09-27 |
   | BRANCH-2 | **A branch created at the table door records no `branch_created`, while `app.create_branch` records the same act** | audit completeness · observability | Low | R | 6 | — | 📋 | **OPEN — reproduced in Batch 6 Slice 24 and recorded, deliberately not repaired.** MEASURED in rolled-back local transactions: three branches were created in one tenant, one by the owner's `app.create_branch` at `aal2`, one by direct INSERT at `aal2` and one by direct INSERT at `aal1` (BRANCH-1), and the tenant gained exactly one `branch_created` event. `branches` has no creator column, so for a branch created at the table door nothing records who created it. **Low, and the bound is measured:** the only function that names `branch_created` is its producer and nothing consumes the event, so the loss is audit and timeline completeness. CAMP-4's shape on another surface; SUP-5's single AFTER INSERT producer is the existing mechanism if this is repaired. **Not part of this finding:** the same direct INSERT also stored a caller-supplied `created_at = 2001-01-01`. That is the caller-writable `created_at` that SPEC-216 recorded as "a question that stands on every table with such a column" and SPEC-218 left unregistered on `customer_contact_methods`: no function in `app` or `public` assigns `new.created_at` on any table, SUP-5's repair left `suppliers.created_at` caller-writable, and nothing reads `branches.created_at`, so repairing this finding would not change it. `130_branch_door_audit_test.sql` assertion 19 pins it OPEN and fails when it is repaired. | — | SPEC-226-branch-door-audit-record | 09-27 | 09-27 |
   | STEPUP-1 | **A class CANDIDATE, found by structural evidence: eleven tables carry a direct permission-only write path with no step-up anywhere in their trigger chain** | security · authorization · class | Unclassified | R | 6 | — | 📋 | **UNPROVEN — structural candidate class, recorded, deliberately not acted on (Batch 6 Slice 24).** Not a reproduced class defect. Criterion, read from the local catalog at `b6a0714`: `authenticated` holds INSERT or UPDATE; the INSERT or UPDATE policy charges `app.has_permission(K)` for a K held only by roles that `app.requires_mfa` binds to step-up; and no trigger on the table, at any timing, calls `app.authorize` or `app.mfa_satisfied` directly or through one level of `app` helper. Eleven tables meet it: `branches`, `campaign_daily_metrics`, `catalog_values`, `chart_of_accounts`, `departments`, `document_retention_policies`, `exchange_rate_adjustments`, `exchange_rates`, `journal_entries`, `journal_entry_lines`, `tenants`. `user_branch_assignments` and `user_permission_grants` meet it too and belong to USR-3. `user_role_assignments` does NOT: its AFTER trigger `app.emit_role_change` charges `app.authorize('MANAGE_USERS')`, which a first, BEFORE-only reading missed and a rolled-back probe corrected. **Only `branches` is a reproduced and consequence-classified defect (BRANCH-1, Low).** **`journal_entry_lines` was audited in Batch 6 Slice 32 (SPEC-245): an `aal1` finance manager rewrote posted lines the RPC refuses it to post, and that member is closed by JE-3's repair; it no longer meets the criterion, because `authenticated` holds no INSERT or UPDATE on it. `chart_of_accounts` was audited in Batch 6 Slice 42 (SPEC-278): its member was reproduced as COA-2 and is closed, and it no longer meets the criterion, because `app.guard_chart_account` charges `app.authorize`. `journal_entries` still meets it (JE-5).** The same probe saw an `aal1` owner's rename land on `departments` and on `tenants`. `departments`' consequence is not classified, so it remains a candidate and is not an audit. **`tenants` was audited in Batch 6 Slice 26 (SPEC-228) and its consequence is classified: none material.** An `aal1` `owner` or `ceo` does write every tenant-profile column, but nothing reads any of them except `name`, shown only to the tenant's own members; no canon marks a tenant-profile edit as step-up, platform-only or sensitive; and the other MANAGE_TENANT_SETTINGS doors that charge `app.authorize` guard distinct actions (licence redemption, payment-proof upload, legal hold, document versions and links, holidays), not a second door to the same action. So `tenants` still meets the criterion, is not a defect, and does not raise this class above UNPROVEN. The other eight are structural candidates only; the finance tables among them are where a consequence, if reproduced, would most likely be material. A member becomes a defect only when it is individually reproduced adversarially and its consequence is classified, and no member gains a disposition or counts toward Batch 6 coverage by being listed here. `campaign_daily_metrics` and `exchange_rate_adjustments` are recorded `AUDITED`, and step-up was not asked on either. **Ceiling:** the criterion reads function text, so it can miss step-up charged through deeper indirection and it cannot see consequence (MEAS-1). **Trigger to revisit:** the Batch 6 slice of any listed table, or the first reproduced consequence on a candidate. **2026-10-08 (SPEC-246): `journal_entries` no longer meets the criterion, because `authenticated` holds no INSERT or UPDATE on it; its member consequence, JE-5, is closed by that revoke.** **2026-11-11 (SPEC-305): `departments` was audited in Batch 6 Slice 46; its member was reproduced as DEP-1 with a classified consequence (DEP-3) and is closed, and it no longer meets the criterion, because `app.guard_department_write` charges `app.authorize`.** **2026-11-11 (SPEC-308): `document_retention_policies` was audited in Batch 6 Slice 49; its member was reproduced as RET-3 with a classified consequence (a superseded file made deletable at `aal1`) and is closed, and it no longer meets the criterion, because `app.guard_document_retention_policy_write` charges `app.authorize`.** **2026-11-14 (SPEC-310): `exchange_rates` and `catalog_values` were audited in Batch 6 Slice 51; each member was reproduced with a classified consequence (FX-6 with FX-5: an `aal1` finance manager set the rate money is converted at; CAT-9 with CAT-7 and CAT-8: an `aal1` owner extended platform-owned families and renamed a value in use) and is closed, and neither meets the criterion any more, because `app.guard_exchange_rate_write` and `app.guard_catalog_value_write` charge `app.authorize`. `user_permission_grants` no longer meets it either: USR-3 is closed by `app.guard_permission_grant_authority`.** | — | SPEC-226-branch-door-audit-record | 09-27 | 09-27 |
   ```
   with
   ```text
   | RFD-3 | **Legal direct refund lifecycle writes still change customer balance without emitting the refund events the RPC emits** | financial audit / observability | Medium | R | 6 | — | ✅ | **FIXED 2026-11-21 (CRM SPEC-326, `20261121110000`).** A refund now records its own acts on both doors: `refunds_emit_requested` (`app.emit_refund_requested`) records the request on every INSERT and `refunds_emit_transition` (`app.emit_refund_transition`) records each transition, with the reason `app.advance_refund(p_reason)` passes through SPEC-237's transaction-local `app.transition_reason`; `app.record_refund` and `app.advance_refund` dropped their own `record_event`, so no act is recorded twice, and the severities are kept (completed stays warning). Both pgTAP runs, including Test 184, verified that the table door records the request, approval and completion once each under the caller, that the RPC door records the same three acts once each with its reasons, and that `completed_at` is server-stamped on both doors. CRM's Platinum Primary readback confirmed the exact migration, the enabled bindings and ten-surface parity. History: **OPEN — independently reproduced during Slice 17; not absorbed by SPEC-217.** Finance at `aal2` created a requested refund by direct INSERT, advanced requested → approved → completed by legal direct UPDATEs, and `app.customer_balance` rose 11 EGP while `public.events` contained zero events for the refund; the RPC path emitted three. After SPEC-217, the direct path is authorized and server-stamped, but remains silent. An event trigger plus removal of RPC emissions would need to preserve `app.advance_refund(p_reason)` and avoid duplicates; that is a distinct event-authority design, not needed to close RFD-1, RFD-2 or ENTRY-1. Reopening trigger: the next refund event-authority work or a consumer that requires direct-door refund event parity. No owner decision is pending. **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |  | SPEC-217-refund-door-integrity; CRM SPEC-326-a-refund-a-conversation-and-a-settlement-are-recorded-on-every-door | 09-24 | 11-21 |
   | BRANCH-1 | **An `aal1` owner or ceo creates, renames, re-slugs and deactivates branches through the table that `app.create_branch` refuses them** | security · authorization | Low | R | 6 | — | ✅ | **FIXED 2026-11-20 (CRM SPEC-320, `20261120122927`).** The existing capability guard now requires MANAGE_BRANCHES and MFA step-up on direct INSERT and UPDATE for roles subject to it. Both pgTAP runs, including Test 130, verified refusal and valid writes. CRM's Platinum Primary readback confirmed the exact migration, enabled trigger, function definition and ten-surface parity. Historical reproduction from SPEC-226: an `owner` with `app.has_permission('MANAGE_BRANCHES')` true and `app.mfa_satisfied()` false was refused `42501 multi-factor authentication required for this role` by `app.create_branch` and, through the existing `app.guard_write_capability`, by the child `branch_business_hours`; the same actor then directly INSERTed a branch (1 row) and set the tenant's Main branch to `name = 'Hijacked'`, a new `slug` and `is_active = false` (1 row, persisted). Cause: the RPC charges `app.authorize` (permission AND step-up), while `scope_insert` and `scope_update` call `app.has_permission` (permission only) and no trigger on `branches` charges step-up. MANAGE_BRANCHES is held only by `owner` and `ceo`, both step-up-bound by `app.requires_mfa`. **Low, and the bound is measured:** no function, view or policy reads `branches.name`, `slug`, `is_active`, `branch_type`, `primary_phone`, `address` or `created_at`; a branch is consumed only by its id, as the target of 22 composite `(tenant_id, id)` foreign keys, in `app.visible_branch_ids` and in `events.audit_read`'s existence test; and a new branch confers nothing, because every write that would place work in it is guarded on its own table. The existing mechanism, if this is repaired, is CAMP-3's: one `guard_write_capability` map arm and a BEFORE INSERT OR UPDATE attachment. **Priority rises when** a function, view, policy or application path first reads a branch attribute other than its id and tenant, or treats a branch's existence as a ceiling or an authority. A member of STEPUP-1. `130_branch_door_audit_test.sql` now asserts the repaired path, and BRANCH-2 retains its separate event evidence. **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. | — | SPEC-226-branch-door-audit-record, CRM SPEC-320-branch-write-authority-matches-the-rpc | 09-27 | 11-20 |
   | BRANCH-2 | **A branch created at the table door records no `branch_created`, while `app.create_branch` records the same act** | audit completeness · observability | Low | R | 6 | — | 📋 | **OPEN — reproduced in Batch 6 Slice 24 and recorded, deliberately not repaired.** MEASURED in rolled-back local transactions: three branches were created in one tenant, one by the owner's `app.create_branch` at `aal2`, one by direct INSERT at `aal2` and one by direct INSERT at `aal1` (BRANCH-1), and the tenant gained exactly one `branch_created` event. `branches` has no creator column, so for a branch created at the table door nothing records who created it. **Low, and the bound is measured:** the only function that names `branch_created` is its producer and nothing consumes the event, so the loss is audit and timeline completeness. CAMP-4's shape on another surface; SUP-5's single AFTER INSERT producer is the existing mechanism if this is repaired. **Not part of this finding:** the same direct INSERT also stored a caller-supplied `created_at = 2001-01-01`. That is the caller-writable `created_at` that SPEC-216 recorded as "a question that stands on every table with such a column" and SPEC-218 left unregistered on `customer_contact_methods`: no function in `app` or `public` assigned `new.created_at` on any table at the time (corrected by CRM SPEC-335: at `676df3e` `app.guard_customer_note_integrity` does, and the caller-writable stamps are STAMP-1), SUP-5's repair left `suppliers.created_at` caller-writable, and nothing reads `branches.created_at`, so repairing this finding would not change it. `130_branch_door_audit_test.sql` assertion 19 pins it OPEN and fails when it is repaired. | — | SPEC-226-branch-door-audit-record | 09-27 | 09-27 |
   | STEPUP-1 | **A class CANDIDATE, found by structural evidence: eleven tables carry a direct permission-only write path with no step-up anywhere in their trigger chain** | security · authorization · class | Unclassified | R | 6 | — | ✅ | **RESOLVED 2026-11-21 (CRM SPEC-324, `20261121100000`) for its B6-EXIT members.** The class was never proven as a class; any remaining candidate keeps its recorded status. History: **UNPROVEN — structural candidate class, recorded, deliberately not acted on (Batch 6 Slice 24).** Not a reproduced class defect. Criterion, read from the local catalog at `b6a0714`: `authenticated` holds INSERT or UPDATE; the INSERT or UPDATE policy charges `app.has_permission(K)` for a K held only by roles that `app.requires_mfa` binds to step-up; and no trigger on the table, at any timing, calls `app.authorize` or `app.mfa_satisfied` directly or through one level of `app` helper. Eleven tables meet it: `branches`, `campaign_daily_metrics`, `catalog_values`, `chart_of_accounts`, `departments`, `document_retention_policies`, `exchange_rate_adjustments`, `exchange_rates`, `journal_entries`, `journal_entry_lines`, `tenants`. `user_branch_assignments` and `user_permission_grants` meet it too and belong to USR-3. `user_role_assignments` does NOT: its AFTER trigger `app.emit_role_change` charges `app.authorize('MANAGE_USERS')`, which a first, BEFORE-only reading missed and a rolled-back probe corrected. **Only `branches` is a reproduced and consequence-classified defect (BRANCH-1, Low).** **`journal_entry_lines` was audited in Batch 6 Slice 32 (SPEC-245): an `aal1` finance manager rewrote posted lines the RPC refuses it to post, and that member is closed by JE-3's repair; it no longer meets the criterion, because `authenticated` holds no INSERT or UPDATE on it. `chart_of_accounts` was audited in Batch 6 Slice 42 (SPEC-278): its member was reproduced as COA-2 and is closed, and it no longer meets the criterion, because `app.guard_chart_account` charges `app.authorize`. `journal_entries` still meets it (JE-5).** The same probe saw an `aal1` owner's rename land on `departments` and on `tenants`. `departments`' consequence is not classified, so it remains a candidate and is not an audit. **`tenants` was audited in Batch 6 Slice 26 (SPEC-228) and its consequence is classified: none material.** An `aal1` `owner` or `ceo` does write every tenant-profile column, but nothing reads any of them except `name`, shown only to the tenant's own members; no canon marks a tenant-profile edit as step-up, platform-only or sensitive; and the other MANAGE_TENANT_SETTINGS doors that charge `app.authorize` guard distinct actions (licence redemption, payment-proof upload, legal hold, document versions and links, holidays), not a second door to the same action. So `tenants` still meets the criterion, is not a defect, and does not raise this class above UNPROVEN. The other eight are structural candidates only; the finance tables among them are where a consequence, if reproduced, would most likely be material. A member becomes a defect only when it is individually reproduced adversarially and its consequence is classified, and no member gains a disposition or counts toward Batch 6 coverage by being listed here. `campaign_daily_metrics` and `exchange_rate_adjustments` are recorded `AUDITED`, and step-up was not asked on either. **Ceiling:** the criterion reads function text, so it can miss step-up charged through deeper indirection and it cannot see consequence (MEAS-1). **Trigger to revisit:** the Batch 6 slice of any listed table, or the first reproduced consequence on a candidate. **2026-10-08 (SPEC-246): `journal_entries` no longer meets the criterion, because `authenticated` holds no INSERT or UPDATE on it; its member consequence, JE-5, is closed by that revoke.** **2026-11-11 (SPEC-308): `departments` was audited in Batch 6 Slice 46; its member was reproduced as DEP-1 with a classified consequence (DEP-3) and is closed, and it no longer meets the criterion, because `app.guard_department_write` charges `app.authorize`.** **2026-11-11 (SPEC-305): `document_retention_policies` was audited in Batch 6 Slice 49; its member was reproduced as RET-3 with a classified consequence (a superseded file made deletable at `aal1`) and is closed, and it no longer meets the criterion, because `app.guard_document_retention_policy_write` charges `app.authorize`.** **2026-11-14 (SPEC-310): `exchange_rates` and `catalog_values` were audited in Batch 6 Slice 51; each member was reproduced with a classified consequence (FX-6 with FX-5: an `aal1` finance manager set the rate money is converted at; CAT-9 with CAT-7 and CAT-8: an `aal1` owner extended platform-owned families and renamed a value in use) and is closed, and neither meets the criterion any more, because `app.guard_exchange_rate_write` and `app.guard_catalog_value_write` charge `app.authorize`. `user_permission_grants` no longer meets it either: USR-3 is closed by `app.guard_permission_grant_authority`.** **2026-11-19 (CRM exit reconciliation):** The remaining named questions are reproduced BRANCH-1 and two previously unswept candidate axes, campaign daily metrics and exchange-rate adjustments. SPEC-245/246 close the journal members, and the later entries carry the local repairs. The class remains UNPROVEN. **2026-11-20 (CRM SPEC-320):** BRANCH-1 is fixed on CRM's Platinum Primary, with the new capability binding independently verified. The two remaining candidate axes still require targeted evidence. **2026-11-21 (CRM SPEC-324):** The two remaining candidate axes are closed on CRM's Platinum Primary: `app.guard_write_capability` now charges `campaign_daily_metrics` writes MANAGE_MARKETING_CAMPAIGN and `exchange_rate_adjustments` writes CREATE_EXCHANGE_RATE_ADJUSTMENT, the permissions their RLS write checks demand, so `app.authorize` adds step-up. Test 183 proves insert and update at `aal1` need step-up, the same writes at `aal2` succeed and a non-holder is refused; Tests 58 and 101 record the guard membership. `tenants` keeps its not-a-defect classification. No B6-EXIT member remains. **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. | — | SPEC-226-branch-door-audit-record, CRM SPEC-324-entry-and-step-up-hold-at-the-table-door | 09-27 | 11-21 |
   ```

   u) immediately after the line
   ```text
   | JE-6 | **`app.create_journal_entry` stores any `source_entity_id`, including a nonexistent one or another tenant's entity** | financial integrity · provenance | Low | R | 6 | — | 📋 | **OPEN -- recorded, deliberately not repaired (Batch 6 Slice 33, SPEC-246).** MEASURED at `7e6f51e`, rolled back: a `finance_manager` at aal2 posted through the RPC with `source_entity_id` set to another tenant's invoice, to a nonexistent id, and to an id on a `manual_entry`, and all three committed. The column has no foreign key: it is polymorphic over `journal_entry_source_type`. **Low:** no disclosure was demonstrated (the RPC stores the id and reads nothing behind it), and no function, view or report reads the column. **Not repaired because the authority is unresolved:** canon names the source types but not which table each points to, nor whether a manual entry may carry a source; inventing that model would be business policy (`AGENTS.md §6`). Separate from JE-5, whose repair closes the header's table door and leaves this RPC and its input handling unchanged. | engineering: decide the source-type-to-entity mapping and manual-entry semantics when the first reader of `source_entity_id` is built, escalating to the owner only if canon cannot answer them | SPEC-246-a-posted-journal-entry-is-never-rewritten | 10-08 | 10-08 |
   ```
   insert
   ```text
   | STAMP-1 | **A member can write the creation stamp of most tables they can write, and no deciding reader reads it** | audit · provenance | Low | R | 6 | — | 📋 | **OPEN — accepted residual, deliberately not repaired.** MEASURED at `676df3e` (catalog): `authenticated` may write `created_at` on 48 tables; only `app.guard_customer_note_integrity` assigns `new.created_at`, and five guards (trusted devices, payment allocations, receipts, user role assignments, customer notes) freeze it on update. No policy reads `created_at`; the function readers read tables members cannot write or use it for display order only (`app.financial_documents`). The two readers that decide something, the sales reports over `bookings` and `booking_items`, are BOOK-13. The other 46 stamps have no deciding reader. Reopening trigger: the first function, view, policy or report that decides or reports by such a column (JE-6's precedent). | engineering: re-measure at the reopening trigger and repair that table's stamp in the same change | CRM SPEC-335-the-exit-evidence-gaps-are-pinned-and-the-re-sweep-registered | 11-23 | 11-23 |
   ```

   v) replace the line
   ```text
   - **Finding:** `scripts/verify_database.sql` raises on the first broken invariant but did not set `ON_ERROR_STOP`, so psql exited 0 on failure — the smoke-test was silently non-gating for every caller (local + never run in CI). **Status: ✅ IMPLEMENTED (SPEC-116).** File now self-arms `\set ON_ERROR_STOP on` (verified: pass→0, fail→3) and CI runs it after every `db reset`.
   ```
   with
   ```text
   - **Finding:** `scripts/verify_database.sql` raises on the first broken invariant but did not set `ON_ERROR_STOP`, so psql exited 0 on failure — the smoke-test was silently non-gating for every caller (local + never run in CI). **Status:** ✅ IMPLEMENTED (SPEC-116). File now self-arms `\set ON_ERROR_STOP on` (verified: pass→0, fail→3) and CI runs it after every `db reset`.
   ```

   w) replace the line
   ```text
   - **Category:** authorization model / misleading contract · **Severity:** Medium · **Status:** OBSOLETE (merged into SEC-1) · **Owner:** —
   ```
   with
   ```text
   - **Category:** authorization model / misleading contract · **Severity:** Medium · **Status:** CLOSED 2026-08-28 by merger into SEC-1 (re-worded 2026-11-22, CRM SPEC-331; superseded text: OBSOLETE, merged into SEC-1) · **Owner:** —
   ```

   x) replace the line
   ```text
   - **Category:** authorization model · **Severity:** — · **Status:** OBSOLETE (merged) · **Owner:** —
   ```
   with
   ```text
   - **Category:** authorization model · **Severity:** — · **Status:** CLOSED 2026-08-28 by merger into SEC-1 (re-worded 2026-11-22, CRM SPEC-331; superseded text: OBSOLETE, merged) · **Owner:** —
   ```

   y) replace the line
   ```text
   - **Category:** interface governance · **Severity:** n/a (deliverable) · **Status:** DELIVERED · **Owner:** engineering
   ```
   with
   ```text
   - **Category:** interface governance · **Severity:** n/a (deliverable) · **Status:** IMPLEMENTED 2026-08-29, guarded by Check L3 (re-worded 2026-11-22, CRM SPEC-331; superseded text: DELIVERED) · **Owner:** engineering
   ```

   z) replace the line
   ```text
   - **Category:** dead structure / vocabulary · **Severity:** Low today, High the day e-invoicing is wired · **Status:** 📋 **OPEN — engineering** · **Owner:** engineering
   ```
   with
   ```text
   - **Category:** dead structure / vocabulary · **Severity:** Low today, High the day e-invoicing is wired · **Status:** PROVEN NOT A DEFECT, retracted 2026-09-04; see the retraction below (re-worded 2026-11-22, CRM SPEC-331; superseded text: 📋 **OPEN — engineering**) · **Owner:** engineering
   ```

   The resulting file's Git blob is dd98cac1e8f387c3638373745d53ddcfc65d6c02.

38. Check whether `reports/master/MASTER_SURFACE_DISPOSITION.md` contains `ORVION SPEC-319, the Founder twin of CRM SPEC-316 to SPEC-340`; if so record Already Applied when its Git blob is 0c091d6bf8793f26f2943ef522269ac7bd79aa06, and otherwise stop and report. Otherwise make exactly these 16 edits (the disposition rows of CRM SPEC-316 to SPEC-340, Founder deployment pending), each matched once, and change nothing else:

   a) replace the line
   ```text
   Last updated: 2026-11-18 (**slice 59 — `nationalities`, `countries` and `currencies` selected by Exposure 0, coverage 4, 10 and 22, in one contract, with `languages` by the owner's policy of 2026-11-18.** Coverage **75 → 78 of 78**. REF-2: a deactivated nationality, country, currency or language was accepted on new business. ORVION SPEC-318, the twin of CRM SPEC-315, closes it here, so the three new rows are `AUDITED` and the `languages` row records the new rule. No other row changed.)
   ```
   with
   ```text
   Last updated: 2026-11-25 (**ORVION SPEC-319, the Founder twin of CRM SPEC-316 to SPEC-340, the Batch 6 exit catch-up.** It adopts by identity the seven CRM migrations `20261119054533` to `20261122100000` and Tests 182–198, and with them CRM's dispositions of `booking_item_passengers`, `booking_items`, `bookings`, `branches`, `campaign_daily_metrics`, `conversations`, `customers`, `documents`, `exchange_rate_adjustments`, `financial_accounts`, `invoices`, `journal_entry_lines`, `leads`, `otp_challenges`, `passengers`, `payment_allocations`, `payments`, `quotations`, `refunds`, `suppliers`, `tasks`; each row cites its CRM contract, and the rows whose CRM proof carries one of the seven migrations name their Founder Secondary state under SPEC-319. Coverage stays **78 of 78**. No other row changed.)

   Previously: 2026-11-18 (**slice 59 — `nationalities`, `countries` and `currencies` selected by Exposure 0, coverage 4, 10 and 22, in one contract, with `languages` by the owner's policy of 2026-11-18.** Coverage **75 → 78 of 78**. REF-2: a deactivated nationality, country, currency or language was accepted on new business. ORVION SPEC-318, the twin of CRM SPEC-315, closes it here, so the three new rows are `AUDITED` and the `languages` row records the new rule. No other row changed.)
   ```

   b) replace the line
   ```text
   **78 of 78 recorded · 54 `AUDITED` · 21 `AUDITED-OPEN` · 3 `PARTIAL` · 0 `EXEMPT` · 0 `NOT-RECORDED`.**
   ```
   with
   ```text
   **78 of 78 recorded · 62 `AUDITED` · 15 `AUDITED-OPEN` · 1 `PARTIAL` · 0 `EXEMPT` · 0 `NOT-RECORDED`.**
   ```

   c) replace the lines
   ```text
   | `booking_item_passengers` | **AUDITED-OPEN** | ADVERSARIAL | `session-2026-09-07-batch6-slice4-booking-item-passengers` | PAX-1, PAX-2, PAX-3, PAX-5, PAX-6 | PAX-5 (owner: manifest immutability after issuance) and PAX-6 (canon: no event vocabulary for a manifest change) — both decisions, neither engineering |
   | `booking_items` | **AUDITED-OPEN** | ADVERSARIAL | session-2026-09-07-batch6-slice5-booking-items | BOOK-8, BOOK-9 | `105_booking_item_service_door_test.sql` — **44 assertions, all ten attack classes, none N/A.** `202607061500` closed **BOOK-3** (the bare booked service, and its whole UPDATE half: service type, currency, ownership and re-parenting were all free), **BOOK-4** (a cross-tenant existence-and-state oracle, PAX-3 one table up), **BOOK-5** (the canon-28 scope check read the attacker's own post-image), **BOOK-6** (the finance execution gate was clearable) and **BOOK-7** (a priced item could be redenominated). `AUDITED-OPEN` rather than `AUDITED` because two remain and **neither is engineering**: **BOOK-8** is a business decision (may a finance-approval requirement be withdrawn) and **BOOK-9** a canon one (booking items have no reassignment permission where leads have REASSIGN_LEAD) |
   | `bookings` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-239-issuance-holds-on-every-door` | PAX-9, BOOK-10, BOOK-11, BOOK-12 | `129_manifest_freeze_cannot_be_left_test.sql` proves that once a booking's status freezes its passenger manifest, an employee is refused carrying its item out, moving entries off or on, inserting a traveller and bringing a traveller-carrying item in, each by its own message; correction holders (including a finance manager) need a fresh reason and are server-stamped, with the linked/replaced event carrying it; correction evidence cannot be forged at birth; the platform path gets no exemption; an installed/restored mutation of `app.manifest_is_frozen` reopens every operation. Capability with step-up, the per-transition status permission, archive authority and scope-aware RLS were already held by existing controls. **2026-09-29 (SPEC-239):** `141_issuance_holds_on_every_door_test.sql` closes **BOOK-10** for issuance — the override, the risk flag and one `booking_issued` on the RPC, table and platform doors, the archived rule on every transition, and `draft` at birth — with an in-file mutation. **BOOK-11 and BOOK-12 remain OPEN.** |
   ```
   with
   ```text
   | `booking_item_passengers` | **AUDITED** | ADVERSARIAL | `session-2026-09-07-batch6-slice4-booking-item-passengers` | PAX-1, PAX-2, PAX-3, PAX-5, PAX-6 | `104_booking_item_passenger_manifest_surface_test.sql` and `114_passenger_manifest_freeze_and_events_test.sql`: PAX-5 is resolved (migration `20260909132000`; the manifest freezes at `issued`, and a correction needs `CORRECT_PASSENGER_MANIFEST`, a fresh reason and a server-derived actor and time). PAX-6 is resolved (migration `20260909133000`; link, replace and remove each emit exactly one immutable event on every path). Re-dispositioned 2026-11-22 by CRM SPEC-331; superseded Next: PAX-5 (owner: manifest immutability after issuance) and PAX-6 (canon: no event vocabulary for a manifest change), both decisions, neither engineering |
   | `booking_items` | **AUDITED-OPEN** | ADVERSARIAL | session-2026-09-07-batch6-slice5-booking-items | BOOK-8, BOOK-9, BOOK-13 | `105_booking_item_service_door_test.sql` — **44 assertions, all ten attack classes, none N/A.** `202607061500` closed **BOOK-3** (the bare booked service, and its whole UPDATE half: service type, currency, ownership and re-parenting were all free), **BOOK-4** (a cross-tenant existence-and-state oracle, PAX-3 one table up), **BOOK-5** (the canon-28 scope check read the attacker's own post-image), **BOOK-6** (the finance execution gate was clearable) and **BOOK-7** (a priced item could be redenominated). `AUDITED-OPEN` rather than `AUDITED` because two remain and **neither is engineering**: **BOOK-8** is a business decision (may a finance-approval requirement be withdrawn) and **BOOK-9** a canon one (booking items have no reassignment permission where leads have REASSIGN_LEAD). **2026-11-21 (CRM SPEC-324):** `AUDITED`, because BOOK-8 and BOOK-9 are resolved in the gap register; `20261121100000` and `183_entry_and_step_up_hold_at_the_table_door_test.sql` close this door's ARCH-2 member (archive authority at INSERT) and ENTRY-1 member (a signed-in creation opens at `draft` with no lifecycle stamp, the RPC door and session-less paths unchanged), verified on CRM's Platinum Primary. **2026-11-23 (CRM SPEC-335):** `AUDITED-OPEN`: **BOOK-13**, the sales owner rewrites a sold item's `created_at` and `reporting.my_sales_performance` reports it sold then; `194_door_evidence_and_sale_dates_open_pins_test.sql` pins it OPEN **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |
   | `bookings` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-239-issuance-holds-on-every-door` | PAX-9, BOOK-10, BOOK-11, BOOK-12, BOOK-13, ARCH-2 | `129_manifest_freeze_cannot_be_left_test.sql` proves that once a booking's status freezes its passenger manifest, an employee is refused carrying its item out, moving entries off or on, inserting a traveller and bringing a traveller-carrying item in, each by its own message; correction holders (including a finance manager) need a fresh reason and are server-stamped, with the linked/replaced event carrying it; correction evidence cannot be forged at birth; the platform path gets no exemption; an installed/restored mutation of `app.manifest_is_frozen` reopens every operation. Capability with step-up, the per-transition status permission, archive authority and scope-aware RLS were already held by existing controls. **2026-09-29 (SPEC-239):** `141_issuance_holds_on_every_door_test.sql` closes **BOOK-10** for issuance — the override, the risk flag and one `booking_issued` on the RPC, table and platform doors, the archived rule on every transition, and `draft` at birth — with an in-file mutation. **BOOK-11 and BOOK-12 remain OPEN.** CRM SPEC-319 and `182_archive_authority_applies_at_entry_test.sql` verify the ARCH-2 booking member on CRM's Platinum Primary. BOOK-11 and BOOK-12 remain open. **2026-11-23 (CRM SPEC-335):** **BOOK-13**, a member backdates their own booking and `reporting.sales_activity` reports it on that date; Test 194 pins it OPEN. |
   ```

   d) replace the lines
   ```text
   | `branches` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-226-branch-door-audit-record` | BRANCH-1, BRANCH-2 | `130_branch_door_audit_test.sql` proves the RPC and the child `branch_business_hours` door refuse an `aal1` owner step-up, the other tenant can be neither planted into, relocated into nor updated, a non-holder's INSERT is refused and its UPDATE changes nothing, DELETE has no grant and a slug is unique per tenant; an installed/restored mutation of each `scope_insert` conjunct shows the tenant and permission refusals come from that policy. It pins **BRANCH-1** (the `aal1` owner's direct create, rename, re-slug and deactivation land) and **BRANCH-2** (a direct creation records no `branch_created`) as OPEN defects, not desired behaviour, and those assertions fail when either is repaired. Swept and classified as non-defects: `is_active`, `name`, `slug`, `branch_type` and the contact columns have no reader; `created_at` is caller-writable here as on every table with such a column (SPEC-216's recorded schema-wide question) and nothing reads it; `max_branches` is unenforced on every door by canon 28; every inbound reference is a composite `(tenant_id, id)` key. BRANCH-1 is a member of **STEPUP-1** |
   | `campaign_daily_metrics` | **AUDITED** | ADVERSARIAL | `session-2026-09-05-batch6-evidence-foundation` | CDM-1, CDM-2, CDM-3 | — |
   ```
   with
   ```text
   | `branches` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-226-branch-door-audit-record` | BRANCH-1, BRANCH-2 | `130_branch_door_audit_test.sql` proves the RPC and the child `branch_business_hours` door refuse an `aal1` owner step-up, the other tenant can be neither planted into, relocated into nor updated, a non-holder's INSERT is refused and its UPDATE changes nothing, DELETE has no grant and a slug is unique per tenant; an installed/restored mutation of each `scope_insert` conjunct shows the tenant and permission refusals come from that policy. CRM SPEC-320 and Test 130 verify MANAGE_BRANCHES and MFA on direct INSERT and UPDATE. Independent CRM's Platinum Primary readback verified migration `20261120122927`, the enabled capability trigger and structural parity. **BRANCH-2** remains open because direct creation still records no `branch_created`. Its enablement trigger stands. Swept and classified as non-defects: `is_active`, `name`, `slug`, `branch_type` and the contact columns have no reader; `created_at` is caller-writable here as on every table with such a column (SPEC-216's recorded schema-wide question) and nothing reads it; `max_branches` is unenforced on every door by canon 28; every inbound reference is a composite `(tenant_id, id)` key. BRANCH-1 is a member of **STEPUP-1** **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |
   | `campaign_daily_metrics` | **AUDITED** | ADVERSARIAL | `session-2026-09-05-batch6-evidence-foundation` | CDM-1, CDM-2, CDM-3 | **2026-11-21 (CRM SPEC-324):** `20261121100000` adds this table to `app.guard_write_capability` at MANAGE_MARKETING_CAMPAIGN; `183_entry_and_step_up_hold_at_the_table_door_test.sql` proves insert and update at `aal1` need step-up, at `aal2` succeed and a non-holder is refused (STEPUP-1) **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |
   ```

   e) replace the line
   ```text
   | `conversations` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-220-conversation-creation-parity` | CHAT-1, CHAT-2, ENTRY-1 | `125_conversation_creation_parity_test.sql` proves a real SEND_MESSAGE actor's direct and RPC open starts, actual owner/placement despite false owner input, one event and timeline entry per row, refused terminal/preclosed entry, capability, catalog and replay refusals, and valid sessionless creation with null actor. A colleague in another branch cannot read the attempted forged-owner row. SPEC-220 closes CHAT-1 and this table's ENTRY-1 instance; **CHAT-2 remains OPEN:** legal direct UPDATE reopen can lack event/reason and retain `closed_at`. No authenticated DELETE grant; CONV-3 inbound integration remains deferred. |
   ```
   with
   ```text
   | `conversations` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-220-conversation-creation-parity` | CHAT-1, CHAT-2, ENTRY-1, CHAT-5 | `125_conversation_creation_parity_test.sql` proves a real SEND_MESSAGE actor's direct and RPC open starts, actual owner/placement despite false owner input, one event and timeline entry per row, refused terminal/preclosed entry, capability, catalog and replay refusals, and valid sessionless creation with null actor. A colleague in another branch cannot read the attempted forged-owner row. SPEC-220 closes CHAT-1 and this table's ENTRY-1 instance; **CHAT-2 remains OPEN:** legal direct UPDATE reopen can lack event/reason and retain `closed_at`. No authenticated DELETE grant; CONV-3 inbound integration remains deferred. **2026-11-21 (CRM SPEC-326):** `AUDITED`, because CHAT-2 is fixed in the gap register: `20261121110000` and `184_refund_conversation_and_settlement_are_recorded_on_every_door_test.sql` prove that a table-door close stamps `closed_at` from the server and a later update cannot rewrite it, that a reopen without a reason is refused on both doors and a reopen clears `closed_at`, and that every move on either door is recorded once with its reason, reopen and escalation as warnings, verified on CRM's Platinum Primary. **2026-11-24 (CRM SPEC-338):** `AUDITED-OPEN`: **CHAT-5**, `app.advance_conversation` refuses an invalid move as `permission denied: <NULL>` instead of its own message; fail-closed, and `196_each_function_refusal_is_reached_by_a_call_test.sql` pins it OPEN. **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |
   ```

   f) replace the line
   ```text
   | `customers` | AUDITED | ADVERSARIAL | `session-2026-09-09-slice11-closure` | CUST-7, CUST-8, CUST-9, CUST-10, CUST-11, CUST-12 | — |
   ```
   with
   ```text
   | `customers` | AUDITED | ADVERSARIAL | `session-2026-09-09-slice11-closure` | CUST-7, CUST-8, CUST-9, CUST-10, CUST-11, CUST-12, CUST-17, ARCH-2 | CRM SPEC-319 and `182_archive_authority_applies_at_entry_test.sql` verify that an active customer insert cannot carry caller-supplied archive actor or time. |
   ```

   g) replace the line
   ```text
   | `documents` | **PARTIAL** | ADVERSARIAL | `SPEC-216-document-door-parity` | DOC-4, DOC-5, DOC-6, DOC-LC-3 | The table door's entry state, type, version pointer and archive representations were swept and **DOC-4**, **DOC-5**, **DOC-6** and **DOC-LC-3** closed: `122_document_door_parity_test.sql` pins them with 25 assertions — an `employee` holding neither ARCHIVE_DOCUMENT nor MANAGE_TENANT_SETTINGS, a `finance_manager` holding no MANAGE_TENANT_SETTINGS, and a pointer attack aimed at a version the caller CAN see, so no permission or visibility is the refuser — and `69_…` 18-19 now assert DOC-LC-3's refusal. The same guard closed the `documents` instances of **ARCH-2** (a document born archived) and **ENTRY-1** (born `archived` or `superseded`). **Swept and classified as non-defects, not registered:** tenant relocation (refused by `scope_isolation`); `created_by` (derived and immutable, `61_…`); confidentiality and title (editable by an actor who already holds the file, so no escalation; a `payment_proof` stays under MANAGE_TENANT_SETTINGS for every edit); both doors agreeing at `aal1`; no DELETE grant; the subscription gate on every door. **`PARTIAL` because two axes were probed and deliberately not classified:** (1) event parity for a document created at the door — it records no `document_uploaded`, while its creator is server-derived and it carries no file until a recorded version is added (`quotations` names the same axis); (2) `created_at`, writable at the door and read only by `app.financial_documents`' listing, a question that stands on every table with such a column |
   ```
   with
   ```text
   | `documents` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-216-document-door-parity` | DOC-4, DOC-5, DOC-6, DOC-LC-3, DOC-11 | The table door's entry state, type, version pointer and archive representations were swept and **DOC-4**, **DOC-5**, **DOC-6** and **DOC-LC-3** closed: `122_document_door_parity_test.sql` pins them with 25 assertions — an `employee` holding neither ARCHIVE_DOCUMENT nor MANAGE_TENANT_SETTINGS, a `finance_manager` holding no MANAGE_TENANT_SETTINGS, and a pointer attack aimed at a version the caller CAN see, so no permission or visibility is the refuser — and `69_…` 18-19 now assert DOC-LC-3's refusal. The same guard closed the `documents` instances of **ARCH-2** (a document born archived) and **ENTRY-1** (born `archived` or `superseded`). **Swept and classified as non-defects, not registered:** tenant relocation (refused by `scope_isolation`); `created_by` (derived and immutable, `61_…`); confidentiality and title (editable by an actor who already holds the file, so no escalation; a `payment_proof` stays under MANAGE_TENANT_SETTINGS for every edit); both doors agreeing at `aal1`; no DELETE grant; the subscription gate on every door. **`PARTIAL` because two axes were probed and deliberately not classified:** (1) event parity for a document created at the door — it records no `document_uploaded`, while its creator is server-derived and it carries no file until a recorded version is added (`quotations` names the same axis); (2) `created_at`, writable at the door and read only by `app.financial_documents`' listing, a question that stands on every table with such a column. **2026-11-23 (CRM SPEC-335):** `AUDITED-OPEN`: both axes are classified. Axis (1) is **DOC-11** (`ENABLE-SURFACE-WORKFLOW`) and axis (2) is **STAMP-1**, an accepted residual; `194_door_evidence_and_sale_dates_open_pins_test.sql` pins DOC-11 OPEN |
   ```

   h) replace the line
   ```text
   | `exchange_rate_adjustments` | **AUDITED** | ADVERSARIAL | `session-2026-09-05-batch6-evidence-foundation` | ERA-1 | — |
   ```
   with
   ```text
   | `exchange_rate_adjustments` | **AUDITED** | ADVERSARIAL | `session-2026-09-05-batch6-evidence-foundation` | ERA-1 | **2026-11-21 (CRM SPEC-324):** `20261121100000` adds this table to `app.guard_write_capability` at CREATE_EXCHANGE_RATE_ADJUSTMENT; `183_entry_and_step_up_hold_at_the_table_door_test.sql` proves an insert at `aal1` needs step-up and at `aal2` succeeds (STEPUP-1) **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |
   ```

   i) replace the line
   ```text
   | `financial_accounts` | **AUDITED-OPEN** | ADVERSARIAL | `session-2026-09-05-batch6-adversarial-program` | FA-1, FA-2 | FA-2 is an owner question: may a bank account receive a payment in another currency? |
   ```
   with
   ```text
   | `financial_accounts` | **AUDITED** | ADVERSARIAL | `session-2026-09-05-batch6-adversarial-program` | FA-1, FA-2 | `113_cross_currency_payment_evidence_test.sql`: FA-2 is resolved (migration `20260909131000`). A payment into an account in another currency needs explicit conversion evidence: the rate, the account-currency amount and a server-derived evidence time. Re-dispositioned 2026-11-22 by CRM SPEC-331; superseded Next: FA-2 is an owner question: may a bank account receive a payment in another currency? |
   ```

   j) replace the line
   ```text
   | `invoices` | **AUDITED** | ADVERSARIAL | `session-2026-09-08-batch6-slice10-invoices` | INVOICE-1, INVOICE-2, INVOICE-3, INVOICE-4, INVOICE-5, INVOICE-6, INVOICE-7 | — |
   ```
   with
   ```text
   | `invoices` | **AUDITED** | ADVERSARIAL | `session-2026-09-08-batch6-slice10-invoices` | INVOICE-1, INVOICE-2, INVOICE-3, INVOICE-4, INVOICE-5, INVOICE-6, INVOICE-7 | **2026-11-21 (CRM SPEC-324):** `20261121100000` attaches archive authority at INSERT; `183_entry_and_step_up_hold_at_the_table_door_test.sql` proves an active row cannot claim a forged archiver, an authorized archived creation is accepted, and the archiver and time come from the server, not the forged and backdated input (ARCH-2) **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |
   ```

   k) replace the line
   ```text
   | `journal_entry_lines` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-245-a-journal-line-is-written-only-with-its-entry` | JE-2, JE-3, JE-4 | `145_a_journal_line_is_written_only_with_its_entry_test.sql` proves that a `finance_manager` holding CREATE_JOURNAL_ENTRY at aal2 is refused, by the missing grant, rewriting a posted entry balanced in another currency and backdated, moving a posted line onto a retired account or into another entry, and appending a balanced pair to a posted entry. Every entry still says what its `journal_entry_created` event says. The same actor at aal1 can neither post through the RPC nor rewrite at the table, an employee cannot post, and another tenant reads nothing. The RPC, now the lines' one writer, is definer with an empty search_path and still charges permission and step-up. Even the platform cannot empty an entry by moving its lines, while a move that leaves both entries balanced passes. `verify_journey_branches.ps1` proves the bulk append, the upsert rewrite and the PATCH at aal2 and aal1 refused over HTTP. Installed/restored mutations restoring either grant, returning the RPC to invoker, dropping the old-parent check or dropping the lock (two sessions) reopen each attack. Swept and classified as non-defects: FIN-8's set rules, the per-row debit-xor-credit CHECK and MONEY-1's NaN rule are unchanged and pinned by `70_...`; tenant isolation (RLS and composite keys to the entry and the account) held; DELETE has no grant; the subscription gate is unchanged; read scope is tenant-wide, as for `chart_of_accounts`, and canon names no finer journal read (ADR-0021: a finance-read RLS decision); FIN-9's residue is now the platform writer alone; lines have no other producer or reader. **JE-2 remains OPEN** (a 100 USD debit still balances a 100 EGP credit, on both doors): one currency per entry or translation to a base currency is the accounting-model decision DC-11 owns. JE-5 is the `journal_entries` header's question and stays with that surface |
   ```
   with
   ```text
   | `journal_entry_lines` | **AUDITED** | ADVERSARIAL | `SPEC-245-a-journal-line-is-written-only-with-its-entry` | JE-2, JE-3, JE-4 | `145_a_journal_line_is_written_only_with_its_entry_test.sql` proves that a `finance_manager` holding CREATE_JOURNAL_ENTRY at aal2 is refused, by the missing grant, rewriting a posted entry balanced in another currency and backdated, moving a posted line onto a retired account or into another entry, and appending a balanced pair to a posted entry. Every entry still says what its `journal_entry_created` event says. The same actor at aal1 can neither post through the RPC nor rewrite at the table, an employee cannot post, and another tenant reads nothing. The RPC, now the lines' one writer, is definer with an empty search_path and still charges permission and step-up. Even the platform cannot empty an entry by moving its lines, while a move that leaves both entries balanced passes. `verify_journey_branches.ps1` proves the bulk append, the upsert rewrite and the PATCH at aal2 and aal1 refused over HTTP. Installed/restored mutations restoring either grant, returning the RPC to invoker, dropping the old-parent check or dropping the lock (two sessions) reopen each attack. Swept and classified as non-defects: FIN-8's set rules, the per-row debit-xor-credit CHECK and MONEY-1's NaN rule are unchanged and pinned by `70_...`; tenant isolation (RLS and composite keys to the entry and the account) held; DELETE has no grant; the subscription gate is unchanged; read scope is tenant-wide, as for `chart_of_accounts`, and canon names no finer journal read (ADR-0021: a finance-read RLS decision); FIN-9's residue is now the platform writer alone; lines have no other producer or reader. **JE-2 remains OPEN** (a 100 USD debit still balances a 100 EGP credit, on both doors): one currency per entry or translation to a base currency is the accounting-model decision DC-11 owns. JE-5 is the `journal_entries` header's question and stays with that surface **2026-11-22 (CRM SPEC-327):** `AUDITED`, because JE-2 is contained fail-closed in the gap register: `20261122100000` and `185_a_ledger_entry_balances_in_one_currency_and_a_payment_carries_value_test.sql` (with the updated `145_...`) prove that the deferred balance trigger refuses an entry mixing USD and EGP lines with 23514 on the RPC and on the platform's direct writes, while a balanced single-currency entry still posts on both, verified on CRM's Platinum Primary. DC-11 still decides the translation model, which replaces the refusal; JE-5 stays with `journal_entries`. **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |
   ```

   l) replace the line
   ```text
   | `leads` | **AUDITED** | ADVERSARIAL | `session-2026-09-08-batch6-slice9-leads` | LEAD-1, LEAD-2, LEAD-3, LEAD-4 | `109_lead_authority_and_lifecycle_test.sql` — 20 assertions, eight attack classes, two declared `N/A` with reasons. `202607061900` closed **LEAD-1** (High — BOOK-5's shape a third time, and the widest: `guard_write_capability` decided a FULL bypass from `new.assigned_user_id`, a column the attacker supplies), **LEAD-2** (a lead could be born `won`), **LEAD-3** (`converted` with no customer) and **LEAD-4** (`assigned → contacted` by hand, which removes the lead from `process_lead_sla`'s working set). `AUDITED` rather than `AUDITED-OPEN`: nothing on this surface is left open. The slice's own headline is a method finding — **two INCIDENTAL DEFENCES had been standing in for the authorization model**, and assertions 15-18 remove both before asking whether the guard holds |
   ```
   with
   ```text
   | `leads` | **AUDITED** | ADVERSARIAL | `session-2026-09-08-batch6-slice9-leads` | LEAD-1, LEAD-2, LEAD-3, LEAD-4 | `109_lead_authority_and_lifecycle_test.sql` — 20 assertions, eight attack classes, two declared `N/A` with reasons. `202607061900` closed **LEAD-1** (High — BOOK-5's shape a third time, and the widest: `guard_write_capability` decided a FULL bypass from `new.assigned_user_id`, a column the attacker supplies), **LEAD-2** (a lead could be born `won`), **LEAD-3** (`converted` with no customer) and **LEAD-4** (`assigned → contacted` by hand, which removes the lead from `process_lead_sla`'s working set). `AUDITED` rather than `AUDITED-OPEN`: nothing on this surface is left open. The slice's own headline is a method finding — **two INCIDENTAL DEFENCES had been standing in for the authorization model**, and assertions 15-18 remove both before asking whether the guard holds. **2026-11-21 (CRM SPEC-324):** `20261121100000` attaches archive authority at INSERT; `183_entry_and_step_up_hold_at_the_table_door_test.sql` proves an archive holder may create an archived lead with a reason and the archiver and time come from the server (ARCH-2) **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |
   ```

   m) replace the lines
   ```text
   | `otp_challenges` | **AUDITED-OPEN** | ADVERSARIAL | `session-2026-09-07-batch6-slice6-otp-challenges` | OTP-1, OTP-2, PAX-4 | `106_otp_challenge_subject_authority_test.sql` — 16 assertions, 3 classes declared `N/A` with reasons. `202607061600` closed **OTP-1** (the subject of a challenge could self-verify it, reset its own attempt counter, extend its expiry, redirect its delivery address and forge a pre-verified one — all reproduced at `aal1`). **The slice refuted its own premise:** the manifest predicted "correctly unguarded — pre-authentication", and `anon` holds no grant and matches no policy here, so the surface is INTRA-authentication (canon 34 § 7 makes OTP a second factor). `AUDITED-OPEN` because **OTP-2** is a security-policy decision (MFA self-disable at `aal1` on `totp_enrollments`), not engineering. **PAX-4 is listed because this slice corrected it**, not because it belongs to this table: 15 of its 20 "ungoverned" tables carry the capability check in RLS, so the uncovered set is five |
   | `passengers` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-223-frozen-traveller-identity-snapshot` | PAX-7, PAX-8 | `128_frozen_traveller_identity_snapshot_test.sql` proves a manifest entry derives its ticketed identity from the profile until the freeze and keeps it afterwards while the profile stays editable; an employee is refused rewriting, clearing, reasoned rewriting and swapping by `permission denied: CORRECT_PASSENGER_MANIFEST`; a correction holder needs a fresh reason and a kept name and is server-stamped; a finance manager can correct; swaps take the new traveller's identity; an installed/restored mutation shows the propagation trigger is load-bearing; it pins PAX-8 as still OPEN. |
   | `payment_allocations` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-264-an-allocation-spends-its-own-payment-on-its-own-invoice` | PAY-6, PAY-7, PAY-8, FIN-12, PAY-10, PAY-11, PAY-5, FIN-11 | `155_an_allocation_spends_its_own_payment_on_its_own_invoice_test.sql` proves that an `employee` holding neither RECORD_PAYMENT nor VIEW_FINANCIAL_DOCUMENTS, who sees the allocation only through an invoice on their booking, cannot re-point it to another invoice, payment, currency or creation time, and that a RECORD_PAYMENT holder cannot move paid money onto a draft invoice, while assigning the fixed fields their own values succeeds and the employee's amount change is still refused by FIN-3's guard; that at commit an allocation of a supplier payment (even at zero), in another currency than its payment's, to another customer's invoice, from a customer-less payment, or beyond its payment's amount is refused for every caller, the platform included, and that an allocated payment cannot shrink beneath, redirect, re-denominate or re-customer under its allocations, but can grow; that a cross-currency allocation needs the exact in-tenant rate for its pair and stores the derived invoice-currency value (8 USD at 50 is 400 EGP; 5000 EGP at 0.02 settles a 100 USD invoice exactly), that a rate on a same-currency allocation and another tenant's rate are refused, that a supplied converted amount is discarded, and that after a rate row is edited a touch that leaves the amount alone changes no money; that the invoice ceiling and `app.record_payment` count each allocation in the invoice's currency; that an allocation write holds the invoice's and the payment's advisory locks; that a `paid` invoice's settling allocation cannot be zeroed or reduced by 0.0001, and a `partially_paid` invoice's last money cannot be removed, by a signed-in owner or on the platform path, while a partial reduction and a zero-and-reallocate correction on an issued invoice succeed, and no status moves; and that every allocation, on the door and on `app.record_payment`, is born with one `payment_allocation_created` event carrying its payment, invoice, currency, rate and both amounts, every real amount change records one `payment_allocation_amount_changed` (`warning`) with both amounts before and after and its actor (NULL on the platform path), the IA → IC correction reads back from the events alone, a no-op and every refused write record nothing, and the employee reads exactly the events of the allocations they can read. A customer merge with allocated payments commits. Installed mutants M1—M37 are each killed; three two-session races (invoice, payment, floor) refuse the second writer, and with the invoice lock removed the floor race committed both removals. Swept and classified as non-defects: no DELETE grant for `anon`, `authenticated` or `service_role`, and the events are append-only (`service_role`'s TRUNCATE is platform-managed, PAR-5); another tenant's payment, invoice or rate is refused by the tenant-qualified foreign keys; PAY-1 on INSERT and `app.guard_invoice_void` are unchanged and held; `app.customer_balance` and `reporting.customer_outstanding` read payments, so no ledger moved; none of the seven readers of `public.events` names `payment_allocation`. **Remains open:** PAY-5 and FIN-11 (a door allocation leaves the invoice status where it was; FIN-7's package). **PAY-9**, found here, is a booking-balance defect recorded OPEN in the register. **Not decided:** a payment that has settled an invoice cannot be moved or shrunk, because canon 26 defines no unsettling transition (PAY-11's residual, an owner business-policy question). |
   | `payments` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-238-payment-is-recorded-on-every-door` | PAY-2, PAY-3, PAY-4 | `126_payment_write_capability_parity_test.sql` proves an employee who sees the payment but lacks RECORD_PAYMENT is refused by the guard's own message on direction, customer, supplier, booking, item, account, currency, method, paid time and rate, with both customers' balances unchanged; same-value assignments, reference edits, the owner's amount correction and a session-less guarded change still land. An installed amount-only mutant lets the same employee's direction, customer and currency rewrites persist and move real balances; the original function is restored byte-identically. **2026-09-28 (SPEC-238):** `140_payment_is_recorded_on_every_door_test.sql` closes **PAY-3** — one deferred-trigger creation event per customer or supplier payment on the RPC, table and platform doors (refund directions stay PAY-4's), `payment_recorded` for customer and `supplier_payment_recorded` for supplier payments, with an in-file mutation. **PAY-4 remains OPEN.** |
   ```
   with
   ```text
   | `otp_challenges` | **AUDITED-OPEN** | ADVERSARIAL | `session-2026-09-07-batch6-slice6-otp-challenges` | OTP-1, OTP-2, PAX-4, AUTH-1 | `106_otp_challenge_subject_authority_test.sql` — 16 assertions, 3 classes declared `N/A` with reasons. `202607061600` closed **OTP-1** (the subject of a challenge could self-verify it, reset its own attempt counter, extend its expiry, redirect its delivery address and forge a pre-verified one — all reproduced at `aal1`). **The slice refuted its own premise:** the manifest predicted "correctly unguarded — pre-authentication", and `anon` holds no grant and matches no policy here, so the surface is INTRA-authentication (canon 34 § 7 makes OTP a second factor). **OTP-2** resolved by derivation on 2026-09-08. SPEC-259 adds the TOTP non-authority proof. `AUDITED-OPEN` carries **AUTH-1** retirement before the first client-facing authentication build or first reference, whichever comes first. **PAX-4 is listed because this slice corrected it**, not because it belongs to this table: 15 of its 20 "ungoverned" tables carry the capability check in RLS, so the uncovered set is five |
   | `passengers` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-223-frozen-traveller-identity-snapshot` | PAX-7, PAX-8, ARCH-2 | `128_frozen_traveller_identity_snapshot_test.sql` proves a manifest entry derives its ticketed identity from the profile until the freeze and keeps it afterwards while the profile stays editable; an employee is refused rewriting, clearing, reasoned rewriting and swapping by `permission denied: CORRECT_PASSENGER_MANIFEST`; a correction holder needs a fresh reason and a kept name and is server-stamped; a finance manager can correct; swaps take the new traveller's identity; an installed/restored mutation shows the propagation trigger is load-bearing; it pins PAX-8 as still OPEN. CRM SPEC-319 and `182_archive_authority_applies_at_entry_test.sql` verify the ARCH-2 passenger member on CRM's Platinum Primary. PAX-8 remains open. |
   | `payment_allocations` | **AUDITED** | ADVERSARIAL | `SPEC-264-an-allocation-spends-its-own-payment-on-its-own-invoice` | PAY-6, PAY-7, PAY-8, FIN-12, PAY-10, PAY-11, PAY-5, FIN-11 | `155_an_allocation_spends_its_own_payment_on_its_own_invoice_test.sql` proves that an `employee` holding neither RECORD_PAYMENT nor VIEW_FINANCIAL_DOCUMENTS, who sees the allocation only through an invoice on their booking, cannot re-point it to another invoice, payment, currency or creation time, and that a RECORD_PAYMENT holder cannot move paid money onto a draft invoice, while assigning the fixed fields their own values succeeds and the employee's amount change is still refused by FIN-3's guard; that at commit an allocation of a supplier payment (even at zero), in another currency than its payment's, to another customer's invoice, from a customer-less payment, or beyond its payment's amount is refused for every caller, the platform included, and that an allocated payment cannot shrink beneath, redirect, re-denominate or re-customer under its allocations, but can grow; that a cross-currency allocation needs the exact in-tenant rate for its pair and stores the derived invoice-currency value (8 USD at 50 is 400 EGP; 5000 EGP at 0.02 settles a 100 USD invoice exactly), that a rate on a same-currency allocation and another tenant's rate are refused, that a supplied converted amount is discarded, and that after a rate row is edited a touch that leaves the amount alone changes no money; that the invoice ceiling and `app.record_payment` count each allocation in the invoice's currency; that an allocation write holds the invoice's and the payment's advisory locks; that a `paid` invoice's settling allocation cannot be zeroed or reduced by 0.0001, and a `partially_paid` invoice's last money cannot be removed, by a signed-in owner or on the platform path, while a partial reduction and a zero-and-reallocate correction on an issued invoice succeed, and no status moves; and that every allocation, on the door and on `app.record_payment`, is born with one `payment_allocation_created` event carrying its payment, invoice, currency, rate and both amounts, every real amount change records one `payment_allocation_amount_changed` (`warning`) with both amounts before and after and its actor (NULL on the platform path), the IA → IC correction reads back from the events alone, a no-op and every refused write record nothing, and the employee reads exactly the events of the allocations they can read. A customer merge with allocated payments commits. Installed mutants M1—M37 are each killed; three two-session races (invoice, payment, floor) refuse the second writer, and with the invoice lock removed the floor race committed both removals. Swept and classified as non-defects: no DELETE grant for `anon`, `authenticated` or `service_role`, and the events are append-only (`service_role`'s TRUNCATE is platform-managed, PAR-5); another tenant's payment, invoice or rate is refused by the tenant-qualified foreign keys; PAY-1 on INSERT and `app.guard_invoice_void` are unchanged and held; `app.customer_balance` and `reporting.customer_outstanding` read payments, so no ledger moved; none of the seven readers of `public.events` names `payment_allocation`. **Remains open:** PAY-5 and FIN-11 (a door allocation leaves the invoice status where it was; FIN-7's package). **PAY-9**, found here, is a booking-balance defect recorded OPEN in the register. **Not decided:** a payment that has settled an invoice cannot be moved or shrunk, because canon 26 defines no unsettling transition (PAY-11's residual, an owner business-policy question). **2026-11-21 (CRM SPEC-326):** `AUDITED`, because PAY-5 and FIN-11 are fixed in the gap register: `20261121110000` and `184_refund_conversation_and_settlement_are_recorded_on_every_door_test.sql` prove that a door allocation settles its invoice `partially_paid` or `paid` under the per-invoice lock, that a zero or lowered allocation never walks a settlement back, and that each settlement is recorded once on either door after the allocation that caused it, naming its payment, verified on CRM's Platinum Primary. PAY-9 stays the booking-balance unit in the register and PAY-11's residual stays an owner policy question. **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |
   | `payments` | **AUDITED** | ADVERSARIAL | `SPEC-238-payment-is-recorded-on-every-door` | PAY-2, PAY-3, PAY-4 | `126_payment_write_capability_parity_test.sql` proves an employee who sees the payment but lacks RECORD_PAYMENT is refused by the guard's own message on direction, customer, supplier, booking, item, account, currency, method, paid time and rate, with both customers' balances unchanged; same-value assignments, reference edits, the owner's amount correction and a session-less guarded change still land. An installed amount-only mutant lets the same employee's direction, customer and currency rewrites persist and move real balances; the original function is restored byte-identically. **2026-09-28 (SPEC-238):** `140_payment_is_recorded_on_every_door_test.sql` closes **PAY-3** — one deferred-trigger creation event per customer or supplier payment on the RPC, table and platform doors (refund directions stay PAY-4's), `payment_recorded` for customer and `supplier_payment_recorded` for supplier payments, with an in-file mutation. **PAY-4 remains OPEN.** **2026-11-22 (CRM SPEC-327):** `AUDITED`, because PAY-4 is fixed in the gap register: `20261122100000` adds the validated `payments_amount_positive_check` (`amount > 0`) and `185_...` proves a zero `customer_refund` row refused at the table door for the owner at aal2 and for the platform, a recorded payment that cannot be emptied to zero, the smallest positive amount and `app.record_payment` still accepted, verified on CRM's Platinum Primary. **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |
   ```

   n) replace the line
   ```text
   | `quotations` | **PARTIAL** | ADVERSARIAL | `SPEC-214-quotation-door-parity` | QUO-5, QUO-6, QUO-7, QUO-8 | The table door's lifecycle state, commercial terms, authority contrast and tenant boundary were swept and **QUO-5** to **QUO-8** closed: `120_quotation_door_parity_test.sql` pins them with 30 assertions, an `employee` carrying DENY on SEND_QUOTATION and ACCEPT_QUOTATION so no permission can be the refuser, and an in-file mutation control. Four axes remain unclassified by choice and are named here rather than registered: (1) event parity for direct-DML creation and transitions (canon 26's Required Events); (2) reassignment of `owner_user_id`, `lead_id` and `quotation_number` by any CREATE_QUOTATION holder who can see the row, which no RPC offers and canon does not decide (BOOK-9's question on another surface); (3) the `quotations` instance of **ARCH-2** (a row born archived), reproduced in this slice and owned by ARCH-2's row; (4) direct writes to `sent_at`, `accepted_at` and `rejected_at`, probed and found to have no reader |
   ```
   with
   ```text
   | `quotations` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-214-quotation-door-parity` | QUO-5, QUO-6, QUO-7, QUO-8, QUO-11, QUO-12 | The table door's lifecycle state, commercial terms, authority contrast and tenant boundary were swept and **QUO-5** to **QUO-8** closed: `120_quotation_door_parity_test.sql` pins them with 30 assertions, an `employee` carrying DENY on SEND_QUOTATION and ACCEPT_QUOTATION so no permission can be the refuser, and an in-file mutation control. Four axes were left unclassified by choice and are named here rather than registered: (1) event parity for direct-DML creation and transitions (canon 26's Required Events); (2) reassignment of `owner_user_id`, `lead_id` and `quotation_number` by any CREATE_QUOTATION holder who can see the row, which no RPC offers and canon does not decide (BOOK-9's question on another surface); (3) the `quotations` instance of **ARCH-2** (a row born archived), reproduced in this slice and owned by ARCH-2's row; (4) direct writes to `sent_at`, `accepted_at` and `rejected_at`, probed and found to have no reader. **2026-11-21 (CRM SPEC-324):** axis (3) is closed: `20261121100000` attaches archive authority at INSERT and `183_entry_and_step_up_hold_at_the_table_door_test.sql` proves the refusal without ARCHIVE_RECORD. Axes (1), (2) and (4) remain, so the surface stays `PARTIAL`. **2026-11-23 (CRM SPEC-335):** `AUDITED-OPEN`: axes (1) and (4) are **QUO-11** (`ENABLE-SURFACE-WORKFLOW`), axis (2) is **QUO-12** (`ENABLE-CRM`), and the caller-writable `created_at` is **STAMP-1**; `194_door_evidence_and_sale_dates_open_pins_test.sql` pins QUO-11 and QUO-12 OPEN **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |
   ```

   o) replace the line
   ```text
   | `refunds` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-217-refund-door-integrity` | RFD-1, RFD-2, RFD-3 | `123_refund_door_integrity_test.sql` proves real-row visibility, absent RECORD_REFUND, unchanged balance after refused direction and currency changes, the RPC's three-event lifecycle, allowed direct customer and supplier paths, the requested positive entry rule, server-derived completion, MFA and tenant boundaries. SPEC-217 closes **RFD-1**, **RFD-2** and the `refunds` instance of **ENTRY-1** with one refund-local guard; catalog, subscription, status-transition and creator-attribution controls remain. **RFD-3 remains OPEN:** a legal authorized direct status progression still emits no refund event; changing event authority while retaining RPC `p_reason` is a separate repair. `authenticated` has no DELETE grant. |
   ```
   with
   ```text
   | `refunds` | **AUDITED** | ADVERSARIAL | `SPEC-217-refund-door-integrity` | RFD-1, RFD-2, RFD-3 | `123_refund_door_integrity_test.sql` proves real-row visibility, absent RECORD_REFUND, unchanged balance after refused direction and currency changes, the RPC's three-event lifecycle, allowed direct customer and supplier paths, the requested positive entry rule, server-derived completion, MFA and tenant boundaries. SPEC-217 closes **RFD-1**, **RFD-2** and the `refunds` instance of **ENTRY-1** with one refund-local guard; catalog, subscription, status-transition and creator-attribution controls remain. **RFD-3 remains OPEN:** a legal authorized direct status progression still emits no refund event; changing event authority while retaining RPC `p_reason` is a separate repair. `authenticated` has no DELETE grant. **2026-11-21 (CRM SPEC-326):** `AUDITED`, because RFD-3 is fixed in the gap register: `20261121110000` and `184_refund_conversation_and_settlement_are_recorded_on_every_door_test.sql` prove that the table door records a refund's request, approval and completion once each under the caller, that the RPC door records the same three acts once each with its reasons, and that `completed_at` is server-stamped on both doors, verified on CRM's Platinum Primary. **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |
   ```

   p) replace the lines
   ```text
   | `suppliers` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-215-supplier-creation-is-recorded` | SUP-5, ARCH-2 | `121_supplier_creation_is_recorded_test.sql` — 21 assertions and an in-file mutation control. `20260924130000` closed **SUP-5** (Medium — a supplier created at the table door recorded nothing, while the RPC recorded the same act; the table has no creator column, so the event is the only attribution). `AUDITED-OPEN` because **ARCH-2**'s `suppliers` instance — a row born archived by a user without ARCHIVE_RECORD — was reproduced in this slice and stays with ARCH-2's row. **Swept and classified as non-defects, not registered:** tenant relocation and planting (refused by RLS); archive authority and attribution on UPDATE (`app.enforce_archive_authority`); both doors agreeing at `aal1`; a blank name and a case-variant duplicate at the table door (a name is freely editable there and the RPC itself admits a near-variant, so neither changes what an ASSIGN_SUPPLIER holder can do); and `is_internal` / `internal_branch_id` / `internal_department_id`, which nothing reads. Whether an archived supplier may still be assigned new work is a rule no code or canon states, and belongs to `booking_items`' supplier assignment rather than to this table |
   | `tasks` | **AUDITED-OPEN** | ADVERSARIAL | `SPEC-230-task-queue-authority` | TASK-4, ENTRY-1, ARCH-2 | `134_task_queue_authority_test.sql` proves that an employee holding CREATE_TASK and COMPLETE_TASK but not ASSIGN_TASK is refused moving its own task's department, branch or both at the table, as `app.assign_task` refuses it, and the task stays in its department manager's queue; handing it to a colleague stays refused (TASK-1). The owner still edits, re-prioritises, reschedules and starts its own task, an ASSIGN_TASK holder moves it on both doors, and the session-less platform path is exempt. Another tenant can be neither planted into nor updated, DELETE has no grant, a trainee cannot create, an `aal1` owner is refused step-up at the table, and a user denied COMPLETE_TASK is refused completion on both doors. An installed/restored pre-repair guard lets the move land and the manager lose sight. It pins the `tasks` instances of **ENTRY-1** (the denied user creates a task born `completed` with no completion time) and **ARCH-2** (a user without ARCHIVE_RECORD creates a task born archived under the owner's name) as OPEN defects, not desired behaviour; those assertions fail when either is repaired. Swept and classified as non-defects: nothing outside the three task RPCs reads a task and no table references one; `completed_at` is caller-writable at the table and read by nothing; a department-queue member working a colleague's queued task is what both doors allow (`app.advance_task` checks no ownership); direct creation and transitions emit no task event, CAMP-4's shape, and nothing reads task events; `created_at` is SPEC-216's schema-wide question; the related-entity reference is existence-checked in the row's own tenant |
   ```
   with
   ```text
   | `suppliers` | AUDITED | ADVERSARIAL | `SPEC-215-supplier-creation-is-recorded` | SUP-5, ARCH-2 | `121_supplier_creation_is_recorded_test.sql` — 21 assertions and an in-file mutation control. `20260924130000` closed **SUP-5** (Medium — a supplier created at the table door recorded nothing, while the RPC recorded the same act; the table has no creator column, so the event is the only attribution). CRM SPEC-319, migration `20261119203357` and `182_archive_authority_applies_at_entry_test.sql` close the supplier ARCH-2 member with verified CRM's Platinum Primary parity. **Swept and classified as non-defects, not registered:** tenant relocation and planting (refused by RLS); archive authority and attribution on UPDATE (`app.enforce_archive_authority`); both doors agreeing at `aal1`; a blank name and a case-variant duplicate at the table door (a name is freely editable there and the RPC itself admits a near-variant, so neither changes what an ASSIGN_SUPPLIER holder can do); and `is_internal` / `internal_branch_id` / `internal_department_id`, which nothing reads. Whether an archived supplier may still be assigned new work is a rule no code or canon states, and belongs to `booking_items`' supplier assignment rather than to this table **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |
   | `tasks` | AUDITED | ADVERSARIAL | `SPEC-230-task-queue-authority` | TASK-4, ENTRY-1, ARCH-2 | `134_task_queue_authority_test.sql` proves that an employee holding CREATE_TASK and COMPLETE_TASK but not ASSIGN_TASK is refused moving its own task's department, branch or both at the table, as `app.assign_task` refuses it, and the task stays in its department manager's queue; handing it to a colleague stays refused (TASK-1). The owner still edits, re-prioritises, reschedules and starts its own task, an ASSIGN_TASK holder moves it on both doors, and the session-less platform path is exempt. Another tenant can be neither planted into nor updated, DELETE has no grant, a trainee cannot create, an `aal1` owner is refused step-up at the table, and a user denied COMPLETE_TASK is refused completion on both doors. An installed/restored pre-repair guard lets the move land and the manager lose sight. For the `tasks` member of **ENTRY-1**, CRM SPEC-318 (migration `20261119112137`, verified on CRM's Platinum Primary) adds the INSERT guard and Test 134 proves refusal of `completed` and `cancelled`, ordinary open creation and absence of rejected rows. CRM SPEC-319 closes the task ARCH-2 member. Tests 134 and 182 prove archive refusal, absence of the refused row and server attribution, with migration `20261119203357` and verified CRM's Platinum Primary parity. Swept and classified as non-defects: nothing outside the three task RPCs reads a task and no table references one; `completed_at` is caller-writable at the table and read by nothing; a department-queue member working a colleague's queued task is what both doors allow (`app.advance_task` checks no ownership); direct creation and transitions emit no task event, CAMP-4's shape, and nothing reads task events; `created_at` is SPEC-216's schema-wide question; the related-entity reference is existence-checked in the row's own tenant **In ORVION:** SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319. |
   ```

   The resulting file's Git blob is 0c091d6bf8793f26f2943ef522269ac7bd79aa06.

39. Check whether `_ORVION_CANONICAL/manifest.md` contains `**OD-8**, **CTRL-19**`; if so record Already Applied when its Git blob is e901d7d335acffc349a5d1795db8378294a11ac6, and otherwise stop and report. Otherwise make exactly this one edit (the open owner decisions without OD-9 (decided AFTER)), each matched once, and change nothing else:

   a) replace the line
   ```text
   Open owner decisions — **MAIL-1**, **RET-1**, **PH8-10**, **OD-1**, **OD-2**, **OD-3**, **OD-5**, **OD-8**, **OD-9**, **CTRL-19**. The OD rows are proposed product decisions awaiting the owner, each with its default in the register. MAIL-1, RET-1 and PH8-10 are exact external prerequisites, not unresolved architecture: MAIL-1 has technically selected Resend but production activation still requires owner authorization and counsel/PDPC confirmation for the actual cross-border destination; RET-1's retention/closure architecture and legal-hold override are implemented, while counsel must supply the actual per-type periods as tenant configuration; PH8-10 awaits Google evidence that click-less phone conversions are credited. No email is sent and no retention policy is seeded while those prerequisites remain. CTRL-19 is GitHub configuration only the owner can make.
   ```
   with
   ```text
   Open owner decisions — **MAIL-1**, **RET-1**, **PH8-10**, **OD-1**, **OD-2**, **OD-3**, **OD-5**, **OD-8**, **CTRL-19**. The OD rows are proposed product decisions awaiting the owner, each with its default in the register. MAIL-1, RET-1 and PH8-10 are exact external prerequisites, not unresolved architecture: MAIL-1 has technically selected Resend but production activation still requires owner authorization and counsel/PDPC confirmation for the actual cross-border destination; RET-1's retention/closure architecture and legal-hold override are implemented, while counsel must supply the actual per-type periods as tenant configuration; PH8-10 awaits Google evidence that click-less phone conversions are credited. No email is sent and no retention policy is seeded while those prerequisites remain. CTRL-19 is GitHub configuration only the owner can make.
   ```

   The resulting file's Git blob is e901d7d335acffc349a5d1795db8378294a11ac6.

40. **Check** for a `Pre-deploy readiness gate` Execution Log entry. If absent, with Steps 1–39 applied and uncommitted in the main checkout:
    - Prove the five pinned baseline identities with CRM `6b28051`, and that every path and Git blob under `supabase/migrations` and `supabase/tests` equals CRM `15bff27`, with exact hashes and lengths of the seven migrations. CRM's focused tests, probes, mutants and causal negatives are adopted by this identity.
    - Reset this product's local stack with its own pinned CLI. Confirm local ledger 277 and the structural surfaces CRM recorded for 277. Regenerate the API contract and require its output to equal CRM blob `62af74be28b058e41b6b6bcfbe43457f15acfd33`. Check generated discovery, scope, Git diff and consistency.
    - The only expected consistency issues before applying the migrations on Founder and refreshing evidence are the six measured-state items in Consumer Closure.
    - Read the authenticated Founder project URL, full ordered ledger with all seven targets absent, all ten surfaces and the business counts, and record the expected delta. Stop on any difference.
41. **Check** that an exact-SHA Gate-2 record for the seven migrations is in the Execution Log. It is either the owner's own, or one marked DELEGATED that names this contract, each migration's SHA-256, Founder Secondary `brplkqmbzffpxqgkkdzo` and the owner's instructions under which it is taken. If it is absent, write it only when Step 40 passed and those instructions cover migrations that drop no table or column and delete or rewrite no business row. Otherwise stop after Step 40 and present the Gate-2 package.
42. **Check** which of the seven migrations Founder Secondary `brplkqmbzffpxqgkkdzo` lacks. If Step 41 is recorded, deploy them in one sitting, serially in ledger order:
    - Immediately re-read HEAD, the hashes, the project URL, the full ordered ledger, the targets' absence and the business counts.
    - For each migration in order: prove the transmitted text's md5 server-side, then apply only that migration through the Founder write connector after its project URL matches Founder Secondary.
    - If the connector assigns a temporary version, rename only that one newly inserted ledger row. The rename requires exactly one new row, its stored statement md5 equal to the file's, and no existing target version.
    - If a migration fails, stop: apply nothing further.

    Then read fresh through the authenticated Founder connector using the evidence file's exact ledger and surface read queries: the ledger, function surface and all ten structural surfaces, and the business counts. Never contact Platinum Primary `vrvtsxexkiiiivlkdxzp`.
43. **Check** that fresh Founder evidence contains each of the seven migrations exactly once. If so:
    - Update `reports/evidence/founder-ledger-evidence.json` schema 3 from those readings only. Keep the exact recorded ledger and surface read queries, record the Founder connector, project URL, observed UTC, current HEAD and live ledger and surface rows. Both native Founder evidence validators must pass.
    - In `_ORVION_CANONICAL/manifest.md`, set `Live state` from the same readings in its existing Founder format, with 80 client RPCs.
    - Confirm that `supabase/tests` holds 198 files whose literal `plan(N)` values sum to 3960, then set `Suite **198 files / 3960 assertions**`. If either differs, stop.
    - In the register (11 spans) and the disposition (14 spans), replace each `SPEC-319 adopts this by identity; Founder Secondary deployment pending under SPEC-319.` with `SPEC-319 adopts this by identity, DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-319.` Change nothing else in either file.
    - Regenerate `MASTER_API_CONTRACT.md` with the canonical generator, which must leave it equal to CRM blob `62af74be28b058e41b6b6bcfbe43457f15acfd33`, and regenerate `ai-map.json` and `repository-index.md` (stored LF) with the canonical generator.
    - Set the Runtime Checkpoint to DONE, append the Execution Log, and commit the implementation once. The pre-commit Gate must admit it.

    If Founder is unproven, stop.
44. **Check** for a `Post-deploy local certification` Execution Log entry. If absent:
    - Run canonical `-Finish` through `scripts/run_timed.ps1`, watched by `scripts/watch_run.ps1`, and require `LOCAL_CERTIFY: READY`.
    - Independently Review the committed implementation against every Acceptance Criterion. After `Verdict: Confirmed Complete`, make the Complete commit:
      - transition to Complete and tick the Acceptance Criteria and the Review Gate;
      - clear `Active Change Request` and set `Last Completed` from Notes;
      - leave `Next capability` and `Current Module` unchanged;
      - regenerate `ai-map.json` and `repository-index.md` LF.
    - Bind the exact candidate with `-Gate -BindCandidate`. Publication and promotion follow the native release path separately.

## Acceptance Criteria

- [ ] Migration 1 is the frozen bytes; `check: blob supabase/migrations/20261119054533_use_customer_preference_catalog_on_registration.sql 648f35f2ba93a9c69c42b989f1be6e8ddb6152eb`
- [ ] Migration 2 is the frozen bytes; `check: blob supabase/migrations/20261119112137_guard_task_terminal_status_at_entry.sql e4864c7bf2c4dc9c9ce07f79e9c0e4a389d98a5d`
- [ ] Migration 3 is the frozen bytes; `check: blob supabase/migrations/20261119203357_archive_authority_applies_at_entry.sql ec8e125c0b20c282cacaad51d1a05a429039aaaf`
- [ ] Migration 4 is the frozen bytes; `check: blob supabase/migrations/20261120122927_branch_write_authority_matches_the_rpc.sql ea92b491bf33a69377921ba84d76daf11abd8770`
- [ ] Migration 5 is the frozen bytes; `check: blob supabase/migrations/20261121100000_entry_and_step_up_hold_at_the_table_door.sql fc317dda36df2d5540bad2ba6afcabbf9d2e8867`
- [ ] Migration 6 is the frozen bytes; `check: blob supabase/migrations/20261121110000_a_refund_a_conversation_and_a_settlement_are_recorded_on_every_door.sql 52bb1f1577f4346b439a1c33c47b233de5d4935d`
- [ ] Migration 7 is the frozen bytes; `check: blob supabase/migrations/20261122100000_a_ledger_entry_balances_in_one_currency_and_a_payment_carries_value.sql 606ce8ad8a5d8bf928cb11b920fbae0e79714a9b`
- [ ] Test 182 is the frozen bytes; `check: blob supabase/tests/182_archive_authority_applies_at_entry_test.sql 5ffffdeb43e3ae777957cafbb35fac99fdbc2e48`
- [ ] Test 183 is the frozen bytes; `check: blob supabase/tests/183_entry_and_step_up_hold_at_the_table_door_test.sql d11dea50c36e8dcc1e418251125358ad0377e87b`
- [ ] Test 184 is the frozen bytes; `check: blob supabase/tests/184_refund_conversation_and_settlement_are_recorded_on_every_door_test.sql be2fc2e45076505879939d0a8accc0fa0f28656b`
- [ ] Test 185 is the frozen bytes; `check: blob supabase/tests/185_a_ledger_entry_balances_in_one_currency_and_a_payment_carries_value_test.sql 67a626e1efa1d1f69109bd107bb8cfe3ae6141af`
- [ ] Test 186 is the frozen bytes; `check: blob supabase/tests/186_every_permission_is_enforced_and_every_table_states_its_isolation_basis_test.sql 167a93e4abbb497b2856c323b193a449480489e3`
- [ ] Test 187 is the frozen bytes; `check: blob supabase/tests/187_every_ceiling_is_a_named_membership_and_no_mechanism_is_orphaned_test.sql 4b7acb723de2ecea6b5ea08190af4b5161566ad3`
- [ ] Test 188 is the frozen bytes; `check: blob supabase/tests/188_every_business_key_is_unique_and_every_event_type_is_registered_test.sql fb389022d81120ed9578fcd721447ed146f6023d`
- [ ] Test 189 is the frozen bytes; `check: blob supabase/tests/189_a_contact_method_change_is_refused_at_the_update_door_test.sql 85f9d02296a20357411b5df659b9eeab9bb3d36e`
- [ ] Test 190 is the frozen bytes; `check: blob supabase/tests/190_constraint_refusals_test.sql 8ae13da46d8ced91c652dfcaec13dba2f7546f3f`
- [ ] Test 191 is the frozen bytes; `check: blob supabase/tests/191_trigger_enforcer_refusals_test.sql e75f8c0425431f68ddb85e1e17f03611b07c3008`
- [ ] Test 192 is the frozen bytes; `check: blob supabase/tests/192_a_customer_lock_is_taken_before_its_judgement_test.sql 00d4d776f17ad411f4499ad454d446e0ac772623`
- [ ] Test 193 is the frozen bytes; `check: blob supabase/tests/193_structural_control_presence_test.sql 472b404c67b1656b5c0013bbbb86f1b7a2e33b4a`
- [ ] Test 194 is the frozen bytes; `check: blob supabase/tests/194_door_evidence_and_sale_dates_open_pins_test.sql 0390d2a92ead6a69ff20e2276332adfc9a036c4c`
- [ ] Test 195 is the frozen bytes; `check: blob supabase/tests/195_every_tenant_function_refuses_a_caller_with_no_active_tenant_test.sql e18dadc093b8ec000e75242f92bc204a58c289fd`
- [ ] Test 196 is the frozen bytes; `check: blob supabase/tests/196_each_function_refusal_is_reached_by_a_call_test.sql ed6542eebeee21869968c6a113ad22430f504450`
- [ ] Test 197 is the frozen bytes; `check: blob supabase/tests/197_each_prepared_state_refusal_is_reached_test.sql 05dc8925972f07f939a2520a8213615b6e7b5ac5`
- [ ] Test 198 is the frozen bytes; `check: blob supabase/tests/198_each_trigger_refusal_is_reached_test.sql 4865e7f8d5d7859d333965f83af04e07f2c5fa3f`
- [ ] Test 54 is the frozen bytes; `check: blob supabase/tests/54_transition_permission_parity_test.sql c4b1b3e8549fd8820ae39eeda99c3e9edcb1dda7`
- [ ] Test 58 is the frozen bytes; `check: blob supabase/tests/58_write_grants_and_config_capability_test.sql 68f4e874e55af952e5e2e8034dd334e347ea935c`
- [ ] Test 79 is the frozen bytes; `check: blob supabase/tests/79_customer_data_integrity_test.sql efe552ad654dbfcfa1d7921b564799e9bc271f7d`
- [ ] Test 96 is the frozen bytes; `check: blob supabase/tests/96_invoice_void_and_eta_boundary_test.sql 72e2107b07178f352a634606fcbd7173bdf39a23`
- [ ] Test 101 is the frozen bytes; `check: blob supabase/tests/101_marketing_metrics_and_fx_adjustment_surface_test.sql 2b86d7be04a4a337d387ff60da68789caa9c9ca6`
- [ ] Test 106 is the frozen bytes; `check: blob supabase/tests/106_otp_challenge_subject_authority_test.sql 02adabd5182f9515a5c1ff17bbaf6431fb083519`
- [ ] Test 130 is the frozen bytes; `check: blob supabase/tests/130_branch_door_audit_test.sql 1100910b9540ce32e32d691bb215f11fa74bdecd`
- [ ] Test 134 is the frozen bytes; `check: blob supabase/tests/134_task_queue_authority_test.sql a8c0ef7d4a916bfbcef68668691b4028a0d8c27a`
- [ ] Test 140 is the frozen bytes; `check: blob supabase/tests/140_payment_is_recorded_on_every_door_test.sql d132e48e82f068588148df658d9eeedc4d2b15d7`
- [ ] Test 145 is the frozen bytes; `check: blob supabase/tests/145_a_journal_line_is_written_only_with_its_entry_test.sql 926f2eac4f1c96b5a5814a9c134115d34343e253`
- [ ] Test 155 is the frozen bytes; `check: blob supabase/tests/155_an_allocation_spends_its_own_payment_on_its_own_invoice_test.sql f85481f019a59ea756ba93a056140cc3576fc423`
- [ ] The plan carries CRM's rows with In ORVION notes; `check: blob reports/master/MASTER_EXECUTION_PLAN.md 9daac0e7c21aa73445b3e0c99412621177e5db05`
- [ ] The register rows are deployed; `check: has reports/master/MASTER_GAP_REGISTER.md "DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-319"`
- [ ] The disposition rows are deployed; `check: has reports/master/MASTER_SURFACE_DISPOSITION.md "DEPLOYED to Founder Secondary under the exact-SHA Gate-2 record of SPEC-319"`
- [ ] The manifest suite figure equals the files; `check: has _ORVION_CANONICAL/manifest.md "Suite **198 files / 3960 assertions**"`
- [ ] Native evaluator remains exact; `check: same scripts/check_agent_continuity.ps1 @367cdf3da293745a573c6c7df0bbc3fd962322a5`
- [ ] The smoke script remains exact; `check: same scripts/verify_database.sql @367cdf3da293745a573c6c7df0bbc3fd962322a5`
- [ ] The parity query remains exact; `check: same scripts/parity_surface.sql @367cdf3da293745a573c6c7df0bbc3fd962322a5`
- [ ] Founder Secondary `brplkqmbzffpxqgkkdzo` received only the seven authorized migrations, serially, with at most one guarded ledger rename each and no business-data write, after a recorded Step 40 readiness gate and Step 41 Gate-2 record. Platinum Primary `vrvtsxexkiiiivlkdxzp` was never contacted.
- [ ] Baseline and payload identity with CRM `15bff27` is proven and binds CRM's probes, mutants and causal negatives to the same product SQL here.

## Execution Log

None.

## Verification Notes

None.

## Review Gate

- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [ ] No file outside Write Scope was modified, created, or deleted.
- [ ] No section was added, removed, or restructured outside the approved steps.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] Any step that could not be resolved deterministically was reported, not guessed.
- [ ] If this Change Request's Supersedes / Depends On section names another file, that file's Status has been updated accordingly.
- [ ] The repository is in a clean, releasable state.

## Notes

After actual native Finish and truthful Review, synchronize only this contract and the declared manifest/discovery paths to Complete. Set `Last Completed: **SPEC-319: Batch 6 exit bundle M — the Founder twin of CRM SPEC-316 to SPEC-340, seven migrations and twenty-eight tests adopted by identity, deployed to Founder Secondary; native verification and Review complete. Publication/promotion remain separately governed.**` and regenerate discovery. `Next capability` and `Current Module` stay unchanged. Candidate binding follows Complete and is never a pre-Complete criterion.

Exact baseline 367cdf3da293745a573c6c7df0bbc3fd962322a5 and source anchors:

| Path | Baseline Git blob |
| --- | --- |
| `supabase/tests/54_transition_permission_parity_test.sql` | `05fb9a92860d4c1f305eb44f999cd27993812fe9` |
| `supabase/tests/58_write_grants_and_config_capability_test.sql` | `3cf87dbf6be695d2b3da79b06216ebf63a2af108` |
| `supabase/tests/79_customer_data_integrity_test.sql` | `fa01969b1adf6c0547274ecc6bcf69681966b09e` |
| `supabase/tests/96_invoice_void_and_eta_boundary_test.sql` | `dfa0b23e384fe29ec369008f4a60b419dc9a3b28` |
| `supabase/tests/101_marketing_metrics_and_fx_adjustment_surface_test.sql` | `9d5f3784082bac2db3f047701c49116c76bb1d74` |
| `supabase/tests/106_otp_challenge_subject_authority_test.sql` | `c2a36860a5d19be926b3e7a30a42d55b7a31d0ff` |
| `supabase/tests/130_branch_door_audit_test.sql` | `7ef0d7049ced476e17b5cfaddcb0c9456cc841d7` |
| `supabase/tests/134_task_queue_authority_test.sql` | `9ffa7c4159154176b8c862824d790fe78a451765` |
| `supabase/tests/140_payment_is_recorded_on_every_door_test.sql` | `0f027d1ab4b873b3eae178166d73909a3476232d` |
| `supabase/tests/145_a_journal_line_is_written_only_with_its_entry_test.sql` | `26176d95881764bd6e6becc3bdaeca007f9befe6` |
| `supabase/tests/155_an_allocation_spends_its_own_payment_on_its_own_invoice_test.sql` | `d48cccf93cc1b20aa24bf3385704e1e8b712f0eb` |
| `reports/master/MASTER_EXECUTION_PLAN.md` | `e957b949bc330cb637a634644664bf93bd2eb5ce` |
| `reports/master/MASTER_GAP_REGISTER.md` | `d5ab36fe9a1084712c92dbe78fceb7fe776f9e83` |
| `reports/master/MASTER_SURFACE_DISPOSITION.md` | `97d3934df8db0f810525f9e123113071efc1194e` |
| `_ORVION_CANONICAL/manifest.md` | `d4083d294f099a662ce932851be57aa98884567a` |

Selection sources: native AGENTS.md, CR_LIFECYCLE.md and ENGINEERING_METHOD.md; CRM SPEC-316 to SPEC-340 at `15bff27`; the owner's instructions of 2026-11-21, 2026-11-23 and 2026-11-24 (recorded outside this repository). This is the one Draft for this catch-up, finalized after the adversarial review and the evidence refresh that its Draft Assurance records. Correctness remains native and independent.
