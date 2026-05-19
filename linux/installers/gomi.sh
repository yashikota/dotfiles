#!/bin/bash
set -Eeuo pipefail

curl -fsSL https://gomi.dev/install | bash
sudo mv "$HOME/bin/gomi" /usr/local/bin/gomi
