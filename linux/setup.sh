#!/bin/bash

export TERM=xterm-256color
set -Eeuo pipefail

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd $HOME

# Color variables
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

function check_already_installed() {
    local app=$1
    if type -p $app >/dev/null; then
        echo "${CYAN}$app installation skipped${RESET}"
        return 0
    fi
    echo "${MAGENTA}$app not found, proceeding with installation...${RESET}"
    return 1
}

# install dependencies
function install_dependencies() {
    sudo apt update -qq
    cat "${SCRIPT_DIR}/apps.txt" | while read line
    do
        type -p $line >/dev/null && { echo "${CYAN}$line is already installed${RESET}"; } && continue
        sudo apt install -qq -y $line
        echo "${YELLOW}$line installed.${RESET}"
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

# install tailscale
function install_tailscale() {
    check_already_installed tailscale && return
    curl -fsSL https://tailscale.com/install.sh | sh
    sudo tailscale up
}

# install docker
function install_docker() {
    check_already_installed docker && return
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get -y update
    sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

# install rust
function install_rust() {
    check_already_installed rustup && return
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --quiet
    . "$HOME/.cargo/env"
}

# install zoxide
function install_zoxide() {
    check_already_installed zoxide && return
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}

# install lazygit
function install_lazygit() {
    check_already_installed lazygit && return
    go install github.com/jesseduffield/lazygit@latest
}

# install other apps
function install_other_apps() {
    cargo install bottom --locked
    cargo install git-delta --locked
    cargo install zellij --locked
    cargo install sheldon --locked
    cargo install shpool --locked
    go install github.com/simonwhitaker/gibo@latest
    curl -fsSL https://gomi.dev/install | bash
    sudo mv $HOME/bin/gomi /usr/local/bin/gomi
}

# disable login message
function disable_login_message() {
    touch ~/.hushlogin
}

# main
generate_locale
install_dependencies
install_starship
install_mise
install_docker
install_rust
install_zoxide
install_lazygit
install_other_apps
disable_login_message

# Done
echo "${GREEN}Done!${RESET}"
