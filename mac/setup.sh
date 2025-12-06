#!/bin/bash

set -ue # exit on error or undefined variable

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

# install homebrew
function install_homebrew() {
    check_already_installed brew && return
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# install dependencies
function install_dependencies() {
    cat "${SCRIPT_DIR}/apps.txt" | while read line
    do
        brew list $line &>/dev/null && { echo "${CYAN}$line is already installed${RESET}"; } && continue
        brew install $line
        echo "${YELLOW}$line installed.${RESET}"
    done
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

# install docker desktop
function install_docker() {
    if [ -d "/Applications/Docker.app" ]; then
        echo "${CYAN}Docker Desktop installation skipped${RESET}"
        return
    fi
    echo "${MAGENTA}Docker Desktop not found, proceeding with installation...${RESET}"
    brew install --cask docker
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

# install other apps
function install_other_apps() {
    cargo install bottom --locked
    cargo install git-delta --locked
    curl -fsSL https://gomi.dev/install | bash
    mv $HOME/bin/gomi /usr/local/bin/gomi
}

# disable login message
function disable_login_message() {
    touch ~/.hushlogin
}

# main
install_homebrew
install_dependencies
install_starship
install_mise
install_docker
install_rust
install_zoxide
install_other_apps
disable_login_message

# Done
echo "${GREEN}Done!${RESET}"
