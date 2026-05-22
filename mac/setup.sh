#!/bin/bash

export TERM=xterm-256color
set -Eeuo pipefail

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

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

# install dependencies from Brewfile (libraries & apps not available in aqua)
function install_dependencies() {
    echo "${MAGENTA}Installing dependencies from Brewfile...${RESET}"
    brew bundle --file="${SCRIPT_DIR}/Brewfile"
    echo "${YELLOW}Brewfile dependencies installed.${RESET}"
}

# install aqua packages (CLI tools managed declaratively)
function install_aqua_packages() {
    export AQUA_GLOBAL_CONFIG="$REPO_DIR/.config/aquaproj-aqua/aqua.yaml"
    aqua i -l -a
}

# main
install_homebrew
install_dependencies
install_aqua_packages

# Done
echo "${GREEN}Done!${RESET}"
