if status is-interactive
    # terminal
    export LC_ALL="en_US.utf8"
    export LANG="en_US.utf8"
    set -g fish_greeting ""
    export XDG_CONFIG_HOME="$HOME/.config"

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

    # zellij
    eval (zellij setup --generate-auto-start fish | string collect)

    ### ================= ###
    ### shortcut commands ###
    ### ================= ###
    alias l='eza -la --icons --git --time-style relative'
    alias tree='eza --tree --icons --color=always --git --time-style relative'

    # trash (gomi on Linux, trash on macOS)
    switch (uname)
        case Darwin
            alias rm='trash'
        case '*'
            alias rm='gomi'
    end

    # gcc
    alias gcc='gcc-14 -fanalyzer'

    # apps
    abbr --add - cd -
    abbr --add inst sudo apt install -y
    abbr --add m make
    abbr --add c code .
    abbr --add cu cursor .

    # git
    abbr --add ga git add -A
    abbr --add gc --set-cursor 'git commit -m "%"'
    abbr --add gp git push
    abbr --add gpo git push -u origin main
    abbr --add gpl git pull
    abbr --add gb git branch -a
    abbr --add gs git status
    abbr --add gd git diff HEAD
    abbr --add gr git reset --hard HEAD~

    # gh
    abbr --add ghb gh browse

    # docker
    abbr --add dcu docker compose up --build
end
set -x PATH $HOME/.tfenv/bin $PATH
