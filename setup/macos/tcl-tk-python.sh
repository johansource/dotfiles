#!/usr/bin/env zsh
############################
# This script ensures tcl-tk is set up properly and
# installs latest stable Python version with tcl-tk to enable TKInter
############################

# Ensure Tcl/Tk paths are properly set
echo "Ensuring tcl-tk compatibility for Tkinter..."
tcltk_path="$(brew --prefix tcl-tk)"
if ! echo "$LDFLAGS" | grep -q "$tcltk_path"; then
    echo "Warning: tcl-tk path environment variables may not be set in .zshrc."
fi

# Install latest stable Python with Tkinter support
echo "Installing the latest stable version of Python with Tkinter..."
latest_python_version=$(pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | tail -1 | xargs)
if [ -z "$latest_python_version" ]; then
    echo "Error: Unable to find the latest Python version. Check pyenv installation."
    exit 1
fi

env PYTHON_CONFIGURE_OPTS="--with-tcl-tk=$tcltk_path" pyenv install -s "$latest_python_version" || {
    echo "Error: Failed to install Python $latest_python_version."
    exit 1
}
pyenv global "$latest_python_version"

# Verify Python and Tkinter installation
echo "Verifying Python installation..."
if command -v python3 &>/dev/null; then
    echo "Python successfully installed!"
    python3 --version
else
    echo "Error: Python installation failed."
    exit 1
fi

# Check Tkinter
echo "Checking Tkinter..."
python3 -m tkinter || echo "Warning: Tkinter may not be correctly configured."
