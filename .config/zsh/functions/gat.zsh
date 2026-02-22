# ターミナルで画像を表示 (Sixel)
# Usage: gat <imagefile>
gat() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: gat <imagefile>"
        return 1
    fi

    local cols=$(tput cols)
    local width_px=$((cols * 10))

    if command -v magick >/dev/null 2>&1; then
        local img
        for img in "$@"; do
            magick "$img" -auto-orient - | img2sixel -w "${width_px}px" -
        done
    elif command -v convert >/dev/null 2>&1; then
        local img
        for img in "$@"; do
            convert "$img" -auto-orient - | img2sixel -w "${width_px}px" -
        done
    else
        img2sixel -w "${width_px}px" "$@"
    fi
}
