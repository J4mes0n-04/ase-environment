[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$failures = [System.Collections.Generic.List[string]]::new()

foreach ($command in @('git', 'pwsh')) {
    if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
        $failures.Add("Required command is unavailable: $command")
    }
}

$repoRoot = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path -LiteralPath (Join-Path $repoRoot 'vendor/engineering-control/.git'))) {
    $failures.Add('engineering-control submodule is not initialized; run git submodule update --init --recursive')
}

if ($failures.Count -gt 0) {
    Write-Error ($failures -join [Environment]::NewLine)
    exit 1
}

Write-Host 'ASE doctor passed. Git, PowerShell and engineering-control submodule are available.'
exit 0

