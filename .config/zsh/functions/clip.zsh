# ファイルの内容をクリップボードにコピー
# Usage: clip <file>
clip() {
    if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
        cat "$1" | clip.exe
    elif [[ "$(uname)" = "Linux" ]]; then
        cat "$1" | xsel -bi
    elif [[ "$(uname)" = "Darwin" ]]; then
        cat "$1" | pbcopy
    fi
}
