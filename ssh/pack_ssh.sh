#!/usr/bin/env bash
# Repack ssh files -> GPG 
# Needs gpg keys!

# Pack new ssh archive
FILE=_ssh.tar.gz
rm -rf $FILE.gpg
tar czf $FILE _ssh
gpg -e --default-recipient-self $FILE
rm -rf $FILE

