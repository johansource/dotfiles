# notion.ps1
############################
# This script installs Notion
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Notion setup..." -ForegroundColor Green

# Function to install or update Notion using Winget
function Install-Notion {
  Write-Host "Checking Notion installation..." -ForegroundColor Cyan

  # Define the expected installation path
  $notionPath = "$env:LOCALAPPDATA\Notion\Notion.exe"

  # Check if Notion is already installed
  if (Test-Path $notionPath) {
    Write-Host "Notion is already installed. Checking for updates..." -ForegroundColor Yellow
    if (winget upgrade --id Notion.Notion -e --source winget) {
      Write-Host "Notion has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for Notion." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "Notion is not installed. Installing Notion..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id Notion.Notion -e --source winget
      Write-Host "Notion has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install Notion manually." -ForegroundColor Red
    }
  }
}

# Call installation function
Install-Notion

Write-Host "Notion has been installed." -ForegroundColor Green
