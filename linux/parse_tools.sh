#!/bin/bash
# Parse tools.toml using only bash + awk (no Python, no jq).
#
# Usage:
#   parse_tools.sh names <file>                # one tool name per line
#   parse_tools.sh names <file> <type>         # names filtered by type
#   parse_tools.sh names <file> '!<type>'      # names excluding a type
#   parse_tools.sh json  <file>                # JSON array of names
#   parse_tools.sh json  <file> <type>         # JSON array filtered by type
#   parse_tools.sh json  <file> '!<type>'      # JSON array excluding a type
#   parse_tools.sh get   <file> <tool>         # key='value' lines (safe for eval)

set -euo pipefail

case "${1:-}" in
  names)
    if [ -n "${3:-}" ]; then
      negate=0; filter="${3}"
      [[ "$filter" == !* ]] && { negate=1; filter="${filter#!}"; }
      awk -v want="$filter" -v neg="$negate" '
        /^\[.+\]$/ { gsub(/[\[\]]/, ""); section = $0; next }
        /^[[:space:]]*type[[:space:]]*=/ {
          match($0, /"[^"]*"/)
          t = substr($0, RSTART + 1, RLENGTH - 2)
          if ((neg && t != want) || (!neg && t == want)) print section
        }
      ' "$2"
    else
      awk '/^\[.+\]$/ { gsub(/[\[\]]/, ""); print }' "$2"
    fi
    ;;
  json)
    if [ -n "${3:-}" ]; then
      negate=0; filter="${3}"
      [[ "$filter" == !* ]] && { negate=1; filter="${filter#!}"; }
      awk -v want="$filter" -v neg="$negate" '
        BEGIN { printf "[" }
        /^\[.+\]$/ { gsub(/[\[\]]/, ""); section = $0; next }
        /^[[:space:]]*type[[:space:]]*=/ {
          match($0, /"[^"]*"/)
          t = substr($0, RSTART + 1, RLENGTH - 2)
          if ((neg && t != want) || (!neg && t == want))
            printf "%s\"%s\"", (n++ ? "," : ""), section
        }
        END { print "]" }
      ' "$2"
    else
      awk '
        BEGIN { printf "[" }
        /^\[.+\]$/ {
          gsub(/[\[\]]/, "")
          printf "%s\"%s\"", (n++ ? "," : ""), $0
        }
        END { print "]" }
      ' "$2"
    fi
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
    echo "Usage: $0 {names|json|get} <file> [type|tool]" >&2
    exit 1
    ;;
esac
