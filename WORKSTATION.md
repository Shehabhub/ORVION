# ORVION — Engineering Workstation Rebuild

This is the entry point for **rebuilding the engineering environment** on a fresh Windows machine.
It is separate from `README.md` (which is the entry point for *working on ORVION itself*).

**One-authority note:** this file owns only *how to rebuild the workstation*. It points to the
scripts and manifest as the source of truth for the actual steps — it does not restate tool lists.
See `GOVERNANCE.md §2` (Workstation rebuild row).

---

## Rebuild in three steps

1. Install Git + PowerShell (Windows 11 ships PowerShell; install Git for the initial clone), then:
   ```powershell
   git clone <ORVION repo url>
   cd ORVION
   ```
2. Open the repo and tell the agent (or run directly):
   > "Prepare this workstation."
   ```powershell
   ./.workstation/prepare.ps1
   ```
   `prepare.ps1` is idempotent — it installs only what is missing (base tools via `winget`, VS Code
   extensions, MCP servers, plugins) from the single source of truth: **`.workstation/manifest.md`**.
3. Verify:
   ```powershell
   ./.workstation/doctor.ps1
   ```
   A clean run means the environment is ready. Then continue with `README.md` to work on ORVION.

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
