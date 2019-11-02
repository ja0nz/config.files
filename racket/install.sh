#!/usr/bin/env bash
SOURCE=racket
TARGET=~/.racket

source $(readlink -f "$0" | rev | cut -d/ -f2- | rev)/../helpers.sh

LINK $SOURCE $TARGET
