# ORVION Workstation — interactive menu (the single human entry point).
# NO logic here: every option invokes an existing script/app. AI agents do NOT use this menu
# (it waits for input) — they call .workstation/prepare.ps1 (etc.) directly.
$Here = $PSScriptRoot
$Root = Split-Path $Here -Parent

# Interactive-only: in a non-interactive/piped context stdin hits EOF and the loop would spin.
if ([Console]::IsInputRedirected) {
    Write-Host "The workstation menu is interactive — run it in a real terminal (or double-click workstation.cmd)."
    Write-Host "For automation/AI: call .workstation/prepare.ps1, doctor.ps1, update.ps1, or cleanup.ps1 directly."
    exit 0
}

function Run($script) { & (Join-Path $Here $script); Write-Host ""; Read-Host "Press Enter to return to the menu" | Out-Null }
function Open($path) { Start-Process (Join-Path $Root $path) }

while ($true) {
    Write-Host ""
    Write-Host "========================================="
    Write-Host "       ORVION Control Center"
    Write-Host "========================================="
    Write-Host " Environment"
    Write-Host "   1  Prepare   (install missing tools + verify)"
    Write-Host "   2  Verify    (doctor — health, versions, GitHub sync)"
    Write-Host "   3  Update    (upgrade tools + verify)"
    Write-Host "   4  Cleanup   (remove transient artifacts — safe)"
    Write-Host " Develop"
    Write-Host "   5  Open repository in VS Code"
    Write-Host "   6  Open README (project entry point)"
    Write-Host " Info"
    Write-Host "   7  Installation status"
    Write-Host " System"
    Write-Host "   R  Restart shell (refresh PATH after installs)"
    Write-Host "   0  Exit"
    Write-Host ""
    switch (Read-Host "Choose") {
        "1" { Run "prepare.ps1" }
        "2" { Run "doctor.ps1" }
        "3" { Run "update.ps1" }
        "4" { Run "cleanup.ps1" }
        "5" { if (Get-Command code -ErrorAction SilentlyContinue) { code $Root } else { Write-Host "'code' not on PATH." } }
        "6" { Open "README.md" }
        "7" { Open ".workstation\reports\INSTALLATION_STATUS.md" }
        "R" { Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$Root'"; break }
        "r" { Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$Root'"; break }
        "0" { break }
        default { Write-Host "Invalid choice." }
    }
}
