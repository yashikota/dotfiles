# git rootに移動（引数指定時はそこからの相対パスに移動）
# Usage: u [directory | -]
# Example: u src/components
u() {
  if [[ "$1" == "-" ]]; then
    cd -
    return
  fi

  local root
  root=$(git rev-parse --show-cdup 2>/dev/null) || {
    echo "Not in a git repository" >&2
    return 1
  }

  cd "./${root:-.}"

  if [[ $# -eq 1 ]]; then
    cd "$1"
  fi
}
