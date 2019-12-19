#!/usr/bin/env bash
SOURCE=_wpa_supplicant
source $(readlink -f "$0" | xargs dirname)/../helpers.sh

ENCRYPT $SOURCE
