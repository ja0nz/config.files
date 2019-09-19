#!/usr/bin/env bash
# Put wpa_supplicant related conf files into /etc/wpa_supplicant
# Needs gpg keys!

# SSH Folder
FILE=_wpa_supplicant
sudo rm -rf $FILE
tar xzf <(gpg -d $FILE.tar.gz.gpg)

# Change group ownership to network group
sudo chown -R root:network $FILE

# Linking
TARGET=/etc
sudo ln -sfn $(pwd)/$FILE $TARGET/wpa_supplicant
