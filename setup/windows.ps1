# windows.ps1
############################
# Manual-first setup script for Windows
############################

$ErrorActionPreference = "Stop"

$dotfilesRoot = Split-Path -Parent $PSScriptRoot
$manualSetupPath = Join-Path $PSScriptRoot "windows\manual-setup.md"

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
    Write-Host "Before continuing, complete the manual tool checklist in:" -ForegroundColor Cyan
    Write-Host "  $manualSetupPath" -ForegroundColor Cyan
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

function Invoke-SetupStep {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [scriptblock]$Action
    )

    Write-Host ""
    Write-Host "==> $Name" -ForegroundColor Cyan
    & $Action
}

function Test-Prerequisites {
    Write-Host "TODO: Verify required tools such as Git and PowerShell 7." -ForegroundColor DarkYellow
}

function Install-OrVerifyFonts {
    Write-Host "TODO: Install or verify JetBrains Mono Nerd Font." -ForegroundColor DarkYellow
}

function Install-OrVerifyStarship {
    Write-Host "TODO: Install or verify Starship before linking its config." -ForegroundColor DarkYellow
}

function Set-GitConfig {
    Write-Host "TODO: Symlink Git configuration." -ForegroundColor DarkYellow
}

function Set-PowerShellProfile {
    Write-Host "TODO: Symlink PowerShell profile configuration." -ForegroundColor DarkYellow
}

function Set-WezTermConfig {
    Write-Host "TODO: Symlink WezTerm configuration." -ForegroundColor DarkYellow
}

function Set-StarshipConfig {
    Write-Host "TODO: Symlink Starship configuration." -ForegroundColor DarkYellow
}

function Set-VSCodeConfig {
    Write-Host "TODO: Install VS Code extensions and symlink VS Code configuration." -ForegroundColor DarkYellow
}

function Set-NeovimConfig {
    Write-Host "TODO: Symlink Neovim configuration." -ForegroundColor DarkYellow
}

function Show-SetupSummary {
    Write-Host "TODO: Show setup verification summary." -ForegroundColor DarkYellow
}

Confirm-Administrator

Write-Host "Starting Windows dotfiles setup..." -ForegroundColor Green
Write-Host "Dotfiles root: $dotfilesRoot" -ForegroundColor DarkGray
Write-Host ""

Confirm-ManualChecklistComplete

Invoke-SetupStep "Prerequisites" { Test-Prerequisites }
Invoke-SetupStep "Fonts" { Install-OrVerifyFonts }
Invoke-SetupStep "Starship" { Install-OrVerifyStarship }
Invoke-SetupStep "Git" { Set-GitConfig }
Invoke-SetupStep "PowerShell" { Set-PowerShellProfile }
Invoke-SetupStep "WezTerm" { Set-WezTermConfig }
Invoke-SetupStep "Starship Config" { Set-StarshipConfig }
Invoke-SetupStep "Visual Studio Code" { Set-VSCodeConfig }
Invoke-SetupStep "Neovim" { Set-NeovimConfig }
Invoke-SetupStep "Summary" { Show-SetupSummary }

Write-Host ""
Write-Host "Windows dotfiles setup completed!" -ForegroundColor Green
