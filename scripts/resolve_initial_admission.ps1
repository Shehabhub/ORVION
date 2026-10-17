# Exact owner-approved initial founder range adapter; never a certification verdict.
param([Parameter(Mandatory)][string]$Root,[Parameter(Mandatory)][string]$BaseRef,[Parameter(Mandatory)][string]$HeadRef)
$ErrorActionPreference='Stop'
$old='35865ca63539f74bbaaf7fa624366defcd784d4b'
$source='fd118fae6c76271100d67fdb44923bb0b406c986'
$adopt='d429e4295f020c5231af82d093fad1c2536b0391'
function Git-One([string[]]$Arguments){
    $out=@(& git -C $Root @Arguments 2>$null)
    if($LASTEXITCODE-ne0){throw 'INITIAL_ADMISSION:GIT_UNREADABLE'}
    ($out-join "`n").Trim()
}
function Require([bool]$Condition,[string]$Code){if(-not$Condition){throw "INITIAL_ADMISSION:$Code"}}
if($BaseRef-cne$old-and$BaseRef-cne('0'*40)){Write-Output $BaseRef;exit 0}
$url=Git-One @('remote','get-url','origin')
Require ($url-match '^https://(?:Shehabhub@)?github\.com/Shehabhub/ORVION(?:\.git)?$') 'TARGET_REPOSITORY'
if($env:GITHUB_REPOSITORY){Require ($env:GITHUB_REPOSITORY-eq'Shehabhub/ORVION') 'EVENT_REPOSITORY'}
Require ($HeadRef-cmatch'^[0-9a-f]{40}$') 'FULL_HEAD_REQUIRED'
Require ((Git-One @('rev-parse','HEAD'))-ceq$HeadRef) 'HEAD_MISMATCH'
$main=Git-One @('rev-parse','refs/remotes/origin/main')
# main==head permits the single admitted object's main-push replay, not a later import.
Require ($main-ceq$old-or$main-ceq$HeadRef) 'TARGET_MOVED'
Require ($HeadRef-cne$adopt) 'RECOVERY_CONTRACT_REQUIRED'
$parents=(Git-One @('show','-s','--format=%P',$adopt))
Require ($parents-ceq"$source $old") 'EXACT_ADOPTION_PARENTS'
& git -C $Root merge-base --is-ancestor $adopt $HeadRef 2>$null
Require ($LASTEXITCODE-eq0) 'ADOPTION_NOT_ANCESTOR'
# Exact adoption OID binds its tree, both histories, all source modes and retained extras.
# Every post-adoption commit is still judged by the ordinary Gate; no history PASS is issued.
$contracts=@(& git -C $Root diff --name-only "$adopt..$HeadRef" -- 'changes/SPEC-*.md')
Require ($LASTEXITCODE-eq0-and$contracts.Count-eq1-and$contracts[0]-ceq'changes/SPEC-286-founder-initial-admission.md') 'EXACT_RECOVERY_CONTRACT'
Write-Output $adopt
