```powershell
$ProjectRoot = Split-Path -Parent $PSScriptRoot

Set-Location $ProjectRoot

aider `
    --read AGENTS.md `
    --read README.md `
    --read docs/PROJECT_CONTEXT.md `
    --read .ai/rules/global-rules.md
```
