#!/usr/bin/env zsh
############################
# This script creates symlinks from the home directory to any desired dotfiles in $HOME/.dotfiles
# And also installs MacOS Software
# And also installs Homebrew Packages and Casks (Apps)
# And also sets up VS Code
# And also sets up pnpm and Node.js
############################

# Dotfiles directory
dotfilesdir="${HOME}/.dotfiles"

# Scripts directory
scriptsdir="${dotfilesdir}/scripts"

# Change to the dotfiles directory
echo "Changing to the ${dotfilesdir} directory"
cd "${dotfilesdir}" || exit

# List of files/folders to symlink and their target locations
declare -A files=(
    ["git/.gitconfig"]="${HOME}/.gitconfig"
    ["zsh/.zshrc"]="${HOME}/.zshrc"
    ["wezterm/.wezterm.lua"]="${HOME}/.wezterm.lua"
)

# Create symlinks (will overwrite old files)
for source in "${!files[@]}"; do
    target="${files[$source]}"
    source_path="${dotfilesdir}/${source}"

    if [[ -f "${source_path}" ]]; then
        echo "Creating symlink for ${source} -> ${target}"

        # Backup the existing target if it exists
        if [[ -f "${target}" || -L "${target}" ]]; then
            echo "Backing up existing ${target} to ${target}.backup"
            mv "${target}" "${target}.backup"
        fi

        ln -svf "${source_path}" "${target}"
    else
        echo "File ${source_path} does not exist, skipping..."
    fi
done

# Run the MacOS script
if [[ -f "${scriptsdir}/macOS.sh" ]]; then
    echo "Running MacOS setup script..."
    ${scriptsdir}/mac-os.sh
else
    echo "'mac-os.sh' not found, skipping..."
fi

# Run the Homebrew script
if [[ -f "${scriptsdir}/homebrew.sh" ]]; then
    echo "Running Homebrew setup script..."
    ${scriptsdir}/homebrew.sh
else
    echo "'homebrew.sh' not found, skipping..."
fi

# Run the VS Code script
if [[ -f "${scriptsdir}/vs-code.sh" ]]; then
    echo "Running VS Code setup script..."
    ${scriptsdir}/vs-code.sh
else
    echo "'vs-code.sh' not found, skipping..."
fi

# Run the pnpm and Node.js script
if [[ -f "${scriptsdir}/pnpm-node.sh" ]]; then
    echo "Running pnpm and Node.js setup script..."
    ${scriptsdir}/pnpm-node.sh
else
    echo "'pnpm-node.sh' not found, skipping..."
fi

echo "Installation complete!"
