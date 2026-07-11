set -gx HOMEBREW_AUTO_UPDATE_SECS 86400
set -gx HOMEBREW_BUNDLE_FILE $HOME/.config/homebrew/Brewfile
set -gx HOMEBREW_CASK_OPTS --no-quarantine
set -gx HOMEBREW_CLEANUP_MAX_AGE_DAYS 30
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx MISE_FISH_AUTO_ACTIVATE 0

for bindir in /usr/local/bin /opt/homebrew/bin
    test -d $bindir && fish_add_path --global $bindir
end

# Detect brew at runtime, so this is correct no matter when brew was installed.
# HOMEBREW_PREFIX is exported, so nested shells inherit it and skip shellenv.
if not set -q HOMEBREW_PREFIX
    for brewbin in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew
        if test -x $brewbin
            eval ($brewbin shellenv)
            break
        end
    end
end
