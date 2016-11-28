#!/usr/bin/env bash

# backwards compatibility to BOOTSTRAP_* -vars in existing blueprints
if [ ! -z "$BOOTSTRAP_URL" ]; then
    AUTODOWNLOAD_URL="$BOOTSTRAP_URL"
fi

if [ ! -z "$AUTODOWNLOAD_URL" ]; then
    if [ ! -z "$AUTODOWNLOAD_FILENAME" ]; then
        echo "Downloading $AUTODOWNLOAD_URL to $AUTODOWNLOAD_FILENAME"
        wget "$AUTODOWNLOAD_URL" -O "$AUTODOWNLOAD_FILENAME"
    else
        echo "Downloading $AUTODOWNLOAD_URL"
        wget "$AUTODOWNLOAD_URL"
    fi

    if [ ! -z "$AUTODOWNLOAD_EXEC" ]; then
        chmod u+x $AUTODOWNLOAD_EXEC
        ./$AUTODOWNLOAD_EXEC
    fi
fi

exec /usr/local/bin/start-notebook.sh $*
