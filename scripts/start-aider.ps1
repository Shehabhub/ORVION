```powershell
$ProjectRoot = Split-Path -Parent $PSScriptRoot

Set-Location $ProjectRoot

aider `
    --read AGENTS.md `
    --read README.md `
    --read PROJECT_CONTEXT.md `
    --read global-rules.md
```
