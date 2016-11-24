#!/usr/bin/env bash

set -e

repository='csc'

if [ ! -z $1 ]; then
    filter=$1
else
    filter='*'
fi

for dockerfile in $filter.dockerfile; do

    name=$(basename -s .dockerfile $dockerfile)

    echo
    echo "Building $repository/$name"
    echo

    docker build -t "$repository/$name" -f "$dockerfile" .

done