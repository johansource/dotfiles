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
. (Join-Path $PSScriptRoot "windows\git.ps1")
. (Join-Path $PSScriptRoot "windows\fonts.ps1")
. (Join-Path $PSScriptRoot "windows\starship.ps1")
. (Join-Path $PSScriptRoot "windows\powershell.ps1")
. (Join-Path $PSScriptRoot "windows\wezterm.ps1")
. (Join-Path $PSScriptRoot "windows\vs-code.ps1")
. (Join-Path $PSScriptRoot "windows\neovim.ps1")

Confirm-Administrator

Write-Host "Starting Windows dotfiles setup..." -ForegroundColor Green
Write-Host "Dotfiles root: $dotfilesRoot" -ForegroundColor DarkGray
Write-Host ""

Confirm-ManualChecklistComplete -ManualSetupPath $manualSetupPath

Invoke-SetupStep "Prerequisites" { Test-Prerequisites }
Invoke-SetupStep "Git" { Set-GitConfig }
Invoke-SetupStep "Fonts" { Install-OrVerifyFonts }
Invoke-SetupStep "Starship" { Install-OrVerifyStarship }
Invoke-SetupStep "Starship Config" { Set-StarshipConfig }
Invoke-SetupStep "PowerShell" { Set-PowerShellProfile }
Invoke-SetupStep "WezTerm" { Set-WezTermConfig }
Invoke-SetupStep "Visual Studio Code" { Set-VSCodeConfig }
Invoke-SetupStep "Neovim" { Set-NeovimConfig }
Invoke-SetupStep "Summary" { Show-SetupSummary }

Write-Host ""
if (@($script:SetupResults | Where-Object { $_.Status -eq "ERROR" }).Count -gt 0) {
    Write-Host "Windows dotfiles setup completed with errors." -ForegroundColor Red
    exit 1
}

Write-Host "Windows dotfiles setup completed!" -ForegroundColor Green
