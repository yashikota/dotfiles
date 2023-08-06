if status is-interactive
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"
    export PATH="/home/kota/.local/bin:$PATH"
    export DENO_INSTALL="/home/kota/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
    export PATH="$HOME/.cargo/bin:$PATH"
    export PATH="$PATH:/usr/local/go/bin"
    export PATH="$PATH:/mnt/c/Users/kota/AppData/Local/Programs/Microsoft VS Code/bin"
    export LC_ALL="en_US.utf8"
    export LS_COLORS="di=01;36"

    # go
    export GOPATH="$HOME/go"
    export GOBIN="$GOPATH/bin"
    export PATH="$PATH:$GOBIN"

    # starship
    starship init fish | source

    # fish
    set fish_prompt_pwd_dir_length 0

    # shortcut commands
    abbr --add rr rm -rf
    abbr --add cdp cd ..
    abbr --add dot cd ~/dotfiles
    abbr --add cx chmod +x

    abbr --add t tmux
    abbr --add n nvim
    abbr --add v nvim
    abbr --add m make
    abbr --add c code .

    abbr --add nrd npm run dev
    abbr --add nrb npm run build

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

    abbr --add db docker build -t .
    abbr --add dr docker run -it
    abbr --add dcu docker compose up -d
    abbr --add dcd docker compose down --rmi all
end
