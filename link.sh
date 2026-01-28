# exit on error or undefined variable
set -ue

# Color variables
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

# if not exist, create directory
if [ ! -d ~/.config ]; then
  mkdir ~/.config
fi

# link
for f in .config/*; do
    target="$HOME/.config/$(basename "$f")"
    [ -e "$target" ] && rm -rf "$target"
    ln -svfn "$(pwd)/$f" "$target"
done

# link .claude
if [ -d ".claude" ]; then
    target="$HOME/.claude"
    [ -e "$target" ] && rm -rf "$target"
    ln -svfn "$(pwd)/.claude" "$target"
fi

# Done
echo "${GREEN}Done!${RESET}"
