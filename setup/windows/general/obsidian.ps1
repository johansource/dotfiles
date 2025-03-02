# obsidian.ps1
############################
# This script installs Obsidian
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Obsidian setup..." -ForegroundColor Green

# Function to install or update Obsidian using Winget
function Install-Obsidian {
  Write-Host "Checking Obsidian installation..." -ForegroundColor Cyan

  # Define the expected installation path for Obsidian
  $obsidianPath = "$env:LocalAppData\Obsidian\Obsidian.exe"

  # Check if Obsidian is already installed
  if (Test-Path $obsidianPath) {
    Write-Host "Obsidian is already installed. Checking for updates..." -ForegroundColor Yellow
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      Write-Host "Updating Obsidian via Winget..." -ForegroundColor Cyan
      winget upgrade --id Obsidian.Obsidian -e --source winget
    }
    else {
      Write-Host "Winget is not available. Please update Obsidian manually." -ForegroundColor Red
      exit 1
    }
  }
  else {
    # Install Obsidian via Winget
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      Write-Host "Installing Obsidian via Winget..." -ForegroundColor Cyan
      winget install --id Obsidian.Obsidian -e --source winget
    }
    else {
      Write-Host "Winget is not available. Please install Obsidian manually." -ForegroundColor Red
      exit 1
    }
  }

  # Verify the Obsidian installation path
  if (-not (Test-Path $obsidianPath)) {
    Write-Host "Error: Obsidian executable not found at $obsidianPath. Please verify the installation." -ForegroundColor Red
    exit 1
  }

  # Temporarily add Obsidian to the current session PATH if not already added
  $obsidianBinPath = "$env:LocalAppData\Obsidian"
  if ($obsidianBinPath -notin ($env:Path -split ';')) {
    $env:Path += ";$obsidianBinPath"
    Write-Host "Obsidian bin path added to the current session PATH." -ForegroundColor Green
  }
  else {
    Write-Host "Obsidian bin path is already in the current session PATH." -ForegroundColor Yellow
  }

  # Verify installation
  if (Test-Path $obsidianPath) {
    Write-Host "Obsidian has been installed or updated successfully." -ForegroundColor Green
  }
  else {
    Write-Host "Obsidian installation failed. Please troubleshoot." -ForegroundColor Red
    exit 1
  }
}

# Call installation function
Install-Obsidian

Write-Host "Obsidian has been installed." -ForegroundColor Green
