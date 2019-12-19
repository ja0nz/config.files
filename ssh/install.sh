#!/usr/bin/env bash
SOURCE=_ssh
TARGET=~/.ssh

source $(readlink -f "$0" | xargs dirname)/../helpers.sh

DECRYPT $SOURCE

LINK $SOURCE $TARGET
