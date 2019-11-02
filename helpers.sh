#!/usr/bin/env bash
# Some aliases needed throughout the config.files repo

DECRYPT () {
    SRC=$(readlink -f "$1")
    su - jan -c "gpg -d $SRC.tar.gz.gpg | tar xz"
}

ENCRYPT () {
    SRC="$1"
    tar -czf - $SRC | gpg -e --default-recipient-self > $SRC.tar.gz.gpg
}

LINK () { 
    SRC=$(readlink -f "$1")
    DEST=$(readlink -f "$2")
    
    mkdir -p $DEST
    if [[ $(stat -c '%U' $DEST) != $(whoami) ]]; then
	echo "Please run as root - permissions not sufficient to set link"
	exit 1
    fi

    if test -d $DEST && test -d $SRC; then
	SRC=$SRC/*
    fi
    ln -sfn $SRC $DEST
}
