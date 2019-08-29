#!/usr/bin/env bash
# Put ssh related files into ~/.ssh
# Needs gpg keys!

# SSH Folder
FILE=_ssh
tar xzf <(gpg -d $FILE.tar.gz.gpg)

# Change ownership to user
chown -R $(whoami):$(whoami) $FILE

# Linking
TARGET=~
ln -sf $(pwd)/$FILE $TARGET/.ssh

