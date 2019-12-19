#!/usr/bin/env bash
SOURCE=_gpg

source $(readlink -f "$0" | xargs dirname)/../helpers.sh

cd $SOURCE
gpg --list-secret-keys --with-colons 2> /dev/null | grep '^sec:' | cut -d: -f5 | while read line; do
	gpg -a --export $line > $line.public.key
	gpg -a --export-secret-keys $line > $line.secret.key
done
gpg --export-ownertrust > ownertrust.txt
cd ..

ENCRYPT $SOURCE
