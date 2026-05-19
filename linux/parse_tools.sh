#!/bin/bash
# Parse tools.toml using only bash + awk (no Python, no jq).
#
# Usage:
#   parse_tools.sh names <file>          # one tool name per line
#   parse_tools.sh json  <file>          # JSON array of names (for CI matrix)
#   parse_tools.sh get   <file> <tool>   # key='value' lines (safe for eval)

set -euo pipefail

case "${1:-}" in
  names)
    awk '/^\[.+\]$/ { gsub(/[\[\]]/, ""); print }' "$2"
    ;;
  json)
    awk '
      BEGIN { printf "[" }
      /^\[.+\]$/ {
        gsub(/[\[\]]/, "")
        printf "%s\"%s\"", (n++ ? "," : ""), $0
      }
      END { print "]" }
    ' "$2"
    ;;
  get)
    awk -v tool="$3" '
      /^\[.+\]$/ { gsub(/[\[\]]/, ""); section = $0; next }
      section == tool && /^[[:space:]]*[a-z_]+[[:space:]]*=/ {
        key = $1
        match($0, /"[^"]*"/)
        val = substr($0, RSTART + 1, RLENGTH - 2)
        printf "%s=\047%s\047\n", key, val
      }
    ' "$2"
    ;;
  *)
    echo "Usage: $0 {names|json|get} <file> [tool]" >&2
    exit 1
    ;;
esac
