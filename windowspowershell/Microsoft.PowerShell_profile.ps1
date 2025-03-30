# Initialise Starship with PowerShell
Invoke-Expression (&starship init powershell)

# Set default directory only if starting in $HOME
if ($PWD.Path -eq $HOME) {
  Set-Location C:\Projects
}
