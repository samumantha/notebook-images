#!/usr/bin/with-contenv bash

if [ ! -z "$BOOTSTRAP_URL" ]; then

    if [ ! -z "$BOOTSTRAP_FILENAME" ]; then
        su rstudio -c "wget '$BOOTSTRAP_URL' -O '$BOOTSTRAP_FILENAME'"
    else
        su rstudio -c "cd /home/rstudio/ && wget '$BOOTSTRAP_URL'"
    fi
fi
