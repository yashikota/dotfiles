# dotfiles

## setup

1. Install GitHub CLI

    See <https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian-ubuntu-linux-raspberry-pi-os-apt>  

2. Login

    ```sh
    gh auth login
    ```

3. Clone repository
    
    ```sh
    gh repo clone yashikota/dotfiles
    cd dotfiles
    bash setup.sh
    bash link.sh
    ```

## link

```sh
sh link.sh
```

## env

- Ubuntu 24.04
- fish
- Neovim
