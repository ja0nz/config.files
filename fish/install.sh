#!/usr/bin/env bash
SOURCE=_config.fish
TARGET=~/.config/fish

source $(readlink -f "$0" | rev | cut -d/ -f2- | rev)/../helpers.sh

DECRYPT $SOURCE

# Install OMF
test ! -d ~/.local/share/omf && curl -L https://get.oh-my.fish | fish

LINK $SOURCE $TARGET
