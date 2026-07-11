# ORVION Workstation Manifest

**This file is the single source of truth for what the ORVION engineering workstation contains.**
`prepare.ps1` provisions exactly this list; `doctor.ps1` verifies it. Every entry earns its place by
measurable value to ORVION or to the primary engineering agent (Claude Code). Nothing is listed
"because it exists."

Last curated: 2026-07-11 · Platform: Windows 11 + PowerShell · Primary agent: Claude Code

---

## 1. Base tools (required — ORVION cannot be built without these)

| Tool | winget id | Why it earns its place | Verified |
|---|---|---|---|
| Git | `Git.Git` | version control; the repo is the SSOT | ✅ 2.54.0 |
| Node.js LTS | `OpenJS.NodeJS.LTS` | runs `npx supabase`, tooling | ✅ v24.18 |
| Docker Desktop | `Docker.DockerDesktop` | local Supabase/Postgres stack (`supabase start`) | ✅ 29.6.1 |
| Python 3 | `Python.Python.3.12` | base scripting dependency | ✅ 3.12.10 |
| VS Code | `Microsoft.VisualStudioCode` | editor host for all agents/extensions | ✅ 1.128 |
| Supabase CLI | via `npx supabase` (no global install) | migrations, `db reset`, `test db` | ✅ 2.109 |

> Supabase CLI is intentionally **not** installed globally — `npx supabase` pins per-project and avoids a stale global. Verified working this session.

## 2. VS Code extensions

| Extension | id | Owner | Earn-It verdict |
|---|---|---|---|
| Claude Code | `anthropic.claude-code` | agent | **Keep** — primary engineering interface |
| GitHub Copilot | `github.copilot` (+`-chat`) | **owner** | **Keep** — owner uses directly |
| OpenAI Codex / ChatGPT | `openai.chatgpt` | **owner** | **Keep** — owner uses directly |
| Continue | `continue.continue` | — | **Remove** — not the primary agent, not an owner tool, overlaps Copilot; no measurable value under the stated model |

## 3. Claude plugins

| Plugin | Earn-It verdict |
|---|---|
| GitKraken Hooks | **Keep** — provides durability (auto-commit). Improve commit-message convention (currently `"y"`). |
| Ponytail | **Keep (as-used)** — second-opinion review flow; occasional but real value |
| claude-mem | **Disabled** — `failed to load: cache-miss` + Windows worker never healthy; redundant with file-memory + self-describing repo. Re-enable only if upstream ships a Windows fix. |

## 4. MCP servers (`.mcp.json` at repo root)

| MCP | Earn-It verdict |
|---|---|
| Supabase MCP | **Adopt** — the one MCP that measurably speeds the agent's ORVION work (direct schema/SQL/RLS vs `docker exec`). Needs a connection string via env var — never commit the secret. |
| Context7 | **Keep** — connected, near-zero maintenance, occasional doc lookups |
| Serena / GitHub / Playwright | **Deferred** — Serena (little payoff on a SQL/RPC repo), GitHub (gh CLI suffices), Playwright (no app UI to drive yet) |

## 5. Deliberately excluded (with reason)
- `opencode-ai` (global npm) — third-party AI CLI, not the primary agent, not an owner tool. Removed.
- Claude Mem worker — Windows blocker; see `reports/INCIDENT_CLAUDE_MEM_WINDOWS.md`.

---

**Reversibility:** every removal here is reinstallable (`winget`, `npm i -g`, `code --install-extension`, `claude plugin`). Nothing removed is irrecoverable.
