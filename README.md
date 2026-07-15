# ORVION

ORVION is the working repository for a travel CRM / operations / revenue platform for Egyptian travel agencies (flights, Umrah, Hajj, visa, hotels, tours). The backend is Supabase/PostgreSQL — SQL migrations + `app`-schema RPCs. There is no application UI yet.

**This file has one job: route you to the right authority in a single hop.** It does not restate the boot sequence, the rules, or the current status — each of those has exactly one home, linked below (One Authority — `GOVERNANCE.md §2`).

## Pick your goal

- **Work on ORVION (develop, review, operate — human or AI)** → go to **`AGENTS.md`**. Its **§4 is the single, mandatory boot sequence** — it walks every session from orientation → governance → live state → active work, and tells you exactly what to read next. Nothing else here needs to precede it.
- **Rebuild the workstation / environment** (new machine, SSD failure, Windows reinstall) → go to **`WORKSTATION.md`**. On a brand-new machine, one PowerShell command restores everything from GitHub (`irm …/bootstrap.ps1 | iex`); if you already have the repo, double-click **`workstation.cmd`**.

That is the entire entry decision. Everything below is a pointer, not a second authority.

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

**Repository policy:** canonical-first; the source of truth is `_ORVION_CANONICAL/` and the migrations. Conduct is governed by `AGENTS.md`; knowledge placement by `GOVERNANCE.md`. A fresh session needs no chat history — the repository is self-describing; start at `AGENTS.md`.
