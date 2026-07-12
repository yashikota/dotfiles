function aqua -d "Wrap aqua to automatically pass GITHUB_TOKEN and auto-commit on install"
    set -l dotfiles_dir ~/dotfiles
    set -l aqua_yaml $dotfiles_dir/.config/aquaproj-aqua/aqua.yaml

    if command -v gh >/dev/null 2>&1
        env AQUA_GITHUB_TOKEN=(gh auth token 2>/dev/null) command aqua $argv
    else
        command aqua $argv
    end

    set -l exit_code $status

    if test $exit_code -ne 0
        return $exit_code
    end

    if string match -qr '^(g|generate|i|install|init|update|up)' -- "$argv[1]"
        if git -C $dotfiles_dir diff --quiet $aqua_yaml 2>/dev/null
            return 0
        end
        git -C $dotfiles_dir add $aqua_yaml
        set -l msg "aqua: "(string join ' ' -- $argv)
        git -C $dotfiles_dir commit -m $msg --quiet
        git -C $dotfiles_dir push --quiet &
        disown
    end

    return 0
end
