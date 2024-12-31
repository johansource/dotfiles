# vs-code.ps1
############################
# This script installs Visual Studio Code extensions
# and handles copying user settings
############################

# Function to install VS Code extensions
function Install-VSCodeExtensions {
    Write-Host "Installing VS Code extensions..." -ForegroundColor Cyan

    # Path to the extensions file
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
    $extensionsFile = Join-Path $scriptDir "..\vs-code-extensions.txt"

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
    Write-Host "Installing VS Code extensions..." -ForegroundColor Green
    Get-Content $extensionsFile | ForEach-Object {
        $extension = $_.Trim()
        # Skip empty lines and comments
        if ($extension -and -not $extension.StartsWith("#")) {
            if ($installedExtensions -contains $extension) {
                Write-Host "$extension is already installed. Skipping..." -ForegroundColor Yellow
            } else {
                Write-Host "Installing $extension..." -ForegroundColor Cyan
                if (-Not (code --install-extension $extension)) {
                    Write-Host "Failed to install $extension" -ForegroundColor Red
                }
            }
        }
    }
}

# Function to symlink VS Code configuration files
function Symlink-VSCodeConfig {
    Write-Host "Setting up symlinks for VS Code configuration..." -ForegroundColor Cyan

    # Define the source and destination paths
    $dotfilesDir = "$PSScriptRoot\..\.."  # Adjust this to point to the dotfiles directory
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
                Write-Host "$file already exists at $targetFile. Removing it to create the symlink..." -ForegroundColor Yellow
                Remove-Item -Path $targetFile -Force
            }

            # Create the symbolic link
            try {
                Write-Host "Creating symlink: $targetFile -> $sourceFile" -ForegroundColor Cyan
                New-Item -ItemType SymbolicLink -Path $targetFile -Target $sourceFile
                Write-Host "$file symlink created successfully." -ForegroundColor Green
            } catch {
                Write-Host "Error creating symlink for $file: $_" -ForegroundColor Red
            }
        } else {
            Write-Host "$file does not exist in the source directory. Skipping..." -ForegroundColor Yellow
        }
    }
}

# Call installation functions
Install-VSCodeExtensions
Symlink-VSCodeConfig

Write-Host "VS Code extensions have been installed." -ForegroundColor Green
