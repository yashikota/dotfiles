if status is-interactive
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"
    export PATH="/home/kota/.local/bin:$PATH"
    export DENO_INSTALL="/home/kota/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
    export PATH="$HOME/.cargo/bin:$PATH"
    export PATH="$PATH:/usr/local/go/bin"

    export GOPATH="$HOME/go"
    export GOBIN="$GOPATH/bin"
    export PATH="$PATH:$GOBIN"

    export LS_COLORS="di=01;36"

    source ~/.asdf/asdf.fish

    set fish_prompt_pwd_dir_length 0

    abbr --add rmrf rm -rf
    abbr --add cdp cd ..
    abbr --add cx chmod +x

    abbr --add t tmux
    abbr --add v nvim

    abbr --add ga git add
    abbr --add gaa git add .
    abbr --add gcm git commit -m
    abbr --add gpu git push
    abbr --add gpo git push origin
    abbr --add gpl git pull
    abbr --add gs git status
    abbr --add gsw git switch
    abbr --add gsc git switch -c
    abbr --add gr git restore
end
