# if not exist, create directory
if [ ! -d ~/.config ]; then
  mkdir ~/.config
fi

# link
for f in .config/*; do
    ln -svfn $(pwd)/$f ~/.config/
done

# done
echo "\033[0;32mDone!\033[0m\n"
