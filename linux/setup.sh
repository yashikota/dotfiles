#!/bin/bash

export TERM=xterm-256color
set -Eeuo pipefail

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$HOME"

# Color variables
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

function check_already_installed() {
    local app=$1
    if type -p "$app" >/dev/null; then
        echo "${CYAN}$app installation skipped${RESET}"
        return 0
    fi
    echo "${MAGENTA}$app not found, proceeding with installation...${RESET}"
    return 1
}

function package_installed() {
    local pkg="$1"
    dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed"
}

# install dependencies
function install_dependencies() {
    sudo apt update -qq
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        package_installed "$line" && { echo "${CYAN}$line is already installed${RESET}"; continue; }
        sudo apt install -qq -y "$line"
        echo "${YELLOW}$line installed.${RESET}"
    done < "${SCRIPT_DIR}/apps.txt"
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

# install a cargo binary if it's not already on PATH
function cargo_install_if_missing() {
    local bin="$1"
    local crate="${2:-$1}"
    check_already_installed "$bin" && return
    cargo install "$crate" --locked
}

# install other apps
function install_other_apps() {
    cargo_install_if_missing btm bottom
    cargo_install_if_missing delta git-delta
    cargo_install_if_missing zellij
    cargo_install_if_missing sheldon
    cargo_install_if_missing shpool
    if ! check_already_installed gibo; then
        go install github.com/simonwhitaker/gibo@latest
    fi
    if ! check_already_installed gomi; then
        curl -fsSL https://gomi.dev/install | bash
        sudo mv "$HOME/bin/gomi" /usr/local/bin/gomi
    fi
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
