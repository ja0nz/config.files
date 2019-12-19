#!/usr/bin/env bash
SOURCE=_config.fish
source $(readlink -f "$0" | xargs dirname)/../helpers.sh

ENCRYPT $SOURCE
