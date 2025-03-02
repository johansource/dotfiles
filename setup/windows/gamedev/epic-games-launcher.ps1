# epic-games-launcher.ps1
############################
# This script installs Epic Games Launcher
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Epic Games Launcher setup..." -ForegroundColor Green

# Function to install Epic Games Launcher using Winget
function Install-EpicGamesLauncher {
  Write-Host "Checking Epic Games Launcher installation..." -ForegroundColor Cyan

  # Define the expected installation path
  $epicGamesLauncherPath = "$env:ProgramFiles\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe"

  # Check if Epic Games Launcher is already installed
  if (Test-Path $epicGamesLauncherPath) {
    Write-Host "Epic Games Launcher is already installed. Skipping installation..." -ForegroundColor Yellow
    return
  }

  # Install Epic Games Launcher via Winget
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "Installing Epic Games Launcher via Winget..." -ForegroundColor Cyan
    winget install --id EpicGames.EpicGamesLauncher -e --source winget
  }
  else {
    Write-Host "Winget is not available. Please install Epic Games Launcher manually." -ForegroundColor Red
    exit 1
  }

  # Verify installation
  if (-not (Test-Path $epicGamesLauncherPath)) {
    Write-Host "Error: Epic Games Launcher installation failed. Please troubleshoot." -ForegroundColor Red
    exit 1
  }

  Write-Host "Epic Games Launcher installed successfully." -ForegroundColor Green
}

# Call installation function
Install-EpicGamesLauncher

Write-Host "Epic Games Launcher has been installed." -ForegroundColor Green
