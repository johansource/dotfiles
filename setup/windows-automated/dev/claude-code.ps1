# claude-code.ps1
############################
# This script installs Claude Code
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Claude Code setup..." -ForegroundColor Green

# Function to install Claude Code using proprietary script
function Install-ClaudeCode {
  Write-Host "Checking Claude Code installation..." -ForegroundColor Cyan

  $localBin = Join-Path $env:USERPROFILE ".local\bin"
  $claudeExe = Join-Path $localBin "claude.exe"

  # --- Skip if already installed ---
  if (Test-Path $claudeExe) {
    Write-Host "Claude Code is already installed. Skipping installation..." -ForegroundColor DarkYellow
  }
  else {
    $uri = "https://claude.ai/install.ps1"
    $tmp = Join-Path $env:TEMP "claude-install.ps1"

    Write-Host "Downloading Claude Code installer..." -ForegroundColor Cyan
    try {
      Invoke-WebRequest -Uri $uri -OutFile $tmp -UseBasicParsing
    }
    catch {
      Write-Host "Error: Failed to download Claude installer." -ForegroundColor Red
      exit 1
    }

    Write-Host "Running Claude Code installer..." -ForegroundColor Cyan
    try {
      & powershell -NoProfile -ExecutionPolicy Bypass -File $tmp
    }
    catch {
      Write-Host "Error: Claude Code installer failed." -ForegroundColor Red
      exit 1
    }

    if (-not (Test-Path $claudeExe)) {
      Write-Host "Error: Claude Code installation failed (claude.exe not found)." -ForegroundColor Red
      exit 1
    }

    Write-Host "Claude Code installed successfully." -ForegroundColor Green
  }

  # --- Ensure ~/.local/bin is in User PATH ---
  Write-Host "Ensuring Claude Code is available in PATH..." -ForegroundColor Cyan

  $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
  if ([string]::IsNullOrWhiteSpace($userPath)) {
    $userPath = ""
  }

  $pathParts = $userPath -split ";" | Where-Object { $_ -and $_.Trim() -ne "" }
  $alreadyExists = $pathParts | Where-Object {
    $_.TrimEnd('\') -ieq $localBin.TrimEnd('\')
  }

  if (-not $alreadyExists) {
    $newUserPath = ($pathParts + $localBin) -join ";"
    [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
    Write-Host "Added '$localBin' to User PATH." -ForegroundColor Green
  }
  else {
    Write-Host "'$localBin' already exists in User PATH. Skipping..." -ForegroundColor DarkYellow
  }

  # --- Refresh PATH in current session ---
  if ($env:Path -notlike "*$localBin*") {
    $env:Path = "$env:Path;$localBin"
    Write-Host "Refreshed PATH in current session." -ForegroundColor Green
  }

  # --- Final verification ---
  if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host "Warning: Claude is installed, but command is not available in this session." -ForegroundColor DarkYellow
    Write-Host "Open a new terminal to ensure PATH is refreshed." -ForegroundColor DarkYellow
  }
  else {
    $version = & claude --version 2>$null
    Write-Host "Claude Code ready ($version)." -ForegroundColor Green
  }
}

# Call installation function
Install-ClaudeCode

Write-Host "Claude Code has been installed." -ForegroundColor Green
