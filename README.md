# Dotfiles

This repository keeps personal dotfiles and setup scripts for restoring my shell, editor, terminal, and Git configuration.

## Table of Contents

1. [Getting started](#getting-started)
2. [MacOS](#macos)
3. [Windows](#windows)
4. [Post-Setup Notes](#post-setup-notes)

## <a name="getting-started"></a> Getting Started

This repository helps restore a familiar development environment by:

- Configuring applications with customized settings
- Creating symlinks for dotfiles to maintain consistency across machines.
- Installing or configuring a small number of dotfiles-adjacent tools when manual setup is awkward.

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

1. Clone (or manually download pre-Git) the repository to your desired local directory:
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

The Windows setup is manual-first. Tool installs should be handled by following `setup/windows/manual-setup.md`; this repository should manage dotfiles and configuration for:

- Git
- Neovim
- WezTerm
- Starship
- PowerShell
- Visual Studio Code

### Prerequisites

Updating execution policy and running the script requires running the terminal as Administrator. Before running the script, complete the manual setup checklist in `setup/windows/manual-setup.md`.

1. Ensure you have the following installed:
   - **PowerShell 7+**
   - **Git**
2. Update execution policy to allow running scripts:
   ```ps1
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
   ```
3. Clone (or manually download pre-Git) the repository to your desired local directory:
   ```ps1
   git clone https://github.com/johansource/dotfiles.git C:/Projects/dotfiles
   ```
4. Navigate to the `dotfiles/setup` directory:
   ```ps1
   cd C:/Projects/dotfiles/setup
   ```

### Running the Setup Script

The new Windows setup script is intended for dotfiles-related configuration after the manual checklist is complete.

```ps1
.\windows.ps1
```

### Legacy Automated Setup

The previous Winget-heavy automation has been archived under `setup/windows-automated`. It remains available as reference, but it is no longer the recommended Windows setup path.

```ps1
.\windows-automated.ps1 [-Dev] [-Gaming] [-GameDev] [-Python] [-Js]
```

## <a name="post-setup-notes"></a> Post-Setup Notes

### MacOS-Specific Notes

- Update macOS-specific settings (e.g., Dock preferences) manually if required
- Install additional Homebrew casks or formulae as needed.

### Windows-Specific Notes

1. **Verify Configuration:**
   - Ensure the expected tools are configured and symlinks point back to this repository:
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
