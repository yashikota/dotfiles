---
paths:
  - "link.sh"
---
link.sh must always backup existing targets before creating symlinks.
Never use force-overwrite without backup. Test on both macOS and Linux.
New .config/ subdirectories are automatically handled — no manual entries needed.
