# Dotfiles

This repository contains scripts and configuration files to set up a development environment for macOS.

## Getting Started

### Prerequisites

-  macOS (The scripts are tailored for macOS)

### Installation

1. Clone the repository to your local machine:
   ```sh
   git clone https://github.com/johansource/dotfiles.git ~/Projects/dotfiles
   ```
2. Navigate to the `dotfiles` directory:
   ```sh
   cd ~/Projects/dotfiles
   ```
3. Run the installation script:
   ```sh
   zsh ./install.sh
   ```

This script will:

- Create symlinks for dotfiles (`.zshrc`, `.gitconfig`, VS Code `settings.json`, etc.)
- Run macOS-specific configurations
- Install Homebrew packages and casks
- Configure Visual Studio Code
- Install Pnpm and the latest LTS version of Node.js

To be continued

TODO:
- [x] Main install script
- [x]: Main macOS script
- [x]: Homebrew script
- [x]: VS Code script
- [x]: Pnpm and Node.js script
- [x]: MacOS dock apps script, cleanup and auto add
- [ ]: Python script, also add python stuff where needed
- [ ]: Flutter script, also add python stuff where needed
- [x]: WezTerm config and beautification
- [ ]: Unity stuff for VS Code
- [ ]: Unreal Engine stuff for VS Code