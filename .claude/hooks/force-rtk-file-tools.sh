#!/usr/bin/env bash
set -euo pipefail

tool_name="$(jq -r '.tool_name // "tool"' 2>/dev/null || printf 'tool')"

case "$tool_name" in
    Read)
        hint="Use Bash with: rtk read <file>"
        ;;
    Grep)
        hint="Use Bash with: rtk grep <pattern> <path>, or rtk rg if you need ripgrep behavior."
        ;;
    Glob)
        hint="Use Bash with: rtk find <path> -name '<pattern>', or rtk rg --files <path>."
        ;;
    *)
        hint="Use Bash through rtk for file discovery and reading."
        ;;
esac

printf '%s is blocked because Claude Code built-in file tools bypass Bash hooks and RTK filtering. %s\n' "$tool_name" "$hint" >&2
exit 2
