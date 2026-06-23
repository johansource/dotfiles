# vs-code.ps1
############################
# Visual Studio Code configuration for Windows dotfiles setup
############################

function Install-VSCodeExtensions {
    if (-not $script:ToolStatus.VSCode) {
        Write-SetupResult -Status "SKIP" -Name "VS Code Extensions" -Message "VS Code CLI is unavailable."
        return
    }

    $extensionsFile = Join-Path $dotfilesRoot "vscode\extensions.txt"
    if (-not (Test-FileExists -Path $extensionsFile)) {
        Write-SetupResult -Status "ERROR" -Name "VS Code Extensions" -Message "Extensions file not found: $extensionsFile"
        return
    }

    $installedExtensions = @(& code --list-extensions)
    if ($LASTEXITCODE -ne 0) {
        Write-SetupResult -Status "ERROR" -Name "VS Code Extensions" -Message "Failed to list installed VS Code extensions."
        return
    }

    $installed = 0
    $alreadyInstalled = 0
    $failed = @()

    Get-Content $extensionsFile | ForEach-Object {
        $extension = $_.Trim()
        if (-not $extension -or $extension.StartsWith("#")) {
            return
        }

        if ($installedExtensions -contains $extension) {
            $alreadyInstalled += 1
            return
        }

        & code --install-extension $extension | Out-Null
        if ($LASTEXITCODE -eq 0) {
            $installed += 1
        }
        else {
            $failed += $extension
        }
    }

    $message = "Installed $installed, already present $alreadyInstalled."
    if ($failed.Count -gt 0) {
        Write-SetupResult -Status "WARN" -Name "VS Code Extensions" -Message "$message Failed: $($failed -join ', ')"
        return
    }

    Write-SetupResult -Status "OK" -Name "VS Code Extensions" -Message $message
}

function Set-VSCodeConfig {
    if (-not $script:ToolStatus.VSCode) {
        Write-SetupResult -Status "SKIP" -Name "Visual Studio Code Config" -Message "VS Code CLI is unavailable."
        return
    }

    Install-VSCodeExtensions

    $sourceDirectory = Join-Path $dotfilesRoot "vscode\User"
    $targetDirectory = Join-Path $env:APPDATA "Code\User"

    $configFiles = @(
        @{
            Name     = "VS Code Settings"
            FileName = "settings.json"
            Required = $true
        },
        @{
            Name     = "VS Code Keybindings"
            FileName = "keybindings.json"
            Required = $false
        }
    )

    foreach ($configFile in $configFiles) {
        $source = Join-Path $sourceDirectory $configFile.FileName
        $target = Join-Path $targetDirectory $configFile.FileName

        if (-not (Test-FileExists -Path $source)) {
            if ($configFile.Required) {
                Write-SetupResult -Status "ERROR" -Name $configFile.Name -Message "Source file not found: $source"
            }
            else {
                Write-SetupResult -Status "SKIP" -Name $configFile.Name -Message "Source file not tracked, skipping."
            }

            continue
        }

        New-SafeSymlink -Source $source -Target $target -Name $configFile.Name
    }
}
