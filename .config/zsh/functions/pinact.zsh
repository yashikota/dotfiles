# Wrap pinact to automatically pass GITHUB_TOKEN using gh auth token
pinact() {
    if command -v gh >/dev/null 2>&1; then
        GITHUB_TOKEN=$(gh auth token 2>/dev/null) PINACT_GITHUB_TOKEN=$(gh auth token 2>/dev/null) command pinact "$@"
    else
        command pinact "$@"
    fi
}
