# steam.ps1
############################
# This script installs Steam
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Steam setup..." -ForegroundColor Green

# Function to install Steam using Winget
function Install-Steam {
  Write-Host "Checking Steam installation..." -ForegroundColor Cyan

  $steamPath = "$env:ProgramFiles (x86)\Steam\Steam.exe"

  if (Test-Path $steamPath) {
    Write-Host "Steam is already installed. Skipping installation..." -ForegroundColor Yellow
    return
  }

  if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "Installing Steam via Winget..." -ForegroundColor Cyan
    winget install --id Valve.Steam -e
  }
  else {
    Write-Host "Winget is not available. Please install Steam manually." -ForegroundColor Red
    exit 1
  }

  if (-not (Test-Path $steamPath)) {
    Write-Host "Error: Steam installation failed or not found at $steamPath. Please troubleshoot." -ForegroundColor Red
    exit 1
  }

  Write-Host "Steam installed successfully." -ForegroundColor Green
}

# Call installation function
Install-Steam

Write-Host "Steam has been installed." -ForegroundColor Green
