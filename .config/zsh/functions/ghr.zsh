# GitHubにリポジトリを作成してoriginに設定
# Usage: ghr <organization> [public|private]
# Example: ghr myorg public
ghr() {
    local organization="$1"
    local visibility="$2"

    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        git init
    fi

    if [[ "$visibility" = "public" ]]; then
        visibility="--public"
    else
        visibility="--private"
    fi

    local current_directory=$(basename "$PWD")
    local source_directory=$(git rev-parse --show-toplevel)

    gh repo create "$organization/$current_directory" "$visibility" --source "$source_directory" --remote=origin
}
