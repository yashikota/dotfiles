function copy
    if [ -n "$IS_WSL" ] || [ -n "$WSL_DISTRO_NAME" ]
        cat $argv[1] | clip.exe
    else if [ "$(uname)" = "Linux" ]
        cat $argv[1] | xsel -bi
    else if [ "$(uname)" = "Darwin" ]
        cat $argv[1] | pbcopy
    else
        echo "This is Windows"
    end
end
