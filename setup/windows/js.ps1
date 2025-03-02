# js.ps1
############################
# This script installs JavaScript-environment stuff
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Starting Js setup..." -ForegroundColor Green

# Define the path to the scripts using $PSScriptRoot
$pnpmScript = Join-Path $PSScriptRoot "js/pnpm.ps1"

# Call the Pnpm setup script
if (Test-Path $pnpmScript) {
    Write-Host "Running Pnpm setup..." -ForegroundColor Cyan
    & $pnpmScript
}
else {
    Write-Host "Error: Pnpm setup script not found at $pnpmScript" -ForegroundColor Red
}

Write-Host "Js setup completed!" -ForegroundColor Green
