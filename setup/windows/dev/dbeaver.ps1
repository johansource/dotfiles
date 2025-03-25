# dbeaver.ps1
############################
# This script installs DBeaver CE
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting DBeaver setup..." -ForegroundColor Green

# Function to install or update DBeaver
function Install-DBeaver {
  Write-Host "Checking DBeaver installation..." -ForegroundColor Cyan

  $pathsToCheck = @(
    "$env:LOCALAPPDATA\Programs\DBeaver\dbeaver.exe",
    "$env:ProgramFiles\DBeaver\dbeaver.exe"
  )

  $dbeaverInstalled = $pathsToCheck | Where-Object { Test-Path $_ }

  if ($dbeaverInstalled) {
    Write-Host "DBeaver is already installed. Checking for updates..." -ForegroundColor DarkYellow
    if (winget upgrade --id dbeaver.dbeaver -e --source winget) {
      Write-Host "DBeaver has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for DBeaver." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "DBeaver is not installed. Installing..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id dbeaver.dbeaver -e --source winget --accept-source-agreements --accept-package-agreements
      Write-Host "DBeaver has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install DBeaver manually." -ForegroundColor Red
    }
  }
}

# Call the function
Install-DBeaver

Write-Host "DBeaver CE has been installed." -ForegroundColor Green
