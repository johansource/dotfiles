# git.ps1
############################
# This script installs Git
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Git setup..." -ForegroundColor Green

# Function to install or update Git using Winget
function Install-Git {
  Write-Host "Checking Git installation..." -ForegroundColor Cyan

  # Check if Git is already installed
  if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "Git is already installed. Checking for updates..." -ForegroundColor Yellow
    if (winget upgrade --id Git.Git -e --source winget) {
      Write-Host "Git has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for Git." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "Git is not installed. Installing Git..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id Git.Git -e --source winget
      Write-Host "Git has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install Git manually." -ForegroundColor Red
    }
  }
}

# Function to create a symbolic link for .gitconfig
function Symlink-Gitconfig {
  Write-Host "Setting up symlink for .gitconfig..." -ForegroundColor Cyan

  # Define the source and destination paths
  $dotfilesDir = "$PSScriptRoot\..\..\.."
  $gitconfigSource = Join-Path $dotfilesDir "git\.gitconfig"
  $gitconfigTarget = "$env:USERPROFILE\.gitconfig"

  # Check if the destination already exists
  if (Test-Path $gitconfigTarget) {
    Write-Host ".gitconfig already exists at $gitconfigTarget. Removing it to create the symlink..." -ForegroundColor Yellow
    Remove-Item -Path $gitconfigTarget -Force
  }

  # Create the symbolic link
  try {
    Write-Host "Creating symlink: $gitconfigTarget -> $gitconfigSource" -ForegroundColor Cyan
    New-Item -ItemType SymbolicLink -Path $gitconfigTarget -Target $gitconfigSource
    Write-Host ".gitconfig symlink created successfully." -ForegroundColor Green
  }
  catch {
    Write-Host "Error creating symlink for .gitconfig: $_" -ForegroundColor Red
  }
}

# Call installation function
Install-Git
Symlink-Gitconfig

Write-Host "Git has been installed, and symlinks created." -ForegroundColor Green
