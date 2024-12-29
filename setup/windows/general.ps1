# general.ps1
############################
# General setup script for common tools
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Starting general setup..." -ForegroundColor Green

# Function to install or update Git using Winget
function Install-Git {
    Write-Host "Checking Git installation..." -ForegroundColor Cyan

    # Check if Git is already installed
    if (Get-Command git -ErrorAction SilentlyContinue) {
        Write-Host "Git is already installed. Checking for updates..." -ForegroundColor Yellow
        if (winget upgrade --id Git.Git -e --source winget) {
            Write-Host "Git has been updated to the latest version." -ForegroundColor Green
        } else {
            Write-Host "No updates available for Git." -ForegroundColor Cyan
        }
    } else {
        Write-Host "Git is not installed. Installing Git..." -ForegroundColor Cyan
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            winget install --id Git.Git -e --source winget
            Write-Host "Git has been installed successfully." -ForegroundColor Green
        } else {
            Write-Host "Winget is not available. Please install Git manually." -ForegroundColor Red
        }
    }
}

# Function to install or update 1Password using Winget
function Install-1Password {
    Write-Host "Checking 1Password installation..." -ForegroundColor Cyan

    # Check if 1Password is already installed
    if (Get-Command op -ErrorAction SilentlyContinue) {
        Write-Host "1Password CLI is already installed. Checking for updates..." -ForegroundColor Yellow
        if (winget upgrade --id AgileBits.1Password -e --source winget) {
            Write-Host "1Password has been updated to the latest version." -ForegroundColor Green
        } else {
            Write-Host "No updates available for 1Password." -ForegroundColor Cyan
        }
    } else {
        Write-Host "1Password is not installed. Installing 1Password..." -ForegroundColor Cyan
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            winget install --id AgileBits.1Password -e --source winget
            Write-Host "1Password has been installed successfully." -ForegroundColor Green
        } else {
            Write-Host "Winget is not available. Please install 1Password manually." -ForegroundColor Red
        }
    }
}

# Function to install Arc Browser
#* Not yet available for Winget, custom script
function Install-ArcBrowser {
    Write-Host "Checking Arc Browser installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $arcPath = "$env:LOCALAPPDATA\Arc\Application\Arc.exe"

    # Check if Arc is already installed
    if (Test-Path $arcPath) {
        Write-Host "Arc Browser is already installed. Skipping..." -ForegroundColor Yellow
        return
    }

    # Define the URL for the Arc installer
    #! Need to make sure Url is correct and up to date
    $installerUrl = "https://releases.arc.net/windows/ArcInstaller.exe"
    $installerPath = "$env:TEMP\ArcInstaller.exe"

    # Download the installer
    Write-Host "Downloading Arc Browser installer..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

    # Run the installer silently
    Write-Host "Installing Arc Browser..." -ForegroundColor Cyan
    Start-Process -FilePath $installerPath -ArgumentList "/silent", "/norestart" -Wait

    # Verify installation
    if (Test-Path $arcPath) {
        Write-Host "Arc Browser has been installed successfully." -ForegroundColor Green
    } else {
        Write-Host "Arc Browser installation failed." -ForegroundColor Red
    }
}

# Function to install or update Spotify using Winget
function Install-Spotify {
    Write-Host "Checking Spotify installation..." -ForegroundColor Cyan

    # Check if Spotify is already installed
    $spotifyPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps\Spotify.exe"
    if (Test-Path $spotifyPath) {
        Write-Host "Spotify is already installed. Checking for updates..." -ForegroundColor Yellow
        if (winget upgrade --id Spotify.Spotify -e --source winget) {
            Write-Host "Spotify has been updated to the latest version." -ForegroundColor Green
        } else {
            Write-Host "No updates available for Spotify." -ForegroundColor Cyan
        }
    } else {
        Write-Host "Spotify is not installed. Installing Spotify..." -ForegroundColor Cyan
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            winget install --id Spotify.Spotify -e --source winget
            Write-Host "Spotify has been installed successfully." -ForegroundColor Green
        } else {
            Write-Host "Winget is not available. Please install Spotify manually." -ForegroundColor Red
        }
    }
}

# Function to install or update Discord using Winget
function Install-Discord {
    Write-Host "Checking Discord installation..." -ForegroundColor Cyan

    # Check if Discord is already installed
    $discordPath = "$env:LOCALAPPDATA\Discord\Update.exe"
    if (Test-Path $discordPath) {
        Write-Host "Discord is already installed. Checking for updates..." -ForegroundColor Yellow
        if (winget upgrade --id Discord.Discord -e --source winget) {
            Write-Host "Discord has been updated to the latest version." -ForegroundColor Green
        } else {
            Write-Host "No updates available for Discord." -ForegroundColor Cyan
        }
    } else {
        Write-Host "Discord is not installed. Installing Discord..." -ForegroundColor Cyan
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            winget install --id Discord.Discord -e --source winget
            Write-Host "Discord has been installed successfully." -ForegroundColor Green
        } else {
            Write-Host "Winget is not available. Please install Discord manually." -ForegroundColor Red
        }
    }
}

# Function to install Logitech G Hub
#* Not yet available for Winget, custom script
function Install-LogitechGHub {
    Write-Host "Checking Logitech G Hub installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $ghubPath = "C:\Program Files\LGHUB\lghub.exe"

    # Check if Logitech G Hub is already installed
    if (Test-Path $ghubPath) {
        Write-Host "Logitech G Hub is already installed. Skipping..." -ForegroundColor Yellow
        return
    }

    # Define the URL for the Logitech G Hub installer
    #! Need to make sure Url is correct and up to date
    $installerUrl = "https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe"
    $installerPath = "$env:TEMP\lghub_installer.exe"

    # Download the installer
    Write-Host "Downloading Logitech G Hub installer..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

    # Run the installer silently
    Write-Host "Installing Logitech G Hub..." -ForegroundColor Cyan
    Start-Process -FilePath $installerPath -ArgumentList "/silent", "/norestart" -Wait

    # Verify installation
    if (Test-Path $ghubPath) {
        Write-Host "Logitech G Hub has been installed successfully." -ForegroundColor Green
    } else {
        Write-Host "Logitech G Hub installation failed." -ForegroundColor Red
    }
}

# Function to install Elgato Wave Link
#* Not yet available for Winget, custom script
function Install-ElgatoWaveLink {
    Write-Host "Checking Elgato Wave Link installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $waveLinkPath = "C:\Program Files\Elgato\Wave Link\WaveLink.exe"

    # Check if Elgato Wave Link is already installed
    if (Test-Path $waveLinkPath) {
        Write-Host "Elgato Wave Link is already installed. Skipping..." -ForegroundColor Yellow
        return
    }

    # Define the URL for the Wave Link installer
    #! Need to make sure Url is correct and up to date
    $installerUrl = "https://edge.elgato.com/egc/windows/WaveLink_1.6.0.5562.exe"
    $installerPath = "$env:TEMP\WaveLinkInstaller.exe"

    # Download the installer
    Write-Host "Downloading Elgato Wave Link installer..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

    # Run the installer silently
    Write-Host "Installing Elgato Wave Link..." -ForegroundColor Cyan
    Start-Process -FilePath $installerPath -ArgumentList "/quiet", "/norestart" -Wait

    # Verify installation
    if (Test-Path $waveLinkPath) {
        Write-Host "Elgato Wave Link has been installed successfully." -ForegroundColor Green
    } else {
        Write-Host "Elgato Wave Link installation failed." -ForegroundColor Red
    }
}

# Function to install or update Notion using Winget
function Install-Notion {
    Write-Host "Checking Notion installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $notionPath = "$env:LOCALAPPDATA\Notion\Notion.exe"

    # Check if Notion is already installed
    if (Test-Path $notionPath) {
        Write-Host "Notion is already installed. Checking for updates..." -ForegroundColor Yellow
        if (winget upgrade --id Notion.Notion -e --source winget) {
            Write-Host "Notion has been updated to the latest version." -ForegroundColor Green
        } else {
            Write-Host "No updates available for Notion." -ForegroundColor Cyan
        }
    } else {
        Write-Host "Notion is not installed. Installing Notion..." -ForegroundColor Cyan
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            winget install --id Notion.Notion -e --source winget
            Write-Host "Notion has been installed successfully." -ForegroundColor Green
        } else {
            Write-Host "Winget is not available. Please install Notion manually." -ForegroundColor Red
        }
    }
}

# Function to install or update VLC Media Player using Winget
function Install-VLC {
    Write-Host "Checking VLC installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $vlcPath = "C:\Program Files\VideoLAN\VLC\vlc.exe"

    # Check if VLC is already installed
    if (Test-Path $vlcPath) {
        Write-Host "VLC is already installed. Checking for updates..." -ForegroundColor Yellow
        if (winget upgrade --id VideoLAN.VLC -e --source winget) {
            Write-Host "VLC has been updated to the latest version." -ForegroundColor Green
        } else {
            Write-Host "No updates available for VLC." -ForegroundColor Cyan
        }
    } else {
        Write-Host "VLC is not installed. Installing VLC..." -ForegroundColor Cyan
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            winget install --id VideoLAN.VLC -e --source winget
            Write-Host "VLC has been installed successfully." -ForegroundColor Green
        } else {
            Write-Host "Winget is not available. Please install VLC manually." -ForegroundColor Red
        }
    }
}

# Function to install or update OBS Studio using Winget
function Install-OBS {
    Write-Host "Checking OBS Studio installation..." -ForegroundColor Cyan

    # Define the expected installation path
    $obsPath = "C:\Program Files\obs-studio\bin\64bit\obs64.exe"

    # Check if OBS Studio is already installed
    if (Test-Path $obsPath) {
        Write-Host "OBS Studio is already installed. Checking for updates..." -ForegroundColor Yellow
        if (winget upgrade --id OBSProject.OBSStudio -e --source winget) {
            Write-Host "OBS Studio has been updated to the latest version." -ForegroundColor Green
        } else {
            Write-Host "No updates available for OBS Studio." -ForegroundColor Cyan
        }
    } else {
        Write-Host "OBS Studio is not installed. Installing OBS Studio..." -ForegroundColor Cyan
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            winget install --id OBSProject.OBSStudio -e --source winget
            Write-Host "OBS Studio has been installed successfully." -ForegroundColor Green
        } else {
            Write-Host "Winget is not available. Please install OBS Studio manually." -ForegroundColor Red
        }
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
}

# Call installation functions
Install-Git
Install-1Password
Install-ArcBrowser
Install-Spotify
Install-Discord
Install-LogitechGHub
Install-ElgatoWaveLink
Install-Notion
Install-VLC
Install-OBS
Install-VSCode

Write-Host "General setup completed!" -ForegroundColor Green