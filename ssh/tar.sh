#!/usr/bin/env bash
SOURCE=_ssh
source $(readlink -f "$0" | rev | cut -d/ -f2- | rev)/../helpers.sh

ENCRYPT $SOURCE
