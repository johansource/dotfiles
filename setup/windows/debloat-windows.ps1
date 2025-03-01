# debloat-windows.ps1
############################
# This script removes a bunch of preinstalled Windows bloat
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Windows debloat..." -ForegroundColor Green

# Function to remove built-in apps
function Remove-Bloatware {
  $bloatApps = @(
      "Microsoft.3DBuilder",
      "Microsoft.BingNews",
      "Microsoft.BingWeather",
      "Microsoft.Microsoft3DViewer",
      "Microsoft.MicrosoftOfficeHub",
      "Microsoft.MicrosoftSolitaireCollection",
      "Microsoft.MixedReality.Portal",
      "Microsoft.OneConnect",
      "Microsoft.People",
      "Microsoft.Print3D",
      "Microsoft.SkypeApp",
      "Microsoft.Todos",
      "Microsoft.Xbox.TCUI",
      "Microsoft.XboxApp",
      "Microsoft.XboxGameOverlay",
      "Microsoft.XboxGamingOverlay",
      "Microsoft.XboxSpeechToTextOverlay",
      "Microsoft.YourPhone",
      "Microsoft.ZuneMusic",
      "Microsoft.ZuneVideo"
  )

  foreach ($app in $bloatApps) {
      Get-AppxPackage -Name $app | Remove-AppxPackage
      Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$app*" | ForEach-Object {
          Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName
      }
  }
}

# Function to disable telemetry services
function Disable-Telemetry {
  Write-Host "Disabling Telemetry Services..."
  $telemetryServices = @(
      "DiagTrack",
      "dmwappushservice"
  )

  foreach ($service in $telemetryServices) {
      Get-Service -Name $service -ErrorAction SilentlyContinue | Stop-Service -Force
      Set-Service -Name $service -StartupType Disabled
  }
}

# Function to disable unnecessary scheduled tasks
function Disable-ScheduledTasks {
  Write-Host "Disabling Microsoft Scheduled Tasks..."
  $tasks = @(
      "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
      "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
      "\Microsoft\Windows\Autochk\Proxy",
      "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
      "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
      "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
      "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
  )

  foreach ($task in $tasks) {
      Get-ScheduledTask -TaskPath $task -ErrorAction SilentlyContinue | Disable-ScheduledTask
  }
}

# Function to clean up temporary files
function Remove-TemporaryFiles {
  Write-Host "Cleaning Temporary Files..."
  Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
  Remove-Item -Path "$env:TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue
  Write-Host "Temporary Files Cleaned!"
}

# Function to disable unnecessary Windows Features
function Disable-WindowsFeatures {
  Write-Host "Disabling Unnecessary Windows Features..."
  $features = @(
      "WindowsMediaPlayer",
      "WorkFolders-Client"
  )

  foreach ($feature in $features) {
      Disable-WindowsOptionalFeature -FeatureName $feature -Online -NoRestart -ErrorAction SilentlyContinue
  }
}

# Function to tweak privacy settings
function Set-PrivacySettings {
  Write-Host "Setting Privacy Tweaks..."
  $regPaths = @(
      "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection",
      "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"
  )

  # Create Registry Keys if not exist
  foreach ($path in $regPaths) {
      if (!(Test-Path $path)) {
          New-Item -Path $path -Force | Out-Null
      }
  }

  Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord
  Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value 0 -Type DWord
  Write-Host "Privacy Tweaks Applied!"
}

# Main execution
Write-Host "Starting Windows 11 Debloat Process..."

# Call debloat functions
Remove-Bloatware
Disable-Telemetry
Disable-ScheduledTasks
Remove-TemporaryFiles
Disable-WindowsFeatures
Set-PrivacySettings

Write-Host "Windows 11 Debloat completed!"
