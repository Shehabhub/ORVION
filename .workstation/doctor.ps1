$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "========================================="
Write-Host "ORVION WORKSTATION DOCTOR"
Write-Host "========================================="
Write-Host ""

$Root = Split-Path $PSScriptRoot -Parent
Set-Location $Root

function Test-Cmd {
    param($Name)

    if(Get-Command $Name -ErrorAction SilentlyContinue){

        Write-Host "[ OK ] $Name"

    }else{

        Write-Host "[FAIL] $Name"

    }
}

Write-Host "[Applications]"

Test-Cmd git
Test-Cmd node
Test-Cmd npm
Test-Cmd docker
Test-Cmd python
Test-Cmd claude
Test-Cmd code

Write-Host ""

Write-Host "[Repository]"

$Files=@(
"README.md",
"AGENTS.md",
"PROJECT_CONTEXT.md",
".gitignore"
)

foreach($f in $Files){

    if(Test-Path $f){

        Write-Host "[ OK ] $f"

    }else{

        Write-Host "[FAIL] $f"

    }

}

Write-Host ""

Write-Host "[Docker]"

docker version *> $null

if($LASTEXITCODE -eq 0){

    Write-Host "[ OK ] Docker Engine"

}else{

    Write-Host "[FAIL] Docker Engine"

}

Write-Host ""
Write-Host "Doctor completed."
