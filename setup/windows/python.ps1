# python.ps1
############################
# Python environment setup script
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Starting Python setup..." -ForegroundColor Green

# Function to install Python using Winget
function Install-Python {
    Write-Host "Checking Python installation..." -ForegroundColor Cyan

    # Check if Python is already installed
    if (Get-Command python -ErrorAction SilentlyContinue) {
        Write-Host "Python is already installed. Skipping installation..." -ForegroundColor Yellow
        return
    }

    # Install Python via Winget
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "Installing Python via Winget..." -ForegroundColor Cyan
        winget install --id Python.Python.3 -e
    } else {
        Write-Host "Winget is not available. Please install Python manually." -ForegroundColor Red
        exit 1
    }

    # Verify Python installation
    if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
        Write-Host "Error: Python installation failed. Please troubleshoot." -ForegroundColor Red
        exit 1
    }

    Write-Host "Python installed successfully." -ForegroundColor Green
}

# Function to install pyenv for Windows
function Install-Pyenv {
    Write-Host "Checking pyenv installation..." -ForegroundColor Cyan

    # Check if pyenv is already installed
    if (Test-Path "$env:USERPROFILE\.pyenv") {
        Write-Host "Pyenv is already installed. Skipping installation..." -ForegroundColor Yellow
        return
    }

    # Install pyenv for Windows using Scoop (preferred) or manual setup
    try {
        Invoke-WebRequest -Uri https://pyenv-win.github.io/pyenv-win/install.sh -OutFile "$env:TEMP\install_pyenv.ps1"
        . "$env:TEMP\install_pyenv.ps1"
        Write-Host "Pyenv installed successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error: Failed to install pyenv. Please troubleshoot." -ForegroundColor Red
        exit 1
    }
}

# Function to install Poetry
function Install-Poetry {
    Write-Host "Checking Poetry installation..." -ForegroundColor Cyan

    # Check if Poetry is already installed
    if (Get-Command poetry -ErrorAction SilentlyContinue) {
        Write-Host "Poetry is already installed. Skipping installation..." -ForegroundColor Yellow
        return
    }

    # Install Poetry using the official installation script
    try {
        Invoke-WebRequest -Uri https://install.python-poetry.org -OutFile "$env:TEMP\install_poetry.py"
        python "$env:TEMP\install_poetry.py"
        Write-Host "Poetry installed successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error: Failed to install Poetry. Please troubleshoot." -ForegroundColor Red
        exit 1
    }
}

# Function to ensure tkinter support
function Configure-TclTk {
    Write-Host "Ensuring Tcl/Tk support for Python..." -ForegroundColor Cyan

    # Tcl/Tk comes bundled with Windows Python installations.
    # Verify tkinter is functional
    try {
        python -c "import tkinter; print('Tkinter is functional.')"
        Write-Host "Tkinter is functional and ready to use." -ForegroundColor Green
    } catch {
        Write-Host "Error: Tkinter is not functional. Ensure Tcl/Tk is properly installed." -ForegroundColor Red
        exit 1
    }
}

# Call installation functions
Install-Python
Install-Pyenv
Install-Poetry
Configure-TclTk

Write-Host "Python setup completed!" -ForegroundColor Green
