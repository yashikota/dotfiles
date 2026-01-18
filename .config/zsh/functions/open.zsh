# ファイル/ディレクトリをデフォルトアプリで開く
# Usage: open [path]  (省略時はカレントディレクトリ)
open() {
    local target="${1:-.}"

    if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
        explorer.exe "$target"
    elif [[ "$(uname)" = "Linux" ]]; then
        xdg-open "$target"
    elif [[ "$(uname)" = "Darwin" ]]; then
        command open "$target"
    fi
}
