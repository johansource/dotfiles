# python.ps1
############################
# Optional Python tooling for Windows dotfiles setup
############################

function Invoke-PythonCommand {
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

function Install-OrVerifyUv {
    if (Test-CommandAvailable -Command "uv") {
        $uvVersion = (& uv --version)
        Write-SetupResult -Status "OK" -Name "uv" -Message "$uvVersion found at $(Get-CommandSource -Command "uv")."
        return
    }

    if (-not $script:ToolStatus.Winget) {
        Write-SetupResult -Status "ERROR" -Name "uv" -Message "uv is missing and Winget is unavailable. Install with: winget install --id astral-sh.uv -e"
        return
    }

    Write-SetupResult -Status "WARN" -Name "uv" -Message "uv was not found. Installing with Winget..."
    Invoke-PythonCommand -Name "uv install" -Command {
        winget install --id astral-sh.uv -e --source winget --accept-source-agreements --accept-package-agreements
    }

    Update-SessionPath

    if (Test-CommandAvailable -Command "uv") {
        $uvVersion = (& uv --version)
        Write-SetupResult -Status "OK" -Name "uv" -Message "$uvVersion installed at $(Get-CommandSource -Command "uv")."
    }
    else {
        Write-SetupResult -Status "WARN" -Name "uv" -Message "uv was installed, but is not available in this session yet. Restart the terminal and rerun with -Python."
    }
}

function Install-OrVerifyManagedPython {
    if (-not (Test-CommandAvailable -Command "uv")) {
        Write-SetupResult -Status "SKIP" -Name "Python Runtime" -Message "uv is unavailable in this session."
        return
    }

    Invoke-PythonCommand -Name "uv python install" -Command {
        uv python install --default --preview-features python-install-default
    }

    $pythonPath = (& uv python find)
    if ($LASTEXITCODE -ne 0 -or -not $pythonPath) {
        Write-SetupResult -Status "WARN" -Name "Python Runtime" -Message "uv completed, but no Python runtime was found."
        return
    }

    if (Test-CommandAvailable -Command "python") {
        $pythonVersion = (& python --version)
        Write-SetupResult -Status "OK" -Name "Python Runtime" -Message "$pythonVersion found at $(Get-CommandSource -Command "python")."
        return
    }

    $pythonVersion = (& $pythonPath --version)
    Write-SetupResult -Status "WARN" -Name "Python Runtime" -Message "$pythonVersion is installed at $pythonPath, but python is not available on PATH yet. Restart the terminal and rerun with -Python."
}

function Set-UvToolEnvironment {
    if (-not (Test-CommandAvailable -Command "uv")) {
        Write-SetupResult -Status "SKIP" -Name "uv Tool Path" -Message "uv is unavailable in this session."
        return
    }

    $toolBinPath = (& uv tool dir --bin)
    if ($LASTEXITCODE -ne 0 -or -not $toolBinPath) {
        Write-SetupResult -Status "WARN" -Name "uv Tool Path" -Message "Could not determine uv tool executable directory."
        return
    }

    New-DirectoryIfMissing -Path $toolBinPath
    Add-UserPathEntry -Path $toolBinPath -Prepend

    if (Test-CommandAvailable -Command "uvx") {
        Write-SetupResult -Status "OK" -Name "uv Tool Path" -Message "Tool executables will be available from $toolBinPath."
    }
    else {
        Write-SetupResult -Status "WARN" -Name "uv Tool Path" -Message "Added $toolBinPath to PATH, but uvx is not available in this session yet."
    }
}

function Test-TkinterSupport {
    if (-not (Test-CommandAvailable -Command "uv")) {
        Write-SetupResult -Status "SKIP" -Name "Tkinter" -Message "uv is unavailable in this session."
        return
    }

    $tkVersion = (& uv run --no-project python -c "import tkinter; print(tkinter.TkVersion)" 2>$null)
    if ($LASTEXITCODE -eq 0 -and $tkVersion) {
        Write-SetupResult -Status "OK" -Name "Tkinter" -Message "Tcl/Tk $tkVersion is available."
        return
    }

    Write-SetupResult -Status "WARN" -Name "Tkinter" -Message "Tkinter is unavailable for the uv-managed Python. Install official Python separately if Tk GUI support is needed."
}

function Install-OrVerifyPythonToolchain {
    Install-OrVerifyUv
    Set-UvToolEnvironment
    Install-OrVerifyManagedPython
    Test-TkinterSupport
}
