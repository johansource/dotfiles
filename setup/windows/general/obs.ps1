# obs.ps1
############################
# This script installs OBS
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting OBS setup..." -ForegroundColor Green

# Function to install or update OBS Studio using Winget
function Install-OBS {
  Write-Host "Checking OBS Studio installation..." -ForegroundColor Cyan

  # Define the expected installation path
  $obsPath = "C:\Program Files\obs-studio\bin\64bit\obs64.exe"

  # Check if OBS Studio is already installed
  if (Test-Path $obsPath) {
    Write-Host "OBS Studio is already installed. Checking for updates..." -ForegroundColor Yellow
    if (winget upgrade --id OBSProject.OBSStudio -e --source winget) {
      Write-Host "OBS Studio has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for OBS Studio." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "OBS Studio is not installed. Installing OBS Studio..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id OBSProject.OBSStudio -e --source winget
      Write-Host "OBS Studio has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install OBS Studio manually." -ForegroundColor Red
    }
  }
}

# Call installation function
Install-OBS

Write-Host "OBS has been installed." -ForegroundColor Green
