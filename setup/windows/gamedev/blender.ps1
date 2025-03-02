# blender.ps1
############################
# This script installs Blender
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Blender setup..." -ForegroundColor Green

# Function to install Blender using Winget
function Install-Blender {
  Write-Host "Checking Blender installation..." -ForegroundColor Cyan

  # Define the expected installation path
  $blenderPath = "$env:ProgramFiles\Blender Foundation\Blender\blender.exe"

  # Check if Blender is already installed
  if (Test-Path $blenderPath) {
    Write-Host "Blender is already installed. Skipping installation..." -ForegroundColor Yellow
    return
  }

  # Install Blender via Winget
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "Installing Blender via Winget..." -ForegroundColor Cyan
    winget install --id BlenderFoundation.Blender -e --source winget
  }
  else {
    Write-Host "Winget is not available. Please install Blender manually." -ForegroundColor Red
    exit 1
  }

  # Verify installation
  if (-not (Test-Path $blenderPath)) {
    Write-Host "Error: Blender installation failed. Please troubleshoot." -ForegroundColor Red
    exit 1
  }

  Write-Host "Blender installed successfully." -ForegroundColor Green
}

# Call installation function
Install-Blender

Write-Host "Blender has been installed." -ForegroundColor Green
