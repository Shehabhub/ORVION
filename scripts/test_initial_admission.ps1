param([string]$SourceRoot,[string]$Helper=(Join-Path $PSScriptRoot 'resolve_initial_admission.ps1'))
$ErrorActionPreference='Stop'
if(-not$SourceRoot){$SourceRoot=Split-Path $PSScriptRoot -Parent}
$work=Join-Path ([IO.Path]::GetTempPath()) ('orvion-initial-admission-'+[guid]::NewGuid().ToString('N'))
$bare=Join-Path $work 'fixture.git';[void][IO.Directory]::CreateDirectory($work)
$old='35865ca63539f74bbaaf7fa624366defcd784d4b';$source='fd118fae6c76271100d67fdb44923bb0b406c986';$adopt='d429e4295f020c5231af82d093fad1c2536b0391'
$cr='changes/SPEC-286-founder-initial-admission.md';$pass=0;$fail=0
$priorIndex=$env:GIT_INDEX_FILE;$priorEvent=$env:GITHUB_REPOSITORY
$priorRoot=$script:Root;$priorTrusted=$script:Trusted;$priorReceiptName=$script:ReceiptName
$fixtureCr=[IO.File]::ReadAllText((Join-Path $SourceRoot 'changes/SPEC-286-founder-initial-admission.md'))
$fixtureCr=[regex]::Replace($fixtureCr,'(?m)^\[x\] (Draft|Approved|In Progress|Complete|Cancelled)[ \t]*(?=\r?$)','[ ] $1').Replace('[ ] In Progress','[x] In Progress')
function G([string[]]$Arguments){$v=@(& git -C $bare @Arguments 2>&1);if($LASTEXITCODE){throw "fixture Git failed: $($Arguments[0])"};($v-join "`n").Trim()}
function Check([string]$Name,[bool]$Ok,[string]$Detail=''){if($Ok){$script:pass++;"PASS $Name"}else{$script:fail++;"FAIL $Name $Detail"}}
function MakeCommit([string]$Path,[string]$Parent=$adopt,[string]$Content=$fixtureCr){
  $env:GIT_INDEX_FILE=Join-Path $work 'fixture.index'
  $null=G @('read-tree',$Parent)
  $blob=($Content | & git -C $bare hash-object -w --stdin).Trim()
  if($LASTEXITCODE){throw 'fixture blob failed'}
  $null=G @('update-index','--add','--cacheinfo','100644',$blob,$Path)
  $tree=G @('write-tree')
  G @('-c','user.name=Boundary fixture','-c','user.email=fixture@invalid.example','commit-tree',$tree,'-p',$Parent,'-m',('isolated boundary fixture '+[guid]::NewGuid().ToString('N')))
}
function InvokeCase([string]$At,[string]$Head,[string]$Base=$old,[string]$Repo='https://github.com/Shehabhub/ORVION.git',[string]$Main=$old,[string]$Event='Shehabhub/ORVION',[string]$Script=$Helper){
  $null=G @('update-ref','refs/heads/probe',$At);$null=G @('symbolic-ref','HEAD','refs/heads/probe')
  $null=G @('update-ref','refs/remotes/origin/main',$Main);$null=G @('remote','set-url','origin',$Repo)
  $env:GITHUB_REPOSITORY=$Event
  $out=@(& pwsh -NoProfile -File $Script -Root $bare -BaseRef $Base -HeadRef $Head 2>&1)
  [pscustomobject]@{Exit=$LASTEXITCODE;Text=($out-join "`n");Admits=($LASTEXITCODE-eq0-and$out.Count-eq1-and"$($out[0])"-ceq$adopt)}
}
function Negative([string]$Name,$Result,[string]$Code){Check $Name ($Result.Exit-ne0-and$Result.Text.Contains('INITIAL_ADMISSION:'+$Code)) $Result.Text}
try{
  & git -c core.hooksPath=$work clone --bare --no-hardlinks --quiet $SourceRoot $bare
  if($LASTEXITCODE){throw 'isolated bare clone failed'}
  if(Test-Path (Join-Path $bare 'objects/info/alternates')){throw 'shared objects forbidden'}
  $null=G @('config','credential.helper','');$null=G @('remote','set-url','--push','origin','DISABLED')
  $null=G @('config','remote.origin.fetch','+refs/heads/*:refs/remotes/origin/*')
  $null=G @('config','branch.probe.remote','origin');$null=G @('config','branch.probe.merge','refs/heads/main')
  $good=MakeCommit $cr;$other=MakeCommit 'changes/SPEC-999-not-the-recovery.md';$rogue=MakeCommit $cr $source;$second=MakeCommit $cr
  $later=MakeCommit $cr $good;$extraContract=MakeCommit 'changes/SPEC-999-not-the-recovery.md' $good
  $parents=G @('show','-s','--format=%P',$adopt)
  $extras=@((G @('diff','--name-only',$source,$adopt))-split"`n")
  Check 'nonempty retained population contains both histories and eight founder-only entries' ($parents-ceq"$source $old"-and$extras.Count-eq8) ("parents=$parents entries=$($extras.Count)")
  $r=InvokeCase $good $good;Check 'exact first recovery boundary resolves to adopted context only' $r.Admits $r.Text
  $r=InvokeCase $good $good -Base ('0'*40);Check 'first preflight push resolves only the exact initial context' $r.Admits $r.Text
  $r=InvokeCase $good $good -Main $good;Check 'exact admitted object main-push replay retains initial range' $r.Admits $r.Text
  $r=InvokeCase $good $good -Base $source -Repo 'https://github.com/PlatPlusHub/CRM.git';Check 'ordinary ranges remain unchanged without applying initial admission' ($r.Exit-eq0-and$r.Text-ceq$source) $r.Text
  $r=InvokeCase $later $later -Base $good -Main $good;Check 'later founder range receives its actual unchanged base' ($r.Exit-eq0-and$r.Text-ceq$good) $r.Text
  Negative 'reuse after an earlier admitted founder head refuses' (InvokeCase $later $later -Main $good) 'TARGET_MOVED'
  Negative 'initial range containing another contract refuses' (InvokeCase $extraContract $extraContract) 'EXACT_RECOVERY_CONTRACT'
  Negative 'wrong target repository refuses' (InvokeCase $good $good -Repo 'https://github.com/PlatPlusHub/CRM.git') 'TARGET_REPOSITORY'
  Negative 'wrong GitHub event repository refuses' (InvokeCase $good $good -Event 'PlatPlusHub/CRM') 'EVENT_REPOSITORY'
  Negative 'moved physical main refuses' (InvokeCase $good $good -Main $source) 'TARGET_MOVED'
  Negative 'bare adopted object has no engineering admission' (InvokeCase $adopt $adopt) 'RECOVERY_CONTRACT_REQUIRED'
  Negative 'head outside adopted ancestry refuses' (InvokeCase $rogue $rogue) 'ADOPTION_NOT_ANCESTOR'
  Negative 'different governing contract refuses' (InvokeCase $other $other) 'EXACT_RECOVERY_CONTRACT'
  Negative 'different root HEAD refuses' (InvokeCase $good $second) 'HEAD_MISMATCH'
  Negative 'abbreviated head refuses' (InvokeCase $good $good.Substring(0,12)) 'FULL_HEAD_REQUIRED'
  $text=[IO.File]::ReadAllText($Helper)
  $mutations=@(
    @('target','Require ($url-match ',{param($s) InvokeCase $good $good -Repo 'https://github.com/PlatPlusHub/CRM.git' -Script $s}),
    @('event','if($env:GITHUB_REPOSITORY)',{param($s) InvokeCase $good $good -Event 'PlatPlusHub/CRM' -Script $s}),
    @('physical-main','Require ($main-ceq',{param($s) InvokeCase $good $good -Main $source -Script $s}),
    @('head','Require ((Git-One ',{param($s) InvokeCase $good $second -Script $s}),
    @('contract','Require ($LASTEXITCODE-eq0-and$contracts.Count',{param($s) InvokeCase $other $other -Script $s}),
    @('ancestry','Require ($LASTEXITCODE-eq0) ''ADOPTION_NOT_ANCESTOR''',{param($s) InvokeCase $rogue $rogue -Script $s})
  )
  foreach($m in $mutations){
    $lines=@($text-split'\r?\n');$matching=@(0..($lines.Count-1)|Where-Object{$lines[$_].StartsWith($m[1],[StringComparison]::Ordinal)})
    Check "mutation $($m[0]) targets exactly one load-bearing predicate" ($matching.Count-eq1)
    if($matching.Count-ne1){continue}
    $lines[$matching[0]]='# deliberately removed by isolated mutation fixture'
    $mutant=Join-Path $work ($m[0]+'.ps1');[IO.File]::WriteAllText($mutant,($lines-join"`n"))
    $escaped=& $m[2] $mutant;$restored=& $m[2] $Helper
    Check "mutation $($m[0]) is killed by a forbidden case and restored refusal" ($escaped.Admits-and-not$restored.Admits-and$restored.Exit-ne0) ("mutant=$($escaped.Exit) restored=$($restored.Exit) "+$escaped.Text)
  }
  # Test the actual Finish precondition with its implementation, not a stubbed command.
  # The bare fixture holds real imported history, but all added recovery states are synthetic.
  $control=Join-Path $SourceRoot 'scripts/check_agent_continuity.ps1'
  $ast=[Management.Automation.Language.Parser]::ParseFile($control,[ref]$null,[ref]$null)
  $defs=(@($ast.EndBlock.Statements|Where-Object{$_-is[Management.Automation.Language.FunctionDefinitionAst]}|ForEach-Object{$_.Extent.Text})-join"`n")
  $importAst=[Management.Automation.Language.Parser]::ParseInput($defs,$control,[ref]$null,[ref]$null)
  . ($importAst.GetScriptBlock())
  . (Join-Path $SourceRoot 'scripts/github_public_read.ps1')
  $script:Root=$bare;$script:Trusted=$false;$script:ReceiptName='.orvion-local-certification.json'
  $null=InvokeCase $good $good
  $legacyRefused=$false
  try{$null=@(Pending-Completions 'refs/remotes/origin/main'|Select-Object -First 1)}catch{$legacyRefused=$_.Exception.Message.StartsWith('CONTRACT_SECTION_Status:')}
  Check 'raw legacy pending enumeration reproduces historical-format refusal without retrofitting history' $legacyRefused
  $c=[pscustomobject]@{Id='SPEC-286'}
  $mapped=Get-InitialAdmissionBase 'refs/remotes/origin/main' HEAD
  Check 'actual local pending consumer resolves the same exact initial context' ($mapped-ceq$adopt) "$mapped"
  $protected=$true;try{Protect-PendingCertifications $c $cr}catch{$protected=$false;$why=$_.Exception.Message}
  Check 'actual pending precondition accepts adopted baseline without minting legacy receipts' ($protected-and-not(Test-Path (Join-Path $bare '.orvion-certifications'))) "$why"
  $definition=@($ast.EndBlock.Statements|Where-Object{$_-is[Management.Automation.Language.FunctionDefinitionAst]-and$_.Name-ceq'Protect-PendingCertifications'})[0].Extent.Text
  $needle='$pendingBase=Get-InitialAdmissionBase ("$upstream").Trim() HEAD'
  Check 'pending mutation targets exactly one context input' ([regex]::Matches($definition,[regex]::Escape($needle)).Count-eq1)
  $mutated=$definition.Replace($needle,'$pendingBase=("$upstream").Trim()')
  . (([Management.Automation.Language.Parser]::ParseInput($mutated,$control,[ref]$null,[ref]$null)).GetScriptBlock());$blocked=$false
  try{Protect-PendingCertifications $c $cr}catch{$blocked=$_.Exception.Message.StartsWith('CONTRACT_SECTION_Status:')}
  . (([Management.Automation.Language.Parser]::ParseInput($definition,$control,[ref]$null,[ref]$null)).GetScriptBlock());$restored=$true
  try{Protect-PendingCertifications $c $cr}catch{$restored=$false}
  Check 'pending context mutation is killed and restored precondition succeeds' ($blocked-and$restored)
  $doneText=$fixtureCr.Replace('[x] In Progress','[ ] In Progress').Replace('[ ] Complete','[x] Complete')
  $done=MakeCommit $cr $good $doneText
  $tail=MakeCommit 'changes/SPEC-999-not-the-recovery.md' $done ($fixtureCr.Replace('SPEC-286','SPEC-999'))
  $null=InvokeCase $tail $tail -Base $good -Main $good
  $pendingStillBlocks=$false
  try{Protect-PendingCertifications ([pscustomobject]@{Id='SPEC-999'}) 'changes/SPEC-999-not-the-recovery.md'}catch{$pendingStillBlocks=$_.Exception.Message.StartsWith('PENDING_RECEIPT_UNBOUND:')}
  Check 'ordinary post-bootstrap unbound completion still blocks before evidence deletion' $pendingStillBlocks
  Check 'prototype push remains disabled' ((G @('remote','get-url','--push','origin'))-ceq'DISABLED')
}finally{
  $env:GIT_INDEX_FILE=$priorIndex;$env:GITHUB_REPOSITORY=$priorEvent
  $script:Root=$priorRoot;$script:Trusted=$priorTrusted;$script:ReceiptName=$priorReceiptName
  # Keep failed fixtures for diagnosis; no shared state or production refs were written.
  "FIXTURE: $work"
}
"== $pass passed, $fail failed =="
if($fail){exit 1}
