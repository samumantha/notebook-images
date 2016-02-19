#!/bin/bash

if [ ! -z "$BOOTSTRAP_URL" ]; then
    su rstudio -c "wget $BOOTSTRAP_URL -O /home/rstudio/Examples.R"
fi
