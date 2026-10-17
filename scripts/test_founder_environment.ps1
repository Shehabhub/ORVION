# Focused Founder binding tests. Transport fixtures are labelled; no hosted write or owner credential.
$ErrorActionPreference='Stop'
$Root=Split-Path $PSScriptRoot -Parent
$pass=0;$fail=0
function Check($Name,[bool]$Ok){if($Ok){$script:pass++;"PASS $Name"}else{$script:fail++;"FAIL $Name"}}
$temporaryBase=[IO.Path]::GetFullPath([IO.Path]::GetTempPath())
$fixture=Join-Path $temporaryBase ('orvion-founder-target-'+[guid]::NewGuid().ToString('N'))
[void][IO.Directory]::CreateDirectory((Join-Path $fixture 'scripts'))
$guard=Join-Path $fixture 'scripts/check_primary_ledger.ps1'
$config=Join-Path $fixture '.mcp.json'
$evidence=Join-Path $fixture 'evidence.json'
$sourceGuard=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'check_primary_ledger.ps1'))
$configBytes=[IO.File]::ReadAllBytes((Join-Path $Root '.mcp.json'))
$record=Get-Content (Join-Path $Root 'reports/evidence/founder-ledger-evidence.json') -Raw|ConvertFrom-Json
function Write-Record($Object){[IO.File]::WriteAllText($evidence,($Object|ConvertTo-Json -Depth 20))}
function Copy-Record { $record|ConvertTo-Json -Depth 20|ConvertFrom-Json }
function Run-Guard {
    $o=& pwsh -NoProfile -File $guard -EvidencePath $evidence -MigrationDir (Join-Path $Root 'supabase/migrations') 2>&1
    [pscustomobject]@{Exit=$LASTEXITCODE;Text=($o|Out-String)}
}
Push-Location $Root
try {
    git -c core.hooksPath=NUL init -q $fixture
    git -C $fixture remote add origin https://github.com/Shehabhub/ORVION.git
    [IO.File]::WriteAllText($guard,$sourceGuard);[IO.File]::WriteAllBytes($config,$configBytes);Write-Record $record
    $r=Run-Guard;Check 'nonempty actual Founder ledger population is accepted' ($record.ledger.Count -gt 0 -and $r.Exit -eq 0)
    foreach($case in @(
        @{Name='project';Field='project_ref';Bad='vrvtsxexkiiiivlkdxzp';Cut='$ev.project_ref -cne $binding -or '},
        @{Name='read URL';Field='read_project_url';Bad='https://vrvtsxexkiiiivlkdxzp.supabase.co';Cut='$ev.read_project_url -cne "https://$binding.supabase.co" -or '},
        @{Name='connector';Field='read_connector';Bad='supabase-primary';Cut=' -or $ev.read_connector -cne ''supabase-secondary'''}
    )) {
        $bad=Copy-Record;$bad.($case.Field)=$case.Bad;Write-Record $bad
        $r=Run-Guard;Check "wrong $($case.Name) refused with identical ledger/hashes" ($r.Exit -ne 0 -and $r.Text -match 'WRONG PROJECT')
        if(-not $sourceGuard.Contains($case.Cut)){throw "MUTATION_ANCHOR_MOVED:$($case.Name)"}
        [IO.File]::WriteAllText($guard,$sourceGuard.Replace($case.Cut,''));$r=Run-Guard
        Check "removing $($case.Name) predicate admits its forbidden fixture: mutation killed" ($r.Exit -eq 0)
        [IO.File]::WriteAllText($guard,$sourceGuard)
    }
    Write-Record $record
    foreach($uri in @(
        'https://mcp.supabase.com/mcp?project_ref=vrvtsxexkiiiivlkdxzp',
        'https://mcp.supabase.com/mcp?project_ref=brplkqmbzffpxqgkkdzo&project_ref=vrvtsxexkiiiivlkdxzp',
        'https://mcp.supabase.com/mcp',
        'http://mcp.supabase.com/mcp?project_ref=brplkqmbzffpxqgkkdzo'
    )) {
        $m=[Text.Encoding]::UTF8.GetString($configBytes)|ConvertFrom-Json;$m.mcpServers.'supabase-secondary'.url=$uri
        [IO.File]::WriteAllText($config,($m|ConvertTo-Json -Depth 12));$r=Run-Guard
        Check 'wrong, ambiguous, missing or insecure configured project refused' ($r.Exit -ne 0 -and $r.Text -match 'CONFIGURED PROJECT MISMATCH')
    }
    [IO.File]::WriteAllBytes($config,$configBytes)
    foreach($case in @(
        @{Name='HTTPS';Uri='http://mcp.supabase.com/mcp?project_ref=brplkqmbzffpxqgkkdzo';Cut='$uri.Scheme -cne ''https'' -or '},
        @{Name='host';Uri='https://other.invalid/mcp?project_ref=brplkqmbzffpxqgkkdzo';Cut='$uri.Host -cne ''mcp.supabase.com'' -or '},
        @{Name='path';Uri='https://mcp.supabase.com/other?project_ref=brplkqmbzffpxqgkkdzo';Cut=' -or $uri.AbsolutePath -cne ''/mcp'''},
        @{Name='ref value';Uri='https://mcp.supabase.com/mcp?project_ref=vrvtsxexkiiiivlkdxzp';Cut=' -or $refs[0] -cne ''project_ref=brplkqmbzffpxqgkkdzo'''},
        @{Name='ref cardinality';Uri='https://mcp.supabase.com/mcp?project_ref=brplkqmbzffpxqgkkdzo&project_ref=vrvtsxexkiiiivlkdxzp';Cut='$refs.Count -ne 1 -or '}
    )) {
        $m=[Text.Encoding]::UTF8.GetString($configBytes)|ConvertFrom-Json;$m.mcpServers.'supabase-secondary'.url=$case.Uri
        [IO.File]::WriteAllText($config,($m|ConvertTo-Json -Depth 12));$r=Run-Guard
        Check "configured $($case.Name) predicate refuses its forbidden population" ($r.Exit -ne 0)
        if(-not $sourceGuard.Contains($case.Cut)){throw "MUTATION_ANCHOR_MOVED:$($case.Name)"}
        [IO.File]::WriteAllText($guard,$sourceGuard.Replace($case.Cut,''));$r=Run-Guard
        Check "configured $($case.Name) mutation admits the forbidden population: killed" ($r.Exit -eq 0)
        [IO.File]::WriteAllText($guard,$sourceGuard)
    }
    [IO.File]::WriteAllBytes($config,$configBytes)
    git -C $fixture remote set-url --push origin https://github.com/PlatPlusHub/CRM.git
    $r=Run-Guard;Check 'Founder fetch with Platinum push URL is refused' ($r.Exit -ne 0 -and $r.Text -match 'FOUNDER_REPOSITORY_MISMATCH')
    git -C $fixture remote set-url --push origin DISABLED
    $r=Run-Guard;Check 'push-disabled original receipt context remains admissible for reads' ($r.Exit -eq 0)
    git -C $fixture remote set-url origin https://github.com/PlatPlusHub/CRM.git
    $r=Run-Guard;Check 'wrong fetch repository refused' ($r.Exit -ne 0 -and $r.Text -match 'FOUNDER_REPOSITORY_MISMATCH')
    git -C $fixture remote set-url origin https://github.com/Shehabhub/ORVION.git
    foreach($case in @(
        @{Name='fetch identity';Args=@('remote','set-url','origin','https://github.com/PlatPlusHub/CRM.git');Cut='$fetchUrls[0] -notmatch ''^https://(?:Shehabhub@)?github\.com/Shehabhub/ORVION(?:\.git)?$'' -or '},
        @{Name='fetch cardinality';Args=@('remote','set-url','--add','origin','https://github.com/PlatPlusHub/CRM.git');Cut='$fetchUrls.Count -ne 1 -or '},
        @{Name='push identity';Args=@('remote','set-url','--push','origin','https://github.com/PlatPlusHub/CRM.git');Cut=' -or ($pushUrls[0] -cne ''DISABLED'' -and $pushUrls[0] -notmatch ''^https://(?:Shehabhub@)?github\.com/Shehabhub/ORVION(?:\.git)?$'')'},
        @{Name='push cardinality';Args=@('remote','set-url','--add','--push','origin','https://github.com/PlatPlusHub/CRM.git');Cut='$pushUrls.Count -ne 1 -or '}
    )) {
        git -C $fixture config --unset-all remote.origin.url
        git -C $fixture config --add remote.origin.url https://github.com/Shehabhub/ORVION.git
        git -C $fixture config --unset-all remote.origin.pushurl
        git -C $fixture config --add remote.origin.pushurl DISABLED
        $argsForGit=$case.Args;git -C $fixture @argsForGit
        $r=Run-Guard;Check "$($case.Name) refuses the forbidden population" ($r.Exit -ne 0 -and $r.Text -match 'FOUNDER_REPOSITORY_MISMATCH')
        if(-not $sourceGuard.Contains($case.Cut)){throw "MUTATION_ANCHOR_MOVED:$($case.Name)"}
        [IO.File]::WriteAllText($guard,$sourceGuard.Replace($case.Cut,''));$r=Run-Guard
        Check "$($case.Name) mutation admits its forbidden population: killed" ($r.Exit -eq 0)
        [IO.File]::WriteAllText($guard,$sourceGuard)
    }
    git -C $fixture config --unset-all remote.origin.url
    git -C $fixture config --add remote.origin.url https://github.com/Shehabhub/ORVION.git
    git -C $fixture config --unset-all remote.origin.pushurl
    git -C $fixture config --add remote.origin.pushurl DISABLED
    $bad=Copy-Record;$bad.ledger_fingerprint='00000000000000000000000000000000';Write-Record $bad
    $r=Run-Guard;Check 'forged digest refused' ($r.Exit -ne 0 -and $r.Text -match 'SELF-INCONSISTENT')
    $bad=Copy-Record;$bad.repository_head='ffffffffffffffffffffffffffffffffffffffff';Write-Record $bad
    $r=Run-Guard;Check 'untraceable history refused' ($r.Exit -ne 0 -and $r.Text -match 'UNATTRIBUTABLE')
    $bad=Copy-Record;$bad.ledger=@($bad.ledger)+'99999999999999_unapplied_fixture';$bad.migration_count=$bad.ledger.Count
    $bad.ledger_fingerprint=[Convert]::ToHexString([Security.Cryptography.MD5]::HashData([Text.Encoding]::UTF8.GetBytes((@($bad.ledger|Sort-Object -CaseSensitive)-join',')))).ToLowerInvariant();Write-Record $bad
    $r=Run-Guard;Check 'self-consistent but stale migration population refused' ($r.Exit -ne 0 -and $r.Text -match 'REPOSITORY DOES NOT')
    Remove-Item -LiteralPath $evidence
    $r=Run-Guard;Check 'missing evidence refused' ($r.Exit -ne 0 -and $r.Text -match 'MISSING')
    Write-Record $record;$r=Run-Guard;Check 'valid population still accepted after all negatives' ($r.Exit -eq 0)
    # Execute the actual first target predicate, not a copied model of its decision.
    $controller=[IO.File]::ReadAllText((Join-Path $PSScriptRoot 'check_agent_continuity.ps1'))
    $parseErrors=$null;$parseTokens=$null
    $ast=[Management.Automation.Language.Parser]::ParseInput($controller,[ref]$parseTokens,[ref]$parseErrors)
    if($parseErrors.Count){throw 'CONTROLLER_PARSE_ERROR'}
    $overrideIf=@($ast.FindAll({param($n) $n -is [Management.Automation.Language.IfStatementAst] -and $n.Extent.Text -match 'MISSING_REQUIRED_CAPABILITY:supabase-local:project_id_override'},$true)|Where-Object {$_.Extent.Text -notmatch "'supabase-local'  ="})
    if($overrideIf.Count -ne 1){throw 'LOCAL_OVERRIDE_PREDICATE_MOVED'}
    $overrideBlock=$overrideIf[0].Extent.Text
    Check 'local override refusal precedes the Docker/CLI probe' ($controller.Contains("'supabase-local'  =@{Class='LOCAL_PROBE';Probe={`n        "+$overrideBlock))
    $priorOverride=$env:SUPABASE_PROJECT_ID
    try {
        foreach($value in @('', 'ORVION_FOUNDER','orvion_probe_missing_6c764a')) {
            $env:SUPABASE_PROJECT_ID=$value
            $verdict=try{& ([scriptblock]::Create($overrideBlock));'ACCEPT'}catch{$_.Exception.Message}
            Check "local override predicate: '$value'" $(if($value -eq 'orvion_probe_missing_6c764a'){$verdict -match 'project_id_override'}else{$verdict -eq 'ACCEPT'})
        }
        $env:SUPABASE_PROJECT_ID='orvion_probe_missing_6c764a'
        $mutant=$overrideBlock.Replace("$"+"env:SUPABASE_PROJECT_ID-cne'ORVION_FOUNDER'",'$false')
        if($mutant -ceq $overrideBlock){throw 'LOCAL_OVERRIDE_MUTATION_ANCHOR_MOVED'}
        $verdict=try{& ([scriptblock]::Create($mutant));'ACCEPT'}catch{$_.Exception.Message}
        Check 'local override mutation admits forbidden selection: mutation killed' ($verdict -eq 'ACCEPT')
        $doctorSource=[IO.File]::ReadAllText((Join-Path $Root '.workstation/doctor.ps1'))
        $doctorAst=[Management.Automation.Language.Parser]::ParseInput($doctorSource,[ref]$parseTokens,[ref]$parseErrors)
        $doctorIf=@($doctorAst.FindAll({param($n) $n -is [Management.Automation.Language.IfStatementAst] -and $n.Extent.Text -match "Fail 'FOUNDER_LOCAL_PROJECT_OVERRIDE'"},$true))
        if($doctorIf.Count -ne 1){throw 'DOCTOR_OVERRIDE_PREDICATE_MOVED'}
        function Fail($Text){throw $Text}
        $verdict=try{& ([scriptblock]::Create($doctorIf[0].Extent.Text));'ACCEPT'}catch{$_.Exception.Message}
        Check 'Doctor refuses conflicting project override' ($verdict -match 'FOUNDER_LOCAL_PROJECT_OVERRIDE')
        $env:SUPABASE_PROJECT_ID='ORVION_FOUNDER'
        $verdict=try{& ([scriptblock]::Create($doctorIf[0].Extent.Text));'ACCEPT'}catch{$_.Exception.Message}
        Check 'Doctor accepts matching project override' ($verdict -eq 'ACCEPT')
    } finally {$env:SUPABASE_PROJECT_ID=$priorOverride}
    foreach($name in @('verify_api_end_to_end.ps1','verify_storage_end_to_end.ps1','verify_role_journeys.ps1','verify_lifecycle_branches.ps1','verify_journey_branches.ps1','verify_care_journeys.ps1')) {
        $httpSource=[IO.File]::ReadAllText((Join-Path $PSScriptRoot $name))
        $httpAst=[Management.Automation.Language.Parser]::ParseInput($httpSource,[ref]$parseTokens,[ref]$parseErrors)
        $httpIf=@($httpAst.FindAll({param($n) $n -is [Management.Automation.Language.IfStatementAst] -and $n.Extent.Text -match "throw 'FOUNDER_LOCAL_API_TARGET_MISMATCH'"},$true))
        if($httpIf.Count -ne 1 -or $parseErrors.Count){throw "HTTP_TARGET_GUARD_MOVED:$name"}
        $httpBlock=$httpIf[0].Extent.Text
        Check "$name target refusal directly follows local status discovery" ($httpSource.Contains('$API = $status.API_URL'+"`n"+$httpBlock))
        foreach($uri in @('http://127.0.0.1:57421','http://localhost:57421/','http://127.0.0.1:54321','https://other.invalid','http://other.invalid:57421')) {
            $API=$uri;$verdict=try{& ([scriptblock]::Create($httpBlock));'ACCEPT'}catch{$_.Exception.Message}
            $allowed=$uri -in @('http://127.0.0.1:57421','http://localhost:57421/')
            Check "$name URL predicate: $uri" $(if($allowed){$verdict -eq 'ACCEPT'}else{$verdict -match 'FOUNDER_LOCAL_API_TARGET_MISMATCH'})
        }
        $API='http://127.0.0.1:54321'
        $mutant=$httpBlock.Replace('$API -notmatch', '$API -match')
        if($mutant -ceq $httpBlock){throw "HTTP_MUTATION_ANCHOR_MOVED:$name"}
        $verdict=try{& ([scriptblock]::Create($mutant));'ACCEPT'}catch{$_.Exception.Message}
        Check "$name mutation admits forbidden shared port: mutation killed" ($verdict -eq 'ACCEPT')
    }
    # Actual Git metadata, only the Doctor's target block. No auth or remote request is stubbed as live.
    $doctor=[IO.File]::ReadAllText((Join-Path $Root '.workstation/doctor.ps1'))
    $start=$doctor.IndexOf('$originUrl = git remote get-url origin')
    $end=$doctor.IndexOf('git ls-remote origin HEAD',$start)
    if($start -lt 0 -or $end -le $start){throw 'DOCTOR_TARGET_BLOCK_MOVED'}
    $targetBlock=$doctor.Substring($start,$end-$start)
    git -C $fixture config core.hooksPath NUL
    git -C $fixture config user.name 'Founder fixture'
    git -C $fixture config user.email 'fixture@invalid.local'
    git -C $fixture add --all
    git -C $fixture commit -qm 'valid isolated target population'
    function Pass($Text){}
    function Fail($Text){$script:targetFailures+=@($Text)}
    function Invoke-TargetBlock {
        $script:targetFailures=@();Push-Location $fixture
        try{& ([scriptblock]::Create($targetBlock))}finally{Pop-Location}
        @($script:targetFailures)
    }
    git -C $fixture config user.name 'An unrelated commit author'
    git -C $fixture remote set-url --push origin https://github.com/Shehabhub/ORVION.git
    $faults=@(Invoke-TargetBlock);Check 'Doctor target proof accepts Founder and does not equate author with authentication' ($faults.Count -eq 0)
    git -C $fixture remote set-url --push origin https://github.com/PlatPlusHub/CRM.git
    $faults=@(Invoke-TargetBlock);Check 'Doctor rejects a different push target with a correct fetch URL' ($faults -contains 'FOUNDER_PUSH_TARGET_MISMATCH')
    git -C $fixture remote set-url origin https://github.com/PlatPlusHub/CRM.git
    $faults=@(Invoke-TargetBlock);Check 'Doctor rejects a different fetch target' ($faults -contains 'FOUNDER_REPOSITORY_MISMATCH')
    git -C $fixture remote set-url origin https://github.com/Shehabhub/ORVION.git
    git -C $fixture remote set-url --push origin DISABLED
    $faults=@(Invoke-TargetBlock);Check 'Doctor preserves push-disabled execution checkout safety' ($faults.Count -eq 0)
    # Bootstrap validation executes against real temporary Git metadata; pull and provision are not run.
    $bootstrap=[IO.File]::ReadAllText((Join-Path $Root 'bootstrap.ps1'))
    $start=$bootstrap.IndexOf('    $origin = git -C $Target remote get-url origin')
    $end=$bootstrap.IndexOf('    Write-Host "Repository already present',$start)
    if($start -lt 0 -or $end -le $start){throw 'BOOTSTRAP_TARGET_BLOCK_MOVED'}
    $bootstrapBlock=$bootstrap.Substring($start,$end-$start);$Target=$fixture
    git -C $fixture remote set-url --push origin https://github.com/Shehabhub/ORVION.git
    $verdict=try{& ([scriptblock]::Create($bootstrapBlock));'ACCEPT'}catch{$_.Exception.Message}
    Check 'bootstrap existing-checkout validation accepts an intended clean Founder target' ($verdict -eq 'ACCEPT')
    git -C $fixture remote set-url origin https://github.com/PlatPlusHub/CRM.git
    $verdict=try{& ([scriptblock]::Create($bootstrapBlock));'ACCEPT'}catch{$_.Exception.Message}
    Check 'bootstrap refuses an unrelated checkout before pull/provision' ($verdict -match 'FOUNDER_REPOSITORY_MISMATCH')
    git -C $fixture remote set-url origin https://github.com/Shehabhub/ORVION.git
    git -C $fixture remote set-url --push origin https://github.com/PlatPlusHub/CRM.git
    $verdict=try{& ([scriptblock]::Create($bootstrapBlock));'ACCEPT'}catch{$_.Exception.Message}
    Check 'bootstrap refuses a different push target before pull/provision' ($verdict -match 'FOUNDER_PUSH_TARGET_MISMATCH')
    git -C $fixture remote set-url --push origin https://github.com/Shehabhub/ORVION.git
    [IO.File]::WriteAllText((Join-Path $fixture 'untracked-owner-work.txt'),'nonempty preservation fixture')
    $verdict=try{& ([scriptblock]::Create($bootstrapBlock));'ACCEPT'}catch{$_.Exception.Message}
    Check 'bootstrap refuses existing owner work before pull/provision' ($verdict -match 'FOUNDER_CHECKOUT_DIRTY')
    $cut="    if (@(git -C `$Target status --porcelain).Count) { throw 'FOUNDER_CHECKOUT_DIRTY' }"
    if(-not $bootstrapBlock.Contains($cut)){throw 'BOOTSTRAP_DIRTY_MUTATION_ANCHOR_MOVED'}
    $verdict=try{& ([scriptblock]::Create($bootstrapBlock.Replace($cut,'')));'ACCEPT'}catch{$_.Exception.Message}
    Check 'bootstrap dirt predicate mutation admits forbidden population: mutation killed' ($verdict -eq 'ACCEPT')
} finally {
    Pop-Location
    $resolved=[IO.Path]::GetFullPath($fixture)
    if(-not $resolved.StartsWith($temporaryBase,[StringComparison]::OrdinalIgnoreCase) -or (Split-Path $resolved -Leaf) -notlike 'orvion-founder-target-*'){throw 'UNSAFE_FIXTURE_CLEANUP'}
    Remove-Item -LiteralPath $resolved -Recurse -Force
}
# WORKDIR boundary proof; actual executable routes use non-destructive markers.
$R=Split-Path $PSScriptRoot -Parent
. (Join-Path $R 'scripts/assert_founder_local.ps1')
$fixture=Join-Path $temporaryBase ('orvion-local-selection-'+[guid]::NewGuid().ToString('N'))
$founder=Join-Path $fixture 'founder';$other=Join-Path $fixture 'platinum-disposable';$missing=Join-Path $fixture 'absent'
foreach($dir in @($founder,$other)){
    [void][IO.Directory]::CreateDirectory((Join-Path $dir 'supabase'))
    git -C $dir init -q
    git -C $dir remote add origin https://github.com/Shehabhub/ORVION.git
    git -C $dir remote set-url --push origin DISABLED
}
$config=Join-Path $founder 'supabase/config.toml'
[IO.File]::WriteAllText($config,"project_id = `"ORVION_FOUNDER`"`n[api]`nport = 57421`n[db]`nport = 57422`n")
[IO.File]::WriteAllText((Join-Path $other 'supabase/config.toml'),"project_id = `"PLATINUM_DISPOSABLE`"`n")
$savedWorkdir=$env:SUPABASE_WORKDIR;$savedId=$env:SUPABASE_PROJECT_ID
function Verdict([scriptblock]$Call){try{& $Call | Out-Null;'ACCEPT'}catch{$_.Exception.Message}}
try {
    $env:SUPABASE_WORKDIR='';$env:SUPABASE_PROJECT_ID=''
    Check 'nonempty two-project fixture exists with independent Git/config' ((Test-Path $config) -and (Get-Content (Join-Path $other 'supabase/config.toml') -Raw).Contains('PLATINUM_DISPOSABLE'))
    Check 'correct root/default input accepted' ((Verdict {Assert-FounderLocalTarget $founder}) -eq 'ACCEPT')
    $env:SUPABASE_PROJECT_ID='ORVION_FOUNDER';$env:SUPABASE_WORKDIR=$founder
    Check 'matching explicit/environment workdir and project accepted' ((Verdict {Assert-FounderLocalTarget $founder -Workdir $founder}) -eq 'ACCEPT')
    Check 'normalized dot/trailing separator accepted' ((Verdict {Assert-FounderLocalTarget $founder -Workdir (Join-Path $founder '.')}) -eq 'ACCEPT')
    $env:SUPABASE_WORKDIR=$other
    Check 'contradictory inherited directory refused even with correct explicit target' ((Verdict {Assert-FounderLocalTarget $founder -Workdir $founder}) -match 'WORKDIR_MISMATCH')
    $env:SUPABASE_WORKDIR=$missing
    Check 'missing inherited directory refused' ((Verdict {Assert-FounderLocalTarget $founder}) -match 'WORKDIR_MISSING')
    $env:SUPABASE_WORKDIR=$founder
    Check 'conflicting explicit directory refused despite valid environment' ((Verdict {Assert-FounderLocalTarget $founder -Workdir $other}) -match 'WORKDIR_MISMATCH')
    $env:SUPABASE_WORKDIR='';$env:SUPABASE_PROJECT_ID='PLATINUM_DISPOSABLE'
    Check 'contradictory project environment refused' ((Verdict {Assert-FounderLocalTarget $founder}) -match 'PROJECT_OVERRIDE')
    $env:SUPABASE_PROJECT_ID=''
    Check 'wrong configured project refused' ((Verdict {Assert-FounderLocalTarget $other}) -match 'CONFIG_MISMATCH')
    $bytes=[IO.File]::ReadAllBytes($config);Remove-Item -LiteralPath $config
    Check 'missing configuration refused' ((Verdict {Assert-FounderLocalTarget $founder}) -match 'CONFIG_MISSING')
    [IO.File]::WriteAllBytes($config,$bytes)
    git -C $founder remote set-url origin https://github.com/PlatPlusHub/CRM.git
    Check 'wrong Git repository refused' ((Verdict {Assert-FounderLocalTarget $founder}) -match 'REPOSITORY_MISMATCH')
    git -C $founder remote set-url origin https://github.com/Shehabhub/ORVION.git
    Check 'nested unexpected root refused' ((Verdict {Assert-FounderLocalTarget (Join-Path $founder 'supabase')}) -match 'CHECKOUT_MISMATCH')
    Push-Location $other
    Check 'unexpected caller cwd cannot redirect explicit Founder root' ((Verdict {Assert-FounderLocalTarget $founder}) -eq 'ACCEPT')
    $env:SUPABASE_WORKDIR='.'
    Check 'relative inherited directory uses caller cwd and is refused' ((Verdict {Assert-FounderLocalTarget $founder}) -match 'WORKDIR_MISMATCH')
    Pop-Location
    $env:SUPABASE_WORKDIR=''
    # Execute only the actual decommission prefix, ending BEFORE detached removal.
    # Stop is a pinned executable fixture, not Docker. No real decommission is invoked.
    $source=Get-Content (Join-Path $R '.workstation/decommission.ps1') -Raw
    $prefix=$source.Substring(0,$source.IndexOf('# 3. Remove the local repository'))
    if($prefix -notmatch 'Assert-FounderLocalTarget' -or $prefix -notmatch '--project-id ORVION_FOUNDER --workdir'){throw 'DECOMMISSION_BOUNDARY_MOVED'}
    $prefix=$prefix.Replace('$Root = Split-Path $PSScriptRoot -Parent','$Root = $founder')
    $scriptDir=Join-Path $founder 'scripts';[void][IO.Directory]::CreateDirectory($scriptDir)
    Copy-Item (Join-Path $R 'scripts/assert_founder_local.ps1') (Join-Path $scriptDir 'assert_founder_local.ps1')
    $bin=Join-Path $founder 'node_modules/.bin';[void][IO.Directory]::CreateDirectory($bin)
    $marker=Join-Path $fixture 'boundary.txt';$env:ORVION_TARGET_BOUNDARY=$marker
    [IO.File]::WriteAllText((Join-Path $bin 'supabase.cmd'),"@echo off`r`necho %*>>`"%ORVION_TARGET_BOUNDARY%`"`r`nexit /b 0`r`n")
    function Read-Host { 'DECOMMISSION' }
    Push-Location $other
    & ([scriptblock]::Create($prefix)) | Out-Null
    Check 'actual decommission prefix selects Founder from wrong cwd' ((Get-Content $marker -Raw) -match 'stop --project-id ORVION_FOUNDER --workdir .*founder')
    Remove-Item -LiteralPath $marker
    $env:SUPABASE_WORKDIR=$other
    $verdict=Verdict { & ([scriptblock]::Create($prefix)) }
    Check 'actual decommission refuses before executable boundary' ($verdict -match 'WORKDIR_MISMATCH' -and -not (Test-Path $marker))
    # Remove exactly the shared call; the nonempty forbidden fixture reaches stop.
    $mutant=$prefix.Replace('$Root = Assert-FounderLocalTarget -Root $Root','# removed target assertion')
    if($mutant -ceq $prefix){throw 'DECOMMISSION_MUTATION_ANCHOR_MOVED'}
    & ([scriptblock]::Create($mutant)) | Out-Null
    Check 'removing decommission assertion reaches forbidden-input stop boundary: mutation killed' (Test-Path $marker)
    Pop-Location
    # Independent predicate mutations, evaluated against real populated fixtures.
    $helper=Get-Content (Join-Path $R 'scripts/assert_founder_local.ps1') -Raw
    foreach($case in @(
        @{Name='directory';From="throw 'FOUNDER_LOCAL_WORKDIR_MISMATCH'";Setup={$env:SUPABASE_WORKDIR=$other};Code='WORKDIR_MISMATCH'},
        @{Name='project';From="throw 'FOUNDER_LOCAL_PROJECT_OVERRIDE'";Setup={$env:SUPABASE_PROJECT_ID='PLATINUM_DISPOSABLE'};Code='PROJECT_OVERRIDE'},
        @{Name='config';From="throw 'FOUNDER_LOCAL_CONFIG_MISMATCH'";Setup={ [IO.File]::WriteAllText($config,'project_id = "PLATINUM_DISPOSABLE"') };Code='CONFIG_MISMATCH'},
        @{Name='repository';From="throw 'FOUNDER_LOCAL_REPOSITORY_MISMATCH'";Setup={git -C $founder remote set-url origin https://github.com/PlatPlusHub/CRM.git};Code='REPOSITORY_MISMATCH'}
    )) {
        $env:SUPABASE_WORKDIR='';$env:SUPABASE_PROJECT_ID='';[IO.File]::WriteAllBytes($config,$bytes)
        git -C $founder remote set-url origin https://github.com/Shehabhub/ORVION.git
        . ([scriptblock]::Create($helper))
        Check "$($case.Name) valid population accepted before mutation" ((Verdict {Assert-FounderLocalTarget $founder}) -eq 'ACCEPT')
        & $case.Setup
        Check "$($case.Name) invalid population refused" ((Verdict {Assert-FounderLocalTarget $founder}) -match $case.Code)
        if(-not $helper.Contains($case.From)){throw 'MUTATION_ANCHOR_MOVED'}
        . ([scriptblock]::Create($helper.Replace($case.From,'$null = 0')))
        Check "$($case.Name) predicate removal admits forbidden input: mutation killed" ((Verdict {Assert-FounderLocalTarget $founder}) -eq 'ACCEPT')
    }
    . (Join-Path $R 'scripts/assert_founder_local.ps1')
    $env:SUPABASE_WORKDIR='';$env:SUPABASE_PROJECT_ID=''
    [IO.File]::WriteAllBytes($config,$bytes)
    git -C $founder remote set-url origin https://github.com/Shehabhub/ORVION.git
    $env:SUPABASE_CLI_BINARY_OVERRIDE=Join-Path $other 'untrusted.exe'
    Check 'installed npm launcher executable override refused' ((Verdict {Assert-FounderLocalTarget $founder}) -match 'CLI_OVERRIDE')
    Remove-Item Env:SUPABASE_CLI_BINARY_OVERRIDE
    # The actual six discovery prefixes, with only the pinned executable replaced by a marker.
    [IO.File]::WriteAllText((Join-Path $bin 'supabase.cmd'),"@echo off`r`necho %*>>`"%ORVION_TARGET_BOUNDARY%`"`r`necho {`"API_URL`":`"http://127.0.0.1:57421`"}`r`nexit /b 0`r`n")
    foreach($name in 'api_end_to_end','storage_end_to_end','role_journeys','lifecycle_branches','journey_branches','care_journeys') {
        $httpSource=Get-Content (Join-Path $R "scripts/verify_$name.ps1") -Raw
        $first=$httpSource.IndexOf('. (Join-Path $PSScriptRoot ''assert_founder_local.ps1'')')
        $end=$httpSource.IndexOf('}', $httpSource.IndexOf("throw 'FOUNDER_LOCAL_API_TARGET_MISMATCH'",$first))+1
        if($first -lt 0 -or $end -lt 0){throw "HTTP_PREFIX_MOVED:$name"}
        $route=$httpSource.Substring($first,$end-$first).Replace('$PSScriptRoot',"(Join-Path `$founder 'scripts')")
        Remove-Item -LiteralPath $marker -ErrorAction SilentlyContinue
        Push-Location $other
        Check "$name discovery accepted from foreign cwd using explicit root" ((Verdict { & ([scriptblock]::Create($route)) }) -eq 'ACCEPT')
        Check "$name pinned status boundary uses explicit Founder directory" ((Get-Content $marker -Raw) -match 'status -o json --workdir .*founder')
        Remove-Item -LiteralPath $marker
        $env:SUPABASE_WORKDIR=$other
        Check "$name foreign workdir refused before status or HTTP" ((Verdict { & ([scriptblock]::Create($route)) }) -match 'WORKDIR_MISMATCH' -and -not (Test-Path $marker))
        $env:SUPABASE_WORKDIR=''
        Pop-Location
    }
    $controller=Get-Content (Join-Path $R 'scripts/check_agent_continuity.ps1') -Raw
    $capAst=[Management.Automation.Language.Parser]::ParseInput($controller,[ref]$null,[ref]$null)
    $probes=@($capAst.FindAll({param($n) $n -is [Management.Automation.Language.ScriptBlockExpressionAst] -and $n.Extent.Text -match '^\{\s*if\(\$env:SUPABASE_PROJECT_ID' -and $n.Extent.Text -match 'MISSING_REQUIRED_CAPABILITY:supabase-local:project_id_override'},$true))
    if($probes.Count -ne 1){throw 'CAPABILITY_PROBE_MOVED'}
    $probe=$probes[0].ScriptBlock.GetScriptBlock()
    $Root=$founder;$script:dockerReached=$false
    function docker { $script:dockerReached=$true; $global:LASTEXITCODE=0 }
    $nativeAllowed=Verdict { & $probe }
    if($nativeAllowed -ne 'ACCEPT'){"DIAGNOSTIC native allowed: $nativeAllowed"}
    Check 'actual native capability accepts valid populated fixture' ($nativeAllowed -eq 'ACCEPT' -and $script:dockerReached)
    $script:dockerReached=$false;$env:SUPABASE_WORKDIR=$other
    $nativeDenied=Verdict { & $probe }
    if($nativeDenied -notmatch 'WORKDIR_MISMATCH'){"DIAGNOSTIC native denied: $nativeDenied"}
    Check 'actual native capability refuses before Docker boundary' ($nativeDenied -match 'WORKDIR_MISMATCH' -and -not $script:dockerReached)
    $env:SUPABASE_WORKDIR=''
    $batch=Get-Content (Join-Path $R 'scripts/batch6_select_target.ps1') -Raw
    $begin=$batch.IndexOf('$container = ''supabase_db_ORVION_FOUNDER''')
    $end=$batch.IndexOf('if (-not $container)', $begin)
    if($begin -lt 0 -or $end -lt 0){throw 'BATCH6_SELECTOR_MOVED'}
    $selection=$batch.Substring($begin,$end-$begin)
    $script:listed=@('supabase_db_PLATINUM_DISPOSABLE','supabase_db_ORVION_FOUNDER');$script:listExit=0
    function docker { $global:LASTEXITCODE=$script:listExit; $script:listed }
    $selected=& ([scriptblock]::Create($selection+'; $container'))
    Check 'actual Batch 6 selector chooses Founder when another project is first' ($selected -ceq 'supabase_db_ORVION_FOUNDER')
    $script:listed=@('supabase_db_PLATINUM_DISPOSABLE')
    $selected=& ([scriptblock]::Create($selection+'; $container'))
    Check 'actual Batch 6 selector does not substitute another running project' ($null -eq $selected)
    $script:listed=@('supabase_db_PLATINUM_DISPOSABLE','supabase_db_ORVION_FOUNDER');$script:listExit=1
    $selected=& ([scriptblock]::Create($selection+'; $container'))
    Check 'actual Batch 6 selector fails closed on unreadable Docker inventory' ($null -eq $selected)
    $script:listExit=0
    $mutant=$selection.Replace("'supabase_db_ORVION_FOUNDER'","'supabase_db_PLATINUM_DISPOSABLE'")
    if($mutant -ceq $selection){throw 'BATCH6_MUTATION_ANCHOR_MOVED'}
    $selected=& ([scriptblock]::Create($mutant+'; $container'))
    Check 'Batch 6 selector mutation chooses forbidden populated project: mutation killed' ($selected -ceq 'supabase_db_PLATINUM_DISPOSABLE')
    foreach($wf in 'migration-ci','orvion-acceptance') {
        $yaml=Get-Content (Join-Path $R ".github/workflows/$wf.yml") -Raw
        $calls=@([regex]::Matches($yaml,'(?m)^\s*(?:run:\s*)?node_modules/\.bin/supabase.*$'))
        # start/reset/test follow && on the same line, cleanup is a separate guarded Bash line.
        $all=@([regex]::Matches($yaml,'(?m)^.*(?:run:.*&&\s+node_modules/\.bin/supabase|^\s+node_modules/\.bin/supabase).*$'))
        Check "$wf has four explicitly bound runtime calls" ($all.Count -eq 4 -and @($all|Where-Object {$_.Value -notmatch '--workdir "\$GITHUB_WORKSPACE"'}).Count -eq 0)
        Check "$wf reset/test explicitly local, stop explicitly one project" ($yaml -match 'db reset --local' -and $yaml -match 'test db --local' -and $yaml -match 'stop --project-id ORVION_FOUNDER' -and $yaml -notmatch 'supabase stop --all')
    }
} finally {
    $env:SUPABASE_WORKDIR=$savedWorkdir;$env:SUPABASE_PROJECT_ID=$savedId
    Remove-Item Env:ORVION_TARGET_BOUNDARY -ErrorAction SilentlyContinue
    if (-not ([IO.Path]::GetFullPath($fixture)).StartsWith($temporaryBase,[StringComparison]::OrdinalIgnoreCase)) { throw 'UNSAFE_TARGET_FIXTURE_CLEANUP' }; Remove-Item -LiteralPath $fixture -Recurse -Force
}
"FOUNDER ENVIRONMENT: $pass passed, $fail failed"
if($fail){exit 1}
