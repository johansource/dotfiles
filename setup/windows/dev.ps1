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

# Define the path to the scripts using $PSScriptRoot
$devFontsScript = Join-Path $PSScriptRoot "dev/dev-fonts.ps1"
$weztermScript = Join-Path $PSScriptRoot "dev/wezterm.ps1"
$starshipScript = Join-Path $PSScriptRoot "dev/starship.ps1"
$vsCodeScript = Join-Path $PSScriptRoot "dev/vs-code.ps1"
$visualStudioScript = Join-Path $PSScriptRoot "dev/visual-studio.ps1"
$devtoysScript = Join-Path $PSScriptRoot "dev/devtoys.ps1"
$jetbrainsToolboxScript = Join-Path $PSScriptRoot "dev/jetbrains-toolbox.ps1"
$powershellSymlinksScript = Join-Path $PSScriptRoot "dev/powershell-symlinks.ps1"
$podmanScript = Join-Path $PSScriptRoot "dev/podman.ps1"

# Call the Fonts setup script
if (Test-Path $devFontsScript) {
    Write-Host "Running Fonts setup..." -ForegroundColor Cyan
    & $devFontsScript
}
else {
    Write-Host "Error: Fonts setup script not found at $devFontsScript" -ForegroundColor Red
}

# Call the WezTerm setup script
if (Test-Path $weztermScript) {
    Write-Host "Running WezTerm setup..." -ForegroundColor Cyan
    & $weztermScript
}
else {
    Write-Host "Error: WezTerm setup script not found at $weztermScript" -ForegroundColor Red
}

# Call the Starship setup script
if (Test-Path $starshipScript) {
    Write-Host "Running Starship setup..." -ForegroundColor Cyan
    & $starshipScript
}
else {
    Write-Host "Error: Starship setup script not found at $starshipScript" -ForegroundColor Red
}

# Call the VS Code setup script
if (Test-Path $vsCodeScript) {
    Write-Host "Running Visual Studio Code setup..." -ForegroundColor Cyan
    & $vsCodeScript
}
else {
    Write-Host "Error: Visual Studio Code setup script not found at $vsCodeScript" -ForegroundColor Red
}

# Call the Visual Studio setup script
if (Test-Path $visualStudioScript) {
    Write-Host "Running Visual Studio setup..." -ForegroundColor Cyan
    & $visualStudioScript
}
else {
    Write-Host "Error: Visual Studio setup script not found at $visualStudioScript" -ForegroundColor Red
}

# Call the Devtoys setup script
if (Test-Path $devtoysScript) {
    Write-Host "Running Devtoys setup..." -ForegroundColor Cyan
    & $devtoysScript
}
else {
    Write-Host "Error: Devtoys setup script not found at $devtoysScript" -ForegroundColor Red
}

# Call the Jetbrains Toolbox setup script
if (Test-Path $jetbrainsToolboxScript) {
    Write-Host "Running Jetbrains Toolbox setup..." -ForegroundColor Cyan
    & $jetbrainsToolboxScript
}
else {
    Write-Host "Error: Jetbrains Toolbox setup script not found at $jetbrainsToolboxScript" -ForegroundColor Red
}

# Call the Powershell symlinks setup script
if (Test-Path $powershellSymlinksScript) {
    Write-Host "Running Powershell symlinks setup..." -ForegroundColor Cyan
    & $powershellSymlinksScript
}
else {
    Write-Host "Error: Powershell symlinks setup script not found at $powershellSymlinksScript" -ForegroundColor Red
}

# Call the Podman setup script
if (Test-Path $podmanScript) {
    Write-Host "Running Podman setup..." -ForegroundColor Cyan
    & $podmanScript
}
else {
    Write-Host "Error: Podman setup script not found at $podmanScript" -ForegroundColor Red
}

Write-Host "Development setup completed!" -ForegroundColor Green
