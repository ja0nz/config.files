#!/usr/bin/env bash
SOURCE=_backup
source $(readlink -f "$0" | xargs dirname)/../helpers.sh

ENCRYPT $SOURCE
