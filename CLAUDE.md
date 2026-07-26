# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Dotfiles managed with [chezmoi](https://www.chezmoi.io/) targeting **macOS (Darwin)** and **Linux (Fedora)**. The source root is `home/` (per `.chezmoiroot`).

## Conventions

- **Edit `.tmpl` files only**; never edit deployed files in `~` directly.
- **Platform gating:** use `.osid` or `.chezmoi.os` in templates; platform-specific scripts live in `darwin/` and `linux/` subdirs of `.chezmoiscripts/`.
- **`run_onchange_` scripts** re-run whenever their file content changes; hash external dependencies (e.g., `Brewfile`) in a comment inside the script to trigger re-runs on dependency changes.
- **Runtime detection over render-time `lookPath`:** fish tool-init files (starship, atuin, zoxide, mise, homebrew, kubectl) are plain `.fish` that detect tools at shell startup (`type -q` / `test -x`), not `.tmpl` files gated on `lookPath`; script shebangs use `#!/usr/bin/env bash`. This keeps configs correct when a tool is installed after the first apply. Render-time gates remain only where the template body itself calls a tool (e.g. `output "bat"`) or reads secrets (`onepasswordRead`).
