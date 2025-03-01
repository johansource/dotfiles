# powershell-symlinks.ps1
############################
# This script handles symlinking for PowerShell profile
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting PowerShell symlink setup..." -ForegroundColor Green

function Symlink-PowerShellProfile {
  Write-Host "Setting up symlink for PowerShell profile..." -ForegroundColor Cyan

  # Define source and target paths
  $dotfilesDir = "$PSScriptRoot\..\..\.."
  $profileSource = Join-Path $dotfilesDir "windowspowershell\Microsoft.PowerShell_profile.ps1"
  $profileTargetDir = Join-Path "$env:USERPROFILE\Documents" "WindowsPowerShell"
  $profileTarget = Join-Path $profileTargetDir "Microsoft.PowerShell_profile.ps1"

  # Ensure the PowerShell directory exists
  if (-not (Test-Path $profileTargetDir)) {
      Write-Host "Creating PowerShell directory at $profileTargetDir" -ForegroundColor Cyan
      New-Item -ItemType Directory -Path $profileTargetDir
  }

  # Check if the target already exists
  if (Test-Path $profileTarget) {
      Write-Host "PowerShell profile already exists at $profileTarget. Removing it to create the symlink..." -ForegroundColor DarkYellow
      Remove-Item -Path $profileTarget -Force
  }

  # Create the symbolic link
  try {
      Write-Host "Creating symlink: $profileTarget -> $profileSource" -ForegroundColor Cyan
      New-Item -ItemType SymbolicLink -Path $profileTarget -Target $profileSource
      Write-Host "PowerShell profile symlink created successfully." -ForegroundColor Green
  } catch {
      Write-Host "Error creating symlink for PowerShell profile: $_" -ForegroundColor Red
  }
}

# Call installation function
Symlink-PowerShellProfile

Write-Host "PowerShell symlinks has been created." -ForegroundColor Green
