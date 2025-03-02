# discord.ps1
############################
# This script installs Discord
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Discord setup..." -ForegroundColor Green

# Function to install or update Discord using Winget
function Install-Discord {
  Write-Host "Checking Discord installation..." -ForegroundColor Cyan

  # Check if Discord is already installed
  $discordPath = "$env:LOCALAPPDATA\Discord\Update.exe"
  if (Test-Path $discordPath) {
    Write-Host "Discord is already installed. Checking for updates..." -ForegroundColor Yellow
    if (winget upgrade --id Discord.Discord -e --source winget) {
      Write-Host "Discord has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for Discord." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "Discord is not installed. Installing Discord..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id Discord.Discord -e --source winget
      Write-Host "Discord has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install Discord manually." -ForegroundColor Red
    }
  }
}

# Call installation function
Install-Discord

Write-Host "Discord has been installed." -ForegroundColor Green
