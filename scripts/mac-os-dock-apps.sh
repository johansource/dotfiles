#!/usr/bin/env zsh
############################
# This script cleans up the macOS Dock and adds desired applications
############################

# Install dockutil if not already installed
if ! command -v dockutil &>/dev/null; then
    echo "Installing dockutil..."
    brew install dockutil
else
    echo "dockutil is already installed."
fi

# Remove all apps from the Dock
echo "Removing all apps from the Dock..."
dockutil --remove all --no-restart

# Remove "persistent other" app from dock
dockutil --remove '~/Downloads' --no-restart

# Add desired applications to the Dock
apps=(
    "/Applications/Arc.app"
    "/Applications/WezTerm.app"
)

echo "Adding selected apps to the Dock..."
for app in "${apps[@]}"; do
    dockutil --add "$app" --no-restart
done

# Restart the Dock to apply changes
echo "Restarting the Dock to apply changes..."
killall Dock

echo "Dock has been cleaned and updated with your selected applications."
