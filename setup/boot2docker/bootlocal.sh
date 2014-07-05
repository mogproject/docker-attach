#!/bin/sh

SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd -P )
FILES=$SCRIPT_DIR/bootlocal.d/*

for file in $FILES; do
    if [ -x $file ]; then
        $file
    fi
done
