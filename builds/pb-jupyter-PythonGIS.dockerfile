FROM jupyter/datascience-notebook

MAINTAINER Samantha Wittke <samantha.wittke@csc.fi>

# Conda stuff below from https://github.com/csc-training/geocomputing/blob/master/rahti/notebooks/course_notebooks/autogis-course-part1/autogis-part2.dockerfile

WORKDIR /opt/app
USER 1000

### Installing the GIS libraries and jupyter lab extensions. Modify this and make sure the conda spell is working
# Conda packages from https://github.com/Automating-GIS-processes/site/blob/master/ci/py38-GIS.yaml
RUN echo "Upgrading conda" \
&& conda update --yes -n base conda  \
&& conda install --yes -c conda-forge -c patrikhlobil \
  python=3.8
  jupyterlab
  jupyterlab-git
  matplotlib
  geopandas
  geojson
  pysal
  mapclassify
  osmnx
  pyrosm
  geopy
  geojson
  rasterio
  contextily
  folium
  mplleaflet
  bokeh
  patrikhlobil::pandas-bokeh
  pip

RUN jupyter lab build

RUN conda clean -afy


# below from pb-jupyter-datascience.dockerfile

USER root

# OpenShift allocates the UID for the process, but GID is 0
# Based on an example by Graham Dumpleton
RUN chgrp -R root /home/$NB_USER \
    && find /home/$NB_USER -type d -exec chmod g+rwx,o+rx {} \; \
    && find /home/$NB_USER -type f -exec chmod g+rw {} \; \
    && chgrp -R root /opt/conda \
    && find /opt/conda -type d -exec chmod g+rwx,o+rx {} \; \
    && find /opt/conda -type f -exec chmod g+rw {} \;

RUN test -f /bin/env || ln -s /usr/bin/env /bin/env

ENV HOME /home/$NB_USER

COPY scripts/jupyter/autodownload_and_start.sh /usr/local/bin/autodownload_and_start.sh
RUN chmod a+x /usr/local/bin/autodownload_and_start.sh

RUN echo "ssh-client and less from apt" \
    && apt-get update \
    && apt-get install -y ssh-client less \
    && apt-get clean

# compatibility with old blueprints, remove when not needed
RUN ln -s /usr/local/bin/autodownload_and_start.sh /usr/local/bin/bootstrap_and_start.bash

USER $NB_USER

CMD ["/usr/local/bin/autodownload_and_start.sh"]
