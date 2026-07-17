# ORVION

ORVION is the working repository for a travel CRM / operations / revenue platform for Egyptian travel agencies (flights, Umrah, Hajj, visa, hotels, tours). The backend is Supabase/PostgreSQL — SQL migrations + `app`-schema RPCs.

**This file has one job: orient you inside the repository and route you to the right authority in a single hop.** It does not restate the boot sequence, the rules, or the current status — each of those has exactly one home, linked below (One Authority — `GOVERNANCE.md §2`). It is a router, not a second authority.

## Start here

**To develop, review, or operate ORVION — human or AI → open `AGENTS.md` immediately and continue through its §4 boot sequence before doing anything else.** Its **§4 is the single, mandatory boot sequence** — it is the repository-maintained path from orientation → governance → live state → active work, and finishes by *verifying* the repository is internally consistent before engineering begins. Do not replace it with a remembered or hardcoded reading list; follow the authority it identifies so the path can evolve with the repository.

**Repository initialization is automatic.** Reading the governance, authority, and live-state documents required by the boot sequence is initialization, not exploratory engineering and not an owner-approval checkpoint. A fresh session must complete that initialization before asking engineering questions or proposing work. The boot sequence itself determines whether the repository is ready, blocked, or has a next executable capability.

## Where things live (authorities)

| You want… | Go to |
|---|---|
| The boot sequence / reading order | `AGENTS.md §4` (single authority) |
| How work is done — conduct, standing authorities, decision tiers | `AGENTS.md` |
| Where every fact lives — SSOT matrix, decision & document lifecycles, write-permissions | `GOVERNANCE.md` |
| Change Request state machine & command vocabulary | `CR_LIFECYCLE.md` |
| Current phase, module, and Active Change Request (live state) | `_ORVION_CANONICAL/manifest.md` |
| Business & schema canon (source of truth for domain/schema intent) | `_ORVION_CANONICAL/**` |
| As-built schema truth | `supabase/migrations/**` |
| Coding / SQL / API / security standards | `CODING_STANDARDS.md` |
| Project identity, vision, boundaries | `PROJECT_CONTEXT.md` |
| Rationale, findings, ADRs, deferred backlog | `reports/` (index: `reports/README.md`) |
| Full document registry (what each file owns) | `GOVERNANCE.md §5` |

**Repository policy:** the repository is self-describing and has no chat-history prerequisite. `AGENTS.md` governs execution conduct and the boot process; `GOVERNANCE.md` governs knowledge authority and placement; the boot process routes each question to the current authoritative document and ground truth. Start at `AGENTS.md`.
