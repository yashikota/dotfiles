#!/bin/bash

set -ue # exit on error or undefined variable
cd $HOME

# set colors
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

function set_color() {
    local color=$1
    case "$color" in
        yellow) echo -ne "${YELLOW}" ;;
        cyan) echo -ne "${CYAN}" ;;
        *) echo -ne "${RESET}" ;;
    esac
}

function check_already_installed() {
    local app=$1
    if type -p $app >/dev/null; then
        set_color cyan; echo "$app is already installed"; set_color reset
        return 0
    fi
    return 1
}

# install dependencies
function install_dependencies() {
    sudo apt update -qq
    cat "$HOME/dotfiles/apps.txt" | while read line
    do
        type -p $line >/dev/null && { set_color cyan; echo "$line is already installed"; set_color reset; } && continue
        sudo apt install -qq -y $line
        set_color yellow; echo "$line is installed"; set_color reset
    done
}

# generate EN_US.UTF-8 locale
function generate_locale() {
    sudo locale-gen en_US.UTF-8
}

# install starship
function install_starship() {
    check_already_installed starship && return
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y
}

# install mise
function install_mise() {
    check_already_installed mise && return
    curl https://mise.run | sh
}

# install docker
function install_docker() {
    check_already_installed docker && return
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    set_color yellow; echo "docker is installed"; set_color reset
}

# install rust
function install_rust() {
    check_already_installed rustup && return
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --quiet
}

# install zoxide
function install_zoxide() {
    check_already_installed zoxide && return
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}

# install go apps
function install_go_apps() {
    check_already_installed gtrash && return
    go install github.com/umlx5h/gtrash@latest
}

# install rust apps
function install_rust_apps() {
    check_already_installed delta && return
    cargo install --quiet git-delta
}

# change default shell
function change_default_shell() {
    sudo chsh -s $(which fish)
}

# main
generate_locale
install_dependencies
install_starship
install_mise
install_docker
install_rust
install_zoxide
install_go_apps
install_rust_apps
change_default_shell

# Done
{ set_color cyan; echo "Done!"; set_color reset; }
