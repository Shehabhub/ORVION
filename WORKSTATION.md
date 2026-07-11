# ORVION — Engineering Workstation Rebuild

This is the entry point for **rebuilding the engineering environment** on a fresh Windows machine.
It is separate from `README.md` (which is the entry point for *working on ORVION itself*).

**One-authority note:** this file owns only *how to rebuild the workstation*. It points to the
scripts and manifest as the source of truth for the actual steps — it does not restate tool lists.
See `GOVERNANCE.md §2` (Workstation rebuild row).

---

## Rebuild: clone, then one action

Prerequisites on a bare Windows 11 machine: it already ships PowerShell; install **Git** (to clone)
and **Docker Desktop** (start it once). Then clone and enter the repo:

```powershell
git clone <ORVION repo url>
cd ORVION
```

Now **double-click `setup.cmd`** in the repo root. That is the whole rebuild — it **provisions and
then verifies**: it installs only what is missing (base tools via `winget`, VS Code extensions — from
the single source of truth `.workstation/manifest.md`) and finishes by running the verifier. A clean
result means the environment is ready — return to `README.md` and develop ORVION.

- **No double-click? / prefer a terminal:** run `./.workstation/prepare.ps1`.
- **AI agent controlling Windows:** call `./.workstation/prepare.ps1` directly (the `.cmd` is a
  human convenience that pauses at the end).
- **Re-check health anytime:** double-click `doctor.cmd` (or run `./.workstation/doctor.ps1`) — no
  changes, just checks.

`setup.cmd` / `doctor.cmd` are **thin launchers only** — the real logic lives in `.workstation/*.ps1`
(no duplicated logic, no second authority).

---

## What lives where

| Concern | Source of truth |
|---|---|
| Double-click launchers (human convenience, thin wrappers) | `setup.cmd`, `doctor.cmd` (repo root) |
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
