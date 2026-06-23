function __clip_emit_osc52 -a encoded
    if set -q TMUX
        printf '\033Ptmux;\033\033]52;c;%s\a\033\\' "$encoded"
    else
        printf '\033]52;c;%s\a' "$encoded"
    end
end

function clip
    if not command -q base64
        echo "clip: base64 is required" >&2
        return 1
    end

    set -l encoded
    if test (count $argv) -eq 0
        set encoded (base64 | tr -d '\r\n')
    else
        set encoded (cat $argv | base64 | tr -d '\r\n')
    end

    __clip_emit_osc52 "$encoded"
end
