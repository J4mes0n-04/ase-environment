[CmdletBinding()]
param(
    [string]$PdeHandoffPath,
    [string]$AseHandoffPath
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$controlRoot = Join-Path $repoRoot 'vendor/engineering-control'
$failures = [System.Collections.Generic.List[string]]::new()

if (-not $PdeHandoffPath -and -not $AseHandoffPath) {
    $PdeHandoffPath = Join-Path $controlRoot 'contracts/examples/pde-to-ase.example.json'
    $AseHandoffPath = Join-Path $controlRoot 'contracts/examples/ase-to-qsre.example.json'
}

function Test-ContractFile {
    param(
        [string]$Path,
        [string]$SchemaName,
        [string]$ExpectedType,
        [string]$ExpectedVersion
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        $script:failures.Add("Contract file not found: $Path")
        return $null
    }

    $schemaPath = Join-Path $controlRoot "contracts/$SchemaName"
    if (-not (Test-Path -LiteralPath $schemaPath)) {
        $script:failures.Add("Pinned contract schema not found: $schemaPath")
        return $null
    }

    try {
        $text = Get-Content -Raw -LiteralPath $Path
        $data = $text | ConvertFrom-Json -Depth 100
        if (-not ($text | Test-Json -SchemaFile $schemaPath -ErrorAction Stop)) {
            $script:failures.Add("Schema validation failed: $Path")
        }
        if ($data.contract_type -ne $ExpectedType) {
            $script:failures.Add("Unexpected contract_type in ${Path}: $($data.contract_type)")
        }
        if ($data.contract_version -ne $ExpectedVersion) {
            $script:failures.Add("Unsupported contract_version in ${Path}: $($data.contract_version)")
        }
        return $data
    } catch {
        $script:failures.Add("Invalid contract ${Path}: $($_.Exception.Message)")
        return $null
    }
}

$pde = $null
$ase = $null
if ($PdeHandoffPath) {
    $pde = Test-ContractFile -Path $PdeHandoffPath -SchemaName 'pde-to-ase.schema.json' -ExpectedType 'pde-to-ase' -ExpectedVersion '1.0.0'
    if ($pde -and $pde.ase_ack.status -eq 'accepted') {
        $blockingQuestions = @($pde.open_questions | Where-Object { $_.blocking -eq $true -and $_.status -eq 'open' })
        if ($blockingQuestions.Count -gt 0) {
            $failures.Add('PDE handoff is accepted while blocking questions remain open')
        }
    }
}
if ($AseHandoffPath) {
    $ase = Test-ContractFile -Path $AseHandoffPath -SchemaName 'ase-to-qsre.schema.json' -ExpectedType 'ase-to-qsre' -ExpectedVersion '1.0.0'
}

if ($pde -and $ase) {
    if ($ase.outcome_id -ne $pde.outcome_id) {
        $failures.Add('Input and output use different outcome_id values')
    }
    if ($ase.pde_handoff_id -ne $pde.handoff_id) {
        $failures.Add('ASE output does not reference the input PDE handoff_id')
    }
    if ($ase.pack.commit_sha -ne $pde.pack.commit_sha -or $ase.pack.version -ne $pde.pack.version) {
        $failures.Add('ASE output changed Pack commit SHA or version')
    }

    $requiredIds = @($pde.requirements.acceptance_criteria.id) + @($pde.requirements.nfrs.id)
    $coveredIds = @($ase.coverage.requirement_id)
    foreach ($id in $requiredIds) {
        if ($id -notin $coveredIds) {
            $failures.Add("ASE output has no coverage for requirement: $id")
        }
    }
    foreach ($id in $coveredIds) {
        if ($id -notin $requiredIds) {
            $failures.Add("ASE output covers an unknown requirement: $id")
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Error ($failures -join [Environment]::NewLine)
    exit 1
}

$validated = @($PdeHandoffPath, $AseHandoffPath | Where-Object { $_ }).Count
Write-Host "ASE handoff validation passed. Contract files checked: $validated."
exit 0

