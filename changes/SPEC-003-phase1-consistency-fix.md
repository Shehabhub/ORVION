# Change Request — SPEC-003

## Status

[x] Draft

---

## Assigned Model Tier

[x] Tier 2 — Local execution agent (Qwen3.8B)
    Permitted modes: IMPLEMENT only

---

## Objective

Restore internal consistency to `_ORVION_CANONICAL/31_schema_draft.md` where SPEC-002's execution left it self-contradictory.

---

## Business Reason

The post-implementation review of SPEC-002 (`/reports/phase-01-post-implementation-review.md`) found that SPEC-002 never included a step for audit finding 4.2 (the `booking_items` non-negative amount constraint), even though it was part of the originally approved Phase 1 findings. As a direct consequence, `booking_item_passengers`' Rules block now contains a sentence — "consistent with the equivalent rule on booking_items" — that refers to a rule which does not exist anywhere in the document. This task adds the missing rule (closing the original audit finding) and restores the Phase 1 completion log entry that SPEC-002 also omitted, so the in-document audit trail is accurate.

---

## Risks

None. Both changes are additive documentation-only insertions to a file already in Scope for prior work. Neither changes any table, column, or existing rule.

---

## Supersedes / Depends On

Supersedes: None.
Depends on: SPEC-002-phase1-database-foundation.md must already be applied (this task's verification checks assume `booking_item_passengers`, `## 11. Table Classification Summary`, and `# 13. Review Required` item 7 already exist in their SPEC-002 form).

---

## Scope — Files Allowed to Modify

- _ORVION_CANONICAL/31_schema_draft.md

---

## Out of Scope — Files Forbidden to Modify

Scope above is exhaustive. Every other file in the repository is out of scope, with no exceptions, including but not limited to:
- _ORVION_CANONICAL/24_entity_registry.md
- _ORVION_CANONICAL/25_catalog_registry.md
- _ORVION_CANONICAL/29_relationship_map.md
- _ORVION_CANONICAL/30_database_conventions.md
- _ORVION_CANONICAL/26_state_machines.md
- _ORVION_CANONICAL/27_event_catalog.md
- _ORVION_CANONICAL/28_permissions_matrix.md
- changes/SPEC-002-phase1-database-foundation.md (historical record — do not edit)
- Any governance file (AGENTS.md, PROTOCOL.md, README.md, global-rules.md, PROJECT_CONTEXT.md, CODING_STANDARDS.md, codex.md, manifest.md, SYSTEM_PROMPT.md)

---

## Minimum Reading List

- _ORVION_CANONICAL/31_schema_draft.md

---

## Implementation Steps

### Step 1 — `booking_items` non-negative amount constraint

Verify: within the `## booking_items` section, search for the string `must not be negative`.
- If found: Already Applied, skip.
- If not found: locate that section's existing `Notes:` block, which ends with the exact line `` `commission_rate` reserves a lightweight path for future sales commission calculation without creating a payroll model. `` (immediately before the `## booking_item_passengers` heading). Insert immediately after that line and before `## booking_item_passengers`:

```

Rules:

- cost_amount and selling_amount must not be negative.
```

### Step 2 — Restore the dangling cross-reference's target is now valid

Verify: within the `## booking_item_passengers` section, confirm the string `consistent with the equivalent rule on booking_items` is present.
- If present and Step 1 was just applied (or was already applied): no edit needed — the reference is now valid. Do nothing further for this step.
- If the string is not present at all: STOP. Report: "booking_item_passengers no longer contains the expected cross-reference sentence; SPEC-003's assumptions about the current file state do not hold. Escalate for review rather than editing."

### Step 3 — Phase 1 completion log entry

Verify: within `# 13. Review Required`, search for the string `Review Required item 8` OR an existing numbered item 8.
- If item 8 already exists: Already Applied, skip.
- If not found (the section currently ends at item 7, `"Logical schema is frozen as the working baseline after this review. No additional schema redesign should happen unless implementation reveals a real problem."`): insert immediately after item 7 and before the following `---`:

```
8. Version 0.4 closed the Phase 1 Domain & Schema Audit findings via SPEC-002 and SPEC-003 (see changes/): added `currencies`, `payment_allocations`, and `customer_identity_merges`; added missing columns to `journal_entry_lines`, `invoices`, `booking_item_passengers`, `bookings`, `conversations`, `attribution_clicks`, `offline_conversions`, and `document_links`; documented five previously-unenforced constraints as table-level Rules (journal debit/credit exclusivity, booking_items and booking_item_passengers non-negative amounts, document_links single-target, document_versions single-current-version); and corrected the Table Classification Summary. State machines, events, and permissions for the CRM-extension entities (Task, Quotation, Conversation, Complaint, Service Request, Marketing Campaign) remain open and are explicitly deferred to the Phase 2 Catalog & Lifecycle Audit — no changes to `26_state_machines.md`, `27_event_catalog.md`, or `28_permissions_matrix.md` have been made as of this entry.
```

---

## Acceptance Criteria

- [ ] `## booking_items` contains a `Rules:` block with the exact sentence `cost_amount and selling_amount must not be negative.`
- [ ] The existing `booking_item_passengers` sentence referencing "the equivalent rule on booking_items" now refers to a rule that actually exists in the document.
- [ ] `# 13. Review Required` contains exactly one item 8, worded exactly as specified, and items 1–7 are unchanged.
- [ ] No file outside Scope (`_ORVION_CANONICAL/31_schema_draft.md` only) was modified or created.
- [ ] Re-running the Step 14 table/summary count check from SPEC-002 still yields a 1:1 match (this task does not add or remove any table).

---

## Review Gate

- [ ] Every change matches the Implementation Steps exactly, or was correctly recorded as Already Applied per its verification check.
- [ ] No file outside the Scope list was modified or created.
- [ ] No section was added, removed, or restructured outside the approved steps.
- [ ] Every Acceptance Criteria item is confirmed true.
- [ ] Any step that could not be resolved deterministically was reported, not guessed.
- [ ] Supersedes / Depends On: confirmed SPEC-002 was already applied before this task began.
- [ ] The repository is in a clean, releasable state.

---

## Notes

This task exists solely to close two small omissions found during the post-implementation review of
SPEC-002 (`/reports/phase-01-post-implementation-review.md`). It does not revisit, redesign, or
reopen any decision already made in SPEC-002. After this task, Phase 1 (Domain & Schema Audit) is
fully closed with no known open items at the database-structure layer. The only remaining known gap
in the repository — state machines, events, and permissions for the six CRM-extension entities — is
explicitly Phase 2 scope and is not addressed by this task.
