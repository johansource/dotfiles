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
    amlovey.shaderlabvscodefree
    antfu.browse-lite
    antfu.vite
    bradlc.vscode-tailwindcss
    catppuccin.catppuccin-vsc
    christian-kohler.path-intellisense
    dbaeumer.vscode-eslint
    dsznajder.es7-react-js-snippets
    eamodio.gitlens
    esbenp.prettier-vscode
    expo.vscode-expo-tools
    formulahendry.code-runner
    formulahendry.docker-explorer
    foxundermoon.shell-format
    gruntfuggly.todo-tree
    jeff-hykin.better-cpp-syntax
    johnpapa.vscode-peacock
    k--kato.docomment
    kleber-swf.unity-code-snippets
    mikestead.dotenv
    ms-azuretools.vscode-docker
    ms-dotnettools.csharp
    ms-python.black-formatter
    ms-python.debugpy
    ms-python.isort
    ms-python.pylint
    ms-python.python
    ms-python.vscode-pylance
    ms-toolsai.jupyter
    ms-vscode.cmake-tools
    ms-vscode.cpptools
    ms-vscode-remote.remote-containers
    msjsdiag.vscode-react-native
    njpwerner.autodocstring
    pkief.material-icon-theme
    pranaygp.vscode-css-peek
    redhat.vscode-yaml
    slevesque.shader
    tamasfe.even-better-toml
    usernamehw.errorlens
    visualstudiotoolsforunity.vstuc
    whizkydee.material-palenight-theme
    wix.vscode-import-cost
    yclepticstudios.unity-snippets
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
    SOURCE_DIR="${HOME}/Projects/dotfiles/vscode/User"
    # Copy your custom settings.json and keybindings.json to the VS Code settings directory
    ln -sf "${SOURCE_DIR}/settings.json" "${TARGET_DIR}/settings.json"
    # ln -sf "${SOURCE_DIR}/keybindings.json" "${TARGET_DIR}/keybindings.json"
    echo "VS Code settings and keybindings have been updated."
else
    echo "VS Code user settings directory does not exist. Please ensure VS Code is installed."
fi
