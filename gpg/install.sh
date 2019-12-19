#!/usr/bin/env bash
SOURCE=_gpg

source $(readlink -f "$0" | xargs dirname)/../helpers.sh

DECRYPT $SOURCE

cd $SOURCE
for file in *.sec.key; do
	gpg --import $file
done
for file in *.pub.key; do
	gpg --import $file
done
gpg --import-ownertrust ownertrust.txt

# Previously
#awk '!/^#/' ownertrust.txt | while read line; do
#        KEY=$(echo $line | cut -d: -f1 | tail -c 17)
#	test -f $KEY.secret.key && gpg --import $KEY.secret.key
#done
