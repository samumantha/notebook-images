# Pouta Blueprints Notebook image branch

This repository contains the Dockerfiles and relevant artefacts for building
images to use with the Docker driver of [Pouta
Blueprints](https://github.com/CSC-IT-Center-for-Science/pouta-blueprints) .

In the future the plan is that the Docker files will be used by the OpenShift
driver once it is stabilized.

## Use instructions for Docker driver

1. build images
2. extract images using
        
        docker save csc/pb-jupyter-ml > csc.pb-jupyter-ml.img 

3. move images to /var/lib/pb/docker_images/ on the host
   running Pouta Blueprints


For more detailed descriptions see [Pouta
Blueprints](https://github.com/CSC-IT-Center-for-Science/pouta-blueprints)
documentation. (*ToDo: link to gh-pages doc when it's out*)


