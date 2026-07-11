# ORVION Workstation Provisioner — "Prepare this workstation"
# Idempotent + fault-tolerant: installs only what is missing, CONTINUES past any failure,
# and prints a final Installed/Present/Failed summary. Re-running is also the retry path —
# only still-missing items are attempted. Real logic lives here; workstation.cmd (menu) is the launcher.
$ErrorActionPreference = "Continue"
$Root = Split-Path $PSScriptRoot -Parent
Set-Location $Root

$Results = [System.Collections.Generic.List[object]]::new()
function Note($Item, $State) { $Results.Add([pscustomobject]@{ Item = $Item; State = $State }) }

function Ensure-Tool {
    param($Cmd, $WingetId, $Label)
    if (Get-Command $Cmd -ErrorAction SilentlyContinue) { Write-Host "[ OK ] $Label present"; Note $Label "present"; return }
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { Write-Host "[FAIL] $Label — winget unavailable"; Note $Label "FAILED (no winget)"; return }
    Write-Host "[INSTALL] $Label ($WingetId)"
    winget install --id $WingetId -e --accept-source-agreements --accept-package-agreements
    if (Get-Command $Cmd -ErrorAction SilentlyContinue) { Note $Label "installed" } else { Write-Host "[FAIL] $Label"; Note $Label "FAILED" }
}

Write-Host ""
Write-Host "== Base tools (manifest.md section 1) =="
Ensure-Tool git    "Git.Git"                     "Git"
Ensure-Tool node   "OpenJS.NodeJS.LTS"           "Node.js LTS"
Ensure-Tool docker "Docker.DockerDesktop"        "Docker Desktop"
Ensure-Tool python "Python.Python.3.12"          "Python 3.12"
Ensure-Tool code   "Microsoft.VisualStudioCode"  "VS Code"
# Supabase CLI is used via `npx supabase` (no global install) — see manifest.md.

Write-Host ""
Write-Host "== VS Code extensions (manifest.md section 2) =="
if (Get-Command code -ErrorAction SilentlyContinue) {
    $installed = @(code --list-extensions 2>$null)
    # Agent + owner AI + the ORVION-relevant editor tools (Supabase, SQL, PowerShell, Docker).
    # github.copilot is NOT CLI-installed here: it depends on github.copilot-chat, which VS Code now
    # ships built-in — the CLI tries to downgrade it and fails. Install Copilot from the VS Code
    # Extensions UI instead (it resolves the built-in dependency). It stays in .vscode/extensions.json
    # recommendations. (github.copilot-chat itself is built-in — never install explicitly.)
    foreach ($ext in @(
            "anthropic.claude-code", "openai.chatgpt",
            "supabase.vscode-supabase-extension", "mtxr.sqltools",
            "ms-vscode.powershell", "ms-azuretools.vscode-docker")) {
        if ($installed -contains $ext) { Write-Host "[ OK ] $ext present"; Note "ext:$ext" "present"; continue }
        Write-Host "[INSTALL] $ext"
        code --install-extension $ext 2>&1 | Out-Null
        if (@(code --list-extensions 2>$null) -contains $ext) { Write-Host "[ OK ] $ext installed"; Note "ext:$ext" "installed" }
        else { Write-Host "[FAIL] $ext"; Note "ext:$ext" "FAILED" }
    }
}
else { Write-Host "[SKIP] 'code' CLI not on PATH — open VS Code once, enable the 'code' command, re-run"; Note "vscode-extensions" "skipped (no code CLI)" }
Write-Host "[NOTE] GitHub Copilot (owner tool): install from the VS Code Extensions UI — the CLI conflicts with the built-in Copilot Chat."

Write-Host ""
Write-Host "== MCP servers (manifest.md section 4) =="
Write-Host "Configured in .mcp.json (context7, postgres-local) — auto-loaded by Claude Code on start."
Write-Host "Cloud Supabase MCP: add @supabase/mcp-server-supabase with SUPABASE_ACCESS_TOKEN once a cloud project exists."

Write-Host ""
Write-Host "== Verify =="
& (Join-Path $PSScriptRoot "doctor.ps1")

Write-Host ""
Write-Host "== Summary =="
$Results | ForEach-Object { Write-Host ("  {0,-24} {1}" -f $_.Item, $_.State) }
$failed = @($Results | Where-Object { $_.State -like "FAILED*" })
if ($failed.Count -gt 0) {
    Write-Host ""
    Write-Host "$($failed.Count) item(s) FAILED. Re-run Prepare (workstation.cmd -> 1) to retry only those (idempotent). If a base tool keeps failing, install it manually and re-run."
}
else {
    Write-Host ""
    Write-Host "All items present or installed. If a base tool was just installed, restart the shell so PATH updates."
}
