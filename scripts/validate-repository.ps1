[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$failures = [System.Collections.Generic.List[string]]::new()

$requiredPaths = @(
    'README.md', 'AGENTS.md', 'CONTRIBUTING.md', 'SECURITY.md', 'CHANGELOG.md',
    '.gitmodules', 'config/control-plane.yaml', 'config/features.yaml',
    'architecture/system-context.md', 'architecture/repository-layout.md',
    'operations/onboarding.md', 'operations/handoff-runbook.md',
    'templates/ase-ack.md', 'templates/implementation-plan.md', 'templates/evidence-map.md',
    'workspaces/README.md', 'workspaces/projects/README.md',
    'scripts/doctor.ps1', 'scripts/validate-repository.ps1', 'scripts/validate-handoffs.ps1',
    '.github/CODEOWNERS', '.github/pull_request_template.md', '.github/workflows/validate-ase.yml',
    '.agents/skills/ase-accept-handoff/SKILL.md',
    '.agents/skills/ase-plan-implementation/SKILL.md',
    '.agents/skills/ase-build-evidence/SKILL.md',
    '.agents/skills/ase-prepare-qsre-handoff/SKILL.md',
    'vendor/engineering-control/contracts/pde-to-ase.schema.json',
    'vendor/engineering-control/contracts/ase-to-qsre.schema.json'
)

foreach ($relativePath in $requiredPaths) {
    if (-not (Test-Path -LiteralPath (Join-Path $repoRoot $relativePath))) {
        $failures.Add("Missing required path: $relativePath")
    }
}

$controlConfigPath = Join-Path $repoRoot 'config/control-plane.yaml'
if (Test-Path -LiteralPath $controlConfigPath) {
    $controlConfig = Get-Content -Raw -LiteralPath $controlConfigPath
    foreach ($requiredPattern in @(
        '(?m)^mode:\s+shadow\s*$',
        '(?m)^\s+tag:\s+v1\.0\.0-rc\.1\s*$',
        '(?m)^\s+commit:\s+abd0982171341438cab80267099b951a2027be0b\s*$',
        '(?m)^\s+status:\s+staging\s*$',
        '(?m)^\s+authoritative:\s+false\s*$'
    )) {
        if ($controlConfig -notmatch $requiredPattern) {
            $failures.Add("control-plane.yaml does not match required RC pin: $requiredPattern")
        }
    }
}

$featuresPath = Join-Path $repoRoot 'config/features.yaml'
if (Test-Path -LiteralPath $featuresPath) {
    $features = Get-Content -Raw -LiteralPath $featuresPath
    if ($features -notmatch '(?ms)openspace_local:\s+enabled:\s+false.*?cloud_mode:\s+off') {
        $failures.Add('OpenSpace must remain disabled and cloud_mode must be off')
    }
    foreach ($feature in @('unleash', 'opentelemetry', 'grafana')) {
        if ($features -notmatch "(?ms)${feature}:\s+enabled:\s+false") {
            $failures.Add("Optional feature must be disabled initially: $feature")
        }
    }
}

$submodulePath = Join-Path $repoRoot 'vendor/engineering-control'
if (Test-Path -LiteralPath $submodulePath) {
    $actualCommit = (& git -C $submodulePath rev-parse HEAD 2>$null).Trim()
    if ($LASTEXITCODE -ne 0 -or $actualCommit -ne 'abd0982171341438cab80267099b951a2027be0b') {
        $failures.Add("engineering-control submodule is not pinned to the approved commit; actual=$actualCommit")
    }
    $gitlink = (& git -C $repoRoot ls-files --stage -- vendor/engineering-control 2>$null) -join ''
    if ($LASTEXITCODE -ne 0 -or $gitlink -notmatch '^160000\s+abd0982171341438cab80267099b951a2027be0b\s') {
        $failures.Add('Parent repository gitlink is not pinned to the approved engineering-control commit')
    }
    $vendorChanges = @(& git -C $submodulePath status --porcelain 2>$null)
    if ($LASTEXITCODE -ne 0 -or $vendorChanges.Count -gt 0) {
        $failures.Add('engineering-control vendor submodule contains local changes')
    }
}

$skillFiles = @(Get-ChildItem -LiteralPath (Join-Path $repoRoot '.agents/skills') -Filter 'SKILL.md' -File -Recurse -ErrorAction SilentlyContinue)
if ($skillFiles.Count -ne 4) {
    $failures.Add("Expected 4 initial ASE skills; found $($skillFiles.Count)")
}

foreach ($jsonFile in @(Get-ChildItem -LiteralPath $repoRoot -Filter '*.json' -File -Recurse -Force | Where-Object { $_.FullName -notmatch '[\\/]vendor[\\/]' })) {
    try {
        Get-Content -Raw -LiteralPath $jsonFile.FullName | ConvertFrom-Json -Depth 100 | Out-Null
    } catch {
        $failures.Add("Invalid JSON: $([IO.Path]::GetRelativePath($repoRoot, $jsonFile.FullName))")
    }
}

$markdownFiles = @(Get-ChildItem -LiteralPath $repoRoot -Filter '*.md' -File -Recurse -Force | Where-Object { $_.FullName -notmatch '[\\/]vendor[\\/]' })
foreach ($markdownFile in $markdownFiles) {
    $text = Get-Content -Raw -LiteralPath $markdownFile.FullName
    foreach ($match in [regex]::Matches($text, '\[[^\]]+\]\(([^)]+)\)')) {
        $target = $match.Groups[1].Value.Trim().Trim('<', '>')
        if ($target -match '^(https?://|mailto:|#)') { continue }
        $pathPart = ($target -split '#', 2)[0]
        if (-not $pathPart) { continue }
        $absoluteTarget = Join-Path $markdownFile.DirectoryName ([Uri]::UnescapeDataString($pathPart))
        if (-not (Test-Path -LiteralPath $absoluteTarget)) {
            $relativeSource = [IO.Path]::GetRelativePath($repoRoot, $markdownFile.FullName)
            $failures.Add("Broken local link in ${relativeSource}: $target")
        }
    }
}

& (Join-Path $PSScriptRoot 'validate-handoffs.ps1')
if ($LASTEXITCODE -ne 0) {
    $failures.Add('Default handoff contract validation failed')
}

if ($failures.Count -gt 0) {
    Write-Error ($failures -join [Environment]::NewLine)
    exit 1
}

Write-Host "ASE repository is valid. Skills: $($skillFiles.Count). Markdown files: $($markdownFiles.Count)."
exit 0
