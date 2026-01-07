function open
    set target $argv[1]
    if test -z "$target"
        set target .
    end

    if test -n "$IS_WSL" -o -n "$WSL_DISTRO_NAME"
        explorer.exe $target
    else if test (uname) = Linux
        xdg-open $target
    else if test (uname) = Darwin
        command open $target
    end
end
