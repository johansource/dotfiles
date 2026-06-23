# powershell.ps1
############################
# PowerShell profile configuration for Windows dotfiles setup
############################

function Set-PowerShellProfile {
    if (-not $script:ToolStatus.PowerShell) {
        Write-SetupResult -Status "SKIP" -Name "PowerShell Profile" -Message "PowerShell 7+ is unavailable."
        return
    }

    $source = Join-Path $dotfilesRoot "windowspowershell\Microsoft.PowerShell_profile.ps1"
    $documentsPath = [Environment]::GetFolderPath("MyDocuments")

    $profiles = @(
        @{
            Name   = "PowerShell 7 Profile"
            Target = Join-Path $documentsPath "PowerShell\Microsoft.PowerShell_profile.ps1"
        },
        @{
            Name   = "Windows PowerShell Profile"
            Target = Join-Path $documentsPath "WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
        }
    )

    foreach ($profileLink in $profiles) {
        New-SafeSymlink -Source $source -Target $profileLink.Target -Name $profileLink.Name
    }
}
