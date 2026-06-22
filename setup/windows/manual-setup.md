# Manual Windows Setup

Windows setup is manual-first. Install the tools below manually, then use the dotfiles setup script for configuration that belongs in this repository.

Complete this checklist before running `setup/windows.ps1`.

The dotfiles script should manage configuration for:

- Git
- Neovim
- WezTerm
- Starship
- PowerShell
- Visual Studio Code

The checklist below is intentionally separate from the dotfiles script so tool installation stays visible and easy to change.

## Required Tools

- [ ] Install Git.
- [ ] Clone this repository to `C:\Projects\dotfiles`.
- [ ] Install PowerShell 7.
- [ ] Allow local setup scripts for the current user.

```ps1
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

## Terminal And Shell

- [ ] Install WezTerm.
- [ ] Install Starship, or leave it for `setup/windows.ps1` if the script handles installation later.
- [ ] Install JetBrains Mono Nerd Font, or leave it for `setup/windows.ps1` if the script handles installation later.
- [ ] Open PowerShell 7 once to let it create its profile directories.
- [ ] Install Visual Studio Code.
  - [ ] Confirm the `code` command is available in a new terminal.
- [ ] Install Neovim.

## Before Running The Script

- [ ] Restart the terminal after installing tools that update `PATH`.
- [ ] Confirm PowerShell is running as Administrator.
- [ ] Confirm this checklist is complete enough for this machine.
- [ ] Run the dotfiles setup script from the `setup` directory.

```ps1
.\windows.ps1
```
