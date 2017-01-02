# Pouta Blueprints Notebook image sources

This repository contains the Dockerfiles and relevant artefacts for building
images to use with the Docker driver of [Pouta
Blueprints](https://github.com/CSC-IT-Center-for-Science/pouta-blueprints) .

In the future the plan is that the Docker files will be used by the OpenShift
driver once it is stabilized.

## Use instructions for Docker driver

1. build images in builds/
2. extract images using

        docker save csc/pb-jupyter-ml > /var/lib/pb/docker_images/csc.pb-jupyter-ml.img

If you write them somewhere else and move it, SELinux labels may not be
created correctly and you get a very interesting behaviour to debug.

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

## Settings in Notebooks.csc.fi

### Jupyter notebooks

  internal port: 8888
  launch_command: /usr/local/bin/autodownload_and_start.sh --no-browser --port 8888 --ip=0.0.0.0 --NotebookApp.base_url=notebooks{proxy_path} --NotebookApp.allow_origin=*
  AUTODOWNLOAD_URL=http://example.com/my_script.sh

Proxy options
  
  [ ] Rewrite the proxy url
  [x] Set host header
  [ ] Redirect the proxy url

  
