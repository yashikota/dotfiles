if status is-interactive
    # terminal
    export LC_ALL="en_US.utf8"
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

    # gradle
    export PATH="$PATH:/opt/gradle/bin"

    # starship
    starship init fish | source
    export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

    # rtx
    rtx activate fish | source
    rtx hook-env -s fish | source
    rtx complete -s fish | source

    # shortcut commands
    # misc
    abbr --add rr rm -rf
    abbr --add cdp cd ..
    abbr --add dot cd ~/dotfiles
    abbr --add cx chmod +x
    abbr --add inst sudo apt install -y

    # apps
    abbr --add t tmux
    abbr --add n nvim
    abbr --add v nvim
    abbr --add m make
    abbr --add c code .

    # bun
    abbr --add brd bun run dev
    abbr --add brb bun run build
    abbr --add brl bun run lint
    abbr --add brf bun run format

    # cargo
    abbr --add cr cargo run
    abbr --add ct cargo test

    # git
    abbr --add ga git add .
    abbr --add gc git commit -m
    abbr --add gpu git push
    abbr --add gpl git pull
    abbr --add gb git branch -a
    abbr --add gf git fetch
    abbr --add gs git status
    abbr --add gd git diff
    abbr --add gsw git switch
    abbr --add gsc git switch -c
    abbr --add gr git restore
    abbr --add gco git checkout

    # docker
    abbr --add db docker build -t .
    abbr --add dr docker run -it
    abbr --add dcu docker compose up -d
    abbr --add dcd docker compose down --rmi all
    abbr --add dce docker compose exec
end

set -gx WASMTIME_HOME "$HOME/.wasmtime"

string match -r ".wasmtime" "$PATH" > /dev/null; or set -gx PATH "$WASMTIME_HOME/bin" $PATH
