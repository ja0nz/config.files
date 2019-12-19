#!/usr/bin/env bash
SOURCE=kitty
TARGET=~/.config/kitty

source $(readlink -f "$0" | xargs dirname)/../helpers.sh

LINK $SOURCE $TARGET

