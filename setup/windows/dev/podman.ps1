# podman.ps1
############################
# This script installs Podman and Podman Desktop
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Podman setup..." -ForegroundColor Green

# Function to check and install WSL2
function Install-WSL2 {
  Write-Host "Checking for WSL2 installation..." -ForegroundColor Cyan

  try {
    $wslVersionOutput = wsl --version 2>&1
    if ($wslVersionOutput -match "WSL version") {
      Write-Host "WSL2 is already installed. Checking for updates..." -ForegroundColor DarkYellow
      wsl --update
      Write-Host "WSL2 has been updated (if needed)." -ForegroundColor Green
    }
    else {
      Write-Host "WSL is present, but version info is unclear. Attempting to update WSL..." -ForegroundColor Yellow
      wsl --update
      wsl --set-default-version 2
      Write-Host "WSL2 update attempted and default version set to 2." -ForegroundColor Green
    }
  }
  catch {
    Write-Host "WSL is not installed. Installing WSL2..." -ForegroundColor Cyan
    try {
      wsl --install
      wsl --set-default-version 2
      Write-Host "WSL2 has been installed and set as default." -ForegroundColor Green
    }
    catch {
      Write-Host "Automatic WSL installation failed. You may need to manually install WSL2." -ForegroundColor Red
      Write-Host "See: https://aka.ms/wslinstall" -ForegroundColor Yellow
      exit 1
    }
  }
}

# Function to install or update Podman using Winget
function Install-Podman {
  Write-Host "Checking Podman installation..." -ForegroundColor Cyan

  if (Get-Command podman -ErrorAction SilentlyContinue) {
    Write-Host "Podman CLI is already installed. Checking for updates..." -ForegroundColor DarkYellow
    if (winget upgrade --id RedHat.Podman -e --source winget) {
      Write-Host "Podman has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for Podman." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "Podman CLI is not installed. Installing..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id RedHat.Podman -e --source winget --accept-source-agreements --accept-package-agreements
      Write-Host "Podman CLI has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install Podman manually." -ForegroundColor Red
    }
  }
}

# Function to install or update Podman Desktop using Winget
function Install-PodmanDesktop {
  Write-Host "Checking Podman Desktop installation..." -ForegroundColor Cyan

  $pathsToCheck = @(
    "$env:LOCALAPPDATA\Programs\podman-desktop\Podman Desktop.exe",
    "$env:ProgramFiles\Podman Desktop\Podman Desktop.exe"
  )

  $podmanDesktopInstalled = $pathsToCheck | Where-Object { Test-Path $_ }

  if ($podmanDesktopInstalled) {
    Write-Host "Podman Desktop is already installed. Checking for updates..." -ForegroundColor DarkYellow
    if (winget upgrade --id RedHat.Podman-Desktop -e --source winget) {
      Write-Host "Podman Desktop has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for Podman Desktop." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "Podman Desktop is not installed. Installing..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id RedHat.Podman-Desktop -e --source winget --accept-source-agreements --accept-package-agreements
      Write-Host "Podman Desktop has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install Podman Desktop manually." -ForegroundColor Red
    }
  }
}

# Call installation functions
Install-WSL2
Install-Podman
Install-PodmanDesktop

Write-Host "Podman and Podman Desktop has been installed." -ForegroundColor Green
Write-Host "Remember to restart your system." -ForegroundColor Green