#!/usr/bin/env zsh
############################
# This script installs macOS software and sets up essential tools and system preferences
############################

# Install Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install

    # Show the path where the tools were installed
    echo "Xcode Command Line Tools installed at: $(xcode-select -p)"
else
    echo "Xcode Command Line Tools are already installed."
    echo "Installed at: $(xcode-select -p)"
fi

# Automatically hide the Dock
echo "Setting Dock to autohide..."
defaults write com.apple.dock autohide -bool true

# Disable "recently used" spaces in the Dock
echo "Disabling MRU (most recently used) spaces in the Dock..."
defaults write com.apple.dock mru-spaces -bool false

# Show all file extensions in Finder
echo "Showing all file extensions in Finder..."
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults read NSGlobalDomain AppleShowAllExtensions

# Set Finder view style to Column View
echo "Setting Finder preferred view style to Column view (clmv)..."
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults read com.apple.finder FXPreferredViewStyle

# Disable Guest login
echo "Disabling Guest account login..."
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

# Set a fast keyboard repeat rate
echo "Setting a fast keyboard repeat rate..."
defaults write NSGlobalDomain KeyRepeat -int 2
defaults read NSGlobalDomain KeyRepeat

# Set scroll direction for mouse (inverts default behavior)
echo "Setting scroll direction for mouse..."
defaults write NSGlobalDomain com.apple.scrollwheel.scaling -1
defaults read NSGlobalDomain com.apple.scrollwheel.scaling

# Disable the alert sound
echo "Disabling system alert sound..."
defaults write NSGlobalDomain com.apple.sound.beep.volume -int 0

# Change the default location for screenshots (restart SystemUIServer to apply changes)
echo "Setting default screenshot location to ~/Pictures/Screenshots..."
mkdir -p "${HOME}/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"
killall SystemUIServer

# Set screensaver to ask for password immediately after sleep or screensaver starts
echo "Setting screensaver to ask for password after 10 seconds..."
defaults write com.apple.screensaver askForPasswordDelay -int 10

# Apply Dock settings (restart Dock to apply changes)
echo "Applying Dock settings..."
killall Dock

# Apply Finder settings (restart Finder to apply changes)
echo "Applying Finder settings..."
killall Finder

echo "MacOS settings configuration complete!"
