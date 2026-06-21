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

  # Define the correct system-wide installation path
  $wezTermPath = "C:\Program Files\WezTerm\wezterm.exe"

  # Check if WezTerm is already installed
  if (Test-Path $wezTermPath) {
      Write-Host "WezTerm is already installed. Skipping installation..." -ForegroundColor DarkYellow
      return
  }

  # Install WezTerm via Winget
  if (Get-Command winget -ErrorAction SilentlyContinue) {
      Write-Host "Installing WezTerm via Winget..." -ForegroundColor Cyan
      winget install --id wez.wezterm -e --source winget
  } else {
      Write-Host "Winget is not available. Please install WezTerm manually." -ForegroundColor Red
      exit 1
  }

  # Verify WezTerm installation
  if (-not (Test-Path $wezTermPath)) {
      Write-Host "Error: WezTerm installation not found at $wezTermPath. Please verify the installation." -ForegroundColor Red
      exit 1
  }

  # Add WezTerm to the global PATH
  $wezTermBinPath = "C:\Program Files\WezTerm"
  $currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

  if ($currentPath -notlike "*$wezTermBinPath*") {
      Write-Host "Adding WezTerm to system PATH..." -ForegroundColor Yellow
      [System.Environment]::SetEnvironmentVariable("Path", "$currentPath;$wezTermBinPath", [System.EnvironmentVariableTarget]::Machine)
      Write-Host "WezTerm added to the global PATH." -ForegroundColor Green
  } else {
      Write-Host "WezTerm is already in the global PATH." -ForegroundColor DarkYellow
  }

  # Ensure the current PowerShell session recognizes the updated PATH
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

  Write-Host "WezTerm installation and setup completed successfully!" -ForegroundColor Green
}

# Function to create a symbolic link for wezterm.lua
function Symlink-Wezterm {
  Write-Host "Setting up symlink for wezterm.lua..." -ForegroundColor Cyan

  # Define the source and destination paths
  $dotfilesDir = "$PSScriptRoot\..\..\.."
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
