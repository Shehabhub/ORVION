# ORVION Workstation — Installation Status

Last curated: 2026-07-11 · Primary engineering agent: Claude Code

This is the single status doc for the workstation. What to install and why lives in
`../manifest.md`; how to rebuild lives in `/WORKSTATION.md`. This file only records current state.

## Environment: READY

The full ORVION stack was exercised on this machine this session (Supabase local, `db reset`,
pgTAP, migrations) — the environment is verified working for ORVION development.

| Area | State |
|---|---|
| Base tools (Git, Node, Docker, Python, VS Code, Supabase-via-npx) | ✅ verified present (`doctor.ps1`) |
| Reproducibility (`prepare.ps1` + `doctor.ps1` + `manifest.md` + `.mcp.json` + `WORKSTATION.md`) | ✅ in repo |
| MCP: context7 | ✅ connected |
| MCP: postgres-local | ⏳ configured in `.mcp.json`; activates on next agent start |
| Plugins: GitKraken Hooks, Ponytail | ✅ enabled |
| Plugin: claude-mem | ⚠ disabled (Windows blocker — see `INCIDENT_CLAUDE_MEM_WINDOWS.md`) |

## Earn-It decisions applied this session
- **Removed:** `continue` VS Code extension and `opencode-ai` global npm (not the primary agent, not owner tools).
- **Kept as owner tools:** GitHub Copilot, OpenAI Codex / ChatGPT (owner uses directly).
- **Noted:** `github.copilot-chat` is now a built-in VS Code extension — not provisioned explicitly.
- **Consolidated:** four near-duplicate check scripts (`bootstrap`/`verify`/`healthcheck`/`install`) into `prepare.ps1` (provision) + `doctor.ps1` (verify).

## Known blockers
- Claude Mem worker never becomes healthy on Windows. Parked until an official fix; not required for ORVION.

## Next
Return to ORVION implementation (`README.md`). No further workstation installation is required unless
a new tool earns its place under Earn-It.
