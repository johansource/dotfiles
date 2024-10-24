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

    # Assuming your dotfiles setup already configures the PATH in .zshrc
    echo "Pnpm installed. Ensure that your dotfiles configure pnpm in the PATH."

    # Add pnpm to PATH if it's not already there
    if ! grep -q "pnpm" ~/.zshrc; then
        echo "Adding pnpm to PATH..."
        echo "export PATH=\$HOME/.local/share/pnpm:\$PATH" >>~/.zshrc
        source ~/.zshrc
    fi
fi

# Install Node.js LTS using pnpm
echo "Installing the latest LTS version of Node.js using pnpm..."

# Pnpm's env tool to install the latest LTS version of Node.js
pnpm env use --global lts

# Ensure the pnpm and Node.js installation is sourced
source ~/.zshrc

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
