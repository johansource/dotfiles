# dev.ps1
############################
# Developer tools setup script
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Starting development setup..." -ForegroundColor Green

# Function to install WezTerm using Winget
function Install-WezTerm {
    Write-Host "Checking WezTerm installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $wezTermPath = "$env:LOCALAPPDATA\wezterm\wezterm.exe"

    # Check if WezTerm is already installed
    if (Test-Path $wezTermPath) {
        Write-Host "WezTerm is already installed. Skipping installation..." -ForegroundColor Yellow
        return
    }

    # Install WezTerm via Winget
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "Installing WezTerm via Winget..." -ForegroundColor Cyan
        winget install --id Wez.WezTerm -e
    } else {
        Write-Host "Winget is not available. Please install WezTerm manually." -ForegroundColor Red
        exit 1
    }

    # Verify the WezTerm installation path
    if (-not (Test-Path $wezTermPath)) {
        Write-Host "Error: WezTerm installation directory not found at $wezTermPath. Please verify the installation." -ForegroundColor Red
        exit 1
    }

    # Add WezTerm to the global PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
    $wezTermBinPath = "$env:LOCALAPPDATA\wezterm"
    if ($wezTermBinPath -notin ($currentPath -split ';')) {
        [Environment]::SetEnvironmentVariable("Path", $currentPath + ";" + $wezTermBinPath, [EnvironmentVariableTarget]::Machine)
        Write-Host "WezTerm added to the global PATH." -ForegroundColor Green
    } else {
        Write-Host "WezTerm is already in the global PATH." -ForegroundColor Yellow
    }

    # Temporarily add WezTerm to the current session PATH
    if ($wezTermBinPath -notin ($env:Path -split ';')) {
        $env:Path += ";$wezTermBinPath"
        Write-Host "WezTerm added to the current session PATH." -ForegroundColor Green
    }

    # Verify installation
    if (Test-Path $wezTermPath) {
        Write-Host "WezTerm has been installed successfully and is ready to use." -ForegroundColor Green
    } else {
        Write-Host "WezTerm installation failed. Please troubleshoot." -ForegroundColor Red
        exit 1
    }
}

# Function to install Starship
function Install-Starship {
    Write-Host "Checking Starship installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $starshipPath = "$env:USERPROFILE\.cargo\bin\starship.exe"

    # Check if Starship is already installed
    if (Test-Path $starshipPath) {
        Write-Host "Starship is already installed. Skipping installation..." -ForegroundColor Yellow
        return
    }

    # Download and run the Starship installation script
    try {
        Invoke-WebRequest https://starship.rs/install.ps1 -UseBasicParsing | Invoke-Expression
        Write-Host "Starship installation script executed successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error: Failed to execute the Starship installation script." -ForegroundColor Red
        exit 1
    }

    # Verify the Starship installation path
    if (-not (Test-Path $starshipPath)) {
        Write-Host "Error: Starship executable not found at $starshipPath. Please verify the installation." -ForegroundColor Red
        exit 1
    }

    # Add Starship to the global PATH
    $cargoBinPath = "$env:USERPROFILE\.cargo\bin"
    $currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
    if ($cargoBinPath -notin ($currentPath -split ';')) {
        [Environment]::SetEnvironmentVariable("Path", $currentPath + ";" + $cargoBinPath, [EnvironmentVariableTarget]::Machine)
        Write-Host "Starship's cargo bin path added to the global PATH." -ForegroundColor Green
    } else {
        Write-Host "Starship's cargo bin path is already in the global PATH." -ForegroundColor Yellow
    }

    # Temporarily add Starship to the current session PATH
    if ($cargoBinPath -notin ($env:Path -split ';')) {
        $env:Path += ";$cargoBinPath"
        Write-Host "Starship's cargo bin path added to the current session PATH." -ForegroundColor Green
    }

    # Verify installation
    if (Get-Command starship -ErrorAction SilentlyContinue) {
        Write-Host "Starship has been installed successfully and is ready to use." -ForegroundColor Green
    } else {
        Write-Host "Starship installation failed. Please troubleshoot." -ForegroundColor Red
        exit 1
    }
}

# Function to install or update Visual Studio Code using Winget
function Install-VSCode {
    Write-Host "Checking Visual Studio Code installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $vscodePath = "C:\Program Files\Microsoft VS Code\Code.exe"

    # Check if VS Code is already installed
    if (Test-Path $vscodePath) {
        Write-Host "Visual Studio Code is already installed. Checking for updates..." -ForegroundColor Yellow
        if (winget upgrade --id Microsoft.VisualStudioCode -e --source winget) {
            Write-Host "Visual Studio Code has been updated to the latest version." -ForegroundColor Green
        } else {
            Write-Host "No updates available for Visual Studio Code." -ForegroundColor Cyan
        }
    } else {
        Write-Host "Visual Studio Code is not installed. Installing Visual Studio Code..." -ForegroundColor Cyan
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            winget install --id Microsoft.VisualStudioCode -e --source winget
            Write-Host "Visual Studio Code has been installed successfully." -ForegroundColor Green
        } else {
            Write-Host "Winget is not available. Please install Visual Studio Code manually." -ForegroundColor Red
        }
    }

    # Update PATH for the current session
    $vscodeBinPath = "C:\Program Files\Microsoft VS Code"
    if ($vscodeBinPath -notin ($env:Path -split ';')) {
        $env:Path += ";$vscodeBinPath"
        Write-Host "VS Code bin path added to the current session PATH." -ForegroundColor Green
    }

    # Verify that the 'code' command is available
    if (Get-Command code -ErrorAction SilentlyContinue) {
        Write-Host "VS Code CLI is available." -ForegroundColor Green
    } else {
        Write-Host "VS Code CLI is not available. Please restart the terminal if issues persist." -ForegroundColor Red
    }
}

# Function to install Visual Studio 2022 Community with specific workloads using Winget
function Install-VisualStudio {
    Write-Host "Checking Visual Studio installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $vsInstallerPath = "$env:ProgramFiles(x86)\Microsoft Visual Studio\Installer\vs_installer.exe"

    # Check if Visual Studio is already installed
    if (Test-Path $vsInstallerPath) {
        Write-Host "Visual Studio Installer is already installed. Checking for updates..." -ForegroundColor Yellow
        Start-Process -FilePath $vsInstallerPath -ArgumentList "update" -Wait
        Write-Host "Visual Studio Installer has been updated." -ForegroundColor Green
    } else {
        Write-Host "Installing Visual Studio Community 2022..." -ForegroundColor Cyan

        # Install Visual Studio Community 2022 with specific workloads
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            winget install --id Microsoft.VisualStudio.2022.Community -e --override `
                "--add Microsoft.VisualStudio.Workload.NetWeb `
                --add Microsoft.VisualStudio.Workload.ManagedGame `
                --add Microsoft.VisualStudio.Workload.NativeGame"
            Write-Host "Visual Studio Community 2022 installed successfully with specified workloads." -ForegroundColor Green
        } else {
            Write-Host "Winget is not available. Please install Visual Studio manually." -ForegroundColor Red
            exit 1
        }
    }

    # Verify the installation
    $vsCommunityPath = "$env:ProgramFiles\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
    if (Test-Path $vsCommunityPath) {
        Write-Host "Visual Studio Community 2022 has been installed successfully and is ready to use." -ForegroundColor Green
    } else {
        Write-Host "Visual Studio installation failed or is not available. Please troubleshoot." -ForegroundColor Red
        exit 1
    }
}

# Function to install Neovim using Winget
function Install-Neovim {
    Write-Host "Checking Neovim installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $neovimPath = "$env:ProgramFiles\Neovim\bin\nvim.exe"

    # Check if Neovim is already installed
    if (Test-Path $neovimPath) {
        Write-Host "Neovim is already installed. Skipping installation..." -ForegroundColor Yellow
        return
    }

    # Install Neovim via Winget
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "Installing Neovim via Winget..." -ForegroundColor Cyan
        winget install --id Neovim.Neovim -e
    } else {
        Write-Host "Winget is not available. Please install Neovim manually." -ForegroundColor Red
        exit 1
    }

    # Verify the Neovim installation path
    if (-not (Test-Path $neovimPath)) {
        Write-Host "Error: Neovim executable not found at $neovimPath. Please verify the installation." -ForegroundColor Red
        exit 1
    }

    # Add Neovim to the global PATH
    $neovimBinPath = "$env:ProgramFiles\Neovim\bin"
    $currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
    if ($neovimBinPath -notin ($currentPath -split ';')) {
        [Environment]::SetEnvironmentVariable("Path", $currentPath + ";" + $neovimBinPath, [EnvironmentVariableTarget]::Machine)
        Write-Host "Neovim bin path added to the global PATH." -ForegroundColor Green
    } else {
        Write-Host "Neovim bin path is already in the global PATH." -ForegroundColor Yellow
    }

    # Temporarily add Neovim to the current session PATH
    if ($neovimBinPath -notin ($env:Path -split ';')) {
        $env:Path += ";$neovimBinPath"
        Write-Host "Neovim bin path added to the current session PATH." -ForegroundColor Green
    }

    # Verify installation
    if (Get-Command nvim -ErrorAction SilentlyContinue) {
        Write-Host "Neovim has been installed successfully and is ready to use." -ForegroundColor Green
    } else {
        Write-Host "Neovim installation failed. Please troubleshoot." -ForegroundColor Red
        exit 1
    }
}

# Function to install DevToys using Winget
function Install-Devtoys {
    Write-Host "Checking DevToys installation..." -ForegroundColor Cyan

    $devtoysPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps\DevToys.exe"

    if (Test-Path $devtoysPath) {
        Write-Host "DevToys is already installed. Skipping installation..." -ForegroundColor Yellow
        return
    }

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "Installing DevToys via Winget..." -ForegroundColor Cyan
        winget install --id DevToys.DevToys -e
    } else {
        Write-Host "Winget is not available. Please install DevToys manually." -ForegroundColor Red
        exit 1
    }

    if (-not (Test-Path $devtoysPath)) {
        Write-Host "Error: DevToys installation failed. Please troubleshoot." -ForegroundColor Red
        exit 1
    }

    Write-Host "DevToys installed successfully." -ForegroundColor Green
}

# Function to install fonts
function Install-Fonts {
    Write-Host "Installing fonts..." -ForegroundColor Cyan

    # Define the fonts to download
    $fonts = @(
        @{
            Name = "JetBrains Mono";
            Url = "https://github.com/JetBrains/JetBrainsMono/releases/latest/download/JetBrainsMono-2.304.zip";
        },
        @{
            Name = "JetBrains Mono Nerd Font";
            Url = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip";
        },
        @{
            Name = "Source Code Pro";
            Url = "https://github.com/adobe-fonts/source-code-pro/releases/latest/download/TTF-source-code-pro.zip";
        }
    )

    # Temporary directory for downloads
    $tempDir = "$env:TEMP\fonts"
    if (-not (Test-Path $tempDir)) {
        New-Item -ItemType Directory -Path $tempDir | Out-Null
    }

    # Fonts installation directory
    $fontsDir = "C:\Windows\Fonts"

    foreach ($font in $fonts) {
        try {
            # Download the font archive
            $zipPath = Join-Path $tempDir "$($font.Name).zip"
            Write-Host "Downloading $($font.Name)..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $font.Url -OutFile $zipPath -ErrorAction Stop

            # Extract the font files
            $extractPath = Join-Path $tempDir "$($font.Name)"
            if (-not (Test-Path $extractPath)) {
                New-Item -ItemType Directory -Path $extractPath | Out-Null
            }
            Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

            # Install the font files
            Write-Host "Installing $($font.Name) fonts..." -ForegroundColor Cyan
            Get-ChildItem -Path $extractPath -Recurse -Include *.ttf, *.otf | ForEach-Object {
                Copy-Item -Path $_.FullName -Destination $fontsDir -Force
            }

            Write-Host "$($font.Name) installed successfully." -ForegroundColor Green
        } catch {
            Write-Host "Error installing $($font.Name): $_" -ForegroundColor Red
        }
    }

    # Cleanup
    Remove-Item -Recurse -Force $tempDir
    Write-Host "Font installation completed." -ForegroundColor Green
}

# Function to create a symbolic link for wezterm.lua
function Symlink-Wezterm {
    Write-Host "Setting up symlink for wezterm.lua..." -ForegroundColor Cyan

    # Define the source and destination paths
    $dotfilesDir = "$PSScriptRoot\..\.."
    $weztermSource = Join-Path $dotfilesDir "wezterm\wezterm.lua"
    $weztermTarget = "$env:USERPROFILE\.wezterm.lua"

    # Check if the destination already exists
    if (Test-Path $weztermTarget) {
        Write-Host "wezterm.lua already exists at $weztermTarget. Removing it to create the symlink..." -ForegroundColor Yellow
        Remove-Item -Path $weztermTarget -Force
    }

    # Create the symbolic link
    try {
        Write-Host "Creating symlink: $weztermTarget -> $weztermSource" -ForegroundColor Cyan
        New-Item -ItemType SymbolicLink -Path $weztermTarget -Target $weztermSource
        Write-Host "wezterm.lua symlink created successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error creating symlink for wezterm.lua: $_" -ForegroundColor Red
    }
}

# Function to create a symbolic link for starship.toml
function Symlink-Starship {
    Write-Host "Setting up symlink for starship.toml..." -ForegroundColor Cyan

    # Define the source and destination paths
    $dotfilesDir = "$PSScriptRoot\..\.."
    $starshipSource = Join-Path $dotfilesDir "starship\starship.toml"
    $starshipConfigDir = "$env:USERPROFILE\.config"
    $starshipTarget = Join-Path $starshipConfigDir "starship.toml"

    # Ensure the config directory exists
    if (-not (Test-Path $starshipConfigDir)) {
        Write-Host "Creating Starship config directory at $starshipConfigDir" -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $starshipConfigDir
    }

    # Check if the destination already exists
    if (Test-Path $starshipTarget) {
        Write-Host "starship.toml already exists at $starshipTarget. Removing it to create the symlink..." -ForegroundColor Yellow
        Remove-Item -Path $starshipTarget -Force
    }

    # Create the symbolic link
    try {
        Write-Host "Creating symlink: $starshipTarget -> $starshipSource" -ForegroundColor Cyan
        New-Item -ItemType SymbolicLink -Path $starshipTarget -Target $starshipSource
        Write-Host "starship.toml symlink created successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error creating symlink for starship.toml: $_" -ForegroundColor Red
    }
}

# Call installation functions
Install-WezTerm
Install-Starship
Install-VSCode
Install-VisualStudio
Install-Neovim
Install-Devtoys
Install-Fonts
Symlink-Wezterm
Symlink-Starship

# Define the path to the VS Code setup script
$vsCodeScript = Join-Path $PSScriptRoot "vs-code.ps1"

# Call the VS Code extensions setup script
if (Test-Path $vsCodeScript) {
    Write-Host "Running VS Code extensions setup..." -ForegroundColor Cyan
    & $vsCodeScript
} else {
    Write-Host "Error: VS Code extensions setup script not found at $vsCodeScript" -ForegroundColor Red
}

Write-Host "Development setup completed!" -ForegroundColor Green
