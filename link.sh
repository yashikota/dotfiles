#!/usr/bin/env bash
# exit on error or undefined variable
set -ue

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# Color variables
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

mkdir -p "$HOME/.config"
mkdir -p "$BACKUP_DIR"

backup_target() {
    local target="$1"
    local name="$2"

    [ ! -e "$target" ] && return 0
    # Skip if already linked to this repo.
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$DOTFILES_DIR/$name" ]; then
        return 0
    fi
    mkdir -p "$BACKUP_DIR/$(dirname "$name")"
    mv "$target" "$BACKUP_DIR/$name"
    echo "${YELLOW}Backed up $target -> $BACKUP_DIR/$name${RESET}"
}

# link
for f in "$DOTFILES_DIR"/.config/*; do
    name="$(basename "$f")"
    # Herdr creates runtime files in its config directory. Manage only its
    # declarative config so those files stay machine-local.
    [ "$name" = "herdr" ] && continue
    target="$HOME/.config/$name"
    backup_target "$target" ".config/$name"
    mkdir -p "$(dirname "$target")"
    ln -svfn "$f" "$target"
done

# Herdr writes runtime state next to config.toml, so link only that file.
if [ -f "$DOTFILES_DIR/.config/herdr/config.toml" ]; then
    target="$HOME/.config/herdr/config.toml"
    mkdir -p "$(dirname "$target")"
    backup_target "$target" ".config/herdr/config.toml"
    ln -svfn "$DOTFILES_DIR/.config/herdr/config.toml" "$target"
fi

# Keep .agents runtime files machine-local and manage only portable skills.
if [ -d "$DOTFILES_DIR/.agents/skills" ]; then
    target="$HOME/.agents/skills"
    mkdir -p "$(dirname "$target")"
    backup_target "$target" ".agents/skills"
    ln -svfn "$DOTFILES_DIR/.agents/skills" "$target"
fi

# link .claude
if [ -d "$DOTFILES_DIR/.claude" ]; then
    target="$HOME/.claude"
    backup_target "$target" ".claude"
    ln -svfn "$DOTFILES_DIR/.claude" "$target"
fi

# link .codex
if [ -d "$DOTFILES_DIR/.codex" ]; then
    if [ ! -f "$DOTFILES_DIR/.codex/config.toml" ] && [ -f "$DOTFILES_DIR/.codex/config.example.toml" ]; then
        cp "$DOTFILES_DIR/.codex/config.example.toml" "$DOTFILES_DIR/.codex/config.toml"
        echo "${CYAN}Created $DOTFILES_DIR/.codex/config.toml from config.example.toml${RESET}"
    fi

    target="$HOME/.codex"
    backup_target "$target" ".codex"
    ln -svfn "$DOTFILES_DIR/.codex" "$target"
fi

# Share custom skills with Codex. Skills in .agents are the portable source of
# truth and take precedence over Claude-specific skills with the same name.
for skills_dir in "$DOTFILES_DIR/.claude/skills" "$DOTFILES_DIR/.agents/skills"; do
    [ -d "$skills_dir" ] || continue
    mkdir -p "$HOME/.codex/skills"
    for skill in "$skills_dir"/*/; do
        name="$(basename "$skill")"
        if [ "$skills_dir" = "$DOTFILES_DIR/.claude/skills" ] && [ -d "$DOTFILES_DIR/.agents/skills/$name" ]; then
            continue
        fi
        target="$HOME/.codex/skills/$name"
        # skip if already managed by gh skill (plugin cache)
        [ -d "$target" ] && [ ! -L "$target" ] && continue
        ln -svfn "$skill" "$target"
    done
done

# link ~/.zshenv to keep ZDOTDIR user-local
if [ -f "$DOTFILES_DIR/.config/zsh/.zshenv" ]; then
    target="$HOME/.zshenv"
    backup_target "$target" ".zshenv"
    ln -svfn "$DOTFILES_DIR/.config/zsh/.zshenv" "$target"
fi

# Done
echo "${GREEN}Done!${RESET}"
echo "${CYAN}Backup directory: $BACKUP_DIR${RESET}"
