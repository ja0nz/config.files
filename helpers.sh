#!/usr/bin/env bash
# Some aliases needed throughout the config.files repo

DECRYPT () {
    SRC=$(readlink -f "$1")
    gpg -d $SRC.tar.gz.gpg | tar xz
}

ENCRYPT () {
    SRC="$1"
    tar -czf - $SRC | gpg -e --default-recipient-self > $SRC.tar.gz.gpg
}

LINK () {
    SRC=$(readlink -f "$1")
    DEST=$(readlink -f "$2")

    mkdir -p $DEST
    if test -d $DEST && test -d $SRC; then
        SRC=$SRC/*
    fi

    if [[ $(stat -c '%U' $DEST) != $(whoami) ]]; then
        echo "Not sufficient rights to set link in destination folder. Trying to 'sudo'"
        sudo ln -sfn $SRC $DEST
    else
        ln -sfn $SRC $DEST
    fi
}
