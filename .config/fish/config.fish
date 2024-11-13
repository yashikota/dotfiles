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

    # gradle
    export PATH="$PATH:/opt/gradle/bin"

    # starship
    starship init fish | source
    export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

    # mise
    ~/.local/bin/mise activate fish | source

    # wasmtime
    set -gx WASMTIME_HOME "$HOME/.wasmtime"
    string match -r ".wasmtime" "$PATH" > /dev/null; or set -gx PATH "$WASMTIME_HOME/bin" $PATH

    # rubyenv
    status --is-interactive; and source (rbenv init -|psub)

    # pnpm
    set -gx PNPM_HOME "/home/kota/.local/share/pnpm"
    if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
    end

    # verible
    set -Ux PATH $PATH /usr/local/bin/verible/bin
    set -g PATH /usr/local/bin/verible/bin $PATH

    ### ================= ###
    ### shortcut commands ###
    ### ================= ###
    abbr --add l eza -la --icons --git --time-style relative
    abbr --add rr rm -rf
    abbr --add cdp cd ..
    abbr --add inst sudo apt install -y

    # gcc
    abbr --add gcc gcc-14 -fanalyzer

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
    abbr --add gpuo git push -u origin main
    abbr --add gpl git pull
    abbr --add gb git branch -a
    abbr --add gf git fetch --prune
    abbr --add gs git status
    abbr --add gd git diff
    abbr --add gsw git switch
    abbr --add gsc git switch -c
    abbr --add gr git restore
    abbr --add gco git checkout

    # docker
    abbr --add db docker build -t .
    abbr --add dr docker run -it
    abbr --add dcu docker compose up --build
    abbr --add dcd docker compose down --rmi all
    abbr --add dce docker compose exec

    # terraform
    abbr --add tf terraform
    abbr --add tfi terraform init
    abbr --add tfp terraform plan
    abbr --add tfa terraform apply
    abbr --add tff terraform fmt
    abbr --add tfo terraform output
    abbr --add tfd terraform destroy

    # uv
    abbr --add uva uvx ruff check --fix \&\& uvx ruff format \&\& uvx isort .
    abbr --add uvc uvx ruff check --fix
    abbr --add uvf uvx ruff format
    abbr --add uvi uvx isort .
end
