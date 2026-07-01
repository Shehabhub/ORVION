Clear-Host

Write-Host ""
Write-Host "===============================" -ForegroundColor Cyan
Write-Host " ORVION Repository Automation"
Write-Host "===============================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/7] Refresh Project Tree..."
cmd /c "tree /f /a > project-tree.txt"

Write-Host "[2/7] Refresh Git Files..."
git ls-files | Out-File tracked-files.txt -Encoding utf8
git log --graph --decorate --oneline --all | Out-File git-tree.txt -Encoding utf8

Write-Host "[3/7] Stage Changes..."
git add .

Write-Host "[4/7] Repository Status..."
git status --short

$msg = Read-Host "`nCommit message"

if ([string]::IsNullOrWhiteSpace($msg)) {
    Write-Host ""
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "[5/7] Commit..."
git commit -m "$msg"

if ($LASTEXITCODE -ne 0) {
    exit
}

Write-Host "[6/7] Push..."
git push

if ($LASTEXITCODE -ne 0) {
    exit
}

Write-Host "[7/7] Done"

$commit = git rev-parse --short HEAD

Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host " Repository Updated Successfully"
Write-Host "=====================================" -ForegroundColor Green
Write-Host "Branch : $(git branch --show-current)"
Write-Host "Commit : $commit"
Write-Host ""