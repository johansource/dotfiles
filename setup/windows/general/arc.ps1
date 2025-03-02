# arc.ps1
############################
# This script installs Arc
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Arc setup..." -ForegroundColor Green

# Function to install Arc using Winget
function Install-ArcBrowser {
  Write-Host "Checking Arc Browser installation..." -ForegroundColor Cyan

  # Check if Arc Browser is already installed
  if (Get-Command "arc" -ErrorAction SilentlyContinue) {
    Write-Host "Arc Browser is already installed. Checking for updates..." -ForegroundColor DarkYellow
    if (winget upgrade --id TheBrowserCompany.Arc -e --source winget) {
      Write-Host "Arc Browser has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for Arc Browser." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "Arc Browser is not installed. Installing via Winget..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id TheBrowserCompany.Arc -e --source winget --accept-source-agreements --accept-package-agreements
      Write-Host "Arc Browser has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install Arc Browser manually." -ForegroundColor Red
    }
  }
}

# Call installation function
Install-ArcBrowser

Write-Host "Arc has been installed." -ForegroundColor Green
