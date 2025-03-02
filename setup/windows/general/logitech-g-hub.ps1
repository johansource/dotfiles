# logitech-g-hub.ps1
############################
# This script installs Logitech G Hub
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Logitech G Hub setup..." -ForegroundColor Green

# Function to install Logitech G Hub
function Install-LogitechGHub {
  Write-Host "Checking Logitech G Hub installation..." -ForegroundColor Cyan

  # Define the expected installation path
  $ghubPath = "C:\Program Files\LGHUB\lghub.exe"

  # Check if Logitech G Hub is already installed
  if (Test-Path $ghubPath) {
    Write-Host "Logitech G Hub is already installed. Checking for updates..." -ForegroundColor Yellow
    if (winget upgrade --id Logitech.GHUB -e --source winget) {
      Write-Host "Logitech G Hub has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for Logitech G Hub." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "Logitech G Hub is not installed. Installing via Winget..." -ForegroundColor Cyan

    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id Logitech.GHUB -e --source winget --accept-source-agreements --accept-package-agreements
      Write-Host "Logitech G Hub has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install Logitech G Hub manually." -ForegroundColor Red
    }
  }
}

# Call installation function
Install-LogitechGHub

Write-Host "Logitech G Hub has been installed." -ForegroundColor Green
