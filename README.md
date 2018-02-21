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

## Use instructions for OpenShift driver

build_openshift.sh and build_and_upload_to_openshift.sh contain use cases in
the docs. jupyter-datascience and images building on that are so monstrous
that they need to be built outside OS for now.

When creating an OpenShift namespace for the images you *must* go to the
Docker Registry for that project and make it visible to either logged in users
or anonymous users. The default setting makes images available only to the
same namespace which doesn't work and will result in timeouts when starting a
new container.

The containers are defined by URLs so it's very easy to e.g. build into
namespace notebook-images-beta, test on a hidden blueprint and then build and
upload to a production namespace like notebook-images.

## Bootstrapping

The scripts in builds/scripts e.g.
[autodownload_and_start.sh](builds/scripts/jupyter/autodownload_and_start.sh)
support passing URLs that will be run with user priviledges. It's possible to
host this code wherever you want, but for convenience we have the files under
[bootstrap](./bootstrap) so that hosting, persistence and versioning is just a
pull-request away.

To execute the script you can set AUTODOWNLOAD_EXEC or AUTODOWNLOAD_EXEC_BG to
the filename to be run. The system doesn't immediately infer this from the
name. You should also be able to set both to split work to what must be done
before starting Jupyter and what can be done afterwards.


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

  
