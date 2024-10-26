#!/usr/bin/env zsh
############################
# This script installs Visual Studio Code extensions
# and handles symlinkng user settings
############################

# Check that VS Code is installed
if ! command -v code &>/dev/null; then
    echo "Visual Studio Code is not installed. Please install it via Homebrew."
    exit 1
fi

# List extensions for installation
extensions=(
    aaron-bond.better-comments
    adpyke.codesnap
    alefragnani.bookmarks
    antfu.browse-lite
    antfu.vite
    bradlc.vscode-tailwindcss
    catppuccin.catppuccin-vsc
    dbaeumer.vscode-eslint
    dsznajder.es7-react-js-snippets
    eamodio.gitlens
    esbenp.prettier-vscode
    foxundermoon.shell-format
    gruntfuggly.todo-tree
    johnpapa.vscode-peacock
    ms-python.black-formatter
    ms-python.debugpy
    ms-python.pylint
    ms-python.python
    ms-python.vscode-pylance
    pkief.material-icon-theme
    pranaygp.vscode-css-peek
    tamasfe.even-better-toml
    usernamehw.errorlens
    whizkydee.material-palenight-theme
    wix.vscode-import-cost
)

# Get a list of all currently installed extensions.
installed_extensions=$(code --list-extensions)

# Install VS Code Extensions
for extension in "${extensions[@]}"; do
    if echo "$installed_extensions" | grep -qi "^$extension$"; then
        echo "$extension is already installed. Skipping..."
    else
        echo "Installing $extension..."
        code --install-extension "$extension"
    fi
done

echo "VS Code extensions have been installed."

# Define the target directory for VS Code user settings on macOS
TARGET_DIR="${HOME}/Library/Application Support/Code/User"

# Check if VS Code settings directory exists
if [ -d "$TARGET_DIR" ]; then
    # Define the source directory for VS Code user settings
    SOURCE_DIR="${HOME}/.dotfiles/vscode/User"
    # Copy your custom settings.json and keybindings.json to the VS Code settings directory
    ln -sf "${SOURCE_DIR}/settings.json" "${TARGET_DIR}/settings.json"
    # ln -sf "${SOURCE_DIR}/keybindings.json" "${TARGET_DIR}/keybindings.json"
    echo "VS Code settings and keybindings have been updated."
else
    echo "VS Code user settings directory does not exist. Please ensure VS Code is installed."
fi
