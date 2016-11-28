# Pouta Blueprints Notebook image branch

This repository contains the Dockerfiles and relevant artefacts for building
images to use with the Docker driver of [Pouta
Blueprints](https://github.com/CSC-IT-Center-for-Science/pouta-blueprints) .

In the future the plan is that the Docker files will be used by the OpenShift
driver once it is stabilized.

## Use instructions for Docker driver

1. build images in buiilds/
2. extract images using
        
        docker save csc/pb-jupyter-ml > csc.pb-jupyter-ml.img 

3. move images to /var/lib/pb/docker_images/ on the host
   running Pouta Blueprints

## Bootstrapping

The scripts in builds/scripts e.g.
[autodownload_and_start.sh](builds/scripts/jupyter/autodownload_and_start.sh)
support passing URLs that will be run with user priviledges. It's possible to
host this code wherever you want, but for convenience we have the files under
[bootstrap](./bootstrap) so that hosting, persistence and versioning is just a
pull-request away.


For more detailed descriptions see [Pouta
Blueprints](https://github.com/CSC-IT-Center-for-Science/pouta-blueprints)
documentation. (*ToDo: link to gh-pages doc when it's out*)


