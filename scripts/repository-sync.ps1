Clear-Host

Write-Host ""
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "              ORVION Repository Sync"
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/5] Refreshing project tree..." -ForegroundColor Yellow
cmd /c "tree /f /a > project-tree.txt"

Write-Host "[2/5] Refreshing tracked files..." -ForegroundColor Yellow
git ls-files | Out-File tracked-files.txt -Encoding utf8

Write-Host "[3/5] Refreshing git history..." -ForegroundColor Yellow
git log --graph --decorate --oneline --all | Out-File git-tree.txt -Encoding utf8

Write-Host "[4/5] Staging repository..." -ForegroundColor Yellow
git add .

Write-Host "[5/5] Collecting repository status..." -ForegroundColor Yellow

$status = git status --short

$modified = ($status | Where-Object { $_ -match '^ M|^M ' }).Count
$added    = ($status | Where-Object { $_ -match '^A |^\?\?' }).Count
$deleted  = ($status | Where-Object { $_ -match '^ D|^D ' }).Count
$renamed  = ($status | Where-Object { $_ -match '^R ' }).Count

Write-Host ""
Write-Host "================ Repository Summary ================" -ForegroundColor Cyan

Write-Host ("Modified : {0}" -f $modified)
Write-Host ("Added    : {0}" -f $added)
Write-Host ("Deleted  : {0}" -f $deleted)
Write-Host ("Renamed  : {0}" -f $renamed)

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

git status

Write-Host ""
Write-Host "================ Repository Health =================" -ForegroundColor Cyan

$branch = git branch --show-current
$remote = git remote get-url origin 2>$null

Write-Host ("Branch        : {0}" -f $branch)

if ($remote) {
    Write-Host "Remote        : Connected" -ForegroundColor Green
}
else {
    Write-Host "Remote        : Not Configured" -ForegroundColor Red
}

if ((git status --porcelain).Length -gt 0) {
    Write-Host "Working Tree  : Changes Staged / Pending" -ForegroundColor Yellow
}
else {
    Write-Host "Working Tree  : Clean" -ForegroundColor Green
}

Write-Host "Snapshots     : Updated" -ForegroundColor Green

Write-Host ""
Write-Host "Repository Sync Completed Successfully." -ForegroundColor Green
Write-Host ""