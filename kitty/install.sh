#!/usr/bin/env bash
SOURCE=kitty
TARGET=~/.config/kitty

source $(readlink -f "$0" | rev | cut -d/ -f2- | rev)/../helpers.sh

LINK $SOURCE $TARGET

