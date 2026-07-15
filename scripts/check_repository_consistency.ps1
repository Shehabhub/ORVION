<#
.SYNOPSIS
  Repository consistency guard — permanent guard (GOVERNANCE.md §18 discovery-to-guard loop)
  for the drift class repaired in the 2026-07-15 Repository Recovery: broken document
  references in Living docs, and contradictory finding-status inside a Master register.

.DESCRIPTION
  Deterministic, dependency-free. Precision over recall — it must not cry wolf, or agents
  will learn to ignore it. Two checks, both scoped to LIVING documents only:

    1) BROKEN REFERENCES — in Living docs (repo-root *.md, _ORVION_CANONICAL/** except the
       two deprecated files, reports/master, reports/evidence, reports root), any strict
       document token (NN_name.md / MASTER_*.md / ADR-####.md) whose basename does not exist.
       Immutable/execution records (changes/**, reports/history/**) and placeholder tokens
       (NN_name.md, SPEC-NNN.md) are intentionally NOT linted.

    2) STATUS CONTRADICTION — within a single reports/master file, a finding ID that is
       shown OPEN in a table-row status cell (| ... | OPEN | ...) while the SAME file also
       marks it resolved (✅ / RESOLVED / IMPLEMENTED). This is the DC-16 row-vs-detail bug.

  Exit 0 = clean; 1 = issue(s) found (gates CI, GOVERNANCE.md §11). Never edits files.

.NOTES
  Run: pwsh -File scripts/check_repository_consistency.ps1
#>

param([string]$RepoRoot = (Resolve-Path "$PSScriptRoot/..").Path)

$ErrorActionPreference = 'Stop'
$issues = 0

# --- File index (basename -> exists) for reference resolution -------------------------------
$allFiles = Get-ChildItem -Path $RepoRoot -Recurse -File |
    Where-Object { $_.FullName -notmatch '[\\/](node_modules|backup|\.git)[\\/]' }
$fileNames = @{}
foreach ($f in $allFiles) { $fileNames[$f.Name.ToLower()] = $true }

# --- Living-doc set (what we lint) ----------------------------------------------------------
$deprecated = @('codex.md','system_prompt.md')
$livingDocs = $allFiles | Where-Object {
    $_.Extension -eq '.md' -and
    $_.FullName -notmatch '[\\/](changes|history)[\\/]' -and
    $deprecated -notcontains $_.Name.ToLower()
}

Write-Host "== Check 1: broken references in Living docs ==" -ForegroundColor Cyan

# Strict document tokens only. Placeholders (NN_, SPEC-NNN) excluded by requiring real digits/letters.
$strictRef = '(?<name>(?:[0-9]{2}_[a-z0-9_]+|MASTER_[A-Z0-9_]+|ADR-[0-9]{4})\.md)'

foreach ($md in $livingDocs) {
    $lineNo = 0
    foreach ($line in [System.IO.File]::ReadAllLines($md.FullName)) {
        $lineNo++
        foreach ($m in [regex]::Matches($line, $strictRef)) {
            $name = $m.Groups['name'].Value.ToLower()
            if (-not $fileNames.ContainsKey($name)) {
                $rel = $md.FullName.Substring($RepoRoot.Length + 1)
                Write-Host "  BROKEN REF: $rel : $lineNo -> $($m.Groups['name'].Value)" -ForegroundColor Yellow
                $issues++
            }
        }
    }
}

Write-Host "== Check 2: intra-file status contradiction in reports/master ==" -ForegroundColor Cyan

$masterDir = Join-Path $RepoRoot 'reports/master'
$idPat = '\b(DC-[0-9]+|R[0-9]+|A[0-9]+|B[0-9]+|N[0-9]+|CDD-[0-9]+|BF-[0-9]+|RC-[0-9]+|OPS-[0-9]+|INV-[0-9]+)\b'

if (Test-Path $masterDir) {
    foreach ($md in Get-ChildItem $masterDir -Filter *.md -File) {
        $openAt = @{}      # id -> "line" where a table-row status cell is exactly OPEN
        $resolvedAt = @{}  # id -> "line" where the id is marked resolved
        $lineNo = 0
        foreach ($line in [System.IO.File]::ReadAllLines($md.FullName)) {
            $lineNo++
            # OPEN only when it is a padded table cell: | OPEN | (kills prose false-positives)
            $rowOpen = $line -match '\|\s*OPEN\s*\|'
            $rowResolved = $line -match '✅|\bRESOLVED\b|\bIMPLEMENTED\b'
            if (-not ($rowOpen -or $rowResolved)) { continue }
            # Only the row's leading ID (first table cell) is the row's subject — avoids
            # counting every id mentioned in a multi-id justification line.
            $leadId = [regex]::Match($line, '^\|\s*(?<id>' + $idPat.Trim('\b') + ')')
            $ids = @()
            if ($leadId.Success) { $ids = @($leadId.Groups['id'].Value) }
            elseif ($line -match '^###\s') {
                # detail-block heading: "### DC-16 — ..." — subject is its leading id
                $h = [regex]::Match($line, '^###\s+(?<id>' + $idPat.Trim('\b') + ')')
                if ($h.Success) { $ids = @($h.Groups['id'].Value) }
            }
            foreach ($id in $ids) {
                if ($rowOpen)     { $openAt[$id]     = $lineNo }
                if ($rowResolved) { $resolvedAt[$id] = $lineNo }
            }
        }
        foreach ($id in $openAt.Keys) {
            if ($resolvedAt.ContainsKey($id)) {
                Write-Host "  STATUS CONTRADICTION: $($md.Name): $id OPEN at line $($openAt[$id]) but resolved at line $($resolvedAt[$id])" -ForegroundColor Yellow
                $issues++
            }
        }
    }
}

Write-Host ""
if ($issues -eq 0) {
    Write-Host "REPOSITORY CONSISTENCY: CLEAN" -ForegroundColor Green
    exit 0
} else {
    Write-Host "REPOSITORY CONSISTENCY: $issues issue(s) found" -ForegroundColor Red
    exit 1
}
