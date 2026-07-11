$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "========================================="
Write-Host "ORVION WORKSTATION UPDATE"
Write-Host "========================================="
Write-Host ""

$Root = Split-Path $PSScriptRoot -Parent
Set-Location $Root

$ReportDir = ".workstation\reports"

if (!(Test-Path $ReportDir)) {
    New-Item -ItemType Directory -Force $ReportDir | Out-Null
}

$Report = Join-Path $ReportDir "update-report.txt"

"ORVION UPDATE REPORT" | Set-Content $Report
(Get-Date) | Add-Content $Report
"" | Add-Content $Report

function Run-Step {
    param(
        [string]$Title,
        [scriptblock]$Command
    )

    Write-Host ""
    Write-Host "[$Title]"

    try {

        & $Command

        "$Title : OK" | Add-Content $Report

    }
    catch {

        Write-Host "[WARN] $($_.Exception.Message)"

        "$Title : FAILED" | Add-Content $Report

    }
}

Run-Step "Git Version" {
    git --version
}

Run-Step "Node Version" {
    node -v
}

Run-Step "NPM Version" {
    npm -v
}

Run-Step "Docker Version" {
    docker --version
}

Run-Step "Python Version" {
    python --version
}

Run-Step "Claude Version" {
    claude --version
}

Run-Step "VS Code Version" {
    code --version
}

Write-Host ""
Write-Host "Update completed."
Write-Host "Report:"
Write-Host $Report
