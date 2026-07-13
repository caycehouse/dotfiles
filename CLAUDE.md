# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Dotfiles managed with [chezmoi](https://www.chezmoi.io/) targeting **macOS (Darwin)** and **Linux (Fedora)**. The source root is `home/` (per `.chezmoiroot`).

## Key Commands

```bash
chezmoi apply          # apply all templates and run scripts
chezmoi diff           # preview pending changes
chezmoi status         # list files with pending changes
chezmoi edit <file>    # edit the source template for a target file
chezmoi cd             # jump to source directory
```

Bootstrap on a new machine (installs Xcode CLT / build tools, Homebrew, chezmoi, then applies):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/caycehouse/dotfiles/HEAD/install.sh)"
```

## Architecture

```
home/
  .chezmoi.toml.tmpl         # core config: defines template variables
  .chezmoiignore.tmpl
  .chezmoiexternal.toml      # external files/archives to fetch
  .chezmoiremove             # paths chezmoi should delete
  .chezmoitemplates/         # reusable template snippets (e.g. sudo.tmpl)
  .chezmoiscripts/
    darwin/                  # macOS-only scripts
    linux/                   # Linux-only scripts (incl. fedora/)
    run_onchange_after_*.tmpl  # run when content/dependencies change
  dot_claude/                # ~/.claude/CLAUDE.md: symlink to agents/AGENTS.md
  dot_codex/                 # ~/.codex/AGENTS.md: symlink to agents/AGENTS.md
  dot_config/                # maps to ~/.config/
    agents/AGENTS.md.tmpl    # global agent instructions (shared by Claude + Codex)
    private_fish/            # Fish shell config (private_ = chmod 600)
    git/                     # Git config
    homebrew/Brewfile.tmpl   # Homebrew packages
    starship.toml.tmpl       # prompt config
    atuin/, bat/, ghostty/, k9s/, lsd/, topgrade.toml
  private_dot_ssh/           # SSH config (private_ = chmod 600)
  dot_vimrc
```

## Template Variables

Defined in `home/.chezmoi.toml.tmpl` and available in all `.tmpl` files:

| Variable | Type | Description |
|---|---|---|
| `.isWorkComputer` | bool | Work vs. personal machine |
| `.hasNvidia` | bool | Linux only: NVIDIA GPU present |
| `.nvidia580xx` | bool | Linux only: use RPM Fusion's NVIDIA 580xx driver branch |
| `.osid` | string | `"darwin"` or `"linux-fedora"` |
| `.email` | string | Git/identity email |
| `.workGitUrl` | string | Work Git SSH host |

## Conventions

- **Edit `.tmpl` files only**; never edit deployed files in `~` directly.
- **Platform gating:** use `.osid` or `.chezmoi.os` in templates; platform-specific scripts live in `darwin/` and `linux/` subdirs of `.chezmoiscripts/`.
- **`run_onchange_` scripts** re-run whenever their file content changes; hash external dependencies (e.g., `Brewfile`) in a comment inside the script to trigger re-runs on dependency changes.
- **Runtime detection over render-time `lookPath`:** fish tool-init files (starship, atuin, zoxide, mise, homebrew, kubectl) are plain `.fish` that detect tools at shell startup (`type -q` / `test -x`), not `.tmpl` files gated on `lookPath`; script shebangs use `#!/usr/bin/env bash`. This keeps configs correct when a tool is installed after the first apply. Render-time gates remain only where the template body itself calls a tool (e.g. `output "bat"`) or reads secrets (`onepasswordRead`).
- **`private_` prefix** → chezmoi deploys with 0600 permissions.
- **`dot_` prefix** → chezmoi maps to a dotfile (e.g., `dot_vimrc` → `~/.vimrc`).
- **Package management:** Homebrew (macOS via `Brewfile.tmpl`), DNF (Fedora), Flatpak, mise for runtime versions.
