# ORVION Workstation Provisioner — "Prepare this workstation"
# Idempotent: installs only what is missing, from the single source of truth (manifest.md).
# Safe to re-run. Run doctor.ps1 afterwards (this script calls it at the end).
$ErrorActionPreference = "Continue"
$Root = Split-Path $PSScriptRoot -Parent
Set-Location $Root

function Ensure-Tool {
    param($Cmd, $WingetId, $Label)
    if (Get-Command $Cmd -ErrorAction SilentlyContinue) {
        Write-Host "[ OK ] $Label already present"
        return
    }
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "[INSTALL] $Label ($WingetId)"
        winget install --id $WingetId -e --accept-source-agreements --accept-package-agreements
    }
    else {
        Write-Host "[WARN] $Label missing and winget unavailable — install manually"
    }
}

Write-Host ""
Write-Host "== Base tools (manifest.md section 1) =="
Ensure-Tool git    "Git.Git"                        "Git"
Ensure-Tool node   "OpenJS.NodeJS.LTS"              "Node.js LTS"
Ensure-Tool docker "Docker.DockerDesktop"           "Docker Desktop"
Ensure-Tool python "Python.Python.3.12"             "Python 3.12"
Ensure-Tool code   "Microsoft.VisualStudioCode"     "VS Code"
# Supabase CLI is used via `npx supabase` (no global install) — see manifest.md.

Write-Host ""
Write-Host "== VS Code extensions (manifest.md section 2) =="
if (Get-Command code -ErrorAction SilentlyContinue) {
    # github.copilot-chat is now bundled built-in with VS Code — do not install it explicitly.
    foreach ($ext in @("anthropic.claude-code", "github.copilot", "openai.chatgpt")) {
        code --install-extension $ext --force
    }
}
else {
    Write-Host "[WARN] 'code' CLI not on PATH — open VS Code once and enable 'code' command, then re-run"
}

Write-Host ""
Write-Host "== MCP servers (manifest.md section 4) =="
Write-Host "Configured in .mcp.json (context7, postgres-local) — auto-loaded by Claude Code on start."
Write-Host "Cloud Supabase MCP: add @supabase/mcp-server-supabase with SUPABASE_ACCESS_TOKEN once a cloud project exists."

Write-Host ""
Write-Host "== Verify =="
& (Join-Path $PSScriptRoot "doctor.ps1")

Write-Host ""
Write-Host "Prepare complete. If any base tool was just installed, restart the shell so PATH updates."
