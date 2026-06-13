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

Bootstrap on a new machine:
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply caycehouse
```

## Architecture

```
home/
  .chezmoi.toml.tmpl         # core config — defines template variables
  .chezmoiignore.tmpl
  .chezmoiexternal.toml      # external files/archives to fetch
  .chezmoiremove             # paths chezmoi should delete
  .chezmoiscripts/
    darwin/                  # macOS-only scripts
    linux/                   # Linux-only scripts
    run_onchange_after_*.tmpl  # run when content/dependencies change
  dot_config/                # maps to ~/.config/
    fish/                    # Fish shell config
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
| `.hasNvidia` | bool | Linux only — NVIDIA GPU present |
| `.osid` | string | `"darwin"` or `"linux-fedora"` |
| `.email` | string | Git/identity email |
| `.workGitUrl` | string | Work Git SSH host |

## Conventions

- **Edit `.tmpl` files only** — never edit deployed files in `~` directly.
- **Platform gating:** use `.osid` or `.chezmoi.os` in templates; platform-specific scripts live in `darwin/` and `linux/` subdirs of `.chezmoiscripts/`.
- **`run_onchange_` scripts** re-run whenever their file content changes; hash external dependencies (e.g., `Brewfile`) in a comment inside the script to trigger re-runs on dependency changes.
- **`private_` prefix** → chezmoi deploys with 0600 permissions.
- **`dot_` prefix** → chezmoi maps to a dotfile (e.g., `dot_vimrc` → `~/.vimrc`).
- **Package management:** Homebrew (macOS via `Brewfile.tmpl`), DNF (Fedora), Flatpak, mise for runtime versions.
