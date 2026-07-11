# ORVION — Engineering Workstation Rebuild

This is the entry point for **rebuilding the engineering environment** on a fresh Windows machine.
It is separate from `README.md` (which is the entry point for *working on ORVION itself*).

**One-authority note:** this file owns only *how to rebuild the workstation*. It points to the
scripts and manifest as the source of truth for the actual steps — it does not restate tool lists.
See `GOVERNANCE.md §2` (Workstation rebuild row).

---

## Rebuild: clone, then one launcher

Prerequisites on a bare Windows 11 machine: it already ships PowerShell; install **Git** (to clone)
and **Docker Desktop** (start it once). Then clone and enter the repo:

```powershell
git clone <ORVION repo url>
cd ORVION
```

Now **double-click `workstation.cmd`** in the repo root and choose **1 (Prepare)**. That is the whole
rebuild — Prepare **provisions and then verifies**: it installs only what is missing (base tools via
`winget`, VS Code extensions — from the single source of truth `.workstation/manifest.md`) and
finishes by running the verifier. A clean result means the environment is ready — return to
`README.md` and develop ORVION. The same menu also offers Verify, Update, and Cleanup.

- **Prefer a terminal / no double-click:** run `./.workstation/prepare.ps1` (provision) or
  `./.workstation/doctor.ps1` (verify) directly.
- **AI agent controlling Windows:** call the `.workstation/*.ps1` scripts directly — **do not** use
  the menu (it waits for input).

`workstation.cmd` is a **thin launcher** over `.workstation/menu.ps1`, which contains no logic and only
invokes the existing `.workstation/*.ps1` scripts — the real implementation. No duplicated logic, no
second authority.

**Why no `irm <url> | iex` remote bootstrap:** rejected by design — it would execute unreviewed remote
code and move setup logic *outside* the repository. ORVION keeps the implementation *in* the repo:
clone first, then run the local launcher. The only pre-clone steps are installing Git + Docker.

---

## What lives where

| Concern | Source of truth |
|---|---|
| Single launcher (interactive menu, human) | `workstation.cmd` (root) → `.workstation/menu.ps1` |
| What to install (tools, extensions, MCPs, plugins) + why | `.workstation/manifest.md` |
| Provision the environment (real logic) | `.workstation/prepare.ps1` |
| Verify the environment (real logic) | `.workstation/doctor.ps1` |
| MCP server configuration | `.mcp.json` (repo root; secrets via env vars, never committed) |
| Known blockers | `.workstation/reports/INCIDENT_*.md` |
| Current install status | `.workstation/reports/INSTALLATION_STATUS.md` |

## Secrets (not in the repo)
Some MCP servers need secrets (e.g. the Supabase MCP connection string). Provide them as environment
variables before running `prepare.ps1`; they are never committed. `prepare.ps1` registers an MCP only
when its required env var is present.

## Known blocker
- **Claude Mem** worker does not stay healthy on Windows (port 37777). Parked; see
  `.workstation/reports/INCIDENT_CLAUDE_MEM_WINDOWS.md`. Not required for ORVION development.
