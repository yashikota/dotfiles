# クリップボードにコピー（ファイルまたは標準入力）
# Usage: clip [file] or echo "text" | clip
# Example: clip file.txt / echo "hello" | clip
_clip_emit_osc52() {
    local encoded="$1"

    if [[ -n "${TMUX:-}" ]]; then
        printf '\033Ptmux;\033\033]52;c;%s\a\033\\' "$encoded"
    else
        printf '\033]52;c;%s\a' "$encoded"
    fi
}

clip() {
    local encoded

    if ! command -v base64 >/dev/null 2>&1; then
        print -u2 "clip: base64 is required"
        return 1
    fi

    if [[ $# -eq 0 ]]; then
        encoded=$(base64 | tr -d '\r\n')
    else
        encoded=$(cat "$@" | base64 | tr -d '\r\n')
    fi

    _clip_emit_osc52 "$encoded"
}
