#!/bin/sh

# Setup paths
remove_from_path() {
  [ -d "$1" ] || return
  PATHSUB=":$PATH:"
  PATHSUB=${PATHSUB//:$1:/:}
  PATHSUB=${PATHSUB#:}
  PATHSUB=${PATHSUB%:}
  export PATH="$PATHSUB"
}

add_to_path_start() {
  [ -d "$1" ] || return
  remove_from_path "$1"
  export PATH="$1:$PATH"
}

add_to_path_end() {
  [ -d "$1" ] || return
  remove_from_path "$1"
  export PATH="$PATH:$1"
}

force_add_to_path_start() {
  remove_from_path "$1"
  export PATH="$1:$PATH"
}

quiet_which() {
  command -v "$1" >/dev/null
}

add_to_path_start "/usr/local/bin"
add_to_path_start "/usr/local/sbin"
add_to_path_start "/opt/homebrew/bin"

# Aliases
alias mkdir="mkdir -vp"
alias rm="rm -iv"
alias mv="mv -iv"
alias cp="cp -irv"
alias sail="bash vendor/bin/sail"

if quiet_which brew
then
  export HOMEBREW_PREFIX="$(brew --prefix)"
fi

if quiet_which diff-so-fancy
then
  export GIT_PAGER='diff-so-fancy | less -+$LESS -RX'
else
  export GIT_PAGER='less -+$LESS -RX'
fi

if quiet_which exa
then
  alias ls="exa --classify --group --git"
else
  alias ls="ls -F"
fi

if quiet_which bat
then
  export BAT_THEME="Dracula"
  alias cat="bat"
fi

if quiet_which prettyping
then
  alias ping="prettyping --nolegend"
fi

if quiet_which htop
then
  alias top="sudo htop"
fi

# Set up editor
if quiet_which code
then
  export EDITOR="code"
  export GIT_EDITOR="$EDITOR -w"
elif quiet_which vim
then
  export EDITOR="vim"
elif quiet_which vi
then
  export EDITOR="vi"
fi
alias e="$EDITOR"

# Move files to the Trash folder
trash() {
  mv "$@" "$HOME/.Trash/"
}
