# wezterm.ps1
############################
# WezTerm configuration for Windows dotfiles setup
############################

function Set-WezTermConfig {
    if (-not $script:ToolStatus.WezTerm) {
        Write-SetupResult -Status "SKIP" -Name "WezTerm Config" -Message "WezTerm is unavailable."
        return
    }

    $source = Join-Path $dotfilesRoot "wezterm\wezterm.lua"
    $target = Join-Path $env:USERPROFILE ".config\wezterm\wezterm.lua"

    New-SafeSymlink -Source $source -Target $target -Name "WezTerm Config"
}
