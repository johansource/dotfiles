#!/usr/bin/env zsh
############################
# This script creates symlinks from the home directory to any desired dotfiles in the dotfiles repository
# And also installs MacOS Software
# And also installs Homebrew Packages and Casks
# And also sets up VS Code
# And also sets up pnpm and Node.js
############################

# Dotfiles directory
dotfilesdir="${HOME}/Projects/dotfiles"

# Scripts directory
scriptsdir="${dotfilesdir}/scripts"

# Change to the dotfiles directory
echo "Changing to the ${dotfilesdir} directory"
cd "${dotfilesdir}" || exit

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
    source_path="${dotfilesdir}/${source}"

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
if [[ -f "${scriptsdir}/mac-os.sh" ]]; then
    echo "Running MacOS setup script..."
    zsh ${scriptsdir}/mac-os.sh
else
    echo "'mac-os.sh' not found, skipping..."
fi

# Run the Homebrew script
if [[ -f "${scriptsdir}/homebrew.sh" ]]; then
    echo "Running Homebrew setup script..."
    zsh ${scriptsdir}/homebrew.sh
else
    echo "'homebrew.sh' not found, skipping..."
fi

# Run the VS Code script
if [[ -f "${scriptsdir}/vs-code.sh" ]]; then
    echo "Running VS Code setup script..."
    zsh ${scriptsdir}/vs-code.sh
else
    echo "'vs-code.sh' not found, skipping..."
fi

# Run the pnpm and Node.js script
if [[ -f "${scriptsdir}/pnpm-node.sh" ]]; then
    echo "Running pnpm and Node.js setup script..."
    zsh ${scriptsdir}/pnpm-node.sh
else
    echo "'pnpm-node.sh' not found, skipping..."
fi

# Run the VS Code script
if [[ -f "${scriptsdir}/mac-os-dock-apps.sh" ]]; then
    echo "Running macOS dock apps script..."
    zsh ${scriptsdir}/mac-os-dock-apps.sh
else
    echo "'mac-os-dock-apps.sh' not found, skipping..."
fi

echo "Installation complete!"
