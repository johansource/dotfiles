# vs-code-symlinks.ps1
############################
# This script handles symlinking for Visual Studio Code files
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Visual Studio Code symlinks setup..." -ForegroundColor Green

# Function to symlink VS Code configuration files
function Symlink-VSCodeConfig {
  Write-Host "Setting up symlinks for VS Code configuration..." -ForegroundColor Cyan

  # Define the source and destination paths
  $dotfilesDir = "$PSScriptRoot\..\..\.."  # Adjust this to point to the dotfiles directory
  $vscodeSourceDir = Join-Path $dotfilesDir "vscode\User"
  $vscodeTargetDir = Join-Path "$env:APPDATA\Code" "User"

  # Files to symlink
  $filesToLink = @("settings.json", "keybindings.json")

  # Ensure the VS Code target directory exists
  if (-not (Test-Path $vscodeTargetDir)) {
      Write-Host "Creating VS Code user settings directory at $vscodeTargetDir" -ForegroundColor Cyan
      New-Item -ItemType Directory -Path $vscodeTargetDir
  }

  # Loop through each file and create symlinks
  foreach ($file in $filesToLink) {
      $sourceFile = Join-Path $vscodeSourceDir $file
      $targetFile = Join-Path $vscodeTargetDir $file

      if (Test-Path $sourceFile) {
          # Check if the destination already exists
          if (Test-Path $targetFile) {
              Write-Host "$file already exists at $targetFile. Removing it to create the symlink..." -ForegroundColor DarkYellow
              Remove-Item -Path $targetFile -Force
          }

          # Create the symbolic link
          try {
              Write-Host "Creating symlink: $targetFile -> $sourceFile" -ForegroundColor Cyan
              New-Item -ItemType SymbolicLink -Path $targetFile -Target $sourceFile
              Write-Host "$file symlink created successfully." -ForegroundColor Green
          } catch {
              Write-Host "Error creating symlink for $file : $_" -ForegroundColor Red
          }
      } else {
          Write-Host "$file does not exist in the source directory. Skipping..." -ForegroundColor DarkYellow
      }
  }
}

# Call installation function
Symlink-VSCodeConfig

Write-Host "Visual Studio Code symlinks has been created." -ForegroundColor Green
