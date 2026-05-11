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

# install homebrew
function install_homebrew() {
    check_already_installed brew && return
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# install dependencies
function install_dependencies() {
    echo "${MAGENTA}Installing dependencies from Brewfile...${RESET}"
    brew bundle --file="${SCRIPT_DIR}/Brewfile"
    echo "${YELLOW}Brewfile dependencies installed.${RESET}"
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

# install zoxide
function install_zoxide() {
    check_already_installed zoxide && return
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
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
}

# main
install_homebrew
install_dependencies
install_starship
install_mise
install_zoxide
install_other_apps

# Done
echo "${GREEN}Done!${RESET}"
