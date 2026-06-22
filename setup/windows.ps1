# windows.ps1
############################
# Manual-first setup script for Windows
############################

$ErrorActionPreference = "Stop"

$dotfilesRoot = Split-Path -Parent $PSScriptRoot
$manualSetupPath = Join-Path $PSScriptRoot "windows\manual-setup.md"
$script:SetupResults = @()
$script:ToolStatus = @{}

. (Join-Path $PSScriptRoot "windows\common.ps1")
. (Join-Path $PSScriptRoot "windows\prerequisites.ps1")

function Install-OrVerifyFonts {
    Write-Host "TODO: Install or verify JetBrains Mono Nerd Font." -ForegroundColor DarkYellow
}

function Install-OrVerifyStarship {
    if ($script:ToolStatus.Starship) {
        Write-SetupResult -Status "OK" -Name "Starship Install" -Message "Starship is already available."
        return
    }

    if ($script:ToolStatus.Winget) {
        Write-SetupResult -Status "SKIP" -Name "Starship Install" -Message "TODO: Install Starship with Winget."
        return
    }

    Write-SetupResult -Status "WARN" -Name "Starship Install" -Message "Starship is missing and Winget is unavailable."
}

function Set-GitConfig {
    if (-not $script:ToolStatus.Git) {
        Write-SetupResult -Status "SKIP" -Name "Git Config" -Message "Git is unavailable."
        return
    }

    Write-SetupResult -Status "SKIP" -Name "Git Config" -Message "TODO: Symlink Git configuration."
}

function Set-PowerShellProfile {
    if (-not $script:ToolStatus.PowerShell) {
        Write-SetupResult -Status "SKIP" -Name "PowerShell Profile" -Message "PowerShell 7+ is unavailable."
        return
    }

    Write-SetupResult -Status "SKIP" -Name "PowerShell Profile" -Message "TODO: Symlink PowerShell profile configuration."
}

function Set-WezTermConfig {
    if (-not $script:ToolStatus.WezTerm) {
        Write-SetupResult -Status "SKIP" -Name "WezTerm Config" -Message "WezTerm is unavailable."
        return
    }

    Write-SetupResult -Status "SKIP" -Name "WezTerm Config" -Message "TODO: Symlink WezTerm configuration."
}

function Set-StarshipConfig {
    if (-not $script:ToolStatus.Starship) {
        Write-SetupResult -Status "SKIP" -Name "Starship Config" -Message "Starship is unavailable."
        return
    }

    Write-SetupResult -Status "SKIP" -Name "Starship Config" -Message "TODO: Symlink Starship configuration."
}

function Set-VSCodeConfig {
    if (-not $script:ToolStatus.VSCode) {
        Write-SetupResult -Status "SKIP" -Name "Visual Studio Code Config" -Message "VS Code CLI is unavailable."
        return
    }

    Write-SetupResult -Status "SKIP" -Name "Visual Studio Code Config" -Message "TODO: Install VS Code extensions and symlink VS Code configuration."
}

function Set-NeovimConfig {
    if (-not $script:ToolStatus.Neovim) {
        Write-SetupResult -Status "SKIP" -Name "Neovim Config" -Message "Neovim is unavailable."
        return
    }

    Write-SetupResult -Status "SKIP" -Name "Neovim Config" -Message "TODO: Symlink Neovim configuration."
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
if (@($script:SetupResults | Where-Object { $_.Status -eq "ERROR" }).Count -gt 0) {
    Write-Host "Windows dotfiles setup completed with errors." -ForegroundColor Red
    exit 1
}

Write-Host "Windows dotfiles setup completed!" -ForegroundColor Green
