#!/usr/bin/env bash
# Put ssh related files into ~/.ssh
# Needs gpg keys!

# SSH Folder
FILE=_ssh
rm -rf $FILE
tar xzf <(gpg -d $FILE.tar.gz.gpg)

# Change ownership to user
chown -R $(whoami):$(whoami) $FILE

# Linking
TARGET=~
ln -sfn $(pwd)/$FILE $TARGET/.ssh
