Clear-Host

Write-Host ""
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "             ORVION Repository Publish"
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

$msg = Read-Host "Commit message"

if ([string]::IsNullOrWhiteSpace($msg)) {
    Write-Host ""
    Write-Host "Publish cancelled." -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "Creating commit..." -ForegroundColor Yellow

git commit -m "$msg"

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Commit failed." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Pushing to GitHub..." -ForegroundColor Yellow

git push

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Push failed." -ForegroundColor Red
    exit
}

$commit = git rev-parse --short HEAD
$branch = git branch --show-current

Write-Host ""
Write-Host "================ Publish Summary ===================" -ForegroundColor Cyan

Write-Host ("Branch : {0}" -f $branch)
Write-Host ("Commit : {0}" -f $commit)

Write-Host "Status : Success" -ForegroundColor Green

Write-Host ""
Write-Host "Repository Published Successfully." -ForegroundColor Green
Write-Host ""