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

## Optional: Transferring images to and from object storage

It is highly preferred to build the images on a separate VM then the vm which is running pebbles/notebooks.
For easier transfer, you could use cPouta object storage. 
In order to do that, first you need to create a container (If doesn't already exist) using the Openstack Horizon UI (Object Store -> Containers -> +Container) or use the command line.

To use the Swift API for object storage, install the python client.

        pip install python-swiftclient
        
Then, from the VM where the image exists, source the openrc.sh file (Can be obtained from Horizon UI)

        source openrc.sh
        
Next, try to upload the file to a container.

        swift upload <container-name> csc.pb-jupyter-ml.img
        
 After this, for quick download, make the container public using the UI (you can always make it private again)
 
 On the notebooks/pebbles VM -
 
        wget https://<container-name>.object.pouta.csc.fi/csc.pb-jupyter-ml.img

Alternatively, one could use the python swift client to download the file, if the container is kept private.

## SELinux labels

If the image was build somewhere else than the docker_host using it, then the SELinux labels need to be checked.

        ls -Z
        
If the labels do not match the labels of the other images running in production, then the label needs to be changed

        chcon -Rt <TYPE_TO_BE_CHECKED_FROM_OTHER_IMAGES> <FILE_NAME>


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

  
