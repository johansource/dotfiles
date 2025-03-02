# proton-vpn.ps1
############################
# This script installs Proton VPN
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Proton VPN setup..." -ForegroundColor Green

# Function to install or update Proton VPN using Winget
function Install-ProtonVPN {
  Write-Host "Checking Proton VPN installation..." -ForegroundColor Cyan

  # Check if Proton VPN CLI is installed
  if (Get-Command "protonvpn-cli" -ErrorAction SilentlyContinue) {
    Write-Host "Proton VPN CLI is already installed. Checking for updates..." -ForegroundColor Yellow
    if (winget upgrade --id Proton.ProtonVPN -e --source winget) {
      Write-Host "Proton VPN has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for Proton VPN." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "Proton VPN is not installed. Installing Proton VPN..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id Proton.ProtonVPN -e --source winget
      Write-Host "Proton VPN has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install Proton VPN manually." -ForegroundColor Red
    }
  }
}

# Call installation function
Install-ProtonVPN

Write-Host "Proton VPN has been installed." -ForegroundColor Green
