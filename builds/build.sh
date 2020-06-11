#!/usr/bin/env bash

set -e

repository=${TAG_REPOSITORY:-'csc'}

# set filter
filter=${1:-'*'}
# remove trailing .dockerfile from filter, if exists
filter=${filter%.dockerfile}

for dockerfile in $filter.dockerfile; do

    name=$(basename -s .dockerfile $dockerfile)

    echo
    echo "Building $repository/$name"
    echo

    docker build -t "$repository/$name" -f "$dockerfile" $DOCKER_BUILD_OPTIONS .

done
