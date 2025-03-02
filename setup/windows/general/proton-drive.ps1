# proton-drive.ps1
############################
# This script installs Proton Drive
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Proton Drive setup..." -ForegroundColor Green

# Function to install or update Proton Drive using Winget
function Install-ProtonDrive {
  Write-Host "Checking Proton Drive installation..." -ForegroundColor Cyan

  # Check if Proton Drive CLI is installed
  if (Get-Command "protondrive-cli" -ErrorAction SilentlyContinue) {
    Write-Host "Proton Drive CLI is already installed. Checking for updates..." -ForegroundColor Yellow
    if (winget upgrade --id Proton.ProtonDrive -e --source winget) {
      Write-Host "Proton Drive has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for Proton Drive." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "Proton Drive is not installed. Installing Proton Drive..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id Proton.ProtonDrive -e --source winget
      Write-Host "Proton Drive has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install Proton Drive manually." -ForegroundColor Red
    }
  }
}

# Call installation function
Install-ProtonDrive

Write-Host "Proton Drive has been installed." -ForegroundColor Green
