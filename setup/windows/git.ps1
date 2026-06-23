# git.ps1
############################
# Git configuration for Windows dotfiles setup
############################

function Set-GitConfig {
    if (-not $script:ToolStatus.Git) {
        Write-SetupResult -Status "SKIP" -Name "Git Config" -Message "Git is unavailable."
        return
    }

    $source = Join-Path $dotfilesRoot "git\.gitconfig"
    $target = Join-Path $env:USERPROFILE ".gitconfig"

    New-SafeSymlink -Source $source -Target $target -Name "Git Config"
}
