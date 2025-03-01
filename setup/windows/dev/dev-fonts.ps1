# dev-fonts.ps1
############################
# This script installs a few fonts
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting fonts setup..." -ForegroundColor Green

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
      }
      #},
      #@{
          #Name = "Source Code Pro";
          #Url = "https://github.com/adobe-fonts/source-code-pro/releases/latest/download/TTF-source-code-pro.zip";
      #}
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

# Call installation function
Install-Fonts

Write-Host "Dev fonts have been installed." -ForegroundColor Green
