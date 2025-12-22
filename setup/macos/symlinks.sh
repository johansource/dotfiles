#!/usr/bin/env zsh
set -euo pipefail
############################
# This script handles symlinking of files
############################

# Dotfiles directory
dotfiles_dir="${HOME}/Projects/dotfiles"

echo "Symlinking dotfiles from: ${dotfiles_dir}"

# List of source files and target locations
files=(
    "git/.gitconfig:${HOME}/.gitconfig"
    "zsh/.zprofile:${HOME}/.zprofile"
    "zsh/.zshrc:${HOME}/.zshrc"
    "wezterm/wezterm.lua:${HOME}/.config/wezterm/wezterm.lua"
    "starship/starship.toml:${HOME}/.config/starship.toml"
    "nvim/init.lua:${HOME}/.config/nvim/init.lua"
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
