# fzf powered abbreviation search
# Usage: cmd [query]
# Select an abbreviation to execute its expansion
cmd() {
    local selected
    local selected_abbr
    local command

    selected=$(abbr list | \
        awk -F= '!seen[$1]++ { order[++n] = $1 } { line[$1] = $0 } END { for (i = 1; i <= n; i++) print line[order[i]] }' | \
        fzf --no-sort --query="${*}" \
            --preview-window=hidden \
            --prompt="Abbr > ")

    if [[ -n "$selected" ]]; then
        selected_abbr="${selected%%=*}"
        selected_abbr="${(Q)selected_abbr}"
        command=$(abbr expand "$selected_abbr") || return

        print -s -- "$command"
        eval "$command"
    fi
}
