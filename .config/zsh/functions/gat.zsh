# ターミナルで画像を表示 (Sixel)
# Usage: gat <imagefile>
gat() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: gat <imagefile>"
        return 1
    fi

    local cols=$(tput cols)
    local width_px=$((cols * 10))

    img2sixel -w "${width_px}px" "$@"
}
