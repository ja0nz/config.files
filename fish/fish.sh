#!/usr/bin/env bash
# Install OMF and link config.fish

# Fish Folder
FILE=config.fish

# Change ownership to user
chown $(whoami):$(whoami) $FILE

# Install OMF
test ! -d ~/.local/share/omf && curl -L https://get.oh-my.fish | fish

# Linking
TARGET=~/.config/fish
mkdir -p $TARGET

ln -sf $(pwd)/$FILE $TARGET/

