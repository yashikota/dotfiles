function pinact -d "Wrap pinact to automatically pass GITHUB_TOKEN using gh auth token"
    if command -v gh >/dev/null 2>&1
        env GITHUB_TOKEN=(gh auth token 2>/dev/null) PINACT_GITHUB_TOKEN=(gh auth token 2>/dev/null) command pinact $argv
    else
        command pinact $argv
    end
end
