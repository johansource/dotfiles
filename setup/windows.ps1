# windows.ps1
############################
# Main setup script for Windows
############################

param (
    [switch]$Dev,
    [switch]$Gaming,
    [switch]$GameDev,
    [switch]$Python,
    [switch]$Js
)

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Starting Windows setup..." -ForegroundColor Green

# Define the path to the scripts
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$generalScript = Join-Path $scriptDir "windows\general.ps1"

# Call the general setup script
if (Test-Path $generalScript) {
    Write-Host "Running general setup..." -ForegroundColor Cyan
    & $generalScript
}
else {
    Write-Host "Error: General setup script not found at $generalScript" -ForegroundColor Red
}

# Call the development setup script only if Dev flag is provided
if ($Dev) {
    $devScript = Join-Path $scriptDir "windows\dev.ps1"
    if (Test-Path $devScript) {
        Write-Host "Running development setup..." -ForegroundColor Cyan
        & $devScript
    }
    else {
        Write-Host "Error: Development setup script not found at $devScript" -ForegroundColor Red
    }
}

# Call the gaming setup script only if Gaming flag is provided
if ($Gaming) {
    $gamingScript = Join-Path $scriptDir "windows\gaming.ps1"
    if (Test-Path $gamingScript) {
        Write-Host "Running gaming setup..." -ForegroundColor Cyan
        & $gamingScript
    }
    else {
        Write-Host "Error: Gaming setup script not found at $gamingScript" -ForegroundColor Red
    }
}

# Call the game development setup script only if GameDev flag is provided
if ($GameDev) {
    $gameDevScript = Join-Path $scriptDir "windows\game-dev.ps1"
    if (Test-Path $gameDevScript) {
        Write-Host "Running game development setup..." -ForegroundColor Cyan
        & $gameDevScript
    }
    else {
        Write-Host "Error: Game development setup script not found at $gameDevScript" -ForegroundColor Red
    }
}

# Call the Python setup script only if Python flag is provided
if ($Python) {
    $pythonScript = Join-Path $scriptDir "windows\python.ps1"
    if (Test-Path $pythonScript) {
        Write-Host "Running Python setup..." -ForegroundColor Cyan
        & $pythonScript
    }
    else {
        Write-Host "Error: Python setup script not found at $pythonScript" -ForegroundColor Red
    }
}

# Call the JavaScript-environment setup script only if Js flag is provided
if ($Js) {
    $jsScript = Join-Path $scriptDir "windows\js.ps1"
    if (Test-Path $jsScript) {
        Write-Host "Running Js setup..." -ForegroundColor Cyan
        & $jsScript
    }
    else {
        Write-Host "Error: Js setup script not found at $jsScript" -ForegroundColor Red
    }
}

Write-Host "Windows setup completed!" -ForegroundColor Green