#!/usr/bin/env bash
SOURCE=racket
TARGET=~/.racket

source $(readlink -f "$0" | xargs dirname)/../helpers.sh

LINK $SOURCE $TARGET
