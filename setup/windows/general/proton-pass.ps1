# proton-pass.ps1
############################
# This script installs Proton Pass
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Proton Pass setup..." -ForegroundColor Green


# Function to install or update Proton Pass using Winget
function Install-ProtonPass {
  Write-Host "Checking Proton Pass installation..." -ForegroundColor Cyan

  #? Proton Pass currently doesn't have CLI support, but hopefully will in the future
  #? At that point, we can uncomment the below code
  # Check if Proton Pass is already installed
  # if (Get-Command protonpass -ErrorAction SilentlyContinue) {
  #     Write-Host "Proton Pass CLI is already installed. Checking for updates..." -ForegroundColor Yellow
  #     if (winget upgrade --id Proton.ProtonPass -e --source winget) {
  #         Write-Host "Proton Pass has been updated to the latest version." -ForegroundColor Green
  #     } else {
  #         Write-Host "No updates available for Proton Pass." -ForegroundColor Cyan
  #     }
  # } else {
  Write-Host "Proton Pass is not installed. Installing Proton Pass..." -ForegroundColor Cyan
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget install --id Proton.ProtonPass -e --source winget
    Write-Host "Proton Pass has been installed successfully." -ForegroundColor Green
  }
  else {
    Write-Host "Winget is not available. Please install Proton Pass manually." -ForegroundColor Red
  }
  # }
}

# Call installation function
Install-ProtonPass

Write-Host "Proton Pass has been installed." -ForegroundColor Green
