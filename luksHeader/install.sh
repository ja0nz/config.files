#!/usr/bin/env bash
SOURCE=_luksHeader

source $(readlink -f "$0" | xargs dirname)/../helpers.sh

DECRYPT $SOURCE

