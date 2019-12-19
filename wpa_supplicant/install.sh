#!/usr/bin/env bash
SOURCE=_wpa_supplicant
TARGET=/etc/wpa_supplicant

source $(readlink -f "$0" | xargs dirname)/../helpers.sh

DECRYPT $SOURCE

# Change group ownership to network group
# Not needed for single user
# sudo chown -R root:network $FILE

LINK $SOURCE $TARGET
