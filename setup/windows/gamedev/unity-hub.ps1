# unity-hub.ps1
############################
# This script installs Unity Hub
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Unity Hub setup..." -ForegroundColor Green

# Function to install Unity Hub using Winget
function Install-UnityHub {
  Write-Host "Checking Unity Hub installation..." -ForegroundColor Cyan

  # Define the expected installation path
  $unityHubPath = "$env:LOCALAPPDATA\UnityHub\Unity Hub.exe"

  # Check if Unity Hub is already installed
  if (Test-Path $unityHubPath) {
    Write-Host "Unity Hub is already installed. Skipping installation..." -ForegroundColor Yellow
    return
  }

  # Install Unity Hub via Winget
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "Installing Unity Hub via Winget..." -ForegroundColor Cyan
    winget install --id Unity.UnityHub -e --source winget
  }
  else {
    Write-Host "Winget is not available. Please install Unity Hub manually." -ForegroundColor Red
    exit 1
  }

  # Verify installation
  if (-not (Test-Path $unityHubPath)) {
    Write-Host "Error: Unity Hub installation failed. Please troubleshoot." -ForegroundColor Red
    exit 1
  }

  Write-Host "Unity Hub installed successfully." -ForegroundColor Green
}

# Call installation function
Install-UnityHub

Write-Host "Unity Hub has been installed." -ForegroundColor Green
