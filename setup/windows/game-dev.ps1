# game-dev.ps1
############################
# Game development tools setup script
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Starting game development setup..." -ForegroundColor Green

# Function to install Blender using Winget
function Install-Blender {
    Write-Host "Checking Blender installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $blenderPath = "$env:ProgramFiles\Blender Foundation\Blender\blender.exe"

    # Check if Blender is already installed
    if (Test-Path $blenderPath) {
        Write-Host "Blender is already installed. Skipping installation..." -ForegroundColor Yellow
        return
    }

    # Install Blender via Winget
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "Installing Blender via Winget..." -ForegroundColor Cyan
        winget install --id BlenderFoundation.Blender -e
    } else {
        Write-Host "Winget is not available. Please install Blender manually." -ForegroundColor Red
        exit 1
    }

    # Verify installation
    if (-not (Test-Path $blenderPath)) {
        Write-Host "Error: Blender installation failed. Please troubleshoot." -ForegroundColor Red
        exit 1
    }

    Write-Host "Blender installed successfully." -ForegroundColor Green
}

# Function to install Unity Hub using Winget
function Install-UnityHub {
    Write-Host "Checking Unity Hub installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $unityHubPath = "$env:LOCALAPPDATA\UnityHub\Unity Hub.exe"

    # Check if Unity Hub is already installed
    if (Test-Path $unityHubPath) {
        Write-Host "Unity Hub is already installed. Skipping installation..." -ForegroundColor Yellow
        return
    }

    # Install Unity Hub via Winget
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "Installing Unity Hub via Winget..." -ForegroundColor Cyan
        winget install --id UnityTechnologies.UnityHub -e
    } else {
        Write-Host "Winget is not available. Please install Unity Hub manually." -ForegroundColor Red
        exit 1
    }

    # Verify installation
    if (-not (Test-Path $unityHubPath)) {
        Write-Host "Error: Unity Hub installation failed. Please troubleshoot." -ForegroundColor Red
        exit 1
    }

    Write-Host "Unity Hub installed successfully." -ForegroundColor Green
}

# Function to install Epic Games Launcher using Winget
function Install-EpicGamesLauncher {
    Write-Host "Checking Epic Games Launcher installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $epicGamesLauncherPath = "$env:ProgramFiles\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe"

    # Check if Epic Games Launcher is already installed
    if (Test-Path $epicGamesLauncherPath) {
        Write-Host "Epic Games Launcher is already installed. Skipping installation..." -ForegroundColor Yellow
        return
    }

    # Install Epic Games Launcher via Winget
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "Installing Epic Games Launcher via Winget..." -ForegroundColor Cyan
        winget install --id EpicGames.EpicGamesLauncher -e
    } else {
        Write-Host "Winget is not available. Please install Epic Games Launcher manually." -ForegroundColor Red
        exit 1
    }

    # Verify installation
    if (-not (Test-Path $epicGamesLauncherPath)) {
        Write-Host "Error: Epic Games Launcher installation failed. Please troubleshoot." -ForegroundColor Red
        exit 1
    }

    Write-Host "Epic Games Launcher installed successfully." -ForegroundColor Green
}

# Call installation functions
Install-Blender
Install-UnityHub
Install-EpicGamesLauncher

Write-Host "Game development setup completed!" -ForegroundColor Green
