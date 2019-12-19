#!/usr/bin/env bash
SOURCE=luksHeader
source $(readlink -f "$0" | xargs dirname)/../helpers.sh

ENCRYPT $SOURCE
