# fonts.ps1
############################
# Font setup for Windows dotfiles setup
############################

function Test-FontInstalled {
    param (
        [Parameter(Mandatory = $true)]
        [string]$NamePattern
    )

    $fontRegistryPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts",
        "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    )

    foreach ($fontRegistryPath in $fontRegistryPaths) {
        if (-not (Test-Path -LiteralPath $fontRegistryPath)) {
            continue
        }

        $fontEntries = Get-ItemProperty -LiteralPath $fontRegistryPath
        $matchingFont = $fontEntries.PSObject.Properties |
        Where-Object { $_.Name -like $NamePattern -or [string]$_.Value -like $NamePattern } |
        Select-Object -First 1

        if ($matchingFont) {
            return $true
        }
    }

    return $false
}

function Install-FontArchive {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Url,

        [Parameter(Mandatory = $true)]
        [string]$NamePattern
    )

    if (Test-FontInstalled -NamePattern $NamePattern) {
        Write-SetupResult -Status "OK" -Name $Name -Message "Font is already installed."
        return
    }

    $tempDirectory = Join-Path ([System.IO.Path]::GetTempPath()) "dotfiles-fonts-$([Guid]::NewGuid())"
    $archivePath = Join-Path $tempDirectory "$Name.zip"
    $extractPath = Join-Path $tempDirectory "extract"

    try {
        New-DirectoryIfMissing -Path $tempDirectory
        New-DirectoryIfMissing -Path $extractPath

        Invoke-WebRequest -Uri $Url -OutFile $archivePath -ErrorAction Stop
        Expand-Archive -Path $archivePath -DestinationPath $extractPath -Force

        $fontFiles = @(Get-ChildItem -Path $extractPath -Recurse -Include *.ttf, *.otf)
        if ($fontFiles.Count -eq 0) {
            Write-SetupResult -Status "ERROR" -Name $Name -Message "No font files found in downloaded archive."
            return
        }

        $fontsShellFolder = (New-Object -ComObject Shell.Application).Namespace(0x14)
        foreach ($fontFile in $fontFiles) {
            $fontsShellFolder.CopyHere($fontFile.FullName)
        }

        if (Test-FontInstalled -NamePattern $NamePattern) {
            Write-SetupResult -Status "OK" -Name $Name -Message "Installed $($fontFiles.Count) font file(s)."
        }
        else {
            Write-SetupResult -Status "WARN" -Name $Name -Message "Font files were copied, but installation could not be verified until Windows refreshes fonts."
        }
    }
    catch {
        Write-SetupResult -Status "ERROR" -Name $Name -Message $_.Exception.Message
    }
    finally {
        if (Test-Path -LiteralPath $tempDirectory) {
            Remove-Item -LiteralPath $tempDirectory -Recurse -Force
        }
    }
}

function Install-OrVerifyFonts {
    Install-FontArchive `
        -Name "JetBrains Mono Nerd Font" `
        -Url "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" `
        -NamePattern "*JetBrainsMono*Nerd*Font*"
}
