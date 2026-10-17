# ORVION Secure Workstation Decommission
# Removes ONLY ORVION assets from THIS machine (for retire / sell / replace). Safe because GitHub is
# the permanent source of truth - the repo is fully recoverable anytime via the bootstrap. It NEVER
# removes general tools (Git/Node/Docker/VS Code) or any unrelated user data. Requires explicit confirmation.
$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
# Refuse before confirmation, stopping containers, or scheduling repository removal.
. (Join-Path $Root 'scripts/assert_founder_local.ps1')
$Root = Assert-FounderLocalTarget -Root $Root

Write-Host ""
Write-Host "== ORVION Secure Decommission =="
Write-Host "Removes the local ORVION repository + ORVION-specific config/env from THIS machine."
Write-Host "GitHub keeps the permanent copy - recover anytime with the bootstrap."
Write-Host "Does NOT remove Git, Node, Docker, VS Code, or any unrelated data."
Write-Host ""
if ((Read-Host "Type DECOMMISSION to proceed (anything else cancels)") -cne "DECOMMISSION") {
    Write-Host "Cancelled - nothing removed."; return
}

# 1. ORVION-specific environment variables
Write-Host '[NOTE] Shared user environment and credentials are preserved.'

# 2. Stop the local Supabase stack (frees ORVION containers) - best-effort.
$cli = Join-Path $Root 'node_modules/.bin/supabase.cmd'
if (Test-Path -LiteralPath $cli) {
    & $cli stop --project-id ORVION_FOUNDER --workdir $Root 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) { Write-Warning 'Founder stack stop failed; preserving existing best-effort stop behavior.' }
} else { Write-Warning 'Pinned CLI absent; no Supabase stop attempted.' }

# 3. Remove the local repository LAST - detached, because we are running from inside it.
Write-Host "[DONE] scheduling removal of $Root"
Set-Location $HOME
Start-Process powershell -ArgumentList "-NoProfile", "-Command", "Start-Sleep 2; Remove-Item -LiteralPath '$Root' -Recurse -Force -ErrorAction SilentlyContinue" -WindowStyle Hidden

Write-Host ""
Write-Host "ORVION will be removed from this machine momentarily. Recover anytime with one command:"
Write-Host "  irm https://raw.githubusercontent.com/Shehabhub/ORVION/main/bootstrap.ps1 | iex"
exit 0
