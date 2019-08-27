#!/usr/bin/env bash
# Link .emacs.d

# Personal Emacs Prelude folder
FILES=(personal prelude-pinned-packages.el)

# Install prelude
test ! -f ~/.emacs.d/README.md && curl -L https://git.io/epre | sh

# Remove existing prelude personal folder 
rm -rf ~/.emacs.d/personal

# Linking and chown
TARGET=~/.emacs.d

for file in "${FILES[@]}"
do
   chown -R $(whoami):$(whoami) $file
   sudo ln -sf $(pwd)/$file $TARGET/
done

echo "M-x package-install<ENTER> undo-tree"
echo "M-x package-install<ENTER> use-package"
echo "C-c I => set to org clock in"
