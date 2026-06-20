# fzf powered abbreviation search
# Usage: cmd [query]
# Select an abbreviation to execute its expansion
cmd() {
    local selected
    selected=$(abbr list-commands | \
        fzf --no-sort --query="${*}" \
            --preview-window=hidden \
            --prompt="Abbr > ")

    if [[ -n "$selected" ]]; then
        print -s -- "$selected"
        eval "$selected"
    fi
}
