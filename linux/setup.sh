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

function package_installed() {
    local pkg="$1"
    dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed"
}

# install apt dependencies from apps.txt
function install_dependencies() {
    sudo apt update -qq
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        package_installed "$line" && { echo "${CYAN}$line is already installed${RESET}"; continue; }
        sudo apt install -qq -y "$line"
        echo "${YELLOW}$line installed.${RESET}"
    done < "${SCRIPT_DIR}/apps.txt"
}

# install tools listed in tools.conf
function install_tools() {
    while IFS=$'\t' read -r type binary arg extra; do
        # skip comments and empty lines
        [[ -z "$type" || "$type" == \#* ]] && continue

        check_already_installed "$binary" && continue

        echo "${YELLOW}Installing $binary ($type)...${RESET}"
        case "$type" in
            curl)
                if [ -n "${extra:-}" ]; then
                    # shellcheck disable=SC2086
                    curl -fsSL "$arg" | sh $extra
                else
                    curl -fsSL "$arg" | sh
                fi
                ;;
            cargo)
                local crate="${arg:-$binary}"
                cargo install "$crate" --locked
                ;;
            go)
                go install "$arg"
                ;;
            script)
                bash "$REPO_DIR/$arg"
                ;;
        esac
        echo "${GREEN}$binary installed.${RESET}"
    done < "${SCRIPT_DIR}/tools.conf"
}

# generate EN_US.UTF-8 locale
function generate_locale() {
    sudo locale-gen en_US.UTF-8
}

# disable login message
function disable_login_message() {
    touch ~/.hushlogin
}

# main
generate_locale
install_dependencies
install_tools
disable_login_message

# Done
echo "${GREEN}Done!${RESET}"
