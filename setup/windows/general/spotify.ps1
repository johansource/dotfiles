# spotify.ps1
############################
# This script installs Spotify
############################

Write-Host "Starting Spotify setup..." -ForegroundColor Green

# Function to install or update Spotify using Winget
function Install-Spotify {
  Write-Host "Checking Spotify installation..." -ForegroundColor Cyan

  # Check if Spotify is already installed
  $spotifyPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps\Spotify.exe"
  if (Test-Path $spotifyPath) {
    Write-Host "Spotify is already installed. Checking for updates..." -ForegroundColor Yellow
    if (winget upgrade --id Spotify.Spotify -e --source winget) {
      Write-Host "Spotify has been updated to the latest version." -ForegroundColor Green
    }
    else {
      Write-Host "No updates available for Spotify." -ForegroundColor Cyan
    }
  }
  else {
    Write-Host "Spotify is not installed. Installing Spotify..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      winget install --id Spotify.Spotify -e --source winget
      Write-Host "Spotify has been installed successfully." -ForegroundColor Green
    }
    else {
      Write-Host "Winget is not available. Please install Spotify manually." -ForegroundColor Red
    }
  }
}

# Call installation function
Install-Spotify

Write-Host "Spotify has been installed." -ForegroundColor Green
