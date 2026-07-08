# VS Code Remote SSH shim for SSH sessions.
# Usage: code [path]
if [[ -z "${SSH_CONNECTION:-}${SSH_TTY:-}" && "${CODE_REMOTE_OPEN:-}" != "1" ]]; then
    return 0
fi

_code_remote_abs_path() {
    local target="${1:-.}"
    local resolved

    if command -v realpath >/dev/null 2>&1; then
        if resolved="$(realpath -m -- "$target" 2>/dev/null)"; then
            print -r -- "$resolved"
            return 0
        fi
        if resolved="$(realpath -- "$target" 2>/dev/null)"; then
            print -r -- "$resolved"
            return 0
        fi
    fi

    case "$target" in
        /*) print -r -- "$target" ;;
        *) print -r -- "$PWD/$target" ;;
    esac
}

code() {
    local target="${1:-.}"
    local abs
    local host
    local port="${REMOTE_OPEN_PORT:-${ZED_REMOTE_OPEN_PORT:-17342}}"
    local uri

    abs="$(_code_remote_abs_path "$target")" || return
    host="${CODE_SSH_HOST:-${ZED_SSH_HOST:-$(hostname -f 2>/dev/null || hostname)}}"
    uri="vscode-remote://ssh-remote+${host}${abs}"

    if command -v nc >/dev/null 2>&1; then
        if printf '%s\n' "$uri" | nc -N 127.0.0.1 "$port" >/dev/null 2>&1; then
            return 0
        fi
        if printf '%s\n' "$uri" | nc -w 1 127.0.0.1 "$port" >/dev/null 2>&1; then
            return 0
        fi
    fi

    print -r -- "Run locally:"
    print -r -- "code --folder-uri $uri"
}
