# pnpm.ps1
############################
# This script installs Pnpm
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Pnpm setup..." -ForegroundColor Green

# Function to install Pnpm using the official standalone installer script
function Install-Pnpm {
  Write-Host "Checking Pnpm installation..." -ForegroundColor Cyan

  # Check if Pnpm is already installed
  if (Get-Command pnpm -ErrorAction SilentlyContinue) {
    Write-Host "Pnpm is already installed. Checking for updates..." -ForegroundColor Yellow
    if (winget upgrade --id pnpm.pnpm -e --source winget) {
      Write-Host "Pnpm has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for Pnpm." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "Pnpm is not installed. Installing via Winget..." -ForegroundColor Cyan

    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id pnpm.pnpm -e --source winget --accept-source-agreements --accept-package-agreements
      Write-Host "Pnpm has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install Pnpm manually." -ForegroundColor Red
      return
    }
  }
  
  Write-Host "Pnpm installation complete. If the command is not recognized, restart your terminal." -ForegroundColor Green
}


# Call installation function
Install-Pnpm

Write-Host "Pnpm has been installed." -ForegroundColor Green
