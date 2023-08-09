if status is-interactive
    # terminal
    export LC_ALL="en_US.utf8"
    export LS_COLORS="di=01;36"

    # fish
    set fish_prompt_pwd_dir_length 0
    set GPG_TTY (tty)

    set fish_color_normal         brwhite
    set fish_color_autosuggestion brblack
    set fish_color_cancel         brred
    set fish_color_command        brcyan
    set fish_color_comment        brblack
    set fish_color_cwd            brcyan
    set fish_color_end            brwhite
    set fish_color_error          brred
    set fish_color_escape         brcyan
    set fish_color_host           brgreen
    set fish_color_host_remote    bryellow
    set fish_color_match          brcyan --underline
    set fish_color_operator       brpurple
    set fish_color_param          brgreen
    set fish_color_quote          bryellow
    set fish_color_redirection    brpurple
    set fish_color_search_match   --background=brblack
    set fish_color_selection      --background=brblack
    set fish_color_user           brblue

    # pager
    set fish_pager_color_progress              brblack --italics
    set fish_pager_color_secondary_background  # null
    set fish_pager_color_secondary_completion  brblack
    set fish_pager_color_secondary_description brblack
    set fish_pager_color_secondary_prefix      brblack
    set fish_pager_color_selected_background   --background=brblack
    set fish_pager_color_selected_completion   bryellow
    set fish_pager_color_selected_description  bryellow
    set fish_pager_color_selected_prefix       bryellow

    # deno
    export PATH="/home/kota/.local/bin:$PATH"
    export DENO_INSTALL="/home/kota/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"

    # rust
    export PATH="$HOME/.cargo/bin:$PATH"

    # go
    export PATH="$PATH:/usr/local/go/bin"
    export GOPATH="$HOME/go"
    export GOBIN="$GOPATH/bin"
    export PATH="$PATH:$GOBIN"

    # starship
    starship init fish | source

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

    # apps
    abbr --add t tmux
    abbr --add n nvim
    abbr --add v nvim
    abbr --add m make
    abbr --add c code .

    # npm
    abbr --add nrd npm run dev
    abbr --add nrb npm run build

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
end
