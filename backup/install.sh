#!/usr/bin/env bash
SOURCE=_backup
TARGET=~/backups

source $(readlink -f "$0" | xargs dirname)/../helpers.sh

DECRYPT $SOURCE

LINK $SOURCE $TARGET
