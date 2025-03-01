# vs-code-extensions.ps1
############################
# This script installs Visual Studio Code extensions
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Visual Studio Code extensions setup..." -ForegroundColor Green

# Function to install VS Code extensions
function Install-VSCodeExtensions {
  Write-Host "Installing VS Code extensions..." -ForegroundColor Cyan

  # Path to the extensions file
  $extensionsFile = Join-Path $PSScriptRoot "..\..\vs-code-extensions.txt"

  # Ensure the extensions file exists
  if (-Not (Test-Path $extensionsFile)) {
      Write-Host "Error: vs-code-extensions.txt file not found." -ForegroundColor Red
      exit 1
  }

  # Check if VS Code is installed
  if (-Not (Get-Command code -ErrorAction SilentlyContinue)) {
      Write-Host "Visual Studio Code is not installed. Please install it before running this script." -ForegroundColor Red
      exit 1
  }

  # Get a list of all currently installed extensions
  $installedExtensions = code --list-extensions

  # Install VS Code Extensions
  Get-Content $extensionsFile | ForEach-Object {
      $extension = $_.Trim()
      # Skip empty lines and comments
      if ($extension -and -not $extension.StartsWith("#")) {
          if ($installedExtensions -contains $extension) {
              Write-Host "$extension is already installed. Skipping..." -ForegroundColor DarkYellow
          } else {
              Write-Host "Installing $extension..." -ForegroundColor Cyan
              # Run the command in a clean CLI environment
              $result = cmd /c "code --install-extension $extension --force --no-sync --disable-gpu"
              if ($LASTEXITCODE -eq 0) {
                  Write-Host "$extension installed successfully." -ForegroundColor Green
              } else {
                  Write-Host "Failed to install $extension (Exit Code: $LASTEXITCODE)" -ForegroundColor Red
              }
          }
      }
  }
}


# Call installation function
Install-VSCodeExtensions

Write-Host "Visual Studio Code extensions has been installed." -ForegroundColor Green
