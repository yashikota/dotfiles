#!/bin/bash

set -ue # exit on error or undefined variable

# install dependencies
function install_dependencies() {
    sudo apt-get update
    sudo apt-get install --no-install-recommends -y \
        curl \
        git \
        fish \
        zip \
        neovim \
        tmux \
        build-essential \
        pkg-config
}

# install rust
function install_rust() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

# install go
function install_go() {
    sudo add-apt-repository -y ppa:longsleep/golang-backports
    sudo apt-get update
    sudo apt-get install --no-install-recommends -y golang
}

# install github cli
function install_github_cli() {
    type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
}

# install starship
function install_starship() {
    curl -fsSL https://starship.rs/install.sh | bash
}

# install rtx
function install_rtx() {
    cargo install rtx-cli
}

# clone dotfiles
function clone_dotfiles() {
    git clone git@github.com:yashikota/dotfiles.git
}

# link dotfiles
function link_dotfiles() {
    cd dotfiles
    mkdir ~/.config

    # cloneしたdotfilesには.configというディレクトリがあるので、そこの中身を~/.configにシンボリックリンクを貼る
    for f in .config/*; do
        ln -svfn $(pwd)/$f ~/.config/
    done
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
clone_dotfiles
link_dotfiles
change_default_shell
