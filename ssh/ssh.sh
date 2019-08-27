#!/usr/bin/env bash
# Put ssh related files into ~/.ssh

# SSH Folder
FILE=ssh

# Change ownership to user
chown -R $(whoami):$(whoami) $FILE

# Linking
TARGET=~
ln -sf $(pwd)/$FILE $TARGET/.$FILE
