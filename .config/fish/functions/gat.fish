function gat
    if test (count $argv) -eq 0
        echo "Usage: gat <imagefile>"
        return 1
    end

    set cols (tput cols)
    set width_px (math "$cols * 10")

    if command -v magick >/dev/null 2>&1
        for img in $argv
            magick "$img" -auto-orient - | img2sixel -w "$width_px"px -
        end
    else if command -v convert >/dev/null 2>&1
        for img in $argv
            convert "$img" -auto-orient - | img2sixel -w "$width_px"px -
        end
    else
        img2sixel -w "$width_px"px $argv
    end
end
