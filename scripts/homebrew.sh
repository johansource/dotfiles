#!/usr/bin/env zsh
############################
# This script installs Homebrew along with formulae, casks, and fonts
############################

# Install Homebrew if it isn't already installed
if ! command -v brew &>/dev/null; then
    echo "Homebrew not installed. Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Attempt to set up Homebrew PATH automatically for this session
    if [[ $(uname -m) == "arm64" ]]; then
        # For Apple Silicon Macs
        echo "Configuring Homebrew in PATH for Apple Silicon Mac..."
        export PATH="/opt/homebrew/bin:$PATH"
    else
        # For Intel Macs, Homebrew is typically installed in /usr/local/bin
        echo "Configuring Homebrew in PATH for Intel Mac..."
        export PATH="/usr/local/bin:$PATH"
    fi
else
    echo "Homebrew is already installed."
fi

# Verify brew is now accessible
if ! command -v brew &>/dev/null; then
    echo "Failed to configure Homebrew in PATH. Please add Homebrew to your PATH manually."
    exit 1
fi

# Update Homebrew and upgrade any already-installed formulae
brew update
brew upgrade
brew upgrade --cask
brew cleanup

# Define an array of packages to install using Homebrew
packages=(
    "git"
    "python"
    "poetry"
    "pyenv"
    "starship"
    "tcl-tk"
    "zsh"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
)

# Loop over the array to install each application.
for package in "${packages[@]}"; do
    if brew list --formula | grep -q "^$package\$"; then
        echo "$package is already installed. Skipping..."
    else
        echo "Installing $package..."
        brew install "$package"
    fi
done

# Get the path to Homebrew's zsh
BREW_ZSH="$(brew --prefix)/bin/zsh"

# Check if Homebrew's zsh is already the default shell
if [ "$SHELL" != "$BREW_ZSH" ]; then
    # Check if Homebrew's zsh is already in allowed shells
    if ! grep -Fxq "$BREW_ZSH" /etc/shells; then
        echo "Adding Homebrew zsh to allowed shells..."
        echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
    fi
    # Set the Homebrew zsh as default shell
    chsh -s "$BREW_ZSH"
    echo "Default shell changed to Homebrew zsh."
else
    echo "Homebrew zsh is already the default shell. Skipping configuration."
fi

# Define an array of applications to install using Homebrew casks
apps=(
    "1password"
    "arc"
    "devtoys"
    "discord"
    "docker"
    "figma"
    "iina"
    "notion"
    "obs"
    "pika"
    "rectangle"
    "spotify"
    "visual-studio-code"
    "wezterm"
)

# Loop over the array to install each application
for app in "${apps[@]}"; do
    if brew list --cask | grep -q "^$app\$"; then
        echo "$app is already installed. Skipping..."
    else
        echo "Installing $app..."
        brew install --cask "$app"
    fi
done

# Define an array of applications to install using Homebrew casks
fonts=(
    "font-jetbrains-mono"
    # For symbols in VS Code terminal
    "font-jetbrains-mono-nerd-font"
    "font-source-code-pro"
)

# Loop over the array to install each font
for font in "${fonts[@]}"; do
    # Check if the font is already installed
    if brew list --cask | grep -q "^$font\$"; then
        echo "$font is already installed. Skipping..."
    else
        echo "Installing $font..."
        brew install --cask "$font"
    fi
done

# Update and clean up again for safe measure
brew update
brew upgrade
brew upgrade --cask
brew cleanup
