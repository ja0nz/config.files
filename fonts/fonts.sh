#!/usr/bin/env bash
# Link fonts to /usr/share/fonts folder
# Requires sudo!!!

TARGET=/usr/share/fonts
FONTS=(otf-operatormono otf-firacode ttf-iosevka)

for font in "${FONTS[@]}"
do
   sudo ln -sf $(pwd)/$font $TARGET
done
