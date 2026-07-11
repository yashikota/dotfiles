function aqua -d "Wrap aqua to automatically pass GITHUB_TOKEN using gh auth token"
    if command -v gh >/dev/null 2>&1
        env AQUA_GITHUB_TOKEN=(gh auth token 2>/dev/null) command aqua $argv
    else
        command aqua $argv
    end
end
