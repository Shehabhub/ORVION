# ORVION Workstation — interactive menu (human entry point).
# NO logic here: every option just invokes an existing .workstation/*.ps1 script.
# AI agents: do NOT use this menu (it waits for input) — call .workstation/prepare.ps1 etc. directly.
$Here = $PSScriptRoot
$Root = Split-Path $Here -Parent

# Interactive-only. In a non-interactive/piped context stdin hits EOF and a menu loop would spin —
# so refuse and point automation at the real scripts.
if ([Console]::IsInputRedirected) {
    Write-Host "The workstation menu is interactive — run it in a real terminal (or double-click workstation.cmd)."
    Write-Host "For automation/AI: call .workstation/prepare.ps1, doctor.ps1, update.ps1, or cleanup.ps1 directly."
    exit 0
}

function Run($script) { & (Join-Path $Here $script); Write-Host ""; Read-Host "Press Enter to return to the menu" | Out-Null }

while ($true) {
    Write-Host ""
    Write-Host "===================================="
    Write-Host " ORVION Workstation"
    Write-Host "===================================="
    Write-Host " 1. Prepare workstation  (install missing tools + verify)"
    Write-Host " 2. Verify workstation   (doctor — read-only checks)"
    Write-Host " 3. Update workstation   (upgrade tools + verify)"
    Write-Host " 4. Cleanup workstation  (remove transient artifacts — safe)"
    Write-Host " 5. Open documentation   (WORKSTATION.md)"
    Write-Host " 0. Exit"
    Write-Host ""
    switch (Read-Host "Choose") {
        "1" { Run "prepare.ps1" }
        "2" { Run "doctor.ps1" }
        "3" { Run "update.ps1" }
        "4" { Run "cleanup.ps1" }
        "5" { Start-Process (Join-Path $Root "WORKSTATION.md") }
        "0" { break }
        default { Write-Host "Invalid choice — enter 0-5." }
    }
}
