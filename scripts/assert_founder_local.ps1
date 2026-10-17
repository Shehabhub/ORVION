# One assertion for repository-owned local CLI calls; no command execution or verdict authority.
# Callers bind --workdir to the returned root. Conflicting inputs are refused, never cleared.
function Assert-FounderLocalTarget {
    param([Parameter(Mandatory)][string]$Root, [string]$Workdir = $Root)
    if ($env:SUPABASE_CLI_BINARY_OVERRIDE) { throw 'FOUNDER_LOCAL_CLI_OVERRIDE' }
    $expected = [IO.Path]::GetFullPath((Resolve-Path -LiteralPath $Root -ErrorAction Stop).ProviderPath).TrimEnd('\','/')
    foreach ($inputPath in @($Workdir, $env:SUPABASE_WORKDIR)) {
        if ([string]::IsNullOrEmpty($inputPath)) { continue }
        try { $actual = [IO.Path]::GetFullPath((Resolve-Path -LiteralPath $inputPath -ErrorAction Stop).ProviderPath).TrimEnd('\','/') }
        catch { throw 'FOUNDER_LOCAL_WORKDIR_MISSING' }
        if (-not [string]::Equals($actual,$expected,[StringComparison]::OrdinalIgnoreCase)) { throw 'FOUNDER_LOCAL_WORKDIR_MISMATCH' }
    }
    if ($env:SUPABASE_PROJECT_ID -and $env:SUPABASE_PROJECT_ID -cne 'ORVION_FOUNDER') { throw 'FOUNDER_LOCAL_PROJECT_OVERRIDE' }
    $top = git -C $expected rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -ne 0 -or -not [string]::Equals([IO.Path]::GetFullPath([string]$top).TrimEnd('\','/'),$expected,[StringComparison]::OrdinalIgnoreCase)) { throw 'FOUNDER_LOCAL_CHECKOUT_MISMATCH' }
    $origins = @(git -C $expected remote get-url --all origin 2>$null)
    if ($LASTEXITCODE -ne 0 -or $origins.Count -ne 1 -or $origins[0] -notmatch '^https://(?:Shehabhub@)?github\.com/Shehabhub/ORVION(?:\.git)?$') { throw 'FOUNDER_LOCAL_REPOSITORY_MISMATCH' }
    $config = Join-Path $expected 'supabase/config.toml'
    if (-not (Test-Path -LiteralPath $config -PathType Leaf)) { throw 'FOUNDER_LOCAL_CONFIG_MISSING' }
    # project_id is a root TOML key; a repeated key or a table-local lookalike cannot satisfy it.
    $header = ([IO.File]::ReadAllText($config) -split '(?m)^\s*\[',2)[0]
    $ids = [regex]::Matches($header,'(?m)^project_id\s*=\s*"ORVION_FOUNDER"\s*(?:#.*)?$')
    if ($ids.Count -ne 1) { throw 'FOUNDER_LOCAL_CONFIG_MISMATCH' }
    $expected
}
