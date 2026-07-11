# ORVION Control Center — interactive menu (the single human entry point).
# NO implementation here: options only DISPATCH to existing scripts/apps or read state for display.
# AI agents do NOT use this menu (it waits for input) — they call .workstation/*.ps1 directly.
$Here = $PSScriptRoot
$Root = Split-Path $Here -Parent

if ([Console]::IsInputRedirected) {
    Write-Host "The Control Center is interactive — run it in a real terminal (or double-click workstation.cmd)."
    Write-Host "For automation/AI: call .workstation/prepare.ps1, doctor.ps1, update.ps1, or cleanup.ps1 directly."
    exit 0
}

function Run($script) { & (Join-Path $Here $script); Write-Host ""; Read-Host "Press Enter to return to the menu" | Out-Null }
function Open($path) { Start-Process (Join-Path $Root $path) }

# --- state-awareness (reads only; no mutation) ---
function Get-DockerState {
    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { return "not installed" }
    docker ps *> $null 2>&1
    if ($LASTEXITCODE -eq 0) { return "running" } else { return "STOPPED (start Docker Desktop)" }
}
function Get-GitState {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { return "no git" }
    Push-Location $Root
    $branch = git rev-parse --abbrev-ref HEAD 2>$null
    git rev-parse "@{u}" *> $null 2>&1
    if ($LASTEXITCODE -ne 0) { $s = "$branch — NOT PUSHED (no upstream; work at risk)" }
    else {
        $ahead = git rev-list --count "@{u}..HEAD" 2>$null
        if ([int]$ahead -gt 0) { $s = "$branch — $ahead commit(s) NOT PUSHED (at risk)" } else { $s = "$branch — in sync with GitHub" }
    }
    Pop-Location; return $s
}

while ($true) {
    $docker = Get-DockerState
    $git = Get-GitState
    Write-Host ""
    Write-Host "========================================="
    Write-Host "       ORVION Control Center"
    Write-Host "========================================="
    Write-Host "  Docker : $docker"
    Write-Host "  GitHub : $git"
    Write-Host "-----------------------------------------"
    Write-Host " Environment"
    Write-Host "   1  Prepare   (install missing tools + verify)"
    Write-Host "   2  Verify    (doctor — health, versions, GitHub sync)"
    Write-Host "   3  Update    (upgrade tools + verify)"
    Write-Host "   4  Cleanup   (remove transient artifacts — safe)"
    Write-Host " Develop"
    Write-Host "   5  Open repository in VS Code"
    Write-Host "   6  Open README (project entry point)"
    Write-Host "   7  Open AGENTS (execution operating model)"
    Write-Host "   8  Open Supabase Studio (local DB UI)"
    Write-Host " Info"
    Write-Host "   9  Installation status"
    Write-Host " System"
    Write-Host "   R  Restart shell (refresh PATH after installs)"
    Write-Host "   X  Exit"
    Write-Host ""
    switch (Read-Host "Choose") {
        "1" { Run "prepare.ps1" }
        "2" { Run "doctor.ps1" }
        "3" { Run "update.ps1" }
        "4" { Run "cleanup.ps1" }
        "5" { if (Get-Command code -ErrorAction SilentlyContinue) { code $Root } else { Write-Host "'code' not on PATH." } }
        "6" { Open "README.md" }
        "7" { Open "AGENTS.md" }
        "8" {
            if ((Get-DockerState) -eq "running") { Start-Process "http://127.0.0.1:54323" }
            else { Write-Host "Supabase Studio needs the local stack running. Start it: npx supabase start" }
        }
        "9" { Open ".workstation\reports\INSTALLATION_STATUS.md" }
        { $_ -in "R", "r" } { Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$Root'"; break }
        { $_ -in "X", "x", "0" } { break }
        default { Write-Host "Invalid choice." }
    }
}
