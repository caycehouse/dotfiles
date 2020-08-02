# Essential.
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# Package list.
zplug "desyncr/auto-ls"
zplug "woefe/wbase.zsh"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "peterhurford/up.zsh"
zplug "dracula/zsh", as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load

# Configure history
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY

# Make Homebrew safer
export HOMEBREW_CASK_OPTS=--require-sha
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

# Keybindings for substring search plugin. Maps up and down arrows.
bindkey -M main '^[[A' history-substring-search-up
bindkey -M main '^[[B' history-substring-search-up

# Aliases
alias ls='exa'
alias l='exa -l --git'

# Alias hub over git
eval "$(hub alias -s)"

# Initialize fuck
eval $(thefuck --alias)

# Add custom scripts to path
export PATH="/usr/local/sbin:$PATH"
export PATH="$PATH:$HOME/.composer/vendor/bin"

if command -v neofetch >/dev/null
then
    neofetch
fi
