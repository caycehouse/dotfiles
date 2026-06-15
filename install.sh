#!/usr/bin/env bash

set -Eeuo pipefail

ostype="$(uname)"
if [ "${ostype}" == "Darwin" ]; then
  # Install XCode Command Line Tools if necessary
  declare git_cmd_path="/Library/Developer/CommandLineTools/usr/bin/git"
  if [ ! -e "${git_cmd_path}" ]; then
    xcode-select --install
  else
    echo "Command line developer tools are already installed."
  fi
elif [ "${ostype}" == "Linux" ]; then
  # Install build tools based on package manager
  if ! command -v gcc >/dev/null 2>&1; then
      if command -v apt-get >/dev/null 2>&1; then
          sudo apt-get update
          sudo apt-get install -y build-essential procps curl file git
      elif command -v dnf >/dev/null 2>&1; then
          sudo dnf group install -y development-tools
          sudo dnf install -y procps-ng curl file git
      else
          echo "Unknown package manager, skipping build tools installation"
      fi
  fi
else
    echo "Unknown OS type: ${ostype}"
    exit 1
fi

# Install Homebrew if necessary
export HOMEBREW_CASK_OPTS=--no-quarantine
if command -v brew >/dev/null 2>&1; then
  echo "Homebrew is already installed."
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH="/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin:$PATH"
  eval "$(brew shellenv)"
fi

# Install chezmoi if necessary
if command -v chezmoi >/dev/null 2>&1; then
  echo "Chezmoi is already installed."
else
  brew install chezmoi
fi

if [ "${ostype}" == "Darwin" ]; then
  # Install 1Password if necessary
  if command -v op >/dev/null 2>&1; then
    echo "1Password is already installed."
  else
    brew install --cask 1password
    brew install 1password-cli
    read -p "Please open 1Password, log into all accounts and set under Settings>CLI activate Integrate with 1Password CLI. Press any key to continue." -n 1 -r
  fi
fi

# Apply dotfiles
echo "Applying Chezmoi configuration."
chezmoi init caycehouse/dotfiles
chezmoi apply
