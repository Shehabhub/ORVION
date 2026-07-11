$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "========================================="
Write-Host "ORVION WORKSTATION CLEANUP"
Write-Host "========================================="
Write-Host ""

$Root = Split-Path $PSScriptRoot -Parent
Set-Location $Root

$ReportDir = ".workstation\reports"

if (!(Test-Path $ReportDir)) {
    New-Item -ItemType Directory -Force $ReportDir | Out-Null
}

$Report = Join-Path $ReportDir "cleanup-report.txt"

"ORVION CLEANUP REPORT" | Set-Content $Report
(Get-Date) | Add-Content $Report
"" | Add-Content $Report

function Remove-EnvVar {
    param([string]$Name)

    [Environment]::SetEnvironmentVariable($Name,$null,"User")
    Remove-Item "Env:$Name" -ErrorAction SilentlyContinue

    Write-Host "[DONE] $Name"
    "$Name : REMOVED" | Add-Content $Report
}

Write-Host "[Environment]"

Remove-EnvVar "GEMINI_API_KEY"
Remove-EnvVar "OLLAMA_API_BASE"

Write-Host ""
Write-Host "[Containers]"

docker rm -f omniroute 2>$null | Out-Null

if($LASTEXITCODE -eq 0){
    Write-Host "[DONE] omniroute"
    "omniroute : REMOVED" | Add-Content $Report
}
else{
    Write-Host "[SKIP] omniroute"
    "omniroute : NOT FOUND" | Add-Content $Report
}

Write-Host ""
Write-Host "[Backup Files]"

$Backups = @(
    "opencode.json.backup"
)

foreach($File in $Backups){

    if(Test-Path $File){

        Write-Host "[FOUND] $File"
        "$File : EXISTS" | Add-Content $Report

    }
    else{

        Write-Host "[SKIP] $File"
        "$File : NOT FOUND" | Add-Content $Report

    }

}

Write-Host ""
Write-Host "Cleanup completed."
Write-Host "Report:"
Write-Host $Report
