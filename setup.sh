#!/bin/bash

set -ue # exit on error or undefined variable
cd $HOME # move to home directory

# install dependencies
function install_dependencies() {
    sudo apt-get update
    cat apps.txt | while read line
    do
        type -p $line >/dev/null && echo "\e[36m$line is already installed\e[m" && continue
        sudo apt-get install --no-install-recommends -y $line
    done
}

# install rust
function install_rust() {
    type -p rustup >/dev/null && echo "\e[36mrustup is already installed\e[m" && return
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

# install go
function install_go() {
    type -p go >/dev/null && echo "\e[36mgo is already installed\e[m" && return
    sudo add-apt-repository -y ppa:longsleep/golang-backports
    sudo apt-get update
    sudo apt-get install --no-install-recommends -y golang
}

# install github cli
function install_github_cli() {
    type -p gh >/dev/null && echo "\e[36mgh is already installed\e[m" && return
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
}

# install starship
function install_starship() {
    type -p starship >/dev/null && echo "\e[36mstarship is already installed\e[m" && return
    curl -fsSL https://starship.rs/install.sh | sh
}

# install rtx
function install_rtx() {
    type -p rtx >/dev/null && echo "\e[36mrtx is already installed\e[m" && return
    cargo install rtx-cli
}

# install poetry
function install_poetry() {
    type -p poetry >/dev/null && echo "\e[36mpoetry is already installed\e[m" && return
    curl -sSL https://install.python-poetry.org | python3 -
}

# change default shell
function change_default_shell() {
    sudo chsh -s $(which fish) $USER
}

# main
install_dependencies
install_rust
install_go
install_github_cli
install_starship
install_rtx
install_poetry
change_default_shell

# Done
echo "\e[34mDone\e[m"
