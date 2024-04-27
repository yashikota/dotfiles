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
    type -p starship >/dev/null && { set_color cyan; echo "starship is already installed"; set_color reset; } && return
    curl -fsSL https://starship.rs/install.sh | sh
}

# install mise
function install_mise() {
    type -p mise >/dev/null && { set_color cyan; echo "mise is already installed"; set_color reset; } && return
    curl https://mise.run | sh
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
change_default_shell

# Done
{ set_color cyan; echo "Done!"; set_color reset; }
