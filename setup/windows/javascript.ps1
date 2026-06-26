# javascript.ps1
############################
# Optional JavaScript tooling for Windows dotfiles setup
############################

function Add-UserPathEntry {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [switch]$Prepend
    )

    $normalizedPath = [System.IO.Path]::GetFullPath($Path).TrimEnd("\")
    $userPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
    $pathEntries = @($userPath -split ";" | Where-Object {
            $_ -and ([System.IO.Path]::GetFullPath($_).TrimEnd("\") -ine $normalizedPath)
        })

    if ($Prepend) {
        $pathEntries = @($normalizedPath) + $pathEntries
    }
    else {
        $pathEntries += $normalizedPath
    }

    [Environment]::SetEnvironmentVariable("Path", ($pathEntries -join ";"), [EnvironmentVariableTarget]::User)

    $sessionPathEntries = @($env:Path -split ";" | Where-Object { $_ })
    $sessionPathEntries = @($sessionPathEntries | Where-Object {
            [System.IO.Path]::GetFullPath($_).TrimEnd("\") -ine $normalizedPath
        })

    if ($Prepend) {
        $env:Path = (@($normalizedPath) + $sessionPathEntries) -join ";"
    }
    else {
        $env:Path = ($sessionPathEntries + @($normalizedPath)) -join ";"
    }
}

function Invoke-JavaScriptCommand {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [scriptblock]$Command
    )

    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw "$Name failed with exit code $LASTEXITCODE."
    }
}

function Install-OrVerifyPnpm {
    if (Test-CommandAvailable -Command "pnpm") {
        Write-SetupResult -Status "OK" -Name "pnpm" -Message "Found at $(Get-CommandSource -Command "pnpm")."
        return
    }

    if (-not $script:ToolStatus.Winget) {
        Write-SetupResult -Status "ERROR" -Name "pnpm" -Message "pnpm is missing and Winget is unavailable. Install with: winget install -e --id pnpm.pnpm"
        return
    }

    Write-SetupResult -Status "WARN" -Name "pnpm" -Message "pnpm was not found. Installing with Winget..."
    Invoke-JavaScriptCommand -Name "pnpm install" -Command {
        winget install -e --id pnpm.pnpm --source winget --accept-source-agreements --accept-package-agreements
    }

    Update-SessionPath

    if (Test-CommandAvailable -Command "pnpm") {
        Write-SetupResult -Status "OK" -Name "pnpm" -Message "Installed at $(Get-CommandSource -Command "pnpm")."
    }
    else {
        Write-SetupResult -Status "WARN" -Name "pnpm" -Message "pnpm was installed, but is not available in this session yet. Restart the terminal and rerun with -Js."
    }
}

function Set-PnpmEnvironment {
    $pnpmHome = Join-Path $env:LOCALAPPDATA "pnpm"
    $pnpmBin = Join-Path $pnpmHome "bin"

    New-DirectoryIfMissing -Path $pnpmHome
    New-DirectoryIfMissing -Path $pnpmBin

    $currentPnpmHome = [Environment]::GetEnvironmentVariable("PNPM_HOME", [EnvironmentVariableTarget]::User)
    if ($currentPnpmHome -ne $pnpmHome) {
        [Environment]::SetEnvironmentVariable("PNPM_HOME", $pnpmHome, [EnvironmentVariableTarget]::User)
    }

    $env:PNPM_HOME = $pnpmHome
    Add-UserPathEntry -Path $pnpmHome -Prepend
    Add-UserPathEntry -Path $pnpmBin -Prepend

    Write-SetupResult -Status "OK" -Name "pnpm Environment" -Message "PNPM_HOME is $pnpmHome."
}

function Update-Pnpm {
    if (-not (Test-CommandAvailable -Command "pnpm")) {
        Write-SetupResult -Status "SKIP" -Name "pnpm Update" -Message "pnpm is unavailable in this session."
        return
    }

    Invoke-JavaScriptCommand -Name "pnpm self-update" -Command {
        pnpm self-update
    }

    Update-SessionPath
    Add-UserPathEntry -Path $env:PNPM_HOME -Prepend
    Add-UserPathEntry -Path (Join-Path $env:PNPM_HOME "bin") -Prepend

    $pnpmVersion = (& pnpm --version)
    Write-SetupResult -Status "OK" -Name "pnpm Update" -Message "Using pnpm $pnpmVersion from $(Get-CommandSource -Command "pnpm")."
}

function Set-PnpmGlobalBin {
    if (-not (Test-CommandAvailable -Command "pnpm")) {
        Write-SetupResult -Status "SKIP" -Name "pnpm Global Bin" -Message "pnpm is unavailable in this session."
        return
    }

    $globalBin = Join-Path $env:PNPM_HOME "bin"
    Invoke-JavaScriptCommand -Name "pnpm global-bin-dir" -Command {
        pnpm config set global-bin-dir $globalBin
    }

    Write-SetupResult -Status "OK" -Name "pnpm Global Bin" -Message "Global binaries will be installed to $globalBin."
}

function Install-OrVerifyNodeRuntime {
    if (-not (Test-CommandAvailable -Command "pnpm")) {
        Write-SetupResult -Status "SKIP" -Name "Node.js Runtime" -Message "pnpm is unavailable in this session."
        return
    }

    $expectedNodePath = Join-Path $env:PNPM_HOME "bin\node.exe"
    if (Test-FileExists -Path $expectedNodePath) {
        $nodeVersion = (& $expectedNodePath --version)
        Write-SetupResult -Status "OK" -Name "Node.js Runtime" -Message "Running $nodeVersion from $expectedNodePath."
        return
    }

    Invoke-JavaScriptCommand -Name "Node.js LTS runtime" -Command {
        pnpm runtime set node lts -g
    }

    Update-SessionPath
    Add-UserPathEntry -Path $env:PNPM_HOME -Prepend
    Add-UserPathEntry -Path (Join-Path $env:PNPM_HOME "bin") -Prepend

    if (Test-CommandAvailable -Command "node") {
        $nodeVersion = (& node --version)
        Write-SetupResult -Status "OK" -Name "Node.js Runtime" -Message "Running $nodeVersion from $(Get-CommandSource -Command "node")."
    }
    else {
        Write-SetupResult -Status "WARN" -Name "Node.js Runtime" -Message "Node.js LTS was installed, but node is not available in this session yet. Restart the terminal and rerun with -Js."
    }
}

function Install-OrVerifyJavaScriptToolchain {
    Install-OrVerifyPnpm
    Set-PnpmEnvironment
    Update-Pnpm
    Set-PnpmGlobalBin
    Install-OrVerifyNodeRuntime
}
