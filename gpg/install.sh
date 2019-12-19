#!/usr/bin/env bash
SOURCE=_gpg

source $(readlink -f "$0" | xargs dirname)/../helpers.sh

DECRYPT $SOURCE

cd $SOURCE
awk '!/^#/' ownertrust.txt | while read line; do
        KEY=$(echo $line | cut -d: -f1 | tail -c 17)
	test -f $KEY.secret.key && gpg --import $KEY.secret.key
done
gpg --import-ownertrust ownertrust.txt
