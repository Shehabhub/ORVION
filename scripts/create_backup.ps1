$src='c:\Projects\ORVION\Orvion'
$ts=Get-Date -Format 'yyyyMMdd_HHmm'
$dest='c:\Projects\ORVION\_BACKUP_'+$ts
New-Item -ItemType Directory -Path $dest -Force | Out-Null
Copy-Item -Path "$src\*" -Destination $dest -Recurse -Force
$filesSrc=(Get-ChildItem -Path $src -Recurse -File | Measure-Object).Count
$filesDst=(Get-ChildItem -Path $dest -Recurse -File | Measure-Object).Count
$sizeSrc=(Get-ChildItem -Path $src -Recurse -File | Measure-Object -Property Length -Sum).Sum
$sizeDst=(Get-ChildItem -Path $dest -Recurse -File | Measure-Object -Property Length -Sum).Sum
Write-Output "BACKUP_PATH=$dest"
Write-Output "SRC_FILES=$filesSrc"
Write-Output "DST_FILES=$filesDst"
Write-Output "SRC_BYTES=$sizeSrc"
Write-Output "DST_BYTES=$sizeDst"
$samples=@("$src\_ORVION_CANONICAL\31_schema_draft.md","$src\AGENTS.md","$src\README.md")
foreach($f in $samples){
  if(Test-Path $f){
    $srcHash=(Get-FileHash -Path $f -Algorithm SHA256).Hash
    $dstPath=$f -replace [regex]::Escape($src), $dest
    $dstHash=(Get-FileHash -Path $dstPath -Algorithm SHA256).Hash
    Write-Output "CHECK:"
    Write-Output "SRC_FILE=$f"
    Write-Output "DST_FILE=$dstPath"
    Write-Output "SRC_HASH=$srcHash"
    Write-Output "DST_HASH=$dstHash"
  } else { Write-Output "MISSING_SAMPLE=$f" }
}
