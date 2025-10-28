#!/usr/bin/env bash

set -Eeuo pipefail

declare -r DOTFILES_REPO_URL="https://github.com/caycehouse/dotfiles"

function get_os_type() {
  uname
}

declare ostype="$(get_os_type)"
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
  if ! which -s gcc; then
      if which -s apt-get; then
          sudo apt-get update
          sudo apt-get install -y build-essential procps curl file git
      elif which -s dnf; then
          sudo dnf group install -y development-tools
          sudo dnf install -y procps-ng curl file git
      elif which -s yum; then
          sudo yum groupinstall -y 'Development Tools'
          sudo yum install -y procps-ng curl file git
      elif which -s pacman; then
          sudo pacman -S --noconfirm base-devel procps-ng curl file git
      else
          echo "Unknown package manager, skipping build tools installation"
      fi
  fi
else
    echo "Unknown OS type: ${ostype}"
    return 1
fi

# Install Homebrew if necessary
export HOMEBREW_CASK_OPTS=--no-quarantine
if which -s brew; then
  echo "Homebrew is already installed."
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH="/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin:$PATH"
  eval "$(brew shellenv)"
fi

# Install chezmoi if necessary
if which -s chezmoi; then
  echo "Chezmoi is already installed."
else
  brew install chezmoi
fi

if [ "${ostype}" == "Darwin" ]; then
  # Install 1Password if necessary
  if which -s op; then
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
