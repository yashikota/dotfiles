# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for yashikota. Cross-platform (macOS/Linux) configuration managed via symlinks under the XDG Base Directory Specification.

## Setup Commands

```sh
# macOS
bash mac/setup.sh && bash link.sh

# Linux (Ubuntu/Debian)
bash linux/setup.sh && bash link.sh

# Set ZDOTDIR (required after setup)
ln -s ~/.config/zsh/.zshenv ~/.zshenv
```

`link.sh` symlinks everything under `.config/` into `$HOME/.config/`, `.claude/` into `$HOME/.claude/`, and `~/.zshenv` from `.config/zsh/.zshenv` if present. It backs up existing targets before creating symlinks.

## Architecture

All configuration lives under `.config/` following XDG conventions. Platform-specific install scripts are in `mac/` (Homebrew + Brewfile) and `linux/` (apt + cargo/go installs).

### Shell (Zsh)

- Entry point: `.config/zsh/.zshrc`
- ZDOTDIR is set in `.config/zsh/.zshenv` and linked to `~/.zshenv`
- Plugin management: sheldon (`.config/sheldon/plugins.toml`) with `zsh-defer` for deferred loading
- Prompt: starship (`.config/starship/starship.toml`)
- Custom functions: `.config/zsh/functions/*.zsh` — each file is auto-sourced from `.zshrc`
- Machine-local overrides: `.config/zsh/.zshrc.local` (gitignored)
- Abbreviations use `zsh-abbr` (expanded inline, not traditional aliases)

### Key tool configs

| Tool | Config path |
|------|------------|
| Git | `.config/git/config` (SSH signing, delta pager, rebase on pull) |
| Neovim | `.config/nvim/init.lua` |
| WezTerm | `.config/wezterm/wezterm.lua` |
| Ghostty | `.config/ghostty/config` |
| Tmux | `.config/tmux/tmux.conf` |
| EZA | `.config/eza/theme.yml` |
| Fish (alt shell) | `.config/fish/config.fish` |
| Mise (runtimes) | `.config/mise/config.toml` |
| Aqua (tools) | `.config/aquaproj-aqua/aqua.yaml` |

### Conventions

- Aliases that shadow system commands: `ls`/`ll`/`tree` -> eza, `gcc` -> gcc-14
- Git abbreviations: `ga` (add), `gc` (commit), `gp` (push), `gpl` (pull), `gs` (status), `gsw` (switch), `gd` (diff), `lg` (lazygit)
- Adding a new zsh utility: create a `.zsh` file in `.config/zsh/functions/` — it will be auto-sourced
