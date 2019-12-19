#!/usr/bin/env bash
# Set default sound card. Check
#    cat /proc/asound/cards
#    or
#    aplay -l
# first to get the soundcard and number

SOURCE=asound.conf
TARGET=/etc

source $(readlink -f "$0" | xargs dirname)/../helpers.sh

LINK $SOURCE $TARGET

echo "In order to save a default volume setting, run: sudo alsactl store"
# Or non root: https://askubuntu.com/questions/50067/howto-save-alsamixer-settings
