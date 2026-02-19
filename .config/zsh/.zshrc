# ==================== #
#  Basic Configuration #
# ==================== #

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export GPG_TTY=$(tty)
OS_NAME="$(uname -s)"
setopt AUTO_CD
ABBR_SET_EXPANSION_CURSOR=1

# Directory colors
export LS_COLORS="no=01;32:fi=01;97:di=01;36:ex=01;31:ln=01;35"

# History (XDG compliant)
HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
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
if [[ "$OS_NAME" == "Linux" ]]; then
    export PATH="/usr/local/go/bin:$PATH"
fi
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# java
if [[ "$OS_NAME" == "Linux" ]]; then
    export JAVA_HOME="/usr/local/jdk-21"
    export PATH="$JAVA_HOME/bin:$PATH"
fi

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
_setup_syntax_highlighting() {
    ZSH_HIGHLIGHT_STYLES[command]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
}
zsh-defer _setup_syntax_highlighting

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

# OSC 2 - タブタイトルにgit root名を設定
# OSC 7 - 作業ディレクトリをターミナルに通知
function __osc2_7_cwd() {
    printf '\033]7;file://%s%s\033\\' "${HOST}" "${PWD}"
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    local title=${${git_root:t}:-${PWD:t}}
    printf '\033]2;%s\033\\' "$title"
}
chpwd_functions+=(__osc2_7_cwd)
__osc2_7_cwd  # 初回実行

# OSC 133 - プロンプトをターミナルに通知
# https://gitlab.freedesktop.org/Per_Bothner/specifications/-/blob/master/proposals/prompts-data/shell-integration.zsh
_prompt_executing=""
function __prompt_precmd() {
    local ret="$?"
    if test "$_prompt_executing" != "0"
    then
      _PROMPT_SAVE_PS1="$PS1"
      _PROMPT_SAVE_PS2="$PS2"
      PS1=$'%{\e]133;P;k=i\a%}'$PS1$'%{\e]133;B\a\e]122;> \a%}'
      PS2=$'%{\e]133;P;k=s\a%}'$PS2$'%{\e]133;B\a%}'
    fi
    if test "$_prompt_executing" != ""
    then
       printf "\033]133;D;%s;aid=%s\007" "$ret" "$$"
    fi
    printf "\033]133;A;cl=m;aid=%s\007" "$$"
    _prompt_executing=0
}
function __prompt_preexec() {
    PS1="$_PROMPT_SAVE_PS1"
    PS2="$_PROMPT_SAVE_PS2"
    printf "\033]133;C;\007"
    _prompt_executing=1
}
preexec_functions+=(__prompt_preexec)
precmd_functions+=(__prompt_precmd)

# mise
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

# zoxide
eval "$(zoxide init zsh)"

# git-wt
eval "$(git wt --init zsh)"

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

if [[ "$OS_NAME" == "Linux" ]]; then
    alias gcc='gcc-14 -fanalyzer'
fi

# ==================== #
#    Abbreviations     #
# ==================== #
_setup_abbr() {
    # apps
    abbr add -S --quieter -- -='cd -'
    if [[ "$OS_NAME" == "Linux" ]]; then
        abbr add -S --quieter inst='sudo apt install -y'
    fi
    abbr add -S --quieter m='make'
    abbr add -S --quieter c='code .'
    abbr add -S --quieter cur='cursor .'
    abbr add -S --quieter k='kubectl'
    abbr add -S --quieter lg='lazygit'
    abbr add -S --quieter tf='terraform'

    # git
    abbr add -S --quieter ga='git add -A'
    abbr add -S --quieter gc='git commit -m "%"'
    abbr add -S --quieter gp='git push'
    abbr add -S --quieter gpo='git push -u origin main'
    abbr add -S --quieter gpl='git pull'
    abbr add -S --quieter gb='git branch -a'
    abbr add -S --quieter gs='git status'
    abbr add -S --quieter gsw='git switch'
    abbr add -S --quieter gsm='git default'
    abbr add -S --quieter gd='git diff HEAD'
    abbr add -S --quieter gr='git reset --hard HEAD~'
    abbr add -S --quieter gsub='git submodule update --init --recursive'
    abbr add -S --quieter glog='git log --oneline --graph --decorate --all'

    # gh
    abbr add -S --quieter ghb='gh browse'
    abbr add -S --quieter clone='gh repo clone $(koeda)'

    # docker
    abbr add -S --quieter dcu='docker compose up --build'
}
_setup_abbr

# ==================== #
#      Functions       #
# ==================== #
for f in "$ZDOTDIR"/functions/*.zsh; do
    source "$f"
done

# ==================== #
#    Local Settings    #
# ==================== #
[[ -f "$ZDOTDIR/.zshrc.local" ]] && source "$ZDOTDIR/.zshrc.local"
