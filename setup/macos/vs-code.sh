#!/usr/bin/env zsh
############################
# This script installs Visual Studio Code extensions
# and handles symlinking user settings
############################

# Check that VS Code is installed
if ! command -v code &>/dev/null; then
    echo "Visual Studio Code is not installed. Please install it via Homebrew."
    exit 1
fi

# Path to the extensions file
EXTENSIONS_FILE="$(dirname "$0")/../vs-code-extensions.txt"

# Ensure the extensions file exists
if [[ ! -f "$EXTENSIONS_FILE" ]]; then
    echo "Error: vs-code-extensions.txt file not found."
    exit 1
fi

# Get a list of all currently installed extensions.
installed_extensions=$(code --list-extensions)

# Install VS Code Extensions
echo "Installing VS Code extensions..."
while IFS= read -r extension; do
    # Skip empty lines and comments
    if [[ -n "$extension" && "$extension" != \#* ]]; then
        if echo "$installed_extensions" | grep -qi "^$extension$"; then
            echo "$extension is already installed. Skipping..."
        else
            echo "Installing $extension..."
            if ! code --install-extension "$extension"; then
                echo "Failed to install $extension"
            fi
        fi
    fi
done <"$EXTENSIONS_FILE"

echo "VS Code extensions have been installed."

# Define the target directory for VS Code user settings on macOS
TARGET_DIR="${HOME}/Library/Application Support/Code/User"

# Check if VS Code settings directory exists
if [ -d "$TARGET_DIR" ]; then
    # Define the source directory for VS Code user settings
    SOURCE_DIR="${HOME}/Projects/dotfiles/vscode/User"
    # Symlink settings.json
    ln -sf "${SOURCE_DIR}/settings.json" "${TARGET_DIR}/settings.json"
    # Uncomment if you also want to symlink keybindings.json
    # ln -sf "${SOURCE_DIR}/keybindings.json" "${TARGET_DIR}/keybindings.json"
    echo "VS Code settings and keybindings have been updated."
else
    echo "VS Code user settings directory does not exist. Please ensure VS Code is installed."
fi
