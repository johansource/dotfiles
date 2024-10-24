#!/usr/bin/env zsh
############################
# This script installs pnpm and the latest LTS version of Node.js using pnpm
############################

# Check if pnpm is already installed
if command -v pnpm &>/dev/null; then
    echo "Pnpm is already installed."
else
    # Install pnpm
    echo "Installing pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -

    # Since your dotfiles setup configures PNPM_HOME in .zshrc, we rely on that
    echo "Pnpm installed. Ensure that your dotfiles correctly configure PNPM_HOME and the PATH."
fi

# Install Node.js LTS using pnpm
echo "Installing the latest LTS version of Node.js using pnpm..."

# Pnpm's env tool to install the latest LTS version of Node.js
pnpm env use --global lts

# Verify installations
echo "Verifying pnpm and Node.js installations..."

if command -v pnpm &>/dev/null; then
    echo "Pnpm installed successfully!"
else
    echo "There was an error installing pnpm."
fi

if command -v node &>/dev/null; then
    echo "Node.js LTS installed successfully!"
    # Print Node.js version to confirm
    node -v
else
    echo "There was an error installing Node.js."
fi
