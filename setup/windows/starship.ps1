# starship.ps1
############################
# Starship configuration for Windows dotfiles setup
############################

function Install-OrVerifyStarship {
    if ($script:ToolStatus.Starship) {
        Write-SetupResult -Status "OK" -Name "Starship Install" -Message "Starship is already available."
        return
    }

    if (-not $script:ToolStatus.Winget) {
        Write-SetupResult -Status "WARN" -Name "Starship Install" -Message "Starship is missing and Winget is unavailable."
        return
    }

    & winget install --id Starship.Starship -e --source winget --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-SetupResult -Status "ERROR" -Name "Starship Install" -Message "Winget failed to install Starship."
        return
    }

    Update-SessionPath

    if (Test-CommandAvailable -Command "starship") {
        $script:ToolStatus.Starship = $true
        Write-SetupResult -Status "OK" -Name "Starship Install" -Message "Installed Starship successfully."
        return
    }

    $script:ToolStatus.Starship = $false
    Write-SetupResult -Status "WARN" -Name "Starship Install" -Message "Starship installed, but the command is not available in this session. Restart the terminal and run setup again."
}

function Set-StarshipConfig {
    if (-not $script:ToolStatus.Starship) {
        Write-SetupResult -Status "SKIP" -Name "Starship Config" -Message "Starship is unavailable."
        return
    }

    $source = Join-Path $dotfilesRoot "starship\starship.toml"
    $target = Join-Path $env:USERPROFILE ".config\starship.toml"

    New-SafeSymlink -Source $source -Target $target -Name "Starship Config"
}
