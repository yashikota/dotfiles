# dotfiles

## Setup

### Linux (Ubuntu/Debian)

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
    ```

4. Setup

   ```sh
   bash linux/setup.sh
   bash link.sh
   ```


5. Set ZDOTDIR

    ```sh
    ln -s ~/.config/zsh/.zshenv ~/.zshenv
    ```

6. Change Shell

    ```sh
    chsh -s /usr/bin/zsh
    ```

### macOS

1. Install GitHub CLI

    ```sh
    brew install gh
    ```

2. Login

    ```sh
    gh auth login
    ```

3. Clone repository

    ```sh
    gh repo clone yashikota/dotfiles
    cd dotfiles
    ```

4. Setup

   ```sh
   bash mac/setup.sh
   bash link.sh
   ```


5. Set ZDOTDIR

    ```sh
    ln -s ~/.config/zsh/.zshenv ~/.zshenv
    ```

6. Change Shell

    ```sh
    chsh -s /bin/zsh
    ```
