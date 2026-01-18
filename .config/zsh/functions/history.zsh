# fzf powered history search
# Usage: history [query]
# Select a command to insert it into the command line
history() {
    local selected
    selected=$(builtin fc -l 1 | \
        awk '{$1=""; print substr($0,2)}' | \
        fzf --tac --no-sort --query="${*}" \
            --preview-window=hidden \
            --prompt="History > ")

    if [[ -n "$selected" ]]; then
        print -z "$selected"
    fi
}
