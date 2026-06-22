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
```

`link.sh` symlinks everything under `.config/` into `$HOME/.config/`, `.claude/` into `$HOME/.claude/`, and `~/.zshenv` from `.config/zsh/.zshenv` if present. It backs up existing targets before creating symlinks.

## Architecture

All configuration lives under `.config/` following XDG conventions. Platform-specific install scripts are in `mac/` (Homebrew + Brewfile) and `linux/` (`tools.toml` defines all packages — apt, curl, cargo, go, and script installers).

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

Runtime/tool managers (`mise`, `aqua`) are installed by the platform setup scripts and have their PATH/env exports configured in `.zshrc` / `config.fish`. The aqua global config (`.config/aquaproj-aqua/aqua.yaml`) is managed in this repo and symlinked to `$HOME/.config/aquaproj-aqua/` via `link.sh`. `AQUA_GLOBAL_CONFIG` points to this path in both zsh and fish.

### Conventions

- Aliases that shadow system commands: `ls`/`ll`/`tree` -> eza, `gcc` -> gcc-14
- Git abbreviations: `ga` (add), `gc` (commit), `gp` (push), `gpl` (pull), `gs` (status), `gsw` (switch), `gd` (diff), `lg` (lazygit)
- Adding a new zsh utility: create a `.zsh` file in `.config/zsh/functions/` — it will be auto-sourced
- Adding a new tool: use the `/add-tool` skill for the full workflow
- Commit messages: imperative mood, lowercase, no period (e.g. `add ghostty config`, `update aqua packages`)
