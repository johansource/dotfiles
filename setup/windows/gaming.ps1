# gaming.ps1
############################
# Gaming tools and platforms setup script
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Starting gaming setup..." -ForegroundColor Green

# Define the path to the scripts using $PSScriptRoot
$steamScript = Join-Path $PSScriptRoot "gaming/steam.ps1"

# Call the Steam setup script
if (Test-Path $steamScript) {
    Write-Host "Running Steam setup..." -ForegroundColor Cyan
    & $steamScript
}
else {
    Write-Host "Error: Steam setup script not found at $steamScript" -ForegroundColor Red
}

Write-Host "Gaming setup completed!" -ForegroundColor Green
