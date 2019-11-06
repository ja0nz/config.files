#!/usr/bin/env bash

FULL_PATH=$(readlink -f $1)
BASE=$(basename $FULL_PATH)
DIR=$(dirname $FULL_PATH)

if [[ $(file -b $FULL_PATH) == "directory" ]]; then
    # Make a dir
    echo -e "looping $FULL_PATH for PDF files and converting them with ocr layer"
    OCR_DIR=$DIR/$BASE.OCR.pdf
    mkdir -p $OCR_DIR
    echo -e "Writing generated PDFs to $OCR_DIR"
    cd $FULL_PATH
    for filename in ./*.pdf; do
        [ -e "$filename" ] || continue
        if [[ $(file -b --mime-type $filename) == "application/pdf" ]]; then
	    ocrmypdf -l deu $filename $OCR_DIR/$filename.pdf
        fi
    done
    echo -e "Finished"
    cd $OCR_DIR
    ls -halt
    exit 0
fi

if [[ $(file -b --mime-type $FULL_PATH) == "application/pdf" ]]; then
    echo -e "Converting file $FULL_PATH to ${BASE%.pdf}.OCR.pdf"
    ocrmypdf -l deu $FULL_PATH $DIR/${BASE%.pdf}.OCR.pdf
fi

