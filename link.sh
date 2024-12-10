# if not exist, create directory
if [ ! -d ~/.config ]; then
  mkdir ~/.config
fi

# link
for f in .config/*; do
    ln -svfn $(pwd)/$f ~/.config/
done

# done
echo -ne "\033[0;36mDone!\033[0m\n"
