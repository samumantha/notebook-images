#!/usr/bin/env bash

# This is a script to build notebook image(s) locally and upload them to
# an OpenShift Registry. Here is an example session:

# export OSO_REGISTRY=docker-registry.oso.example.org
# export OSO_PROJECT=pebbles-images
# oc login https://oso.example.org:8443 -u user01
# oc project pebbles-images
# docker login -u ignored -p $(oc whoami -t) $OSO_REGISTRY
# ./build_and_upload_to_openshift.bash pb-jupyter-minimal

set -e

repository=${TAG_REPOSITORY:-'cscfi'}

if [ -z $OSO_REGISTRY ]; then
    echo
    echo  "set OSO_REGISTRY to point to the target OpenShift registry and try again"
    echo
    exit 1
fi

if [ -z $OSO_PROJECT ]; then
    echo
    echo  "set OSO_PROJECT to set the OpenShift project name and try again"
    echo
    exit 1
fi

oso_registry_base="$OSO_REGISTRY/$OSO_PROJECT"

filter=${1:-'*'}

for dockerfile in $filter.dockerfile; do

    name=$(basename -s .dockerfile $dockerfile)

    echo
    echo "Building $repository/$name"
    echo

    docker build -t "$repository/$name" -f "$dockerfile" $DOCKER_BUILD_OPTIONS .

    docker tag "$repository/$name" "$oso_registry_base/$name"

    docker push "$oso_registry_base/$name"
done
