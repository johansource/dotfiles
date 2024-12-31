# pnpm-setup.ps1
############################
# This script installs pnpm and uses it to install Node.js
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Starting Pnpm and Node.js setup..." -ForegroundColor Green

# Function to install Pnpm using the official standalone installer script
function Install-Pnpm {
    Write-Host "Installing Pnpm using the standalone script..." -ForegroundColor Cyan

    # Check if Pnpm is already installed
    if (Get-Command pnpm -ErrorAction SilentlyContinue) {
        Write-Host "Pnpm is already installed. Skipping installation..." -ForegroundColor Yellow
        return
    }

    # Run the official standalone installer script
    try {
        Invoke-WebRequest https://get.pnpm.io/install.ps1 -UseBasicParsing | Invoke-Expression
        Write-Host "Pnpm installation script executed successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error: Failed to execute the Pnpm installation script." -ForegroundColor Red
        exit 1
    }

    # Define the typical installation path for Pnpm
    $pnpmPath = "$env:USERPROFILE\AppData\Local\pnpm"

    # Verify the Pnpm installation path
    if (-not (Test-Path $pnpmPath)) {
        Write-Host "Error: Pnpm installation directory not found at $pnpmPath. Please verify the installation." -ForegroundColor Red
        exit 1
    }

    # Add Pnpm to the global PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
    if ($pnpmPath -notin ($currentPath -split ';')) {
        [Environment]::SetEnvironmentVariable("Path", $currentPath + ";" + $pnpmPath, [EnvironmentVariableTarget]::Machine)
        Write-Host "Pnpm added to the global PATH." -ForegroundColor Green
    } else {
        Write-Host "Pnpm is already in the global PATH." -ForegroundColor Yellow
    }

    # Temporarily add Pnpm to the current session PATH
    if ($pnpmPath -notin ($env:Path -split ';')) {
        $env:Path += ";$pnpmPath"
        Write-Host "Pnpm added to the current session PATH." -ForegroundColor Green
    }

    # Verify installation
    if (Get-Command pnpm -ErrorAction SilentlyContinue) {
        Write-Host "Pnpm has been installed successfully and is ready to use." -ForegroundColor Green
    } else {
        Write-Host "Pnpm installation failed or is not available. Please troubleshoot." -ForegroundColor Red
        exit 1
    }
}

# Function to install Node.js using Pnpm
function Install-Node {
    Write-Host "Installing Node.js using Pnpm..." -ForegroundColor Cyan

    # Check if Node.js is already installed
    if (Get-Command node -ErrorAction SilentlyContinue) {
        Write-Host "Node.js is already installed. Skipping installation..." -ForegroundColor Yellow
        return
    }

    # Install the latest LTS version of Node.js globally using Pnpm
    pnpm env use --global lts

    # Verify Node.js installation
    if (Get-Command node -ErrorAction SilentlyContinue) {
        Write-Host "Node.js has been installed successfully using Pnpm." -ForegroundColor Green
    } else {
        Write-Host "Node.js installation failed." -ForegroundColor Red
        exit 1
    }
}

# Call the functions
Install-Pnpm
Install-Node

Write-Host "Pnpm and Node.js setup completed!" -ForegroundColor Green