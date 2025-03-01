# visual-studio.ps1
############################
# This script installs Visual Studio
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Visual Studio setup..." -ForegroundColor Green

# Function to install Visual Studio 2022 Community with specific workloads using Winget
function Install-VisualStudio {
  Write-Host "Checking Visual Studio installation..." -ForegroundColor Cyan

  # Define the expected installation path
  $vsInstallerPath = "$env:ProgramFiles(x86)\Microsoft Visual Studio\Installer\vs_installer.exe"

  # Check if Visual Studio is already installed
  if (Test-Path $vsInstallerPath) {
      Write-Host "Visual Studio Installer is already installed. Checking for updates..." -ForegroundColor DarkYellow
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

# Call installation function
Install-VisualStudio

Write-Host "Visual Studio has been installed." -ForegroundColor Green