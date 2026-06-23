# neovim.ps1
############################
# Neovim configuration for Windows dotfiles setup
############################

function Set-NeovimConfig {
    if (-not $script:ToolStatus.Neovim) {
        Write-SetupResult -Status "SKIP" -Name "Neovim Config" -Message "Neovim is unavailable."
        return
    }

    $source = Join-Path $dotfilesRoot "nvim\init.lua"
    $target = Join-Path $env:LOCALAPPDATA "nvim\init.lua"

    New-SafeSymlink -Source $source -Target $target -Name "Neovim Config"
}
