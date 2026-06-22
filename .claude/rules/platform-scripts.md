---
paths:
  - "mac/**"
  - "linux/**"
---
Platform setup scripts must be idempotent — safe to re-run without side effects.
mac/setup.sh uses Homebrew (Brewfile). linux/setup.sh uses tools.toml (apt, curl, cargo, go, script).
When adding a tool to one platform, check if the other platform needs it too.
