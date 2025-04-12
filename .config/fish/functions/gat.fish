function gat
    if test (count $argv) -eq 0
        echo "Usage: gat <imagefile>"
        return 1
    end

    set cols (tput cols)
    set width_px (math "$cols * 10")

    img2sixel -w "$width_px"px $argv
end
