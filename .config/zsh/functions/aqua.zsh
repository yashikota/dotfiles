# Wrap aqua to automatically pass GITHUB_TOKEN using gh auth token
aqua() {
    if command -v gh >/dev/null 2>&1; then
        AQUA_GITHUB_TOKEN=$(gh auth token 2>/dev/null) command aqua "$@"
    else
        command aqua "$@"
    fi
}
