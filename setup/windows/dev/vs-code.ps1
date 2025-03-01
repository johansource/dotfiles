# vs-code.ps1
############################
# This script installs Visual Studio Code
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Visual Studio Code setup..." -ForegroundColor Green

# Function to install or update Visual Studio Code using Winget
function Install-VSCode {
  Write-Host "Checking Visual Studio Code installation..." -ForegroundColor Cyan

  # Define the expected installation path
  $vscodePath = "C:\Program Files\Microsoft VS Code\Code.exe"

  # Check if VS Code is already installed
  if (Test-Path $vscodePath) {
      Write-Host "Visual Studio Code is already installed. Checking for updates..." -ForegroundColor DarkYellow
      if (winget upgrade --id Microsoft.VisualStudioCode -e --source winget) {
          Write-Host "Visual Studio Code has been updated to the latest version." -ForegroundColor Green
      } else {
          Write-Host "No updates available for Visual Studio Code." -ForegroundColor Cyan
      }
  } else {
      Write-Host "Visual Studio Code is not installed. Installing Visual Studio Code..." -ForegroundColor Cyan
      if (Get-Command winget -ErrorAction SilentlyContinue) {
          winget install --id Microsoft.VisualStudioCode -e --source winget --scope machine --accept-source-agreements --accept-package-agreements
          Write-Host "Visual Studio Code has been installed successfully." -ForegroundColor Green
      } else {
          Write-Host "Winget is not available. Please install Visual Studio Code manually." -ForegroundColor Red
      }
  }

  # Update PATH for the current session
  $vscodeBinPath = "C:\Program Files\Microsoft VS Code\bin"
  if ($vscodeBinPath -notin ($env:Path -split ';')) {
      $env:Path += ";$vscodeBinPath"
      Write-Host "VS Code bin path added to the current session PATH." -ForegroundColor Green
  }

  # Verify that the 'code' command is available
  if (Get-Command code -ErrorAction SilentlyContinue) {
      Write-Host "VS Code CLI is available." -ForegroundColor Green
  } else {
      Write-Host "VS Code CLI is not available. Please restart the terminal if issues persist." -ForegroundColor Red
  }
}

# Call installation function
Install-VSCode

Write-Host "Visual Studio Code has been installed." -ForegroundColor Green
