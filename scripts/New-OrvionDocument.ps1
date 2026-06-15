param(
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [Parameter(Mandatory=$true)]
    [string]$Content
)

$directory = Split-Path -Parent $Path

if ($directory -and !(Test-Path $directory)) {
    New-Item -ItemType Directory -Force -Path $directory | Out-Null
}

$Content | Set-Content $Path -Encoding UTF8

Write-Host ""
Write-Host "Created: $Path" -ForegroundColor Green
