# Dotfiles

This repository was created to mostly automate setting up a desired environment on a fresh machine.

## Table of Contents

1. [Getting started](#getting-started)
2. [MacOS](#macos)
3. [Windows](#windows)

## <a name="getting-started"></a> Getting Started

Do some things and stuff

## <a name="macos"></a> MacOS

This setup will:

- Create symlinks for dotfiles (`.zshrc`, `.gitconfig`, VS Code `settings.json`, etc.)
- Run MacOS-specific configurations
- Install Homebrew packages and casks
- Configure Visual Studio Code
- Install Pnpm and the latest LTS version of Node.js

### Setup

1. Clone the repository to your local machine:
   ```sh
   git clone https://github.com/johansource/dotfiles.git ~/Projects/dotfiles
   ```
2. Navigate to the `dotfiles` directory:
   ```sh
   cd ~/Projects/dotfiles
   ```
3. Run the setup script for MacOS:
   ```sh
   zsh ./macos-setup.sh
   ```

## <a name="windows"></a> Windows

This setup will:

- ?

### Setup

1. Clone the repository to your local machine:
   ```sh
   git clone https://github.com/johansource/dotfiles.git C:/Projects/dotfiles
   ```
2. Navigate to the `dotfiles` directory:
   ```sh
   cd C:/Projects/dotfiles
   ```
3. Run the setup script for Windows:
   ```ps
   ./windows-setup.ps1
   ```
