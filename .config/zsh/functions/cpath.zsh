# ファイルまたはディレクトリの絶対パスをクリップボードにコピー
# Usage: cpath [file|directory]
# Example: cpath src/index.ts
cpath() {
    local target="${1:-.}"
    local abspath

    if [[ -e "$target" ]]; then
        abspath=$(realpath "$target")
    else
        echo "cpath: '$target' does not exist" >&2
        return 1
    fi

    echo -n "$abspath" | clip

    echo "Copied: $abspath"
}
