if status is-interactive
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"
    export PATH="/home/kota/.local/bin:$PATH"
    export DENO_INSTALL="/home/kota/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
    export PATH="$HOME/.cargo/bin:$PATH"
    export PATH="$PATH:/usr/local/go/bin"
    export PATH="$PATH:/mnt/c/Users/kota/AppData/Local/Programs/Microsoft VS Code/bin"

    export GOPATH="$HOME/go"
    export GOBIN="$GOPATH/bin"
    export PATH="$PATH:$GOBIN"

    export LS_COLORS="di=01;36"

    source ~/.asdf/asdf.fish

    set fish_prompt_pwd_dir_length 0

    abbr --add rr rm -rf
    abbr --add cdp cd ..
    abbr --add dot cd ~/dotfiles
    abbr --add cx chmod +x

    abbr --add t tmux
    abbr --add v nvim
    abbr --add m make
    abbr --add c code .

    abbr --add nrd npm run dev
    abbr --add nrb npm run build

    abbr --add ga git add .
    abbr --add gc git commit -m
    abbr --add gpo git push origin
    abbr --add gpom git push origin master
    abbr --add gpl git pull
    abbr --add gplom git pull orign master
    abbr --add gb git branch -a
    abbr --add gf git fetch
    abbr --add gfp git fetch --prune
    abbr --add gs git status
    abbr --add gd git diff
    abbr --add gsw git switch
    abbr --add gsc git switch -c
    abbr --add gr git restore
    abbr --add gco git checkout .

    abbr --add db docker build -t .
    abbr --add dr docker run -it
    abbr --add dcu docker compose up -d
    abbr --add dcd docker compose down --rmi all
end
