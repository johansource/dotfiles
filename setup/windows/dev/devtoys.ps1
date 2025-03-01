# devtoys.ps1
############################
# This script installs DevToys
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting DevToys setup..." -ForegroundColor Green

# Function to install DevToys using Winget
function Install-Devtoys {
  Write-Host "Checking DevToys installation..." -ForegroundColor Cyan

  $devtoysPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps\DevToys.exe"

  if (Test-Path $devtoysPath) {
      Write-Host "DevToys is already installed. Skipping installation..." -ForegroundColor DarkYellow
      return
  }

  if (Get-Command winget -ErrorAction SilentlyContinue) {
      Write-Host "Installing DevToys via Winget..." -ForegroundColor Cyan
      winget install --id DevToys-app.DevToys -e --source winget
  } else {
      Write-Host "Winget is not available. Please install DevToys manually." -ForegroundColor Red
      exit 1
  }

  if (-not (Test-Path $devtoysPath)) {
      Write-Host "Error: DevToys installation failed. Please troubleshoot." -ForegroundColor Red
      exit 1
  }

  Write-Host "DevToys installed successfully." -ForegroundColor Green
}

# Call installation function
Install-Devtoys

Write-Host "DevToys has been installed." -ForegroundColor Green
