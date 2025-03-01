# starship.ps1
############################
# Starship setup script
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting WezTerm setup..." -ForegroundColor Green

# Function to install Starship
function Install-Starship {
  Write-Host "Checking Starship installation..." -ForegroundColor Cyan

  # Define the expected installation path
  $starshipPath = "$env:USERPROFILE\.cargo\bin\starship.exe"

  # Check if Starship is already installed
  if (Test-Path $starshipPath) {
      Write-Host "Starship is already installed. Skipping installation..." -ForegroundColor DarkYellow
      return
  }

  # Download and run the Starship installation script
  try {
      Invoke-WebRequest https://starship.rs/install.ps1 -UseBasicParsing | Invoke-Expression
      Write-Host "Starship installation script executed successfully." -ForegroundColor Green
  } catch {
      Write-Host "Error: Failed to execute the Starship installation script." -ForegroundColor Red
      exit 1
  }

  # Verify the Starship installation path
  if (-not (Test-Path $starshipPath)) {
      Write-Host "Error: Starship executable not found at $starshipPath. Please verify the installation." -ForegroundColor Red
      exit 1
  }

  # Add Starship to the global PATH
  $cargoBinPath = "$env:USERPROFILE\.cargo\bin"
  $currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
  if ($cargoBinPath -notin ($currentPath -split ';')) {
      [Environment]::SetEnvironmentVariable("Path", $currentPath + ";" + $cargoBinPath, [EnvironmentVariableTarget]::Machine)
      Write-Host "Starship's cargo bin path added to the global PATH." -ForegroundColor Green
  } else {
      Write-Host "Starship's cargo bin path is already in the global PATH." -ForegroundColor DarkYellow
  }

  # Temporarily add Starship to the current session PATH
  if ($cargoBinPath -notin ($env:Path -split ';')) {
      $env:Path += ";$cargoBinPath"
      Write-Host "Starship's cargo bin path added to the current session PATH." -ForegroundColor Green
  }

  # Verify installation
  if (Get-Command starship -ErrorAction SilentlyContinue) {
      Write-Host "Starship has been installed successfully and is ready to use." -ForegroundColor Green
  } else {
      Write-Host "Starship installation failed. Please troubleshoot." -ForegroundColor Red
      exit 1
  }
}

# Function to create a symbolic link for starship.toml
function Symlink-Starship {
  Write-Host "Setting up symlink for starship.toml..." -ForegroundColor Cyan

  # Define the source and destination paths
  $dotfilesDir = "$PSScriptRoot\..\.."
  $starshipSource = Join-Path $dotfilesDir "starship\starship.toml"
  $starshipConfigDir = "$env:USERPROFILE\.config"
  $starshipTarget = Join-Path $starshipConfigDir "starship.toml"

  # Ensure the config directory exists
  if (-not (Test-Path $starshipConfigDir)) {
      Write-Host "Creating Starship config directory at $starshipConfigDir" -ForegroundColor Cyan
      New-Item -ItemType Directory -Path $starshipConfigDir
  }

  # Check if the destination already exists
  if (Test-Path $starshipTarget) {
      Write-Host "starship.toml already exists at $starshipTarget. Removing it to create the symlink..." -ForegroundColor DarkYellow
      Remove-Item -Path $starshipTarget -Force
  }

  # Create the symbolic link
  try {
      Write-Host "Creating symlink: $starshipTarget -> $starshipSource" -ForegroundColor Cyan
      New-Item -ItemType SymbolicLink -Path $starshipTarget -Target $starshipSource
      Write-Host "starship.toml symlink created successfully." -ForegroundColor Green
  } catch {
      Write-Host "Error creating symlink for starship.toml: $_" -ForegroundColor Red
  }
}

# Call functions
Install-Starship
Symlink-Starship

Write-Host "WezTerm setup completed!" -ForegroundColor Green
