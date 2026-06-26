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

It can also install or verify a few dotfiles-adjacent dependencies:

- JetBrains Mono Nerd Font
- Starship, via Winget if missing
- Pnpm and Node.js LTS, when the setup script is run with `-Js`
- uv and Python, when the setup script is run with `-Python`

The checklist below is intentionally separate from the dotfiles script so tool installation stays visible and easy to change.

## Required Tools

- [ ] Install Git.
- [ ] Clone this repository to `C:\Projects\dotfiles`.
- [ ] Install PowerShell 7.

  ```ps1
  winget install --id Microsoft.PowerShell --source winget
  ```

- [ ] Allow local setup scripts for the current user.

```ps1
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

## Terminal And Shell

- [ ] Install WezTerm.
- [ ] Open PowerShell 7 once to let it create its profile directories.
- [ ] Install Visual Studio Code.
  - [ ] Confirm the `code` command is available in a new terminal.
- [ ] Install Neovim.

## Script-Managed Dependencies

- [ ] Leave Starship for `setup/windows.ps1`, or install it manually first if preferred.
- [ ] Leave JetBrains Mono Nerd Font for `setup/windows.ps1`, or install it manually first if preferred.

## Before Running The Script

- [ ] Restart the terminal after installing tools that update `PATH`.
- [ ] Confirm PowerShell is running as Administrator.
- [ ] Confirm this checklist is complete enough for this machine.
- [ ] Run the dotfiles setup script from the `setup` directory.

```ps1
.\windows.ps1
```

To include the optional JavaScript toolchain setup:

```ps1
.\windows.ps1 -Js
```

To include the optional Python toolchain setup:

```ps1
.\windows.ps1 -Python
```

After the checklist has already been completed once, the confirmation prompt can be skipped:

```ps1
.\windows.ps1 -SkipManualCheck
```
