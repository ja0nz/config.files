#!/usr/bin/env bash
# Link kitty.conf

# Kitty Folder
FILE=kitty

# Change ownership to user
chown -R $(whoami):$(whoami) $FILE

# Linking
TARGET=~/.config
mkdir -p $TARGET

ln -sf $(pwd)/$FILE $TARGET/

