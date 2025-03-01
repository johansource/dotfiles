# wezterm.ps1
############################
# WezTerm setup script
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting WezTerm setup..." -ForegroundColor Green

# Function to install WezTerm using Winget
function Install-WezTerm {
  Write-Host "Checking WezTerm installation..." -ForegroundColor Cyan

  # Define the expected installation path
  $wezTermPath = "$env:LOCALAPPDATA\wezterm\wezterm.exe"

  # Check if WezTerm is already installed
  if (Test-Path $wezTermPath) {
      Write-Host "WezTerm is already installed. Skipping installation..." -ForegroundColor DarkYellow
      return
  }

  # Install WezTerm via Winget
  if (Get-Command winget -ErrorAction SilentlyContinue) {
      Write-Host "Installing WezTerm via Winget..." -ForegroundColor Cyan
      winget install --id wez.wezterm -e
  } else {
      Write-Host "Winget is not available. Please install WezTerm manually." -ForegroundColor Red
      exit 1
  }

  # Verify the WezTerm installation path
  if (-not (Test-Path $wezTermPath)) {
      Write-Host "Error: WezTerm installation directory not found at $wezTermPath. Please verify the installation." -ForegroundColor Red
      exit 1
  }

  # Add WezTerm to the global PATH
  $currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
  $wezTermBinPath = "$env:LOCALAPPDATA\wezterm"
  if ($wezTermBinPath -notin ($currentPath -split ';')) {
      [Environment]::SetEnvironmentVariable("Path", $currentPath + ";" + $wezTermBinPath, [EnvironmentVariableTarget]::Machine)
      Write-Host "WezTerm added to the global PATH." -ForegroundColor Green
  } else {
      Write-Host "WezTerm is already in the global PATH." -ForegroundColor DarkYellow
  }

  # Temporarily add WezTerm to the current session PATH
  if ($wezTermBinPath -notin ($env:Path -split ';')) {
      $env:Path += ";$wezTermBinPath"
      Write-Host "WezTerm added to the current session PATH." -ForegroundColor Green
  }

  # Verify installation
  if (Test-Path $wezTermPath) {
      Write-Host "WezTerm has been installed successfully and is ready to use." -ForegroundColor Green
  } else {
      Write-Host "WezTerm installation failed. Please troubleshoot." -ForegroundColor Red
      exit 1
  }
}

# Function to create a symbolic link for wezterm.lua
function Symlink-Wezterm {
  Write-Host "Setting up symlink for wezterm.lua..." -ForegroundColor Cyan

  # Define the source and destination paths
  $dotfilesDir = "$PSScriptRoot\..\.."
  $weztermSource = Join-Path $dotfilesDir "wezterm\wezterm.lua"
  $weztermTarget = "$env:USERPROFILE\.wezterm.lua"

  # Check if the destination already exists
  if (Test-Path $weztermTarget) {
      Write-Host "wezterm.lua already exists at $weztermTarget. Removing it to create the symlink..." -ForegroundColor DarkYellow
      Remove-Item -Path $weztermTarget -Force
  }

  # Create the symbolic link
  try {
      Write-Host "Creating symlink: $weztermTarget -> $weztermSource" -ForegroundColor Cyan
      New-Item -ItemType SymbolicLink -Path $weztermTarget -Target $weztermSource
      Write-Host "wezterm.lua symlink created successfully." -ForegroundColor Green
  } catch {
      Write-Host "Error creating symlink for wezterm.lua: $_" -ForegroundColor Red
  }
}

# Run functions
Install-WezTerm
Symlink-Wezterm

Write-Host "WezTerm setup completed!" -ForegroundColor Green
