#!/usr/bin/env bash
# Repack wpa_supplicant files -> GPG 
# Needs gpg keys!

# Pack new wpa_supplicant archive
FILE=_wpa_supplicant.tar.gz
rm -rf $FILE.gpg
tar czf $FILE _wpa_supplicant
gpg -e --default-recipient-self $FILE
rm -rf $FILE

