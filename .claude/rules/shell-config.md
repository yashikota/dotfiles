---
paths:
  - ".config/zsh/**"
  - ".config/fish/**"
---
Shell config files must maintain cross-shell parity where possible.
Zsh uses zsh-abbr for abbreviations (not aliases). Fish uses abbreviations natively.
Always check both shells when adding a new PATH export or environment variable.
When adding sheldon plugins for zsh, consider if fish needs an equivalent.
