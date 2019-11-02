#!/usr/bin/env bash
SOURCE=_ssh
TARGET=~/.ssh

source $(readlink -f "$0" | rev | cut -d/ -f2- | rev)/../helpers.sh

DECRYPT $SOURCE

LINK $SOURCE $TARGET
