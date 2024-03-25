#!/bin/bash

set -ue # exit on error or undefined variable
cd $HOME

# set colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

function set_color() {
    local color=$1
    case "$color" in
        red) echo -ne "${RED}" ;;
        green) echo -ne "${GREEN}" ;;
        yellow) echo -ne "${YELLOW}" ;;
        cyan) echo -ne "${CYAN}" ;;
        *) echo -ne "${RESET}" ;;
    esac
}

# add repository
function add_repository() {
    cat "$HOME/dotfiles/repo.txt" | while read line
    do
        sudo add-apt-repository -y $line
    done
}

# install dependencies
function install_dependencies() {
    sudo apt-get update -qq
    cat "$HOME/dotfiles/apps.txt" | while read line
    do
        type -p $line >/dev/null && { set_color cyan; echo "$line is already installed"; set_color reset; } && continue
        sudo apt-get install --no-install-recommends -y -q=2 $line
        set_color yellow; echo "$line is installed"; set_color reset
    done
}

# generate EN_US.UTF-8 locale
function generate_locale() {
    sudo locale-gen en_US.UTF-8
}

# install rust
function install_rust() {
    type -p rustup >/dev/null && { set_color cyan; echo "rustup is already installed"; set_color reset; } && return
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

# install go
function install_go() {
    type -p go >/dev/null && { set_color cyan; echo "go is already installed"; set_color reset; } && return
    sudo add-apt-repository -y ppa:longsleep/golang-backports
    sudo apt-get update
    sudo apt-get install --no-install-recommends -y golang
}

# install github cli
function install_github_cli() {
    type -p gh >/dev/null && { set_color cyan; echo "gh is already installed"; set_color reset; } && return
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
}

# install starship
function install_starship() {
    type -p starship >/dev/null && { set_color cyan; echo "starship is already installed"; set_color reset; } && return
    curl -fsSL https://starship.rs/install.sh | sh
}

# install mise
function install_mise() {
    type -p mise >/dev/null && { set_color cyan; echo "mise is already installed"; set_color reset; } && return
    curl https://mise.run | sh
    echo '~/.local/bin/mise activate fish | source' >> ~/.config/fish/config.fish
}

# install poetry
function install_poetry() {
    type -p poetry >/dev/null && { set_color cyan; echo "poetry is already installed"; set_color reset; } && return
    curl -sSL https://install.python-poetry.org | python3 -
}

# change default shell
function change_default_shell() {
    sudo chsh -s $(which fish) $USER
}

# main
add_repository
generate_locale
install_dependencies
install_rust
install_go
install_github_cli
install_starship
install_mise
install_poetry
change_default_shell

# Done
{ set_color green; echo "Done!"; set_color reset; }
