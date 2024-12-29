# windows.ps1
############################
# Main setup script for Windows
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Starting Windows setup..." -ForegroundColor Green

# Define the path to the scripts
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$generalScript = Join-Path $scriptDir "windows\general.ps1"
$vsCodeScript = Join-Path $scriptDir "windows\vs-code.ps1"

# Call the general setup script
if (Test-Path $generalScript) {
    Write-Host "Running general setup..." -ForegroundColor Cyan
    & $generalScript
} else {
    Write-Host "Error: General setup script not found at $generalScript" -ForegroundColor Red
}

# Call the VS Code setup script
if (Test-Path $vsCodeScript) {
    Write-Host "Running VS Code setup..." -ForegroundColor Cyan
    & $vsCodeScript
} else {
    Write-Host "Error: VS Code setup script not found at $vsCodeScript" -ForegroundColor Red
}

Write-Host "Windows setup completed!" -ForegroundColor Green