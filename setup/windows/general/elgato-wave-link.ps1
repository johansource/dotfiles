# elgato-wave-link.ps1
############################
# This script installs Elgato Wave Link
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Elgato Wave Link setup..." -ForegroundColor Green

# Function to install Elgato Wave Link
function Install-ElgatoWaveLink {
  Write-Host "Checking Elgato Wave Link installation..." -ForegroundColor Cyan

  # Define the expected installation path
  $waveLinkPath = "C:\Program Files\Elgato\Wave Link\WaveLink.exe"

  # Check if Elgato Wave Link is already installed
  if (Test-Path $waveLinkPath) {
    Write-Host "Elgato Wave Link is already installed. Checking for updates..." -ForegroundColor Yellow
    if (winget upgrade --id Corsair.WaveLink -e --source winget) {
      Write-Host "Elgato Wave Link has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for Elgato Wave Link." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "Elgato Wave Link is not installed. Installing via Winget..." -ForegroundColor Cyan

    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id Corsair.WaveLink -e --source winget --accept-source-agreements --accept-package-agreements
      Write-Host "Elgato Wave Link has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install Elgato Wave Link manually." -ForegroundColor Red
    }
  }
}

# Call installation function
Install-ElgatoWaveLink

Write-Host "Elgato Wave Link has been installed." -ForegroundColor Green
