# ORVION — Engineering Workstation Rebuild

This is the entry point for **rebuilding the engineering environment** on a fresh Windows machine.
It is separate from `README.md` (which is the entry point for *working on ORVION itself*).

**One-authority note:** this file owns only *how to rebuild the workstation*. It points to the
scripts and manifest as the source of truth for the actual steps — it does not restate tool lists.
See `GOVERNANCE.md §2` (Workstation rebuild row).

**Design assumption (permanent):** the local machine is **disposable**; **GitHub is the permanent
source of truth**. Every workstation decision optimizes for rebuilding a completely new machine from
GitHub with the fewest user actions. When "convenient on this machine" conflicts with "reproducible
from GitHub," choose GitHub. (`doctor.ps1` enforces the spirit of this by warning when local commits
are not yet pushed.)

---

## Rebuild on a brand-new machine — ONE command

Open PowerShell on a fresh Windows 11 machine (no USB, no manual download) and run:

```powershell
irm https://raw.githubusercontent.com/Shehabhub/ORVION/main/bootstrap.ps1 | iex
```

`bootstrap.ps1` (committed in this repo; the URL just delivers it) does the minimum needed *before* the
repo exists: ensure Git (install via `winget` if missing), clone ORVION from GitHub into `~/ORVION`,
then hand off to the in-repo provisioner `.workstation/prepare.ps1`. **All real setup logic stays in
the repo** — the bootstrap only downloads the repository and transfers execution to it. Start Docker
Desktop once when prompted. When `prepare` reports a clean `doctor`, return to `README.md` and develop.

**Trust model:** `irm|iex` runs a script fetched over HTTPS from your own GitHub repo — the same trust
you place in the repo's scripts once cloned. This is the standard Windows bootstrap pattern (Chocolatey,
Scoop, rustup). The script is tiny and reviewable in the repo.

## Already have the repo? — one launcher

```powershell
cd ORVION   # (or wherever you cloned it)
```
Double-click **`workstation.cmd`** and choose **1 (Prepare)** — provisions and self-verifies. The menu
also offers Verify, Update, Cleanup, Open-in-VS-Code, README, Installation-status, Restart-shell.

- **Terminal / no double-click:** run `./.workstation/prepare.ps1` (provision) or `doctor.ps1` (verify).
- **AI agent controlling Windows:** call the `.workstation/*.ps1` scripts directly — **not** the menu.

`bootstrap.ps1` (remote entry) and `workstation.cmd → .workstation/menu.ps1` (local entry) are both thin
— they only clone/launch. The real implementation lives in `.workstation/*.ps1`. No duplicated logic,
no second authority.

---

## What lives where

| Concern | Source of truth |
|---|---|
| Remote bootstrap (fresh machine, pre-clone) | `bootstrap.ps1` (root; served via GitHub raw URL) |
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
