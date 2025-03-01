# jetbrains-toolbox.ps1
############################
# This script installs Jetbrains Toolbox
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Jetbrains Toolbox setup..." -ForegroundColor Green

# Function to install or update JetBrains Toolbox using Winget
function Install-JetBrainsToolbox {
  Write-Host "Checking JetBrains Toolbox installation..." -ForegroundColor Cyan

  # Define the expected installation path for JetBrains Toolbox
  $toolboxPath = "$env:LocalAppData\JetBrains\Toolbox\bin\jetbrains-toolbox.exe"

  # Check if JetBrains Toolbox is already installed
  if (Test-Path $toolboxPath) {
      Write-Host "JetBrains Toolbox is already installed. Checking for updates..." -ForegroundColor DarkYellow
      if (Get-Command winget -ErrorAction SilentlyContinue) {
          Write-Host "Updating JetBrains Toolbox via Winget..." -ForegroundColor Cyan
          winget upgrade --id JetBrains.Toolbox -e
      } else {
          Write-Host "Winget is not available. Please update JetBrains Toolbox manually." -ForegroundColor Red
          exit 1
      }
  } else {
      # Install JetBrains Toolbox via Winget
      if (Get-Command winget -ErrorAction SilentlyContinue) {
          Write-Host "Installing JetBrains Toolbox via Winget..." -ForegroundColor Cyan
          winget install --id JetBrains.Toolbox -e
      } else {
          Write-Host "Winget is not available. Please install JetBrains Toolbox manually." -ForegroundColor Red
          exit 1
      }
  }

  # Verify the JetBrains Toolbox installation path
  if (-not (Test-Path $toolboxPath)) {
      Write-Host "Error: JetBrains Toolbox executable not found at $toolboxPath. Please verify the installation." -ForegroundColor Red
      exit 1
  }

  # Temporarily add JetBrains Toolbox to the current session PATH if not already added
  $toolboxBinPath = "$env:LocalAppData\JetBrains\Toolbox\bin"
  if ($toolboxBinPath -notin ($env:Path -split ';')) {
      $env:Path += ";$toolboxBinPath"
      Write-Host "JetBrains Toolbox bin path added to the current session PATH." -ForegroundColor Green
  } else {
      Write-Host "JetBrains Toolbox bin path is already in the current session PATH." -ForegroundColor DarkYellow
  }

  # Verify installation
  if (Test-Path $toolboxPath) {
      Write-Host "JetBrains Toolbox has been installed or updated successfully." -ForegroundColor Green
  } else {
      Write-Host "JetBrains Toolbox installation failed. Please troubleshoot." -ForegroundColor Red
      exit 1
  }
}

# Call installation function
Install-JetBrainsToolbox

Write-Host "Jetbrains Toolbox has been installed." -ForegroundColor Green
