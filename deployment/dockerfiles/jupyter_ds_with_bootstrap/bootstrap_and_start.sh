#!/bin/bash

if [ ! -z "$BOOTSTRAP_URL" ]; then
    wget $BOOTSTRAP_URL
    filename=$(basename $BOOTSTRAP_URL)
    case $filename in
        *.bash|*.sh)
            /usr/bin/bash $filename
        ;;
    esac
fi

exec /usr/local/bin/start-notebook.sh $*
