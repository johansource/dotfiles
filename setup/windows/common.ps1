# common.ps1
############################
# Shared helpers for Windows dotfiles setup
############################

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity

    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

function Confirm-Administrator {
    if (-not (Test-IsAdministrator)) {
        Write-Host "Please run this script as Administrator." -ForegroundColor Red
        exit 1
    }
}

function Confirm-ManualChecklistComplete {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ManualSetupPath
    )

    Write-Host "Before continuing, complete the manual tool checklist in:" -ForegroundColor Cyan
    Write-Host "  $ManualSetupPath" -ForegroundColor Cyan
    Write-Host ""

    $manualStepsCompleted = (Read-Host "Have you completed the required manual checklist? [y/N]").Trim().ToLowerInvariant()

    if ($manualStepsCompleted -notin @("y", "yes")) {
        Write-Host ""
        Write-Host "Please complete the manual checklist before running this script again." -ForegroundColor Yellow
        exit 1
    }

    Write-Host ""
    Write-Host "Manual checklist confirmed. Continuing..." -ForegroundColor Green
}

function Add-SetupResult {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("OK", "WARN", "ERROR", "SKIP")]
        [string]$Status,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $script:SetupResults += [PSCustomObject]@{
        Status  = $Status
        Name    = $Name
        Message = $Message
    }
}

function Write-SetupResult {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("OK", "WARN", "ERROR", "SKIP")]
        [string]$Status,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    $color = switch ($Status) {
        "OK" { "Green" }
        "WARN" { "Yellow" }
        "ERROR" { "Red" }
        "SKIP" { "DarkYellow" }
    }

    Write-Host "[$Status] $Name - $Message" -ForegroundColor $color
    Add-SetupResult -Status $Status -Name $Name -Message $Message
}

function Test-CommandAvailable {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Command
    )

    return $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

function Get-CommandSource {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Command
    )

    $commandInfo = Get-Command $Command -ErrorAction SilentlyContinue
    if (-not $commandInfo) {
        return $null
    }

    return $commandInfo.Source
}

function Test-FileExists {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    return Test-Path -LiteralPath $Path -PathType Leaf
}

function Test-DirectoryExists {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    return Test-Path -LiteralPath $Path -PathType Container
}

function New-DirectoryIfMissing {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-DirectoryExists -Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Resolve-NormalizedPath {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $resolvedPath = Resolve-Path -LiteralPath $Path -ErrorAction SilentlyContinue
    if ($resolvedPath) {
        return $resolvedPath.ProviderPath.TrimEnd("\")
    }

    return [System.IO.Path]::GetFullPath($Path).TrimEnd("\")
}

function Test-SymlinkTarget {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$Target
    )

    $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    if (-not $item -or $item.LinkType -ne "SymbolicLink") {
        return $false
    }

    $actualTarget = Resolve-NormalizedPath -Path $item.Target
    $expectedTarget = Resolve-NormalizedPath -Path $Target

    return $actualTarget -eq $expectedTarget
}

function New-SafeSymlink {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Source,

        [Parameter(Mandatory = $true)]
        [string]$Target,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if (-not (Test-FileExists -Path $Source)) {
        Write-SetupResult -Status "ERROR" -Name $Name -Message "Source file not found: $Source"
        return
    }

    $targetDirectory = Split-Path -Parent $Target
    New-DirectoryIfMissing -Path $targetDirectory

    if (Test-SymlinkTarget -Path $Target -Target $Source) {
        Write-SetupResult -Status "OK" -Name $Name -Message "Already linked."
        return
    }

    if (Test-Path -LiteralPath $Target) {
        Write-SetupResult -Status "WARN" -Name $Name -Message "Target already exists and was left untouched: $Target"
        return
    }

    New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
    Write-SetupResult -Status "OK" -Name $Name -Message "Linked $Target"
}

function Invoke-SetupStep {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [scriptblock]$Action
    )

    Write-Host ""
    Write-Host "==> $Name" -ForegroundColor Cyan
    try {
        & $Action
    }
    catch {
        Write-SetupResult -Status "ERROR" -Name $Name -Message $_.Exception.Message
    }
}

function Show-SetupSummary {
    $errors = @($script:SetupResults | Where-Object { $_.Status -eq "ERROR" })
    $warnings = @($script:SetupResults | Where-Object { $_.Status -eq "WARN" })

    Write-Host "Results: $($script:SetupResults.Count) total, $($warnings.Count) warning(s), $($errors.Count) error(s)." -ForegroundColor Cyan

    if ($errors.Count -gt 0) {
        Write-Host "Fix the reported errors, then run the setup again." -ForegroundColor Red
    }
}
