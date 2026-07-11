# ORVION Workstation Cleanup
# Removes ONLY transient/obsolete artifacts. Safe by design: it never touches committed files
# (curated reports/*.md, migrations, canon, source). Safe to run multiple times.
$ErrorActionPreference = "Continue"
$Root = Split-Path $PSScriptRoot -Parent
Set-Location $Root

$Removed = [System.Collections.Generic.List[string]]::new()

Write-Host ""
Write-Host "[Retired-experiment env vars]"
foreach ($name in @("GEMINI_API_KEY", "OLLAMA_API_BASE")) {
    if ([Environment]::GetEnvironmentVariable($name, "User")) {
        [Environment]::SetEnvironmentVariable($name, $null, "User")
        Remove-Item "Env:$name" -ErrorAction SilentlyContinue
        Write-Host "[DONE] $name"; $Removed.Add("env:$name")
    }
    else { Write-Host "[SKIP] $name (not set)" }
}

Write-Host ""
Write-Host "[Transient workstation logs] (gitignored generated captures only)"
# Only the regenerated, gitignored logs — NOT the curated committed reports/*.md.
$patterns = @(".workstation\reports\*.txt", ".workstation\reports\*.log", ".workstation\reports\mcp\*.txt", ".workstation\reports\tools\*.txt")
foreach ($p in $patterns) {
    Get-ChildItem $p -File -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
        Write-Host "[DONE] $($_.Name)"; $Removed.Add($_.Name)
    }
}

Write-Host ""
Write-Host "[Stray backup artifacts]"
foreach ($f in @("opencode.json.backup", ".aider.tags.cache.v4")) {
    if (Test-Path $f) { Remove-Item $f -Recurse -Force -ErrorAction SilentlyContinue; Write-Host "[DONE] $f"; $Removed.Add($f) }
    else { Write-Host "[SKIP] $f (absent)" }
}

Write-Host ""
Write-Host "== Cleanup summary =="
if ($Removed.Count -eq 0) { Write-Host "  Nothing to clean — workstation already tidy." }
else { $Removed | ForEach-Object { Write-Host "  removed: $_" } }
Write-Host ""
Write-Host "Cleanup does not touch committed files, migrations, or canon."
