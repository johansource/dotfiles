#!/usr/bin/env zsh
############################
# Main setup script for MacOS
# This script sets up symlinks from the home directory to specified dotfiles in the repository
# Installs essential MacOS software
# Adds necessary Homebrew packages and casks
# Configures Visual Studio Code settings
# Installs and configures pnpm and Node.js
# Sets up Tcl/Tk for Python’s Tkinter support
# Customizes MacOS Dock with preferred applications
############################

# Dotfiles directory
dotfiles_dir="${HOME}/Projects/dotfiles"

# MacOS scripts directory
macos_dir="${dotfiles_dir}/setup/macos"

# Change to the dotfiles directory
echo "Changing to the ${dotfiles_dir} directory"
cd "${dotfiles_dir}" || exit

# List of source files and target locations
files=(
    "git/.gitconfig:${HOME}/.gitconfig"
    "zsh/.zshrc:${HOME}/.zshrc"
    "wezterm/wezterm.lua:${HOME}/.config/wezterm/wezterm.lua"
    "starship/starship.toml:${HOME}/.config/starship.toml"
)

# Create symlinks (will overwrite old files)
for file in "${files[@]}"; do
    # Split the source and target using colon as a delimiter
    source="${file%%:*}"
    target="${file##*:}"
    source_path="${dotfiles_dir}/${source}"

    # Get the directory of the target file
    target_dir="$(dirname "${target}")"

    # Ensure the target directory exists
    if [[ ! -d "${target_dir}" ]]; then
        echo "Creating directory ${target_dir}"
        mkdir -p "${target_dir}"
    fi

    if [[ -f "${source_path}" ]]; then
        echo "Creating symlink for ${source_path} -> ${target}"
        ln -svf "${source_path}" "${target}"
    else
        echo "File ${source_path} does not exist, skipping..."
    fi
done

# Run the MacOS script
if [[ -f "${macos_dir}/general.sh" ]]; then
    echo "Running general setup script..."
    zsh ${macos_dir}/general.sh
else
    echo "'general.sh' not found, skipping..."
fi

# Run the Homebrew script
if [[ -f "${macos_dir}/homebrew.sh" ]]; then
    echo "Running Homebrew setup script..."
    zsh ${macos_dir}/homebrew.sh
else
    echo "'homebrew.sh' not found, skipping..."
fi

# Run the VS Code script
if [[ -f "${macos_dir}/vs-code.sh" ]]; then
    echo "Running VS Code setup script..."
    zsh ${macos_dir}/vs-code.sh
else
    echo "'vs-code.sh' not found, skipping..."
fi

# Run the pnpm and Node.js script
if [[ -f "${macos_dir}/pnpm-node.sh" ]]; then
    echo "Running pnpm and Node.js setup script..."
    zsh ${macos_dir}/pnpm-node.sh
else
    echo "'pnpm-node.sh' not found, skipping..."
fi

# Run the Tcl/Tk setup script
if [[ -f "${macos_dir}/tcl-tk-python.sh" ]]; then
    echo "Running Tcl/Tk setup script for Python..."
    zsh ${macos_dir}/tcl-tk-python.sh
else
    echo "'tcl-tk-python.sh' not found, skipping..."
fi

# Run the MacOS dock apps script
if [[ -f "${macos_dir}/dock-apps.sh" ]]; then
    echo "Running MacOS dock apps script..."
    zsh ${macos_dir}/dock-apps.sh
else
    echo "'dock-apps.sh' not found, skipping..."
fi

echo "Installation complete!"
