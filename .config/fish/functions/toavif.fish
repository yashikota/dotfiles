function toavif
    argparse q/quality= -- $argv
    set quality 30

    if set -q _flag_q
        set quality $_flag_q
    end

    for img in $argv
        set img_out (string replace -r '\.\w+$' '.avif' -- $img)
        set img_in_short (basename "$img")
        set img_out_short (basename "$img_out")

        if test -e "$img_out"
            echo "UNEXPECTED ERROR: FILE '$img_out' EXISTS."
            continue
        end

        set size_in_B (stat -c %s "$img")
        set size_in (numfmt --to=iec $size_in_B)

        ffmpeg -hide_banner -y -loglevel error -i "$img" -c:v libsvtav1 -qp $quality -svtav1-params 'preset=0:fast-decode=1' "$img_out" \
            || ffmpeg -hide_banner -y -loglevel error -i "$img" -c:v libsvtav1 -qp $quality "$img_out" \
            || ffmpeg -hide_banner -y -loglevel error -i "$img" -vf "scale=ceil(iw/2)*2:ceil(ih/2)*2" -c:v libsvtav1 -qp $quality -svtav1-params 'preset=0:fast-decode=1' "$img_out" \
            || ffmpeg -hide_banner -y -loglevel error -i "$img" -vf "scale=ceil(iw/2)*2:ceil(ih/2)*2" -c:v libsvtav1 -qp $quality "$img_out" \
            || begin
                echo "ERROR: Failed to write '$img_out' - proceeding..."
                continue
            end

        if command -v exiftool > /dev/null
            exiftool -overwrite_original -tagsFromFile "$img" -FileModifyDate -FileCreateDate "$img_out"
        end

        set size_out_B (stat -c %s "$img_out")
        set size_out (numfmt --to=iec $size_out_B)
        set pct_diff (math "($size_out_B - $size_in_B) / $size_in_B * 100")

        set pct_color 'red'
        if test $size_out_B -le $size_in_B
            set pct_color 'green'
        end

        echo "Converted file:      '$img_in_short' -> '$img_out_short' ($img_out_short)"
        echo "AVIF Size Reduction: $size_in -> $size_out ($pct_diff% change)"
    end
end
