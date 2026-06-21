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

# Function to refresh path
function Refresh-Path {
    # Winget/installer kan uppdatera PATH, men din nuvarande PS-session ser inte det automatiskt.
    $machine = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $user = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machine;$user"
}

# Function to get 'python' command
function Get-RealPythonCommand {
    $py = Get-Command py.exe -ErrorAction SilentlyContinue
    if ($py) { return @{ Kind = "py"; Cmd = "py" } }

    $candidates = Get-Command python.exe -All -ErrorAction SilentlyContinue |
    Where-Object { $_.Source -and ($_.Source -notmatch '\\WindowsApps\\') }

    if ($candidates) {
        return @{ Kind = "python"; Cmd = $candidates[0].Source }
    }

    return $null
}

# Function to install Python using Winget
function Install-Python {
    Write-Host "Checking Python installation..." -ForegroundColor Cyan

    # Check if Python is already installed
    $python = Get-RealPythonCommand
    if ($python) {
        Write-Host "Python already available via: $($python.Cmd) (kind: $($python.Kind)). Skipping installation..." -ForegroundColor Yellow
        $script:PythonCmd = $python  # spara för senare steg
        return
    }

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "Installing Python via Winget..." -ForegroundColor Cyan
        winget install --id Python.Python.3.14 -e --source winget --accept-package-agreements --accept-source-agreements
    }
    else {
        Write-Host "Winget is not available. Please install Python manually." -ForegroundColor Red
        exit 1
    }

    Refresh-Path

    # Verify Python installation
    $python = Get-RealPythonCommand
    if (-not $python) {
        Write-Host "Error: Python installation failed or is still not discoverable in PATH." -ForegroundColor Red
        Write-Host "Tip: Close and reopen the terminal, or ensure App Execution Aliases for python/python3 are disabled." -ForegroundColor Yellow
        exit 1
    }

    $script:PythonCmd = $python

    Write-Host "Python installed successfully." -ForegroundColor Green
}

# Function to install pyenv for Windows
function Install-Pyenv {
    Write-Host "Checking pyenv installation..." -ForegroundColor Cyan

    # Check if pyenv is already installed
    if (Test-Path "$env:USERPROFILE\.pyenv\pyenv-win\bin\pyenv.bat") {
        Write-Host "Pyenv is already installed. Skipping installation..." -ForegroundColor Yellow
        return
    }

    # Install pyenv for Windows using the official installation script
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $installer = Join-Path $env:TEMP "install-pyenv-win.ps1"

        Invoke-WebRequest -UseBasicParsing `
            -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" `
            -OutFile $installer

        # Kör scriptet (inte dot-source)
        & $installer

        Write-Host "Pyenv installed successfully." -ForegroundColor Green

        Refresh-Path

        Write-Host "Note: You may need to restart the terminal for PATH changes to apply." -ForegroundColor Yellow
    }
    catch {
        Write-Host "Error: Failed to install pyenv. Please troubleshoot." -ForegroundColor Red
        Write-Host $_ -ForegroundColor DarkGray
        exit 1
    }
}

# Function to add to user path if missing
function Add-ToUserPathIfMissing([string]$dir) {
    if (-not (Test-Path $dir)) { return $false }

    $current = [Environment]::GetEnvironmentVariable("Path", "User")
    $parts = @()
    if ($current) { $parts = $current -split ";" }

    $normalized = ($dir.TrimEnd("\")).ToLowerInvariant()
    $already = $parts | Where-Object { $_ -and ($_.TrimEnd("\").ToLowerInvariant() -eq $normalized) }

    if (-not $already) {
        $new = @($parts + $dir) -join ";"
        [Environment]::SetEnvironmentVariable("Path", $new, "User")
        return $true
    }

    return $false
}

# Function to find Poetry.exe
function Find-PoetryExe {
    $candidates = @(
        (Join-Path $env:APPDATA "Python\Scripts\poetry.exe"),
        (Join-Path $env:APPDATA "pypoetry\venv\Scripts\poetry.exe")
    )

    foreach ($p in $candidates) {
        if (Test-Path $p) { return $p }
    }

    $found = Get-ChildItem -Path $env:APPDATA -Filter "poetry.exe" -Recurse -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName

    return $found
}

# Function to install Poetry
function Install-Poetry {
    Write-Host "Checking Poetry installation..." -ForegroundColor Cyan

    # If Poetry already works, we're done
    if (Get-Command poetry -ErrorAction SilentlyContinue) {
        Write-Host "Poetry is already installed and available in PATH. Skipping installation..." -ForegroundColor Yellow
        return
    }

    # Ensure we have a working Python command
    if (-not $script:PythonCmd) { $script:PythonCmd = Get-RealPythonCommand }
    if (-not $script:PythonCmd) {
        Write-Host "Error: Python is not available, cannot install Poetry." -ForegroundColor Red
        exit 1
    }

    try {
        # Run the official Poetry installer
        Invoke-WebRequest -Uri "https://install.python-poetry.org" -OutFile "$env:TEMP\install_poetry.py"

        if ($script:PythonCmd.Kind -eq "py") {
            & $script:PythonCmd.Cmd -3 "$env:TEMP\install_poetry.py"
        }
        else {
            & $script:PythonCmd.Cmd "$env:TEMP\install_poetry.py"
        }

        # Ensure Poetry folder is present in PATH (User PATH)
        $poetryExe = Find-PoetryExe
        if ($poetryExe) {
            $poetryDir = Split-Path $poetryExe -Parent
            $changed = Add-ToUserPathIfMissing $poetryDir

            # Refresh PATH for this session
            Refresh-Path

            if (Get-Command poetry -ErrorAction SilentlyContinue) {
                Write-Host "Poetry installed successfully and available in PATH." -ForegroundColor Green
            }
            else {
                Write-Host "Poetry was found at: $poetryExe" -ForegroundColor Yellow
                Write-Host "But 'poetry' is still not resolvable in this session." -ForegroundColor Yellow
                Write-Host "Try running it once via full path:" -ForegroundColor Yellow
                Write-Host "  `"$poetryExe`" --version" -ForegroundColor Yellow
            }

            if ($changed) {
                Write-Host "Added to User PATH: $poetryDir" -ForegroundColor Green
                Write-Host "Open a NEW terminal for PATH to apply everywhere." -ForegroundColor Yellow
            }
        }
        else {
            # Poetry install completed but we couldn't find poetry.exe to add it to PATH
            Refresh-Path
            Write-Host "Poetry installer ran, but poetry.exe could not be found under %APPDATA%." -ForegroundColor Yellow
            Write-Host "This usually means Poetry was installed under a different user profile (e.g. running as Administrator)." -ForegroundColor Yellow
            Write-Host "Try running the script without elevation or reinstall Poetry in your normal user context." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Error: Failed to install Poetry. Please troubleshoot." -ForegroundColor Red
        Write-Host $_ -ForegroundColor DarkGray
        exit 1
    }
}

# Function to ensure tkinter support
function Configure-TclTk {
    Write-Host "Ensuring Tcl/Tk support for Python..." -ForegroundColor Cyan

    # Tcl/Tk comes bundled with Windows Python installations.
    # Verify tkinter is functional
    try {
        if (-not $script:PythonCmd) { $script:PythonCmd = Get-RealPythonCommand }
        if (-not $script:PythonCmd) { throw "Python not available." }

        if ($script:PythonCmd.Kind -eq "py") {
            & $script:PythonCmd.Cmd -3 -c "import tkinter; print('Tkinter is functional.')"
        }
        else {
            & $script:PythonCmd.Cmd -c "import tkinter; print('Tkinter is functional.')"
        }

        Write-Host "Tkinter is functional and ready to use." -ForegroundColor Green
    }
    catch {
        Write-Host "Error: Tkinter is not functional. Ensure Tcl/Tk is properly installed." -ForegroundColor Red
        Write-Host $_ -ForegroundColor DarkGray
        exit 1
    }
}

# Call installation functions
Install-Python
Install-Pyenv
Install-Poetry
Configure-TclTk

Write-Host "Python setup completed!" -ForegroundColor Green
