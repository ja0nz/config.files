#!/usr/bin/env bash
SOURCE=luksHeader

source $(readlink -f "$0" | rev | cut -d/ -f2- | rev)/../helpers.sh

DECRYPT $SOURCE

