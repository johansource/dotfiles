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

# Define the path to the scripts using $PSScriptRoot
$blenderScript = Join-Path $PSScriptRoot "gamedev/blender.ps1"
$unityHubScript = Join-Path $PSScriptRoot "gamedev/unity-hub.ps1"
$epicGamesLauncherScript = Join-Path $PSScriptRoot "gamedev/epic-games-launcher.ps1"

# Call the Blender setup script
if (Test-Path $blenderScript) {
    Write-Host "Running Blender setup..." -ForegroundColor Cyan
    & $blenderScript
}
else {
    Write-Host "Error: Blender setup script not found at $blenderScript" -ForegroundColor Red
}

# Call the Unity Hub setup script
if (Test-Path $unityHubScript) {
    Write-Host "Running Unity Hub setup..." -ForegroundColor Cyan
    & $unityHubScript
}
else {
    Write-Host "Error: Unity Hub setup script not found at $unityHubScript" -ForegroundColor Red
}

# Call the Epic Games Launcher setup script
if (Test-Path $epicGamesLauncherScript) {
    Write-Host "Running Epic Games Launcher setup..." -ForegroundColor Cyan
    & $epicGamesLauncherScript
}
else {
    Write-Host "Error: Epic Games Launcher setup script not found at $epicGamesLauncherScript" -ForegroundColor Red
}

Write-Host "Game development setup completed!" -ForegroundColor Green
