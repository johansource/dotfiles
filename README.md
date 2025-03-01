# Dotfiles

This repository was created to mostly automate setting up a desired environment on a fresh machine.

## Table of Contents

1. [Getting started](#getting-started)
2. [MacOS](#macos)
3. [Windows](#windows)
4. [Post-Setup Notes](#post-setup-notes)

## <a name="getting-started"></a> Getting Started

This repository helps you quickly set up a new development environment by:

- Installing essential tools and software
- Configuring applications with customized settings
- Creating symlinks for dotfiles to maintain consistency across machines.

## <a name="macos"></a> MacOS

This setup will:

- Install essential tools using Homebrew (e.g., Git, Node.js, Python, etc.).
- Configure Visual Studio Code:
  - Install extensions.
  - Symlink settings.
- Set up Pnpm and install the latest LTS version of Node.js.
- Create symlinks for dotfiles:
  - `.zshrc`
  - `.gitconfig`
  - VS Code `settings.json` and `keybindings.json` (if applicable).

### Setup

1. Clone (or manually dowload pre-Git) the repository to your desired local directory:
   ```sh
   git clone https://github.com/johansource/dotfiles.git ~/Projects/dotfiles
   ```
2. Navigate to the `dotfiles/setup` directory:
   ```sh
   cd ~/Projects/dotfiles/setup
   ```
3. Run the setup script for MacOS:
   ```sh
   zsh ./macos.sh
   ```

## <a name="windows"></a> Windows

This setup will:

- Install essential tools and software:
  - Git (always installed via `general.ps1`).
  - Developer tools (optional, via `-Dev`):
    - Visual Studio Code (including extensions and configuration).
    - Visual Studio.
    - Neovim.
    - WezTerm (with configuration).
    - Starship (with configuration).
    - DevToys.
    - Installs fonts.
    - Symlinks configuration files:
      - `wezterm.lua`
      - `starship.toml`
      - `Microsoft.PowerShell_profile.ps1`
  - Gaming tools (optional, via `-Gaming`):
    - Steam.
  - Game development tools (optional, via `-GameDev`):
    - Unity Hub.
    - Unreal Engine (via Epic Games Launcher).
    - Blender.
  - Python environment (optional, via `-Python`):
    - Python.
    - Pyenv.
    - Poetry.
    - Tcl-Tk for GUI programming.
  - Node.js environment (optional, via `-NodeJs`):
    - Installs Pnpm.
    - Installs Node.js via Pnpm.

- Create symbolic links for configuration files:
  - `.gitconfig` (always symlinked via `general.ps1`).
  - `wezterm.lua`, `starship.toml`, and `Microsoft.PowerShell_profile.ps1` (symlinked via `-Dev`).
  - VS Code settings (`settings.json`) and optionally `keybindings.json` (symlinked via `-Dev`).

- Automate installation using Winget and PowerShell scripts for simplicity and reproducibility.

- Provide a modular setup with flags to optionally install specific components or skip them entirely.


### Prerequisites

Updating execution policy and running the script requires running the terminal as Administrator.

1. Ensure you have the following installed:
   - **PowerShell 7+** (comes pre-installed with Windows 10/11).
   - **Winget** (Windows Package Manager, included with Windows 11).
   - **Git** (will be installed by the `general.ps1` script if not already installed).
     - To preemptively install Git the same way the script would, run this Winget command:
        ```ps1
        winget install --id Git.Git -e --source winget
        ```
2. Update execution policy to allow running scripts:
   ```ps1
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
   ```
3. Clone (or manually dowload pre-Git) the repository to your desired local directory:
   ```ps1
   git clone https://github.com/johansource/dotfiles.git C:/Projects/dotfiles
   ```
4. Navigate to the `dotfiles/setup` directory:
   ```ps1
   cd C:/Projects/dotfiles/setup
   ```

### Running the Setup Script

To start the Windows setup process, execute the main `windows.ps1` script. The script accepts several optional flags to customize which components are installed. The general setup (`general.ps1`) always runs.

```ps1
.\windows.ps1 [-Dev] [-Gaming] [-GameDev] [-Python] [-NodeJs]
```

#### Flags

- `-Dev`: Installs developer tools including:
  - WezTerm
  - Starship
  - Visual Studio Code
  - Visual Studio
  - Neovim
  - Devtoys
  - Installs fonts.
  - Symlinks configuration files:
    - `wezterm.lua`
    - `starship.toml`
    - `Microsoft.PowerShell_profile.ps1`
  - Installs and configures extensions and preferences for Visual Studio Code
- `-Gaming`: Installs game platforms and related software such as:
  - Steam
- `-GameDev`: Installs game development tools such as:
  - Blender
  - Unity Hub
  - Epic Games Launcher (for Unreal Engine)
- `-Python`: Sets up the Python environment:
  - Installs Python
  - Configures Pyenv
  - Installs Poetry
  - Ensures Tcl/Tk is available for GUI programming
- `-NodeJs`: Sets up the Node.js environment:
  - Installs Pnpm
  - Installs Node.js via Pnpm

## <a name="post-setup-notes"></a> Post-Setup Notes

### MacOS-Specific Notes

- Update macOS-specific settings (e.g., Dock preferences) manually if required
- Install additional Homebrew casks or formulae as needed.

### Windows-Specific Notes

1. **Verify Symlinks:**
   - Ensure all symbolic links (e.g., `.gitconfig`, `wezterm.lua`, `starship.toml`, `Microsoft.PowerShell_profile.ps1`) are created correctly:
      ```ps1
      Get-ChildItem -Path $env:USERPROFILE\.gitconfig
      ```
2. **Revert Execution Policy:**
   - Revert the policy back to its more secure state (optional):
      ```ps1
      Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted
      ```
3. **Restart the Terminal:**
   - Restart your terminal to ensure all changes take effect, including environment variable updates and symbolic links.