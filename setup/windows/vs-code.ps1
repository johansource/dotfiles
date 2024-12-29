# vs-code.ps1
############################
# This script installs Visual Studio Code extensions
# and handles copying user settings
############################

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

Write-Host "VS Code extensions have been installed." -ForegroundColor Green

# Define the target directory for VS Code user settings on Windows
$targetDir = "$Env:APPDATA\Code\User"

# Check if VS Code settings directory exists
if (Test-Path $targetDir) {
    # Define the source directory for VS Code user settings
    $sourceDir = "C:\Projects\dotfiles\vscode\User"
    # Copy custom settings.json to the VS Code settings directory
    Copy-Item -Force -Path "$sourceDir\settings.json" -Destination "$targetDir\settings.json"
    # Uncomment to copy keybindings.json if needed
    # Copy-Item -Force -Path "$sourceDir\keybindings.json" -Destination "$targetDir\keybindings.json"
    Write-Host "VS Code settings and keybindings have been updated." -ForegroundColor Green
} else {
    Write-Host "VS Code user settings directory does not exist. Please ensure VS Code is installed." -ForegroundColor Red
}
