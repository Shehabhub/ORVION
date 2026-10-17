# ORVION Remote Bootstrap - the ONLY thing that runs before the repository exists.
# Almost no logic: ensure Git, clone the ORVION repository (Shehabhub/ORVION - the Founder environment) from GitHub, then hand off to the in-repo provisioner.
# ALL real setup logic lives in the repository (the permanent source of truth). This file is
# committed in the repo; the raw URL only delivers it for the single pre-clone step.
#
# On a brand-new machine, open PowerShell and run ONE command:
#   irm https://raw.githubusercontent.com/Shehabhub/ORVION/main/bootstrap.ps1 | iex
#
# (Docker Desktop is still installed by prepare.ps1; start it once when prompted.)
$ErrorActionPreference = "Stop"
# Founder recovery owns only Shehabhub/ORVION. A commit author is never an authenticated identity.
$RepoUrl = "https://Shehabhub@github.com/Shehabhub/ORVION.git"
$Target = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "GitHub/ORVION"

Write-Host "== ORVION bootstrap ==  target: $Target"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "winget is unavailable. Install Microsoft's App Installer, then rerun this bootstrap."
    }
    Write-Host "Git not found - installing via winget..."
    winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements
    # Refresh PATH so git is usable in this same session.
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "Git installation completed but git is not available on PATH." }
}

if (Test-Path (Join-Path $Target ".git")) {
    $origin = git -C $Target remote get-url origin
    if ($LASTEXITCODE -ne 0 -or $origin -notmatch '^https://(Shehabhub@)?github\.com/Shehabhub/ORVION(\.git)?$') { throw 'FOUNDER_REPOSITORY_MISMATCH: recovery will not update this checkout.' }
    $pushUrls = @(git -C $Target remote get-url --push --all origin)
    if ($pushUrls.Count -ne 1 -or $pushUrls[0] -notmatch '^https://(?:Shehabhub@)?github\.com/Shehabhub/ORVION(?:\.git)?$') { throw 'FOUNDER_PUSH_TARGET_MISMATCH' }
    if (@(git -C $Target status --porcelain).Count) { throw 'FOUNDER_CHECKOUT_DIRTY' }
    Write-Host "Repository already present - pulling latest."
    git -C $Target pull --ff-only
}
else {
    git clone $RepoUrl $Target
}

if ($LASTEXITCODE -ne 0) { throw "Founder clone/update failed; provisioner not started." }
Set-Location $Target
Write-Host "Handing off to the in-repo provisioner (workstation.cmd -> .workstation\prepare.ps1)..."
# Through workstation.cmd, never `& prepare.ps1`: `irm | iex` runs this text under the Restricted
# execution policy a fresh Windows client has, but Restricted refuses a script FILE, so recovery
# stopped here with "running scripts is disabled". workstation.cmd starts prepare.ps1 with a
# process-scoped -ExecutionPolicy Bypass and changes no persistent policy.
& (Join-Path $Target "workstation.cmd")
exit $LASTEXITCODE
