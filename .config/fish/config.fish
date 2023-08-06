if status is-interactive
    # terminal
    export LC_ALL="en_US.utf8"
    export LS_COLORS="di=01;36"

    # fish
    set fish_prompt_pwd_dir_length 0

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
