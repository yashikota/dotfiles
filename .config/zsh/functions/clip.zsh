# クリップボードにコピー（ファイルまたは標準入力）
# Usage: clip [file] or echo "text" | clip
# Example: clip file.txt / echo "hello" | clip
clip() {
    local input
    if [[ $# -eq 0 ]]; then
        input=$(cat)
    else
        input=$(cat "$1")
    fi

    if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
        echo -n "$input" | clip.exe
    elif [[ "$(uname)" = "Linux" ]]; then
        echo -n "$input" | xsel -bi
    elif [[ "$(uname)" = "Darwin" ]]; then
        echo -n "$input" | pbcopy
    fi
}
