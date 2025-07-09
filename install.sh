#!/usr/bin/env bash

set -eufo pipefail

echo ""
echo "🤚  This script will setup .dotfiles for you."
read -n 1 -r -s -p $'    Press any key to continue or Ctrl+C to abort...\n\n'

# Install build tools based on package manager
if ! command -v gcc >/dev/null 2>&1; then
    echo "🔧  Installing build tools..."
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y build-essential procps curl file git
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf groupinstall -y 'Development Tools'
        sudo dnf install -y procps-ng curl file git
    elif command -v yum >/dev/null 2>&1; then
        sudo yum groupinstall -y 'Development Tools'
        sudo yum install -y procps-ng curl file git
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm base-devel procps-ng curl file git
    else
        echo "⚠️  Unknown package manager, skipping build tools installation"
    fi
fi

# Install Homebrew
command -v brew >/dev/null 2>&1 ||
    (echo '🍺  Installing Homebrew' && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")

# Load brew into shell environment
command -v brew >/dev/null 2>&1 || export PATH="/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin:$PATH"
command -v brew >/dev/null 2>&1 && eval "$(brew shellenv)"

# Install chezmoi
command -v chezmoi >/dev/null 2>&1 ||
    (echo '👊  Installing chezmoi' && brew install chezmoi)

if [ -d "$HOME/.local/share/chezmoi/.git" ]; then
    echo "🚸  chezmoi already initialized"
    echo "    Reinitialize with: 'chezmoi init caycehouse'"
else
    echo "🚀  Initializing dotfiles with:"
    echo "    chezmoi init caycehouse"
    chezmoi init --apply caycehouse
fi

echo ""
echo "Done."
