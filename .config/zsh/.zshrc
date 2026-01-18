# ==================== #
#  Basic Configuration #
# ==================== #
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export TERM="xterm-256color"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export GPG_TTY=$(tty)
setopt AUTO_CD
ABBR_SET_EXPANSION_CURSOR=1

# Directory colors
export LS_COLORS="no=01;32:fi=01;97:di=01;36:ex=01;31:ln=01;35"

# History (XDG compliant)
HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# ==================== #
#    PATH Settings     #
# ==================== #
# local bin
export PATH="$HOME/.local/bin:$PATH"

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# bun
export PATH="$HOME/.bun/bin:$PATH"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# go
export PATH="/usr/local/go/bin:$PATH"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# java
export JAVA_HOME="/usr/local/jdk-21"
export PATH="$JAVA_HOME/bin:$PATH"

# aqua
export AQUA_ROOT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua"
export PATH="$AQUA_ROOT_DIR/bin:$PATH"
export AQUA_GLOBAL_CONFIG="$HOME/.config/aquaproj-aqua/aqua.yaml"

# wasmtime
export WASMTIME_HOME="$HOME/.wasmtime"
export PATH="$WASMTIME_HOME/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# tfenv
export PATH="$HOME/.tfenv/bin:$PATH"

# ==================== #
#       Plugins        #
# ==================== #
eval "$(sheldon source)"

# zsh-syntax-highlighting colors
zsh-defer _setup_syntax_highlighting
_setup_syntax_highlighting() {
    ZSH_HIGHLIGHT_STYLES[command]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
}

# zsh-autosuggestions color
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=250'

# 補完
autoload -Uz compinit && compinit
# 部分一致
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}' 'r:|[-_]=* r:|=*' 'l:|=* r:|=*'

# ==================== #
#   Tool Initializers  #
# ==================== #
# starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# WezTerm Shell Integration (OSC 133 - Semantic Zones)
if [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
    _wezterm_osc133_precmd() {
        # プロンプト開始マーカー (A)
        printf '\e]133;A\e\\'
        # Starship が設定した PROMPT の末尾に Input 開始マーカー (B) を追加
        PROMPT="${PROMPT}"$'\e]133;B\e\\'
    }
    _wezterm_osc133_preexec() {
        # コマンド実行開始マーカー (C)
        printf '\e]133;C\e\\'
    }
    precmd_functions+=(_wezterm_osc133_precmd)
    preexec_functions+=(_wezterm_osc133_preexec)
fi

# mise
eval "$(mise activate zsh)"

# zoxide
eval "$(zoxide init zsh)"

# ==================== #
#       Aliases        #
# ==================== #
alias ls='eza --icons --git'
alias ll='eza -la --icons --git'
alias tree='eza --tree --icons --color=always --git'

# gomi: cross-platform safe delete
case "$(uname)" in
    Darwin) alias gomi='trash' ;;
esac

# gcc
alias gcc='gcc-14 -fanalyzer'

# ==================== #
#    Abbreviations     #
# ==================== #
# (loaded after zsh-abbr plugin is initialized)
zsh-defer _setup_abbr
_setup_abbr() {
    # apps
    abbr -S -q -- -='cd -'
    abbr -S -q -- inst='sudo apt install -y'
    abbr -S -q -- m='make'
    abbr -S -q -- c='code .'
    abbr -S -q -- cur='cursor .'
    abbr -S -q -- k='kubectl'

    # git
    abbr -S -q -- ga='git add -A'
    abbr -S -q -- gc='git commit -m "%"'
    abbr -S -q -- gp='git push'
    abbr -S -q -- gpo='git push -u origin main'
    abbr -S -q -- gpl='git pull'
    abbr -S -q -- gb='git branch -a'
    abbr -S -q -- gs='git status'
    abbr -S -q -- gd='git diff HEAD'
    abbr -S -q -- gr='git reset --hard HEAD~'

    # gh
    abbr -S -q -- ghb='gh browse'
    abbr -S -q -- clone='gh repo clone'

    # docker
    abbr -S -q -- dcu='docker compose up --build'
}

# ==================== #
#      Functions       #
# ==================== #
for f in "$ZDOTDIR"/functions/*.zsh; do
    source "$f"
done
