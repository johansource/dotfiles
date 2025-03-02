# debloat-windows.ps1
############################
# This script removes a bunch of preinstalled Windows bloat
############################

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Host "Please run this script as Administrator." -ForegroundColor Red
  exit 1
}

Write-Host "Starting Windows debloat..." -ForegroundColor Cyan

# Function to remove built-in apps
function Remove-Bloatware {
  Write-Host "Removing bloatware..." -ForegroundColor Cyan

  $bloatApps = @(
    "Clipchamp.Clipchamp"
    "Microsoft.3DBuilder",
    "Microsoft.Bing",
    "Microsoft.BingNews",
    "Microsoft.BingSearch",
    "Microsoft.BingWeather",
    "Microsoft.Copilot",
    "Microsoft.Family",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MixedReality.Portal",
    "Microsoft.Office.Desktop",
    "Microsoft.Office",
    "Microsoft.OneConnect",
    "Microsoft.OneDrive",
    "Microsoft.People",
    "Microsoft.PowerAutomateDesktop",
    "Microsoft.Print3D",
    "Microsoft.SkypeApp",
    "Microsoft.Teams",
    "Microsoft.Todos",
    "Microsoft.WindowsCamera",
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
    Get-AppxPackage -AllUsers -Name $app | Remove-AppxPackage
    Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -match $app } | Remove-AppxProvisionedPackage -Online
  }

  Write-Host "Bloatware removed!" -ForegroundColor Green
}

# Function to uninstall Teams via Winget
function Remove-TeamsWinget {
  Write-Host "Uninstalling Microsoft Teams via Winget..." -ForegroundColor Cyan
  winget uninstall --id Microsoft.Teams -e --silent --force
}

# Function to disable telemetry services
function Disable-Telemetry {
  Write-Host "Disabling telemetry services..." -ForegroundColor Cyan

  $telemetryServices = @(
    "DiagTrack",
    "dmwappushservice"
  )

  foreach ($service in $telemetryServices) {
    Get-Service -Name $service -ErrorAction SilentlyContinue | Stop-Service -Force
    Set-Service -Name $service -StartupType Disabled
  }

  Write-Host "Telemetry services disabled!" -ForegroundColor Green
}

# Function to disable unnecessary scheduled tasks
function Disable-ScheduledTasks {
  Write-Host "Disabling Microsoft scheduled tasks..." -ForegroundColor Cyan

  $tasks = @(
    "\\Microsoft\\Windows\\Application Experience\\Microsoft Compatibility Appraiser",
    "\\Microsoft\\Windows\\Application Experience\\ProgramDataUpdater",
    "\\Microsoft\\Windows\\Autochk\\Proxy",
    "\\Microsoft\\Windows\\Customer Experience Improvement Program\\Consolidator",
    "\\Microsoft\\Windows\\Customer Experience Improvement Program\\UsbCeip",
    "\\Microsoft\\Windows\\DiskDiagnostic\\Microsoft-Windows-DiskDiagnosticDataCollector",
    "\\Microsoft\\Windows\\Windows Error Reporting\\QueueReporting"
  )

  foreach ($task in $tasks) {
    $foundTask = Get-ScheduledTask | Where-Object { $_.TaskPath -match $task }
    if ($foundTask) {
      Disable-ScheduledTask -TaskName $foundTask.TaskName
      Write-Host "Disabled Task: $($foundTask.TaskName)" -ForegroundColor Green
    }
    else {
      Write-Host "Task not found: $task" -ForegroundColor DarkYellow
    }
  }

  Write-Host "Microsoft scheduled tasks disabled!" -ForegroundColor Green
}

# Function to clean up temporary files
function Remove-TemporaryFiles {
  Write-Host "Cleaning temporary files..." -ForegroundColor Cyan

  Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -ErrorAction Ignore
  Remove-Item -Path "$env:TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue

  Write-Host "Temporary files cleaned!" -ForegroundColor Green
}

# Function to disable unnecessary Windows Features
function Disable-WindowsFeatures {
  Write-Host "Disabling Unnecessary Windows features..." -ForegroundColor Cyan

  $features = @(
    "WindowsMediaPlayer",
    "WorkFolders-Client"
  )

  foreach ($feature in $features) {
    Disable-WindowsOptionalFeature -FeatureName $feature -Online -NoRestart -ErrorAction SilentlyContinue
  }
  
  Write-Host "Unneccesary Windows features disabled!" -ForegroundColor Green
}

# Function to tweak privacy settings
function Set-PrivacySettings {
  Write-Host "Setting privacy tweaks..." -ForegroundColor Cyan

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
  
  Write-Host "Privacy tweaks applied!"  -ForegroundColor Green
}

# Main execution
Write-Host "Starting Windows 11 debloat process..." -ForegroundColor Cyan

# Call debloat functions
Remove-Bloatware
Disable-Telemetry
Disable-ScheduledTasks
Remove-TemporaryFiles
Disable-WindowsFeatures
Set-PrivacySettings

Write-Host "Windows 11 Debloat completed!" -ForegroundColor Green
