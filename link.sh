# if not exist, create directory
if [ ! -d ~/.config ]; then
  mkdir ~/.config
fi

# link
for f in .config/*; do
    target="$HOME/.config/$(basename "$f")"
    [ -e "$target" ] && rm -rf "$target"
    ln -svfn "$(pwd)/$f" "$target"
done

# done
echo -ne "\033[0;36mDone!\033[0m\n"
