#!/usr/bin/env bash
SOURCE=_ssh
source $(readlink -f "$0" | xargs dirname)/../helpers.sh

ENCRYPT $SOURCE
