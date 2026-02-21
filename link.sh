# exit on error or undefined variable
set -ue

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# Color variables
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
MAGENTA=$(tput setaf 5)
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
    target="$HOME/.config/$name"
    backup_target "$target" ".config/$name"
    mkdir -p "$(dirname "$target")"
    ln -svfn "$f" "$target"
done

# link .claude
if [ -d "$DOTFILES_DIR/.claude" ]; then
    target="$HOME/.claude"
    backup_target "$target" ".claude"
    ln -svfn "$DOTFILES_DIR/.claude" "$target"
fi

# link ~/.zshenv to keep ZDOTDIR user-local
if [ -f "$DOTFILES_DIR/.config/zsh/.zshenv" ]; then
    target="$HOME/.zshenv"
    backup_target "$target" ".zshenv"
    ln -svfn "$DOTFILES_DIR/.config/zsh/.zshenv" "$target"
fi

# Done
echo "${GREEN}Done!${RESET}"
echo "${CYAN}Backup directory: $BACKUP_DIR${RESET}"
