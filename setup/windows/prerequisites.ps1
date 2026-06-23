# prerequisites.ps1
############################
# Tool verification for Windows dotfiles setup
############################

function Test-Prerequisites {
    if ($PSVersionTable.PSVersion.Major -ge 7) {
        Write-SetupResult -Status "OK" -Name "PowerShell" -Message "Running PowerShell $($PSVersionTable.PSVersion)."
        $script:ToolStatus.PowerShell = $true
    }
    else {
        Write-SetupResult -Status "ERROR" -Name "PowerShell" -Message "PowerShell 7+ is required. Current version is $($PSVersionTable.PSVersion)."
        Write-Host "Install PowerShell 7 with:" -ForegroundColor Yellow
        Write-Host "  winget install --id Microsoft.PowerShell --source winget" -ForegroundColor Yellow
        Write-Host "Then open PowerShell 7 as Administrator and run this setup again." -ForegroundColor Yellow
        $script:ToolStatus.PowerShell = $false
    }

    if (Test-CommandAvailable -Command "pwsh") {
        Write-SetupResult -Status "OK" -Name "PowerShell CLI" -Message "Found at $(Get-CommandSource -Command "pwsh")."
        $script:ToolStatus.Pwsh = $true
    }
    else {
        Write-SetupResult -Status "WARN" -Name "PowerShell CLI" -Message "The pwsh command was not found in PATH."
        $script:ToolStatus.Pwsh = $false
    }

    if (Test-CommandAvailable -Command "git") {
        Write-SetupResult -Status "OK" -Name "Git" -Message "Found at $(Get-CommandSource -Command "git")."
        $script:ToolStatus.Git = $true
    }
    else {
        Write-SetupResult -Status "ERROR" -Name "Git" -Message "Git is required before running the dotfiles setup."
        $script:ToolStatus.Git = $false
    }

    if (Test-DirectoryExists -Path $dotfilesRoot) {
        Write-SetupResult -Status "OK" -Name "Dotfiles Root" -Message $dotfilesRoot
    }
    else {
        Write-SetupResult -Status "ERROR" -Name "Dotfiles Root" -Message "Directory not found: $dotfilesRoot"
    }

    if (Test-CommandAvailable -Command "code") {
        Write-SetupResult -Status "OK" -Name "Visual Studio Code" -Message "Found at $(Get-CommandSource -Command "code")."
        $script:ToolStatus.VSCode = $true
    }
    else {
        Write-SetupResult -Status "WARN" -Name "Visual Studio Code" -Message "The code command was not found. VS Code config will be skipped."
        $script:ToolStatus.VSCode = $false
    }

    if (Test-CommandAvailable -Command "wezterm") {
        Write-SetupResult -Status "OK" -Name "WezTerm" -Message "Found at $(Get-CommandSource -Command "wezterm")."
        $script:ToolStatus.WezTerm = $true
    }
    else {
        Write-SetupResult -Status "WARN" -Name "WezTerm" -Message "WezTerm was not found. WezTerm config will be skipped."
        $script:ToolStatus.WezTerm = $false
    }

    if (Test-CommandAvailable -Command "nvim") {
        Write-SetupResult -Status "OK" -Name "Neovim" -Message "Found at $(Get-CommandSource -Command "nvim")."
        $script:ToolStatus.Neovim = $true
    }
    else {
        Write-SetupResult -Status "WARN" -Name "Neovim" -Message "Neovim was not found. Neovim config will be skipped."
        $script:ToolStatus.Neovim = $false
    }

    if (Test-CommandAvailable -Command "starship") {
        Write-SetupResult -Status "OK" -Name "Starship" -Message "Found at $(Get-CommandSource -Command "starship")."
        $script:ToolStatus.Starship = $true
    }
    else {
        Write-SetupResult -Status "WARN" -Name "Starship" -Message "Starship was not found. Installation will be handled in a later step."
        $script:ToolStatus.Starship = $false
    }

    if (Test-CommandAvailable -Command "winget") {
        Write-SetupResult -Status "OK" -Name "Winget" -Message "Found at $(Get-CommandSource -Command "winget")."
        $script:ToolStatus.Winget = $true
    }
    else {
        Write-SetupResult -Status "WARN" -Name "Winget" -Message "Winget was not found. Script-managed installs may be skipped."
        $script:ToolStatus.Winget = $false
    }
}
