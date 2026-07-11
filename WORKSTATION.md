# ORVION — Engineering Workstation Rebuild

This is the entry point for **rebuilding the engineering environment** on a fresh Windows machine.
It is separate from `README.md` (which is the entry point for *working on ORVION itself*).

**One-authority note:** this file owns only *how to rebuild the workstation*. It points to the
scripts and manifest as the source of truth for the actual steps — it does not restate tool lists.
See `GOVERNANCE.md §2` (Workstation rebuild row).

---

## Rebuild: read this, run one command

Prerequisites on a bare Windows 11 machine: it already ships PowerShell; install **Git** (to clone)
and **Docker Desktop** (start it once). Then:

```powershell
git clone <ORVION repo url>
cd ORVION
./.workstation/prepare.ps1
```

That is the whole rebuild — the one command **provisions and then verifies**. `prepare.ps1` is
idempotent (installs only what is missing — base tools via `winget`, VS Code extensions — from the
single source of truth `.workstation/manifest.md`) and finishes by running `doctor.ps1` itself. When
it prints a clean `doctor` result, the environment is ready.

> "Prepare this workstation." = run the command above. Then return to `README.md` and develop ORVION.

Re-verify anytime with `./.workstation/doctor.ps1` (no changes, just checks).

---

## What lives where

| Concern | Source of truth |
|---|---|
| What to install (tools, extensions, MCPs, plugins) + why | `.workstation/manifest.md` |
| Provision the environment | `.workstation/prepare.ps1` |
| Verify the environment | `.workstation/doctor.ps1` |
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
