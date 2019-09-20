#!/usr/bin/env bash
# Set default sound card. Check 
#    cat /proc/asound/cards
#    or
#    aplay -l
# first to get the soundcard and number

FILE=asound.conf

# Change group ownership to root
sudo chown -R root:root $FILE

# Linking
TARGET=/etc
sudo ln -sf $(pwd)/$FILE $TARGET/

