# vs-code.ps1
############################
# This script installs Visual Studio Code
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Starting Visual Studio Code setup..." -ForegroundColor Green

# Function to install or update Visual Studio Code using Winget
function Install-VSCode {
    Write-Host "Checking Visual Studio Code installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $vscodePath = "C:\Program Files\Microsoft VS Code\Code.exe"

    # Check if VS Code is already installed
    if (Test-Path $vscodePath) {
        Write-Host "Visual Studio Code is already installed. Checking for updates..." -ForegroundColor DarkYellow
        if (winget upgrade --id Microsoft.VisualStudioCode -e --source winget) {
            Write-Host "Visual Studio Code has been updated to the latest version." -ForegroundColor Green
        }
        else {
            Write-Host "No updates available for Visual Studio Code." -ForegroundColor Cyan
        }
    }
    else {
        Write-Host "Visual Studio Code is not installed. Installing Visual Studio Code..." -ForegroundColor Cyan
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            winget install --id Microsoft.VisualStudioCode -e --source winget --scope machine --accept-source-agreements --accept-package-agreements
            Write-Host "Visual Studio Code has been installed successfully." -ForegroundColor Green
        }
        else {
            Write-Host "Winget is not available. Please install Visual Studio Code manually." -ForegroundColor Red
        }
    }

    # Update PATH for the current session
    $vscodeBinPath = "C:\Program Files\Microsoft VS Code\bin"
    if ($vscodeBinPath -notin ($env:Path -split ';')) {
        $env:Path += ";$vscodeBinPath"
        Write-Host "VS Code bin path added to the current session PATH." -ForegroundColor Green
    }

    # Verify that the 'code' command is available
    if (Get-Command code -ErrorAction SilentlyContinue) {
        Write-Host "VS Code CLI is available." -ForegroundColor Green
    }
    else {
        Write-Host "VS Code CLI is not available. Please restart the terminal if issues persist." -ForegroundColor Red
    }
}

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
            }
            else {
                Write-Host "Installing $extension..." -ForegroundColor Cyan
                # Run the command in a clean CLI environment
                $result = cmd /c "code --install-extension $extension --force --no-sync --disable-gpu"
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "$extension installed successfully." -ForegroundColor Green
                }
                else {
                    Write-Host "Failed to install $extension (Exit Code: $LASTEXITCODE)" -ForegroundColor Red
                }
            }
        }
    }
}

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
            }
            catch {
                Write-Host "Error creating symlink for $file : $_" -ForegroundColor Red
            }
        }
        else {
            Write-Host "$file does not exist in the source directory. Skipping..." -ForegroundColor DarkYellow
        }
    }
}

# Call installation function
Install-VSCode
Install-VSCodeExtensions
Symlink-VSCodeConfig

Write-Host "Visual Studio Code and externsions has been installed, and symlinks created." -ForegroundColor Green
