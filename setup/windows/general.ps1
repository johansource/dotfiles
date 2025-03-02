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

# Define the path to the scripts using $PSScriptRoot
$gitScript = Join-Path $PSScriptRoot "general/git.ps1"
$protonPassScript = Join-Path $PSScriptRoot "general/proton-pass.ps1"
$protonDriveScript = Join-Path $PSScriptRoot "general/proton-drive.ps1"
$protonVpnScript = Join-Path $PSScriptRoot "general/proton-vpn.ps1"
$arcScript = Join-Path $PSScriptRoot "general/arc.ps1"
$spotifyScript = Join-Path $PSScriptRoot "general/spotify.ps1"
$discordScript = Join-Path $PSScriptRoot "general/discord.ps1"
$obsidianScript = Join-Path $PSScriptRoot "general/obsidian.ps1"
$notionScript = Join-Path $PSScriptRoot "general/notion.ps1"
$vlcScript = Join-Path $PSScriptRoot "general/vlc.ps1"
$obsScript = Join-Path $PSScriptRoot "general/obs.ps1"
$logitechGHubScript = Join-Path $PSScriptRoot "general/logitech-g-hub.ps1"
$elgatoWaveLinkScript = Join-Path $PSScriptRoot "general/elgato-wave-link.ps1"

# Call the Git setup script
if (Test-Path $gitScript) {
    Write-Host "Running Git setup..." -ForegroundColor Cyan
    & $gitScript
}
else {
    Write-Host "Error: Git setup script not found at $gitScript" -ForegroundColor Red
}

# Call the Proton Pass setup script
if (Test-Path $protonPassScript) {
    Write-Host "Running Proton Pass setup..." -ForegroundColor Cyan
    & $protonPassScript
}
else {
    Write-Host "Error: Proton Pass setup script not found at $protonPassScript" -ForegroundColor Red
}

# Call the Proton Drive setup script
if (Test-Path $protonDriveScript) {
    Write-Host "Running Proton Drive setup..." -ForegroundColor Cyan
    & $protonDriveScript
}
else {
    Write-Host "Error: Proton Drive setup script not found at $protonDriveScript" -ForegroundColor Red
}

# Call the Proton VPN setup script
if (Test-Path $protonVpnScript) {
    Write-Host "Running Proton VPN setup..." -ForegroundColor Cyan
    & $protonVpnScript
}
else {
    Write-Host "Error: Proton VPN setup script not found at $protonVpnScript" -ForegroundColor Red
}

# Call the Arc setup script
if (Test-Path $arcScript) {
    Write-Host "Running Arc setup..." -ForegroundColor Cyan
    & $arcScript
}
else {
    Write-Host "Error: Arc setup script not found at $arcScript" -ForegroundColor Red
}

# Call the Spotify setup script
if (Test-Path $spotifyScript) {
    Write-Host "Running Spotify setup..." -ForegroundColor Cyan
    & $spotifyScript
}
else {
    Write-Host "Error: Spotify setup script not found at $spotifyScript" -ForegroundColor Red
}

# Call the Obsidian setup script
if (Test-Path $obsidianScript) {
    Write-Host "Running Obsidian setup..." -ForegroundColor Cyan
    & $obsidianScript
}
else {
    Write-Host "Error: Obsidian setup script not found at $obsidianScript" -ForegroundColor Red
}

# Call the Discord setup script
if (Test-Path $discordScript) {
    Write-Host "Running Discord setup..." -ForegroundColor Cyan
    & $discordScript
}
else {
    Write-Host "Error: Discord setup script not found at $discordScript" -ForegroundColor Red
}

# Call the Notion setup script
if (Test-Path $notionScript) {
    Write-Host "Running Notion setup..." -ForegroundColor Cyan
    & $notionScript
}
else {
    Write-Host "Error: Notion setup script not found at $notionScript" -ForegroundColor Red
}

# Call the VLC setup script
if (Test-Path $vlcScript) {
    Write-Host "Running VLC setup..." -ForegroundColor Cyan
    & $vlcScript
}
else {
    Write-Host "Error: VLC setup script not found at $vlcScript" -ForegroundColor Red
}

# Call the OBS setup script
if (Test-Path $obsScript) {
    Write-Host "Running OBS setup..." -ForegroundColor Cyan
    & $obsScript
}
else {
    Write-Host "Error: OBS setup script not found at $obsScript" -ForegroundColor Red
}

# Call the Logitech G Hub setup script
if (Test-Path $logitechGHubScript) {
    Write-Host "Running Logitech G Hub setup..." -ForegroundColor Cyan
    & $logitechGHubScript
}
else {
    Write-Host "Error: Logitech G Hub setup script not found at $logitechGHubScript" -ForegroundColor Red
}

# Call the Elgato Wave Link setup script
if (Test-Path $elgatoWaveLinkScript) {
    Write-Host "Running Elgato Wave Link setup..." -ForegroundColor Cyan
    & $elgatoWaveLinkScript
}
else {
    Write-Host "Error: Elgato Wave Link setup script not found at $elgatoWaveLinkScript" -ForegroundColor Red
}

Write-Host "General setup completed!" -ForegroundColor Green
