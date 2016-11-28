#!/usr/bin/with-contenv bash

if [ ! -z "$AUTODOWNLOAD_URL" ]; then
    if [ ! -z "$AUTODOWNLOAD_FILENAME" ]; then
        echo "Downloading $AUTODOWNLOAD_URL to $AUTODOWNLOAD_FILENAME"
        su rstudio -c "cd /home/rstudio/ && wget '$AUTODOWNLOAD_URL' -O '$AUTODOWNLOAD_FILENAME'"
    else
        echo "Downloading $AUTODOWNLOAD_URL"
        su rstudio -c "cd /home/rstudio/ && wget '$AUTODOWNLOAD_URL'"
    fi
fi
