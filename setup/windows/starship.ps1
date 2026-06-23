# starship.ps1
############################
# Starship configuration for Windows dotfiles setup
############################

function Install-OrVerifyStarship {
    if ($script:ToolStatus.Starship) {
        Write-SetupResult -Status "OK" -Name "Starship Install" -Message "Starship is already available."
        return
    }

    if ($script:ToolStatus.Winget) {
        Write-SetupResult -Status "SKIP" -Name "Starship Install" -Message "TODO: Install Starship with Winget."
        return
    }

    Write-SetupResult -Status "WARN" -Name "Starship Install" -Message "Starship is missing and Winget is unavailable."
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
