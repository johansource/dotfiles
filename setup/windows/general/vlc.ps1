# vlc.ps1
############################
# This script installs VLC
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting VLC setup..." -ForegroundColor Green

# Function to install or update VLC Media Player using Winget
function Install-VLC {
  Write-Host "Checking VLC installation..." -ForegroundColor Cyan

  # Define the expected installation path
  $vlcPath = "C:\Program Files\VideoLAN\VLC\vlc.exe"

  # Check if VLC is already installed
  if (Test-Path $vlcPath) {
    Write-Host "VLC is already installed. Checking for updates..." -ForegroundColor Yellow
    if (winget upgrade --id VideoLAN.VLC -e --source winget) {
      Write-Host "VLC has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for VLC." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "VLC is not installed. Installing VLC..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id VideoLAN.VLC -e --source winget
      Write-Host "VLC has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install VLC manually." -ForegroundColor Red
    }
  }
}

# Call installation function
Install-VLC

Write-Host "VLC has been installed." -ForegroundColor Green
