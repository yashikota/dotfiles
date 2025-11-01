if status is-interactive
    # terminal
    export LC_ALL="en_US.utf8"
    export LANG="en_US.utf8"
    set -g fish_greeting ""

    # directory colors
    export LS_COLORS="no=01;32:fi=01;97:di=01;36:ex=01;31:ln=01;35"

    # fish
    set fish_prompt_pwd_dir_length 0
    set -gx GPG_TTY (tty)

    set fish_color_normal         brwhite
    set fish_color_autosuggestion brgrey
    set fish_color_cancel         brred
    set fish_color_command        brcyan
    set fish_color_comment        brgrey
    set fish_color_end            brpurple
    set fish_color_error          brred
    set fish_color_escape         bryellow
    set fish_color_match          brcyan --underline
    set fish_color_operator       brpurple
    set fish_color_param          brgreen
    set fish_color_quote          bryellow
    set fish_color_redirection    brpurple
    set fish_color_search_match   --background=brblack
    set fish_color_selection      --background=brblack

    ### ================ ###
    ### environment vars ###
    ### ================ ###
    # deno
    export PATH="/home/kota/.local/bin:$PATH"
    export DENO_INSTALL="/home/kota/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"

    # bun
    export PATH="$PATH:$HOME/.bun/bin"

    # rust
    export PATH="$HOME/.cargo/bin:$PATH"

    # go
    export PATH="$PATH:/usr/local/go/bin"
    export GOPATH="$HOME/go"
    export GOBIN="$GOPATH/bin"
    export PATH="$PATH:$GOBIN"

    # java
    export JAVA_HOME="/usr/local/jdk-21"
    export PATH="$JAVA_HOME/bin:$PATH"

    # starship
    starship init fish | source
    export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

    # mise
    ~/.local/bin/mise activate fish | source

    # aqua
    set -gx AQUA_ROOT_DIR "$XDG_DATA_HOME/aquaproj-aqua"
    test -n "$XDG_DATA_HOME"; or set -gx AQUA_ROOT_DIR "$HOME/.local/share/aquaproj-aqua"
    set -gx PATH "$AQUA_ROOT_DIR/bin" $PATH
    set -gx AQUA_GLOBAL_CONFIG "$HOME/.config/aquaproj-aqua/aqua.yaml"

    # wasmtime
    set -gx WASMTIME_HOME "$HOME/.wasmtime"
    string match -r ".wasmtime" "$PATH" > /dev/null; or set -gx PATH "$WASMTIME_HOME/bin" $PATH

    # pnpm
    set -gx PNPM_HOME "/home/kota/.local/share/pnpm"
    if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
    end

    # zoxide
    zoxide init fish | source

    ### ================= ###
    ### shortcut commands ###
    ### ================= ###
    alias l='eza -la --icons --git --time-style relative'
    alias bat='batcat'

    # gomi
    abbr --add rm gomi

    # rm
    abbr --add rr rm -rf

    # gcc
    alias gcc='gcc-14 -fanalyzer'

    # apps
    abbr --add - cd -
    abbr --add inst sudo apt install -y
    abbr --add m make
    abbr --add c code .
    abbr --add cu cursor .

    # git
    abbr --add ga git add .
    abbr --add gc git commit -m
    abbr --add gpu git push
    abbr --add gpuo git push -u origin main
    abbr --add gpl git pull
    abbr --add gb git branch -a
    abbr --add gf git fetch --prune
    abbr --add gs git status
    abbr --add gd git diff
    abbr --add gsw git switch

    # docker
    abbr --add dcu docker compose up --build
end
