# fzf powered abbreviation search
# Usage: cmd [query]
# Select an abbreviation to insert its expansion into the command line
cmd() {
    local selected
    selected=$(abbr list-commands | \
        fzf --no-sort --query="${*}" \
            --preview-window=hidden \
            --prompt="Abbr > ")

    if [[ -n "$selected" ]]; then
        print -z "$selected"
    fi
}
