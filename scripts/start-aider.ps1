$ProjectRoot = Split-Path -Parent $PSScriptRoot

Set-Location $ProjectRoot

aider `
    --read AGENTS.md `
    --read .ai/rules/global-rules.md `
    --read .ai/packs/current-pack.md