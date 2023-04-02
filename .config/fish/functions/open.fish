function open
    if [ -n "$IS_WSL" ] || [ -n "$WSL_DISTRO_NAME" ]
        explorer.exe $argv[1]
    else if [ "$(uname)" = "Linux" ]
        xdg-open $argv[1]
    else if [ "$(uname)" = "Darwin" ]
        open $argv[1]
    end
end
