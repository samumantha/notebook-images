#!/usr/bin/env bash

set -e

# set filter
filter=${1:-'*'}
# remove trailing .dockerfile from filter, if exists
filter=${filter%.dockerfile}

for dockerfile in $filter.dockerfile; do

    name=$(basename -s .dockerfile $dockerfile)
    echo
    echo "Building $name"

    if ! oc get imagestream $name > /dev/null; then
        echo "creating imagesteam"
        oc create imagestream $name
    fi
    if ! oc get buildconfig $name > /dev/null; then
        echo "creating buildconfig"
        sed -e "s/__NAME__/$name/g" build_config.yaml | oc create -f -
    fi

    echo "cancelling existing builds"
    oc cancel-build bc/$name
    echo "starting a new build"
    oc start-build $name --from-dir ..

done
